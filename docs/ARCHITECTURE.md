# LPSB Architecture

## Overview

LPSB (LaTeX Parser for Structured Bounding-boxes) is a source-side document structure extraction framework. Unlike PDF-based approaches that reverse-engineer rendered output, LPSB instruments the LaTeX compilation process to capture semantic structure directly.

## Design Philosophy

### Source-Side vs. PDF-Side Extraction

| Aspect | PDF-Side Extraction | LPSB (Source-Side) |
|--------|--------------------|--------------------|
| Input | Rendered PDF | LaTeX source |
| Structure | Inferred from visual layout | Explicit from markup |
| Accuracy | Heuristic-dependent | Ground truth |
| Math | OCR/pattern matching | Direct LaTeX + MathML |
| Tables | Visual grid detection | Semantic markup |

### Key Insight

LaTeX contains explicit structural information that is lost during PDF rendering:
- Section hierarchy with explicit levels
- Mathematical semantics (not just glyphs)
- Table structure as markup (not visual grid)
- Cross-references and citations

LPSB preserves this information by intercepting LaTeX's internal processing.

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                        LaTeX Source                              │
└─────────────────────────────────────────────────────────────────┘
                                │
                                ▼
┌─────────────────────────────────────────────────────────────────┐
│                    LPSB Instrumentation                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐              │
│  │  lpsb.sty   │  │lpsb-luamath │  │lpsb-luatable│              │
│  │ (Structure) │  │   (Math)    │  │  (Tables)   │              │
│  └─────────────┘  └─────────────┘  └─────────────┘              │
└─────────────────────────────────────────────────────────────────┘
                                │
            ┌───────────────────┼───────────────────┐
            ▼                   ▼                   ▼
     *.lpsb.json        *.lpsb-math.json    *.lpsb-table.json
     (Structure)           (Math)              (Tables)
            │                   │                   │
            └───────────────────┼───────────────────┘
                                │
                                ▼
                    ┌─────────────────┐
                    │  merge_lpsb.py  │
                    └─────────────────┘
                                │
                                ▼
                    *.lpsb.merged.json
                    (Unified Output)
                                │
                                ▼
                    ┌─────────────────┐
                    │    solver.py    │
                    └─────────────────┘
                                │
                                ▼
                    *.structure.json
                    (Document Tree)
```

## Components

### 1. Structure Pass (`lpsb.sty`)

**Purpose**: Extract document structure during PDFLaTeX/XeLaTeX compilation.

**Mechanism**: Hooks LaTeX internal commands to capture structural events:

| LaTeX Command | LPSB Hook | Output Role |
|---------------|-----------|-------------|
| `\@sect` | Section handler | H1-H6 |
| `\@ssect` | Starred section | H* |
| `\everypar` | Paragraph tracking | P |
| `table` env | Environment hook | Table |
| `figure` env | Environment hook | Figure |
| `itemize/enumerate` | List hooks | L, LI |

**Output Format**: JSON event stream with start/end markers:
```json
{"id": "H-1", "role": "H2", "event": "start", "title": "Introduction", "page": "1"}
{"id": "P-1", "role": "P", "event": "start", "page": "1"}
{"id": "P-1", "role": "P", "event": "end", "page": "1"}
{"id": "H-1", "role": "H2", "event": "end", "page": "1"}
```

### 2. Math Pass (`lpsb-luamath.sty` + `lpsb-math.lua`)

**Purpose**: Extract mathematical expressions with optional MathML conversion.

**Requirements**: LuaLaTeX (for Lua callbacks and `luamml` integration)

**Mechanism**:
- Hooks `$...$`, `\[...\]`, and amsmath environments
- Captures LaTeX source via `\everymath`/`\everydisplay`
- Optionally converts to MathML using `luamml`

**Output**: `*.lpsb-math.json` with formula entries:
```json
{"id": "M-1", "type": "display", "latex": "E = mc^2", "mathml": "<math>...</math>", "page": "1"}
```

### 3. Table Pass (`lpsb-luatable.sty` + `lpsb-table.lua`)

**Purpose**: Extract table cell structure with coordinates.

**Requirements**: LuaLaTeX (for `hpack_filter` callback)

**Mechanism**:
- Registers LuaTeX `hpack_filter` callback to capture packed cells
- Uses `zref-savepos` for absolute coordinates
- Infers colspan from cell widths

**Alternative**: PDF-side extraction using `pdfplumber` (see TABLE_EXTRACTION.md)

### 4. Merge Script (`merge_lpsb.py`)

**Purpose**: Combine structure, math, and table passes into unified output.

**Algorithm**:
1. Load base structure events (`*.lpsb.json`)
2. Load math events (`*.lpsb-math.json`)
3. Load table events (`*.lpsb-table.json`)
4. Merge by matching IDs (e.g., inject math under corresponding section)
5. Output unified event stream

### 5. Tree Builder (`solver.py`)

**Purpose**: Convert event stream to hierarchical document tree.

**Algorithm**:
1. Parse event stream (start/end pairs)
2. Build nested tree structure
3. Validate well-formedness (matching pairs)
4. Output structured JSON or other formats

## Template Compatibility Layer

LPSB achieves broad template compatibility through specialized hooks:

| Template Category | Hook Strategy |
|-------------------|---------------|
| Standard LaTeX | `\@sect`, `\@ssect` |
| REVTeX | `\@sect@ltx` |
| KOMA-Script | `\scr@sect` |
| memoir | `\M@sect` |
| ICML | `\@sict` |
| CVPR/ICCV | `\cvprsect`, `\iccvsect` |
| titlesec | `\ttl@straight@ii` |

See [TEMPLATE_COMPATIBILITY.md](TEMPLATE_COMPATIBILITY.md) for details.

## Two-Pass Compilation Strategy

For maximum compatibility, LPSB uses a two-pass strategy:

1. **Gold Pass (PDFLaTeX)**: Produces authoritative PDF and structure JSON
2. **Enrichment Pass (LuaLaTeX)**: Produces math and table JSON

This separation ensures:
- PDF rendering is not affected by Lua-specific issues
- Math extraction benefits from `luamml` MathML generation
- Legacy documents (using `inputenc`, etc.) compile successfully

## Output Formats

### Event Stream (`.lpsb.json`)

Low-level format capturing all structural events in document order.

### Document Tree (`.structure.json`)

Hierarchical representation suitable for downstream processing.

### Merged Output (`.lpsb.merged.json`)

Unified stream combining structure, math, and table data.
