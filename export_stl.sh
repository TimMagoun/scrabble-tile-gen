#!/bin/sh
set -e
# Script to export tiles and letters as separate STL files for all letter sets
# Usage: ./export_stl.sh <parameter_set_name>

OPEN_SCAD_COMMAND="/Applications/OpenSCAD.app/Contents/MacOS/OpenSCAD"

if [ -z "$1" ]; then
    echo "Error: Parameter set name required"
    echo "Usage: ./export_stl.sh <parameter_set_name>"
    echo ""
    echo "Available parameter sets in scrabble_gen.json:"
    sed -n '/"parameterSets":/,/^[[:space:]]*}[[:space:]]*$/p' scrabble_gen.json | grep -o '"[^"]*"[[:space:]]*:[[:space:]]*{' | sed 's/"//g' | sed 's/[[:space:]]*:[[:space:]]*{//'
    exit 1
fi

PARAM_SET="$1"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
OUTPUT_DIR="output/${PARAM_SET}_${TIMESTAMP}"

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Define all available letter sets (space-separated)
LETTER_SETS="englishOriginal englishRedditAlt1 englishRedditAlt2 englishTest englishTestFast"

echo "Exporting STL files for parameter set: $PARAM_SET"
echo "Output directory: $OUTPUT_DIR"
echo ""

# Loop through each letter set
for LETTER_SET in $LETTER_SETS; do
    echo "================================================"
    echo "Processing letter set: $LETTER_SET"
    echo "================================================"
    
    # Export tiles only (white part)
    echo "Exporting tiles only..."
    $OPEN_SCAD_COMMAND -o "$OUTPUT_DIR/${LETTER_SET}_tiles_only.stl" \
        -p scrabble_gen.json \
        -P "$PARAM_SET" \
        -D "renderPart=1" \
        -D "letterSet=\"$LETTER_SET\"" \
        scrabble_gen.scad
    
    if [ $? -eq 0 ]; then
        echo "[OK] Tiles exported successfully"
    else
        echo "[FAIL] Failed to export tiles for $LETTER_SET"
        continue
    fi
    
    echo ""
    
    # Export letters only (black part)
    echo "Exporting letters only..."
    $OPEN_SCAD_COMMAND -o "$OUTPUT_DIR/${LETTER_SET}_letters_only.stl" \
        -p scrabble_gen.json \
        -P "$PARAM_SET" \
        -D "renderPart=2" \
        -D "letterSet=\"$LETTER_SET\"" \
        scrabble_gen.scad
    
    if [ $? -eq 0 ]; then
        echo "[OK] Letters exported successfully"
    else
        echo "[FAIL] Failed to export letters for $LETTER_SET"
    fi
    
    echo ""
done

echo "================================================"
echo "Export complete! All files saved in: $OUTPUT_DIR"
echo "================================================"
echo ""
ls -lh "$OUTPUT_DIR"
