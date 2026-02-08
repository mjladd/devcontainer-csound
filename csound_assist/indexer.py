"""
Csound corpus indexer using ChromaDB with Ollama embeddings.

Provides document indexing and hybrid retrieval for RAG. Supports indexing
markdown docs, CSD files, and JSONL training pairs.
"""

import hashlib
import json
import logging
from pathlib import Path

try:
    import chromadb
    from chromadb.config import Settings
    HAS_CHROMADB = True
except ImportError:
    HAS_CHROMADB = False

from csound_assist.chunker import (
    Chunk,
    chunk_csound_code,
    chunk_jsonl_entry,
    chunk_markdown_document,
)
from csound_assist.embeddings import OllamaEmbeddingFunction, DEFAULT_EMBEDDING_MODEL
from csound_assist.retriever import HybridRetriever

logger = logging.getLogger(__name__)


class CsoundIndexer:
    """
    Indexes Csound documentation for RAG retrieval.

    Uses ChromaDB for vector storage and Ollama nomic-embed-text for embeddings.
    Supports hybrid search via BM25 + semantic retrieval.
    """

    COLLECTION_NAME = "csound_corpus"

    def __init__(
        self,
        db_path: Path | None = None,
        embedding_model: str = DEFAULT_EMBEDDING_MODEL,
        ollama_url: str = "http://d01.consul:3000",
    ):
        if not HAS_CHROMADB:
            raise ImportError(
                "chromadb is required. Install with: pip install chromadb"
            )

        self.db_path = db_path or Path(".cache/csound_assist_db")
        self.db_path.mkdir(parents=True, exist_ok=True)

        # Initialize ChromaDB
        self.client = chromadb.PersistentClient(
            path=str(self.db_path),
            settings=Settings(anonymized_telemetry=False),
        )

        # Initialize embedding function
        self.embedding_fn = OllamaEmbeddingFunction(
            model=embedding_model,
            ollama_url=ollama_url,
        )

        # Get or create collection with metadata validation
        self.collection = self._get_or_create_collection(embedding_model)

        # Hybrid retriever (lazy-initialized)
        self._retriever: HybridRetriever | None = None

    def _get_or_create_collection(self, embedding_model: str):
        """Get or create collection, checking for embedding model mismatch."""
        try:
            collection = self.client.get_collection(name=self.COLLECTION_NAME)
            stored_model = collection.metadata.get("embedding_model", "")
            if stored_model and stored_model != embedding_model:
                logger.warning(
                    "Embedding model mismatch: index uses '%s' but configured for '%s'. "
                    "Run with --reset to rebuild the index.",
                    stored_model,
                    embedding_model,
                )
            return collection
        except Exception:
            return self.client.create_collection(
                name=self.COLLECTION_NAME,
                metadata={"embedding_model": embedding_model},
            )

    @property
    def retriever(self) -> HybridRetriever:
        """Get or create the hybrid retriever."""
        if self._retriever is None:
            self._retriever = HybridRetriever(
                collection=self.collection,
                embedding_fn=self.embedding_fn,
            )
        return self._retriever

    def get_stats(self) -> dict:
        """Get index statistics."""
        count = self.collection.count()
        return {
            "indexed": count > 0,
            "chunks": count,
            "db_path": str(self.db_path),
            "embedding_model": self.embedding_fn.model_name,
            "bm25_available": self.retriever.bm25_available,
            "bm25_docs": self.retriever.bm25_doc_count,
        }

    def reset(self):
        """Delete all indexed documents and recreate collection."""
        self.client.delete_collection(self.COLLECTION_NAME)
        self.collection = self.client.create_collection(
            name=self.COLLECTION_NAME,
            metadata={"embedding_model": self.embedding_fn.model_name},
        )
        self._retriever = None

    def index_document(self, path: Path, force: bool = False) -> int:
        """
        Index a single document.

        Returns number of chunks indexed.
        """
        suffix = path.suffix.lower()

        try:
            content = path.read_text(encoding="utf-8", errors="replace")
        except Exception as e:
            logger.error("Error reading %s: %s", path, e)
            return 0

        source_path = str(path)

        # Check if already indexed
        if not force:
            existing = self.collection.get(
                where={"source": source_path},
                limit=1,
            )
            if existing and existing["ids"]:
                return 0

        # Chunk based on file type
        if suffix == ".md":
            chunks = chunk_markdown_document(content, source_path)
        elif suffix in (".csd", ".orc", ".sco"):
            chunks = chunk_csound_code(content, source_path)
        else:
            chunks = [Chunk(
                content=content,
                metadata={"source": source_path},
                chunk_id=f"{source_path}::full",
            )]

        return self._add_chunks(chunks)

    def index_jsonl_file(self, path: Path, force: bool = False) -> int:
        """
        Index a JSONL training data file.

        Each line should be a JSON object with 'instruction' and 'output' fields.
        Returns number of chunks indexed.
        """
        source_path = str(path)

        if not force:
            existing = self.collection.get(
                where={"source": source_path},
                limit=1,
            )
            if existing and existing["ids"]:
                return 0

        try:
            content = path.read_text(encoding="utf-8", errors="replace")
        except Exception as e:
            logger.error("Error reading %s: %s", path, e)
            return 0

        chunks: list[Chunk] = []
        for idx, line in enumerate(content.strip().split("\n")):
            line = line.strip()
            if not line:
                continue
            try:
                entry = json.loads(line)
            except json.JSONDecodeError:
                continue

            instruction = entry.get("instruction", "")
            output = entry.get("output", "")
            if not output:
                continue

            chunk = chunk_jsonl_entry(instruction, output, source_path, idx)
            chunks.append(chunk)

        return self._add_chunks(chunks)

    def _add_chunks(self, chunks: list[Chunk]) -> int:
        """Add chunks to ChromaDB with embeddings."""
        if not chunks:
            return 0

        # Process in batches to avoid memory issues
        batch_size = 50
        total_added = 0

        for i in range(0, len(chunks), batch_size):
            batch = chunks[i:i + batch_size]
            texts = [c.content for c in batch]

            try:
                embeddings = self.embedding_fn.embed_documents(texts)
            except Exception as e:
                logger.error("Embedding error for batch %d: %s", i // batch_size, e)
                continue

            ids = [c.chunk_id for c in batch]
            metadatas = [c.metadata for c in batch]

            try:
                self.collection.add(
                    ids=ids,
                    embeddings=embeddings,
                    documents=texts,
                    metadatas=metadatas,
                )
                total_added += len(batch)
            except Exception as e:
                logger.error("ChromaDB add error: %s", e)

        return total_added

    def index_corpus(
        self,
        corpus_dir: Path,
        reset: bool = False,
        extensions: list[str] | None = None,
    ) -> dict:
        """
        Index all documents in a corpus directory.

        Args:
            corpus_dir: Directory containing documents
            reset: If True, clear existing index first
            extensions: File extensions to index (default: [".md"])

        Returns:
            Statistics about the indexing process
        """
        if reset:
            self.reset()

        if extensions is None:
            extensions = [".md"]

        files = []
        for ext in extensions:
            files.extend(corpus_dir.rglob(f"*{ext}"))

        stats = {
            "documents": 0,
            "chunks": 0,
            "errors": 0,
            "skipped": 0,
            "sources": set(),
        }

        for path in sorted(files):
            try:
                chunks_added = self.index_document(path)
                if chunks_added > 0:
                    stats["documents"] += 1
                    stats["chunks"] += chunks_added
                    stats["sources"].add(path.parent.name)
                else:
                    stats["skipped"] += 1
            except Exception as e:
                logger.error("Error indexing %s: %s", path, e)
                stats["errors"] += 1

        stats["sources"] = list(stats["sources"])
        return stats

    def index_all(
        self,
        corpus_dir: Path | None = None,
        examples_dir: Path | None = None,
        training_dir: Path | None = None,
        reset: bool = False,
        skip_csd: bool = False,
        progress_callback=None,
    ) -> dict:
        """
        Index all content: corpus markdown, CSD examples, JSONL training data.

        Args:
            corpus_dir: Markdown corpus directory (default: ./corpus)
            examples_dir: CSD examples directory (default: ./csound_score_examples)
            training_dir: JSONL training data (default: ./csound_corpus)
            reset: Clear and rebuild index
            skip_csd: Skip CSD file indexing
            progress_callback: Called with (phase, current, total) for progress reporting

        Returns:
            Combined statistics
        """
        if reset:
            self.reset()

        corpus_dir = corpus_dir or Path("corpus")
        examples_dir = examples_dir or Path("csound_score_examples")
        training_dir = training_dir or Path("csound_corpus")

        stats = {
            "markdown_docs": 0,
            "markdown_chunks": 0,
            "csd_docs": 0,
            "csd_chunks": 0,
            "jsonl_files": 0,
            "jsonl_chunks": 0,
            "errors": 0,
            "skipped": 0,
        }

        # Phase 1: Markdown corpus
        if corpus_dir.exists():
            md_files = sorted(corpus_dir.rglob("*.md"))
            for idx, path in enumerate(md_files):
                if progress_callback:
                    progress_callback("markdown", idx + 1, len(md_files))
                try:
                    added = self.index_document(path)
                    if added > 0:
                        stats["markdown_docs"] += 1
                        stats["markdown_chunks"] += added
                    else:
                        stats["skipped"] += 1
                except Exception as e:
                    logger.error("Error indexing %s: %s", path, e)
                    stats["errors"] += 1

        # Phase 2: CSD examples
        if not skip_csd and examples_dir.exists():
            csd_files = sorted(examples_dir.rglob("*.csd"))
            for idx, path in enumerate(csd_files):
                if progress_callback:
                    progress_callback("csd", idx + 1, len(csd_files))
                try:
                    added = self.index_document(path)
                    if added > 0:
                        stats["csd_docs"] += 1
                        stats["csd_chunks"] += added
                    else:
                        stats["skipped"] += 1
                except Exception as e:
                    logger.error("Error indexing %s: %s", path, e)
                    stats["errors"] += 1

        # Phase 3: JSONL training data
        if training_dir.exists():
            jsonl_files = sorted(training_dir.rglob("*.jsonl"))
            for idx, path in enumerate(jsonl_files):
                if progress_callback:
                    progress_callback("jsonl", idx + 1, len(jsonl_files))
                try:
                    added = self.index_jsonl_file(path)
                    if added > 0:
                        stats["jsonl_files"] += 1
                        stats["jsonl_chunks"] += added
                    else:
                        stats["skipped"] += 1
                except Exception as e:
                    logger.error("Error indexing %s: %s", path, e)
                    stats["errors"] += 1

        # Phase 4: Build BM25 index
        if progress_callback:
            progress_callback("bm25", 0, 1)
        self.retriever.build_bm25_index()
        if progress_callback:
            progress_callback("bm25", 1, 1)

        return stats

    def search(
        self,
        query: str,
        n_results: int = 5,
    ) -> list[dict]:
        """Search using hybrid retrieval."""
        return self.retriever.search(query, n_results=n_results)

    def get_relevant_context(
        self,
        query: str,
        max_tokens: int = 3000,
        n_results: int = 10,
    ) -> str:
        """Get relevant context for a query, formatted for LLM consumption."""
        return self.retriever.get_relevant_context(
            query, max_tokens=max_tokens, n_results=n_results,
        )
