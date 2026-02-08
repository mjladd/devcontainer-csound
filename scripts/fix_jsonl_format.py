#!/usr/bin/env python3
"""
Fix JSONL files that have literal \\n between JSON objects instead of actual newlines.

Some files were created with escaped newlines between JSON objects:
    {"obj": 1}\\n{"obj": 2}

This script fixes them to proper JSONL format:
    {"obj": 1}
    {"obj": 2}
"""

import json
import re
from pathlib import Path


def fix_jsonl_file(path: Path, dry_run: bool = False) -> dict:
    """Fix a JSONL file with incorrect newline escaping."""
    stats = {"fixed": False, "entries_before": 0, "entries_after": 0, "error": None}

    try:
        content = path.read_text(encoding='utf-8')
    except Exception as e:
        stats["error"] = str(e)
        return stats

    # Check if file has the issue (literal \n between objects)
    # Pattern: }\n{ where \n is literal backslash-n
    if '}\\n{' not in content:
        # File doesn't have this issue
        return stats

    # Split on the literal \n between objects
    # This pattern matches: }  followed by literal \n  followed by {
    parts = re.split(r'\}\\n\{', content)

    if len(parts) <= 1:
        # No splits made
        return stats

    # Reconstruct as proper JSON objects
    entries = []

    # First part ends with }
    first = parts[0] + '}'
    try:
        entries.append(json.loads(first))
        stats["entries_before"] += 1
    except json.JSONDecodeError as e:
        stats["error"] = f"Failed to parse first entry: {e}"
        return stats

    # Middle parts need { at start and } at end
    for part in parts[1:-1]:
        middle = '{' + part + '}'
        try:
            entries.append(json.loads(middle))
            stats["entries_before"] += 1
        except json.JSONDecodeError as e:
            stats["error"] = f"Failed to parse middle entry: {e}"
            return stats

    # Last part starts with {
    if len(parts) > 1:
        last = '{' + parts[-1]
        try:
            entries.append(json.loads(last))
            stats["entries_before"] += 1
        except json.JSONDecodeError as e:
            stats["error"] = f"Failed to parse last entry: {e}"
            return stats

    stats["entries_after"] = len(entries)

    if dry_run:
        stats["fixed"] = True
        return stats

    # Write fixed file
    with open(path, 'w', encoding='utf-8') as f:
        for entry in entries:
            f.write(json.dumps(entry, ensure_ascii=False) + '\n')

    stats["fixed"] = True
    return stats


def main():
    import argparse

    parser = argparse.ArgumentParser(description="Fix JSONL format issues")
    parser.add_argument(
        "--corpus-dir",
        type=Path,
        default=Path(__file__).parent.parent / "csound_corpus",
        help="Directory to search for JSONL files",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be fixed without making changes",
    )
    args = parser.parse_args()

    # Find all JSONL files
    jsonl_files = list(args.corpus_dir.rglob("*.jsonl"))

    print(f"Checking {len(jsonl_files)} JSONL files...")
    print()

    fixed_count = 0
    error_count = 0

    for path in sorted(jsonl_files):
        stats = fix_jsonl_file(path, dry_run=args.dry_run)

        if stats["error"]:
            print(f"ERROR: {path.name}")
            print(f"  {stats['error']}")
            error_count += 1
        elif stats["fixed"]:
            rel_path = path.relative_to(args.corpus_dir)
            action = "Would fix" if args.dry_run else "Fixed"
            print(f"{action}: {rel_path}")
            print(f"  Entries: {stats['entries_before']} -> {stats['entries_after']}")
            fixed_count += 1

    print()
    print(f"{'Would fix' if args.dry_run else 'Fixed'}: {fixed_count} files")
    if error_count:
        print(f"Errors: {error_count} files")

    return 0 if error_count == 0 else 1


if __name__ == "__main__":
    exit(main())
