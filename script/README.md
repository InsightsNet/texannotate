# LPSB Scripts

This directory contains the core scripts for the LPSB (LaTeX Position & Structure Builder) pipeline.

## Core Workflow Scripts

| Script | Description |
|--------|-------------|
| **`lpsb_compiler.py`** | **The Main Entry Point.** Unified driver for compiling papers (single or batch). Handles dependency injection, dual-pass compilation (LuaLaTeX), merging, and enrichment. |
| **`enrich_positions.py`** | Post-processor that injects precise `x, y, width, height` coordinates into the JSON output using a hybrid of `.aux` (zref) data and PDF analysis (pdfplumber). |
| **`merge_lpsb.py`** | Utility to merge the Structure JSON (`.lpsb.json`) with the Math JSON (`.lpsb-math.json`) produced by LuaLaTeX. Called automatically by the compiler. |
| **`solver.py`** | Converts the flat LPSB JSON events into a hierarchical Structure Tree (PDF/UA compatible). |

## Auxiliary Tools

| Script | Description |
|--------|-------------|
| `extract_cells.py` | Standalone tool to extract table cell structures (TD/TR) from PDFs. |
| `fix_table_rows.py` | Helper to fix common table row issues in the extracted data. |
| `download_arxiv_samples.py` | Utility to download sample logical units from arXiv for testing. |

## Subdirectories

- **`analysis/`**: Contains scripts for analyzing compilation errors, verifying PDF lines, and comparing outputs. Useful for debugging and regression testing.
- **`archive/`**: Contains obsolete scripts (e.g., bash-based batch scripts, legacy enrichment attempts) that have been superseded by the Python-based workflow.
