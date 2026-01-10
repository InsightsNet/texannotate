# LPSB: LaTeX-PDF Semantic Bridge (LaTeX Rainbow 2.0)

LPSB extracts semantic structure from LaTeX compilations and aligns it with PDF page coordinates. It produces a single event log (`*.lpsb.json`) that can be rebuilt into a tree (`*.structure.json`) and can be enriched with MathML from a LuaLaTeX pass.

## Status / Version Notice (READ THIS FIRST)

This repository is **LaTeX Rainbow 2.0**: a **complete rewrite / restructuring** of the original codebase. It is under active development and **not stable**.

If you need a version that works today, use the **`v1` branch** (the previous implementation).

## Key Features

- **PDF structure events**: emits start/end events for common PDF/UA-ish roles.
  - **Structure**: `Document`, `Sect`, `Div`
  - **Headings**: `H1`-`H6`
  - **Lists**: `L`, `LI`, `Lbl`
  - **Tables**: `Table`, `TR` (rows)
  - **Figures**: `Figure`, `Caption`
  - **Inline**: `Strong`, `Em`, `Link`, `Reference`
- **Math capture**
  - **PDFLaTeX**: captures display math environments as `Formula` (e.g. `equation`, `align`).
  - **LuaLaTeX extension** (`lpsb-luamath`): captures *all* math including `$...$` and can emit **MathML** via `luamml`.
  - **LaTeXML stage (default)**: emits MathML without LuaTeX; alignment is best-effort and positions remain from PDFLaTeX (gold).
- **Robust logs**: `solver.py` includes fault-tolerant parsing for “dirty” JSON emitted by TeX.
- **Batchable via Docker**: scripts run against arXiv source tarballs, producing reproducible output directories.

---

## Quick Start

### Build the recommended Docker image (MathML enabled)

The scripts prefer a local image tag `lpsb-texlive:latest` if available.

```bash
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
```

### Optional: build TeX Live 2023 image (for older arXiv toolchains)

Some arXiv sources pin TeX Live (via `00README.json` / `texlive_version`). In particular, `biblatex` `.bbl` files can be version-strict.

If you want reproducible builds for TL2023 papers, build this tag too:

```bash
docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker
```

> Note: `docker/Dockerfile.tl2023` also vendors `luamml` runtime into the historic image (under `TEXMFLOCAL`)
> so the LuaLaTeX pass can emit **MathML** even on frozen TeX Live releases.

### Optional: build TeX Live 2022 image (for older biblatex `.bbl` formats)

Older arXiv sources (pre-`00README.json`) may ship a pre-generated `biblatex` `.bbl` that is **format-version strict**.
For those, compiling with a newer TeX Live can fail (or silently diverge).

This repo provides a TL2022 historic image that also vendors `luamml` runtime (so the LuaLaTeX pass can still emit MathML):

```bash
docker build -f docker/Dockerfile.tl2022 -t lpsb-texlive:TL2022-historic docker
```

### Single file (local directory)

Copy `lpsb.sty` into the same directory as your `main.tex` and add:

```tex
\usepackage{lpsb}
```

Then compile:

```bash
docker run --rm -v "$(pwd)":/workdir -w /workdir lpsb-texlive:latest \
  pdflatex -interaction=nonstopmode main.tex
```

Output: `main.lpsb.json` (Structure only)

 ### Dual-Track Compilation (MathML Support)

 To extract **MathML** and inline formulas (`$...$`), run a second pass with LuaLaTeX:

 1. **Pass 1 (Structure)**: Run PDFLaTeX as above.
 2. **Pass 2 (Math)**: Add `\usepackage{lpsb-luamath}` to your tex file (or inject it), then run:

 ```bash
 docker run --rm -v "$(pwd)":/workdir -w /workdir lpsb-texlive:latest \
   lualatex -interaction=nonstopmode main.tex
 ```

 Output: `main.lpsb-math.json` (Math events with MathML)

 > **Note**: The official batch scripts (`script/test_lua_batch.sh`) handle package injection automatically.

### Stage B engine selection (compiler script)

`script/lpsb_compiler.py` supports an optional Stage B enrichment engine:

- `LPSB_STAGE_B_ENGINE=latexml` (default): LaTeXML MathML/table extraction (no coordinates)
- `LPSB_STAGE_B_ENGINE=lua`: LuaLaTeX MathML/table passes
- `LPSB_STAGE_B_ENGINE=none`: disable Stage B

For `LPSB_STAGE_B_ENGINE=latexml`, the compiler can persist LaTeXML caches (notably expl3) across runs:
- Default cache root: `latexml_cache/TL<year>/`
- Toggle: `LPSB_LATEXML_CACHE=0` to disable

### Build a structure tree

Use the Python solver to reconstruct the DOM tree:

```bash
python3 solver.py main.lpsb.json --output main.structure.json --validate
```

### Optional: extract table cells (TR/TD) from the PDF

By default, LPSB does **not** hook `tabular` internals (to avoid TeX alignment/rule artifacts). If you need `TR/TD`, extract them from the compiled PDF using `pdfplumber`:

```bash
python3 solver.py main.lpsb.json --pdf main.pdf --extract-cells --output main.structure.json
```

Details: see `docs/table_cells.md`.

### Optional (LuaLaTeX): table pass (TR/TD + colspan + bbox)

If you want TR/TD from a LuaLaTeX pass (similar to the MathML pipeline), see:

- `docs/lua_table_pass.md`

### Batch processing (arXiv source tarballs)

Put `*.tar.gz` into `data/download/`, then run:

```bash
# Recommended: Python batch compiler (with Docker container reuse)
python3 script/lpsb_compiler.py --batch data/download --output compile_results --workers 8
```

Or use the shell script:

```bash
# - Stage A (gold): pdflatex -> PDF + *.lpsb.json
# - Stage B (enrich): lualatex -> *.lpsb-math.json (MathML) + *.lpsb-table.json
# - Merge: *.lpsb.merged.json
bash script/batch_compile_all.sh
```

#### Docker Container Reuse (Performance)

The Python compiler (`lpsb_compiler.py`) supports Docker container reuse to eliminate container startup overhead (~0.5-1s per command):

```bash
# Container reuse is ENABLED by default
python3 script/lpsb_compiler.py --batch data/download -o compile_results --workers 8

# Disable container reuse if needed
python3 script/lpsb_compiler.py --batch data/download -o compile_results --no-reuse-containers
```

**Features:**
- Pre-scans papers to detect required TeX Live versions
- Starts one container per TeX Live version (e.g., TL2023, TL2025)
- Uses `docker exec` instead of `docker run` for subsequent commands
- Automatically cleans up containers after batch completes

**LaTeXML cache in reuse mode:**
- When `LPSB_LATEXML_CACHE=1` (default), the compiler mounts a persistent host cache directory into each reused container:
  - Default cache root: `latexml_cache/TL<year>/`
  - Override with `LPSB_LATEXML_CACHE_ROOT=/path/to/cache_root`
- This makes LaTeXML's caches (notably expl3/L3) persist across runs even when using `docker exec`.

Outputs:

- `compile_results/<paper>/`: per-paper outputs (gold + enrich + logs)
  - `_pdflatex/`: gold PDF + `*.lpsb.json`
  - `_lualatex/`: `*.lpsb-math.json` (+ MathML when available) and `*.lpsb-table.json`
  - `*.lpsb.merged.json`: merged output (structure enriched with `mathml` and table events)

> **TeX Live selection**:
> - New arXiv sources: read `00README.json` / `texlive_version`.
> - Old arXiv sources (no `00README.json`): if a `biblatex` `.bbl` exists, infer TeX Live from the header
>   (`% $ biblatex bbl format version X.Y $`) and pick a matching historic image (heuristic).
> - The script prints: `TeX Live selected: <year> (image: <docker-tag>)`.

---

## Architecture

LPSB uses a 3-stage pipeline:

1. **Instrumentation (LaTeX)**: `lpsb.sty` hooks into LaTeX commands/environments and emits events + coordinates.
2. **Compilation (Docker)**: scripts compile papers in a container.
3. **Reconstruction (Python)**: `solver.py` parses the log, validates nesting, and builds a tree.

Optional:

4. **Math enrichment (LuaLaTeX)**: `lpsb-luamath.sty` + `lpsb-math.lua` captures math and emits MathML using `luamml`. `merge_lpsb.py` merges by context-aware IDs.

```
┌─────────────────────────────────────────────────────────────────────┐
│                         LaTeX source (.tex)                          │
└─────────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼ (package injected / \usepackage{lpsb})
┌─────────────────────────────────────────────────────────────────────┐
│                          Structure pass (PDFLaTeX)                   │
│  lpsb.sty                                                             │
│  - hooks environments/commands                                        │
│  - emits start/end events + page/coords                               │
└─────────────────────────────────────────────────────────────────────┘
                │                                   │
                ▼                                   ▼
      ┌──────────────────────┐            ┌──────────────────────────┐
      │  PDF output (*.pdf)  │            │  event log (*.lpsb.json) │
      └──────────────────────┘            └──────────────────────────┘
                                                   │
                                                   ▼
                                         ┌──────────────────────────┐
                                         │ solver.py                │
                                         │ - parse/validate events  │
                                         │ - build structure tree   │
                                         └──────────────────────────┘
                                                   │
                                                   ▼
                                         ┌──────────────────────────┐
                                         │ *.structure.json (tree)  │
                                         └──────────────────────────┘

Optional MathML track (LuaLaTeX):

┌─────────────────────────────────────────────────────────────────────┐
│                          Math pass (LuaLaTeX)                        │
│  lpsb-luamath.sty + lpsb-math.lua                                    │
│  - captures inline + display math (incl. $...$)                      │
│  - emits Math events + MathML via luamml                             │
└─────────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
                      ┌──────────────────────────────┐
                      │ *.lpsb-math.json (Math/MathML)│
                      └──────────────────────────────┘
                                 │
                                 ▼
                      ┌──────────────────────────────┐
                      │ merge_lpsb.py / hybrid_merge  │
                      │ -> merged JSON (mathml fields)│
                      └──────────────────────────────┘
```

---

## Current Capabilities & Status

| Category | Feature | Status | Notes |
|----------|---------|--------|-------|
| **Structure** | Sections (Sect) | ✅ | Maps `\section`, `\chapter` etc. |
| | Headings (H1-H6) | ✅ | Captures titles and hierarchy level |
| **Blocks** | Lists (L, LI) | ✅ | `itemize`, `enumerate`, `description` |
| | List Labels (Lbl) | ✅ | Captures `1.`, `a)`, `•` etc. |
| | Paragraphs (P) | ✅ | Uses kernel paragraph hooks (`para/begin`, `para/end`) |
| **Tables** | Table Container | ✅ (floats) / ⚠️ (longtable) | Float `table`/`table*` are instrumented. `longtable` hooks are disabled due to visual artifacts. |
| | Rows (TR) | ⚠️ | Best-effort; longtable row semantics are not reliable via TeX hooks. |
| | Cells (TD) | ⚠️ (Lua) / ✅ (PDF-side) | Lua TD capture is best-effort; recommended approach is PDF-side extraction (`extract_cells.py`). |
| | Colspan/Rowspan | ✅ (PDF-side) / ⚠️ (Lua) | PDF-side extractor supports spans; Lua pass may infer colspan but is not authoritative. |
| | Cell Bbox | ✅ (Lua) / ✅ (PDF-side) | Lua bbox is approximate; PDF-side tends to be more stable across engines. |
| **Math** | Display Formulas | ✅ | `equation`, `align`, `gather` |
| | Inline Formulas | ✅ (LuaLaTeX) | `$...$` captured by `lpsb-luamath` |
| | MathML | ✅ (LuaLaTeX) | Requires `luamml` runtime. Provided by `lpsb-texlive:latest`, and historic images `lpsb-texlive:TL2022-historic` / `lpsb-texlive:TL2023-historic`. |
| **Refs** | Citations | ✅ | `\cite` links to bibliography |
| | References | ✅ | `\ref`, `\label` linkages |
| **Accessibility** | Captions | ✅ | Figures and Tables |
| | Alt Text | ❌ | Not implemented |

### Known Limitations

1. **PDF is gold = PDFLaTeX**: the pipeline treats the PDFLaTeX output as the visual “gold” PDF. The LuaLaTeX pass is for enrichment only.
2. **Inline math in PDFLaTeX**: `$...$` is not hooked in PDFLaTeX. Use the LuaLaTeX math pass (`lpsb-luamath`) for inline math + MathML.
3. **MathML depends on `luamml`**: if your container image does not ship `luamml`, `mathml` will be empty. Use `lpsb-texlive:latest` or the provided historic images with vendored `luamml`.
4. **Table extraction is still messy**:
   - Hooking `tabular` internals in TeX is fragile and can create visual artifacts.
   - `longtable` is especially fragile; hooks are disabled to preserve rendering.
   - Recommended: PDF-side cell extraction (`extract_cells.py`) for reliable TD/row/col/span.
5. **Weird macros win**: heavily customized macros/classes/packages can bypass hooks or reorder output in ways that break event nesting.
6. **Coordinate sources**: All position coordinates come **exclusively from pdfLaTeX (Stage A)**. LuaLaTeX (Stage B) is used **only for MathML enrichment**, never for coordinates, because LuaLaTeX can produce slightly different page layouts that would cause coordinate drift.
7. **Strong/Em in math mode**: When `\textbf`/`\textit` is used inside math mode (e.g., `\bm{\textbf{...}}`), coordinates are skipped to avoid `\bm` package conflicts. These entries have `"inMathMode": true` in JSON and can inherit coordinates from their parent InlineMath/DisplayMath events.
8. **ACM templates (`acmart.cls`)**: LPSB delays activation until `\maketitle` to prevent blank first page issues. Abstract events are captured by hooking into ACM's internal `\@mkabstract` command during rendering. All elements work normally.

### Recent Fixes (2026-01)

#### LuaTeX Compatibility (`lpsb.sty`)

The LuaLaTeX enrichment pass (Stage B) now includes several compatibility fixes to handle older arXiv papers:

- **pdfTeX primitive compatibility**: Defines `\pdfoutput`, `\pdfminorversion`, `\pdfcompresslevel`, `\pdfpagewidth`, `\pdfpageheight` when running under LuaTeX to prevent "Missing \begin{document}" errors.
- **xypdf package compatibility**: Provides `\pdftexversion` and `\pdfsave`/`\pdfrestore` definitions to satisfy xypdf's version check (`! Package xypdf Error: pdfTeX version 1.40.0 or higher is needed`).
- **`\savepos` protection**: Saves and restores the original LuaTeX `\savepos` definition to prevent conflicts with packages like xypdf that incorrectly redefine it.
- **inputenc compatibility**: Defines a no-op `\inputencoding` for LuaTeX to prevent `! Package inputenc Error: inputenc is not designed for xetex or luatex`.

#### Stage B Error Handling (`lpsb_compiler.py`)

- **Non-fatal Stage B errors**: LuaLaTeX compilation errors in Stage B (enrichment) are now treated as **warnings**, not hard failures. The gold PDF from Stage A is preserved, and the pipeline continues to produce enriched JSON output.
- **Log scanning improvements**: The `_scan_compile_log_for_issues` function now only considers Stage A errors as fatal. Stage B error counts are logged informatively but don't block success.
- **Tolerant artifact handling**: Papers with non-zero pdflatex return codes but valid output files (PDF, JSON, AUX) now proceed to enrichment instead of failing early.

#### Coordinate Enrichment (`enrich_positions.py`)

- **InlineMath handling**: Extended `enrich_from_aux` to handle InlineMath labels that don't use `-start/-end` suffix.
- **Dynamic page height**: Extracts actual PDF page height for correct Y-coordinate conversion instead of using a fixed constant.
- **Abstract environment coordinates**: Added `\zsavepos` calls to the `lpsbHookEnv` macro for abstract and other environments.

#### bm Package Compatibility (`lpsb.sty`)

- **Problem**: Papers using `\bm{\textbf{...}}` (bold/italic inside bold math) trigger "Argument of \ZREF@temp has an extra }" errors when `\zsavepos` is called during `\bm`'s argument expansion.
- **Solution**: Conditional tracking using `\ifmmode`:
  - **Text mode**: Full `\zsavepos` coordinates recorded
  - **Math mode**: Skip `\zsavepos`, record `"inMathMode": true` in JSON
- **Coordinate inheritance**: Math-mode Strong/Em entries can inherit coordinates from their parent InlineMath/DisplayMath events during post-processing.
- **Verification**: Paper 2509.00074 (uses `\bm{T_\textbf{s-1}}`) compiles successfully with 113 `inMathMode` entries and 113 text-mode Strong coordinates preserved.

#### DVI-to-PDF Conversion (`lpsb_compiler.py`)

- **Problem**: Some legacy documents produce DVI files instead of PDF (using `latex`/`dvips` workflow or `dvips.def`).
- **Solution**: Automatic fallback conversion using `dvipdf` in the Docker container when DVI is detected but PDF is missing.
- **Impact**: Recovers ~3 additional papers that would otherwise fail compilation.

#### ACM Template Support (`lpsb.sty`)

- **Problem**: ACM papers using `acmart.cls` produced a blank first page due to LPSB hooks triggering during title page construction.
- **Solution**: 
  - Detect `acmart.cls` at `\AtBeginDocument` and delay LPSB activation until after `\maketitle`
  - Hook into ACM's internal `\@mkabstract` to capture abstract events during rendering (not definition)
- **Result**: ACM papers compile correctly with all elements captured including abstract.

#### Package Auto-Collection (`lpsb_compiler.py`)

- **Feature**: Automatically harvests `.sty`, `.cls`, and `.bst` files from successfully compiled papers.
- **Storage**: Packages are stored in `arxiv_stubs/collected/TL{version}/` (e.g., `TL2025`), organized by TeX Live version.
- **Reuse (on-demand)**: When compiling subsequent papers, the compiler copies **only the specific missing files** into the build dir (based on `*.log` “File ... not found”), rather than bulk-copying a stub bundle.
- **Safety**: Core/fragile packages (notably `biblatex*`, `blx-*`, `expl3/xparse`, LaTeX kernel-ish files) are never injected from stubs; they must come from the selected TeX Live image.

#### LaTeXML expl3 Performance (`docker/install_latexml_github.sh`)

- **Background**: LaTeXML's processing of `expl3` (L3 kernel) used to take 20+ minutes due to complex Unicode/codepoint initialization.
- **Solution**: Docker images now run `make formats` during build to precompile the L3 kernel.
- **Impact**: Packages using expl3 (e.g., `siunitx`, `tcolorbox`) now load in ~3 seconds instead of 20+ minutes.
- **Reference**: [LaTeXML issue #2064](https://github.com/brucemiller/LaTeXML/issues/2064)

---

## Repo Layout / Tools

- **Core**
  - `lpsb.sty`: structure/coordinate event emitter
  - `solver.py`: fault-tolerant loader + tree builder
- **Math (LuaLaTeX)**
  - `lpsb-luamath.sty`, `lpsb-math.lua`: capture math + emit MathML (via `luamml`)
- **Merge**
  - `script/merge_lpsb.py`: merge structure + math/table by IDs
  - `hybrid_merge.sh`: batch merge `test_output/` + `test_output_lua/`
- **Scripts**
  - `script/lpsb_compiler.py`: **main batch compiler** (Python, Docker container reuse)
  - `script/test_batch.sh`: PDFLaTeX batch pass (legacy shell script)
  - `script/test_lua_batch.sh`: LuaLaTeX batch pass (uses `lpsb-texlive:latest` if present)
  - `script/test_lua_math.sh`: small smoke test
- **Docker**
  - `docker/Dockerfile.latest`: recommended image (`lpsb-texlive:latest`) with `luamml` and LaTeXML

---

## Future Work

- [ ] PDF content stream parsing for semantic marker extraction (BDC/EMC)
- [ ] Recover full affine transforms (better geometry for nested boxes)
- [ ] Integrate with PDF toolkits (pdfplumber / PyMuPDF) for richer alignment/debugging
- [ ] Add a small GUI/visualizer to inspect source↔PDF alignment

## License

MIT License
