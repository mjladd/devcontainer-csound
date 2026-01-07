#!/usr/bin/env python3
"""
Fetch Blue examples for Csound corpus.

Blue is a music composition environment for Csound by Steven Yi.
It provides a timeline-based interface for composing with Csound instruments.

Usage:
    python3 fetch_blue_examples.py

Source: https://github.com/kunstmusik/blue
"""

import os
import sys
import json
import shutil
import subprocess
import xml.etree.ElementTree as ET
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


def find_blue_files(directory: Path) -> list[Path]:
    """Find all Blue project files."""
    return sorted(directory.rglob("*.blue"))


def find_csound_files(directory: Path) -> list[Path]:
    """Find all Csound-related files in a directory."""
    extensions = {'.csd', '.orc', '.sco', '.udo'}
    files = []
    for ext in extensions:
        files.extend(directory.rglob(f"*{ext}"))
    return sorted(files)


def extract_blue_project_info(filepath: Path) -> dict:
    """Extract information from a Blue project file."""
    info = {
        "title": filepath.stem,
        "instruments": [],
        "global_orc": "",
        "description": "",
    }

    try:
        tree = ET.parse(filepath)
        root = tree.getroot()

        # Try to find project name
        name_elem = root.find(".//projectName")
        if name_elem is not None and name_elem.text:
            info["title"] = name_elem.text

        # Extract global orchestra
        global_orc = root.find(".//globalOrcSco/globalOrc")
        if global_orc is not None and global_orc.text:
            info["global_orc"] = global_orc.text

        # Extract instruments
        for instr in root.findall(".//instrument"):
            name_elem = instr.find("name")
            code_elem = instr.find("code")
            if name_elem is not None:
                instr_info = {
                    "name": name_elem.text or "Unnamed",
                    "code": code_elem.text if code_elem is not None else ""
                }
                info["instruments"].append(instr_info)

        # Look for UDOs
        for udo in root.findall(".//udo"):
            name_elem = udo.find("name")
            code_elem = udo.find("code")
            if name_elem is not None:
                info["instruments"].append({
                    "name": f"UDO: {name_elem.text}",
                    "code": code_elem.text if code_elem is not None else ""
                })

    except ET.ParseError as e:
        print(f"  Warning: Could not parse {filepath.name}: {e}")
    except Exception as e:
        print(f"  Warning: Error reading {filepath.name}: {e}")

    return info


def create_blue_markdown(filepath: Path, info: dict, repo_dir: Path) -> str:
    """Create markdown documentation for a Blue project."""
    rel_path = filepath.relative_to(repo_dir)

    md = f"""---
source: Blue Examples
file: {rel_path}
title: "{info['title']}"
type: blue_project
instrument_count: {len(info['instruments'])}
---

# {info['title']}

**Source File:** `{rel_path}`
**Instruments:** {len(info['instruments'])}

## Description

Blue composition project demonstrating Csound instrument design and composition techniques.

"""

    if info["global_orc"]:
        md += f"""## Global Orchestra

```csound
{info['global_orc']}
```

"""

    if info["instruments"]:
        md += "## Instruments\n\n"
        for instr in info["instruments"]:
            md += f"### {instr['name']}\n\n"
            if instr["code"]:
                md += f"""```csound
{instr['code']}
```

"""

    return md


def create_csd_markdown(filepath: Path, content: str, repo_dir: Path) -> str:
    """Create markdown for a standalone CSD file."""
    rel_path = filepath.relative_to(repo_dir)

    # Extract description from comments
    description = ""
    for line in content.split('\n')[:20]:
        if line.strip().startswith(';'):
            desc_line = line.strip()[1:].strip()
            if desc_line:
                description += desc_line + " "
    description = description.strip()[:500] if description else "Blue example file."

    md = f"""---
source: Blue Examples
file: {rel_path}
title: "{filepath.stem}"
type: csound_file
---

# {filepath.stem}

**Source File:** `{rel_path}`

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
    output_dir = project_root / "corpus" / "blue_examples"
    temp_dir = project_root / ".cache" / "blue_repo"

    print("=== Blue Examples Fetcher ===")
    print(f"Output: {output_dir}")
    print()

    # Clone/update repo
    print("Fetching Blue repository...")
    repo_url = "https://github.com/kunstmusik/blue.git"

    temp_dir.parent.mkdir(parents=True, exist_ok=True)
    if not clone_or_update_repo(repo_url, temp_dir):
        print("Error: Failed to clone repository")
        return 1

    # Find example directories
    example_dirs = [
        temp_dir / "examples",
        temp_dir / "Examples",
        temp_dir / "blue-core" / "examples",
    ]

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    # Find all Blue project files
    print("Finding Blue projects...")
    blue_files = []
    for example_dir in example_dirs:
        if example_dir.exists():
            blue_files.extend(find_blue_files(example_dir))

    # Also search entire repo
    if not blue_files:
        blue_files = find_blue_files(temp_dir)

    print(f"  Found {len(blue_files)} Blue project files")

    # Find standalone CSD files
    csd_files = []
    for example_dir in example_dirs:
        if example_dir.exists():
            csd_files.extend(find_csound_files(example_dir))
    if not csd_files:
        csd_files = find_csound_files(temp_dir)

    print(f"  Found {len(csd_files)} CSD files")

    # Process Blue projects
    print("Processing Blue projects...")
    projects = []
    blue_dir = output_dir / "projects"
    blue_dir.mkdir(exist_ok=True)

    for filepath in blue_files:
        try:
            info = extract_blue_project_info(filepath)
            md_content = create_blue_markdown(filepath, info, temp_dir)

            md_filename = filepath.stem + ".md"
            (blue_dir / md_filename).write_text(md_content, encoding='utf-8')

            projects.append({
                "name": info["title"],
                "file": f"projects/{md_filename}",
                "original": str(filepath.relative_to(temp_dir)),
                "instruments": len(info["instruments"]),
            })
        except Exception as e:
            print(f"  Warning: Error processing {filepath.name}: {e}")

    print(f"  Processed {len(projects)} Blue projects")

    # Process CSD files
    print("Processing CSD files...")
    csd_examples = []
    csd_dir = output_dir / "csound_files"
    csd_dir.mkdir(exist_ok=True)

    for filepath in csd_files:
        try:
            content = filepath.read_text(encoding='utf-8', errors='replace')
            if len(content) < 50:
                continue

            md_content = create_csd_markdown(filepath, content, temp_dir)

            md_filename = filepath.stem + ".md"
            (csd_dir / md_filename).write_text(md_content, encoding='utf-8')

            csd_examples.append({
                "name": filepath.stem,
                "file": f"csound_files/{md_filename}",
                "original": str(filepath.relative_to(temp_dir)),
            })
        except Exception as e:
            print(f"  Warning: Error processing {filepath.name}: {e}")

    print(f"  Processed {len(csd_examples)} CSD files")

    # Create index
    print("Creating index...")
    total = len(projects) + len(csd_examples)

    index_content = f"""# Blue Examples - Corpus Index

**Source:** https://github.com/kunstmusik/blue
**Author:** Steven Yi
**Fetched:** {datetime.now().strftime("%Y-%m-%d")}
**Total Examples:** {total}

## About

Blue is a music composition environment for Csound created by Steven Yi.
It provides a timeline-based interface, instrument library management,
and advanced composition tools for working with Csound.

## Blue Projects ({len(projects)})

Blue project files (.blue) containing instruments and compositions:

"""
    for proj in sorted(projects, key=lambda x: x["name"]):
        index_content += f"- [{proj['name']}]({proj['file']}) - {proj['instruments']} instruments\n"

    index_content += f"""
## Csound Files ({len(csd_examples)})

Standalone Csound files (.csd, .orc, .udo):

"""
    for ex in sorted(csd_examples, key=lambda x: x["name"]):
        index_content += f"- [{ex['name']}]({ex['file']})\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding='utf-8')

    # JSON index
    index_data = {
        "projects": projects,
        "csound_files": csd_examples,
    }
    (output_dir / "index.json").write_text(
        json.dumps(index_data, indent=2),
        encoding='utf-8'
    )

    print()
    print("=== Complete ===")
    print(f"Processed {len(projects)} Blue projects and {len(csd_examples)} CSD files")
    print(f"Output: {output_dir}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
