#!/bin/bash
# LPSB Batch Compile All Papers - Error Analysis Script
# Compiles all arXiv papers and generates a detailed error report

set -u
set -o pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
# Default repo root is parent of script/ (consistent with other scripts in this repo).
LPSB_DIR_DEFAULT="$(cd -- "$SCRIPT_DIR/.." && pwd)"

LPSB_DIR="${LPSB_DIR:-$LPSB_DIR_DEFAULT}"
LPSB_DATA_DIR="${LPSB_DATA_DIR:-${LPSB_DATA_DOWNLOAD_DIR:-"$LPSB_DIR/data/download"}}"
LPSB_OUT_DIR="${LPSB_OUT_DIR:-${LPSB_OUTPUT_DIR:-"$LPSB_DIR/compile_results"}}"
LPSB_INJECTOR="${LPSB_INJECTOR:-"$LPSB_DIR/lpsb.sty"}"
LPSB_MERGE_PY="${LPSB_MERGE_PY:-"$LPSB_DIR/script/merge_lpsb.py"}"

mkdir -p "$LPSB_OUT_DIR"

# Report file
REPORT_FILE="$LPSB_OUT_DIR/compile_report_$(date +%Y%m%d_%H%M%S).txt"
SUMMARY_FILE="$LPSB_OUT_DIR/summary_$(date +%Y%m%d_%H%M%S).txt"

# Statistics
TOTAL=0
SUCCESS=0
FAILED=0
WARNINGS=0
NO_MAIN_TEX=0

echo "=========================================="
echo "LPSB Batch Compile All Papers - Error Analysis"
echo "Started: $(date)"
echo "=========================================="
echo "Input:  $LPSB_DATA_DIR"
echo "Output: $LPSB_OUT_DIR"
echo "Report: $REPORT_FILE"
echo "=========================================="
echo ""

# Initialize report
{
    echo "LPSB Batch Compile Report"
    echo "Generated: $(date)"
    echo "=========================================="
    echo ""
} > "$REPORT_FILE"

# Helper function to inject package after \documentclass
inject_pkg_after_documentclass() {
    local file="$1"
    local pkg="$2"
    
    # Already injected?
    if grep -qE '^[[:space:]]*\\usepackage(\[[^]]*\])?\{'$pkg'\}' "$file" 2>/dev/null; then
        return 0
    fi
    
    # Insert after \documentclass
    # NOTE: Don't use {...} blocks here: "a\..." consumes the rest of the sed script line.
    # For sed's "a\" text, backslashes are escape characters; use \\\\ to get a literal "\" in output.
    sed -i '/^[[:space:]]*\\documentclass/a\\\\usepackage{'$pkg'}' "$file"
}

find_main_tex() {
    local workdir="$1"
    local candidate=""
    local rel=""

    for candidate in main.tex paper.tex ms.tex article.tex manuscript.tex; do
        if [ -f "$workdir/$candidate" ]; then
            echo "$candidate"
            return 0
        fi
    done

    candidate="$(grep -l '\\documentclass' "$workdir"/*.tex 2>/dev/null | head -1 || true)"
    if [ -n "$candidate" ]; then
        rel="$(realpath --relative-to="$workdir" "$candidate" 2>/dev/null || echo "$(basename "$candidate")")"
        echo "$rel"
        return 0
    fi

    candidate="$(find "$workdir" -maxdepth 2 -name "*.tex" -type f -print0 2>/dev/null | xargs -0 -r grep -l '\\documentclass' 2>/dev/null | head -1 || true)"
    if [ -n "$candidate" ]; then
        rel="$(realpath --relative-to="$workdir" "$candidate" 2>/dev/null || echo "$(basename "$candidate")")"
        echo "$rel"
        return 0
    fi

    return 1
}

detect_biblatex_bbl_format_version() {
    # Extract biblatex .bbl format version from a .bbl file (if present).
    # Example line: "% $ biblatex bbl format version 3.1 $"
    local bbl="$1"
    local v=""
    if [ -f "$bbl" ]; then
        # Use ERE; keep this strict and predictable.
        # We only care about "X.Y" here.
        v="$(grep -m1 -Eo 'biblatex bbl format version[[:space:]]*[0-9]+\.[0-9]+' "$bbl" 2>/dev/null | sed -E 's/.*version[[:space:]]*([0-9]+\.[0-9]+).*/\1/' || true)"
        v="${v:-}"
    fi
    echo "$v"
}

map_bbl_format_to_texlive_year() {
    # Heuristic mapping for biblatex .bbl format versions -> TeX Live year.
    # Keep this conservative: only map what we are confident about.
    local fmt="$1"
    case "$fmt" in
        "3.0") echo "2021" ;;
        "3.1") echo "2022" ;;
        "3.2") echo "2023" ;;
        "3.3") echo "2024" ;;
        "3.4") echo "2025" ;;
        *) echo "" ;;
    esac
}

infer_texlive_year_from_docker_image() {
    # Best-effort inference from docker tag.
    # Examples:
    # - texlive/texlive:TL2022-historic -> 2022
    # - lpsb-texlive:TL2023-historic   -> 2023
    # - *:latest                       -> latest
    local img="$1"
    local year=""
    year="$(echo "$img" | sed -nE 's/.*:TL([0-9]{4})-historic.*/\1/p' | head -1)"
    if [ -n "$year" ]; then
        echo "$year"
        return 0
    fi
    if echo "$img" | grep -qE ':latest$'; then
        echo "latest"
        return 0
    fi
    echo ""
}

extract_errors() {
    local logfile="$1"
    local paper_name="$2"
    
    {
        # Fatal errors (!)
        if grep -q "^!" "$logfile" 2>/dev/null; then
            echo "  FATAL ERRORS:"
            grep "^!" "$logfile" 2>/dev/null | head -5 | sed 's/^/    /'
        fi
        
        # LaTeX errors
        if grep -q "LaTeX Error:" "$logfile" 2>/dev/null; then
            echo "  LaTeX ERRORS:"
            grep "LaTeX Error:" "$logfile" 2>/dev/null | head -5 | sed 's/^/    /'
        fi
        
        # Missing packages/files
        if grep -q "File.*not found" "$logfile" 2>/dev/null; then
            echo "  MISSING FILES:"
            grep "File.*not found" "$logfile" 2>/dev/null | sed 's/^/    /' | head -3
        fi
        
        # Undefined control sequences
        if grep -q "Undefined control sequence" "$logfile" 2>/dev/null; then
            echo "  UNDEFINED COMMANDS:"
            grep "Undefined control sequence" "$logfile" 2>/dev/null | sed 's/^/    /' | head -3
        fi
        
        # Overfull/underfull boxes (warnings)
        local overfull
        local underfull
        overfull="$(grep -c "Overfull" "$logfile" 2>/dev/null || true)"
        underfull="$(grep -c "Underfull" "$logfile" 2>/dev/null || true)"
        overfull="${overfull:-0}"
        underfull="${underfull:-0}"
        if [ "$overfull" -gt 0 ] || [ "$underfull" -gt 0 ]; then
            echo "  BOX WARNINGS: Overfull=$overfull, Underfull=$underfull"
        fi
    } | head -20
}

if [ ! -d "$LPSB_DATA_DIR" ]; then
    echo "ERROR: Data directory not found: $LPSB_DATA_DIR" >&2
    exit 2
fi
if [ ! -f "$LPSB_INJECTOR" ]; then
    echo "ERROR: Injector not found: $LPSB_INJECTOR" >&2
    exit 2
fi

# Process each tarball
for tarball in "$LPSB_DATA_DIR"/*.tar.gz; do
    [ -f "$tarball" ] || continue
    
    TOTAL=$((TOTAL + 1))
    name=$(basename "$tarball" .tar.gz)
    workdir="$LPSB_OUT_DIR/$name"
    
    echo "[$TOTAL] Processing: $name"
    echo "-------------------------------------------"
    
    # Clean and extract
    rm -rf "$workdir"
    mkdir -p "$workdir"
    
    if ! tar -xzf "$tarball" -C "$workdir" 2>/dev/null; then
        echo "  ERROR: Failed to extract tarball"
        {
            echo ""
            echo "=========================================="
            echo "PAPER: $name"
            echo "STATUS: FAILED - Extraction error"
            echo "=========================================="
        } >> "$REPORT_FILE"
        FAILED=$((FAILED + 1))
        continue
    fi
    
    # Remove auxiliary files
    rm -f "$workdir"/*.aux "$workdir"/*.blg 2>/dev/null
    
    # Find main tex file first to determine directory structure
    main_tex="$(find_main_tex "$workdir" || true)"
    
    if [ -z "$main_tex" ]; then
        echo "  ERROR: No main .tex file found"
        {
            echo ""
            echo "=========================================="
            echo "PAPER: $name"
            echo "STATUS: FAILED - No main .tex file found"
            echo "=========================================="
        } >> "$REPORT_FILE"
        NO_MAIN_TEX=$((NO_MAIN_TEX + 1))
        FAILED=$((FAILED + 1))
        continue
    fi
    
    echo "  Main: $main_tex"
    main_base="$(basename "${main_tex%.*}")"
    main_tex_basename="$(basename "$main_tex")"

    tex_dir_rel="$(dirname "$main_tex")"
    if [ "$tex_dir_rel" = "." ] || [ -z "$tex_dir_rel" ]; then
        tex_dir_rel="."
    fi

    # Two-stage pipeline:
    # A) PDFLaTeX output is the gold PDF/structure baseline (most compatible with arXiv sources).
    # B) LuaLaTeX is only used to generate math/table JSON (MathML + table cells), then merged.
    pdflatex_dir="$workdir/_pdflatex"
    lualatex_dir="$workdir/_lualatex"
    rm -rf "$pdflatex_dir" "$lualatex_dir"
    mkdir -p "$pdflatex_dir" "$lualatex_dir"
    # Clone sources into stage dirs.
    # NOTE: stage dirs live under workdir; do NOT use plain `cp` (it will recurse into itself).
    (cd "$workdir" && tar --exclude='./_pdflatex' --exclude='./_lualatex' -cf - .) | (cd "$pdflatex_dir" && tar -xf -)
    (cd "$workdir" && tar --exclude='./_pdflatex' --exclude='./_lualatex' -cf - .) | (cd "$lualatex_dir" && tar -xf -)

    pd_tex_dir="$pdflatex_dir"
    lua_tex_dir="$lualatex_dir"
    if [ "$tex_dir_rel" != "." ]; then
        pd_tex_dir="$pdflatex_dir/$tex_dir_rel"
        lua_tex_dir="$lualatex_dir/$tex_dir_rel"
    fi

    pd_container_wd="/workdir"
    lua_container_wd="/workdir"
    if [ "$tex_dir_rel" != "." ]; then
        pd_container_wd="/workdir/$tex_dir_rel"
        lua_container_wd="/workdir/$tex_dir_rel"
    fi

    # Copy LPSB files
    # - pdflatex build only needs lpsb.sty (structure)
    cp "$LPSB_DIR/lpsb.sty" "$pd_tex_dir/" 2>/dev/null || true
    # - lualatex build needs math/table extensions too
    cp "$LPSB_DIR/lpsb.sty" "$lua_tex_dir/" 2>/dev/null || true
    cp "$LPSB_DIR/lpsb-luamath.sty" "$lua_tex_dir/" 2>/dev/null || true
    cp "$LPSB_DIR/lpsb-math.lua" "$lua_tex_dir/" 2>/dev/null || true
    cp "$LPSB_DIR/lpsb-luatable.sty" "$lua_tex_dir/" 2>/dev/null || true
    cp "$LPSB_DIR/lpsb-table.lua" "$lua_tex_dir/" 2>/dev/null || true
    
    
    # Determine Docker Image based on 00README.json (arXiv post-2024-summer format)
    # arXiv updated their compilation system in summer 2024, and now includes
    # 00README.json with texlive_version and compiler information
    # Overrides:
    # - LPSB_DOCKER_IMAGE_OVERRIDE: force an explicit image tag (e.g. texlive/texlive:TL2022-historic)
    # - LPSB_TEXLIVE_VERSION_OVERRIDE: force a TeX Live year (e.g. 2022/2023/2024/2025)
    if [ -n "${LPSB_DOCKER_IMAGE_OVERRIDE:-}" ]; then
        DOCKER_IMAGE="$LPSB_DOCKER_IMAGE_OVERRIDE"
        echo "  Docker image override: $DOCKER_IMAGE"
    else
        DOCKER_IMAGE="lpsb-texlive:latest"
        if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
            DOCKER_IMAGE="texlive/texlive:latest"
        fi
    fi
    selected_texlive_version=""
    
    if [ -n "${LPSB_TEXLIVE_VERSION_OVERRIDE:-}" ]; then
        tl_version="$LPSB_TEXLIVE_VERSION_OVERRIDE"
        compiler=""
        echo "  TeX Live override: $tl_version"
        selected_texlive_version="$tl_version"
    elif [ -f "$workdir/00README.json" ]; then
        # Extract texlive_version from 00README.json
        tl_version=$(grep -o '"texlive_version"[[:space:]]*:[[:space:]]*"[^"]*"' "$workdir/00README.json" 2>/dev/null | cut -d'"' -f4 || echo "")
        
        # Extract compiler (for future use, currently we always use pdflatex)
        compiler=$(grep -o '"compiler"[[:space:]]*:[[:space:]]*"[^"]*"' "$workdir/00README.json" 2>/dev/null | cut -d'"' -f4 || echo "")
        
        if [ -n "$tl_version" ] && [ -z "${LPSB_DOCKER_IMAGE_OVERRIDE:-}" ]; then
            case "$tl_version" in
                "2022")
                    # TeX Live 2022 - try historic image tag
                    DOCKER_IMAGE="lpsb-texlive:TL2022-historic"
                    if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                        DOCKER_IMAGE="texlive/texlive:TL2022-historic"
                    fi
                    echo "  TeX Live: 2022 (Historic)"
                    ;;
                "2023")
                    # TeX Live 2023 - use historic image
                    DOCKER_IMAGE="lpsb-texlive:TL2023-historic"
                    if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                        DOCKER_IMAGE="texlive/texlive:TL2023-historic"
                    fi
                    echo "  TeX Live: 2023 (Historic)"
                    ;;
                "2024")
                    # TeX Live 2024 - try TL2024-historic, fallback to latest
                    DOCKER_IMAGE="lpsb-texlive:TL2024-historic"
                    if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                        DOCKER_IMAGE="lpsb-texlive:latest"
                        if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                            DOCKER_IMAGE="texlive/texlive:latest"
                        fi
                    fi
                    echo "  TeX Live: 2024 (from 00README.json)"
                    ;;
                "2025"|"2026"|"2027"|"2028"|"2029"|"2030")
                    # Recent/future versions - use latest (which should be >= 2024)
                    DOCKER_IMAGE="lpsb-texlive:latest"
                    if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                        DOCKER_IMAGE="texlive/texlive:latest"
                    fi
                    echo "  TeX Live: $tl_version (using latest image)"
                    ;;
                *)
                    # Unknown version - use latest and warn
                    echo "  WARNING: Unknown TeX Live version '$tl_version' in 00README.json, using latest"
                    ;;
            esac
            
            if [ -n "$compiler" ]; then
                echo "  Compiler in 00README.json: $compiler (using lualatex for math/table support)"
            fi
            selected_texlive_version="$tl_version"
        else
            echo "  NOTE: 00README.json found but no texlive_version field"
        fi
    else
        echo "  NOTE: No 00README.json found (pre-2024-summer arXiv format or custom source)"
        # For old arXiv sources: if a biblatex-generated .bbl is present, use its format version
        # to choose a compatible TeX Live (prevents biblatex format mismatch).
        if [ -z "${LPSB_DOCKER_IMAGE_OVERRIDE:-}" ] && [ -z "${LPSB_TEXLIVE_VERSION_OVERRIDE:-}" ]; then
            bbl_dir="$workdir"
            if [ "$tex_dir_rel" != "." ]; then
                bbl_dir="$workdir/$tex_dir_rel"
            fi

            bbl_file=""
            if [ -f "$bbl_dir/$main_base.bbl" ]; then
                bbl_file="$bbl_dir/$main_base.bbl"
            else
                # If there's exactly one .bbl, use it as a hint.
                # (Don't scan deep: keep it cheap.)
                one_bbl="$(ls "$bbl_dir"/*.bbl 2>/dev/null | head -1 || true)"
                if [ -n "$one_bbl" ]; then
                    bbl_file="$one_bbl"
                fi
            fi

            if [ -n "$bbl_file" ] && [ -f "$bbl_file" ]; then
                bbl_fmt="$(detect_biblatex_bbl_format_version "$bbl_file")"
                if [ -n "$bbl_fmt" ]; then
                    bbl_year="$(map_bbl_format_to_texlive_year "$bbl_fmt")"
                    if [ -n "$bbl_year" ]; then
                        echo "  Detected biblatex .bbl format $bbl_fmt -> TeX Live $bbl_year"
                        selected_texlive_version="$bbl_year"
                        case "$bbl_year" in
                            "2022")
                                DOCKER_IMAGE="lpsb-texlive:TL2022-historic"
                                if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                                    DOCKER_IMAGE="texlive/texlive:TL2022-historic"
                                fi
                                ;;
                            "2023")
                                DOCKER_IMAGE="lpsb-texlive:TL2023-historic"
                                if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                                    DOCKER_IMAGE="texlive/texlive:TL2023-historic"
                                fi
                                ;;
                            "2024")
                                DOCKER_IMAGE="lpsb-texlive:TL2024-historic"
                                if ! docker image inspect "$DOCKER_IMAGE" >/dev/null 2>&1; then
                                    DOCKER_IMAGE="texlive/texlive:TL2024-historic"
                                fi
                                ;;
                            *)
                                : # keep default
                                ;;
                        esac
                    else
                        echo "  NOTE: Detected biblatex .bbl format $bbl_fmt but no mapping; using default image"
                    fi
                fi
            fi
        fi
    fi

    # Always log the resolved image + inferred texlive year (best effort).
    inferred_tl="$(infer_texlive_year_from_docker_image "$DOCKER_IMAGE")"
    if [ -z "$selected_texlive_version" ] && [ -n "$inferred_tl" ]; then
        selected_texlive_version="$inferred_tl"
    fi
    if [ -n "$selected_texlive_version" ]; then
        echo "  TeX Live selected: $selected_texlive_version (image: $DOCKER_IMAGE)"
    else
        echo "  TeX Live selected: unknown (image: $DOCKER_IMAGE)"
    fi
    
    jobname="$main_base"

    # -------------------------
    # Stage A: PDFLaTeX gold
    # -------------------------
    pd_main_tex_full="$pdflatex_dir/$main_tex"
    inject_pkg_after_documentclass "$pd_main_tex_full" "lpsb"

    echo "  [A] Compiling gold PDF/structure with PDFLaTeX (pass 1)..."
    docker run --rm -v "$pdflatex_dir":/workdir -w "$pd_container_wd" "$DOCKER_IMAGE" \
        pdflatex -interaction=nonstopmode -jobname="$jobname" "$main_tex_basename" \
        > "$workdir/pdflatex_compile1.log" 2>&1
    rc_pd_1=$?

    # Bibliography for gold
    if [ -f "$pd_tex_dir/$jobname.bbl" ]; then
        echo "  [A] Using existing .bbl..."
    elif grep -q 'biblatex' "$pd_main_tex_full" 2>/dev/null; then
        echo "  [A] Running biber..."
        docker run --rm -v "$pdflatex_dir":/workdir -w "$pd_container_wd" "$DOCKER_IMAGE" \
            biber "$jobname" > "$workdir/pdflatex_biber.log" 2>&1 || true
    elif grep -q 'bibliography' "$pd_main_tex_full" 2>/dev/null || ls "$pdflatex_dir"/*.bib >/dev/null 2>&1; then
        echo "  [A] Running bibtex..."
        docker run --rm -v "$pdflatex_dir":/workdir -w "$pd_container_wd" "$DOCKER_IMAGE" \
            bibtex "$jobname" > "$workdir/pdflatex_bibtex.log" 2>&1 || true
    fi

    for pass in 2 3; do
        echo "  [A] Compiling gold PDF/structure with PDFLaTeX (pass $pass)..."
        docker run --rm -v "$pdflatex_dir":/workdir -w "$pd_container_wd" "$DOCKER_IMAGE" \
            pdflatex -interaction=nonstopmode -jobname="$jobname" "$main_tex_basename" \
            > "$workdir/pdflatex_compile$pass.log" 2>&1
        eval "rc_pd_$pass=$?"
    done

    # -------------------------
    # Stage B: LuaLaTeX enrichment (math/table)
    # -------------------------
    lua_main_tex_full="$lualatex_dir/$main_tex"
    inject_pkg_after_documentclass "$lua_main_tex_full" "lpsb"
    inject_pkg_after_documentclass "$lua_main_tex_full" "lpsb-luamath"
    inject_pkg_after_documentclass "$lua_main_tex_full" "lpsb-luatable"

    echo "  [B] Compiling math/table with LuaLaTeX (pass 1)..."
    docker run --rm -v "$lualatex_dir":/workdir -w "$lua_container_wd" "$DOCKER_IMAGE" \
        lualatex -interaction=nonstopmode -jobname="$jobname" "$main_tex_basename" \
        > "$workdir/lualatex_compile1.log" 2>&1
    rc_lua_1=$?

    # Bibliography for lua pass (best effort)
    if [ -f "$lua_tex_dir/$jobname.bbl" ]; then
        : # use existing bbl
    elif grep -q 'biblatex' "$lua_main_tex_full" 2>/dev/null; then
        docker run --rm -v "$lualatex_dir":/workdir -w "$lua_container_wd" "$DOCKER_IMAGE" \
            biber "$jobname" > "$workdir/lualatex_biber.log" 2>&1 || true
    elif grep -q 'bibliography' "$lua_main_tex_full" 2>/dev/null || ls "$lualatex_dir"/*.bib >/dev/null 2>&1; then
        docker run --rm -v "$lualatex_dir":/workdir -w "$lua_container_wd" "$DOCKER_IMAGE" \
            bibtex "$jobname" > "$workdir/lualatex_bibtex.log" 2>&1 || true
    fi

    for pass in 2 3; do
        echo "  [B] Compiling math/table with LuaLaTeX (pass $pass)..."
        docker run --rm -v "$lualatex_dir":/workdir -w "$lua_container_wd" "$DOCKER_IMAGE" \
            lualatex -interaction=nonstopmode -jobname="$jobname" "$main_tex_basename" \
            > "$workdir/lualatex_compile$pass.log" 2>&1
        eval "rc_lua_$pass=$?"
    done
    
    # Analyze results
    pdf_exists=false
    json_exists=false
    math_json_exists=false
    table_json_exists=false
    has_errors=false
    has_warnings=false
    
    if [ -f "$pd_tex_dir/$jobname.pdf" ]; then
        pdf_exists=true
        pdf_size=$(stat -c%s "$pd_tex_dir/$jobname.pdf" 2>/dev/null || echo "0")
        echo "  ✓ PDF: $(($pdf_size/1024))KB"
    else
        has_errors=true
        echo "  ✗ PDF: FAILED"
    fi
    
    # Check for structure JSON
    if [ -f "$pd_tex_dir/$jobname.lpsb.json" ]; then
        json_exists=true
        line_count=$(wc -l < "$pd_tex_dir/$jobname.lpsb.json" 2>/dev/null || echo 0)
        echo "  ✓ Structure JSON: $line_count lines"
    else
        echo "  ✗ Structure JSON: NOT GENERATED"
    fi
    
    # Check for math JSON
    if [ -f "$lua_tex_dir/$jobname.lpsb-math.json" ]; then
        math_json_exists=true
        math_count="$( (grep -c '"role": "Math"' "$lua_tex_dir/$jobname.lpsb-math.json" 2>/dev/null || true) | tr -d '\n' )"
        math_count="${math_count:-0}"
        math_count=$((math_count / 2))  # start + end = 2 entries per formula
        echo "  ✓ Math JSON: $math_count formulas"
    else
        echo "  ✗ Math JSON: NOT GENERATED"
    fi
    
    # Check for table JSON
    if [ -f "$lua_tex_dir/$jobname.lpsb-table.json" ]; then
        table_json_exists=true
        table_count="$( (grep -c '"role": "Table"' "$lua_tex_dir/$jobname.lpsb-table.json" 2>/dev/null || true) | tr -d '\n' )"
        table_count=${table_count:-0}  # Ensure it's a number
        echo "  ✓ Table JSON: $table_count tables"
    else
        table_count=0
        echo "  ✗ Table JSON: NOT GENERATED"
    fi
    
    # Check for errors in logs
    if grep -q "^!" "$workdir/pdflatex_compile3.log" 2>/dev/null || \
       grep -q "LaTeX Error:" "$workdir/pdflatex_compile3.log" 2>/dev/null; then
        has_errors=true
    fi
    
    if grep -q "Overfull\|Underfull" "$workdir/pdflatex_compile3.log" 2>/dev/null; then
        has_warnings=true
        WARNINGS=$((WARNINGS + 1))
    fi

    # Merge (best effort): inject Lua math/table into gold structure stream.
    merged_json_exists=false
    if [ "$json_exists" = true ] && [ "$math_json_exists" = true ]; then
        merged_json="$workdir/$jobname.lpsb.merged.json"
        if [ -f "$lua_tex_dir/$jobname.lpsb-table.json" ]; then
            python3 "$LPSB_MERGE_PY" \
                "$pd_tex_dir/$jobname.lpsb.json" \
                "$lua_tex_dir/$jobname.lpsb-math.json" \
                "$merged_json" \
                "$lua_tex_dir/$jobname.lpsb-table.json" \
                > "$workdir/merge.log" 2>&1 || true
        else
            python3 "$LPSB_MERGE_PY" \
                "$pd_tex_dir/$jobname.lpsb.json" \
                "$lua_tex_dir/$jobname.lpsb-math.json" \
                "$merged_json" \
                > "$workdir/merge.log" 2>&1 || true
        fi
        if [ -f "$merged_json" ]; then
            merged_json_exists=true
            merged_lines=$(wc -l < "$merged_json" 2>/dev/null || echo 0)
            echo "  ✓ Merged JSON: $merged_lines lines"
        else
            echo "  ✗ Merged JSON: NOT GENERATED"
        fi
    fi
    
    # Update statistics
    if [ "$pdf_exists" = true ]; then
        SUCCESS=$((SUCCESS + 1))
    else
        FAILED=$((FAILED + 1))
    fi
    
    # Write detailed report
    {
        echo ""
        echo "=========================================="
        echo "PAPER: $name"
        echo "Main file: $main_tex"
        echo "Docker image: $DOCKER_IMAGE"
        echo "TeX Live selected: ${selected_texlive_version:-unknown}"
        echo "=========================================="
        echo "STATUS: $([ "$pdf_exists" = true ] && echo "SUCCESS" || echo "FAILED")"
        echo "PDF: $([ "$pdf_exists" = true ] && echo "Generated ($(($pdf_size/1024))KB)" || echo "NOT GENERATED")"
        echo "Structure JSON: $([ "$json_exists" = true ] && echo "Generated ($line_count lines)" || echo "NOT GENERATED")"
        echo "Math JSON: $([ "$math_json_exists" = true ] && echo "Generated ($math_count formulas)" || echo "NOT GENERATED")"
        echo "Table JSON: $([ "$table_json_exists" = true ] && echo "Generated ($table_count tables)" || echo "NOT GENERATED")"
        echo ""
        
        if [ "$has_errors" = true ] || [ "$has_warnings" = true ]; then
            echo "ERRORS AND WARNINGS (gold / pdflatex):"
            extract_errors "$workdir/pdflatex_compile3.log" "$name"
            echo ""
        fi

        # Also capture lua-pass errors (they should NOT affect gold PDF, but affect enrichment).
        if grep -q "^!" "$workdir/lualatex_compile3.log" 2>/dev/null || \
           grep -q "LaTeX Error:" "$workdir/lualatex_compile3.log" 2>/dev/null; then
            echo "ERRORS (enrichment / lualatex):"
            extract_errors "$workdir/lualatex_compile3.log" "$name"
            echo ""
        fi
        
        echo "Return codes:"
        echo "  pdflatex pass 1: ${rc_pd_1:-?}"
        echo "  pdflatex pass 2: ${rc_pd_2:-?}"
        echo "  pdflatex pass 3: ${rc_pd_3:-?}"
        echo "  lualatex pass 1: ${rc_lua_1:-?}"
        echo "  lualatex pass 2: ${rc_lua_2:-?}"
        echo "  lualatex pass 3: ${rc_lua_3:-?}"
        echo ""
        echo "Log files:"
        echo "  $workdir/pdflatex_compile*.log"
        echo "  $workdir/lualatex_compile*.log"
        echo "  $workdir/merge.log"
        echo ""
    } >> "$REPORT_FILE"
    
    cd - > /dev/null
done

# Generate summary
{
    echo "=========================================="
    echo "COMPILATION SUMMARY"
    echo "=========================================="
    echo "Total papers: $TOTAL"
    echo "Successful: $SUCCESS"
    echo "Failed: $FAILED"
    echo "Warnings: $WARNINGS"
    echo "No main .tex: $NO_MAIN_TEX"
    echo ""
    echo "Success rate: $(awk "BEGIN {printf \"%.1f\", ($SUCCESS/$TOTAL)*100}")%"
    echo ""
    echo "Detailed report: $REPORT_FILE"
    echo "=========================================="
} | tee "$SUMMARY_FILE"

# Append summary to report
{
    echo ""
    echo "=========================================="
    echo "SUMMARY"
    echo "=========================================="
    cat "$SUMMARY_FILE"
} >> "$REPORT_FILE"

echo ""
echo "=========================================="
echo "Compilation Complete"
echo "=========================================="
echo "Summary: $SUMMARY_FILE"
echo "Full report: $REPORT_FILE"
echo "Results directory: $LPSB_OUT_DIR"
echo "=========================================="

