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
- Batch rerun helper for failed cases: `script/analysis/rerun_failed_cases.py`
- Minimal arXiv compatibility stubs (only used when sources omit these files): `arxiv_stubs/manual/`
  - `jheppub.sty`, `aastex.cls`, `aastex6.cls`, `iopart.cls`, `tcilatex.tex`, `diagrams.sty`, `picins.sty`, `aa.cls`, `svmult.cls`, `PoS.cls`

### Fixed
- JSON escape errors with `\texorpdfstring` in section titles
- Duplicate section events with skip flag mechanism
- Robust `\documentclass`-adjacent injection for `\usepackage{lpsb}` when `\documentclass` spans multiple lines (prevents `\@fileswith@pti@ns has an extra }`-style crashes)
- Docker run volume mount now always mounts stage dir at `/workdir` (workdir selection handled by `-w`), preventing path resolution breakage for papers with nested sources
- `Missing $ inserted.` crashes from raw underscores in bibliography item keys by enabling a localized underscore catcode workaround during `.bbl`/`bbl.tex`/`.aux`/`.toc` input (avoids global `_` activation issues)
- Preflight detection for shipped/pre-generated `.bbl` files so the workaround is applied before the first `pdflatex` pass (prevents immediate crash on first bibliography read)
- Fix `LPSB_BBL_UNDERSCORE_FIX` plain `\input` wrapper to only intercept braced `\input{...}` (avoids breaking package loads like `\input xstring.tex`, which can manifest as missing `p.tex` or reading TeXLive’s `x.tex`)
- Analysis script now supports current per-paper aggregated log name `compile.log`: `script/analysis/analyze_compile_errors.py`
- Avoid selecting non-LaTeX payloads (e.g. HTML accidentally named `*.tex`) as main entrypoints; these previously surfaced as `LaTeX Error: Missing \begin{document}.`

### Templates Tested
- ACL, ICML, NeurIPS, ICLR, AAAI, AISTATS, IJCAI (ML/AI)
- CVPR, ICCV, ECCV (Computer Vision)
- CoRL (Robotics)
- JHEP (Physics), PLOS ONE, PNAS (Biology)

---

## 2026-01-08

### Fixed
- `I can't find file \`}'` failures (often triggered in `babel.def`) by delaying `LPSB_BBL_UNDERSCORE_FIX` input-hooking until `\AtBeginDocument`
- Expanded `arxiv_stubs/manual/` fallback copy list (including LNCS `llncs.cls` and `splncs04.bst`) and added safe filename aliasing (e.g. `aastex631.cls` → `aastex63.cls`) to match legacy arXiv expectations
- natbib author-year incompatibility (`Bibliography not compatible with author-year citations.`): auto-inject numeric citation style and retry gold pdflatex passes
- (now opt-in) natbib numeric-mode fallback is disabled by default; enable with `LPSB_ENABLE_NATBIB_NUMBERS_FIX=1`
- `Argument of \lpsbWriteEntry has an extra }.` hard failures on Wiley templates by hooking the correct `\@ssect` signature for `WileyNJD-v2` (6-arg variant); prevents runaway-argument cascades in starred sections / bibliography headings

### Updated (2026-01-10)
- Batch input discovery: `--batch <DIR>` now prefers directory-per-paper layouts (subdirs like `2202.00012/`) to avoid treating auxiliary `*.tex` as separate papers.
- Main TeX selection: `find_main_tex()` de-prioritizes common template/demo files (`natbib.tex`, `natnotes.tex`, `aassymbols.tex`) and prefers real manuscripts (title/author/abstract heuristics + size tie-breakers).
- Stub injection safety: `arxiv_stubs/collected/` and `arxiv_stubs/manual/` are copied **on-demand** based on “File ... not found” in LaTeX logs (no bulk injection); core packages (`biblatex*`, `blx-*`, `expl3/xparse`, kernel-ish) are excluded from injection.
- LaTeXML bridge robustness: `latexml_to_lpsb.py` tolerates backslashes in structure JSON strings and strips `\\lpsbMark{...}` from MathML attributes (alignment markers don’t leak into exported MathML).
- Fatal classification: compile-log scanning no longer treats early hard-stops as fatal if a later retry produces a PDF; only the last run’s true hard-stop without PDF is fatal.
- InlineMath bbox: improved bbox filling for superscript footnote-style markers (e.g. `^{1}`) when TeX-side end markers are missing.

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
