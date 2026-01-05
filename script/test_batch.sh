#!/bin/bash
# LPSB Batch Test Script v2.0
# Tests all arXiv papers in the download directory using lpsb.sty auto-injection

INPUT_DIR="/home/duan/rainbow_2/data/download"
OUTPUT_DIR="/home/duan/rainbow_2/LPSB/test_output"
INJECTOR="/home/duan/rainbow_2/LPSB/lpsb.sty"

mkdir -p "$OUTPUT_DIR"

echo "=========================================="
echo "LPSB Batch Test v2.0 - $(date)"
echo "=========================================="

# Helper function to inject package
inject_lpsb() {
    local file="$1"
    # Insert \usepackage{lpsb} after the first \documentclass (avoid pre-class injection)
    if grep -qE '^[[:space:]]*\\usepackage(\[[^]]*\])?\{lpsb\}' "$file" 2>/dev/null; then
        return 0
    fi
    # NOTE: Don't use {...} blocks here: "a\..." consumes the rest of the sed script line.
    # For sed's "a\" text, backslashes are escape characters; use \\\\ to get a literal "\" in output.
    sed -i '/^[[:space:]]*\\documentclass/a\\\\usepackage{lpsb}' "$file"
}

for tarball in "$INPUT_DIR"/*.tar.gz; do
    name=$(basename "$tarball" .tar.gz)
    workdir="$OUTPUT_DIR/$name"
    
    echo ""
    echo "Processing: $name"
    echo "-------------------------------------------"
    
    # Clean and extract
    rm -rf "$workdir"
    mkdir -p "$workdir"
    tar -xzf "$tarball" -C "$workdir" 2>/dev/null
    
    # Remove auxiliary files BUT KEEP .bbl if it exists (arXiv often only includes .bbl)
    rm -f "$workdir"/*.aux "$workdir"/*.blg
    
    # Copy injector package
    cp "$INJECTOR" "$workdir/"
    
    # Find main tex file
    main_tex=""
    for candidate in main.tex paper.tex ms.tex article.tex manuscript.tex; do
        if [ -f "$workdir/$candidate" ]; then
            main_tex="$candidate"
            break
        fi
    done
    
    if [ -z "$main_tex" ]; then
        main_tex=$(grep -l '\documentclass' "$workdir"/*.tex 2>/dev/null | head -1 | xargs basename)
    fi
    
    if [ -z "$main_tex" ]; then
        echo "  ERROR: No main .tex file found"
        continue
    fi
    
    echo "  Main: $main_tex"
    main_base="${main_tex%.*}"
    
    # Determine Docker Image Version
    # Default to latest
    # Prefer local image with extra packages (luamml, etc.) if present.
    DOCKER_IMAGE="lpsb-texlive:latest"
    if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
        DOCKER_IMAGE="texlive/texlive:latest"
    fi
    if [ -f "$workdir/00README.json" ]; then
        # Extract version using grep and shell processing to avoid heavy jq dependency
        tl_version=$(grep -o '"texlive_version"[[:space:]]*:[[:space:]]*"[^"]*"' "$workdir/00README.json" | cut -d'"' -f4)
        if [ "$tl_version" == "2023" ]; then
            # Tag for historic releases is usually TL<YEAR>-historic
            DOCKER_IMAGE="lpsb-texlive:TL2023-historic"
            if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                DOCKER_IMAGE="texlive/texlive:TL2023-historic"
            fi
            echo "  Detected TeX Live 2023 (Historic)"
        elif [ "$tl_version" == "2024" ]; then
            # 2024 is current/recent, might correspond to latest or exist as numeric tag
            # Assume TL2024-historic if available, or just latest which is functionally 2024/2025
            DOCKER_IMAGE="lpsb-texlive:latest"
            if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                DOCKER_IMAGE="texlive/texlive:latest"
            fi
            echo "  Detected TeX Live 2024 (Using Latest)"
        fi
    fi

    # Compile with LPSB - 3 passes
    cd "$workdir"
    # Use the original filename base as jobname so aux/bbl names match
    jobname="$main_base"

    # Inject LPSB in-document (after \documentclass)
    inject_lpsb "$workdir/$main_tex"
    
    # Pass 1
    docker run --rm -v "$workdir":/workdir -w /workdir "$DOCKER_IMAGE" \
        pdflatex -interaction=nonstopmode -jobname="$jobname" "$main_tex" \
        > compile1.log 2>&1
    
    # Handle Bibliography
    # Priority:
    # 1. Existing .bbl matching main file (use it!)
    # 2. Biblatex detected -> run biber
    # 3. Bibliography detected -> run bibtex
    
    if [ -f "$main_base.bbl" ]; then
        echo "  Using existing $main_base.bbl..."
        # NOTE: We NO LONGER patch the version number, because we now match the environment!
        # sed -i 's/biblatex bbl format version 3.2/biblatex bbl format version 3.3/' "$main_base.bbl"
    elif grep -q 'biblatex' "$main_tex" 2>/dev/null; then
        echo "  Running biber..."
        docker run --rm -v "$workdir":/workdir -w /workdir "$DOCKER_IMAGE" \
            biber "$jobname" > biber.log 2>&1
    elif grep -q 'bibliography' "$main_tex" 2>/dev/null || [ -f "$workdir"/*.bib ]; then
        echo "  Running bibtex..."
        docker run --rm -v "$workdir":/workdir -w /workdir "$DOCKER_IMAGE" \
            bibtex "$jobname" > bibtex.log 2>&1
    fi
    
    # Pass 2 & 3
    for pass in 2 3; do
        docker run --rm -v "$workdir":/workdir -w /workdir "$DOCKER_IMAGE" \
            pdflatex -interaction=nonstopmode -jobname="$jobname" "$main_tex" \
            > "compile$pass.log" 2>&1
    done
    
    # Check results
    if [ -f "$workdir/$jobname.pdf" ]; then
        pdf_size=$(stat -c%s "$workdir/$jobname.pdf" 2>/dev/null || echo "0")
        echo "  PDF: $(($pdf_size/1024))KB"
    else
        echo "  PDF: FAILED"
        grep -m1 "^!" "$workdir/compile1.log" 2>/dev/null
    fi
    
    if [ -f "$workdir/$jobname.lpsb.json" ]; then
        line_count=$(wc -l < "$workdir/$jobname.lpsb.json")
        math_count=$(grep -c '"role": "Formula"' "$workdir/$jobname.lpsb.json" 2>/dev/null || echo 0)
        echo "  JSON: $line_count lines, $math_count Formula events"
    elif [ -f "$workdir/$jobname.lpsb.jsonl" ]; then
        probe_count=$(wc -l < "$workdir/$jobname.lpsb.jsonl")
        env_count=$(grep -c '"type": "env-start"' "$workdir/$jobname.lpsb.jsonl" 2>/dev/null || echo 0)
        echo "  JSONL: $probe_count probes, $env_count environments"
    else
        echo "  JSON: NOT GENERATED"
    fi
    
    cd - > /dev/null
done

echo ""
echo "=========================================="
echo "Test Complete"
echo "Results in: $OUTPUT_DIR"
echo "=========================================="
