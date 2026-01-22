# LPSB Known Issues

## 修复进度汇总 (Fix Progress Summary)

| 问题 | 原始数量 | 状态 |
|------|----------|------|
| Cross-Page Element Continuation | - | ✅ Fixed |
| Natbib Citation Conflict | 10,505 | ✅ Fixed |
| Hyperref URL Hash Conflict | 1,742 | ✅ Fixed |
| ICML Footnote Conflict | - | ✅ Fixed |
| Theorem Environment Brace Mismatch | - | ✅ Fixed |
| SMF/smfart Class Conflict | - | ✅ Fixed |
| thmtools/restatable Conflict | - | ✅ Fixed |
| Moving Argument Brace Errors | - | ✅ Fixed |
| Misplaced Alignment Tab Error | 4,570 | ✅ Fixed |
| Tag Stack Underflow (lpsb@do@pop) | 744 | ✅ Fixed |
| Undefined Control Sequence (MakeUppercase) | - | ✅ Fixed |
| Infinite Loop Timeout (Safety Limit) | 39 | ✅ Fixed |
| SyncTeX Reading Order Mapping | - | ✅ Fixed |

---

## Cross-Page Element Continuation

**Status**: Fixed in fix_crosspage_mcid.py

Elements spanning pages now correctly tracked and tagged via the `\lpsb@mcid@cont` aux records.

## Natbib Citation Conflict (10,505 occurrences)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: Para hook fired inside natbib citation commands, injecting `\lpsbTagBegin{P}` into `\NAT@star@cite@post` arguments, causing "Paragraph ended before \NAT@star@cite@post was complete" errors.

**Solution**:
- Added `\if@lpsb@in@citation` flag (line 602-604)
- Hooked `\NAT@open` and `\NAT@close` to set/clear the flag (lines 2987-2998)
- Para hook now skips during citation processing (line 2072)
- Reference atoms still generated correctly - this is semantic filtering, not disabling

**Files Modified**: lpsb-mcid.sty

## Hyperref URL Hash Conflict (1,742 occurrences)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: URLs containing `#` characters (e.g., `page.html#section`) caused "Illegal parameter number in definition of \Hy@tempa" errors. The `\url` command uses catcode magic that changes `#` to catcode 12 AFTER reading the argument. Any wrapper using `#1` reads the URL before this catcode change, seeing `#` as a parameter marker.

**Solution**:
- Hook hyperref's internal output primitives `\hyper@linkurl` and `\hyper@link` instead of user-facing commands like `\url`
- These primitives are called AFTER URL parsing is complete, when `#` is already catcode 12
- Link atoms generated correctly for all hyperlinks

**Files Modified**: lpsb-mcid.sty (lines 2671-2712)

## ICML Footnote Conflict

**Status**: Fixed in lpsb-mcid.sty

**Problem**: ICML template's `\printAffiliationsAndNotice` uses `\footnotetext` with multi-line content containing `\forloop`, which produces `\par` tokens. LPSB's footnote hooks used `\def` which doesn't allow `\par` in arguments, causing "Paragraph ended before \lpsb@fntext@noopt was complete" errors.

**Solution**:
- Changed `\def` to `\long\def` for `\lpsb@fntext@opt` and `\lpsb@fntext@noopt` (lines 2623-2624)
- Changed `\protected\def` to `\protected\long\def` for `\lpsbTagAtom` (line 1533)
- Also updated subfigure fallback definitions to use `\long` (lines 1567, 1582)

**Files Modified**: lpsb-mcid.sty

## Theorem Environment Brace Mismatch

**Status**: Fixed in lpsb-mcid.sty

**Problem**: Extra closing brace `}%` at line 1219 caused "Too many }'s" error during package loading.

**Solution**: Removed the redundant closing brace.

**Files Modified**: lpsb-mcid.sty

## SMF/smfart Class Conflict (Missing \endcsname)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: smfart.cls (Société Mathématique de France) uses `\csname\string\title\endcsname` for dynamic command construction. LPSB's standard `\@maketitle` hooks wrapped `\@title` which broke this internal mechanism, causing "Missing \endcsname inserted" errors.

**Solution**:
- Added smfart detection via `\smfandname` command (lines 712-714)
- Added smf to maketitle hook bypass list (line 937-938)
- smf template now uses TitleArea-only tagging like revtex/aastex

**Test Results**: Paper 2001.00045 - errors reduced from 28 to 0

**Files Modified**: lpsb-mcid.sty

## thmtools/restatable Conflict (Missing \item)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: LPSB's `\@thm` hook (amsthm theorem hooks) conflicts with thmtools package's internal theorem management. thmtools rewrites amsthm internals in ways that trigger "Something's wrong--perhaps a missing \item" errors.

**Solution**:
- Added thmtools detection (line 1198-1200)
- Skip `\@thm` hooks entirely when thmtools is loaded
- Added restatable environment hook for fine-grained control

**Test Results**: Paper 2001.00072 - errors reduced from 12 to 0

**Files Modified**: lpsb-mcid.sty

## Moving Argument Brace Errors (captions, sections)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: Core tagging functions (`\lpsbTagBegin`, `\lpsbTagEnd`, `\lpsbTagReferenceAtom`, etc.) use `\immediate\write` and `\begingroup`/`\endgroup` which break group structure when executed in moving arguments (e.g., `\caption{... \cite[...][]{...} ...}`). This caused "Missing } inserted" and "Extra }, or forgotten \endgroup" errors.

**Solution**:
- Added `\ifx\protect\@typeset@protect` check to ALL core tagging functions:
  - `\lpsbTagBegin` - block element begin
  - `\lpsbTagEnd` - block element end
  - `\lpsbTagBeginFloat` - float element begin
  - `\lpsbTagEndFloat` - float element end
  - `\lpsb@TagAtomImpl` - inline atom implementation
  - `\lpsbTagReferenceAtom` - citation reference atoms
  - `\lpsb@inline@math@begin` - inline math begin
  - `\lpsb@inline@math@end` - inline math end
- Skip tagging in non-typesetting contexts (writing .lof/.lot/.toc files)
- Content still displayed correctly, just without LPSB tagging in moving arguments

**Test Results**: Paper 2001.00018 - All brace errors eliminated (0 errors, was 8)

**Files Modified**: lpsb-mcid.sty

## Misplaced Alignment Tab Error (4,570 occurrences)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: Citation wrappers (citep/citet/cite) with bibcodes containing `&` (e.g., `2013A&A...556A...2V` for Astronomy & Astrophysics journal) caused "Misplaced alignment tab character &" errors. The `&` is interpreted as alignment tab during `\def` argument parsing.

**Solution**:
- Disabled citation wrapper hooks (lines 3085-3091)
- NAT@open/NAT@close hooks remain for para hook suppression during citations
- Tradeoff: Citations are not individually tagged as Reference atoms

**Test Results**: Paper 2002.00127 - errors reduced from 6 to 0

**Files Modified**: lpsb-mcid.sty

## Tag Stack Underflow (lpsb@do@pop errors)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: The tag stack pop operation (`\lpsb@do@pop`) failed with "Argument of \lpsb@do@pop has an extra }" errors when the stack was empty or malformed. The `\ifx` comparison used to check for empty stack was unreliable in edge cases, allowing `\lpsb@do@pop` to be called with invalid input.

**Solution**:
- Added robust `\lpsb@stack@is@empty` function using multiple checks:
  - Primary: `\ifx\lpsb@tag@stack\lpsb@empty@stack`
  - Secondary: `\detokenize` comparison for whitespace edge cases
- Added `\lpsb@check@stack@format` to validate stack format before popping
- Updated `\lpsb@pop@tag` to use the robust emptiness check
- Updated `\lpsbTagEnd` to use `\lpsb@stack@is@empty` for consistency
- Malformed stacks are now logged and cleared instead of causing crashes

**Test Results**: Papers 2105.00112, 2401.00097 - all stack underflow errors eliminated

**Files Modified**: lpsb-mcid.sty (lines 231-280)

## Undefined Control Sequence (MakeUppercase)

**Status**: Fixed in lpsb-mcid.sty

**Problem**: Some class files (e.g., `ifacconf.cls`) use `\MakeUppercase` for running headers and TOC entries. This converts LPSB aux commands like `\lpsb@tag@end` to `\LPSB@TAG@END`, causing "Undefined control sequence" errors when the aux file is re-read.

**Solution**:
- Added uppercase aliases for all LPSB aux file commands:
  - `\LPSB@TAG@DATA`, `\LPSB@TAG@ATOM`, `\LPSB@TAG@END`
  - `\LPSB@MCID@CONT`, `\LPSB@SUMMARY`, `\LPSB@META`, `\LPSB@REFKEY`
  - `\LPSB@LAYOUT`, `\LPSB@PASS@FLOAT`, `\LPSB@PASS@PAGEBREAK`, etc.
- Both lowercase and uppercase versions are defined as no-ops
- Uppercase commands produced by `\MakeUppercase` are now silently consumed

**Test Results**: Paper 2105.00112 - all LPSB@TAG@END errors eliminated

**Files Modified**: lpsb-mcid.sty (lines 45-66, 3190-3195)

## Infinite Loop Timeout (39 papers)

**Status**: Fixed in lpsb-mcid.sty (Root Cause Fix)

**Problem**: Certain document configurations (particularly those using float.sty with specific page styles) caused infinite page generation during the output routine. The infinite loop manifested as:
- 400,000+ empty pages generated before memory overflow
- "TeX capacity exceeded, sorry [number of strings=...]" error
- Each page showing "Underfull \vbox (badness 10000)" and "Underfull \hbox (badness 10000)"
- `[][]` markers indicating empty hboxes during output

**Root Cause Analysis**:
1. `\AtBeginShipoutNext` is a one-shot hook (only runs once on page 2)
2. `@lpsb@in@shipout` flag was set to true in `\AtBeginShipout` but only reset to false in `\AtBeginShipoutNext`
3. From page 3 onwards, `@lpsb@in@shipout` stayed true forever, causing paragraph hook to be skipped
4. After document ends, LPSB hooks continued to run during `\clearpage`, potentially interfering with output routine cleanup

**Solution** (Tagging-Preserving Fix):
1. Reset `@lpsb@in@shipout` flag at the START of each `\AtBeginShipout` (before setting it to true)
   - This ensures the flag is properly reset for each page transition
   - Paragraph tagging now works correctly for all pages (not just pages 1-2)

2. Disable LPSB in `\AtEndDocument` after `\lpsbTagEnd`
   - Sets `\@lpsb@activefalse` to prevent shipout hooks from interfering after document ends
   - Floats are already tagged inside their boxes via `\@xfloat` hook, so this doesn't affect float tagging
   - This is the key fix that prevents infinite page generation

**Benefits over previous safety mechanism**:
- Preserves ALL tagging (previous safety mechanism disabled all tagging when page limit exceeded)
- Fixes the root cause rather than just symptom
- No arbitrary page limits needed

**Affected Papers**: 39 papers including 2004.00030, 2005.00059, 2107.00140, 2302.00007, etc.

**Files Modified**: lpsb-mcid.sty (lines 258-264, 3002-3010)

## Section Hooks Conflict with SMF Templates

**Status**: Fixed in lpsb-mcid.sty

**Problem**: SMF (Société Mathématique de France) templates (smfart.cls, smfbook.cls) use complex section internals (`\smf@sf`, `\smf@eebox`) that conflict with LPSB's section hooks. This caused "Extra }" and "endgroup" errors.

**Solution**:
- Added `\if@lpsb@skip@sectionhooks` flag
- Detect smf templates via `\smf@sf` macro
- Skip section hooks entirely for smf templates
- Section content still tagged via TitleArea and P tags

**Files Modified**: lpsb-mcid.sty (lines 1738-1750, 2039)

## Metadata Hooks Conflict with Complex Templates

**Status**: Fixed in lpsb-mcid.sty

**Problem**: Author/affiliation/institute hooks assume specific argument patterns that don't match all templates. Templates like acmart, elsarticle, amsart, revtex, etc. use different argument syntax (multiple optionals, key-value, different signatures).

**Solution**:
- Added `\if@lpsb@skip@metahooks` flag
- Skip metadata hooks for templates with known complex author handling
- Affected templates: acmart, elsarticle, amsart, revtex, aastex, llncs, svjour, ieeetran

**Files Modified**: lpsb-mcid.sty (lines 1623-1645, 1709)

## Affiliations Hook Conflict

**Status**: Fixed in lpsb-mcid.sty

**Problem**: The `\affiliations` hook assumed exactly one mandatory argument, but some templates define `\affiliations` with optional arguments or different syntax.

**Solution**:
- Disabled affiliations hook entirely (metadata capture is not critical for PDF tagging)
- Content still properly tagged via structure tags

**Files Modified**: lpsb-mcid.sty (lines 961-973)

## Inline Atom Tags - Pre-defined Constants

**Status**: Fixed in lpsb-mcid.sty

**Problem**: `\lpsbTagAtom` used internal `\def` commands (`\def\lpsb@Caption@const{Caption}`, etc.) which could cause issues in fragile contexts like alignments, potentially contributing to "Misplaced \crcr" errors.

**Solution**:
- Pre-defined constants at package load time (`\lpsb@const@Caption`, etc.)
- Modified `\lpsbTagAtom` to use pre-defined constants instead of internal `\def`
- Used `\begingroup`/`\endgroup` with `\edef` for safe comparison

**Files Modified**: lpsb-mcid.sty (lines 1064-1072, 1512-1531)

## SyncTeX Reading Order Mapping

**Status**: Fixed in compute_order_map.py

**Problem**: Reading order computation had multiple issues:
1. Using `start_page` as primary sort key incorrectly prioritized PDF render position over source code order
2. Template-generated elements (Title, Author, Note) matched to wrong source files via SyncTeX coordinate lookup
3. Cross-page and cross-column P elements matched to incorrect source lines when using element center instead of first character

**Root Cause Analysis**:
- SyncTeX maps PDF coordinates → source code positions (file_id, line)
- The correct approach is "多:1 mapping" (many PDF positions → one source line)
- For a cross-page P element, all MCIDs should trace back to the SAME source line
- Previous code used element bbox center for matching, which was unreliable
- Template elements (Title, Author) have no SyncTeX records at their PDF positions because they're generated by `\maketitle` macro expansion

**Solution**:
1. **Use first MCID's first character position** for SyncTeX reverse lookup
   - More precise than bbox center
   - Correctly handles cross-page/cross-column elements

2. **Correct Y coordinate conversion**:
   ```python
   y_pdf = page_height - sp_to_pdf_points(rec.y)  # Convert to top-origin
   ```

3. **Sort key: (file_id, source_line, elem_id)**
   - `file_id` groups content by source file (respects `\input` order)
   - `source_line` orders within each file
   - `elem_id` as tiebreaker (LaTeX processing order)
   - NO `start_page` - PDF render position should not override source order

4. **Template elements special handling**:
   - Title, Author, Note, Affil use `(main_file_id, elem_id, elem_id)` as sort key
   - These are generated by `\maketitle` in main.tex, but SyncTeX has no records for them
   - Using `elem_id` preserves LaTeX processing order

5. **SyncTeX file path resolution**:
   - Support `main_fixed.pdf` → `main.synctex.gz` mapping
   - Try multiple candidate paths when synctex_path not specified

**Correct Reading Order Result**:
```
#1:  Title      (main.tex, elem_id=2)
#2:  Author     (main.tex, elem_id=4)
#3:  Author     (main.tex, elem_id=6)
...
#11: Note       (main.tex, elem_id=23)
#12: H1         (intro.tex:1)
#13: P          (intro.tex:2)
...
```

**Files Modified**: script/postprocess/compute_order_map.py