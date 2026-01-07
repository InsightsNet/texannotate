# Post-Mortem: Table Rendering Artifacts in LaTeX Instrumentation

**Date**: 2026-01-06  
**Status**: Resolved  
**Severity**: High (Visual Corruption)

## 1. Executive Summary

During the development of the LPSB table extraction module (`lpsb-luatable`), we encountered a critical issue where instrumenting LaTeX table environments caused visual artifacts in the compiled PDF. Specifically, hooking `tabular` and `longtable` environments resulted in **extra vertical lines** and **phantom rows**.

After exhaustive testing (40+ minimal reproducers), we identified the root cause: LaTeX's `\AddToHook{env/tabular/begin}` mechanism interacts poorly with macro expansion timing (`\edef`) inside alignment preambles.

The solution involved abandoning `\AddToHook` in favor of **direct command patching** (redefining `\tabular`/`\endtabular`), which completely eliminated the artifacts while preserving full instrumentation capabilities.

## 2. Problem Description

### Symptoms

1.  **tabular**: 2 extra vertical lines appeared at the left edge of every table.
    -   Baseline: 20 vertical lines
    -   Instrumented: 22 vertical lines (+2 artifact)
2.  **longtable**: "Ghost rows" appeared, with partial borders manifested where no content existed.

### Impact

-   **Visual Integrity**: The artifacts made the generated PDFs unsuitable for use as ground truth.
-   **Extraction Data**: While JSON data was correct, the visual corruption compromised trust in the system.

## 3. Root Cause Analysis

### Methodology

We employed a systematic A/B testing approach using minimal reproducers to isolate the specific line of code responsible.

| Test Case | Configuration | Result |
|-----------|---------------|--------|
| Baseline | No hooks | 20 lines (Reference) |
| Empty Hook | `\AddToHook{...}{}` | 20 lines (No artifact) |
| Counter Ops | `\global\advance...` | 12 lines (Expected change) |
| **ID Gen** | **`\edef\id{...}`** | **22 lines (+2 Artifact)** |

### The Trigger

The issue was pinpointed to a single line in `lpsb-luatable.sty` within the `tabular` begin hook:

```latex
\edef\lpsb@tblid{Tabular-\the\lpsbTabularCount}%
```

**Technical Explanation**:
`\edef` performs full expansion. When executed inside the `tabular` environment hook (which runs effectively inside the alignment preamble construction), this expansion timing interferes with LaTeX's delicate table cell/rule rendering engine, specifically the `\halign` primitive's state machine.

It was determined that **any** `\edef` inside `\AddToHook{env/tabular/begin}` triggers this specific artifact, regardless of the macro content.

## 4. Failed Workarounds

We attempted several workarounds within the `\AddToHook` paradigm, all of which failed:

1.  **`\xdef`**: Global expansion (Failed)
2.  **`\protected@edef`**: Robust LaTeX expansion (Failed)
3.  **Manual Expansion**: `\expandafter` chains (Failed)
4.  **External Generation**: Generating ID before the environment (Failed, as hook scope is local)

## 5. Solution: Direct Command Patching

The definitive solution was to bypass the `\AddToHook` mechanism entirely for table environments and use traditional command patching.

### Implementation

We wrap the standard `tabular` and `longtable` commands to inject our instrumentation logic safely *before* and *after* the original command execution.

#### tabular

```latex
\let\lpsb@orig@tabular\tabular
\renewcommand{\tabular}[2][]{%
    % [Instrumentation Logic Here]
    \lpsb@orig@tabular[#1]{#2}%
}
\def\endtabular{%
    \lpsb@orig@endtabular
    % [Cleanup Logic Here]
}
```

#### longtable

Similarly, `longtable` is patched using `\AtBeginDocument` to ensure the package is loaded, replacing `\longtable` and `\endlongtable`.

## 6. Verification

The fix was verified against a suite of production test cases:

| Test Case | Visual Result | JSON Output | Status |
|-----------|---------------|-------------|--------|
| **Simple Tables** | 0 Extra Lines | Correct | ✅ PASS |
| **Nested Tables** | 0 Extra Lines | Correct | ✅ PASS |
| **Sidewaystable** | 0 Extra Lines | Correct | ✅ PASS |
| **Longtable** (Multi-page) | 0 Extra Lines | Correct | ✅ PASS |

## 7. Conclusion

Direct command patching proved to be the only robust method for instrumenting LaTeX alignment environments without introducing visual artifacts. This approach has been adopted as the standard for LPSB's table extraction module.
