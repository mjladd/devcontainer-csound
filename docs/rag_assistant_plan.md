# Csound RAG Assistant - Implementation Plan

## Status: Implemented

The RAG assistant is fully implemented and indexed. This document captures the design decisions and architecture.

## Overview

A local RAG-based CLI assistant for Csound programming using:

- **ChromaDB** for vector storage
- **sentence-transformers** for embeddings (all-MiniLM-L6-v2)
- **Ollama** for LLM responses (codellama)
- **CLI** interface (click + rich)

## Architecture

```shell
┌─────────────┐     ┌──────────────┐     ┌─────────────┐
│   Corpus    │────▶│  Indexer     │────▶│  ChromaDB   │
│  (markdown) │     │  (chunking + │     │  (vectors + │
│             │     │   embedding) │     │   docs)     │
└─────────────┘     └──────────────┘     └──────┬──────┘
                                                │
┌─────────────┐     ┌──────────────┐            │
│   User      │────▶│  CLI Tool    │◀───────────┘
│   Query     │     │  (retrieve + │     ┌─────────────┐
│             │     │   generate)  │────▶│   Ollama    │
└─────────────┘     └──────────────┘     │   (LLM)     │
                                         └─────────────┘
```

## File Structure

```shell
devcontainer-csound/
├── csound_rag/                    # RAG package
│   ├── __init__.py
│   ├── indexer.py                 # Corpus processing + embedding
│   ├── retriever.py               # ChromaDB search
│   ├── generator.py               # Ollama integration
│   └── cli.py                     # CLI entry point
├── requirements.txt               # Dependencies
├── .venv/                         # Python 3.11 virtual environment
├── .cache/
│   └── csound_rag_db/             # ChromaDB database
└── scripts/
    └── index_corpus.py            # Indexing script
```

## Usage

### Prerequisites

- Python 3.11 (3.14 has compatibility issues)
- Ollama installed and running

### Setup

```bash
# Activate virtual environment
source .venv/bin/activate

# Start Ollama (in separate terminal)
ollama serve

# Pull model (first time only)
ollama pull codellama
```

### Commands

```bash
# Ask a question
python -m csound_rag.cli query "how do I create an FM synthesizer?"

# Filter to specific sources
python -m csound_rag.cli query "envelope design" -s opcode_reference -s floss_manual

# Only search code examples
python -m csound_rag.cli query "granular synthesis" --code-only

# Show source citations
python -m csound_rag.cli query "reverb design" --show-sources

# Check index status
python -m csound_rag.cli status

# List available sources
python -m csound_rag.cli sources

# Rebuild index
python -m csound_rag.cli index --reset
```

## Index Statistics

- **Documents indexed**: 2,896
- **Chunks created**: 27,861
- **Corpus size**: ~50MB

### Sources Indexed

- opcode_reference (official manual)
- floss_manual (tutorials)
- csound_book_pdf (32 chapters)
- csound_computing_system_pdf (23 chapters)
- mccurdy_examples
- cabbage_examples (560)
- blue_examples (134 projects)
- csound_journal (articles)
- steven_yi (tutorials)
- csound_expression (32 tutorials)
- csound_plugins (179 opcodes)
- composition_analysis

## Implementation Details

### Chunking Strategy

1. Parse YAML front matter for metadata
2. Split on H2/H3 markdown headers
3. Keep code blocks intact (don't split mid-example)
4. Target chunk size: ~1500 characters
5. Tag chunks with: source, title, section, has_code

### Embedding Model

- Model: `all-MiniLM-L6-v2`
- Dimensions: 384
- Fast, good quality for semantic search

### LLM Configuration

- Model: `codellama` (optimized for code)
- Temperature: 0.3 (focused responses)
- Context window: 8192 tokens

### Retrieval

- Default: 5 results per query
- Supports filtering by source
- Supports code-only filtering
- Results ranked by cosine similarity

## Dependencies

| Package | Purpose |
|---------|---------|
| chromadb | Vector database |
| sentence-transformers | Local embeddings |
| ollama | LLM client |
| click | CLI framework |
| rich | Terminal formatting |
| pyyaml | Parse front matter |

## Future Improvements

- Re-ranking retrieved results
- Caching embeddings for faster re-indexing
- Web interface option
- Support for additional LLM backends
- Query history and feedback loop
