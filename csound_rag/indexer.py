"""
Corpus indexer for Csound RAG Assistant.

Processes markdown files from the corpus, chunks them intelligently,
and stores them in ChromaDB with embeddings.
"""

import re
import yaml
from pathlib import Path
from typing import Iterator

import chromadb
from chromadb.config import Settings
from sentence_transformers import SentenceTransformer


class CsoundIndexer:
    """Indexes Csound corpus into ChromaDB."""

    EMBEDDING_MODEL = "all-MiniLM-L6-v2"
    COLLECTION_NAME = "csound_corpus"
    MAX_CHUNK_SIZE = 1500  # characters, roughly 300-400 tokens

    def __init__(self, db_path: str | Path):
        """Initialize indexer with database path."""
        self.db_path = Path(db_path)
        self.db_path.mkdir(parents=True, exist_ok=True)

        self.client = chromadb.PersistentClient(
            path=str(self.db_path),
            settings=Settings(anonymized_telemetry=False),
        )
        self.embedding_model = SentenceTransformer(self.EMBEDDING_MODEL)

    def get_or_create_collection(self):
        """Get or create the ChromaDB collection."""
        return self.client.get_or_create_collection(
            name=self.COLLECTION_NAME,
            metadata={"description": "Csound programming corpus"},
        )

    def reset_collection(self):
        """Delete and recreate the collection."""
        try:
            self.client.delete_collection(self.COLLECTION_NAME)
        except Exception:
            pass  # Collection may not exist
        return self.get_or_create_collection()

    def load_corpus(self, corpus_dir: Path) -> Iterator[dict]:
        """
        Walk corpus directory and yield documents with metadata.

        Yields:
            dict with keys: content, source, title, path
        """
        corpus_dir = Path(corpus_dir)

        for md_file in corpus_dir.rglob("*.md"):
            # Skip index files
            if md_file.name.lower() in ("index.md", "readme.md"):
                continue

            try:
                content = md_file.read_text(encoding="utf-8", errors="replace")
            except Exception as e:
                print(f"  Warning: Could not read {md_file}: {e}")
                continue

            # Skip very short files
            if len(content) < 100:
                continue

            # Extract metadata from YAML front matter
            metadata = self._extract_front_matter(content)
            content_body = self._remove_front_matter(content)

            # Determine source from path
            rel_path = md_file.relative_to(corpus_dir)
            source = rel_path.parts[0] if rel_path.parts else "unknown"

            yield {
                "content": content_body,
                "source": source,
                "title": metadata.get("title", md_file.stem),
                "path": str(rel_path),
                "metadata": metadata,
            }

    def _extract_front_matter(self, content: str) -> dict:
        """Extract YAML front matter from markdown content."""
        if not content.startswith("---"):
            return {}

        try:
            end_idx = content.index("---", 3)
            yaml_content = content[3:end_idx].strip()
            return yaml.safe_load(yaml_content) or {}
        except (ValueError, yaml.YAMLError):
            return {}

    def _remove_front_matter(self, content: str) -> str:
        """Remove YAML front matter from markdown content."""
        if not content.startswith("---"):
            return content

        try:
            end_idx = content.index("---", 3)
            return content[end_idx + 3:].strip()
        except ValueError:
            return content

    def chunk_document(self, doc: dict) -> list[dict]:
        """
        Split document into chunks for embedding.

        Strategy:
        - Split on markdown headers (##, ###)
        - Keep code blocks intact
        - Respect max chunk size
        """
        content = doc["content"]
        chunks = []

        # Split on headers while preserving them
        sections = self._split_on_headers(content)

        for section_title, section_content in sections:
            # If section is small enough, keep as one chunk
            if len(section_content) <= self.MAX_CHUNK_SIZE:
                chunks.append({
                    "text": section_content,
                    "section": section_title,
                    "source": doc["source"],
                    "title": doc["title"],
                    "path": doc["path"],
                    "has_code": "```" in section_content or "<CsoundSynthesizer>" in section_content,
                })
            else:
                # Split large sections, preserving code blocks
                sub_chunks = self._split_large_section(section_content)
                for i, sub_chunk in enumerate(sub_chunks):
                    chunks.append({
                        "text": sub_chunk,
                        "section": f"{section_title} (part {i+1})" if len(sub_chunks) > 1 else section_title,
                        "source": doc["source"],
                        "title": doc["title"],
                        "path": doc["path"],
                        "has_code": "```" in sub_chunk or "<CsoundSynthesizer>" in sub_chunk,
                    })

        return chunks

    def _split_on_headers(self, content: str) -> list[tuple[str, str]]:
        """Split content on markdown headers, returning (title, content) pairs."""
        # Pattern matches ## or ### headers
        pattern = r'^(#{2,3})\s+(.+?)$'

        sections = []
        current_title = "Introduction"
        current_content = []

        for line in content.split('\n'):
            header_match = re.match(pattern, line)
            if header_match:
                # Save previous section
                if current_content:
                    sections.append((current_title, '\n'.join(current_content).strip()))
                current_title = header_match.group(2).strip()
                current_content = [line]
            else:
                current_content.append(line)

        # Save final section
        if current_content:
            sections.append((current_title, '\n'.join(current_content).strip()))

        return sections

    def _split_large_section(self, content: str) -> list[str]:
        """Split a large section while preserving code blocks."""
        chunks = []
        current_chunk = []
        current_size = 0
        in_code_block = False
        code_block_content = []

        for line in content.split('\n'):
            # Track code blocks
            if line.strip().startswith('```') or '<CsoundSynthesizer>' in line:
                if not in_code_block:
                    in_code_block = True
                    code_block_content = [line]
                else:
                    code_block_content.append(line)
                    in_code_block = False
                    # Add complete code block
                    block = '\n'.join(code_block_content)
                    if current_size + len(block) > self.MAX_CHUNK_SIZE and current_chunk:
                        chunks.append('\n'.join(current_chunk))
                        current_chunk = [block]
                        current_size = len(block)
                    else:
                        current_chunk.append(block)
                        current_size += len(block)
                    code_block_content = []
                continue

            if in_code_block:
                code_block_content.append(line)
                continue

            # Handle end of CSD files
            if '</CsoundSynthesizer>' in line:
                if code_block_content:
                    code_block_content.append(line)
                    block = '\n'.join(code_block_content)
                    current_chunk.append(block)
                    current_size += len(block)
                    code_block_content = []
                    in_code_block = False
                continue

            # Regular line
            if current_size + len(line) > self.MAX_CHUNK_SIZE and current_chunk:
                chunks.append('\n'.join(current_chunk))
                current_chunk = [line]
                current_size = len(line)
            else:
                current_chunk.append(line)
                current_size += len(line) + 1

        # Add remaining content
        if current_chunk:
            chunks.append('\n'.join(current_chunk))

        return chunks if chunks else [content]

    def index_corpus(self, corpus_dir: Path, reset: bool = False) -> dict:
        """
        Index entire corpus into ChromaDB.

        Args:
            corpus_dir: Path to corpus directory
            reset: If True, delete existing index first

        Returns:
            dict with indexing statistics
        """
        corpus_dir = Path(corpus_dir)

        if reset:
            collection = self.reset_collection()
        else:
            collection = self.get_or_create_collection()

        stats = {
            "documents": 0,
            "chunks": 0,
            "sources": set(),
        }

        all_chunks = []
        all_ids = []
        all_metadatas = []

        print(f"Loading corpus from {corpus_dir}...")

        for doc in self.load_corpus(corpus_dir):
            stats["documents"] += 1
            stats["sources"].add(doc["source"])

            chunks = self.chunk_document(doc)

            for i, chunk in enumerate(chunks):
                chunk_id = f"{doc['path']}#{i}"
                all_chunks.append(chunk["text"])
                all_ids.append(chunk_id)
                all_metadatas.append({
                    "source": chunk["source"],
                    "title": chunk["title"],
                    "section": chunk["section"],
                    "path": chunk["path"],
                    "has_code": chunk["has_code"],
                })
                stats["chunks"] += 1

            if stats["documents"] % 50 == 0:
                print(f"  Processed {stats['documents']} documents, {stats['chunks']} chunks...")

        if not all_chunks:
            print("No documents found to index.")
            return stats

        print(f"Embedding {len(all_chunks)} chunks...")
        embeddings = self.embedding_model.encode(
            all_chunks,
            show_progress_bar=True,
            convert_to_numpy=True,
        )

        print("Adding to ChromaDB...")
        # Add in batches to avoid memory issues
        batch_size = 500
        for i in range(0, len(all_chunks), batch_size):
            end = min(i + batch_size, len(all_chunks))
            collection.add(
                ids=all_ids[i:end],
                documents=all_chunks[i:end],
                embeddings=embeddings[i:end].tolist(),
                metadatas=all_metadatas[i:end],
            )

        stats["sources"] = list(stats["sources"])
        print(f"Indexed {stats['documents']} documents into {stats['chunks']} chunks")
        return stats

    def get_stats(self) -> dict:
        """Get statistics about the current index."""
        try:
            collection = self.client.get_collection(self.COLLECTION_NAME)
            count = collection.count()
            return {
                "indexed": True,
                "chunks": count,
                "db_path": str(self.db_path),
            }
        except Exception:
            return {
                "indexed": False,
                "chunks": 0,
                "db_path": str(self.db_path),
            }
