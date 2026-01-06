# Table Cells (TR/TD) Extraction — Current Shipping Workflow

LPSB **does not** hook `tabular` internals in LaTeX. That approach is fragile and can perturb TeX alignment/rule drawing (e.g., extra/dangling vertical lines).

Instead, the shipping workflow is:

1. **Structure pass (LaTeX)** emits `Table` containers (and other structure roles) into `*.lpsb.json`.
2. **Cell extraction pass (Python + PDF)** uses `pdfplumber` to detect tables directly from the compiled PDF and injects `TR/TD` nodes under the `Table` container.

This gives you detailed table markup **without touching LaTeX table alignment macros**.

---

## Requirements

- **Python**: 3.9+ recommended.
- **Dependencies**:
  - `pdfplumber` (used for table detection and cell text extraction)
  - Install via `requirements.txt` or your venv:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

- **TeX compilation**:
  - Use Docker images (`lpsb-texlive:*`) as described in `README.md`.
  - If a paper pins TeXLive (via `00README.json` / `texlive_version`), use a matching image (e.g., TL2023) to avoid biblatex `.bbl` format mismatches.

---

## End-to-End: Single Document

### 1) Compile (structure pass)

Ensure `lpsb.sty` is next to your `main.tex` and add:

```tex
\usepackage{lpsb}
```

Then compile (example uses Docker):

```bash
docker run --rm -v "$(pwd)":/workdir -w /workdir lpsb-texlive:latest \
  pdflatex -interaction=nonstopmode main.tex
```

Result:
- `main.pdf`
- `main.lpsb.json`

Notes:
- If your document loads `lpsb-luamath`, compile with `lualatex` (LuaTeX is required for `\directlua`).

---

### 2) Inject TR/TD from PDF

Run the solver with PDF input and enable cell extraction:

```bash
source .venv/bin/activate
python3 solver.py main.lpsb.json --pdf main.pdf --extract-cells --output main.structure.json
```

What happens:
- `solver.py` loads `main.lpsb.json`
- it calls `extract_cells.extract_table_cells_from_pdf(...)`
- **if `TR` events are present**, it uses the old TR-anchored extraction
- **if `TR` events are not present**, it falls back to **PDF table detection** and generates `TR/TD` under each `Table` container
- it then builds and exports `main.structure.json`

---

## Output: What You Get

### Table containers

The LaTeX pass emits `Table` start/end with unique ids:
- `Table-1`, `Table-2`, ...

### Injected rows and cells

The PDF extraction pass injects:
- `TR` nodes: `Table-N-TR1`, `Table-N-TR2`, ...
- `TD` nodes: `Table-N-TRr-TDc`

`TD` attributes (best-effort):
- **`bbox`**: `(x0, y0, x1, y1)` in PDF coordinate space (pdfplumber units)
- **`text`**: extracted text for that cell
- **`row`**, **`col`**, **`colspan`**

`colspan` handling:
- if pdfplumber marks a grid cell as `None` in the extracted row, the extractor treats it as part of the previous cell’s colspan.

---

## Table Matching Rules (How PDF Tables Map to LPSB Tables)

In fallback mode (no TR anchors), matching is:

- **By page**: a `Table` event with `"page": k` uses `pdf.pages[k-1]`
- **By encounter order on the page**: the first `Table` on that page attaches to the first detected PDF table, the second attaches to the second, etc.

This is simple and works well for most papers when the PDF table detector can see the grid.

---

## Limitations (Current)

- **Best on ruled tables**: the default detector strategy is line-based (`vertical_strategy=lines`, `horizontal_strategy=lines`). Tables drawn without visible grid lines (e.g., pure `booktabs`) may be under-detected or merged.
- **Text quality**: extracted text is best-effort; font encoding/layout can affect it. The extractor prefers `pdfplumber`’s grid text when available.
- **Cross-page tables**: multi-page tables (`longtable`) are not handled as a single logical table yet.
- **Complex nesting**: tables inside rotated boxes, minipages, or with heavy graphical overlays can confuse PDF-side detection.

---

## Troubleshooting

### “Undefined control sequence \directlua …”

You compiled with `pdflatex` but the document loads `lpsb-luamath`. Recompile with:

```bash
lualatex -interaction=nonstopmode main.tex
```

### TD extraction produces 0 cells

Common causes:
- the PDF table has no detectable ruling lines (booktabs-style)
- the table is an image
- the detector merged the whole page into one “table”

Next steps:
- confirm tables are detected:

```python
import pdfplumber
pdf = pdfplumber.open("main.pdf")
len(pdf.pages[0].find_tables())
```

### Structure tree has “mismatched close” warnings

These typically mean the underlying event stream has crossing start/end pairs.
Ensure you’re using the current `lpsb.sty` (unique `Table-*` ids, caption start/end, and table boundaries close open paragraphs).

---

## Batch Usage Notes

- Run your LaTeX batch script to produce `*.lpsb.json` + PDFs.
- Then run a second Python batch to call:
  - `solver.py ... --pdf ... --extract-cells`

If you want, we can add a dedicated batch script for TD extraction to mirror the existing LuaMath flow.

---

## Alternative: LuaLaTeX Table Pass (B方案)

If you want TR/TD directly from a LuaLaTeX pass (with colspan and absolute bbox), see:

- `docs/lua_table_pass.md`


