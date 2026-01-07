# Batch Processing

LPSB includes a batch processing pipeline for compiling and extracting structure from collections of arXiv papers.

## Overview

The batch pipeline:
1. Extracts arXiv source tarballs
2. Injects LPSB packages
3. Compiles with appropriate TeX Live version
4. Merges structure, math, and table data
5. Generates analysis reports

## Quick Start

```bash
cd /path/to/LPSB

# Build Docker image
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker

# Place arXiv tarballs in data/download/
ls data/download/*.tar.gz

# Run batch compilation
bash script/batch_compile_all.sh

# View results
cat compile_results/summary_*.txt
```

## TeX Live Version Selection

### Modern Papers (2024+)

arXiv papers submitted after summer 2024 include `00README.json`:

```json
{
  "texlive_version": "2025",
  "process": {"compiler": "pdflatex"}
}
```

The batch script reads this file and selects the matching Docker image.

### Legacy Papers

For older papers without `00README.json`, the script:
1. Checks for biblatex `.bbl` files
2. Reads the format version header: `% $ biblatex bbl format version 3.1 $`
3. Maps to appropriate TeX Live version

| BBL Format | TeX Live |
|------------|----------|
| 3.1 | 2022 |
| 3.2 | 2023 |
| 3.3+ | 2024/2025 |

## Two-Stage Compilation

For maximum compatibility, the batch script uses a two-stage approach:

### Stage A: Gold PDF (pdfLaTeX)

- Compiler: `pdflatex`
- Produces: authoritative PDF, `*.lpsb.json` (structure)
- Compatibility: handles legacy packages (`inputenc`, etc.)

### Stage B: Enrichment (LuaLaTeX)

- Compiler: `lualatex`
- Produces: `*.lpsb-math.json` (MathML), `*.lpsb-table.json`
- Requires: `luamml` runtime (included in Docker images)

### Merge

The `merge_lpsb.py` script combines outputs:
- Base: structure from Stage A
- Enrichment: math/table data from Stage B
- Output: `*.lpsb.merged.json`

## Docker Images

### Building Images

```bash
# Latest TeX Live (recommended)
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker

# TeX Live 2023 (for older biblatex)
docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker

# TeX Live 2022 (for even older papers)
docker build -f docker/Dockerfile.tl2022 -t lpsb-texlive:TL2022-historic docker
```

### Image Contents

All images include:
- Full TeX Live installation
- `luamml` runtime (for MathML extraction)
- LPSB packages pre-installed in `TEXMFLOCAL`

## Configuration

### Environment Variables

| Variable | Description | Default |
|----------|-------------|---------|
| `LPSB_DATA_DIR` | Input tarballs directory | `data/download` |
| `LPSB_OUT_DIR` | Output directory | `compile_results` |
| `LPSB_DOCKER_IMAGE` | Default Docker image | `lpsb-texlive:latest` |

### Configuration File

Copy and customize `docs/env.example`:

```bash
cp docs/env.example .env
source .env
```

## Output Structure

```
compile_results/
├── paper1/
│   ├── main.pdf                    # Compiled PDF
│   ├── main.lpsb.json              # Structure events
│   ├── main.lpsb-math.json         # Math events (if LuaLaTeX)
│   ├── main.lpsb-table.json        # Table events (if LuaLaTeX)
│   ├── main.lpsb.merged.json       # Merged output
│   ├── compile1.log                # pdfLaTeX pass 1
│   ├── compile2.log                # pdfLaTeX pass 2
│   └── compile3.log                # pdfLaTeX pass 3
├── paper2/
│   └── ...
├── compile_report_YYYYMMDD.txt     # Detailed report
└── summary_YYYYMMDD.txt            # Summary statistics
```

## Analysis

### Summary Report

```
==========================================
COMPILATION SUMMARY
==========================================
Total papers: 100
Successful: 92
Failed: 8
Success rate: 92.0%
```

### Error Analysis

```bash
python script/analyze_compile_errors.py compile_results/ -o error_report.txt
```

Produces:
- Most common missing files
- Most common undefined commands
- Per-paper error details

## Common Issues

### biblatex Format Mismatch

**Symptom**: 100,000+ page PDF with raw biblatex data

**Cause**: `.bbl` format version incompatible with TeX Live version

**Solution**: Use matching TeX Live image based on `.bbl` header

### Missing `luamml`

**Symptom**: Empty MathML fields in output

**Cause**: Historic TeX Live image lacks `luamml`

**Solution**: Use LPSB Docker images with vendored `luamml`

### Package Conflicts

**Symptom**: `inputenc` or `fontenc` errors with LuaLaTeX

**Cause**: Legacy packages incompatible with LuaTeX

**Solution**: Two-stage compilation (gold PDF from pdfLaTeX)

## Performance

Typical timing on modern hardware:
- Single paper: 10-60 seconds
- 100 papers: 20-60 minutes

Factors affecting speed:
- Paper complexity (bibliography size, figure count)
- Number of compilation passes (1-3)
- TeX Live version detection
