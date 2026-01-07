# Changelog

All notable changes to LPSB are documented here.

## 2026-01-07

### Added
- titlesec package compatibility (`\ttl@straight@ii` hook)
- PNAS template support
- CVPR/ICCV template support with `\texorpdfstring` handling
- ICML template support (`\@sict` hook)
- Internal macro filter for `\@ssect` (filters `\contentsname`, etc.)
- Roman numeral page number support (page values as strings)
- ECCV, CoRL, JHEP, PLOS ONE template testing

### Fixed
- JSON escape errors with `\texorpdfstring` in section titles
- Duplicate section events with skip flag mechanism

### Templates Tested
- ACL, ICML, NeurIPS, ICLR, AAAI, AISTATS, IJCAI (ML/AI)
- CVPR, ICCV, ECCV (Computer Vision)
- CoRL (Robotics)
- JHEP (Physics), PLOS ONE, PNAS (Biology)

---

## 2026-01-06

### Added
- PDF-side table extraction using pdfplumber
- Log markers for row tracking in LuaLaTeX table pass
- Robust table extraction pipeline documentation

### Fixed
- Table visual artifacts from `AddToHook` on longtable
- natbib citation resolution conflicts

---

## 2026-01-05

### Added
- LuaLaTeX table pass (`lpsb-luatable.sty`, `lpsb-table.lua`)
- Cell coordinate extraction via `zref-savepos`
- Colspan inference algorithm

### Fixed
- Table rendering artifacts (extra lines at bottom)

---

## 2025-12 (Earlier Development)

### Added
- LuaLaTeX math pass with MathML extraction (`lpsb-luamath.sty`)
- Two-stage compilation pipeline (gold PDF + enrichment)
- Merge script for combining passes (`merge_lpsb.py`)
- REVTeX compatibility (`\@sect@ltx`)
- KOMA-Script compatibility (`\scr@sect`)
- memoir compatibility (`\M@sect`)
- Chapter support (`\@chapter`)
- Docker-based compilation environment
- Batch processing for arXiv papers

### Core Features
- Structure extraction (sections, paragraphs, lists, figures, tables)
- PDF coordinate mapping
- Environment hooks via `\AddToHook`
