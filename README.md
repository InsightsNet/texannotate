# LPSB: LaTeX-PDF Semantic Bridge

**LPSB v3.0** is a production-ready tool for extracting high-fidelity semantic structure from LaTeX documents, aligning source code concepts with PDF output coordinates. It serves as a bridge between raw LaTeX and accessible, structured PDF analysis.

## 🌟 Key Features (v3.0)

*   **PDF 2.0 Structure Elements**: Automatically detects and tags 22+ semantic roles consistent with PDF/UA and Tagged PDF standards.
    *   **Structure**: `Document`, `Sect`, `Div`
    *   **Headings**: `H1` - `H6` (hierarchical)
    *   **Content**: `P` (Paragraphs - experimental), `BlockQuote`
    *   **Lists**: `L`, `LI`, `Lbl` (itemize/enumerate/description)
    *   **Tables**: `Table`, `TR` (Rows)
    *   **Math**: `Formula` (display equations)
    *   **Inline**: `Strong`, `Em`, `Link`, `Reference`
    *   **Figures**: `Figure`, `Caption`
*   **Zero-Source-Modification**: Works via external injection (`\RequirePackage{lpsb}`). No need to edit the author's `.tex` files.
*   **Robustness**:
    *   **Fault-Tolerant JSON**: Handles LaTeX specal characters and escaping issues automatically.
    *   **Bibliography Safe**: Does not interfere with citation numbering (`[1]`, `[2]`).
    *   **Multi-Version Support**: Runs on TeX Live 2023, 2024, and 2025 via Docker.
*   **Data output**: Generates a single `.lpsb.json` event log and a hierarchical `.structure.json` tree.

---

## 🚀 Quick Start

### 1. Simple Usage (Docker)

To process a paper in the current directory:

```bash
docker run --rm -v "$(pwd)":/workdir -w /workdir texlive/texlive:latest \
    pdflatex -interaction=nonstopmode "\RequirePackage{lpsb}\input{main.tex}"
```

This generates `main.lpsb.json`.

### 2. Build Structure Tree

Use the Python solver to reconstruct the DOM tree:

```bash
python3 solver.py main.lpsb.json --output main.structure.json --validate
```

### 3. Batch Processing (arXiv)

To process a dataset of arXiv source packages:

```bash
# Place .tar.gz files in data/download/
bash test_batch.sh
```

---

## 🏗️ Architecture

LPSB v3.0 uses a 3-stage pipeline:

1.  **Injection (LaTeX)**: `lpsb.sty` hooks into standard LaTeX commands and environments. It writes semantic events (start/end) and physical coordinates (`\pdfsavepos`) to a JSON log.
2.  **Compilation (Docker)**: The document is compiled in an isolated environment matching its original TeX Live version.
3.  **Reconstruction (Python)**: `solver.py` parses the potentially noisy JSON log, fixes escape sequences, validates nesting, and builds a clean Semantic Structure Tree.

---

## 📊 Current Capabilities & Status

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
| | Inline Formulas | ❌ | `$ x^2 $` treated as text |
| **Refs** | Citations | ✅ | `\cite` links to bibliography |
| | References | ✅ | `\ref`, `\label` linkages |
| **Accessibility**| Captions | ✅ | Figures and Tables |
| | Alt Text | ❌ | Planned for Phase 5 |

### ⚠️ Known Limitations

1.  **Inline Math**: Inline formulas (e.g., `$E=mc^2$`) are currently treated as regular text (`Span` or `P` content). We do not hook the `$` character due to high breakage risk.
2.  **Table Cells (TD)**: While we detect rows (`TR`), individual cells (`TD`) are not segmented because hooking the alignment character `&` is extremely invasive.
3.  **Paragraphs**: Paragraph detection relies on `\everypar`, which is effectively suppressed by many packages. Expect `P` tags to be sparse in complex documents.
4.  **Complex Macros**: Highly customized user macros that bypass standard LaTeX environments might be missed.

---

## 🛠️ Tools Included

*   **`lpsb.sty`**: The core LaTeX package.
*   **`solver.py`**: The "brain" that parses logs and builds trees. Includes fault-tolerant JSON parser.
*   **`test_batch.sh`**: Robust batch processing script with auto-version detection.
*   **`verify_pdf_simple.py`**: Automated QA script using `pymupdf` to verify PDF integrity (no corrupted numbering).

## 🔮 Roadmap

*   **Phase 4 (Completed)**: PDF 2.0 Structure Elements (v3.0)
*   **Phase 5 (Next)**: 
    *   Dual-track compilation (PDFLaTeX + LuaLaTeX for XML extraction)
    *   MathML extraction for formulas
    *   Alt Text support for figures

---

## License

MIT License
