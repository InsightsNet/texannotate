# LPSB TODO

## Phase 1 - Current Implementation

- [x] Two-stage compilation (pdfLaTeX Gold + LuaLaTeX enrichment)
- [x] Formula position tracking (zsavepos in pdfLaTeX)
- [x] Inline formatting position tracking (Strong, Em, Link)
- [x] Dynamic TeX Live version selection
- [x] Batch processing with parallel workers
- [x] merge_lpsb.py for combining structure + math JSON
- [x] enrich_positions.py for coordinate enrichment

## Phase 2 - Cross-line Element Handling

- [x] PDFplumber word-level bbox extraction
- [x] `refine_inline_bboxes()` for splitting multi-line elements into fragments
- [x] Width/height calculation from start/end zsavepos

## Phase 3 - PDF Marked Content (Planned)

> **Goal**: Write LPSB IDs directly into PDF content stream as Marked Content sequences.
> This provides a more reliable bridge between PDF and JSON than coordinate matching.

### Implementation Plan

1. **LuaTeX Integration** (lpsb-math.lua, lpsb.sty LuaTeX branch)
   ```lua
   -- Before content:
   pdf.literal("/LPSB." .. id .. " BDC")  -- Begin Designated Marked Content
   
   -- After content:
   pdf.literal("EMC")  -- End Marked Content
   ```

2. **Elements to Mark**
   - [ ] Math/Formula environments (`Sec-N-Math-M`)
   - [ ] Sections/Headings (`H-N`)
   - [ ] Lists/Items (`List-N`, `LI-N`)
   - [ ] Figures/Tables (`Figure-N`, `Table-N`)
   - [ ] Inline formatting (`Strong-N`, `Em-N`, `Link-N`)

3. **PDF Parsing Tool** (new script: `extract_mcid.py`)
   - Parse PDF content stream for `/LPSB.*` BDC markers
   - Extract glyph bboxes within each marked region
   - Output: `{id: "Sec-1-Math-2", glyphs: [{char, bbox}, ...]}`

4. **Advantages**
   - No coordinate matching errors
   - Works even if layout differs between pdfLaTeX and LuaLaTeX
   - Industry-standard PDF structure (similar to Tagged PDF)

5. **Limitations**
   - Only works in LuaLaTeX stage (not pdfLaTeX Gold)
   - Fallback to coordinate matching for pdfLaTeX elements

### Dependencies
- pypdf or pdfminer.six for PDF parsing
- No additional LaTeX packages required (uses raw pdf.literal())

## Phase 4 - Future Enhancements

- [ ] PDF/UA Tagged PDF output (requires modern TeX Live with tagpdf)
- [ ] HTML output generation from JSON + PDF
- [ ] Integration with document viewers (e.g., SumatraPDF with structure tree)

## TeX Live Compatibility Notes

### Minimum Requirement: **TeX Live 2020 (2020-10-01 kernel)**

| TeX Live | Status | Notes |
|----------|--------|-------|
| TL2023/2024 | ✅ Full | |
| TL2021/2022 | ✅ Full | |
| TL2020 (Oct+) | ✅ Full | |
| TL2020 (pre-Oct) | ⚠️ Partial | `\AddToHook` may be missing |
| TL2019 and earlier | ❌ Needs fallback | Requires conditional code |

### Key Dependencies

| Feature | Requires | Fallback Needed |
|---------|----------|-----------------|
| `\AddToHook` | LaTeX 2020-10-01+ | Use etoolbox `\AtBeginEnvironment` |
| `\zsavepos` | zref package | All modern TL |
| `\AtBeginEnvironment` | etoolbox | TL2010+ |
| `\everymath`/`\everydisplay` | TeX primitive | All versions |

### To Support TL2019 and Earlier

```latex
\@ifundefined{AddToHook}{%
    % Fallback for old LaTeX kernel
    \AtBeginEnvironment{...}{...}
}{%
    % Modern LaTeX kernel
    \AddToHook{env/.../begin}{...}
}
```

## Missing TeX Live Journal Packages

### Issue

Batch compilation revealed **~27 papers (3%)** failing due to missing journal class files. These are available in arXiv's environment but missing from our Docker images.

### Missing Packages

| Package | Class File | Count | TL2020 Status | Purpose |
|---------|------------|-------|---------------|---------|
| `aa` | `aa.cls` | 3 | ❌ Not installed | Astronomy & Astrophysics journal |
| `iopart` | `iopart.cls` | 6 | ❌ Not installed | IOP Publishing journals |
| `svmult` | `svmult.cls` | 3 | ❌ Not installed | Springer multi-author books |
| `PoS` | `PoS.cls` | 3 | ❌ Not installed | Proceedings of Science |
| `aastex` | `aastex.cls` | 9 | ⚠️ Installed as `aastex631.cls` | American Astronomical Society |

### Solution

Add to `docker/Dockerfile.tl2020`:

```dockerfile
# Install missing journal packages
RUN tlmgr install aa iopart svmult PoS && \
    # Create version-agnostic symlinks for aastex
    ln -s aastex631.cls /usr/local/texlive/2020/texmf-dist/tex/latex/aastex/aastex.cls && \
    mktexlsr
```

**Priority**: Medium (affects 3% of papers, specific to astronomy/physics domains)

## Known Compatibility Issues

### Document Class/Package Conflicts

| Class/Package | Error Type | Status | Notes |
|---------------|------------|--------|-------|
| `WileyNJD-v2` + `NJDnatbib` | `\lpsbWriteEntry` extra } | ⚠️ Unsolved | JSON parameter parsing fails with complex titles. Needs JSON generation rewrite. |
| `xy` (XY-pic) + authblk | Missing number at `\maketitle` | ✅ Fixed | Inline formatting hooks now check `lpsbActive` flag to skip preamble |
| `cas-sc` (Elsevier) | xkeyval mismatch | ⚠️ TL version | Works on TL2023+, fails on TL2020 (source/TL version mismatch, not LPSB bug) |
| `amsrefs` | Input stack overflow | ⚠️ Skip | Skip cite hook when amsrefs loaded (see pitfalls below) |
| `achemso` | (none - uses natbib) | ✅ Compatible | Internally loads natbib, LPSB natbib hook works |
| `revtex4*` | (none - uses natbib) | ✅ Compatible | Internally loads natbib, LPSB natbib hook works |

### Cite Hook Implementation Pitfalls

#### 1. natbib 简单 hook 导致 Citation `[` multiply defined

**问题**: 使用 `\renewcommand{\cite}[2][]{}` 格式 hook `\cite` 命令，导致 natbib 内部参数解析混乱。

**现象**: 
```
Package natbib Warning: Citation `[' multiply defined.
```
引用在 PDF 中显示为 `?`。

**原因**: natbib 的 `\cite` 支持两个可选参数 `\cite[pre][post]{keys}`，简单的 `[2][]` hook 破坏了这个结构。

**解决方案**: Hook natbib 的内部函数 `\@citex[#1][#2]#3` 而不是 `\cite`：
```latex
\let\lpsb@orig@citex\@citex
\def\@citex[#1][#2]#3{%
    \lpsbWriteEntry{...#3...}%
    \lpsb@orig@citex[#1][#2]{#3}%
}
```

#### 2. Inline formatting hooks (textbf/textit/emph) 在 preamble 触发

**问题**: `\textbf`/`\textit`/`\emph` hooks 在 `\begin{document}` 之前被调用。

**现象**: 
```
! Missing number, treated as zero.
<to be read again> \write
```
错误发生在 `\maketitle` 处，文档使用 authblk 包。

**原因**: authblk 在 preamble 阶段设置作者信息时调用 `\textit`，此时 `\thepage` 等命令还未正确定义。

**解决方案**: 添加 `\iflpsbActive` 检查，只在 `\begin{document}` 之后执行 hook 逻辑：
```latex
\renewcommand{\textit}[1]{%
    \iflpsbActive
        % LPSB logging code
    \else
        \lpsb@origtextit{#1}%
    \fi
}
```
并在 `\AtBeginDocument` 中设置 `\lpsbActivetrue`。

#### 3. amsrefs `\citedest` hook 导致无限递归

**问题**: 尝试 hook amsrefs 的 `\citedest{#1}` 函数导致 input stack overflow。

**现象**:
```
! TeX capacity exceeded, sorry [input stack size=5000].
```

**调试过程**:
1. 最小测试成功（amsrefs + hyperref + xy）
2. 生产文档失败（即使用相同的包组合）
3. 问题不是单个包，而是复杂宏定义环境下的递归

**原因**: amsrefs 内部的 citation 处理涉及多层展开和递归调用。在简单文档中 hook 工作正常，但在包含大量宏定义的生产文档中触发无限递归。

**决策**: 
- **放弃 amsrefs 兼容 hook**，改为跳过 cite hook
- 这是稳定性优先的决定：amsrefs 文档可以正常编译，但不会有 Cite 条目记录

#### 4. hyperref PDF 书签生成冲突

**问题**: hyperref 生成 PDF 书签时会展开章节标题，与 LPSB 命令冲突。

**现象**: 各种奇怪的展开错误。

**解决方案**: 使用 `\pdfstringdefDisableCommands` 在 PDF 字符串生成期间禁用 LPSB 命令：
```latex
\AtBeginDocument{%
    \@ifpackageloaded{hyperref}{%
        \pdfstringdefDisableCommands{%
            \let\lpsbWriteEntry\@gobble
            \let\lpsbProbe\@gobbletwo
            \let\zsavepos\@gobble
        }%
    }{}%
}
```

### Source Issues (Cannot Fix)

| paper_id | Issue | Reason |
|----------|-------|--------|
| 2001.00257 | File not found | Source missing `tikz_figures/nonexisting-doubly-attached.tex` |
| 2401.00096 | File not found | Source missing `p.tex` |
| WITHDRAWN papers | Empty/placeholder | arXiv `%auto-ignore` placeholder files |

