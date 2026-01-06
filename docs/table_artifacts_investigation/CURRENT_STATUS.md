# LPSB Table Extraction - Current Status

**Date**: 2026-01-06  
**Version**: Post-Direct-Patching Implementation

---

## ✅ What Works Perfectly

### Visual Rendering
- **tabular** - No artifacts (0 extra lines) ✅
- **longtable** - No artifacts ✅  
- **sidewaystable** - No artifacts ✅
- **Nested tables** - Supported ✅
- **Multiple sequential tables** - Supported ✅

### Basic Extraction
- **Text content** - All cell text extracted ✅
- **Bounding boxes** - x0, y0, x1, y1 coordinates ✅
- **Table structure** - Table/TR/TD hierarchy ✅
- **Cell count** - Accurate ✅
- **Page numbers** - Correct ✅

### Tested Packages
- ✅ **multirow** - Compiles without errors
- ✅ **makecell** - Compiles without errors
- ✅ Compatible with standard table packages

---

## ⚠️ Known Limitations

### Row Detection Issue
**Problem**: All cells currently assigned to row=1

**Impact**:
- `\multicolumn` colspan not detected (requires proper row grouping)
- `\multirow` rowspan not detected
- Cannot distinguish different rows in JSON output

**Root Cause**: 
- Row tracking requires `M.row_break()` to be called
- No LaTeX-side calls to this function exist
- Adding hooks for `\\` would reintroduce visual artifacts
- Lua-only detection attempted but unsuccessful (timing issues)

**Status**: Accepted limitation for current version

### Not Supported Features
- ❌ **Colspan detection** (`\multicolumn`)
- ❌ **Rowspan detection** (`\multirow`)  
- ❌ **Row-level grouping** in JSON output

---

## 📊 JSON Output Example

### What You Get
```json
{
  "id": "Table-1-TR1-TD1",
  "role": "TD",
  "event": "start",
  "row": 1,          // ⚠️ Always 1 (limitation)
  "col": 1,
  "colspan": 1,      // ⚠️ Always 1 (limitation)
  "text": "Cell content",
  "w": 42.5,
  "h": 8.3,
  "d": 2.1,
  "page": 1,
  "x0": 120,
  "y0": 600,
  "x1": 162,
  "y1": 610
}
```

### What Still Works Well
- Text extraction for downstream NLP
- Bounding boxes for visual analysis
- Table detection and counting
- Page-level table locations

---

## 🎯 Use Cases

### ✅ Suitable For
- Document parsing for text extraction
- Table localization in PDFs
- Cell-level text content analysis
- Bbox-based visual table reconstruction
- Counting tables and cells

### ❌ Not Suitable For
- Semantic table structure analysis (row/column relationships)
- Accurate multicolumn/multirow detection
- Row-aware table parsing
- Spreadsheet-like reconstruction

---

## 🔧 Implementation Details

### Modified Files
- `lpsb-luatable.sty` - Direct command patching (lines 157-245)
  - Tabular: Replaces `\AddToHook` 
  - Longtable: Added direct patching

### Code Added (Non-functional)
- `lpsb-table.lua` - Row detection attempts (lines 35, 411-413, 576-612)
  - `table_row_templates` variable
  - Per-table template logic
  - Status: Does not work, kept for future reference

---

## 📝 Future Work

### Option 1: Accept Current State
- Document limitations clearly
- Focus on use cases that don't need row structure
- Current extraction still valuable for many applications

### Option 2: Alternative Approach (Complex)
- Position-based row detection using savepos
- Analyze vertical spacing changes
- Track x-coordinate resets
- Significant implementation effort

### Option 3: Hybrid Solution (Risky)
- Minimal hooks only for row breaks
- Test if `\everycr` hook introduces artifacts
- Fallback to current if issues arise

**Current Decision**: Option 1 (Accept limitations)

---

## 📖 Documentation

### User-Facing
- ✅ Works: Text, bbox, table detection
- ⚠️ Limitation: Row grouping not available
- ❌ Not supported: colspan/rowspan detection

### Technical
- Problem: Row tracking requires explicit signaling
- Attempted: Lua-only automatic detection
- Result: Unsuccessful due to execution order
- Solution: Documented limitation

---

## Summary

**LPSB table extraction is production-ready for:**
- Text extraction from tables
- Visual table localization
- Basic structural information

**Not suitable for:**
- Semantic row/column analysis
- Advanced table structure extraction

**Visual rendering: Perfect (0 artifacts)**  
**Functional completeness: ~70% (missing row structure)**
