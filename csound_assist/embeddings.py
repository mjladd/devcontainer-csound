"""
Embedding function using Ollama's nomic-embed-text model.

Replaces sentence-transformers with Ollama-hosted embeddings for
consistent infrastructure (same server hosts LLM and embeddings).
"""

import logging

try:
    from ollama import Client as OllamaClient
    HAS_OLLAMA = True
except ImportError:
    HAS_OLLAMA = False
    OllamaClient = None

logger = logging.getLogger(__name__)

# nomic-embed-text produces 768-dimensional embeddings with 8K context
DEFAULT_EMBEDDING_MODEL = "nomic-embed-text"
EMBEDDING_DIMENSIONS = 768


class OllamaEmbeddingFunction:
    """
    ChromaDB-compatible embedding function using Ollama.

    Uses nomic-embed-text with task-specific prefixes:
    - "search_document: " for documents being indexed
    - "search_query: " for search queries
    """

    def __init__(
        self,
        model: str = DEFAULT_EMBEDDING_MODEL,
        ollama_url: str = "http://d01.consul:3000",
    ):
        if not HAS_OLLAMA:
            raise ImportError(
                "ollama is required. Install with: pip install ollama"
            )
        self.model = model
        self.model_name = model
        self.ollama_url = ollama_url
        self._client = OllamaClient(host=ollama_url)

    def _embed(self, texts: list[str]) -> list[list[float]]:
        """Generate embeddings for a list of texts via Ollama."""
        try:
            response = self._client.embed(model=self.model, input=texts)
            return response["embeddings"]
        except Exception as e:
            logger.error("Ollama embedding error: %s", e)
            raise ConnectionError(
                f"Failed to generate embeddings via Ollama at {self.ollama_url}: {e}"
            ) from e

    def embed_documents(self, texts: list[str]) -> list[list[float]]:
        """
        Generate embeddings for documents being indexed.

        Adds the 'search_document: ' prefix recommended by nomic-embed-text.
        """
        prefixed = [f"search_document: {t}" for t in texts]
        return self._embed(prefixed)

    def embed_query(self, text: str) -> list[float]:
        """
        Generate embedding for a search query.

        Adds the 'search_query: ' prefix recommended by nomic-embed-text.
        """
        prefixed = [f"search_query: {text}"]
        result = self._embed(prefixed)
        return result[0]

    def __call__(self, input: list[str]) -> list[list[float]]:
        """ChromaDB-compatible callable interface (uses document prefix)."""
        return self.embed_documents(input)

    def check_connection(self) -> bool:
        """Verify that the Ollama server is reachable and the model is available."""
        try:
            self._client.show(self.model)
            return True
        except Exception:
            return False
