#!/usr/bin/env python3
"""
Fetch Cabbage examples for Csound corpus.

Cabbage is a framework for building audio plugins and standalone instruments
using Csound. The examples demonstrate GUI widgets, plugin development, and
practical instrument design.

Usage:
    python3 fetch_cabbage_examples.py

Source: https://github.com/rorywalsh/cabbage
"""

import os
import sys
import json
import shutil
import subprocess
from pathlib import Path
from datetime import datetime


def clone_or_update_repo(repo_url: str, target_dir: Path) -> bool:
    """Clone a repo or update if it exists."""
    if target_dir.exists():
        print(f"  Updating existing repo...")
        result = subprocess.run(
            ["git", "-C", str(target_dir), "pull", "--ff-only"],
            capture_output=True,
            text=True
        )
        return result.returncode == 0
    else:
        print(f"  Cloning {repo_url}...")
        result = subprocess.run(
            ["git", "clone", "--depth", "1", repo_url, str(target_dir)],
            capture_output=True,
            text=True
        )
        return result.returncode == 0


def find_csound_files(directory: Path) -> list[Path]:
    """Find all Csound-related files in a directory."""
    extensions = {'.csd', '.orc', '.sco', '.udo'}
    files = []
    for ext in extensions:
        files.extend(directory.rglob(f"*{ext}"))
    return sorted(files)


def extract_cabbage_metadata(content: str) -> dict:
    """Extract metadata from Cabbage file."""
    metadata = {
        "has_cabbage_section": "<Cabbage>" in content,
        "widgets": [],
        "form_caption": None,
    }

    # Extract Cabbage section
    if "<Cabbage>" in content and "</Cabbage>" in content:
        start = content.index("<Cabbage>") + len("<Cabbage>")
        end = content.index("</Cabbage>")
        cabbage_section = content[start:end]

        # Find widget types
        import re
        widget_pattern = r'^(\w+)'
        for line in cabbage_section.split('\n'):
            line = line.strip()
            if line and not line.startswith(';'):
                match = re.match(widget_pattern, line)
                if match:
                    widget = match.group(1)
                    if widget not in metadata["widgets"]:
                        metadata["widgets"].append(widget)

        # Find form caption
        caption_match = re.search(r'text\s*\(\s*"([^"]+)"', cabbage_section)
        if caption_match:
            metadata["form_caption"] = caption_match.group(1)

    return metadata


def categorize_example(filepath: Path, content: str) -> str:
    """Categorize an example based on path and content."""
    path_str = str(filepath).lower()

    # Check path for category hints
    if "effect" in path_str or "fx" in path_str:
        return "Effects"
    elif "synth" in path_str or "instrument" in path_str:
        return "Synthesizers"
    elif "midi" in path_str:
        return "MIDI"
    elif "widget" in path_str or "gui" in path_str:
        return "Widgets"
    elif "util" in path_str or "misc" in path_str:
        return "Utilities"
    elif "sample" in path_str or "sampler" in path_str:
        return "Samplers"

    # Check content for hints
    content_lower = content.lower()
    if "reverb" in content_lower or "delay" in content_lower or "filter" in content_lower:
        return "Effects"
    elif "oscil" in content_lower and "midi" in content_lower:
        return "Synthesizers"

    return "General"


def create_markdown(filepath: Path, content: str, repo_dir: Path) -> str:
    """Create markdown documentation for a Cabbage example."""
    rel_path = filepath.relative_to(repo_dir)
    metadata = extract_cabbage_metadata(content)
    category = categorize_example(filepath, content)

    # Extract description from comments
    description = ""
    for line in content.split('\n')[:20]:
        if line.strip().startswith(';'):
            desc_line = line.strip()[1:].strip()
            if desc_line and not desc_line.startswith('='):
                description += desc_line + " "
    description = description.strip()[:500] if description else "Cabbage example instrument."

    title = metadata.get("form_caption") or filepath.stem
    widgets_str = ", ".join(metadata["widgets"][:10]) if metadata["widgets"] else "None"

    md = f"""---
source: Cabbage Examples
category: {category}
file: {rel_path}
title: "{title}"
type: cabbage_example
widgets: [{widgets_str}]
---

# {title}

**Category:** {category}
**Source File:** `{rel_path}`
**Cabbage Widgets:** {widgets_str}

## Description

{description}

## Code

```csound
{content}
```
"""
    return md


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "cabbage_examples"
    temp_dir = project_root / ".cache" / "cabbage_repo"

    print("=== Cabbage Examples Fetcher ===")
    print(f"Output: {output_dir}")
    print()

    # Clone/update repo
    print("Fetching Cabbage repository...")
    repo_url = "https://github.com/rorywalsh/cabbage.git"

    temp_dir.parent.mkdir(parents=True, exist_ok=True)
    if not clone_or_update_repo(repo_url, temp_dir):
        print("Error: Failed to clone repository")
        return 1

    # Find example directories
    example_dirs = [
        temp_dir / "Examples",
        temp_dir / "examples",
        temp_dir / "Docs" / "Examples",
    ]

    # Find all .csd files
    print("Finding Cabbage examples...")
    all_files = []
    for example_dir in example_dirs:
        if example_dir.exists():
            all_files.extend(find_csound_files(example_dir))

    # Also check root for any examples
    if not all_files:
        all_files = find_csound_files(temp_dir)

    if not all_files:
        print("Warning: No example files found in expected locations")
        print("Searching entire repository...")
        all_files = find_csound_files(temp_dir)

    print(f"  Found {len(all_files)} Csound files")

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    # Process files
    print("Processing examples...")
    examples_by_category = {}
    processed = 0

    for filepath in all_files:
        try:
            content = filepath.read_text(encoding='utf-8', errors='replace')

            # Skip very small files or non-Cabbage files
            if len(content) < 50:
                continue

            category = categorize_example(filepath, content)
            if category not in examples_by_category:
                examples_by_category[category] = []

            # Create markdown
            md_content = create_markdown(filepath, content, temp_dir)

            # Write to category subdirectory
            category_dir = output_dir / category.lower().replace(" ", "_")
            category_dir.mkdir(exist_ok=True)

            md_filename = filepath.stem + ".md"
            (category_dir / md_filename).write_text(md_content, encoding='utf-8')

            examples_by_category[category].append({
                "name": filepath.stem,
                "file": f"{category.lower().replace(' ', '_')}/{md_filename}",
                "original": str(filepath.relative_to(temp_dir)),
            })
            processed += 1

        except Exception as e:
            print(f"  Warning: Error processing {filepath.name}: {e}")

    print(f"  Processed {processed} examples")

    # Create index
    print("Creating index...")
    index_content = f"""# Cabbage Examples - Corpus Index

**Source:** https://github.com/rorywalsh/cabbage
**Fetched:** {datetime.now().strftime("%Y-%m-%d")}
**Total Examples:** {processed}

## About

Cabbage is a framework for developing audio plugins and standalone instruments
using the Csound audio programming language. These examples demonstrate
GUI widgets, plugin architecture, and practical instrument design.

## Categories

"""
    for category in sorted(examples_by_category.keys()):
        examples = examples_by_category[category]
        index_content += f"### {category} ({len(examples)} examples)\n\n"
        for ex in sorted(examples, key=lambda x: x["name"]):
            index_content += f"- [{ex['name']}]({ex['file']})\n"
        index_content += "\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding='utf-8')

    # JSON index
    (output_dir / "index.json").write_text(
        json.dumps(examples_by_category, indent=2),
        encoding='utf-8'
    )

    print()
    print("=== Complete ===")
    print(f"Processed {processed} examples in {len(examples_by_category)} categories")
    print(f"Output: {output_dir}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
