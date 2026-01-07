# Table Extraction: Current Capabilities

**Date**: 2026-01-07
**Module**: `lpsb-luatable`

## Overview

The LPSB table extraction module provides a robust mechanism for extracting table data from compile-time LaTeX sources using LuaLaTeX. This document outlines the confirmed capabilities, known limitations, and best practices.

## Capabilities Matrix

| Feature | Status | Notes |
|---------|--------|-------|
| **Environment Support** | | |
| `tabular` | ✅ Supported | Full instrumentation |
| `tabularx` | ✅ Supported | Via `tabular` patch |
| `longtable` | ✅ Supported | Direct patch, multi-page correct |
| `sidewaystable` | ✅ Supported | Geometry and rotation handled |
| **Data Extraction** | | |
| Text Content | ✅ Robust | Extracts full cell text |
| Bounding Boxes | ✅ Precise | PDF coordinates (x0, y0, x1, y1) |
| Page Numbers | ✅ Accurate | Handles multi-page tables |
| Table IDs | ✅ Consistent | Matches structure pass IDs |
| **Visual Fidelity** | | |
| Rendering | ✅ Perfect | No artifacts or extra lines |

## Known Limitations

### Row Structure

Currently, the LuaLaTeX pass extracts cells as a flat stream tied to the table container.

-   **Problem**: Explicit row grouping is not strictly enforced in the JSON output (all cells may list `row: 1`).
-   **Cause**: Hooking row delimiters (`\\`, `\cr`) in LaTeX is extremely fragile and prone to visual artifacts.
-   **Workaround**: Use PDF-side extraction (pdfplumber) if strict row/column structural analysis is required. The source-side pass is best for **content** and **location**.

### Complex Merges

-   **Colspan/Rowspan**: Automatic detection of `\multicolumn` and `\multirow` is currently limited in the source-side pass.
-   **Recommendation**: Combine with PDF-side analysis for grid reconstruction.

## JSON Output Specification

The `lpsb-table.json` output provides a sequence of table events:

```json
{
  "id": "Table-1-TR1-TD1",
  "role": "TD",
  "event": "start",
  "text": "Cell Content",
  "page": 1,
  "x0": 100.5,
  "y0": 200.0,
  "x1": 150.5,
  "y1": 212.0
}
```

## Production Readiness

The module is considered **Production Ready** for:
-   Full-text search indexing
-   Table localization (bounding box generation)
-   Accessibility tagging (PDF/UA)

For applications requiring perfect grid reconstruction (e.g., converting to Excel), we recommend a hybrid approach using LPSB for content/location and a PDF vision model for structure.
