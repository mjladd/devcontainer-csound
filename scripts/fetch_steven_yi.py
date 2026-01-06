#!/usr/bin/env python3
"""
Download Steven Yi's Csound resources for corpus integration.

This script downloads:
1. libsyi - UDO library (filters, synths, effects)
2. csound-live-code - Live coding library and documentation
"""

import os
import re
import json
import shutil
import subprocess
import tempfile
from pathlib import Path
from datetime import datetime

# Configuration
LIBSYI_REPO = "https://github.com/kunstmusik/libsyi.git"
LIVECODE_REPO = "https://github.com/kunstmusik/csound-live-code.git"


def clone_repo(url: str, dest: Path) -> None:
    """Clone a git repository."""
    print(f"  Cloning {url}...")
    subprocess.run(
        ["git", "clone", "--depth", "1", url, str(dest)],
        check=True,
        capture_output=True,
    )


def extract_udo_metadata(content: str, filename: str) -> dict:
    """Extract metadata from a UDO file."""
    metadata = {
        "name": filename.replace(".udo", ""),
        "description": "",
        "author": "Steven Yi",
        "opcodes": [],
    }

    # Extract opcode definitions
    opcode_matches = re.findall(r"opcode\s+(\w+)", content)
    metadata["opcodes"] = list(set(opcode_matches))

    # Try to extract description from comments at top
    comment_match = re.search(r"^;+\s*(.+?)(?=\n[^;]|\nopcode)", content, re.MULTILINE | re.DOTALL)
    if comment_match:
        desc_lines = [line.lstrip("; ").strip() for line in comment_match.group(1).split("\n") if line.strip()]
        metadata["description"] = " ".join(desc_lines[:3])

    return metadata


def process_libsyi(repo_path: Path, output_dir: Path) -> list[dict]:
    """Process libsyi UDO files."""
    processed = []

    for udo_file in sorted(repo_path.glob("*.udo")):
        content = udo_file.read_text(encoding="utf-8", errors="replace")
        metadata = extract_udo_metadata(content, udo_file.name)

        # Create output file with metadata header
        target_path = output_dir / udo_file.name.replace(".udo", ".md")

        md_content = f"""# {metadata['name']} - Steven Yi's UDO Library

## Metadata

- **Source:** libsyi (Steven Yi's UDO Library)
- **Repository:** {LIBSYI_REPO}
- **Author:** Steven Yi
- **License:** MIT
- **Opcodes Defined:** {', '.join(metadata['opcodes']) if metadata['opcodes'] else 'N/A'}
- **Tags:** `udo`, `libsyi`, `steven-yi`, `{metadata['name'].lower()}`

---

## Description

{metadata['description'] if metadata['description'] else 'User-defined opcode from Steven Yi\'s libsyi collection.'}

---

## Code

```csound
{content}
```

---

## Usage

Include this UDO in your Csound orchestra:

```csound
#include "{udo_file.name}"
```

"""
        target_path.write_text(md_content, encoding="utf-8")

        # Also copy the raw .udo file
        shutil.copy(udo_file, output_dir / udo_file.name)

        processed.append({
            "file": udo_file.name,
            "name": metadata["name"],
            "opcodes": metadata["opcodes"],
            "description": metadata["description"][:100] if metadata["description"] else "",
        })
        print(f"    {metadata['name']}: {len(metadata['opcodes'])} opcodes")

    return processed


def process_livecode(repo_path: Path, output_dir: Path) -> list[dict]:
    """Process csound-live-code documentation and library."""
    processed = []

    # Copy main library file
    livecode_orc = repo_path / "livecode.orc"
    if livecode_orc.exists():
        content = livecode_orc.read_text(encoding="utf-8", errors="replace")

        # Create markdown version
        md_content = f"""# Csound Live Code Library

## Metadata

- **Source:** csound-live-code
- **Repository:** {LIVECODE_REPO}
- **Author:** Steven Yi
- **License:** MIT
- **Tags:** `live-coding`, `livecode`, `steven-yi`, `performance`

---

## Description

The csound-live-code library provides a framework for live coding with Csound.
It includes instruments, patterns, scales, and utilities for real-time music performance.

---

## Main Library (livecode.orc)

```csound
{content}
```
"""
        (output_dir / "livecode_orc.md").write_text(md_content, encoding="utf-8")
        shutil.copy(livecode_orc, output_dir / "livecode.orc")
        processed.append({"file": "livecode.orc", "type": "library"})
        print("    livecode.orc")

    # Process documentation
    doc_dir = repo_path / "doc"
    if doc_dir.exists():
        for md_file in sorted(doc_dir.glob("*.md")):
            content = md_file.read_text(encoding="utf-8", errors="replace")

            # Add metadata header
            enhanced_content = f"""---
source: csound-live-code documentation
repository: {LIVECODE_REPO}
author: Steven Yi
license: MIT
---

{content}
"""
            target_path = output_dir / f"doc_{md_file.name}"
            target_path.write_text(enhanced_content, encoding="utf-8")
            processed.append({"file": md_file.name, "type": "documentation"})
            print(f"    doc/{md_file.name}")

    # Process practice/example files
    practice_dir = repo_path / "practice"
    if practice_dir.exists():
        for csd_file in sorted(practice_dir.glob("*.csd")):
            shutil.copy(csd_file, output_dir / f"practice_{csd_file.name}")
            processed.append({"file": csd_file.name, "type": "example"})
            print(f"    practice/{csd_file.name}")

    return processed


def create_index(output_dir: Path, libsyi_files: list, livecode_files: list) -> None:
    """Create index file."""
    index_content = f"""# Steven Yi's Csound Resources - Corpus Index

**Downloaded:** {datetime.now().strftime("%Y-%m-%d")}
**License:** MIT

## About

This corpus contains Csound resources created by Steven Yi, including:
- **libsyi**: A library of user-defined opcodes (UDOs)
- **csound-live-code**: A framework for live coding with Csound

## libsyi UDOs ({len(libsyi_files)} files)

| UDO | Opcodes | Description |
|-----|---------|-------------|
"""
    for f in sorted(libsyi_files, key=lambda x: x["name"]):
        opcodes = ", ".join(f["opcodes"][:3]) + ("..." if len(f["opcodes"]) > 3 else "")
        desc = f["description"][:50] + "..." if f["description"] else "N/A"
        index_content += f"| [{f['name']}]({f['name']}.md) | {opcodes} | {desc} |\n"

    index_content += f"""

## csound-live-code ({len(livecode_files)} files)

| File | Type |
|------|------|
"""
    for f in sorted(livecode_files, key=lambda x: x["file"]):
        index_content += f"| {f['file']} | {f['type']} |\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding="utf-8")

    # JSON index
    index_data = {"libsyi": libsyi_files, "livecode": livecode_files}
    (output_dir / "index.json").write_text(json.dumps(index_data, indent=2), encoding="utf-8")


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "steven_yi"
    libsyi_dir = output_dir / "libsyi"
    livecode_dir = output_dir / "livecode"

    print("=== Steven Yi Csound Resources Downloader ===")
    print(f"Output directory: {output_dir}")
    print()

    # Create output directories
    libsyi_dir.mkdir(parents=True, exist_ok=True)
    livecode_dir.mkdir(parents=True, exist_ok=True)

    libsyi_files = []
    livecode_files = []

    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)

        # Clone and process libsyi
        print("Processing libsyi...")
        libsyi_repo = temp_path / "libsyi"
        clone_repo(LIBSYI_REPO, libsyi_repo)
        libsyi_files = process_libsyi(libsyi_repo, libsyi_dir)

        # Clone and process csound-live-code
        print("\nProcessing csound-live-code...")
        livecode_repo = temp_path / "csound-live-code"
        clone_repo(LIVECODE_REPO, livecode_repo)
        livecode_files = process_livecode(livecode_repo, livecode_dir)

    # Create index
    print("\nCreating index...")
    create_index(output_dir, libsyi_files, livecode_files)

    print()
    print("=== Complete ===")
    print(f"libsyi: {len(libsyi_files)} UDO files")
    print(f"csound-live-code: {len(livecode_files)} files")
    print(f"Output directory: {output_dir}")

    return 0


if __name__ == "__main__":
    exit(main())
