# Troubleshooting

Common issues and solutions for LPSB.

## Compilation Issues

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
