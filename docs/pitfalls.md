# Pitfalls / 已踩过的坑（提交前备忘）

这份文档记录本次在 LPSB（Rainbow 2.0）批量编译与 MathML/表格相关工作中踩过的坑、根因和修复方式，便于后续回归与移植。

---

## 1) **不要用 LuaLaTeX 直接当“最终 PDF”**

- **症状**：LuaLaTeX 因兼容性问题（例如 `inputenc`/`\DeclareUnicodeCharacter`）会报错但仍吐出一个“残废 PDF”，出现类似首页只有 `FF0C, 1` 的幽灵内容。
- **根因**：LuaLaTeX 会忽略 `inputenc`，某些 pdfTeX-era 源码依赖 `\DeclareUnicodeCharacter` 之类命令，导致未定义/漏字/杂散 token。
- **修复策略（推荐）**：采用 **gold pipeline**：
  - **Stage A（金标准）**：`pdflatex` 负责最终 PDF + `*.lpsb.json`（结构）
  - **Stage B（enrich）**：`lualatex` 只负责 `*.lpsb-math.json`（MathML）和 `*.lpsb-table.json`
  - **merge**：用 `script/merge_lpsb.py` 把 MathML/table events 注入回 gold 结构流

---

## 2) **arXiv 2024 夏之后：`00README.json` 才是 TeX Live 真相**

- **症状**：同一论文在不同 TL 年份出现 `.bbl`/包版本不兼容导致的失败或差异。
- **根因**：arXiv 新系统会在源码中附带 `00README.json`，记录 `texlive_version` 与 `compiler`。
- **修复**：`script/batch_compile_all.sh` 读取 `00README.json` 并据此选镜像。

---

## 3) **旧论文（无 `00README.json`）：必须看 `.bbl` 的 format version**

- **症状**：旧论文在 `latest`（例如 TL2025）下 `biblatex` 相关报错，甚至直接编译失败。
- **根因**：许多旧 arXiv 源码附带预生成的 `biblatex` `.bbl`，该文件头部写明 **bbl format version**，对 TeX Live/biblatex 版本非常敏感。
- **修复**：在 `script/batch_compile_all.sh` 中：
  - 如果无 `00README.json` 且存在 `*.bbl`，读取头部：
    - `% $ biblatex bbl format version X.Y $`
  - 以 **保守映射**推断 TL 年份并选用 historic image（示例：`3.1 -> TL2022`）
  - 日志里必须打印：
    - `TeX Live selected: <year> (image: <docker-tag>)`

---

## 4) **TL2022/TL2023 也要能产 MathML：historic 镜像必须补 `luamml`**

- **症状**：`*.lpsb-math.json` 里 `mathml: ""` 全为空；`merge.log` 显示 `MathML present in 0`。
- **根因**：
  - `lpsb-math.lua` 依赖 `luamml`（`require("luamml-convert")`、`require("luamml-xmlwriter")`）。
  - historic TL 镜像默认不带/或不完整。
  - 关键路径问题：historic 镜像的 `TEXMFLOCAL` 是 `/usr/local/texlive/texmf-local`，不是 `/usr/local/texlive/<year>/texmf-local`。
- **修复**：
  - 提供 `docker/Dockerfile.tl2022`、`docker/Dockerfile.tl2023`：
    - 从 `texlive/texlive:latest` 抽取 `luamml` runtime
    - 安装到 **`/usr/local/texlive/texmf-local`**
    - 并把 `.lua` 模块也复制到 `tex/luatex/luamml/`（否则 LuaTeX `require` 可能找不到）
  - 构建命令：
    - `docker build -f docker/Dockerfile.tl2022 -t lpsb-texlive:TL2022-historic docker`
    - `docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker`

---

## 5) `.lpsb.json` 必须是合法 JSON：避免把宏写进去

- **症状**：`script/merge_lpsb.py` 的 fault-tolerant loader 大量跳行，最后 merged 只有极少事件。
- **根因**：`lpsb.sty` 在某些场景下把 `\@M` 这种宏写到了 JSON 字段里（例如 `"level": \@M`），导致 JSON 非法。
- **修复**：在 `lpsb.sty` 里把 level 写成数值：`"level": \number#2`。

---

## 6) `script/merge_lpsb.py` 路径别写错

- **症状**：merge 阶段报 `python3: can't open file .../merge_lpsb.py`，导致 `Merged JSON: NOT GENERATED`。
- **根因**：脚本/文件移动后路径没同步（现在 merge 脚本在 `script/merge_lpsb.py`）。
- **修复**：`script/batch_compile_all.sh` 用 `LPSB_MERGE_PY`（默认指向 `script/merge_lpsb.py`）。

---

## 7) stage 目录复制不要递归把自己拷进自己

- **症状**：出现 `_pdflatex/_pdflatex/...` 或 `_lualatex/_lualatex/...` 这种套娃目录，甚至报 `cp: cannot copy a directory ... into itself`。
- **根因**：stage 目录建在 workdir 下，使用 `cp -a "$workdir/." "$workdir/_pdflatex/"` 会把 stage 自己也拷进去。
- **修复**：用 `tar` + exclude 方式复制（排除 `./_pdflatex`、`./_lualatex`）。

---

## 8) `grep -c` + `|| echo 0` 的坑：会打印两个 0

- **症状**：输出里出现 `0\n0 tables` 这种奇怪结果。
- **根因**：`grep -c` 在 0 match 时仍输出 `0`，但 exit code=1，后面的 `|| echo 0` 又追加一个 0。
- **修复**：用 `|| true`，再做字符串清理/默认值：
  - `count="$( (grep -c ... || true) | tr -d '\n' )"; count="${count:-0}"`

---

## 9) 表格支持现状（仍然不完整）

- **现实**：
  - 直接 hook `tabular`/`longtable` internals 很脆，容易出现视觉伪影。
  - `longtable` 相关 hooks 默认禁用（优先保证 PDF 正确）。
  - Lua table pass 目前是 best-effort（bbox/colspan 推断），并不作为 authoritative truth。
- **建议**：生产/评测优先走 **PDF-side** 表格抽取（`extract_cells.py` / `pdfplumber`），得到稳定 TD/row/col/span。

---

## 10) 提交前自检建议（最小）

- **镜像**：
  - `docker image inspect lpsb-texlive:latest >/dev/null`
  - `docker image inspect lpsb-texlive:TL2022-historic >/dev/null`
  - `docker image inspect lpsb-texlive:TL2023-historic >/dev/null`
- **单篇验证**：
  - 选一篇旧论文（无 `00README.json` 且带 `.bbl`）：
    - 日志必须出现 `TeX Live selected: 2022 ...`
    - `merge.log` 中 `MathML present in` 应 > 0（如果包含公式）


