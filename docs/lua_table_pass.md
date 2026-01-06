# LuaLaTeX Table Pass (Plan B) — TR/TD + colspan + absolute bbox

This document records the “Plan B” table extraction pipeline implemented in this repo.

Goal: extract **table-internal structure** (rows/cells) without TeX-side `tabular` macro hooking that can perturb alignment/rule drawing.

The result is a LuaLaTeX-only pass that emits `*.lpsb-table.json`, similar in spirit to the existing MathML pass (`lpsb-luamath` → `*.lpsb-math.json`).

---

## Why a LuaLaTeX pass?

TeX alignment environments are extremely sensitive to injected tokens. Hooking `tabular` internals (`\@tabularcr`, `\@arraycr`, `\everycr`, etc.) from the **structure pass** is risky and can cause visual artifacts (e.g. extra/dangling rules) or even `\noalign` errors.

The Plan B approach:

- **Structure pass** (`lpsb.sty`): emits semantic containers (`Table-*`, `Caption-*`, headings, etc.) without touching `tabular` internals.
- **LuaLaTeX table pass** (`lpsb-luatable.sty` + `lpsb-table.lua`): observes packed alignment cells via LuaTeX callbacks and emits TR/TD with `colspan` and absolute coordinates.
- **Merge** (`merge_lpsb.py`): injects TR/TD under matching `Table-*` containers in the structure event stream.

---

## Files added / modified

- **`lpsb-luatable.sty`**
  - LuaLaTeX-only package.
  - Emits row baseline anchors using `zref-savepos` (requires 2 passes).
  - Triggers row breaks in a safe `\noalign{...}` position.
  - Hooks:
    - `tabular` begin/end
    - `tabularx` begin/end (added because many papers use `tabularx`)
- **`lpsb-table.lua`**
  - Lua module used by `lpsb-luatable`.
  - Registers `hpack_filter` callback to collect cell content per row.
  - Buffers a whole table in memory, then emits JSON at table end.
  - Implements:
    - **colspan inference** (robust, row-cardinality based)
    - **absolute bbox computation** using row baselines + inferred col widths + row height/depth
- **`merge_lpsb.py`**
  - Extended to optionally merge `*.lpsb-table.json` into structure events by matching `Table-*` ids.

---

## Output: `*.lpsb-table.json`

The Lua table pass writes a JSON array containing:

- `{"id":"Table-N","role":"Table","event":"start","cols":<ncols>,"page":<page>}`
- `TR` events: `Table-N-TRr`
- `TD` events: `Table-N-TRr-TDc`

Each `TD` **start** includes:

- **`row`**, **`col`**, **`colspan`**
- **`text`** (best-effort; concatenated glyphs in traversal order)
- **`page`**
- **`x0,y0,x1,y1`** (absolute coordinates in **sp**, same unit family as `zref-savepos`)
- **`w,h,d`** (sp)

---

## colspan inference (current algorithm)

Problem: the raw Lua callback sees only “cells that have text”, and width signals can vary by row (some rows are fixed-width, some are natural).

Robust MVP algorithm used:

1. Let `ncols` = max number of captured cells across all rows in this table.
2. For each row with `k` captured cells:
   - start with all spans = 1
   - distribute remaining spans `ncols - k` to the **widest cells** in that row
   - assign final `(col, colspan)` left-to-right

This matches typical `\multicolumn` usage reliably for common grid tables.

---

## Absolute bbox / page coordinates

The pass uses **row baseline anchors** from `zref-savepos`:

- At table start, record row 1 baseline anchor:
  - label: `lpsbtable-<table_id>-r1`
- At each row break (`\\`), increment row counter and record:
  - label: `lpsbtable-<table_id>-r<row>`

Then `lpsb-table.lua` computes:

- Column widths (`col_widths`) from full rows (rows with exactly `ncols` captured cells).
- Row height/depth (`row_heights`) from max `(h,d)` among cells in that row.
- TD bbox:
  - `x0` = row baseline x + sum of prior col widths
  - `x1` = `x0 + sum(col_widths[col .. col+colspan-1])`
  - `y0,y1` derived from baseline `y` plus/minus `(h,d)`

### IMPORTANT: requires 2 LuaLaTeX passes

`zref-savepos` positions are resolved through the `.aux` mechanism. The first run writes anchors; the second run reads back real positions.

So: run LuaLaTeX **at least twice** for stable `x0/y0/x1/y1`.

---

## How to run (single file)

In your TeX source (LuaLaTeX pass only):

```tex
\usepackage{lpsb}          % to get Table-* ids aligned with structure pass
\usepackage{lpsb-luatable} % table pass
```

Compile twice:

```bash
lualatex -interaction=nonstopmode main.tex
lualatex -interaction=nonstopmode main.tex
```

Outputs:

- `main.lpsb-table.json`

Then merge into structure log:

```bash
python3 merge_lpsb.py main.lpsb.json main.lpsb-math.json main.merged.json main.lpsb-table.json
```

Or let `merge_lpsb.py` auto-detect the `.lpsb-table.json` by basename if present.

---

## How to run (repo test)

The repo includes:

- `test/test_table_complex_luatable.tex`

This produces:

- `test/test_table_complex_luatable.lpsb.json`
- `test/test_table_complex_luatable.lpsb-table.json`

Run LuaLaTeX twice (required), then merge and build a tree.

---

## Known limitations (current)

- **Text extraction**: glyph traversal is a heuristic; kerning/ligatures can affect output. We can upgrade to node-based sorting by `(top,x)` later.
- **Row/col detection**: only captures cells that contain glyphs; “empty cells” are invisible to the current capture. This affects col width inference in pathological tables.
- **Rowspan**: not implemented yet.
- **Exotic tables**: heavy macro packages, rotated content, nested alignments, or graphical overlays can confuse callbacks.

---

## Design notes / safety

- This pass intentionally limits TeX-side patching to a LuaLaTeX-only package (`lpsb-luatable.sty`).
- All row delimiter calls are inside `\noalign{...}` to preserve alignment legality.
- The structure pass (`lpsb.sty`) stays conservative to avoid any rendering regressions.


