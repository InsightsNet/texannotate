# 批量编译 arXiv 论文脚本使用说明

## 概述

这个工具集用于批量编译 `data/download` 目录中的所有 arXiv 论文，并生成详细的错误分析报告。

## 脚本说明

### 1. `script/batch_compile_all.sh` - 批量编译脚本（推荐）

**功能**：
- 自动提取所有 `.tar.gz` 文件
- 为每个论文注入所有 LPSB 包：
  - `lpsb.sty` - 结构提取（文档结构、标题、段落等）
  - `lpsb-luamath.sty` + `lpsb-math.lua` - 数学公式提取（包括 MathML）
  - `lpsb-luatable.sty` + `lpsb-table.lua` - 表格提取（TR/TD 结构）
- **自动识别 TeX Live 版本**：
  - 新论文：读取 `00README.json`（arXiv 2024 年夏天更新后的格式）
  - 旧论文（无 `00README.json`）：优先读取 `biblatex` `.bbl` 头部的 `bbl format version` 推断 TeX Live 年份（例如 `3.1 -> TL2022`）
- **两阶段编译（gold pipeline）**：
  - A) `pdflatex`：生成金标准 PDF + `*.lpsb.json`（最兼容）
  - B) `lualatex`：生成 `*.lpsb-math.json`（含 MathML）+ `*.lpsb-table.json`
  - `merge_lpsb.py` 合并：生成 `*.lpsb.merged.json`
- 处理参考文献（biber/bibtex）
- 生成详细的编译日志和报告

**TeX Live 版本选择**：
- 脚本会自动读取每个论文的 `00README.json` 文件（如果存在）
- 根据 `texlive_version` 字段选择合适的 Docker 镜像：
  - `2023` → 使用 `lpsb-texlive:TL2023-historic` 或 `texlive/texlive:TL2023-historic`
  - `2024` → 使用 `lpsb-texlive:TL2024-historic`（如果存在）或 `latest`
  - `2025+` → 使用 `latest`（应该是最新版本）
  - 无 `00README.json` → 使用 `latest`（旧格式或自定义源）

**使用方法**：
```bash
cd /home/duan/rainbow_2/LPSB
bash script/batch_compile_all.sh
```

**输出**：
- 编译结果目录：`compile_results/<paper_name>/`
- 详细报告：`compile_results/compile_report_YYYYMMDD_HHMMSS.txt`
- 摘要报告：`compile_results/summary_YYYYMMDD_HHMMSS.txt`

**日志中的版本信息**：
- 脚本会在每篇论文的输出中打印一行：
  - `TeX Live selected: <year> (image: <docker-tag>)`

**环境变量**（可选）：
```bash
export LPSB_DATA_DIR="/path/to/download"      # 输入目录（默认：data/download）
export LPSB_OUT_DIR="/path/to/output"          # 输出目录（默认：compile_results）
export LPSB_INJECTOR="/path/to/lpsb.sty"       # LPSB 包路径（默认：./lpsb.sty）
```

### 2. `analyze_compile_errors.py` - 错误分析脚本（可选）

**功能**：
- 分析编译日志，提取错误模式
- 分类常见错误（缺失文件、未定义命令等）
- 生成易读的错误报告

**使用方法**：
```bash
# 分析编译结果并输出到控制台
python3 analyze_compile_errors.py compile_results/

# 分析并保存到文件
python3 analyze_compile_errors.py compile_results/ error_report.txt
```

**报告内容**：
- 编译成功率统计
- 最常见的缺失文件列表
- 最常见的未定义命令列表
- 失败论文的详细错误信息
- 成功论文的统计信息（包括 PDF、结构 JSON、数学 JSON、表格 JSON）

## 完整工作流程

```bash
# 1. 编译所有论文
./batch_compile_all.sh

# 2. 查看摘要
cat compile_results/summary_*.txt

# 3. 生成详细错误分析
python3 analyze_compile_errors.py compile_results/ error_analysis.txt

# 4. 查看详细报告
cat error_analysis.txt
```

## 报告示例

### 摘要报告（summary_*.txt）
```
==========================================
COMPILATION SUMMARY
==========================================
Total papers: 7
Successful: 5
Failed: 2
Warnings: 3
No main .tex: 0

Success rate: 71.4%
```

### 详细报告（compile_report_*.txt）
每个论文包含：
- 编译状态（成功/失败）
- PDF 和 JSON 生成情况
- 错误和警告详情
- 编译返回码

### 错误分析报告（error_analysis.txt）
- 错误分类统计
- 最常见的缺失文件
- 最常见的未定义命令
- 失败论文的详细错误

## 关于 00README.json

**背景**：arXiv 在 2024 年夏天更新了编译系统，之后提交的论文包含一个 `00README.json` 文件，记录了编译所需的 TeX Live 版本和编译器信息。

**文件格式示例**：
```json
{
   "sources" : [
      {
         "usage" : "toplevel",
         "filename" : "paper.tex"
      }
   ],
   "spec_version" : 1,
   "texlive_version" : "2025",
   "process" : {
      "compiler" : "pdflatex"
   }
}
```

**脚本处理**：
- 脚本会自动检测并读取 `00README.json`
- 根据 `texlive_version` 选择对应的 Docker 镜像
- 这确保了版本兼容性，特别是对于 `biblatex` 等版本敏感的包

**如果没有 00README.json**：
- 可能是 2024 年夏天之前的旧论文
- 脚本会使用 `latest` 镜像（通常是 TeX Live 2024/2025）

## 常见问题

### Q: 如何只编译特定的论文？
A: 将其他 `.tar.gz` 文件移出 `data/download` 目录，只保留要编译的论文。

### Q: 编译失败怎么办？
A: 查看对应论文目录下的 `compile3.log` 文件，或运行错误分析脚本获取分类报告。

### Q: 如何重新编译？
A: 删除 `compile_results` 目录或特定论文的子目录，然后重新运行脚本。

### Q: Docker 镜像不存在？
A: 脚本会自动回退到 `texlive/texlive:latest`。如果需要特定版本，请先构建 Docker 镜像：
```bash
# 最新版本（推荐）
docker build -f docker/Dockerfile.latest -t lpsb-texlive:latest docker

# TeX Live 2023（用于旧论文）
docker build -f docker/Dockerfile.tl2023 -t lpsb-texlive:TL2023-historic docker

# TeX Live 2024（可选）
docker build -f docker/Dockerfile.tl2024 -t lpsb-texlive:TL2024-historic docker
```

### Q: 为什么需要不同版本的 TeX Live？
A: 不同版本的 TeX Live 可能有不同的包版本和格式。特别是 `biblatex` 的 `.bbl` 文件格式在不同版本间可能不兼容。使用正确的版本可以避免编译错误。

## 注意事项

1. **磁盘空间**：确保有足够的磁盘空间（每个论文可能需要 50-200MB）
2. **编译时间**：编译所有论文可能需要较长时间（取决于论文数量和复杂度）
3. **Docker**：确保 Docker 正在运行且可以访问
4. **日志文件**：每个论文的编译日志保存在 `compile_results/<paper>/compile*.log`

