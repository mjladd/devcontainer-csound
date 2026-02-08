#!/usr/bin/env python3
"""
Index the Csound corpus for RAG retrieval.

This script processes all markdown files in the corpus directory,
chunks them intelligently, and stores them in ChromaDB with embeddings.

Usage:
    python scripts/index_corpus.py [--reset]

The index is stored in .cache/csound_assist_db/

Note: Prefer using the CLI instead: csound-assist index [--reset]
"""

import argparse
import sys
from pathlib import Path

# Add project root to path
project_root = Path(__file__).parent.parent
sys.path.insert(0, str(project_root))

from csound_assist.indexer import CsoundIndexer


def main():
    parser = argparse.ArgumentParser(
        description="Index Csound corpus for RAG retrieval"
    )
    parser.add_argument(
        "--reset",
        action="store_true",
        help="Delete existing index and rebuild from scratch",
    )
    parser.add_argument(
        "--corpus-dir",
        type=Path,
        default=project_root / "corpus",
        help="Path to corpus directory",
    )
    parser.add_argument(
        "--db-path",
        type=Path,
        default=project_root / ".cache" / "csound_assist_db",
        help="Path to ChromaDB database",
    )
    args = parser.parse_args()

    if not args.corpus_dir.exists():
        print(f"Error: Corpus directory not found: {args.corpus_dir}")
        return 1

    print("=" * 60)
    print("Csound Corpus Indexer")
    print("=" * 60)
    print(f"Corpus: {args.corpus_dir}")
    print(f"Database: {args.db_path}")
    print(f"Reset: {args.reset}")
    print()

    indexer = CsoundIndexer(args.db_path)

    # Show current status
    stats = indexer.get_stats()
    if stats["indexed"]:
        print(f"Current index: {stats['chunks']} chunks")
        if args.reset:
            print("Will delete and rebuild...")
        else:
            print("Will update existing index...")
    else:
        print("No existing index found. Creating new...")
    print()

    # Run indexing
    result = indexer.index_corpus(args.corpus_dir, reset=args.reset)

    print()
    print("=" * 60)
    print("Indexing Complete")
    print("=" * 60)
    print(f"Documents processed: {result['documents']}")
    print(f"Chunks created: {result['chunks']}")
    print(f"Sources: {', '.join(result['sources'])}")
    print()
    print("You can now use the assistant:")
    print("  csound-assist search 'how do I create an oscillator?'")

    return 0


if __name__ == "__main__":
    sys.exit(main())
