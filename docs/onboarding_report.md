# LPSB Onboarding / Repo Health Report (for new teammates)

This document is the “read me first” operational guide for running LPSB locally, understanding where data lives, and knowing what to fix next.

---

## TL;DR: What is this repo?

LPSB instruments LaTeX to emit **structure events + PDF coordinates** into `*.lpsb.json`, then reconstructs a tree with Python (`solver.py`). Optionally, a LuaLaTeX pass can enrich:

- **Math**: `*.lpsb-math.json` (inline + display math, optionally with MathML)
- **Tables**: `*.lpsb-table.json` (TR/TD + colspan + bbox, via LuaTeX node callbacks)

---

## Where things are (paths)

These paths are the current conventions in this workspace. Scripts now use **environment variables with sane defaults** (see `docs/env.example`) so a fresh clone can run without machine-specific absolute paths.

- **Repo root**: `LPSB_DIR` (default: auto-detected from script location)
- **arXiv source tarballs**: `LPSB_DATA_DIR` (default: `$LPSB_DIR/data/download/*.tar.gz`)
- **Python venv (has `pdfplumber`)**: `/home/duan/rainbow_2/.venv`
  - Activate: `source /home/duan/rainbow_2/.venv/bin/activate`

---

## Docker: images you need and how to build them

### Recommended image tag

Batch scripts prefer `lpsb-texlive:latest` (local image). If it does not exist, they fall back to upstream `texlive/texlive:latest`.

Build it:

```bash
cd /path/to/LPSB
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
```

### TeX Live 2023 (historic) for arXiv toolchain pinning

Some arXiv sources include `00README.json` with `"texlive_version": "2023"`. This matters for things like `biblatex` `.bbl` format/version compatibility.

This repo's `docker/Dockerfile.tl2023` also **vendors `luamml` runtime** into the historic image (under `TEXMFLOCAL`) so the LuaLaTeX pass can emit **MathML** even on frozen TeX Live releases.

Build:

```bash
cd /path/to/LPSB
docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker
```

### TeX Live 2022 (historic) for older biblatex `.bbl` formats (optional)

Some older arXiv sources (pre-`00README.json`) ship a pre-generated `.bbl` created by `biblatex/biber`.
Those `.bbl` files can be **format-version strict**, and compiling them with a newer TeX Live can fail
or produce inconsistent outputs.

This repo provides a TL2022 image with `luamml` runtime vendored in (for MathML extraction in the Lua pass):

```bash
cd /path/to/LPSB
docker build -f docker/Dockerfile.tl2022 -t lpsb-texlive:TL2022-historic docker
```

### TeX Live 2024 (optional)

```bash
cd /path/to/LPSB
docker build -f docker/Dockerfile.tl2024 -t lpsb-texlive:TL2024-historic docker
```

---

## The main “entry points” (scripts)

### 1) Batch compile (structure pass, PDFLaTeX)

- Script: `script/test_batch.sh`
- Input tarballs: `/home/duan/rainbow_2/data/download/*.tar.gz`
- Output dir: `/home/duan/rainbow_2/LPSB/test_output/<paper>/`

Runs `pdflatex` (3 passes) and handles bibliography (`biber`/`bibtex`) when needed.

### 2) Batch compile (math pass, LuaLaTeX / MathML)

- Script: `script/test_lua_batch.sh`
- Output dir: `/home/duan/rainbow_2/LPSB/test_output_lua/<paper>/`

Injects `lpsb` + `lpsb-luamath` and runs `lualatex` multiple passes.

### 3) Merge (structure + math/table)

- Script: `hybrid_merge.sh`
- Output dir: `/home/duan/rainbow_2/LPSB/test_output_merged/`

Calls `merge_lpsb.py` to add MathML fields (and optionally table-pass data).

### 4) One-paper full pipeline

- Script: `run_full_pipeline.sh <paper_dir_or_tarball>`
- Output dir: `output_pipeline/<paper>/`

This is the most “one-button” workflow for a single paper: structure pass → lua pass → merge.

---

## How TeX Live selection works (and why)

When a paper has `00README.json`, batch scripts read:

- **`texlive_version`**: selects Docker image (e.g. `TL2023-historic` vs `latest`)
- **`compiler`** (used by `run_full_pipeline.sh`): selects `pdflatex` vs `xelatex` vs `lualatex` for the structure pass

Rationale: arXiv submissions sometimes include pre-generated artifacts (notably `.bbl`) that can be version-sensitive.

For older arXiv sources **without** `00README.json`, `script/batch_compile_all.sh` uses a conservative fallback:

- If a `biblatex`-generated `.bbl` exists, read its header line:
  - `% $ biblatex bbl format version X.Y $`
- Map it to a TeX Live historic image (heuristic; example: `3.1 -> TL2022`).

The script prints the resolved choice in logs as:

- `TeX Live selected: <year> (image: <docker-tag>)`

---

## Python: dependencies and what they’re used for

- `solver.py`: parse `*.lpsb.json` and reconstruct a tree (`*.structure.json`)
- `merge_lpsb.py`: merge structure + math/table logs
- `extract_cells.py` (pdfplumber): PDF-side table cell extraction (alternative to Lua table pass)

Install dependencies (choose one):

```bash
cd /home/duan/rainbow_2/LPSB
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

or use the existing shared venv at `/home/duan/rainbow_2/.venv`.

---

## Repo layout (quick mental map)

- **Core LaTeX packages**
  - `lpsb.sty`: structure pass (PDFLaTeX)
  - `lpsb-luamath.sty`, `lpsb-math.lua`: LuaLaTeX math capture
  - `lpsb-luatable.sty`, `lpsb-table.lua`: LuaLaTeX table capture
- **Python**
  - `solver.py`: build tree from events
  - `merge_lpsb.py`: merge passes
  - `extract_cells.py`: PDF-side table extraction (pdfplumber)
- **Docs**
  - `docs/table_cells.md`: PDF-side table cells (A方案)
  - `docs/lua_table_pass.md`: LuaLaTeX table pass (B方案)
- **Docker**
  - `docker/Dockerfile.latest`, `docker/Dockerfile.tl2023`, `docker/Dockerfile.tl2024`
- **Data / outputs (generated)**
  - `test_output/`, `test_output_lua/`, `test_output_merged/`
  - `output_pipeline/` (single-paper pipeline runs)

---

## Known “sharp edges” a new teammate should know

### 1) Paths are configurable via env vars (no hard-coded absolute paths)

Key vars (all optional):

- `LPSB_DIR`: repo root (default: auto-detected)
- `LPSB_DATA_DIR`: arXiv tarballs dir (default: `$LPSB_DIR/data/download`)
- `LPSB_OUT_DIR`: structure pass output (default: `$LPSB_DIR/test_output`)
- `LPSB_OUT_LUA_DIR`: lua pass output (default: `$LPSB_DIR/test_output_lua`)
- `LPSB_OUT_MERGED_DIR`: merged output (default: `$LPSB_DIR/test_output_merged`)

There is a copy/paste template at `docs/env.example` (recommended: `cp docs/env.example .env` and `set -a; source .env; set +a`).

### 2) Git ignore rules are aggressive

`.gitignore` ignores many generated trees and also broad patterns like `test*/`, `tmp*/`, and `data/`. Make sure new docs live under `docs/` (tracked).

### 3) Table extraction: PDF-side is recommended

Hooking `tabular` macros in LaTeX is fragile and causes issues:
- **Visual artifacts**: dangling vertical lines, extra rules
- **Row detection**: `\everycr` hooks don't fire reliably
- **colspan/rowspan**: `\multicolumn`/`\multirow` hooks interfere with rendering

**Recommended approach: PDF-side extraction** (`extract_cells.py`)

| Method | Row Detection | colspan | rowspan | Reliability |
|--------|---------------|---------|---------|-------------|
| Lua hpack_filter | ❌ No | ❌ Lost | ❌ Lost | Low |
| LaTeX hooks | ⚠️ Risky | ⚠️ Complex | ⚠️ Complex | Medium |
| **PDF-side (pdfplumber)** ✅ | ✅ Perfect | ✅ Perfect | ✅ Perfect | High |

Workflow:
```bash
# 1. Compile (generates PDF)
lualatex doc.tex

# 2. Extract table cells from PDF
python extract_cells.py doc.pdf -o doc.lpsb-table.json
```

The Lua-based `lpsb-luatable` still runs during compilation to capture cell text and approximate bbox, but for accurate row/column/span info, use `extract_cells.py` as post-processing.

---

## Current status: what to fix next (engineering list)

- **Path configurability**: remove hard-coded `/home/duan/...` paths from scripts (make env-var driven).
- **Table extraction pipeline**:
  - ✅ DONE: `extract_cells.py` for PDF-side extraction with colspan/rowspan support
  - ✅ DONE: Log markers in `lpsb-luatable.sty` for row tracking
  - TODO: Integrate into batch scripts (`test_lua_batch.sh`)
- **Rotated tables**:
  - `sidewaystable`/rotation handling exists in structure pass
  - PDF-side extraction via pdfplumber should handle rotated tables correctly
  - Needs more real-paper coverage

---

## Quick commands (copy/paste)

Build docker:

```bash
cd /path/to/LPSB
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker
```

Batch run:

```bash
cd /path/to/LPSB
# Optional: set local overrides
cp docs/env.example .env
set -a; source .env; set +a

bash script/test_batch.sh
bash script/test_lua_batch.sh
bash hybrid_merge.sh
```

Tree build:

```bash
cd /path/to/LPSB
source .venv/bin/activate
python3 solver.py /path/to/main.lpsb.json --output /path/to/main.structure.json --validate
```

Table extraction (PDF-side):

```bash
# Extract tables with colspan/rowspan detection
python extract_cells.py main.pdf -o main.lpsb-table.json

# Or just view the structure
python extract_cells.py main.pdf | python -c "import json,sys; print(json.dumps(json.load(sys.stdin), indent=2))"
```


