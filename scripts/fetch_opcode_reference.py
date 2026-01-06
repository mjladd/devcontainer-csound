#!/usr/bin/env python3
"""
Download and process the official Csound opcode reference for corpus integration.

This script:
1. Clones the official Csound manual from GitHub
2. Processes opcode documentation files
3. Extracts individual opcode entries with metadata
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
REPO_URL = "https://github.com/csound/manual.git"
MANUAL_URL = "https://csound.com/docs/manual/"


def clone_repository(temp_dir: Path) -> Path:
    """Clone the Csound manual repository."""
    print(f"Cloning repository to {temp_dir}...")
    subprocess.run(
        ["git", "clone", "--depth", "1", REPO_URL, str(temp_dir)],
        check=True,
        capture_output=True,
    )
    return temp_dir


def extract_opcode_metadata(content: str, filename: str) -> dict:
    """Extract metadata from opcode documentation."""
    metadata = {
        "name": filename.replace(".md", ""),
        "category": "",
        "description": "",
        "syntax": [],
        "related": [],
    }

    # Try to extract category from HTML comment
    # Format: <!-- opcode_id: xxx, category: yyy -->
    cat_match = re.search(r"category:\s*([^,\n>]+)", content)
    if cat_match:
        metadata["category"] = cat_match.group(1).strip()

    # Extract first paragraph as description (after the heading)
    desc_match = re.search(r"^#[^\n]+\n+([^\n#]+)", content, re.MULTILINE)
    if desc_match:
        metadata["description"] = desc_match.group(1).strip()

    # Extract syntax blocks
    syntax_matches = re.findall(r"```csound-orc\n(.*?)```", content, re.DOTALL)
    metadata["syntax"] = [s.strip() for s in syntax_matches]

    # Extract "See also" links
    see_also_match = re.search(r"##\s*See\s+[Aa]lso.*?\n(.*?)(?=\n##|\Z)", content, re.DOTALL)
    if see_also_match:
        links = re.findall(r"\[([^\]]+)\]", see_also_match.group(1))
        metadata["related"] = links

    return metadata


def extract_code_examples(content: str) -> list[dict]:
    """Extract Csound code examples from markdown content."""
    code_blocks = []
    # Match fenced code blocks with csound hints
    pattern = r"```(?:csound|csd|csound-csd)?\n(.*?)```"
    matches = re.finditer(pattern, content, re.DOTALL | re.IGNORECASE)

    for i, match in enumerate(matches):
        code = match.group(1).strip()
        # Only include complete CSD files
        if "<CsoundSynthesizer>" in code:
            code_blocks.append({"index": i, "code": code})

    return code_blocks


def process_opcode_file(
    source_path: Path,
    output_dir: Path,
    examples_dir: Path,
) -> Optional[dict]:
    """Process a single opcode documentation file."""
    content = source_path.read_text(encoding="utf-8", errors="replace")
    filename = source_path.name

    # Skip index and non-opcode files
    skip_patterns = ["index.md", "README.md", "CONTRIBUTING.md", "quickref", "Reference"]
    if any(pattern.lower() in filename.lower() for pattern in skip_patterns):
        return None

    # Extract metadata
    metadata = extract_opcode_metadata(content, filename)
    code_examples = extract_code_examples(content)

    # Create processed file with enhanced metadata header
    target_path = output_dir / filename

    metadata_header = f"""---
source: Csound Reference Manual
url: {MANUAL_URL}{filename.replace('.md', '.html')}
opcode: {metadata['name']}
category: {metadata['category']}
description: "{metadata['description'][:200]}..."
related: {json.dumps(metadata['related'][:10])}
---

"""
    target_path.write_text(metadata_header + content, encoding="utf-8")

    # Extract code examples as separate files
    for block in code_examples:
        example_id = f"{metadata['name']}_example_{block['index']:02d}"
        example_path = examples_dir / f"{example_id}.md"

        example_content = f"""# {metadata['name']} - Example {block['index'] + 1}

## Metadata

- **Source:** Csound Reference Manual
- **Opcode:** {metadata['name']}
- **Category:** {metadata['category']}
- **Tags:** `opcode-reference`, `{metadata['name']}`, `{metadata['category'].lower().replace(' ', '-') if metadata['category'] else 'uncategorized'}`

---

## Description

{metadata['description']}

---

## Code

```csound
{block['code']}
```

---

## Reference

See the full opcode documentation: [corpus/opcode_reference/opcodes/{filename}](../opcodes/{filename})
"""
        example_path.write_text(example_content, encoding="utf-8")

    return {
        "file": filename,
        "opcode": metadata["name"],
        "category": metadata["category"],
        "description": metadata["description"][:100],
        "code_examples": len(code_examples),
        "related": metadata["related"][:5],
    }


def process_gen_file(
    source_path: Path,
    output_dir: Path,
) -> Optional[dict]:
    """Process a GEN routine documentation file."""
    content = source_path.read_text(encoding="utf-8", errors="replace")
    filename = source_path.name

    # Skip index files
    if "index" in filename.lower():
        return None

    # Extract basic metadata
    title_match = re.search(r"^#\s+(.+)$", content, re.MULTILINE)
    title = title_match.group(1).strip() if title_match else filename

    # Add metadata header
    target_path = output_dir / filename
    metadata_header = f"""---
source: Csound Reference Manual
url: {MANUAL_URL}scoregens/{filename.replace('.md', '.html')}
type: GEN routine
title: "{title}"
---

"""
    target_path.write_text(metadata_header + content, encoding="utf-8")

    return {
        "file": filename,
        "title": title,
        "type": "GEN",
    }


def create_index(output_dir: Path, opcodes: list[dict], gens: list[dict]) -> None:
    """Create an index file for the corpus."""
    # Group opcodes by category
    categories = {}
    for op in opcodes:
        cat = op.get("category", "Uncategorized") or "Uncategorized"
        if cat not in categories:
            categories[cat] = []
        categories[cat].append(op)

    total_examples = sum(op.get("code_examples", 0) for op in opcodes)

    index_content = f"""# Csound Opcode Reference - Corpus Index

**Source:** {MANUAL_URL}
**Repository:** {REPO_URL}
**License:** LGPL
**Downloaded:** {datetime.now().strftime("%Y-%m-%d")}
**Total Opcodes:** {len(opcodes)}
**Total GEN Routines:** {len(gens)}
**Total Code Examples:** {total_examples}

## About This Corpus

This is a processed version of the official Csound Reference Manual, optimized for
use with AI assistants and RAG (Retrieval-Augmented Generation) systems.

### Directory Structure

- `opcodes/` - Individual opcode documentation with metadata headers
- `scoregens/` - GEN routine documentation
- `examples/` - Extracted runnable code examples

## Opcodes by Category

"""

    for cat in sorted(categories.keys()):
        ops = categories[cat]
        index_content += f"\n### {cat} ({len(ops)} opcodes)\n\n"
        for op in sorted(ops, key=lambda x: x["opcode"]):
            desc = op.get("description", "")[:60]
            examples = op.get("code_examples", 0)
            index_content += f"- [{op['opcode']}](opcodes/{op['file']})"
            if examples:
                index_content += f" ({examples} examples)"
            index_content += f" - {desc}...\n"

    index_content += "\n## GEN Routines\n\n"
    for gen in sorted(gens, key=lambda x: x["file"]):
        index_content += f"- [{gen['title']}](scoregens/{gen['file']})\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding="utf-8")

    # Save JSON index
    index_data = {
        "opcodes": opcodes,
        "gens": gens,
        "categories": {k: [o["opcode"] for o in v] for k, v in categories.items()},
    }
    (output_dir / "index.json").write_text(
        json.dumps(index_data, indent=2), encoding="utf-8"
    )


def main():
    # Determine paths
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "opcode_reference"
    opcodes_dir = output_dir / "opcodes"
    gens_dir = output_dir / "scoregens"
    examples_dir = output_dir / "examples"

    print("=== Csound Opcode Reference Downloader ===")
    print(f"Output directory: {output_dir}")
    print()

    # Create output directories
    opcodes_dir.mkdir(parents=True, exist_ok=True)
    gens_dir.mkdir(parents=True, exist_ok=True)
    examples_dir.mkdir(parents=True, exist_ok=True)

    # Clone repository to temp directory
    with tempfile.TemporaryDirectory() as temp_dir:
        repo_path = clone_repository(Path(temp_dir))

        # Find the docs directory
        docs_dir = repo_path / "docs"
        if not docs_dir.exists():
            print(f"Error: docs directory not found at {docs_dir}")
            return 1

        opcodes_src = docs_dir / "opcodes"
        gens_src = docs_dir / "scoregens"

        processed_opcodes = []
        processed_gens = []

        # Process opcode files
        if opcodes_src.exists():
            print("Processing opcode documentation...")
            for md_file in sorted(opcodes_src.glob("*.md")):
                result = process_opcode_file(md_file, opcodes_dir, examples_dir)
                if result:
                    processed_opcodes.append(result)
                    print(f"  {result['opcode']}: {result['code_examples']} examples")
        else:
            print(f"Warning: opcodes directory not found at {opcodes_src}")

        # Process GEN routine files
        if gens_src.exists():
            print("Processing GEN routine documentation...")
            for md_file in sorted(gens_src.glob("*.md")):
                result = process_gen_file(md_file, gens_dir)
                if result:
                    processed_gens.append(result)
                    print(f"  {result['title']}")
        else:
            print(f"Warning: scoregens directory not found at {gens_src}")

        # Copy example .csd files
        examples_src = docs_dir / "examples"
        if examples_src.exists():
            print("Copying example .csd files...")
            csd_count = 0
            for csd_file in examples_src.glob("*.csd"):
                shutil.copy(csd_file, examples_dir / csd_file.name)
                csd_count += 1
            print(f"  Copied {csd_count} .csd example files")

        # Create index
        print("Creating index...")
        create_index(output_dir, processed_opcodes, processed_gens)

    # Summary
    total_examples = sum(op.get("code_examples", 0) for op in processed_opcodes)
    print()
    print("=== Complete ===")
    print(f"Processed {len(processed_opcodes)} opcodes")
    print(f"Processed {len(processed_gens)} GEN routines")
    print(f"Extracted {total_examples} code examples")
    print(f"Output directory: {output_dir}")
    print()
    print("Directory structure:")
    print(f"  {output_dir}/")
    print("  ├── INDEX.md          # Human-readable index")
    print("  ├── index.json        # Machine-readable index")
    print("  ├── opcodes/          # Opcode documentation")
    print("  ├── scoregens/        # GEN routine documentation")
    print("  └── examples/         # Extracted code examples")

    return 0


if __name__ == "__main__":
    exit(main())
