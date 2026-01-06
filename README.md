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
# PDFLaTeX: structure pass (refs/bib resolved via multi-pass)
bash script/test_batch.sh

# LuaLaTeX: math pass (captures $...$, emits *.lpsb-math.json with MathML)
bash script/test_lua_batch.sh

# Merge: enrich PDFLaTeX structure with LuaLaTeX MathML
bash hybrid_merge.sh
```

Outputs:

- `test_output/`: PDFLaTeX outputs and `*.lpsb.json` (structure)
- `test_output_lua/`: LuaLaTeX outputs and `*.lpsb-math.json` (math + MathML)
- `test_output_merged/`: merged JSON (structure + `mathml` fields)

> **TeX Live version selection**: the batch scripts read `00README.json` (if present) and select a compatible TeX Live Docker image based on `texlive_version` to avoid toolchain mismatches (e.g., `biblatex` `.bbl` format differences).

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
| **Tables** | Table Container | ✅ | `tabular`, `tabularx`, `longtable`, `sidewaystable` |
| | Rows (TR) | ✅ | Detects `\\` (⚠️ except longtable MVP) |
| | Cells (TD) | ✅ (LuaLaTeX) | Via `lpsb-luatable` + `lpsb-table.lua` |
| | Colspan | ✅ (LuaLaTeX) | Inferred from row cell counts |
| | Cell Bbox | ✅ (LuaLaTeX) | Absolute page/rotation coordinates |
| **Math** | Display Formulas | ✅ | `equation`, `align`, `gather` |
| | Inline Formulas | ✅ (LuaLaTeX) | `$...$` captured by `lpsb-luamath` |
| | MathML | ✅ (LuaLaTeX) | via `luamml` in `lpsb-texlive:latest` |
| **Refs** | Citations | ✅ | `\cite` links to bibliography |
| | References | ✅ | `\ref`, `\label` linkages |
| **Accessibility** | Captions | ✅ | Figures and Tables |
| | Alt Text | ❌ | Not implemented |

### Known Limitations

1. **Inline math in PDFLaTeX**: `$...$` is not hooked in PDFLaTeX. Use the LuaLaTeX math pass.
2. **Table cells (TD)**: Not extracted by default. Enable with `python3 solver.py --pdf file.pdf --extract-cells` (requires `pdfplumber`). Cells are detected via PDF text positioning. **Note**: Requires 2 compilation passes for accurate coordinates.
3. **Structure Tree Depth**: Due to an event ordering issue in `lpsb.sty` (mismatched nested environments), the JSON structure tree may be deeper than expected (e.g. `Table` closing after `TR` closes). This affects the tree hierarchy but not the content.
4. **Paragraphs**: paragraph detection is much more reliable with kernel hooks, but pathological macro-generated text can still bypass it.
5. **Macros**: heavily customized document-level macros can bypass hooks.

---

## Repo Layout / Tools

- **Core**
  - `lpsb.sty`: structure/coordinate event emitter
  - `solver.py`: fault-tolerant loader + tree builder
- **Math (LuaLaTeX)**
  - `lpsb-luamath.sty`, `lpsb-math.lua`: capture math + emit MathML (via `luamml`)
- **Merge**
  - `merge_lpsb.py`: merge structure + math by IDs
  - `hybrid_merge.sh`: batch merge `test_output/` + `test_output_lua/`
- **Scripts**
  - `script/test_batch.sh`: PDFLaTeX batch pass
  - `script/test_lua_batch.sh`: LuaLaTeX batch pass (uses `lpsb-texlive:latest` if present)
  - `script/test_lua_math.sh`: small smoke test
- **Docker**
  - `docker/Dockerfile.latest`: recommended image (`lpsb-texlive:latest`) with `luamml`

---

## Future Work

- [ ] PDF content stream parsing for semantic marker extraction (BDC/EMC)
- [ ] Recover full affine transforms (better geometry for nested boxes)
- [ ] Integrate with PDF toolkits (pdfplumber / PyMuPDF) for richer alignment/debugging
- [ ] Add a small GUI/visualizer to inspect source↔PDF alignment

## License

MIT License
