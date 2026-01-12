# LPSB Known Issues

## Split Section Headings (`\section*`) vs “6*” Printed Into the PDF

**Status**: Partially fixed (semantic), plus a separate hard bug (visual) fixed

**Symptom A (semantic split)**:
When using `\section*{References}` (starred sections), the heading content may be split across elements:
- The `H1` element contains only a stub (often something like `6*` or other short junk)
- The actual title text (`References`) lands in a following `P`

**Symptom B (visual corruption; much worse)**:
The PDF itself shows a visible line `6 *` above `References`.
This is not a tagging artifact — it is real text rendered into the PDF.

**Example (semantic split)**:
```
PDF Content Stream:
  /H1 << /MCID 271>> BDC
    [(6)-1050(*)]TJ      ← "6*" in H1
  EMC
  /P << /MCID 273>> BDC
    [(References)]TJ      ← Title in P!
  EMC
```

**Root Cause (semantic split)**:
LaTeX's `\@ssect` macro uses delayed output via `\@svsechd`. The heading formatting outputs content in stages:
1. First: section number formatting area (even for starred sections, some output occurs)
2. Later: actual title text (via `\@xsect`)

The pdflatex `\pdfliteral` commands for BDC/EMC are executed at the time of LaTeX processing, not when PDF content is actually written. This timing mismatch causes the split.

**Root Cause (visual `6*` printed)**:
This happens when we wrap `\section` incorrectly and *do not preserve the star form*.
If `\section` is redefined as “optional-arg only” (e.g. `\renewcommand{\section}[1][]{...}`),
then `\section*{References}` is mis-parsed as `\section{*}`.
Result: LaTeX legitimately typesets “section 6 with title `*`” → a visible `6 *`, and
`References` falls into the next paragraph.

**Fix / Workaround**:

- **For Symptom A (semantic split)**: run split-heading repair on the **aux** that feeds downstream consumers
  (document tree / StructTree injection). The compiler can generate and use `*.aux.fixed`.

```bash
python script/postprocess/fix_split_headings.py input.aux -o input.aux.fixed
```

- **For Symptom B (visual `6*` printed)**: preserve `\section*` and `\subsection*` when wrapping.
  Use `\@ifstar` to dispatch to the original `\section*{...}`.

**Affected Templates / Packages**:
- natbib (bibliography headings)
- many conference styles that implement their own sectioning wrappers

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

---

## Wrapping LaTeX Macros: Preserve Optional Arguments (or You Will Leak Tokens)

**Status**: Fixed (but this is a recurring foot-gun)

**Symptom**:
Stray `[` and `]` appear as *visible glyphs* in the PDF (often near the title block), sometimes also corrupting layout/overlaps.

**Root Cause**:
We wrapped `\twocolumn` to record layout switches, but did **not** preserve its optional-argument form:

- `\twocolumn[<top material>]` is a real interface used by many classes/templates (including title pages).
- If a wrapper defines only `\twocolumn` with *no optional-arg parsing*, the following `[` / `]` tokens are no longer consumed as delimiters and get typeset as normal text.

**Key Lesson**:
When you wrap/patch a LaTeX command, you must preserve **all call shapes** it supports:

- Optional arguments `[...]` (possibly multiple)
- Star forms `\cmd*`
- Kernel helpers like `\@dblarg`, `\@ifnextchar`, etc.

If you don't, you are not “slightly incompatible” — you are *printing delimiters into the document*.

**Fix Pattern (example for `\twocolumn`)**:
Use `\@ifnextchar[` to forward both variants to the original macro.
