# Template Compatibility

LPSB provides broad compatibility with LaTeX document classes and conference/journal templates commonly used on arXiv.

## Compatibility Summary

- **14+ conference/journal templates** tested
- **10+ document classes** supported
- **Estimated arXiv coverage**: ~98%

## Supported Document Classes

| Class | Publisher/Type | Hook Strategy | Status |
|-------|---------------|---------------|--------|
| `article` | LaTeX base | Standard `\@sect` | ✅ |
| `book` | LaTeX base | `\@chapter` + `\@sect` | ✅ |
| `report` | LaTeX base | `\@chapter` + `\@sect` | ✅ |
| `IEEEtran` | IEEE | Standard `\@sect` | ✅ |
| `revtex4-2` | APS (Physics) | `\@sect@ltx` | ✅ |
| `acmart` | ACM | Standard `\@sect` | ✅ |
| `llncs` | Springer LNCS | Standard `\@sect` | ✅ |
| `elsarticle` | Elsevier | Standard `\@sect` | ✅ |
| `amsart` | AMS | Standard `\@sect` | ✅ |
| `memoir` | - | `\M@sect` | ✅ |
| `scrartcl` | KOMA-Script | `\scr@sect` | ✅ |

## Supported Conference Templates

### Machine Learning / Artificial Intelligence

| Conference | Template | Hook Strategy | Status |
|------------|----------|---------------|--------|
| ACL/EMNLP/NAACL | `acl.sty` | Standard | ✅ |
| ICML | `icml20XX.sty` | `\@sict` | ✅ |
| NeurIPS | `neurips_20XX.sty` | Standard | ✅ |
| ICLR | `iclr20XX.sty` | Standard | ✅ |
| AAAI | `aaai20XX.sty` | Standard | ✅ |
| AISTATS | `aistats20XX.sty` | Standard | ✅ |
| IJCAI | `ijcaiXX.sty` | Standard | ✅ |

### Computer Vision

| Conference | Template | Hook Strategy | Status |
|------------|----------|---------------|--------|
| CVPR | `cvpr.sty` | `\cvprsect` | ✅ |
| ICCV | `iccv.sty` | `\iccvsect` | ✅ |
| ECCV | `eccv.sty` | Standard | ✅ |

### Robotics

| Conference | Template | Hook Strategy | Status |
|------------|----------|---------------|--------|
| CoRL | `corl_20XX.sty` | Standard | ✅ |

### Physics

| Journal | Template | Hook Strategy | Status |
|---------|----------|---------------|--------|
| Physical Review | `revtex4-2` | `\@sect@ltx` | ✅ |
| JHEP | `jheppub.sty` | Standard + filter | ✅ |

### Biology / Interdisciplinary

| Journal | Template | Hook Strategy | Status |
|---------|----------|---------------|--------|
| PLOS ONE | Article-based | Standard | ✅ |
| PNAS | `pnas.cls` | `titlesec` hook | ✅ |

## Hook Strategies

LPSB uses different strategies to capture section commands depending on how templates redefine LaTeX internals:

### Standard (`\@sect` / `\@ssect`)

Most templates use the standard LaTeX sectioning mechanism. LPSB hooks `\@sect` for numbered sections and `\@ssect` for starred sections.

### REVTeX (`\@sect@ltx`)

REVTeX (used by APS journals) redefines `\@startsection` to call `\@sect@ltx` instead of `\@sect`. LPSB detects and hooks this alternate command.

### KOMA-Script (`\scr@sect`)

KOMA-Script classes use their own sectioning commands. LPSB hooks `\scr@sect` and `\scr@ssect`.

### memoir (`\M@sect`)

The memoir class uses `\M@sect` with a different signature (double optional arguments). LPSB provides a specialized hook.

### ICML (`\@sict`)

ICML templates use `\@sict` (likely a typo for `\@sect`) in their two-column layout. LPSB hooks this command.

### CVPR/ICCV (`\cvprsect` / `\iccvsect`)

CVPR and ICCV templates wrap section titles with `\texorpdfstring` for PDF bookmarks, which introduces escape character issues. LPSB hooks the wrapper commands directly to capture clean titles.

### titlesec (`\ttl@straight@ii`)

The titlesec package completely rewrites LaTeX's sectioning mechanism. LPSB hooks the internal `\ttl@straight@ii` command (7 parameters) to capture sections formatted by titlesec.

## Compiler Requirements

| Compiler | Features |
|----------|----------|
| pdfLaTeX | Structure extraction (sections, paragraphs, tables, figures) |
| XeLaTeX | Structure extraction (same as pdfLaTeX) |
| LuaLaTeX | Structure + Math extraction (MathML via `luamml`) |

### Notes

- **PNAS**: Requires LuaLaTeX due to fontspec dependency in the unofficial template
- **Math extraction**: Requires LuaLaTeX for `luamml` integration
- **Table extraction**: Works with any compiler; PDF-side extraction available as fallback

## Package Load Order

For optimal compatibility, load LPSB packages after template packages:

```latex
\documentclass{article}
\usepackage{cvpr}           % Template package first
\usepackage{lpsb}           % LPSB after template
\usepackage{lpsb-luamath}   % Optional: math extraction
\usepackage{lpsb-luatable}  % Optional: table extraction
```

## Testing

All templates are tested with comprehensive test files in `tests/`:

```
tests/test_acl_comprehensive.tex
tests/test_icml_comprehensive.tex
tests/test_neurips_comprehensive.tex
...
```

Each test file includes sections, subsections, tables, figures, and mathematical content to verify complete extraction.

## Adding Support for New Templates

To add support for a new template:

1. **Identify the sectioning mechanism**: Check if the template redefines `\section`, `\@sect`, or uses packages like `titlesec`
2. **Add detection logic**: Use `\@ifundefined` to check for template-specific commands
3. **Implement hook**: Create a hook that captures the title and level before calling the original command
4. **Add skip flag if needed**: Prevent duplicate events when multiple hooks fire
5. **Test thoroughly**: Create a comprehensive test file with the new template

Example hook structure:
```latex
\@ifundefined{templatecmd}{}{%
    \let\lpsb@origtemplatecmd\templatecmd
    \def\templatecmd#1{%
        \lpsbWriteEntry{...}%
        \lpsb@origtemplatecmd{#1}%
    }%
}%
```
