#!/bin/bash
#
# Download and process the Csound FLOSS Manual for corpus integration
#

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
CORPUS_DIR="$PROJECT_ROOT/corpus/floss_manual"
TEMP_DIR="/tmp/csound-floss-$$"

echo "=== Csound FLOSS Manual Downloader ==="
echo "Target directory: $CORPUS_DIR"
echo ""

# Clean up on exit
cleanup() {
    if [ -d "$TEMP_DIR" ]; then
        echo "Cleaning up temporary files..."
        rm -rf "$TEMP_DIR"
    fi
}
trap cleanup EXIT

# Clone the repository
echo "Cloning FLOSS manual repository..."
git clone --depth 1 https://github.com/csound-flossmanual/csound-floss.git "$TEMP_DIR"

# Create corpus directory
mkdir -p "$CORPUS_DIR"

# Process and copy markdown files from the book directory
echo "Processing markdown files..."

# Find all markdown files in the book directory
find "$TEMP_DIR/book" -name "*.md" -type f | while read -r file; do
    # Get relative path from book directory
    rel_path="${file#$TEMP_DIR/book/}"

    # Create target directory structure
    target_dir="$CORPUS_DIR/$(dirname "$rel_path")"
    mkdir -p "$target_dir"

    # Get filename without extension for metadata
    filename=$(basename "$file" .md)

    # Extract chapter info from path (e.g., "01-a-digital-audio")
    chapter_id=$(echo "$rel_path" | sed 's/\.md$//' | tr '/' '_')

    # Create processed file with metadata header
    target_file="$CORPUS_DIR/$rel_path"

    # Add metadata header and copy content
    {
        echo "---"
        echo "source: FLOSS Manual for Csound"
        echo "url: https://flossmanual.csound.com/"
        echo "chapter: $chapter_id"
        echo "license: CC-BY-SA"
        echo "---"
        echo ""
        cat "$file"
    } > "$target_file"

    echo "  Processed: $rel_path"
done

# Copy any audio examples if they exist
if [ -d "$TEMP_DIR/book/resources" ]; then
    echo "Copying resources..."
    cp -r "$TEMP_DIR/book/resources" "$CORPUS_DIR/" 2>/dev/null || true
fi

# Create an index file
echo "Creating index..."
{
    echo "# FLOSS Manual for Csound - Corpus Index"
    echo ""
    echo "**Source:** https://flossmanual.csound.com/"
    echo "**License:** CC-BY-SA"
    echo "**Downloaded:** $(date -u +"%Y-%m-%d")"
    echo ""
    echo "## Contents"
    echo ""

    # List all processed files
    find "$CORPUS_DIR" -name "*.md" -type f | sort | while read -r file; do
        rel_path="${file#$CORPUS_DIR/}"
        if [ "$rel_path" != "INDEX.md" ]; then
            # Extract title from first heading
            title=$(grep -m1 "^# " "$file" | sed 's/^# //' || echo "$rel_path")
            echo "- [$title]($rel_path)"
        fi
    done
} > "$CORPUS_DIR/INDEX.md"

# Count processed files
file_count=$(find "$CORPUS_DIR" -name "*.md" -type f | wc -l | tr -d ' ')

echo ""
echo "=== Complete ==="
echo "Processed $file_count markdown files"
echo "Output directory: $CORPUS_DIR"
echo ""
echo "To update your .gitignore if you don't want to commit the manual:"
echo "  echo 'corpus/floss_manual/' >> .gitignore"
