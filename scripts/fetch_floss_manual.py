#!/usr/bin/env python3
"""
Download and process the Csound FLOSS Manual for corpus integration.

This script:
1. Clones the FLOSS manual from GitHub
2. Processes markdown files with metadata
3. Extracts code examples as separate corpus entries
4. Creates an index for easy navigation
"""

import os
import re
import json
import shutil
import subprocess
import tempfile
from pathlib import Path
from datetime import datetime
from typing import Optional

# Configuration
REPO_URL = "https://github.com/csound-flossmanual/csound-floss.git"
MANUAL_SOURCE_URL = "https://flossmanual.csound.com/"


def clone_repository(temp_dir: Path) -> Path:
    """Clone the FLOSS manual repository."""
    print(f"Cloning repository to {temp_dir}...")
    subprocess.run(
        ["git", "clone", "--depth", "1", REPO_URL, str(temp_dir)],
        check=True,
        capture_output=True,
    )
    return temp_dir


def extract_code_blocks(content: str) -> list[dict]:
    """Extract Csound code blocks from markdown content."""
    code_blocks = []
    # Match fenced code blocks with csound/csd language hint
    pattern = r"```(?:csound|csd|cs)?\n(.*?)```"
    matches = re.finditer(pattern, content, re.DOTALL | re.IGNORECASE)

    for i, match in enumerate(matches):
        code = match.group(1).strip()
        # Only include substantial code blocks
        if len(code) > 50 and ("<CsoundSynthesizer>" in code or "instr" in code):
            code_blocks.append({"index": i, "code": code})

    return code_blocks


def extract_title(content: str) -> str:
    """Extract the first heading as title."""
    match = re.search(r"^#\s+(.+)$", content, re.MULTILINE)
    return match.group(1).strip() if match else "Untitled"


def extract_section_context(content: str, code_start: int) -> str:
    """Extract surrounding section headings for context."""
    # Find the nearest preceding heading
    before_code = content[:code_start]
    headings = re.findall(r"^#{1,3}\s+(.+)$", before_code, re.MULTILINE)
    return headings[-1] if headings else ""


def process_markdown_file(
    source_path: Path,
    output_dir: Path,
    examples_dir: Path,
    chapter_id: str,
) -> dict:
    """Process a single markdown file."""
    content = source_path.read_text(encoding="utf-8")

    # Extract metadata
    title = extract_title(content)
    code_blocks = extract_code_blocks(content)

    # Create processed markdown with metadata header
    rel_path = source_path.name
    target_path = output_dir / rel_path

    metadata_header = f"""---
source: FLOSS Manual for Csound
url: {MANUAL_SOURCE_URL}
chapter: {chapter_id}
title: "{title}"
license: CC-BY-SA
code_examples: {len(code_blocks)}
---

"""
    target_path.write_text(metadata_header + content, encoding="utf-8")

    # Extract substantial code examples as separate corpus entries
    for block in code_blocks:
        if "<CsoundSynthesizer>" in block["code"]:
            example_id = f"{chapter_id}_example_{block['index']:02d}"
            example_path = examples_dir / f"{example_id}.md"

            # Find context for this code block
            code_pos = content.find(block["code"])
            section = extract_section_context(content, code_pos)

            example_content = f"""# {title} - Code Example {block['index'] + 1}

## Metadata

- **Source:** FLOSS Manual for Csound
- **Chapter:** {chapter_id}
- **Section:** {section}
- **Category:** Reference / Tutorial
- **Tags:** `floss-manual`, `tutorial`, `{chapter_id.split('-')[0] if '-' in chapter_id else 'csound'}`

---

## Code

```csound
{block['code']}
```

---

## Context

This code example is from the FLOSS Manual chapter "{title}".
See the full chapter for detailed explanation and context.

**Full chapter:** [corpus/floss_manual/chapters/{rel_path}](../chapters/{rel_path})
"""
            example_path.write_text(example_content, encoding="utf-8")

    return {
        "file": str(rel_path),
        "title": title,
        "chapter_id": chapter_id,
        "code_examples": len(code_blocks),
    }


def create_index(output_dir: Path, processed_files: list[dict]) -> None:
    """Create an index file for the corpus."""
    index_content = f"""# FLOSS Manual for Csound - Corpus Index

**Source:** {MANUAL_SOURCE_URL}
**Repository:** {REPO_URL}
**License:** CC-BY-SA
**Downloaded:** {datetime.now().strftime("%Y-%m-%d")}
**Total Chapters:** {len(processed_files)}
**Total Code Examples:** {sum(f['code_examples'] for f in processed_files)}

## About This Corpus

This is a processed version of the FLOSS Manual for Csound, optimized for
use with AI assistants and RAG (Retrieval-Augmented Generation) systems.

### Directory Structure

- `chapters/` - Full chapter content with metadata headers
- `examples/` - Extracted code examples as individual entries

## Chapters

| Chapter | Title | Code Examples |
|---------|-------|---------------|
"""

    for f in sorted(processed_files, key=lambda x: x["chapter_id"]):
        index_content += f"| {f['chapter_id']} | [{f['title']}](chapters/{f['file']}) | {f['code_examples']} |\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding="utf-8")

    # Also save as JSON for programmatic access
    (output_dir / "index.json").write_text(
        json.dumps(processed_files, indent=2), encoding="utf-8"
    )


def main():
    # Determine paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "floss_manual"
    chapters_dir = output_dir / "chapters"
    examples_dir = output_dir / "examples"

    print("=== Csound FLOSS Manual Downloader ===")
    print(f"Output directory: {output_dir}")
    print()

    # Create output directories
    chapters_dir.mkdir(parents=True, exist_ok=True)
    examples_dir.mkdir(parents=True, exist_ok=True)

    # Clone repository to temp directory
    with tempfile.TemporaryDirectory() as temp_dir:
        repo_path = clone_repository(Path(temp_dir))
        book_dir = repo_path / "book"

        if not book_dir.exists():
            print(f"Error: book directory not found at {book_dir}")
            return 1

        processed_files = []

        # Process all markdown files
        print("Processing markdown files...")
        for md_file in sorted(book_dir.rglob("*.md")):
            # Skip non-content files
            if md_file.name.startswith("_") or md_file.name == "README.md":
                continue

            # Create chapter ID from path
            rel_parts = md_file.relative_to(book_dir).parts
            chapter_id = "_".join(rel_parts).replace(".md", "")

            print(f"  Processing: {chapter_id}")

            result = process_markdown_file(
                md_file, chapters_dir, examples_dir, chapter_id
            )
            processed_files.append(result)

        # Create index
        print("Creating index...")
        create_index(output_dir, processed_files)

        # Copy resources if they exist
        resources_src = book_dir / "resources"
        if resources_src.exists():
            print("Copying resources...")
            resources_dst = output_dir / "resources"
            if resources_dst.exists():
                shutil.rmtree(resources_dst)
            shutil.copytree(resources_src, resources_dst)

    # Summary
    total_examples = sum(f["code_examples"] for f in processed_files)
    print()
    print("=== Complete ===")
    print(f"Processed {len(processed_files)} chapters")
    print(f"Extracted {total_examples} code examples")
    print(f"Output directory: {output_dir}")
    print()
    print("Directory structure:")
    print(f"  {output_dir}/")
    print("  ├── INDEX.md          # Human-readable index")
    print("  ├── index.json        # Machine-readable index")
    print("  ├── chapters/         # Full chapter content")
    print("  └── examples/         # Extracted code examples")

    return 0


if __name__ == "__main__":
    exit(main())
