# LPSB: LaTeX-PDF Semantic Bridge

**LPSB** extracts semantic structure from LaTeX documents during compilation. It produces **tagged PDFs** with complete StructTree (PDF/UA compliant) and MCID structure data in JSON format for further analysis.

## Features

- **PDF/UA-compatible structure tags**: Document, Sect, H1-H6, P, L, LI, Table, Figure, Formula, Note, Link, etc.
- **Two-pass compilation**: Smart float handling with accurate tag placement
- **StructTree injection**: Complete PDF structure tree for PDF/UA compliance
- **MathML extraction**: Via LaTeXML (planned)
- **Cross-page element handling**: Automatic MCID continuation for split paragraphs
- **Footnote & URL tagging**: Proper Note and Link structure elements
- **Batch processing**: Compile thousands of arXiv papers with Docker

---

## Quick Start

### 1. Installation

```bash
# Clone repository
git clone https://github.com/your-org/LPSB.git && cd LPSB

# Create virtual environment
python3 -m venv .venv && source .venv/bin/activate

# Install dependencies
pip install -r requirements.txt

# Build Docker image
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
```

### 2. Compile a Single Paper

```bash
# Two-pass compilation with StructTree injection
LPSB_TWO_PASS=1 python3 script/lpsb_compiler.py --single <source_dir> --output <output_dir>
```

**Output files**:
- `<paper>_tagged.pdf` — PDF with StructTree (PDF/UA compliant)
- `<paper>.mcid.json` — MCID structure data
- `<paper>.lpsb.json` — Structure events

### 3. Batch Processing (arXiv)

```bash
LPSB_TWO_PASS=1 python3 script/lpsb_compiler.py --batch data/download --output results --workers 8
```

### 4. Visualization

```bash
python3 script/visualization/visualize_mcid.py output.pdf -o visualized.pdf
```

---

## Architecture

```
┌─────────────────────────────────────────┐
│           LaTeX Source (.tex)           │
└─────────────────────────────────────────┘
                    │
                    ▼  \usepackage{lpsb-mcid}
┌─────────────────────────────────────────┐
│      Stage A: Two-Pass PDFLaTeX         │
│  Pass 1: Collect float positions        │
│  Pass 2: Smart tagging with position    │
└─────────────────────────────────────────┘
         │                    │
         ▼                    ▼
    main.pdf           main.lpsb.json
         │
         ▼
┌─────────────────────────────────────────┐
│      Post-Processing Pipeline           │
│  1. parse_lpsb_mcid.py → MCID JSON      │
│  2. fix_split_headings.py → Merge H1+P  │
│  3. fix_crosspage_mcid.py → Fix tags    │
│  4. inject_structtree.py → StructTree   │
└─────────────────────────────────────────┘
         │
         ▼
    main_tagged.pdf (PDF/UA Ready)
```

---

## Core Components

| File | Purpose |
|------|---------|
| `lpsb.sty` | Main structure event emitter |
| `lpsb-mcid.sty` | PDF content stream tagging (BDC/EMC), two-pass support |
| `lpsb-luamath.sty` | MathML extraction via LuaLaTeX |
| `script/lpsb_compiler.py` | Batch compiler with Docker, two-pass flow |
| `script/postprocess/fix_crosspage_mcid.py` | Fix cross-page tagging |
| `script/postprocess/inject_structtree.py` | Inject PDF StructTree (pikepdf) |
| `script/postprocess/fix_split_headings.py` | Merge split H1+P headings |
| `script/parsing/parse_lpsb_mcid.py` | Parse MCID data from aux file |
| `script/parsing/build_doc_tree.py` | Build document hierarchy |
| `script/visualization/visualize_mcid.py` | Visualize MCID tags on PDF |

---

## Tagged PDF Support

LPSB generates PDF/UA-compatible tagged content using MCID (Marked Content IDentifier) markers:

### Structure Tags
- **Document structure**: `Document`, `Sect`, `Div`
- **Headings**: Dynamic levels based on document class:
  - **Article** (no chapter): `H1`=section, `H2`=subsection, `H3`=subsubsection, `H4`=paragraph
  - **Book/Report**: `H1`=chapter, `H2`=section, `H3`=subsection, `H4`=subsubsection, `H5`=paragraph
- **Text blocks**: `P`, `Abstract`, `Caption`
- **Lists**: `L`, `LI`, `Lbl`
- **Tables**: `Table`, `TR`, `TD`
- **Figures**: `Figure`
- **Math**: `Formula`
- **References**: `Reference`, `BibList`, `BibEntry`
- **Footnotes**: `Lbl` (mark/superscript), `Note` (content at page bottom)
- **Links**: `Link` (URLs and hyperlinks)
- **Code**: `Code` (verbatim, listings, fancyvrb)

### Cross-Page & Cross-Column Handling

LPSB automatically handles elements that span page/column boundaries:
- **Phase 0**: Removes orphan EMC markers (structural cleanup)
- **Phase 1**: Injects missing BDC markers for cross-page continuations
- **Phase 2**: Splits cross-column tags in two-column layouts
- **SyncTeX integration**: Uses `.synctex.gz` for accurate discontinuity detection

### StructTree Injection

The final PDF includes a complete StructTree for PDF/UA compliance:
- `/StructTreeRoot` in document catalog
- Hierarchical structure elements (Document → H1 → P → atoms)
- MCR (Marked Content Reference) for each MCID
- `MarkInfo.Marked = true`

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
python3 script/visualization/visualize_mcid.py output.pdf -o visualized.pdf
```

Features:
- **Line-based boxes**: Text elements (P, H1-H4) display per-line boxes to avoid cross-column artifacts
- **Float bodies merged**: Figure, Table, Caption show as single blocks
- **Reading order**: Labels follow logical element order when an adjacent `*.aux` is available (and `*.order.json` when present)

---

## License

MIT License

---

## Known Limitations

### Legacy `subfigure.sty` Package
When the legacy `subfigure.sty` package is used (not `subcaption`), **atom-level tagging is disabled** to avoid expansion conflicts. Block-level tagging (P, H1, Figure, etc.) still works.

**Workaround**: Use the modern `subcaption` package instead of `subfigure.sty`:
```latex
% Replace:
\usepackage{subfigure}
\subfigure[caption]{...}

% With:
\usepackage{subcaption}
\begin{subfigure}{0.48\textwidth}
  ...
  \caption{caption}
\end{subfigure}
```
