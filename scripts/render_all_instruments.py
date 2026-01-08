#!/usr/bin/env python3
"""
Script to render all .csd files from csound_examples directory
Output: renders/instruments directory
"""

import os
import subprocess
import sys
from pathlib import Path
import tempfile
import shutil

# Set directories
SOURCE_DIR = Path("/workspaces/devcontainer-csound/csound_examples")
OUTPUT_DIR = Path("/workspaces/devcontainer-csound/renders/instruments")

# Create output directory if it doesn't exist
OUTPUT_DIR.mkdir(parents=True, exist_ok=True)

# Counter for statistics
total = 0
success = 0
failed = 0
skipped = 0

def modify_csd_for_rendering(csd_path, output_wav):
    """
    Read a .csd file and modify the CsOptions to render to a wav file.
    Returns the path to the modified temp file.
    """
    with open(csd_path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()

    # Replace <CsOptions> section to output to wav file
    # Look for <CsOptions>...</CsOptions> and replace the content
    import re

    # New options for rendering to file
    new_options = f'<CsOptions>\n-o {output_wav} -W -d\n</CsOptions>'

    # Replace the CsOptions section
    pattern = r'<CsOptions>.*?</CsOptions>'
    modified_content = re.sub(pattern, new_options, content, flags=re.DOTALL)

    # If no CsOptions section was found, add one after <CsoundSynthesizer>
    if '<CsOptions>' not in content:
        modified_content = modified_content.replace(
            '<CsoundSynthesizer>',
            f'<CsoundSynthesizer>\n{new_options}'
        )

    # Write to temporary file
    temp_fd, temp_path = tempfile.mkstemp(suffix='.csd', text=True)
    with os.fdopen(temp_fd, 'w', encoding='utf-8') as f:
        f.write(modified_content)

    return temp_path

def render_csd(csd_file, output_file):
    """
    Render a single .csd file to wav.
    Returns True if successful, False otherwise.
    """
    try:
        # Create modified version of CSD file
        temp_csd = modify_csd_for_rendering(csd_file, output_file)

        # Run csound with timeout
        result = subprocess.run(
            ['csound', temp_csd],
            capture_output=True,
            text=True,
            timeout=30,
            cwd=csd_file.parent  # Run from the source directory
        )

        # Clean up temp file
        os.unlink(temp_csd)

        # Check if output file was created and has content
        if output_file.exists() and output_file.stat().st_size > 0:
            return True
        else:
            return False

    except subprocess.TimeoutExpired:
        print("    (timeout)")
        if os.path.exists(temp_csd):
            os.unlink(temp_csd)
        return False
    except Exception as e:
        print(f"    (error: {str(e)[:50]})")
        if os.path.exists(temp_csd):
            os.unlink(temp_csd)
        return False

def main():
    global total, success, failed, skipped

    # Get all .csd files
    csd_files = sorted(SOURCE_DIR.glob("*.csd"))
    total = len(csd_files)

    print("=" * 60)
    print("Rendering Csound Instruments")
    print("=" * 60)
    print(f"Source: {SOURCE_DIR}")
    print(f"Output: {OUTPUT_DIR}")
    print(f"Total files to process: {total}")
    print("=" * 60)
    print()

    # Process each file
    for i, csd_file in enumerate(csd_files, 1):
        filename = csd_file.stem
        output_file = OUTPUT_DIR / f"{filename}.wav"

        # Skip if already exists and has content
        if output_file.exists() and output_file.stat().st_size > 0:
            print(f"[{i:4d}/{total}] Skipping: {filename}.csd (already exists)")
            skipped += 1
            continue

        print(f"[{i:4d}/{total}] Processing: {filename}.csd", end=" ")
        sys.stdout.flush()

        if render_csd(csd_file, output_file):
            success += 1
            file_size = output_file.stat().st_size / 1024  # KB
            print(f"✓ ({file_size:.1f} KB)")
        else:
            failed += 1
            print("✗")

    print()
    print("=" * 60)
    print("Rendering Complete")
    print("=" * 60)
    print(f"Total files:  {total}")
    print(f"Successful:   {success}")
    print(f"Failed:       {failed}")
    print(f"Skipped:      {skipped}")
    print("=" * 60)

if __name__ == "__main__":
    main()
