"""
Hybrid retriever combining ChromaDB semantic search with BM25 keyword search.

Uses Reciprocal Rank Fusion (RRF) to merge ranked results from both systems.
Auto-biases toward BM25 for opcode-heavy queries where exact keyword matching
is more important than semantic similarity.
"""

import logging
import pickle
import re
from pathlib import Path

try:
    from rank_bm25 import BM25Okapi
    HAS_BM25 = True
except ImportError:
    HAS_BM25 = False
    BM25Okapi = None

from csound_assist.opcode_data import OPCODE_DESCRIPTIONS

logger = logging.getLogger(__name__)

# RRF constant (standard value from the original RRF paper)
RRF_K = 60

# Default weights
DEFAULT_SEMANTIC_WEIGHT = 0.5
DEFAULT_BM25_WEIGHT = 0.5

# When query is opcode-heavy, bias toward BM25
OPCODE_HEAVY_SEMANTIC_WEIGHT = 0.3
OPCODE_HEAVY_BM25_WEIGHT = 0.7

# BM25 index cache path
DEFAULT_BM25_CACHE = Path(".cache/bm25_index.pkl")


def _tokenize(text: str) -> list[str]:
    """Simple whitespace + punctuation tokenizer for BM25."""
    text = text.lower()
    tokens = re.findall(r'[a-z0-9_]+', text)
    return tokens


def _is_opcode_heavy_query(query: str) -> bool:
    """Check if a query contains mostly opcode names."""
    words = query.lower().split()
    if not words:
        return False
    opcode_count = sum(1 for w in words if w in OPCODE_DESCRIPTIONS)
    return opcode_count >= len(words) * 0.5


class HybridRetriever:
    """
    Combines ChromaDB semantic search with BM25 keyword search.

    Merges results using Reciprocal Rank Fusion:
        score(doc) = Σ(weight_i / (K + rank_i))

    The BM25 index is built from the ChromaDB collection's documents
    and persisted as a pickle file for fast loading.
    """

    def __init__(
        self,
        collection,
        embedding_fn,
        bm25_cache_path: Path = DEFAULT_BM25_CACHE,
        semantic_weight: float = DEFAULT_SEMANTIC_WEIGHT,
        bm25_weight: float = DEFAULT_BM25_WEIGHT,
    ):
        """
        Args:
            collection: ChromaDB collection
            embedding_fn: Embedding function with embed_query() method
            bm25_cache_path: Path to persist BM25 index
            semantic_weight: Weight for semantic search in RRF
            bm25_weight: Weight for BM25 search in RRF
        """
        self.collection = collection
        self.embedding_fn = embedding_fn
        self.bm25_cache_path = bm25_cache_path
        self.semantic_weight = semantic_weight
        self.bm25_weight = bm25_weight

        # BM25 state
        self._bm25: BM25Okapi | None = None
        self._bm25_ids: list[str] = []
        self._bm25_docs: list[str] = []
        self._bm25_metadatas: list[dict] = []

        # Try loading cached BM25 index
        self._load_bm25_cache()

    def _load_bm25_cache(self):
        """Load BM25 index from disk if available."""
        if not HAS_BM25:
            return
        if self.bm25_cache_path.exists():
            try:
                with open(self.bm25_cache_path, "rb") as f:
                    data = pickle.load(f)
                self._bm25 = data["bm25"]
                self._bm25_ids = data["ids"]
                self._bm25_docs = data["docs"]
                self._bm25_metadatas = data.get("metadatas", [])
                logger.info("Loaded BM25 index with %d documents", len(self._bm25_ids))
            except Exception as e:
                logger.warning("Failed to load BM25 cache: %s", e)

    def build_bm25_index(self):
        """
        Build BM25 index from the ChromaDB collection.

        Fetches all documents from ChromaDB and creates a BM25Okapi index.
        Persists the result to disk.
        """
        if not HAS_BM25:
            logger.warning("rank-bm25 not installed, BM25 search disabled")
            return

        count = self.collection.count()
        if count == 0:
            logger.warning("Collection is empty, cannot build BM25 index")
            return

        logger.info("Building BM25 index from %d documents...", count)

        # Fetch all documents in batches
        all_ids: list[str] = []
        all_docs: list[str] = []
        all_metadatas: list[dict] = []
        batch_size = 5000
        offset = 0

        while offset < count:
            result = self.collection.get(
                limit=batch_size,
                offset=offset,
                include=["documents", "metadatas"],
            )
            if not result["ids"]:
                break
            all_ids.extend(result["ids"])
            all_docs.extend(result["documents"])
            all_metadatas.extend(result["metadatas"])
            offset += len(result["ids"])

        # Tokenize and build BM25
        tokenized = [_tokenize(doc) for doc in all_docs]
        self._bm25 = BM25Okapi(tokenized)
        self._bm25_ids = all_ids
        self._bm25_docs = all_docs
        self._bm25_metadatas = all_metadatas

        # Persist to disk
        self.bm25_cache_path.parent.mkdir(parents=True, exist_ok=True)
        with open(self.bm25_cache_path, "wb") as f:
            pickle.dump({
                "bm25": self._bm25,
                "ids": self._bm25_ids,
                "docs": self._bm25_docs,
                "metadatas": self._bm25_metadatas,
            }, f)
        logger.info("BM25 index built and saved (%d documents)", len(all_ids))

    def _search_semantic(self, query: str, n_results: int) -> list[dict]:
        """Perform semantic search via ChromaDB."""
        query_embedding = self.embedding_fn.embed_query(query)
        results = self.collection.query(
            query_embeddings=[query_embedding],
            n_results=n_results,
            include=["documents", "metadatas", "distances"],
        )

        formatted = []
        for i in range(len(results["ids"][0])):
            formatted.append({
                "id": results["ids"][0][i],
                "content": results["documents"][0][i],
                "metadata": results["metadatas"][0][i],
                "distance": results["distances"][0][i],
            })
        return formatted

    def _search_bm25(self, query: str, n_results: int) -> list[dict]:
        """Perform BM25 keyword search."""
        if self._bm25 is None:
            return []

        tokenized_query = _tokenize(query)
        scores = self._bm25.get_scores(tokenized_query)

        # Get top N indices
        top_indices = sorted(range(len(scores)), key=lambda i: scores[i], reverse=True)
        top_indices = top_indices[:n_results]

        results = []
        for idx in top_indices:
            if scores[idx] > 0:
                metadata = self._bm25_metadatas[idx] if idx < len(self._bm25_metadatas) else {}
                results.append({
                    "id": self._bm25_ids[idx],
                    "content": self._bm25_docs[idx],
                    "metadata": metadata,
                    "bm25_score": float(scores[idx]),
                })
        return results

    def search(
        self,
        query: str,
        n_results: int = 5,
        semantic_weight: float | None = None,
        bm25_weight: float | None = None,
    ) -> list[dict]:
        """
        Hybrid search combining semantic and BM25 results with RRF.

        Auto-biases toward BM25 for opcode-heavy queries.

        Args:
            query: Search query
            n_results: Number of results to return
            semantic_weight: Override default semantic weight
            bm25_weight: Override default BM25 weight

        Returns:
            List of results sorted by RRF score
        """
        # Determine weights (auto-bias for opcode queries)
        if semantic_weight is None or bm25_weight is None:
            if _is_opcode_heavy_query(query):
                sw = OPCODE_HEAVY_SEMANTIC_WEIGHT
                bw = OPCODE_HEAVY_BM25_WEIGHT
            else:
                sw = self.semantic_weight
                bw = self.bm25_weight
        else:
            sw = semantic_weight
            bw = bm25_weight

        # Fetch more than needed from each source for better fusion
        fetch_n = n_results * 3

        # Semantic search
        semantic_results = self._search_semantic(query, fetch_n)

        # BM25 search (if available)
        bm25_results = self._search_bm25(query, fetch_n) if self._bm25 is not None else []

        # If BM25 is unavailable, return semantic results directly
        if not bm25_results:
            return semantic_results[:n_results]

        # Reciprocal Rank Fusion
        rrf_scores: dict[str, float] = {}
        doc_map: dict[str, dict] = {}

        for rank, result in enumerate(semantic_results):
            doc_id = result["id"]
            rrf_scores[doc_id] = rrf_scores.get(doc_id, 0) + sw / (RRF_K + rank + 1)
            doc_map[doc_id] = result

        for rank, result in enumerate(bm25_results):
            doc_id = result["id"]
            rrf_scores[doc_id] = rrf_scores.get(doc_id, 0) + bw / (RRF_K + rank + 1)
            if doc_id not in doc_map:
                doc_map[doc_id] = result

        # Sort by RRF score
        sorted_ids = sorted(rrf_scores, key=lambda x: rrf_scores[x], reverse=True)

        results = []
        for doc_id in sorted_ids[:n_results]:
            entry = doc_map[doc_id].copy()
            entry["rrf_score"] = rrf_scores[doc_id]
            results.append(entry)

        return results

    def get_relevant_context(
        self,
        query: str,
        max_tokens: int = 3000,
        n_results: int = 10,
    ) -> str:
        """
        Get relevant context for a query, formatted for LLM consumption.

        Orders by relevance with "lost in the middle" mitigation:
        most relevant first, second-most relevant last.
        """
        results = self.search(query, n_results=n_results)

        context_parts: list[str] = []
        total_tokens = 0

        for result in results:
            content = result["content"]
            tokens = len(content) // 4

            if total_tokens + tokens > max_tokens:
                break

            source = result["metadata"].get("source", "unknown")
            section = result["metadata"].get("section", "")

            header = f"[Source: {source}]"
            if section:
                header += f" [{section}]"

            context_parts.append(f"{header}\n{content}")
            total_tokens += tokens

        # "Lost in the middle" reordering: best first, second-best last
        if len(context_parts) > 2:
            # Keep first (best), move second-best to end
            reordered = [context_parts[0]]
            middle = context_parts[2:]
            reordered.extend(middle)
            reordered.append(context_parts[1])
            context_parts = reordered

        return "\n\n---\n\n".join(context_parts)

    @property
    def bm25_available(self) -> bool:
        """Whether BM25 index is loaded."""
        return self._bm25 is not None

    @property
    def bm25_doc_count(self) -> int:
        """Number of documents in BM25 index."""
        return len(self._bm25_ids)
