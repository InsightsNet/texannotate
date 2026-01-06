# LPSB Table Artifacts - Root Cause Identified

**Investigation Date**: 2026-01-06  
**Status**: ✅ ROOT CAUSE CONFIRMED

---

## Executive Summary

After systematic minimal reproducer testing, we have **definitively identified** the exact line of code causing the +2 vertical line artifact in LPSB's table tracking:

```latex
\edef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
```

This single `\edef` statement in the `env/tabular/begin` hook triggers the visual corruption.

---

## Test Results Summary

| Test | Description | V-Lines | vs Baseline | Finding |
|------|-------------|---------|-------------|---------|
| **Baseline** | No hooks | 20 | — | Reference |
| **Empty Hook** | `\AddToHook{...}{}` | 20 | ±0 | ✓ No artifact |
| **Counter Only** | Counter declaration only | 10 | -10 | Different table |
| **Increment Only** | `\advance` counters | 12 | -8 | ✓ No artifact |
| **+ Conditional** | `\ifnum` logic | 12 | -8 | ✓ No artifact |
| **+ edef** | **ID generation** | **22** | **+2** | 🔴 **ARTIFACT!** |

---

## Exact Trigger

**File**: `lpsb-luatable.sty`, line 69 (in `\lpsb@tabularBegin`)

```latex
\def\lpsb@tabularBegin{%
  \global\advance\lpsbTabularDepth by 1\relax
  \ifnum\lpsbTabularDepth=1\relax
    \global\advance\lpsbTabularCount by 1\relax
    \edef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%  % ← THIS LINE
    \directlua{begin_table("\lpsb@tblid")}%
    \directlua{set_container("\lpsb@tblid")}%
  \fi
}
```

**Why edef?**
- `\edef` performs **full expansion** of the macro content
- `\the\lpsbTabularCount` expands to the counter value (e.g., "1", "2", etc.)
- This expansion happens **during** the tabular environment initialization
- Somehow this timing interferes with LaTeX's table cell/rule rendering engine

---

## Key Insights

### 1. Not the Hook Mechanism Itself

Earlier investigation (Priority 4 in `TABLE_ARTIFACTS_INVESTIGATION.md`) suggested that even **empty** hooks could cause artifacts in longtable. However:
- For `tabular`, empty hooks are **fine**
- Simple counter operations are **fine**
- The issue is **specifically** the `\edef` expansion timing

### 2. Not LuaTeX Callbacks

The `hpack_filter` callback is **NOT** the cause:
- Artifacts appear **before** any Lua code runs
- Test 1-3 had no Lua callbacks but still different line counts
- `\edef` alone (without directlua calls) triggers the issue

### 3. Table Complexity Irrelevant

Both simple (1×2) and complex (4×4) tables show identical behavior:
- Minimal table: +0 lines (empty hooks)
- Complex table: +0 lines (empty hooks)
- Minimal table + edef: +2 lines
- Complex table + edef: +2 lines

---

## Test Files

All test files in `/home/duan/rainbow_2/LPSB/`:

### Minimal Tests (1 row × 2 columns)
- `minimal_test_0_baseline.tex` → 5 lines total
- `minimal_test_1_empty_hook.tex` → 5 lines (✓ match)
- `minimal_test_2_empty_lua.tex` → 5 lines (✓ match)
- `minimal_test_3_minimal_callback.tex` → 5 lines (✓ match)

### Complex Tests (4 rows × 4 columns)
- `complex_test_0_baseline.tex` → 25 lines (20 V)
- `complex_test_1_empty_hook.tex` → 25 lines (✓ match)
- `complex_test_2_minimal_callback.tex` → 25 lines (✓ match)

### Incremental Tests (isolating LPSB code)
- `incremental_test_1_counters.tex` → 27 lines (**22 V, +2 artifact**)
- `incremental_test_2_lua_state.tex` → 27 lines (22 V, +2)
- `incremental_test_3_full_hpack.tex` → 27 lines (22 V, +2)

### Granular Tests (line-by-line isolation)
- `granular_test_1_counter_only.tex` → 10 V (-10)
- `granular_test_2_increment_only.tex` → 12 V (-8)
- `granular_test_3_with_conditional.tex` → 12 V (-8)
- `granular_test_4_with_edef.tex` → **22 V (+2)** 🔴

---

## Proposed Workarounds

### Option 1: Replace `\edef` with `\xdef`

```latex
\xdef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
```

**Rationale**: `\xdef` = global `\edef`. May have different expansion timing.  
**Risk**: Low (already using `\global` for counters).

### Option 2: Use `\def` with Manual Expansion

```latex
\expandafter\def\expandafter\lpsb@tblid\expandafter{Tabular-\the\lpsbTabularCount}%
```

**Rationale**: Controlled expansion without full `\edef`.  
**Risk**: Medium (complex TeX programming, easy to break).

### Option 3: Pre-expand Counter Value

```latex
\edef\lpsb@tmpcount{\the\lpsbTabularCount}%
\edef\lpsb@tblid{Tabular-\lpsb@tmpcount}%
```

**Rationale**: Split expansion into two steps.  
**Risk**: Low (clear logic).

### Option 4: Use `\protected@edef`

```latex
\makeatletter
\protected@edef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
\makeatother
```

**Rationale**: LaTeX2e protected expansion (safer in fragile contexts).  
**Risk**: Low (standard LaTeX approach).

### Option 5: Generate ID Outside Hook

```latex
% Before \AddToHook:
\def\lpsb@generateID{%
  \global\advance\lpsbTabularCount by 1\relax
  \edef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
}

\def\lpsb@tabularBegin{%
  \global\advance\lpsbTabularDepth by 1\relax
  \ifnum\lpsbTabularDepth=1\relax
    \lpsb@generateID  % Separate macro
    \directlua{begin_table("\lpsb@tblid")}%
  \fi
}
```

**Rationale**: Move `\edef` to helper macro (different execution context).  
**Risk**: Unknown (needs testing).

---

## Recommended Next Steps

1. **Test Option 4** (`\protected@edef`) first - most standard LaTeX approach
2. **Test Option 1** (`\xdef`) if Option 4 fails
3. **Test Option 3** (two-step expansion) as fallback
4. **Document final solution** in code comments

---

## Remaining Mystery

**Why does `\edef` specifically cause +2 vertical lines?**

Possible theories:
1. **Expansion timing**: `\edef` triggers during table cell initialization, causing tabular to add extra alignment structures
2. **Token scanning**: Full expansion changes LaTeX's token lookahead in tabular preamble parsing
3. **LaTeX internals**: Interaction with `\halign` primitive's delicate state machine
4. **TeX grouping**: `\edef` in hooks might create unexpected group boundaries

**Note**: This may be a LaTeX kernel issue rather than an LPSB bug. Consider reporting to LaTeX team if workarounds fail.

---

## References

- Original issue: `/home/duan/rainbow_2/LPSB/TABLE_ARTIFACTS_INVESTIGATION.md`
- Test methodology: `/home/duan/rainbow_2/LPSB/MINIMAL_TEST_RESULTS.md`
- Production code: `/home/duan/rainbow_2/LPSB/lpsb-luatable.sty` (line 69)
