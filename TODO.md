# LPSB TODO

## Phase 1 - Current Implementation

- [x] Two-stage compilation (pdfLaTeX Gold + LuaLaTeX enrichment)
- [x] Formula position tracking (zsavepos in pdfLaTeX)
- [x] Inline formatting position tracking (Strong, Em, Link)
- [x] Dynamic TeX Live version selection
- [x] Batch processing with parallel workers
- [x] merge_lpsb.py for combining structure + math JSON
- [x] enrich_positions.py for coordinate enrichment

## Phase 2 - Cross-line Element Handling

- [x] PDFplumber word-level bbox extraction
- [x] `refine_inline_bboxes()` for splitting multi-line elements into fragments
- [x] Width/height calculation from start/end zsavepos

## Phase 3 - PDF Marked Content (Planned)

> **Goal**: Write LPSB IDs directly into PDF content stream as Marked Content sequences.
> This provides a more reliable bridge between PDF and JSON than coordinate matching.

### Implementation Plan

1. **LuaTeX Integration** (lpsb-math.lua, lpsb.sty LuaTeX branch)
   ```lua
   -- Before content:
   pdf.literal("/LPSB." .. id .. " BDC")  -- Begin Designated Marked Content
   
   -- After content:
   pdf.literal("EMC")  -- End Marked Content
   ```

2. **Elements to Mark**
   - [ ] Math/Formula environments (`Sec-N-Math-M`)
   - [ ] Sections/Headings (`H-N`)
   - [ ] Lists/Items (`List-N`, `LI-N`)
   - [ ] Figures/Tables (`Figure-N`, `Table-N`)
   - [ ] Inline formatting (`Strong-N`, `Em-N`, `Link-N`)

3. **PDF Parsing Tool** (new script: `extract_mcid.py`)
   - Parse PDF content stream for `/LPSB.*` BDC markers
   - Extract glyph bboxes within each marked region
   - Output: `{id: "Sec-1-Math-2", glyphs: [{char, bbox}, ...]}`

4. **Advantages**
   - No coordinate matching errors
   - Works even if layout differs between pdfLaTeX and LuaLaTeX
   - Industry-standard PDF structure (similar to Tagged PDF)

5. **Limitations**
   - Only works in LuaLaTeX stage (not pdfLaTeX Gold)
   - Fallback to coordinate matching for pdfLaTeX elements

### Dependencies
- pypdf or pdfminer.six for PDF parsing
- No additional LaTeX packages required (uses raw pdf.literal())

## Phase 4 - Future Enhancements

- [ ] PDF/UA Tagged PDF output (requires modern TeX Live with tagpdf)
- [ ] HTML output generation from JSON + PDF
- [ ] Integration with document viewers (e.g., SumatraPDF with structure tree)

## TeX Live Compatibility Notes

### Minimum Requirement: **TeX Live 2020 (2020-10-01 kernel)**

| TeX Live | Status | Notes |
|----------|--------|-------|
| TL2023/2024 | ✅ Full | |
| TL2021/2022 | ✅ Full | |
| TL2020 (Oct+) | ✅ Full | |
| TL2020 (pre-Oct) | ⚠️ Partial | `\AddToHook` may be missing |
| TL2019 and earlier | ❌ Needs fallback | Requires conditional code |

### Key Dependencies

| Feature | Requires | Fallback Needed |
|---------|----------|-----------------|
| `\AddToHook` | LaTeX 2020-10-01+ | Use etoolbox `\AtBeginEnvironment` |
| `\zsavepos` | zref package | All modern TL |
| `\AtBeginEnvironment` | etoolbox | TL2010+ |
| `\everymath`/`\everydisplay` | TeX primitive | All versions |

### To Support TL2019 and Earlier

```latex
\@ifundefined{AddToHook}{%
    % Fallback for old LaTeX kernel
    \AtBeginEnvironment{...}{...}
}{%
    % Modern LaTeX kernel
    \AddToHook{env/.../begin}{...}
}
```
