#!/bin/bash

# Script to render all .csd files from csound_examples directory
# Output: renders/instruments directory

# Set directories
SOURCE_DIR="/workspaces/devcontainer-csound/csound_examples"
OUTPUT_DIR="/workspaces/devcontainer-csound/renders/instruments"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

# Counter for statistics
total=0
success=0
failed=0

# Get total number of .csd files
total=$(find "$SOURCE_DIR" -maxdepth 1 -name "*.csd" | wc -l)

echo "================================================"
echo "Rendering Csound Instruments"
echo "================================================"
echo "Source: $SOURCE_DIR"
echo "Output: $OUTPUT_DIR"
echo "Total files to process: $total"
echo "================================================"
echo ""

# Loop through all .csd files
for csd_file in "$SOURCE_DIR"/*.csd; do
    # Get the base filename without path and extension
    filename=$(basename "$csd_file" .csd)

    # Output WAV file path
    output_file="$OUTPUT_DIR/${filename}.wav"

    echo "Processing: $filename.csd"

    # Render the .csd file
    # -o specifies output file
    # -d suppresses displays (no graphics)
    # -m0 sets message level to 0 (minimal output)
    # --nosound prevents trying to use audio device
    if timeout 30s csound -o "$output_file" -d --nosound "$csd_file" > /dev/null 2>&1; then
        if [ -f "$output_file" ] && [ -s "$output_file" ]; then
            ((success++))
            echo "  ✓ Success: $filename.wav"
        else
            ((failed++))
            echo "  ✗ Failed: $filename.csd (no output file)"
        fi
    else
        ((failed++))
        echo "  ✗ Failed: $filename.csd (render error or timeout)"
echo "Rendering Complete"
echo "================================================"
echo "Total files: $total"
echo "Successful: $success"
echo "Failed: $failed"
echo "================================================"
