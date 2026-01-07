"""
Retriever for Csound RAG Assistant.

Searches ChromaDB for relevant chunks based on user queries.
"""

from pathlib import Path
from dataclasses import dataclass

import chromadb
from chromadb.config import Settings
from sentence_transformers import SentenceTransformer


@dataclass
class SearchResult:
    """A single search result."""
    text: str
    source: str
    title: str
    section: str
    path: str
    has_code: bool
    score: float


class CsoundRetriever:
    """Retrieves relevant chunks from the Csound corpus."""

    EMBEDDING_MODEL = "all-MiniLM-L6-v2"
    COLLECTION_NAME = "csound_corpus"

    def __init__(self, db_path: str | Path):
        """Initialize retriever with database path."""
        self.db_path = Path(db_path)

        if not self.db_path.exists():
            raise FileNotFoundError(
                f"Database not found at {db_path}. Run indexing first."
            )

        self.client = chromadb.PersistentClient(
            path=str(self.db_path),
            settings=Settings(anonymized_telemetry=False),
        )
        self.embedding_model = SentenceTransformer(self.EMBEDDING_MODEL)

        try:
            self.collection = self.client.get_collection(self.COLLECTION_NAME)
        except ValueError:
            raise ValueError(
                "Collection not found. Run indexing first."
            )

    def search(
        self,
        query: str,
        n_results: int = 5,
        sources: list[str] | None = None,
        code_only: bool = False,
    ) -> list[SearchResult]:
        """
        Search for relevant chunks.

        Args:
            query: Search query
            n_results: Number of results to return
            sources: Filter to specific corpus sources (e.g., ["opcode_reference"])
            code_only: Only return chunks containing code

        Returns:
            List of SearchResult objects
        """
        # Build where filter
        where_filter = None
        if sources or code_only:
            conditions = []
            if sources:
                if len(sources) == 1:
                    conditions.append({"source": sources[0]})
                else:
                    conditions.append({"source": {"$in": sources}})
            if code_only:
                conditions.append({"has_code": True})

            if len(conditions) == 1:
                where_filter = conditions[0]
            else:
                where_filter = {"$and": conditions}

        # Embed query
        query_embedding = self.embedding_model.encode(query).tolist()

        # Search
        results = self.collection.query(
            query_embeddings=[query_embedding],
            n_results=n_results,
            where=where_filter,
            include=["documents", "metadatas", "distances"],
        )

        # Convert to SearchResult objects
        search_results = []
        if results["documents"] and results["documents"][0]:
            for i, doc in enumerate(results["documents"][0]):
                metadata = results["metadatas"][0][i]
                distance = results["distances"][0][i]
                # Convert distance to similarity score (0-1)
                score = 1 / (1 + distance)

                search_results.append(SearchResult(
                    text=doc,
                    source=metadata.get("source", "unknown"),
                    title=metadata.get("title", "Unknown"),
                    section=metadata.get("section", ""),
                    path=metadata.get("path", ""),
                    has_code=metadata.get("has_code", False),
                    score=score,
                ))

        return search_results

    def format_context(
        self,
        results: list[SearchResult],
        max_length: int = 8000,
    ) -> str:
        """
        Format search results into context for LLM.

        Args:
            results: Search results to format
            max_length: Maximum context length in characters

        Returns:
            Formatted context string
        """
        context_parts = []
        current_length = 0

        for i, result in enumerate(results, 1):
            # Format header
            header = f"### Source {i}: {result.title}"
            if result.section and result.section != result.title:
                header += f" - {result.section}"
            header += f"\n[{result.source}]"

            entry = f"{header}\n\n{result.text}\n"

            # Check length
            if current_length + len(entry) > max_length:
                # Try to fit a truncated version
                remaining = max_length - current_length - len(header) - 50
                if remaining > 200:
                    truncated = result.text[:remaining] + "...\n[truncated]"
                    entry = f"{header}\n\n{truncated}\n"
                    context_parts.append(entry)
                break

            context_parts.append(entry)
            current_length += len(entry)

        return "\n---\n\n".join(context_parts)

    def get_sources(self) -> list[str]:
        """Get list of available corpus sources."""
        # Query a sample to get unique sources
        results = self.collection.get(
            limit=1000,
            include=["metadatas"],
        )

        sources = set()
        for metadata in results["metadatas"]:
            if "source" in metadata:
                sources.add(metadata["source"])

        return sorted(sources)
