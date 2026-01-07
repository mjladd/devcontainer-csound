#!/usr/bin/env python3
"""
Download Iain McCurdy's Csound Realtime Examples for corpus integration.

This script downloads examples from the csound.github.io repository.
"""

import os
import re
import json
import shutil
import subprocess
import tempfile
from pathlib import Path
from datetime import datetime
from collections import defaultdict

# Configuration
REPO_URL = "https://github.com/CsoundQt/CsoundQt.git"
EXAMPLES_PATH = "src/Examples/McCurdy Collection"


def clone_repo(temp_dir: Path) -> Path:
    """Clone the repository with sparse checkout for just the examples."""
    print("Cloning CsoundQt repository (this may take a moment)...")

    # Full clone with depth 1 (sparse checkout is complex, this is simpler)
    subprocess.run(
        ["git", "clone", "--depth", "1", REPO_URL, str(temp_dir)],
        check=True,
        capture_output=True,
    )
    return temp_dir


def extract_csd_metadata(content: str, filepath: Path) -> dict:
    """Extract metadata from a CSD file."""
    metadata = {
        "name": filepath.stem,
        "category": filepath.parent.name,
        "description": "",
        "author": "Iain McCurdy",
        "instruments": [],
        "opcodes_used": [],
    }

    # Extract description from comments
    desc_match = re.search(r"<CsoundSynthesizer>.*?;+\s*(.+?)(?=\n[^;\n]|\n<)", content, re.DOTALL)
    if desc_match:
        lines = [l.lstrip("; ").strip() for l in desc_match.group(1).split("\n") if l.strip().startswith(";")]
        metadata["description"] = " ".join(lines[:3])

    # Extract instrument names/numbers
    instr_matches = re.findall(r"instr\s+(\w+)", content)
    metadata["instruments"] = list(set(instr_matches))

    # Extract some key opcodes used
    key_opcodes = [
        "oscil", "poscil", "vco2", "grain", "fof", "pluck", "wgbow", "wgflute",
        "reverb", "freeverb", "reverbsc", "delay", "flanger", "phaser",
        "moogladder", "lowpass", "highpass", "bandpass", "butterlp", "butterhp",
        "pvsanal", "pvsynth", "pvscale", "pvshift", "partikkel", "granule",
        "diskin", "loscil", "flooper", "sndwarp"
    ]
    for opcode in key_opcodes:
        if re.search(rf"\b{opcode}\b", content, re.IGNORECASE):
            metadata["opcodes_used"].append(opcode)

    return metadata


def process_examples(repo_path: Path, output_dir: Path) -> dict:
    """Process all example files."""
    examples_src = repo_path / EXAMPLES_PATH

    if not examples_src.exists():
        print(f"Warning: Examples directory not found at {examples_src}")
        # Try alternative path
        alt_path = repo_path / "CsoundRealtimeExamples"
        if alt_path.exists():
            examples_src = alt_path
            print(f"Found examples at {alt_path}")
        else:
            return {"categories": {}, "files": []}

    categories = defaultdict(list)
    all_files = []

    # Walk through all directories
    for csd_file in sorted(examples_src.rglob("*.csd")):
        rel_path = csd_file.relative_to(examples_src)

        # Determine category from path
        parts = rel_path.parts
        if len(parts) > 1:
            category = "/".join(parts[:-1])
        else:
            category = "Uncategorized"

        content = csd_file.read_text(encoding="utf-8", errors="replace")
        metadata = extract_csd_metadata(content, csd_file)
        metadata["category"] = category
        metadata["rel_path"] = str(rel_path)

        # Create category directory
        cat_dir = output_dir / "examples" / category
        cat_dir.mkdir(parents=True, exist_ok=True)

        # Copy the CSD file
        shutil.copy(csd_file, cat_dir / csd_file.name)

        # Create markdown documentation
        md_content = f"""# {metadata['name']}

## Metadata

- **Source:** Iain McCurdy's Csound Realtime Examples
- **Category:** {category}
- **Author:** Iain McCurdy
- **License:** CC-BY-NC-SA 4.0
- **Instruments:** {', '.join(metadata['instruments']) if metadata['instruments'] else 'N/A'}
- **Key Opcodes:** {', '.join(metadata['opcodes_used']) if metadata['opcodes_used'] else 'N/A'}
- **Tags:** `mccurdy`, `realtime`, `{category.lower().replace('/', '-').replace(' ', '-')}`

---

## Description

{metadata['description'] if metadata['description'] else 'Interactive Csound example demonstrating synthesis or signal processing techniques.'}

---

## Code

```csound
{content}
```
"""
        md_path = cat_dir / f"{csd_file.stem}.md"
        md_path.write_text(md_content, encoding="utf-8")

        categories[category].append(metadata)
        all_files.append(metadata)

    return {"categories": dict(categories), "files": all_files}


def create_index(output_dir: Path, data: dict) -> None:
    """Create index file."""
    categories = data["categories"]
    total_files = len(data["files"])

    index_content = f"""# Iain McCurdy's Csound Realtime Examples - Corpus Index

**Source:** https://github.com/CsoundQt/CsoundQt (McCurdy Collection)
**Author:** Iain McCurdy
**License:** CC-BY-NC-SA 4.0
**Downloaded:** {datetime.now().strftime("%Y-%m-%d")}
**Total Examples:** {total_files}
**Categories:** {len(categories)}

## About

This corpus contains Iain McCurdy's Csound Realtime Examples, a comprehensive
collection of interactive examples demonstrating synthesis techniques, signal
processing, and Csound programming patterns.

## Categories

| Category | Examples |
|----------|----------|
"""
    for cat in sorted(categories.keys()):
        count = len(categories[cat])
        index_content += f"| [{cat}](examples/{cat}/) | {count} |\n"

    index_content += "\n## All Examples by Category\n"

    for cat in sorted(categories.keys()):
        index_content += f"\n### {cat}\n\n"
        for ex in sorted(categories[cat], key=lambda x: x["name"]):
            opcodes = ", ".join(ex["opcodes_used"][:3]) if ex["opcodes_used"] else ""
            index_content += f"- **{ex['name']}**"
            if opcodes:
                index_content += f" ({opcodes})"
            index_content += "\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding="utf-8")

    # JSON index
    (output_dir / "index.json").write_text(json.dumps(data, indent=2, default=str), encoding="utf-8")


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "mccurdy_examples"

    print("=== Iain McCurdy Realtime Examples Downloader ===")
    print(f"Output directory: {output_dir}")
    print()

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    with tempfile.TemporaryDirectory() as temp_dir:
        repo_path = clone_repo(Path(temp_dir))

        print("\nProcessing examples...")
        data = process_examples(repo_path, output_dir)

        if not data["files"]:
            print("No examples found!")
            return 1

        print(f"\nProcessed {len(data['files'])} examples in {len(data['categories'])} categories")

        # Create index
        print("Creating index...")
        create_index(output_dir, data)

    print()
    print("=== Complete ===")
    print(f"Total examples: {len(data['files'])}")
    print(f"Categories: {len(data['categories'])}")
    print(f"Output directory: {output_dir}")

    return 0


if __name__ == "__main__":
    exit(main())
