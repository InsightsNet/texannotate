# Quick Start Guide

Get started with LPSB in 5 minutes.

## Prerequisites

- Docker (recommended) or local TeX Live installation
- Python 3.9+

## Installation

### Option 1: Docker (Recommended)

```bash
# Clone repository
git clone https://github.com/[username]/LPSB.git
cd LPSB

# Build Docker image
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
```

### Option 2: Local Installation

```bash
# Ensure TeX Live is installed
which pdflatex

# Clone and add to TEXINPUTS
export TEXINPUTS="./:/path/to/LPSB//:"
```

## Basic Usage

### 1. Add LPSB to Your Document

```latex
\documentclass{article}
\usepackage{lpsb}  % Add this line

\begin{document}
\section{Introduction}
Your content here.
\end{document}
```

### 2. Compile

```bash
# Using Docker
docker run --rm -v "$(pwd)":/workdir -w /workdir lpsb-texlive:latest \
  pdflatex -interaction=nonstopmode document.tex

# Or locally
pdflatex document.tex
```


### 3. View Output

The compilation produces:
- `document.pdf` - compiled PDF
- `document.lpsb.json` - structure events

```bash
# View structure
cat document.lpsb.json | python -m json.tool | head -20
```

## Automated Compilation (Recommended)

The **LPSB Compiler** script automates the entire pipeline with a **two-stage** approach:

1. **Stage A (pdflatex)**: Generates the "Gold Standard" PDF + structure JSON
2. **Stage B (optional)**: Extracts MathML/table data (LuaLaTeX or LaTeXML)
3. **Merge & Enrich**: Combines data and adds PDF coordinates

```bash
# Single paper
python3 script/lpsb_compiler.py --single path/to/paper --output results/

# Batch processing (arXiv dump)
python3 script/lpsb_compiler.py --batch data/arxiv/ --output results/ --workers 64
```

Select the Stage B engine with an environment variable:

```bash
LPSB_STAGE_B_ENGINE=latexml python3 script/lpsb_compiler.py --single path/to/paper --output results/
```

See [Batch Processing](BATCH_PROCESSING.md) for detailed configuration options.


## Adding Math Extraction

For mathematical content with MathML:

```latex
\documentclass{article}
\usepackage{lpsb}
\usepackage{lpsb-luamath}  % Add for math extraction

\begin{document}
\section{Theory}
The equation $E = mc^2$ is famous.
\end{document}
```

Compile with LuaLaTeX:
```bash
lualatex document.tex
```

Produces additional `document.lpsb-math.json` with:
```json
{"id": "M-1", "type": "inline", "latex": "E = mc^2", "mathml": "<math>...</math>"}
```

## Building the Document Tree

Convert event stream to hierarchical tree:

```bash
# Install Python dependencies
pip install -r requirements.txt

# Build tree
python solver.py document.lpsb.json -o document.structure.json
```

## Next Steps

- [Architecture](ARCHITECTURE.md) - Understand the system design
- [Template Compatibility](TEMPLATE_COMPATIBILITY.md) - Using with conference templates
- [Batch Processing](BATCH_PROCESSING.md) - Processing arXiv paper collections
