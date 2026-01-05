#!/bin/bash
# Test LuaLaTeX math capture on real arXiv papers
# Creates output in test_output_lua/

set -u
set -o pipefail

DATA_DIR="/home/duan/rainbow_2/data/download"
OUTPUT_DIR="/home/duan/rainbow_2/LPSB/test_output_lua"
LPSB_DIR="/home/duan/rainbow_2/LPSB"

mkdir -p "$OUTPUT_DIR"

inject_pkg_after_documentclass() {
    local file="$1"
    local pkg="$2"

    # Already injected?
    if grep -qE '^[[:space:]]*\\usepackage(\[[^]]*\])?\{'$pkg'\}' "$file" 2>/dev/null; then
        return 0
    fi

    # Insert after \documentclass.
    # NOTE: Don't use {...} blocks here: "a\..." consumes the rest of the sed script line.
    # For sed's "a\" text, backslashes are escape characters; use \\\\ to get a literal "\" in output.
    sed -i '/^[[:space:]]*\\documentclass/a\\\\usepackage{'$pkg'}' "$file"
}

detect_texlive_image() {
    # For math capture we always prefer a LuaLaTeX-capable image.
    # Historic images may not include `lualatex` and won't have newer Lua modules (luamml).
    local img="lpsb-texlive:latest"
    if ! docker image inspect "$img" >/dev/null 2>&1; then
        img="texlive/texlive:latest"
    fi

    echo "$img"
}

find_main_tex() {
    local workdir="$1"
    local candidate

    for candidate in main.tex paper.tex ms.tex article.tex manuscript.tex; do
        if [ -f "$workdir/$candidate" ]; then
            echo "$workdir/$candidate"
            return 0
        fi
    done

    candidate=$(grep -l '\\documentclass' "$workdir"/*.tex 2>/dev/null | head -1)
    if [ -n "$candidate" ]; then
        echo "$candidate"
        return 0
    fi

    # Fallback: allow shallow subdirs
    candidate=$(find "$workdir" -maxdepth 2 -name "*.tex" -type f -print0 2>/dev/null | xargs -0 -r grep -l '\\documentclass' 2>/dev/null | head -1)
    if [ -n "$candidate" ]; then
        echo "$candidate"
        return 0
    fi

    return 1
}

echo "=========================================="
echo "LuaLaTeX Math Capture Test"
echo "=========================================="

for tarball in "$DATA_DIR"/*.tar.gz; do
    paper=$(basename "$tarball" .tar.gz)
    echo
    echo "Processing: $paper"
    echo "-------------------------------------------"
    
    # Create paper directory
    paper_dir="$OUTPUT_DIR/$paper"
    rm -rf "$paper_dir"
    mkdir -p "$paper_dir"
    
    # Extract
    tar -xzf "$tarball" -C "$paper_dir" 2>/dev/null || true

    # Remove auxiliary files (keep .bbl if present)
    rm -f "$paper_dir"/*.aux "$paper_dir"/*.blg
    
    # Find main tex file
    main_tex=$(find_main_tex "$paper_dir" || true)
    
    if [ -z "$main_tex" ]; then
        echo "  ERROR: No main tex file found"
        continue
    fi
    
    main_name=$(basename "$main_tex" .tex)
    tex_dir=$(dirname "$main_tex")
    tex_dir_rel=$(realpath --relative-to="$paper_dir" "$tex_dir" 2>/dev/null || echo ".")
    
    echo "  Main: $main_name.tex"
    echo "  Dir:  $tex_dir_rel"
    
    # Copy LPSB files
    cp "$LPSB_DIR/lpsb.sty" "$tex_dir/"
    cp "$LPSB_DIR/lpsb-luamath.sty" "$tex_dir/"
    cp "$LPSB_DIR/lpsb-math.lua" "$tex_dir/"

    # Inject packages into the document AFTER \documentclass.
    # Command-line \RequirePackage before \documentclass is fragile and breaks hooks/shipout.
    inject_pkg_after_documentclass "$main_tex" "lpsb"
    inject_pkg_after_documentclass "$main_tex" "lpsb-luamath"

    DOCKER_IMAGE=$(detect_texlive_image "$paper_dir")
    
    # Workdir inside container (relative to extracted paper root)
    container_wd="/workdir"
    if [ "$tex_dir_rel" != "." ]; then
        container_wd="/workdir/$tex_dir_rel"
    fi

    jobname="$main_name"

    # Pass 1
    docker run --rm -v "$paper_dir":/workdir -w "$container_wd" "$DOCKER_IMAGE" \
        lualatex -interaction=nonstopmode -jobname="$jobname" "$main_name.tex" \
        > "$paper_dir/compile1.log" 2>&1 || true

    # Bibliography (biber/bibtex) if needed
    if [ -f "$tex_dir/$main_name.bbl" ]; then
        : # use existing bbl
    elif grep -q 'biblatex' "$main_tex" 2>/dev/null; then
        docker run --rm -v "$paper_dir":/workdir -w "$container_wd" "$DOCKER_IMAGE" \
            biber "$jobname" > "$paper_dir/biber.log" 2>&1 || true
    elif grep -q 'bibliography' "$main_tex" 2>/dev/null || ls "$paper_dir"/*.bib >/dev/null 2>&1; then
        docker run --rm -v "$paper_dir":/workdir -w "$container_wd" "$DOCKER_IMAGE" \
            bibtex "$jobname" > "$paper_dir/bibtex.log" 2>&1 || true
    fi

    # Pass 2 & 3 (resolve refs)
    for pass in 2 3; do
        docker run --rm -v "$paper_dir":/workdir -w "$container_wd" "$DOCKER_IMAGE" \
            lualatex -interaction=nonstopmode -jobname="$jobname" "$main_name.tex" \
            > "$paper_dir/compile$pass.log" 2>&1 || true
    done
    
    # Check results
    if [ -f "$tex_dir/$jobname.lpsb-math.json" ]; then
        math_count=$(grep -c '"role": "Math"' "$tex_dir/$jobname.lpsb-math.json" 2>/dev/null || echo 0)
        math_count=$((math_count / 2))  # start + end = 2 entries per formula
        echo "  ✓ Math formulas captured: $math_count"
    else
        echo "  ✗ No math JSON generated"
    fi
    
    if [ -f "$tex_dir/$jobname.lpsb.json" ]; then
        echo "  ✓ Structure JSON generated"
    fi
done

echo
echo "=========================================="
echo "Test Complete"
echo "=========================================="
