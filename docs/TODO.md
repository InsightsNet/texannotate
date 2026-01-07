# LPSB TODO List

## 环境/命令支持状态

| 类别 | 环境/命令 | 状态 | 备注 |
|------|-----------|------|------|
| **数学** | `equation`, `align`, `gather`, `multline`, `eqnarray`, `displaymath`, `flalign` | ✅ | 完整 amsmath 支持 |
| **化学** | `reaction`, `reactions`, `scheme`, `\ce{}`, `\chemfig{}` | ✅ | 环境+命令 Hook |
| **乐谱** | `lilypond`, `music`, `abc`, `guitar` | ✅ | 使用 AddToHook |
| **物理单位** | `\SI{}`, `\si{}` (siunitx) | ✅ | 命令 Hook |
| **语言学** | `exe`, `gb4e`, `lingexample` | ✅ | linguex/gb4e/expex |
| **代码** | `lstlisting`, `verbatim`, `minted`, `algorithm`, `algorithmic` | ✅ | 使用 AddToHook |
| **表格** | `tabular`, `tabbing`, `longtable`, `tabularx` | ⚠️ | 使用 PDF-side 提取 |
| **图形** | `tikzpicture`, `pgfpicture`, `forest` | ✅ | 混合方案 |
| **电路** | `circuitikz` | ✅ | TikZ-based |
| **甘特图** | `ganttchart` (pgfgantt) | ✅ | 图表类 |
| **棋谱** | `chessboard`, `xskakgame` | ✅ | 游戏类 |
| **费曼图** | `feynman` (tikz-feynman) | ✅ | 物理类 |
| **列表** | `itemize`, `enumerate`, `description` | ✅ | 完整 LI 支持 |
| **多列** | `multicols` | ✅ | 使用 AddToHook |
| **浮动** | `figure`, `figure*`, `table`, `table*`, `subfigure`, `wrapfigure` | ✅ | 完整支持 |
| **定理类** | `theorem`, `lemma`, `proof`, `definition`, `corollary`, `proposition`, `remark`, `example` | ✅ | 使用 AddToHook |
| **Beamer** | `frame`, `block`, `alertblock`, `exampleblock`, `columns`, `column` | ✅ | 幻灯片 |
| **参考** | `thebibliography`, `\bibitem` | ✅ | 完整支持 |
| **索引** | `theglossary`, `theindex` | ✅ | 术语/索引 |
| **框架** | `minipage`, `verbatim`, `quote`, `quotation`, `center` | ✅ | 基本支持 |
| **TODO** | `inlinetodo` (todonotes) | ✅ | 注释类 |

### 图例

- ❌ 未实现
- ⚠️ 部分支持
- ✅ 已完成

---

## 遗留问题

1. **longtable**: AddToHook 会导致视觉伪影，已禁用
2. **tabular 内部**: 不追踪 TR/TD，使用 pdfplumber PDF-side 提取

---

## 表格处理策略

参见 `docs/table_cells.md` - 推荐使用 PDF-side 提取 (`extract_cells.py`)。
