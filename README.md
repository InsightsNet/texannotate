# LPSB: LaTeX-PDF Semantic Bridge

LPSB extracts semantic structure from LaTeX compilations and aligns it with PDF page coordinates. It produces a single event log (`*.lpsb.json`) that can be rebuilt into a tree (`*.structure.json`) and can be enriched with MathML from a LuaLaTeX pass.

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

Output: `main.lpsb.json`

### Build a structure tree

Use the Python solver to reconstruct the DOM tree:

```bash
python3 solver.py main.lpsb.json --output main.structure.json --validate
```

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

---

## Architecture

LPSB uses a 3-stage pipeline:

1. **Instrumentation (LaTeX)**: `lpsb.sty` hooks into LaTeX commands/environments and emits events + coordinates.
2. **Compilation (Docker)**: scripts compile papers in a container.
3. **Reconstruction (Python)**: `solver.py` parses the log, validates nesting, and builds a tree.

Optional:

4. **Math enrichment (LuaLaTeX)**: `lpsb-luamath.sty` + `lpsb-math.lua` captures math and emits MathML using `luamml`. `merge_lpsb.py` merges by context-aware IDs.

---

## Current Capabilities & Status

| Category | Feature | Status | Notes |
|----------|---------|--------|-------|
| **Structure** | Sections (Sect) | ✅ | Maps `\section`, `\chapter` etc. |
| | Headings (H1-H6) | ✅ | Captures titles and hierarchy level |
| **Blocks** | Lists (L, LI) | ✅ | `itemize`, `enumerate`, `description` |
| | List Labels (Lbl) | ✅ | Captures `1.`, `a)`, `•` etc. |
| | Paragraphs (P) | ⚠️ | `\everypar` hook is fragile in some envs |
| **Tables** | Table Container | ✅ | `tabular`, `tabularx` |
| | Rows (TR) | ✅ | Detects `\\` |
| | Cells (TD) | ❌ | Difficult to hook `&` reliably |
| **Math** | Display Formulas | ✅ | `equation`, `align`, `gather` |
| | Inline Formulas | ✅ (LuaLaTeX) | `$...$` captured by `lpsb-luamath` |
| | MathML | ✅ (LuaLaTeX) | via `luamml` in `lpsb-texlive:latest` |
| **Refs** | Citations | ✅ | `\cite` links to bibliography |
| | References | ✅ | `\ref`, `\label` linkages |
| **Accessibility** | Captions | ✅ | Figures and Tables |
| | Alt Text | ❌ | Not implemented |

### Known Limitations

1. **Inline math in PDFLaTeX**: `$...$` is not hooked in PDFLaTeX. Use the LuaLaTeX math pass.
2. **Table cells**: we detect `TR`, but not individual `TD`.
3. **Paragraphs**: `\everypar` is fragile; expect sparse `P` tags in complex documents.
4. **Macros**: heavily customized document-level macros can bypass hooks.

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

## Before you commit

- Do not commit generated outputs (`test_output*`, `*.pdf`, `*.log`, `*.aux`, `*.bbl`, `*.blg`, `*.lpsb*.json`, etc.).
- Do not commit downloaded arXiv tarballs in `data/download/`.
- `.gitignore` is expected to cover the above.

---

## License

MIT License
