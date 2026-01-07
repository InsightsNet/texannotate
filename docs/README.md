# LPSB Documentation

This directory contains technical documentation for LPSB (LaTeX Parser for Structured Bounding-boxes).

## Overview

LPSB is a LaTeX instrumentation framework that extracts document structure, mathematical content, and tabular data from LaTeX source files during compilation. Unlike PDF-based extraction approaches, LPSB captures semantic structure directly from the TeX processing pipeline.

## Document Index

### Core Documentation

| Document | Description |
|----------|-------------|
| [README.md](README.md) | This file - documentation overview |
| [ARCHITECTURE.md](ARCHITECTURE.md) | System architecture and design rationale |
| [QUICK_START.md](QUICK_START.md) | Getting started guide |
| [TEMPLATE_COMPATIBILITY.md](TEMPLATE_COMPATIBILITY.md) | Supported document classes and conference templates |

### Technical Reference

| Document | Description |
|----------|-------------|
| [STRUCTURE_PASS.md](STRUCTURE_PASS.md) | LaTeX structure extraction (`lpsb.sty`) |
| [MATH_EXTRACTION.md](MATH_EXTRACTION.md) | Mathematical content extraction with MathML |
| [TABLE_EXTRACTION.md](TABLE_EXTRACTION.md) | Table structure extraction approaches |
| [BATCH_PROCESSING.md](BATCH_PROCESSING.md) | Batch compilation for arXiv papers |

### Development

| Document | Description |
|----------|-------------|
| [DEVELOPMENT.md](DEVELOPMENT.md) | Development setup and guidelines |
| [TROUBLESHOOTING.md](TROUBLESHOOTING.md) | Common issues and solutions |
| [CHANGELOG.md](CHANGELOG.md) | Version history and updates |

## Key Features

- **Structure Extraction**: Captures document hierarchy (sections, paragraphs, lists, figures, tables)
- **Math Extraction**: Extracts mathematical expressions with optional MathML conversion
- **Template Compatibility**: Supports 14+ major conference/journal templates
- **Coordinate Mapping**: Provides PDF page coordinates for extracted elements
- **Batch Processing**: Automated pipeline for processing arXiv paper collections

## Citation

If you use LPSB in your research, please cite:

```bibtex
@inproceedings{lpsb,
  title={LPSB: Source-Side Document Structure Extraction from LaTeX},
  author={[Authors]},
  booktitle={[Venue]},
  year={[Year]}
}
```
- [Development Lessons](DEVELOPMENT_LESSONS.md) - Technical insights and pitfalls
