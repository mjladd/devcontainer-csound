"""
Csound RAG Assistant

A local RAG-based assistant for Csound programming using:
- ChromaDB for vector storage
- sentence-transformers for embeddings
- Ollama for LLM responses
"""

__version__ = "0.1.0"

from .indexer import CsoundIndexer
from .retriever import CsoundRetriever
from .generator import CsoundGenerator

__all__ = ["CsoundIndexer", "CsoundRetriever", "CsoundGenerator"]
