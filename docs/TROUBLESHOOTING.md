# Troubleshooting

Common issues and solutions for LPSB.

## Compilation Issues

### Missing arXiv template/class files (e.g. `jheppub.sty`, `aastex.cls`, `iopart.cls`)

**Symptom**:
- `! LaTeX Error: File 'jheppub.sty' not found.`
- `! LaTeX Error: File 'aastex.cls' not found.`
- `! LaTeX Error: File 'iopart.cls' not found.`
- `! LaTeX Error: File 'tcilatex.tex' not found.`

**Cause**:
Some arXiv sources rely on template/class files that are available in arXiv's build environment
but are not included in the submission tarball and may not exist in your TeX Live image.

**Solution (LPSB default)**:
The compiler will copy files from `arxiv_stubs/` into the build directory **only if the source tree
does not already provide that file**. This unblocks compilation for structure extraction.

**Important**:
- Put **official upstream files** into `arxiv_stubs/` (CTAN / publisher / project homepages). Do not
  “hand-roll” replacement `.cls/.sty` unless you fully control licensing and behavior.
- LPSB will not overwrite author-provided files; `arxiv_stubs/` is only a fallback when the source
  package is incomplete.

### Crash around `\documentclass` (e.g. `\@fileswith@pti@ns has an extra }`)

**Symptom**:
- `! Argument of \@fileswith@pti@ns has an extra }.`
- Often followed by `Missing \\begin{document}` and cascaded errors.

**Cause**:
Some papers use a multi-line `\documentclass[...]` declaration. Injection logic must not insert
packages inside the option block. (This is easy to get wrong if you treat braces line-by-line.)

**Solution**:
`script/lpsb_compiler.py` now parses until the mandatory `{class}` argument closes, and inserts
`\\usepackage{lpsb}` after that point.

### `LaTeX Error: Missing \begin{document}.`

**Symptom**:
- `! LaTeX Error: Missing \begin{document}.`

**Cause**:
The selected “main `.tex`” is not a LaTeX document. In arXiv sources we have seen `*.tex`
files that are actually HTML (e.g. starting with `<html>`), which makes `pdflatex` complain
and abort.

**Solution (LPSB default)**:
`find_main_tex()` rejects obvious non-LaTeX payloads and will not pick a file as the entrypoint
unless it contains a real LaTeX marker like `\documentclass` or `\begin{document}`.

### Undefined control sequence: `\directlua`

**Symptom**: Error when compiling with pdfLaTeX

**Cause**: Document loads `lpsb-luamath` or `lpsb-luatable` which require LuaLaTeX

**Solution**: Compile with `lualatex` instead of `pdflatex`, or remove the Lua-dependent packages

### fontspec error with pdfLaTeX

**Symptom**: `fontspec` requires XeTeX or LuaTeX

**Cause**: Template (e.g., PNAS) requires `fontspec`

**Solution**: Use LuaLaTeX: `lualatex document.tex`

### biblatex `.bbl` format mismatch

**Symptom**: 
- Compilation produces 100,000+ pages
- Raw biblatex internal data printed as text
- Warning: `File '*.bbl' is wrong format`

**Cause**: Pre-generated `.bbl` file incompatible with TeX Live version

**Solution**:
1. Check `.bbl` header: `head -3 *.bbl | grep "bbl format version"`
2. Use matching TeX Live version:
   - Format 3.1 → TeX Live 2022
   - Format 3.2 → TeX Live 2023
   - Format 3.3+ → TeX Live 2024/2025

### `Missing $ inserted.` (often from `.bbl` / `bbl.tex`)

**Symptom**:
- `! Missing $ inserted.` and the log points into a bibliography line like `\bibitem{Key_With_Underscore}`.

**Cause**:
Some sources ship pre-generated bibliography files where the `\bibitem{...}` key contains raw `_`,
which TeX interprets as math subscript in text mode.

**Solution (LPSB default)**:
LPSB detects raw `_` in bibliography keys (both `.bbl` and `bbl.tex`) and injects a **localized**
underscore catcode workaround that only applies while reading bibliography/aux/toc inputs.
This is done *before the first `pdflatex` pass* to handle shipped `.bbl` files that would otherwise
crash immediately.

### inputenc error with LuaLaTeX

**Symptom**: `Package inputenc Error: inputenc is not designed for use with xetex/luatex`

**Cause**: Legacy package conflict

**Solution**: Use two-stage compilation (pdfLaTeX for PDF, LuaLaTeX for math)

## Extraction Issues

### Zero headings captured

**Possible causes**:

1. **Template uses non-standard sectioning**
   - Check if template uses `titlesec`, custom macros, or completely redefines `\section`
   - Solution: Add template-specific hook to `lpsb.sty`

2. **LPSB loaded before template**
   - Solution: Load `\usepackage{lpsb}` after template package

3. **Compilation error**
   - Check log for errors that may have prevented LPSB initialization

### JSON parse error

**Symptom**: `json.decoder.JSONDecodeError: Invalid \escape`

**Possible causes**:

1. **Backslash in section title**
   - e.g., `\texorpdfstring` creating `\t` (interpreted as tab)
   - Solution: Template-specific hook to capture clean title

2. **Roman numeral page number**
   - e.g., `"page": i` (bare identifier)
   - Solution: Already fixed in latest LPSB (page is now string)

3. **Internal macros in output**
   - e.g., `\contentsname \@mkboth` from table of contents
   - Solution: Internal macro filter in `\@ssect` hook

### Missing MathML

**Symptom**: `mathml: ""` or empty in output

**Causes**:
1. Compiled with pdfLaTeX instead of LuaLaTeX
2. `luamml` not installed in TeX Live image
3. Formula in unsupported environment

**Solution**: Use LuaLaTeX with LPSB Docker image (includes `luamml`)

### Table extraction issues

**Symptom**: No TD events or incorrect structure

**PDF-side extraction**:
- Ensure tables have visible lines (booktabs may not be detected)
- Check: `pdfplumber.open('doc.pdf').pages[0].find_tables()`

**LuaLaTeX pass**:
- Run two passes (coordinates require `.aux` file)
- Empty cells are not captured

## Docker Issues

### Image not found

**Symptom**: `Unable to find image 'lpsb-texlive:latest'`

**Solution**: Build the image:
```bash
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker
```

### Permission denied

**Symptom**: Cannot write to mounted volume

**Solution**: Check Docker user/group permissions or use `--user $(id -u):$(id -g)`

## Python Issues

### ModuleNotFoundError: pdfplumber

**Solution**:
```bash
pip install pdfplumber
# or
pip install -r requirements.txt
```

### Invalid JSON in merged output

**Cause**: Line-by-line parsing issue

**Solution**: Check individual JSON files before merge:
```bash
python -c "import json; json.load(open('file.lpsb.json'))"
```

## Performance Issues

### Slow compilation

**Factors**:
- Large bibliography (many `\cite` commands)
- Many figures/tables
- Multiple compilation passes

**Solutions**:
- Use draft mode for initial testing
- Pre-compile with `latexmk` for caching
- Parallelize batch processing

### Large output files

**Cause**: Very detailed structure (many paragraphs, formulas)

**Solution**: Post-process to filter unnecessary events

## Debugging

### Enable verbose output

Add to document preamble:
```latex
\usepackage{lpsb}
\lpsbDebug  % Enable debug messages
```

### Check hook installation

Look for LPSB Info messages in log:
```
LPSB Info: titlesec detected, hooking ttl@straight@ii
LPSB Info: Package v3.0 active (PDF 2.0 Structure Elements)
```

### Inspect JSON output

```bash
# Pretty print
python -c "import json; print(json.dumps(json.load(open('doc.lpsb.json')), indent=2))" | head -50

# Count events
grep -c '"event": "start"' doc.lpsb.json

# Find specific roles
grep '"role": "H2"' doc.lpsb.json
```

### Rerun only the failed cases from a previous batch

If you have a batch output directory (e.g. `compile_test_20260107_180627/`) and want to rerun
only the cases that failed (missing PDF or `COMPILATION_FAILED` marker):

```bash
python3 -u script/analysis/rerun_failed_cases.py \
  compile_test_20260107_180627 \
  data/arxiv/arxiv_extracted \
  --out _rerun_failed/out \
  --no-ramdisk \
  -j 250
```
