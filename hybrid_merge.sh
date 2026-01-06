#!/bin/bash
# Hybrid merge: Combine PDFLaTeX structure JSON with LuaLaTeX math JSON
# Uses context-aware IDs for alignment

set -u
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
LPSB_DIR_DEFAULT="$SCRIPT_DIR"

LPSB_DIR="${LPSB_DIR:-$LPSB_DIR_DEFAULT}"
LPSB_OUT_DIR="${LPSB_OUT_DIR:-${LPSB_OUTPUT_DIR:-"$LPSB_DIR/test_output"}}"
LPSB_OUT_LUA_DIR="${LPSB_OUT_LUA_DIR:-${LPSB_OUTPUT_LUA_DIR:-"$LPSB_DIR/test_output_lua"}}"
LPSB_OUT_MERGED_DIR="${LPSB_OUT_MERGED_DIR:-${LPSB_OUTPUT_MERGED_DIR:-"$LPSB_DIR/test_output_merged"}}"
LPSB_MERGE_PY="${LPSB_MERGE_PY:-"$LPSB_DIR/merge_lpsb.py"}"

# Backward-compatible overrides (old variable names).
PDFLATEX_DIR="${PDFLATEX_DIR:-$LPSB_OUT_DIR}"
LUALATEX_DIR="${LUALATEX_DIR:-$LPSB_OUT_LUA_DIR}"
OUTPUT_DIR="${OUTPUT_DIR:-$LPSB_OUT_MERGED_DIR}"

mkdir -p "$OUTPUT_DIR"

echo "=========================================="
echo "Hybrid Merge: PDFLaTeX + LuaLaTeX"
echo "=========================================="

for paper_dir in "$PDFLATEX_DIR"/*/; do
    paper=$(basename "$paper_dir")
    echo
    echo "Processing: $paper"
    echo "-------------------------------------------"
    
    # Find PDFLaTeX JSON (structure with refs/bib)
    pdflatex_json=$(find "$paper_dir" -name "*.lpsb.json" -type f | head -1)
    
    if [ -z "$pdflatex_json" ]; then
        echo "  ✗ PDFLaTeX JSON not found"
        continue
    fi
    
    echo "  PDFLaTeX: $(basename "$pdflatex_json")"
    
    # Find LuaLaTeX Math JSON (jobname depends on detected main .tex)
    lualatex_json=$(find "$LUALATEX_DIR/$paper" -name "*.lpsb-math.json" -type f 2>/dev/null | head -1)
    
    if [ -z "$lualatex_json" ] || [ ! -f "$lualatex_json" ]; then
        echo "  ✗ LuaLaTeX math JSON not found"
        continue
    fi
    
    echo "  LuaLaTeX: $(basename "$lualatex_json")"
    
    # Merge using Python script
    output_json="$OUTPUT_DIR/$paper-merged.json"
    python3 "$LPSB_MERGE_PY" \
        "$pdflatex_json" \
        "$lualatex_json" \
        "$output_json" 2>&1 | grep -E "Loaded|Indexed|Enriched|✓"
    
    if [ -f "$output_json" ]; then
        size=$(wc -l < "$output_json")
        echo "  ✓ Merged: $size lines"
    fi
done

echo
echo "=========================================="
echo "Merge Complete"
echo "Results in: $OUTPUT_DIR"
echo "=========================================="
