#!/usr/bin/env python3
"""
Merge all JSONL training files into a single corpus.

This script combines:
1. Original csound_corpus JSONL files (synthesis/, signal_processing/)
2. Converted examples from csound_score_examples

Usage:
    python scripts/merge_jsonl_corpus.py [--output FILE]
"""

import argparse
import json
from pathlib import Path
from collections import defaultdict


def find_jsonl_files(base_dir: Path) -> list[Path]:
    """Find all JSONL files in a directory tree."""
    return list(base_dir.rglob("*.jsonl"))


def load_jsonl(path: Path) -> list[dict]:
    """Load entries from a JSONL file."""
    entries = []
    with open(path, 'r', encoding='utf-8') as f:
        for line_num, line in enumerate(f, 1):
            line = line.strip()
            if not line:
                continue
            try:
                entries.append(json.loads(line))
            except json.JSONDecodeError as e:
                print(f"  Warning: Invalid JSON at {path}:{line_num}: {e}")
    return entries


def deduplicate_entries(entries: list[dict]) -> list[dict]:
    """Remove duplicate entries based on output content."""
    seen = set()
    unique = []

    for entry in entries:
        # Use hash of output as key
        output = entry.get("output", "")
        output_hash = hash(output)

        if output_hash not in seen:
            seen.add(output_hash)
            unique.append(entry)

    return unique


def validate_entry(entry: dict) -> bool:
    """Validate that an entry has required fields."""
    if not isinstance(entry, dict):
        return False
    if "instruction" not in entry:
        return False
    if "output" not in entry:
        return False
    if len(entry["output"]) < 50:
        return False
    return True


def categorize_by_source(entries: list[dict], source_path: Path, base_dir: Path) -> str:
    """Determine the category/source of entries based on file path."""
    rel_path = source_path.relative_to(base_dir)
    parts = rel_path.parts

    if "converted_examples" in parts:
        return "converted_examples"
    elif "synthesis" in parts:
        return "synthesis"
    elif "signal_processing" in parts:
        return "signal_processing"
    else:
        return "other"


def main():
    parser = argparse.ArgumentParser(
        description="Merge all JSONL training files into a single corpus"
    )
    parser.add_argument(
        "--corpus-dir",
        type=Path,
        default=Path(__file__).parent.parent / "csound_corpus",
        help="Base directory containing JSONL files",
    )
    parser.add_argument(
        "--output",
        type=Path,
        default=Path(__file__).parent.parent / "csound_corpus" / "training_corpus.jsonl",
        help="Output file path",
    )
    parser.add_argument(
        "--exclude-converted",
        action="store_true",
        help="Exclude converted examples (only use curated corpus)",
    )
    parser.add_argument(
        "--stats-only",
        action="store_true",
        help="Only show statistics, don't write output",
    )
    args = parser.parse_args()

    if not args.corpus_dir.exists():
        print(f"Error: Corpus directory not found: {args.corpus_dir}")
        return 1

    print("=" * 60)
    print("Merge JSONL Training Corpus")
    print("=" * 60)
    print(f"Corpus directory: {args.corpus_dir}")
    print()

    # Find all JSONL files
    jsonl_files = find_jsonl_files(args.corpus_dir)

    # Exclude internal files
    jsonl_files = [
        f for f in jsonl_files
        if not f.name.startswith("_")
        and "training_corpus" not in f.name
    ]

    if args.exclude_converted:
        jsonl_files = [
            f for f in jsonl_files
            if "converted_examples" not in str(f)
        ]

    print(f"Found {len(jsonl_files)} JSONL files")

    # Load and categorize entries
    all_entries = []
    stats = defaultdict(lambda: {"files": 0, "entries": 0})

    for path in sorted(jsonl_files):
        entries = load_jsonl(path)
        category = categorize_by_source(entries, path, args.corpus_dir)

        valid_entries = [e for e in entries if validate_entry(e)]

        # Tag entries with source
        for entry in valid_entries:
            entry["_source_file"] = str(path.relative_to(args.corpus_dir))
            entry["_category"] = category

        all_entries.extend(valid_entries)
        stats[category]["files"] += 1
        stats[category]["entries"] += len(valid_entries)

        if len(valid_entries) != len(entries):
            print(f"  {path.name}: {len(valid_entries)}/{len(entries)} valid entries")

    print()
    print("Entries by category:")
    for category, s in sorted(stats.items()):
        print(f"  {category}: {s['entries']} entries from {s['files']} files")

    total_before = len(all_entries)

    # Deduplicate
    all_entries = deduplicate_entries(all_entries)
    duplicates_removed = total_before - len(all_entries)

    print()
    print(f"Total entries: {total_before}")
    print(f"Duplicates removed: {duplicates_removed}")
    print(f"Final count: {len(all_entries)}")

    if args.stats_only:
        return 0

    # Remove internal metadata before writing
    for entry in all_entries:
        entry.pop("_source_file", None)
        entry.pop("_category", None)

    # Write merged corpus
    args.output.parent.mkdir(parents=True, exist_ok=True)
    with open(args.output, 'w', encoding='utf-8') as f:
        for entry in all_entries:
            f.write(json.dumps(entry, ensure_ascii=False) + '\n')

    print()
    print(f"Written to: {args.output}")
    print(f"File size: {args.output.stat().st_size / 1024 / 1024:.2f} MB")

    # Also create category-specific files
    by_category = defaultdict(list)
    for entry in all_entries:
        # Re-categorize based on content/instruction
        instruction = entry.get("instruction", "").lower()
        if any(kw in instruction for kw in ["filter", "eq", "compress", "reverb", "delay", "effect"]):
            by_category["signal_processing"].append(entry)
        else:
            by_category["synthesis"].append(entry)

    for category, entries in by_category.items():
        cat_path = args.output.with_stem(f"training_corpus_{category}")
        with open(cat_path, 'w', encoding='utf-8') as f:
            for entry in entries:
                f.write(json.dumps(entry, ensure_ascii=False) + '\n')
        print(f"  {cat_path.name}: {len(entries)} entries")

    return 0


if __name__ == "__main__":
    exit(main())
