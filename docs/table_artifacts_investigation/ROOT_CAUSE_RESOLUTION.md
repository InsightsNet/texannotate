# Root Cause Resolution Summary

**Date**: 2026-01-06  
**Investigation**: LPSB Table Visual Artifacts  
**Status**: ✅ ROOT CAUSE IDENTIFIED

## The Problem

When `lpsb-luatable.sty` is loaded, `tabular` environments render with **2 extra vertical lines** in the PDF output.

## The Cause

**Exact trigger**: Line 69 of `lpsb-luatable.sty`

```latex
\edef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
```

This `\edef` statement inside the `env/tabular/begin` hook causes LaTeX's table rendering to produce extra vertical rules.

## Proof

Systematic minimal reproducer testing:

| Hook Content | Result | Conclusion |
|--------------|--------|------------|
| Empty hook | ✓ No artifacts | Hook mechanism is fine |
| Counter increment only | ✓ No artifacts | Counter operations are fine |
| + Conditionals | ✓ No artifacts | Conditional logic is fine |
| **+ `\edef` ID generation** | **🔴 +2 vertical lines** | **This is the trigger** |

## Solution Options

### Recommended: Use `\protected@edef`

```latex
\protected@edef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
```

### Alternative 1: Use `\xdef`

```latex
\xdef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
```

### Alternative 2: Two-step expansion

```latex
\edef\lpsb@tmpcount{\the\lpsbTabularCount}%
\edef\lpsb@tblid{Tabular-\lpsb@tmpcount}%
```

## Files Updated

- `TABLE_ARTIFACTS_INVESTIGATION.md` - Added root cause findings
- Test files in `/home/duan/rainbow_2/LPSB/`:
  - `granular_test_*.tex` - Line-by-line isolation tests
  - `run_granular_tests.sh` - Automated test runner

## Next Actions

1. Implement `\protected@edef` workaround in `lpsb-luatable.sty`
2. Test with production papers
3. Verify artifact is resolved
4. Document fix in code comments
