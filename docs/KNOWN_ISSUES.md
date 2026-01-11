# LPSB Known Issues

## Split Section Headings (`\section*`)

**Status**: Known limitation, workaround available

**Symptom**: 
When using `\section*{References}` (starred sections), the H1 tag may contain only spurious content like "6*" while the actual title text ("References") appears in a following P tag.

**Example**:
```
PDF Content Stream:
  /H1 << /MCID 271>> BDC
    [(6)-1050(*)]TJ      ← "6*" in H1
  EMC
  /P << /MCID 273>> BDC
    [(References)]TJ      ← Title in P!
  EMC
```

**Root Cause**:
LaTeX's `\@ssect` macro uses delayed output via `\@svsechd`. The section formatting outputs content in stages:
1. First: section number formatting area (even for starred sections, some output occurs)
2. Later: actual title text (via `\@xsect`)

The pdflatex `\pdfliteral` commands for BDC/EMC are executed at the time of LaTeX processing, not when PDF content is actually written. This timing mismatch causes the split.

**Attempted Fixes (All Failed)**:
1. Wrapping only title argument (#5) in H1 - LaTeX internal processing still splits output
2. Suppressing everypar during section formatting - Problem not caused by everypar
3. Hooking `\@xsect` to delay H1 closure - Still doesn't work due to pdflatex output timing
4. Hooking `\bibsection` directly - Same underlying issue

**Workaround**:
Use post-processing script to merge split headings:
```bash
python script/fix_split_headings.py output.mcid.json -o output_fixed.mcid.json
```

**Affected Packages**:
- natbib (uses `\section*{\refname}` for bibliography)
- Any document using `\section*`, `\subsection*`, etc.

---

## Empty P Tags After Floats

**Status**: Documented, partial fix in place

**Symptom**:
Empty P tags (BDC immediately followed by EMC) appear after figure/table floats.

**Root Cause**: 
The `\AtEndEnvironment{figure}` hook calls `\lpsbTagBegin{P}` at the source location when the float is defined, not where it's placed.

**Current Behavior**:
Empty P tags are harmless for semantic structure but add noise to the MCID output.

---

## Cross-Page Element Continuation

**Status**: Fixed in fix_crosspage_mcid.py

Elements spanning pages now correctly tracked and tagged via the `\lpsb@mcid@cont` aux records.
