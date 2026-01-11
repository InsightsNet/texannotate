# LPSB: LaTeX-PDF Semantic Bridge

**LPSB** extracts semantic structure from LaTeX documents during compilation and aligns it with PDF page coordinates. It produces a comprehensive JSON output with document structure, bounding boxes, and optional MathML.

## Features

- **PDF/UA-compatible structure tags**: Document, Sect, H1-H6, P, L, LI, Table, Figure, Formula, etc.
- **Precise coordinates**: Bounding boxes from `\zsavepos` (PDFLaTeX gold standard)
- **MathML extraction**: Via LuaLaTeX + `luamml` or LaTeXML
- **Cross-page element handling**: Automatic MCID continuation for split paragraphs
- **Batch processing**: Compile thousands of arXiv papers with Docker

---

## Quick Start

### 1. Build Docker Image

```bash
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
```

### 2. Compile a Single Paper

```bash
# Copy lpsb*.sty to your document directory, then:
docker run --rm -v "$(pwd)":/workdir -w /workdir lpsb-texlive:latest \
  pdflatex -interaction=nonstopmode main.tex
```

Output: `main.pdf`, `main.lpsb.json`

### 3. Batch Processing (arXiv)

```bash
python3 script/lpsb_compiler.py --batch data/download --output results --workers 8
```

---

## Architecture

```
┌─────────────────────────────────────────┐
│           LaTeX Source (.tex)           │
└─────────────────────────────────────────┘
                    │
                    ▼  \usepackage{lpsb}
┌─────────────────────────────────────────┐
│         Stage A: PDFLaTeX (Gold)        │
│  • lpsb.sty, lpsb-mcid.sty              │
│  • Structure events + coordinates        │
│  • MCID tags in PDF content stream      │
└─────────────────────────────────────────┘
         │                    │
         ▼                    ▼
    main.pdf           main.lpsb.json
         │
         ▼
┌─────────────────────────────────────────┐
│      Post-Processing Pipeline           │
│  • parse_lpsb_mcid.py → MCID JSON       │
│  • fix_split_headings.py → Merge H1+P   │
│  • fix_crosspage_mcid.py → Fix tags     │
└─────────────────────────────────────────┘
         │
         ▼
    main_fixed.pdf (Tagged PDF)
```

---

## Core Components

| File | Purpose |
|------|---------|
| `lpsb.sty` | Main structure event emitter |
| `lpsb-mcid.sty` | PDF content stream tagging (BDC/EMC) |
| `lpsb-luamath.sty` | MathML extraction via LuaLaTeX |
| `script/lpsb_compiler.py` | Batch compiler with Docker |
| `script/fix_crosspage_mcid.py` | Fix cross-page tagging |
| `script/fix_split_headings.py` | Merge split H1+P headings |
| `script/visualize_mcid.py` | Visualize MCID tags on PDF |

---

## Tagged PDF Support

LPSB generates PDF/UA-compatible tagged content using MCID (Marked Content IDentifier) markers:

### Structure Tags
- **Document structure**: `Document`, `Sect`, `Div`
- **Headings**: `H1`-`H6`
- **Text blocks**: `P`, `Abstract`, `Caption`
- **Lists**: `L`, `LI`, `Lbl`
- **Tables**: `Table`, `TR`, `TD`
- **Figures**: `Figure`
- **Math**: `Formula`
- **References**: `Reference`, `BibList`, `BibEntry`

### Cross-Page Handling

LPSB automatically handles elements that span page boundaries:
- Generates continuation MCIDs at page breaks
- Post-processing fixes orphaned text after floats
- Maintains correct reading order

---

## Output Format

### Structure JSON (`*.lpsb.json`)

```json
{
  "events": [
    {
      "type": "H1",
      "action": "start",
      "id": 1,
      "page": 1,
      "bbox": {"x": 108, "y": 700, "w": 200, "h": 12}
    },
    ...
  ]
}
```

### MCID JSON (`*.mcid.json`)

```json
{
  "elements": {
    "1": {"type": "H1", "start_mcid": 1, "start_page": 1, "end_page": 1}
  },
  "continuations": [
    {"logical_id": "82", "mcid": 120, "page": 5}
  ]
}
```

---

## Docker Images

| Image | TeX Live | Use Case |
|-------|----------|----------|
| `lpsb-texlive:latest` | 2025 | Default, recommended |
| `lpsb-texlive:TL2023-historic` | 2023 | Older arXiv papers |
| `lpsb-texlive:TL2022-historic` | 2022 | biblatex compatibility |
| `lpsb-texlive:TL2020-historic` | 2020 | Legacy papers |
| `lpsb-texlive:TL2016-historic` | 2016 | Very old papers |

Build historic images:
```bash
docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker
```

---

## Known Limitations

1. **PDFLaTeX is gold**: Coordinates come exclusively from PDFLaTeX. LuaLaTeX is for enrichment only.
2. **Float placement**: LaTeX's asynchronous float placement can cause orphaned text at page boundaries (handled by post-processing).
3. **Table internals**: `tabular` hooks are minimal to avoid visual artifacts. Use PDF-side extraction for TR/TD.
4. **Custom macros**: Heavily customized classes may bypass hooks.

---

## Visualization

Generate a visual overlay showing MCID tags:

```bash
python3 script/visualize_mcid.py output.pdf -o visualized.pdf
```

Each tag type gets a distinct color:
- **P**: Light blue
- **H1/H2**: Orange/Yellow
- **Table**: Green
- **Figure**: Purple
- **Formula**: Pink

---

## Development

### Running Tests

```bash
# Single paper test
python3 script/lpsb_compiler.py data/test/sample.tar.gz -o test_output

# Batch test
python3 script/lpsb_compiler.py --batch data/download -o results --workers 4
```

### Debug Cross-Page Issues

```bash
# Parse MCID data
python3 script/parse_lpsb_mcid.py build/paper.aux

# Fix and visualize
python3 script/fix_crosspage_mcid.py build/paper.pdf --aux build/paper.aux -o fixed.pdf
python3 script/visualize_mcid.py fixed.pdf -o debug.pdf
```

---

## License

MIT License
