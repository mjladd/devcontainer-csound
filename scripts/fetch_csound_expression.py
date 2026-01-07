#!/usr/bin/env python3
"""
Fetch csound-expression tutorials and documentation for corpus.

csound-expression is a Haskell library for Csound that provides excellent
tutorials on synthesis concepts. While the code is Haskell, the concepts
and explanations are valuable for understanding Csound synthesis.

Usage:
    python3 fetch_csound_expression.py

Source: https://github.com/spell-music/csound-expression
"""

import os
import sys
import json
import re
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


def find_markdown_files(directory: Path) -> list[Path]:
    """Find all markdown documentation files."""
    return sorted(directory.rglob("*.md"))


def find_tutorial_files(directory: Path) -> list[Path]:
    """Find tutorial and documentation files."""
    files = []
    # Look in common documentation locations
    for subdir in ['tutorial', 'tutorials', 'doc', 'docs', 'guide']:
        doc_dir = directory / subdir
        if doc_dir.exists():
            files.extend(find_markdown_files(doc_dir))

    # Also get top-level markdown files
    for md_file in directory.glob("*.md"):
        if md_file not in files:
            files.append(md_file)

    return sorted(set(files))


def extract_csound_concepts(content: str) -> list[str]:
    """Extract Csound-related concepts mentioned in the content."""
    concepts = []

    # Common synthesis concepts
    concept_patterns = [
        r'\b(oscillator|oscil|osc)\b',
        r'\b(envelope|adsr|linen)\b',
        r'\b(filter|lowpass|highpass|bandpass|resonant)\b',
        r'\b(reverb|delay|echo)\b',
        r'\b(fm synthesis|frequency modulation)\b',
        r'\b(granular|grain)\b',
        r'\b(additive|subtractive)\b',
        r'\b(waveshaping|distortion)\b',
        r'\b(sampler|sample|soundfile)\b',
        r'\b(midi|note|frequency)\b',
        r'\b(lfo|modulation)\b',
        r'\b(noise|random)\b',
        r'\b(spectrum|spectral|fft)\b',
        r'\b(physical model|waveguide)\b',
    ]

    content_lower = content.lower()
    for pattern in concept_patterns:
        if re.search(pattern, content_lower):
            # Extract the concept name
            match = re.search(pattern, content_lower)
            if match:
                concept = match.group(1)
                if concept not in concepts:
                    concepts.append(concept)

    return concepts


def categorize_tutorial(filepath: Path, content: str) -> str:
    """Categorize a tutorial based on its content."""
    content_lower = content.lower()
    filename_lower = filepath.stem.lower()

    # Check for specific topics
    if 'intro' in filename_lower or 'getting started' in content_lower[:500]:
        return "Introduction"
    elif 'synth' in content_lower[:1000] or 'oscillator' in content_lower[:1000]:
        return "Synthesis"
    elif 'effect' in filename_lower or 'reverb' in content_lower or 'delay' in content_lower:
        return "Effects"
    elif 'sample' in filename_lower or 'soundfile' in content_lower:
        return "Sampling"
    elif 'midi' in filename_lower or 'midi' in content_lower[:500]:
        return "MIDI"
    elif 'signal' in content_lower[:500] or 'audio' in filename_lower:
        return "Signal Processing"
    elif 'event' in content_lower[:500] or 'score' in content_lower[:500]:
        return "Events and Scores"
    elif 'gui' in filename_lower or 'interface' in content_lower[:500]:
        return "GUI and Interface"

    return "General"


def process_markdown_file(filepath: Path, repo_dir: Path) -> dict:
    """Process a markdown file and extract relevant information."""
    try:
        content = filepath.read_text(encoding='utf-8', errors='replace')
    except:
        return None

    # Skip very short files or changelogs
    if len(content) < 200:
        return None
    if 'changelog' in filepath.stem.lower():
        return None

    rel_path = filepath.relative_to(repo_dir)

    # Extract title from first heading
    title_match = re.search(r'^#\s+(.+)$', content, re.MULTILINE)
    title = title_match.group(1).strip() if title_match else filepath.stem

    # Extract description (first paragraph after title)
    lines = content.split('\n')
    description = ""
    in_description = False
    for line in lines:
        if line.startswith('#'):
            if in_description:
                break
            in_description = True
            continue
        if in_description and line.strip():
            description += line.strip() + " "
        elif in_description and not line.strip() and description:
            break
    description = description.strip()[:500]

    concepts = extract_csound_concepts(content)
    category = categorize_tutorial(filepath, content)

    return {
        "title": title,
        "file": str(rel_path),
        "category": category,
        "concepts": concepts,
        "description": description,
        "content": content,
    }


def create_tutorial_markdown(info: dict) -> str:
    """Create corpus-friendly markdown from tutorial info."""
    concepts_str = ", ".join(info["concepts"]) if info["concepts"] else "General"

    md = f"""---
source: csound-expression (Haskell)
title: "{info['title']}"
file: {info['file']}
category: {info['category']}
concepts: [{concepts_str}]
type: tutorial
---

# {info['title']}

**Category:** {info['category']}
**Concepts:** {concepts_str}
**Original File:** `{info['file']}`

## Description

{info['description']}

---

{info['content']}
"""
    return md


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "csound_expression"
    temp_dir = project_root / ".cache" / "csound_expression_repo"

    print("=== csound-expression Tutorials Fetcher ===")
    print(f"Output: {output_dir}")
    print()

    # Clone/update main repo
    print("Fetching csound-expression repository...")
    repo_url = "https://github.com/spell-music/csound-expression.git"

    temp_dir.parent.mkdir(parents=True, exist_ok=True)
    if not clone_or_update_repo(repo_url, temp_dir):
        print("Error: Failed to clone repository")
        return 1

    # Also try to get the wiki or tutorial repo if it exists
    wiki_dir = project_root / ".cache" / "csound_expression_wiki"
    wiki_url = "https://github.com/spell-music/csound-expression.wiki.git"
    print("Attempting to fetch wiki...")
    clone_or_update_repo(wiki_url, wiki_dir)

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    # Find all tutorial/documentation files
    print("Finding documentation files...")
    all_files = find_tutorial_files(temp_dir)

    # Also check wiki
    if wiki_dir.exists():
        all_files.extend(find_markdown_files(wiki_dir))

    print(f"  Found {len(all_files)} documentation files")

    # Process files
    print("Processing tutorials...")
    tutorials_by_category = {}
    processed = 0

    for filepath in all_files:
        info = process_markdown_file(filepath, filepath.parent.parent if 'wiki' in str(filepath) else temp_dir)
        if not info:
            continue

        category = info["category"]
        if category not in tutorials_by_category:
            tutorials_by_category[category] = []

        # Create category directory
        category_dir = output_dir / category.lower().replace(" ", "_")
        category_dir.mkdir(exist_ok=True)

        # Write markdown
        md_content = create_tutorial_markdown(info)
        safe_name = re.sub(r'[^\w\-]', '_', info["title"])[:50]
        md_filename = f"{safe_name}.md"

        (category_dir / md_filename).write_text(md_content, encoding='utf-8')

        tutorials_by_category[category].append({
            "title": info["title"],
            "file": f"{category.lower().replace(' ', '_')}/{md_filename}",
            "concepts": info["concepts"],
            "description": info["description"][:200],
        })
        processed += 1

    print(f"  Processed {processed} tutorials")

    # Create index
    print("Creating index...")
    all_concepts = set()
    for cat_tutorials in tutorials_by_category.values():
        for t in cat_tutorials:
            all_concepts.update(t["concepts"])

    index_content = f"""# csound-expression Tutorials - Corpus Index

**Source:** https://github.com/spell-music/csound-expression
**Fetched:** {datetime.now().strftime("%Y-%m-%d")}
**Total Tutorials:** {processed}
**Categories:** {len(tutorials_by_category)}

## About

csound-expression is a Haskell library that provides a high-level interface
to Csound. While the code examples are in Haskell, the tutorials contain
excellent explanations of synthesis concepts, signal processing, and
sound design principles that apply to Csound programming in general.

## Why This is Valuable

- Clear explanations of synthesis techniques
- Well-structured approach to sound design
- Covers oscillators, envelopes, filters, effects
- Explains signal flow and modulation
- Good examples of combining techniques

## Concepts Covered

{', '.join(sorted(all_concepts))}

## Tutorials by Category

"""

    for category in sorted(tutorials_by_category.keys()):
        tutorials = tutorials_by_category[category]
        index_content += f"### {category} ({len(tutorials)} tutorials)\n\n"
        for t in sorted(tutorials, key=lambda x: x["title"]):
            desc = f" - {t['description']}" if t['description'] else ""
            index_content += f"- [{t['title']}]({t['file']}){desc}\n"
        index_content += "\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding='utf-8')

    # JSON index
    (output_dir / "index.json").write_text(
        json.dumps({
            "tutorials": tutorials_by_category,
            "concepts": sorted(all_concepts),
        }, indent=2),
        encoding='utf-8'
    )

    print()
    print("=== Complete ===")
    print(f"Processed {processed} tutorials in {len(tutorials_by_category)} categories")
    print(f"Concepts covered: {', '.join(sorted(all_concepts)[:10])}...")
    print(f"Output: {output_dir}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
