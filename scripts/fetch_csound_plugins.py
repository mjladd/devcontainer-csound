#!/usr/bin/env python3
"""
Fetch Csound Plugins documentation and examples for corpus.

The csound/plugins repository contains community-contributed opcodes
that extend Csound's capabilities.

Usage:
    python3 fetch_csound_plugins.py

Source: https://github.com/csound/plugins
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


def find_source_files(directory: Path) -> list[Path]:
    """Find C/C++ source files that likely contain opcode implementations."""
    extensions = {'.c', '.cpp', '.h', '.hpp'}
    files = []
    for ext in extensions:
        files.extend(directory.rglob(f"*{ext}"))
    return sorted(files)


def find_doc_files(directory: Path) -> list[Path]:
    """Find documentation files."""
    extensions = {'.md', '.txt', '.rst', '.html'}
    files = []
    for ext in extensions:
        files.extend(directory.rglob(f"*{ext}"))
    return sorted(files)


def find_example_files(directory: Path) -> list[Path]:
    """Find Csound example files."""
    extensions = {'.csd', '.orc', '.sco'}
    files = []
    for ext in extensions:
        files.extend(directory.rglob(f"*{ext}"))
    return sorted(files)


def extract_opcodes_from_source(filepath: Path) -> list[dict]:
    """Extract opcode definitions from C/C++ source files."""
    opcodes = []
    try:
        content = filepath.read_text(encoding='utf-8', errors='replace')

        # Pattern for Csound opcode registration
        # Look for patterns like: {"opcodename", sizeof(...), ...}
        # or OENTRY patterns
        patterns = [
            r'"(\w+)",\s*S\(([^)]+)\)',  # Common pattern
            r'{\s*"(\w+)"\s*,',  # Simple registration
            r'OENTRY\s*\(\s*"(\w+)"',  # OENTRY macro
        ]

        for pattern in patterns:
            for match in re.finditer(pattern, content):
                opcode_name = match.group(1)
                if opcode_name and len(opcode_name) > 1:
                    # Skip common false positives
                    if opcode_name.lower() not in {'if', 'else', 'for', 'while', 'int', 'float', 'void'}:
                        opcodes.append({
                            "name": opcode_name,
                            "source_file": filepath.name,
                        })

    except Exception as e:
        pass

    return opcodes


def extract_plugin_info(plugin_dir: Path) -> dict:
    """Extract information about a plugin from its directory."""
    info = {
        "name": plugin_dir.name,
        "description": "",
        "opcodes": [],
        "examples": [],
        "readme": "",
    }

    # Look for README
    for readme_name in ['README.md', 'README.txt', 'README', 'readme.md']:
        readme_path = plugin_dir / readme_name
        if readme_path.exists():
            try:
                info["readme"] = readme_path.read_text(encoding='utf-8', errors='replace')
                # Extract first paragraph as description
                lines = info["readme"].split('\n')
                desc_lines = []
                for line in lines:
                    if line.strip() and not line.startswith('#'):
                        desc_lines.append(line.strip())
                    elif desc_lines:
                        break
                info["description"] = ' '.join(desc_lines)[:500]
            except:
                pass
            break

    # Find opcodes from source files
    for src_file in find_source_files(plugin_dir):
        opcodes = extract_opcodes_from_source(src_file)
        for op in opcodes:
            if op not in info["opcodes"]:
                info["opcodes"].append(op)

    # Find examples
    for ex_file in find_example_files(plugin_dir):
        try:
            content = ex_file.read_text(encoding='utf-8', errors='replace')
            info["examples"].append({
                "name": ex_file.stem,
                "file": ex_file.name,
                "content": content,
            })
        except:
            pass

    return info


def create_plugin_markdown(plugin_info: dict, plugin_dir: Path, repo_dir: Path) -> str:
    """Create markdown documentation for a plugin."""
    rel_path = plugin_dir.relative_to(repo_dir)

    md = f"""---
source: Csound Plugins Repository
plugin: {plugin_info['name']}
path: {rel_path}
type: csound_plugin
opcode_count: {len(plugin_info['opcodes'])}
example_count: {len(plugin_info['examples'])}
---

# {plugin_info['name']}

**Source Path:** `{rel_path}`
**Opcodes:** {len(plugin_info['opcodes'])}
**Examples:** {len(plugin_info['examples'])}

## Description

{plugin_info['description'] or 'Community-contributed Csound plugin.'}

"""

    if plugin_info['opcodes']:
        md += "## Opcodes\n\n"
        seen = set()
        for op in plugin_info['opcodes']:
            if op['name'] not in seen:
                md += f"- `{op['name']}`\n"
                seen.add(op['name'])
        md += "\n"

    if plugin_info['examples']:
        md += "## Examples\n\n"
        for ex in plugin_info['examples']:
            md += f"### {ex['name']}\n\n"
            md += f"```csound\n{ex['content']}\n```\n\n"

    if plugin_info['readme'] and len(plugin_info['readme']) > len(plugin_info['description']) + 100:
        md += "## Full Documentation\n\n"
        md += plugin_info['readme']

    return md


def main():
    script_dir = Path(__file__).parent
    project_root = script_dir.parent
    output_dir = project_root / "corpus" / "csound_plugins"
    temp_dir = project_root / ".cache" / "csound_plugins_repo"

    print("=== Csound Plugins Fetcher ===")
    print(f"Output: {output_dir}")
    print()

    # Clone/update repo
    print("Fetching Csound plugins repository...")
    repo_url = "https://github.com/csound/plugins.git"

    temp_dir.parent.mkdir(parents=True, exist_ok=True)
    if not clone_or_update_repo(repo_url, temp_dir):
        print("Error: Failed to clone repository")
        return 1

    # Create output directory
    output_dir.mkdir(parents=True, exist_ok=True)

    # Find plugin directories (directories containing CMakeLists.txt or source files)
    print("Finding plugins...")
    plugin_dirs = []

    for item in temp_dir.iterdir():
        if item.is_dir() and not item.name.startswith('.'):
            # Check if it looks like a plugin directory
            has_source = any(find_source_files(item))
            has_cmake = (item / "CMakeLists.txt").exists()
            if has_source or has_cmake:
                plugin_dirs.append(item)

    print(f"  Found {len(plugin_dirs)} plugin directories")

    # Process each plugin
    print("Processing plugins...")
    plugins = []
    all_opcodes = []

    for plugin_dir in plugin_dirs:
        try:
            info = extract_plugin_info(plugin_dir)

            if info["opcodes"] or info["examples"] or info["readme"]:
                md_content = create_plugin_markdown(info, plugin_dir, temp_dir)

                md_filename = plugin_dir.name + ".md"
                (output_dir / md_filename).write_text(md_content, encoding='utf-8')

                plugins.append({
                    "name": info["name"],
                    "file": md_filename,
                    "opcodes": len(info["opcodes"]),
                    "examples": len(info["examples"]),
                    "description": info["description"][:200] if info["description"] else "",
                })

                for op in info["opcodes"]:
                    op["plugin"] = info["name"]
                    all_opcodes.append(op)

                print(f"  {info['name']}: {len(info['opcodes'])} opcodes, {len(info['examples'])} examples")

        except Exception as e:
            print(f"  Warning: Error processing {plugin_dir.name}: {e}")

    # Also find standalone examples in the repo
    print("Finding standalone examples...")
    examples_dir = output_dir / "examples"
    examples_dir.mkdir(exist_ok=True)
    standalone_examples = []

    for ex_file in find_example_files(temp_dir):
        # Skip if already processed as part of a plugin
        if any(p["name"] in str(ex_file) for p in plugins):
            continue

        try:
            content = ex_file.read_text(encoding='utf-8', errors='replace')
            if len(content) < 50:
                continue

            rel_path = ex_file.relative_to(temp_dir)
            md_content = f"""---
source: Csound Plugins Repository
file: {rel_path}
type: csound_example
---

# {ex_file.stem}

**Source:** `{rel_path}`

```csound
{content}
```
"""
            md_filename = ex_file.stem + ".md"
            (examples_dir / md_filename).write_text(md_content, encoding='utf-8')

            standalone_examples.append({
                "name": ex_file.stem,
                "file": f"examples/{md_filename}",
            })

        except Exception as e:
            pass

    print(f"  Found {len(standalone_examples)} standalone examples")

    # Create index
    print("Creating index...")
    total_opcodes = len(set(op["name"] for op in all_opcodes))

    index_content = f"""# Csound Plugins - Corpus Index

**Source:** https://github.com/csound/plugins
**Fetched:** {datetime.now().strftime("%Y-%m-%d")}
**Plugins:** {len(plugins)}
**Unique Opcodes:** {total_opcodes}
**Examples:** {len(standalone_examples)}

## About

The Csound plugins repository contains community-contributed opcodes
that extend Csound's capabilities. These plugins cover areas like:
- Audio analysis and feature extraction
- Physical modeling
- Spectral processing
- Machine learning integration
- Hardware interfaces

## Plugins

"""
    for plugin in sorted(plugins, key=lambda x: x["name"]):
        desc = f" - {plugin['description']}" if plugin['description'] else ""
        index_content += f"- [{plugin['name']}]({plugin['file']}) ({plugin['opcodes']} opcodes){desc}\n"

    if standalone_examples:
        index_content += "\n## Standalone Examples\n\n"
        for ex in sorted(standalone_examples, key=lambda x: x["name"]):
            index_content += f"- [{ex['name']}]({ex['file']})\n"

    index_content += "\n## All Opcodes\n\n"
    seen_opcodes = {}
    for op in all_opcodes:
        if op["name"] not in seen_opcodes:
            seen_opcodes[op["name"]] = op["plugin"]

    for name in sorted(seen_opcodes.keys()):
        index_content += f"- `{name}` ({seen_opcodes[name]})\n"

    (output_dir / "INDEX.md").write_text(index_content, encoding='utf-8')

    # JSON index
    index_data = {
        "plugins": plugins,
        "opcodes": list(seen_opcodes.keys()),
        "examples": standalone_examples,
    }
    (output_dir / "index.json").write_text(
        json.dumps(index_data, indent=2),
        encoding='utf-8'
    )

    print()
    print("=== Complete ===")
    print(f"Processed {len(plugins)} plugins with {total_opcodes} unique opcodes")
    print(f"Output: {output_dir}")

    return 0


if __name__ == "__main__":
    sys.exit(main())
