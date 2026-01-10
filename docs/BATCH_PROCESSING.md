# Batch Processing with LPSB Compiler

The unified compiler script `script/lpsb_compiler.py` handles the complete arXiv paper processing pipeline, from extraction to annotated JSON output.

## Core Architecture: Two-Stage Compilation

LPSB uses a **dual-stage** compilation strategy to ensure output fidelity while maximizing data extraction:

```
┌─────────────────────────────────────────────────────────────┐
│                    Stage A: Gold PDF                         │
│  Compiler: pdflatex (3 passes)                               │
│  Packages: lpsb.sty                                          │
│  Output:   paper.pdf (authoritative), paper.lpsb.json        │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Stage B: Enrichment                       │
│  Engine:   lualatex (3 passes) OR latexml (single pass)      │
│  Output:   paper.lpsb-math.json, paper.lpsb-table.json       │
└─────────────────────────────────────────────────────────────┘
                            ↓
┌─────────────────────────────────────────────────────────────┐
│                    Merge & Enrich                            │
│  Scripts: merge_lpsb.py, enrich_positions.py                 │
│  Output:  paper.json (final enriched structure)              │
└─────────────────────────────────────────────────────────────┘
```

### Why Two Stages?

1. **Visual Fidelity**: pdflatex produces the "Gold Standard" PDF matching arXiv's original output.
2. **Data Richness**: lualatex enables MathML extraction (`lpsb-luamath`) and table cell parsing (`lpsb-luatable`) via Lua callbacks.
3. **Coordinate Consistency**: Position enrichment uses the Gold PDF, ensuring coordinates match the authoritative output.

Stage B can be selected via `LPSB_STAGE_B_ENGINE` (`latexml`/`lua`/`none`). Coordinates are always enriched from the gold PDF/aux, not from Stage B.
For `latexml`, alignment prefers explicit IDs injected by `lpsb.sty` (`\lpsbMark{...}`); it falls back to order-based pairing if markers are missing.

## Quick Start

```bash
# Single paper
python3 script/lpsb_compiler.py --single /path/to/paper_src --output results/

# Batch processing (arXiv dump)
python3 script/lpsb_compiler.py --batch data/arxiv/extracted --output results/ --workers 64
```

## Command-Line Arguments

| Argument | Description |
|----------|-------------|
| `--single <PATH>` | Process a single paper (directory or `.gz`/`.tex` file) |
| `--batch <DIR>` | Process a paper corpus directory (see discovery rules below) |
| `--output <DIR>` | Output directory for results |
| `--workers <N>` | Number of parallel workers (default: 1) |
| `--no-ramdisk` | Disable `/dev/shm` acceleration (default: enabled) |

## TeX Live Version Selection

The script automatically selects the appropriate TeX Live environment:

### Detection Priority
1. **`00README.json`**: Modern arXiv papers include `texlive_version` field
2. **`.bbl` format version**: Biblatex format headers indicate required TeX Live
3. **ArXiv ID date**: Fallback based on submission date (YYMM)

### Version Mapping

| Source | arXiv Date | TeX Live |
|--------|------------|----------|
| `00README.json` | N/A | As specified |
| BBL format 3.4 | N/A | 2025 |
| BBL format 3.2 | N/A | 2023 |
| ArXiv ID 2508+ | Aug 2025+ | 2025 |
| ArXiv ID 2305+ | May 2023+ | 2023 |
| ArXiv ID 2010+ | Oct 2020+ | 2020 |
| Older | Pre-2020 | 2020 (min) |

> **Note**: `LPSB_TEXLIVE_MIN=2020` ensures compatibility with modern LaTeX kernel hooks.

## Docker Images

Build historic images for maximum compatibility:

```bash
# Required images
docker build -f docker/Dockerfile.tl2020 -t lpsb-texlive:TL2020-historic docker
docker build -f docker/Dockerfile.tl2022 -t lpsb-texlive:TL2022-historic docker
docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
```

## Output Structure

```
results/
├── 2305.12345/
│   ├── 2305.12345.pdf          # Gold PDF (from pdflatex)
│   ├── 2305.12345.json         # Final merged + enriched JSON
│   ├── 2305.12345.lpsb.json    # Raw structure (from pdflatex)
│   └── compile.log             # Full compilation log
```

## Environment Variables

| Variable | Description |
|----------|-------------|
| `LPSB_TEXLIVE_MIN` | Minimum TeX Live version (default: 2020) |
| `LPSB_TEXLIVE_VERSION_OVERRIDE` | Force specific TeX Live version |
| `LPSB_DOCKER_IMAGE_OVERRIDE` | Force specific Docker image |
| `LPSB_STAGE_B_ENGINE` | Stage B engine: `latexml` (default), `lua`, or `none` |
| `LPSB_LATEXML_TIMEOUT_SEC` | LaTeXML Stage B timeout (default: 600) |
| `LPSB_LATEXML_CACHE` | Enable LaTeXML cache reuse across runs (default: 1) |
| `LPSB_LATEXML_CACHE_ROOT` | Host cache root dir (default: `latexml_cache/`) |

## Batch input discovery rules

`--batch <DIR>` supports two common corpus layouts:

1. **Directory-per-paper (preferred)**: if `<DIR>` contains subdirectories matching arXiv IDs like `2202.00012/`,
   each such directory is treated as one paper.
2. **Archive/file corpus**: otherwise, the compiler recursively processes `*.gz` and `*.tex` under `<DIR>`.

This avoids accidentally treating every auxiliary `*.tex` inside one paper as a separate paper.

## Performance

- **RAM Disk**: Enabled by default on systems with `/dev/shm`
- **Parallelism**: Scale workers to CPU cores (e.g., `--workers 128` on 256-core machines)
- **Throughput**: ~30-60 seconds per paper depending on complexity
