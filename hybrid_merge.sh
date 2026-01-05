#!/bin/bash
# Hybrid merge: Combine PDFLaTeX structure JSON with LuaLaTeX math JSON
# Uses context-aware IDs for alignment

PDFLATEX_DIR="/home/duan/rainbow_2/LPSB/test_output"
LUALATEX_DIR="/home/duan/rainbow_2/LPSB/test_output_lua"
OUTPUT_DIR="/home/duan/rainbow_2/LPSB/test_output_merged"

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
    python3 /home/duan/rainbow_2/LPSB/merge_lpsb.py \
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
