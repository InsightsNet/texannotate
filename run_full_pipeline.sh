#!/bin/bash
# Unified Pipeline for LPSB
# Runs Structure Pass (PDFLaTeX/LuaLaTeX) + Math/Table Pass (LuaLaTeX) + Merge
# Usage: ./run_full_pipeline.sh <paper_directory_or_tarball>

set -u
set -o pipefail

# Config
LPSB_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOCKER_IMAGE_DEFAULT="lpsb-texlive:latest"
DOCKER_IMAGE_TL2023="lpsb-texlive:TL2023-historic"

detect_texlive_image() {
    local paper_dir="$1"
    local img="$DOCKER_IMAGE_DEFAULT"

    # Check for 00README.json hints
    if [ -f "$paper_dir/00README.json" ]; then
        # Grep for texlive_version (simple parsing)
        local tl_ver=""
        tl_ver=$(grep -o '"texlive_version"[[:space:]]*:[[:space:]]*"[^"]*"' "$paper_dir/00README.json" 2>/dev/null | cut -d'"' -f4)
        
        if [ "$tl_ver" == "2023" ]; then
            if docker image inspect "$DOCKER_IMAGE_TL2023" >/dev/null 2>&1; then
                img="$DOCKER_IMAGE_TL2023"
                echo "  [Info] Detected TeX Live 2023 requirement. Using $img" >&2
            else
                echo "  [Warn] Detected TeX Live 2023 requirement but image not found. Falling back to $img" >&2
            fi
        fi
    fi
    echo "$img"
}

detect_compiler() {
    local paper_dir="$1"
    local compiler="pdflatex" # Default for structure pass

    if [ -f "$paper_dir/00README.json" ]; then
        local val=""
        val=$(grep -o '"compiler"[[:space:]]*:[[:space:]]*"[^"]*"' "$paper_dir/00README.json" 2>/dev/null | cut -d'"' -f4)
        if [ -n "$val" ]; then
            compiler="$val"
            echo "  [Info] Detected preferred compiler: $compiler" >&2
        fi
    fi
    echo "$compiler"
}

inject_pkg() {
    local file="$1"
    local pkg="$2"
    # Inject after \documentclass if not present
    if ! grep -qE '^[[:space:]]*\\usepackage(\[[^]]*\])?\{'"$pkg"'\}' "$file" 2>/dev/null; then
        sed -i '/^[[:space:]]*\\documentclass/a \\\\usepackage{'"$pkg"'}' "$file"
    fi
}

# --- Main ---

if [ $# -lt 1 ]; then
    echo "Usage: $0 <paper_path>"
    exit 1
fi

INPUT_PATH="$1"
WORK_ROOT="$LPSB_DIR/output_pipeline"
mkdir -p "$WORK_ROOT"

PAPER_NAME=$(basename "$INPUT_PATH" | sed 's/\.tar\.gz//')
PAPER_DIR="$WORK_ROOT/$PAPER_NAME"

echo "=== Processing $PAPER_NAME ==="

# 1. Setup Workspace
rm -rf "$PAPER_DIR"
mkdir -p "$PAPER_DIR"

if [ -d "$INPUT_PATH" ]; then
    cp -r "$INPUT_PATH"/* "$PAPER_DIR/"
elif [[ "$INPUT_PATH" == *.tar.gz ]]; then
    tar -xzf "$INPUT_PATH" -C "$PAPER_DIR"
else
    echo "Error: Input must be directory or .tar.gz"
    exit 1
fi

# Clean aux files
rm -f "$PAPER_DIR"/*.aux "$PAPER_DIR"/*.blg "$PAPER_DIR"/*.lpsb*.json

# Find Main Tex
MAIN_TEX=$(grep -l '\\documentclass' "$PAPER_DIR"/*.tex 2>/dev/null | head -1)
if [ -z "$MAIN_TEX" ]; then
    echo "Error: No main tex found"
    exit 1
fi
MAIN_NAME=$(basename "$MAIN_TEX" .tex)
TEX_DIR=$(dirname "$MAIN_TEX")

echo "  Main file: $MAIN_NAME.tex"

# Copy LPSB resources
cp "$LPSB_DIR/lpsb.sty" "$TEX_DIR/"
cp "$LPSB_DIR/lpsb-luamath.sty" "$TEX_DIR/"
cp "$LPSB_DIR/lpsb-luatable.sty" "$TEX_DIR/"
cp "$LPSB_DIR/lpsb-math.lua" "$TEX_DIR/"
cp "$LPSB_DIR/lpsb-table.lua" "$TEX_DIR/"

# Detect Settings
DOCKER_IMG=$(detect_texlive_image "$PAPER_DIR")
STRUCTURE_COMPILER=$(detect_compiler "$PAPER_DIR")

# 2. Structure Pass
echo "--- Step 1: Structure Pass ($STRUCTURE_COMPILER) ---"
# Note: inject_pkg uses sed 'a' which prepends each new package above previous ones
# So we inject in reverse order: last package first
inject_pkg "$MAIN_TEX" "lpsb"

# Run (2 passes for refs)
docker run --rm -v "$PAPER_DIR":/workdir -w /workdir "$DOCKER_IMG" \
    timeout 300 "$STRUCTURE_COMPILER" -interaction=nonstopmode "$MAIN_NAME.tex" > "$PAPER_DIR/structure.log" 2>&1
docker run --rm -v "$PAPER_DIR":/workdir -w /workdir "$DOCKER_IMG" \
    timeout 300 "$STRUCTURE_COMPILER" -interaction=nonstopmode "$MAIN_NAME.tex" >> "$PAPER_DIR/structure.log" 2>&1

if [ ! -f "$TEX_DIR/$MAIN_NAME.lpsb.json" ]; then
    echo "  [Fail] Structure pass failed. See $PAPER_DIR/structure.log"
    # Determine if we should abort or try to continue? 
    # If structure fails, merge will create an empty/broken file. Abort.
    exit 1
else
    echo "  [OK] Generated $MAIN_NAME.lpsb.json"
fi

# 3. Math/Table Pass (LuaLaTeX)
echo "--- Step 2: Math/Table Pass (lualatex) ---"
# Inject in reverse order so file ends up with: lpsb, lpsb-luamath, lpsb-luatable
inject_pkg "$MAIN_TEX" "lpsb-luatable"
inject_pkg "$MAIN_TEX" "lpsb-luamath"

# Must be lualatex
docker run --rm -v "$PAPER_DIR":/workdir -w /workdir "$DOCKER_IMG" \
    timeout 300 lualatex -interaction=nonstopmode "$MAIN_NAME.tex" > "$PAPER_DIR/lua.log" 2>&1
# 2nd pass for table positioning
docker run --rm -v "$PAPER_DIR":/workdir -w /workdir "$DOCKER_IMG" \
    timeout 300 lualatex -interaction=nonstopmode "$MAIN_NAME.tex" >> "$PAPER_DIR/lua.log" 2>&1

MATH_OK=false
TABLE_OK=false

if [ -f "$TEX_DIR/$MAIN_NAME.lpsb-math.json" ]; then
    echo "  [OK] Generated $MAIN_NAME.lpsb-math.json"
    MATH_OK=true
fi
if [ -f "$TEX_DIR/$MAIN_NAME.lpsb-table.json" ]; then
    echo "  [OK] Generated $MAIN_NAME.lpsb-table.json"
    TABLE_OK=true
fi

# 4. Merge
echo "--- Step 3: Merge ---"
python3 "$LPSB_DIR/merge_lpsb.py" \
    "$TEX_DIR/$MAIN_NAME.lpsb.json" \
    "$TEX_DIR/$MAIN_NAME.lpsb-math.json" \
    "$TEX_DIR/$MAIN_NAME.merged.json" \
    "$TEX_DIR/$MAIN_NAME.lpsb-table.json"

if [ -f "$TEX_DIR/$MAIN_NAME.merged.json" ]; then
    echo "=== Success ==="
    echo "Output: $TEX_DIR/$MAIN_NAME.merged.json"
else
    echo "=== Merge Failed ==="
    exit 1
fi
