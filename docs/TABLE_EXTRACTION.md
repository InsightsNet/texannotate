# Table Extraction

LPSB provides two approaches for extracting table structure: source-side (LuaLaTeX) and PDF-side (post-processing).

## Overview

| Approach | Method | Row Detection | Colspan | Rowspan | Visual Safety |
|----------|--------|---------------|---------|---------|---------------|
| LuaLaTeX Pass | `lpsb-luatable` | Partial | ✅ | ❌ | ✅ |
| PDF-Side | `pdfplumber` | ✅ | ✅ | ✅ | ✅ |

**Recommendation**: Use PDF-side extraction for production workloads. The LuaLaTeX pass is useful for capturing cell text content.

## Why Two Approaches?

LaTeX table environments (`tabular`, `longtable`) are sensitive to token injection. Hooking internal commands like `\@tabularcr` or `\everycr` can cause:
- Visual artifacts (extra lines, missing rules)
- Alignment issues
- `\noalign` errors

The PDF-side approach avoids these issues by extracting from the rendered output.

## Approach 1: PDF-Side Extraction (Recommended)

### Workflow

1. Compile LaTeX document (produces PDF)
2. Run PDF table extraction
3. Merge with structure data

```bash
# Compile
pdflatex document.tex

# Extract tables from PDF
python extract_cells.py document.pdf -o document.tables.json

# Or integrate with solver
python solver.py document.lpsb.json --pdf document.pdf --extract-cells -o document.structure.json
```

### Output Format

```json
{
  "tables": [
    {
      "id": "Table-1",
      "page": 1,
      "rows": [
        {
          "cells": [
            {"text": "Header 1", "bbox": [x0, y0, x1, y1], "colspan": 1},
            {"text": "Header 2", "bbox": [x0, y0, x1, y1], "colspan": 2}
          ]
        }
      ]
    }
  ]
}
```

### Colspan/Rowspan Detection

The extractor detects merged cells by identifying `None` entries in the pdfplumber grid:
- Horizontal `None` sequences → colspan
- Vertical `None` sequences → rowspan

### Limitations

- **Ruleless tables**: Detection relies on visible lines; booktabs-style tables may be under-detected
- **Image tables**: Tables rendered as images cannot be extracted
- **Cross-page tables**: Multi-page tables are treated as separate tables per page

## Approach 2: LuaLaTeX Pass

### Workflow

1. Add packages to document:
   ```latex
   \usepackage{lpsb}
   \usepackage{lpsb-luatable}
   ```

2. Compile with LuaLaTeX (two passes required for coordinates):
   ```bash
   lualatex document.tex
   lualatex document.tex
   ```

3. Output: `document.lpsb-table.json`

### Mechanism

- **Cell capture**: LuaTeX `hpack_filter` callback captures each packed cell
- **Coordinates**: `zref-savepos` records row baseline positions
- **Colspan inference**: Based on cell width distribution

### Output Format

```json
[
  {"id": "Table-1", "role": "Table", "event": "start", "cols": 3, "page": "1"},
  {"id": "Table-1-TR1", "role": "TR", "event": "start", "row": 1},
  {"id": "Table-1-TR1-TD1", "role": "TD", "event": "start", 
   "row": 1, "col": 1, "colspan": 1, "text": "Cell content",
   "x0": 100, "y0": 700, "x1": 200, "y1": 720},
  ...
]
```

### Limitations

- **Row detection**: Limited; cells may not be correctly grouped into rows
- **Empty cells**: Not captured (no glyphs to detect)
- **Rowspan**: Not implemented
- **longtable**: Container only; internal structure not tracked

## Best Practice: Hybrid Approach

For optimal results, combine both approaches:

1. **LuaLaTeX pass**: Captures cell text content with LaTeX formatting preserved
2. **PDF-side extraction**: Provides accurate row/column structure and coordinates

Merge the results to get complete table data:
- Structure from PDF extraction
- Text content from LuaLaTeX pass

## Troubleshooting

### No tables detected (PDF-side)

- Verify tables have visible ruling lines
- Check: `python -c "import pdfplumber; pdf=pdfplumber.open('doc.pdf'); print(len(pdf.pages[0].find_tables()))"`

### Empty cells in output

- PDF-side: Normal for merged cells (colspan/rowspan)
- LuaLaTeX: Empty cells are not captured; use PDF-side for structure

### Visual artifacts in PDF

- Remove `lpsb-luatable` and use PDF-side extraction only
- Report issue with minimal reproducible example
