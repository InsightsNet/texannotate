#!/usr/bin/env python3
"""
LPSB Extraction Quality Evaluation Script

评估每篇论文、每个模板的提取质量：
1. Title - 论文标题能否正确提取
2. Section Titles (H1/H2/H3) - 章节标题能否提取，内容是否像标题
3. Math - 数学公式能否提取
4. Caption - 图表标题能否提取

Usage:
    python3 evaluate_extraction.py <output_dir> [--verbose] [--report report.json]
    python3 evaluate_extraction.py test_output/wacv_2304.00022 --verbose

    # 批量评估所有模板
    python3 evaluate_extraction.py test_output/ --batch --report evaluation_report.json
"""

import argparse
import json
import re
import sys
from dataclasses import dataclass, field, asdict
from pathlib import Path
from typing import Dict, List, Optional, Tuple, Any
from collections import defaultdict

try:
    import pdfplumber
    HAS_PDFPLUMBER = True
except ImportError:
    HAS_PDFPLUMBER = False
    print("Warning: pdfplumber not installed. Text extraction will be limited.", file=sys.stderr)

try:
    import fitz  # PyMuPDF
    HAS_PYMUPDF = True
except ImportError:
    HAS_PYMUPDF = False


# ============================================================================
# Data Classes
# ============================================================================

@dataclass
class ElementEval:
    """单个元素的评估结果"""
    elem_id: int
    elem_type: str
    page: int
    text: str = ""
    is_valid: bool = True
    issues: List[str] = field(default_factory=list)


@dataclass
class CategoryEval:
    """某一类元素的评估结果"""
    category: str
    total_count: int = 0
    extracted_count: int = 0
    valid_count: int = 0
    issues: List[str] = field(default_factory=list)
    elements: List[ElementEval] = field(default_factory=list)

    @property
    def extraction_rate(self) -> float:
        return self.extracted_count / max(1, self.total_count)

    @property
    def validity_rate(self) -> float:
        return self.valid_count / max(1, self.extracted_count)


@dataclass
class FloatEval:
    """Figure/Table 与 Caption 匹配评估"""
    float_id: int
    float_type: str  # "Figure" or "Table"
    page: int
    has_caption: bool = False
    caption_id: Optional[int] = None
    caption_text: str = ""
    issues: List[str] = field(default_factory=list)


@dataclass
class FloatCaptionEval:
    """Figure/Table 和 Caption 匹配的整体评估"""
    category: str = "FloatCaption"
    total_figures: int = 0
    total_tables: int = 0
    figures_with_caption: int = 0
    tables_with_caption: int = 0
    orphan_captions: int = 0  # 没有匹配到 Figure/Table 的 Caption
    issues: List[str] = field(default_factory=list)
    floats: List[FloatEval] = field(default_factory=list)

    @property
    def figure_match_rate(self) -> float:
        return self.figures_with_caption / max(1, self.total_figures)

    @property
    def table_match_rate(self) -> float:
        return self.tables_with_caption / max(1, self.total_tables)

    @property
    def overall_match_rate(self) -> float:
        total = self.total_figures + self.total_tables
        matched = self.figures_with_caption + self.tables_with_caption
        return matched / max(1, total)


@dataclass
class PaperEval:
    """单篇论文的评估结果"""
    paper_id: str
    template: str
    pdf_path: str
    total_elements: int = 0
    total_pages: int = 0

    title: CategoryEval = field(default_factory=lambda: CategoryEval("Title"))
    sections: CategoryEval = field(default_factory=lambda: CategoryEval("Sections"))
    math: CategoryEval = field(default_factory=lambda: CategoryEval("Math"))
    captions: CategoryEval = field(default_factory=lambda: CategoryEval("Captions"))
    float_caption: FloatCaptionEval = field(default_factory=FloatCaptionEval)

    overall_score: float = 0.0
    issues: List[str] = field(default_factory=list)


# ============================================================================
# Text Extraction from PDF
# ============================================================================

def extract_text_by_mcid(pdf_path: Path) -> Dict[Tuple[int, int], str]:
    """
    从PDF中按MCID提取文本。
    返回 {(page, mcid): text} 的映射。
    """
    mcid_texts: Dict[Tuple[int, int], str] = {}

    if not HAS_PDFPLUMBER:
        return mcid_texts

    try:
        with pdfplumber.open(pdf_path) as pdf:
            for page_num, page in enumerate(pdf.pages, 1):
                # 按MCID分组字符
                mcid_chars: Dict[int, List] = defaultdict(list)

                for char in page.chars:
                    mcid = char.get("mcid")
                    if mcid is not None:
                        mcid_chars[mcid].append(char)

                # 组装每个MCID的文本
                for mcid, chars in mcid_chars.items():
                    # 按位置排序
                    sorted_chars = sorted(chars, key=lambda c: (c.get("top", 0), c.get("x0", 0)))
                    text = "".join(c.get("text", "") for c in sorted_chars)
                    mcid_texts[(page_num, mcid)] = text.strip()

    except Exception as e:
        print(f"Warning: Failed to extract text from {pdf_path}: {e}", file=sys.stderr)

    return mcid_texts


def get_element_text(element: Dict, mcid_texts: Dict[Tuple[int, int], str]) -> str:
    """获取元素的完整文本（合并所有MCID）"""
    texts = []
    for mcid_entry in element.get("mcids", []):
        mcid = mcid_entry.get("mcid")
        page = mcid_entry.get("page")
        if mcid is not None and page is not None:
            text = mcid_texts.get((page, mcid), "")
            if text:
                texts.append(text)
    return " ".join(texts)


# ============================================================================
# Validation Functions
# ============================================================================

def is_valid_title(text: str) -> Tuple[bool, List[str]]:
    """
    验证标题文本是否有效。

    有效标题应该：
    - 非空
    - 长度合理 (3-300字符)
    - 不是纯数字/符号
    - 包含有意义的单词
    """
    issues = []

    if not text or not text.strip():
        issues.append("Title is empty")
        return False, issues

    text = text.strip()

    if len(text) < 3:
        issues.append(f"Title too short: '{text}'")
        return False, issues

    if len(text) > 500:
        issues.append(f"Title too long: {len(text)} chars")
        return False, issues

    # 检查是否只有数字和符号
    if re.match(r'^[\d\s\.\-\:\;\,\(\)\[\]]+$', text):
        issues.append(f"Title contains only numbers/symbols: '{text}'")
        return False, issues

    # 检查是否包含至少一个字母单词
    if not re.search(r'[a-zA-Z\u4e00-\u9fff]{2,}', text):
        issues.append(f"Title lacks meaningful words: '{text}'")
        return False, issues

    return True, issues


def is_valid_section_title(text: str, level: str) -> Tuple[bool, List[str]]:
    """
    验证章节标题是否有效。

    有效的章节标题应该：
    - 非空
    - 长度合理 (不太长)
    - 看起来像标题（首字母大写、不是完整句子等）
    - 不包含明显的正文内容
    """
    issues = []

    if not text or not text.strip():
        issues.append(f"{level} section title is empty")
        return False, issues

    text = text.strip()

    # 移除章节编号
    text_clean = re.sub(r'^[\d\.]+\s*', '', text)
    text_clean = re.sub(r'^[IVXLCDM]+[\.\s]+', '', text_clean, flags=re.IGNORECASE)
    text_clean = re.sub(r'^[A-Z][\.\s]+', '', text_clean)

    if not text_clean:
        # 只有编号也算有效（如 "1." 或 "A."）
        return True, issues

    # 标题不应该太长（通常不超过100字符）
    if len(text_clean) > 150:
        issues.append(f"{level} title too long ({len(text_clean)} chars): '{text_clean[:50]}...'")
        return False, issues

    # 标题不应该以小写字母开头（除非是特殊词如 "e.g.", "i.e."）
    if text_clean and text_clean[0].islower():
        if not re.match(r'^(e\.g\.|i\.e\.|etc\.|vs\.|cf\.)', text_clean):
            issues.append(f"{level} title starts with lowercase: '{text_clean[:30]}'")
            # 这是一个警告，不一定是错误

    # 标题不应该是完整的句子（以句号结尾，且包含动词）
    if text_clean.endswith('.') and len(text_clean) > 50:
        # 检查是否像是一个句子
        sentence_patterns = [
            r'\b(is|are|was|were|have|has|had|will|would|can|could)\b',
            r'\b(we|they|it|this|that)\s+(show|present|propose|introduce|describe)',
        ]
        for pattern in sentence_patterns:
            if re.search(pattern, text_clean, re.IGNORECASE):
                issues.append(f"{level} title looks like a sentence: '{text_clean[:50]}...'")
                return False, issues

    # 检查是否只有数字和符号
    if re.match(r'^[\d\s\.\-\:\;\,\(\)\[\]]+$', text_clean):
        issues.append(f"{level} title contains only numbers/symbols: '{text}'")
        return False, issues

    return True, issues


def is_valid_math(text: str, element: Dict, mcid_texts: Dict[Tuple[int, int], str]) -> Tuple[bool, List[str]]:
    """
    验证数学公式是否有效。

    检查：
    1. 元素是否有MCID
    2. MCID是否能在PDF中找到对应内容
    3. 内容是否非空（数学公式可能是特殊字符）
    """
    issues = []

    mcids = element.get("mcids", [])
    if not mcids:
        issues.append("Math element has no MCIDs")
        return False, issues

    # 检查是否至少有一个MCID在PDF中有内容
    has_content = False
    for mcid_entry in mcids:
        mcid = mcid_entry.get("mcid")
        page = mcid_entry.get("page")
        if mcid is not None and page is not None:
            content = mcid_texts.get((page, mcid), "")
            if content:
                has_content = True
                break

    # 即使没有可提取的文本（因为是图形/特殊字符），只要有MCID就算有效
    # 但如果有文本，我们可以做额外验证
    if text:
        # 检查是否只有空白
        if not text.strip():
            issues.append("Math element has only whitespace")
            # 这不一定是错误，数学公式可能是图形

    return True, issues


def is_valid_caption(text: str, caption_type: str = "Figure") -> Tuple[bool, List[str]]:
    """
    验证图表标题是否有效。

    有效的caption应该：
    - 非空
    - 包含 "Figure" 或 "Table" 等关键词（或编号）
    - 有描述性文本
    """
    issues = []

    if not text or not text.strip():
        issues.append(f"{caption_type} caption is empty")
        return False, issues

    text = text.strip()

    # 检查是否包含图表标识
    caption_patterns = [
        r'(?i)^(figure|fig\.?|table|tab\.?|algorithm|alg\.?)\s*[\d\.\:]+',
        r'^[\d]+[\.\:]\s+',  # 纯数字编号
    ]

    has_label = any(re.search(p, text) for p in caption_patterns)

    # 即使没有标签，只要有足够长的描述也可以
    if not has_label and len(text) < 10:
        issues.append(f"Caption too short and lacks label: '{text}'")
        return False, issues

    return True, issues


# ============================================================================
# Main Evaluation Logic
# ============================================================================

def find_elements_by_type(elements: List[Dict], types: List[str]) -> List[Dict]:
    """按类型筛选元素"""
    return [e for e in elements if e.get("type") in types]


def evaluate_float_caption_matching(
    all_elements: List[Dict],
    figure_elements: List[Dict],
    table_elements: List[Dict],
    caption_elements: List[Dict],
    mcid_texts: Dict[Tuple[int, int], str]
) -> FloatCaptionEval:
    """
    评估 Figure/Table 与 Caption 的匹配情况。

    检查：
    1. 每个 Figure 是否有对应的 Caption
    2. 每个 Table 是否有对应的 Caption
    3. Caption 文本是否包含正确的标识 (Figure X / Table X)
    4. 是否有孤立的 Caption（没有匹配的 Figure/Table）
    """
    result = FloatCaptionEval()
    result.total_figures = len(figure_elements)
    result.total_tables = len(table_elements)

    # 建立元素ID到元素的映射
    elem_by_id = {e.get("id"): e for e in all_elements}

    # 建立 Caption 的 parent_id 映射
    caption_by_parent: Dict[int, Dict] = {}
    for cap in caption_elements:
        parent_id = cap.get("parent_id")
        if parent_id is not None:
            caption_by_parent[parent_id] = cap

    # 用于追踪已匹配的 Caption
    matched_caption_ids = set()

    # 检查每个 Figure
    for fig in figure_elements:
        fig_id = fig.get("id", 0)
        fig_page = fig.get("start_page", 0)

        float_eval = FloatEval(
            float_id=fig_id,
            float_type="Figure",
            page=fig_page
        )

        # 方式1: 检查是否有 Caption 的 parent_id 指向这个 Figure
        if fig_id in caption_by_parent:
            cap = caption_by_parent[fig_id]
            cap_text = get_element_text(cap, mcid_texts)
            float_eval.has_caption = True
            float_eval.caption_id = cap.get("id")
            float_eval.caption_text = cap_text[:100] if cap_text else ""
            matched_caption_ids.add(cap.get("id"))

            # 验证 Caption 文本是否包含 "Figure" 标识
            if cap_text and not re.search(r'(?i)(figure|fig\.?)\s*\d', cap_text):
                float_eval.issues.append(f"Caption doesn't contain 'Figure X': '{cap_text[:50]}'")

            result.figures_with_caption += 1
        else:
            # 方式2: 检查同页面是否有未匹配的 FigureCaption
            found = False
            for cap in caption_elements:
                if cap.get("id") in matched_caption_ids:
                    continue
                cap_page = cap.get("start_page", 0)
                cap_type = cap.get("type", "")
                cap_text = get_element_text(cap, mcid_texts)

                # 同页面且类型匹配或文本包含 Figure
                if cap_page == fig_page:
                    if cap_type == "FigureCaption" or re.search(r'(?i)(figure|fig\.?)\s*\d', cap_text):
                        float_eval.has_caption = True
                        float_eval.caption_id = cap.get("id")
                        float_eval.caption_text = cap_text[:100] if cap_text else ""
                        matched_caption_ids.add(cap.get("id"))
                        result.figures_with_caption += 1
                        found = True
                        break

            if not found:
                float_eval.issues.append("No caption found for this Figure")
                result.issues.append(f"Figure {fig_id} on page {fig_page} has no caption")

        result.floats.append(float_eval)

    # 检查每个 Table
    for tbl in table_elements:
        tbl_id = tbl.get("id", 0)
        tbl_page = tbl.get("start_page", 0)

        float_eval = FloatEval(
            float_id=tbl_id,
            float_type="Table",
            page=tbl_page
        )

        # 方式1: 检查是否有 Caption 的 parent_id 指向这个 Table
        if tbl_id in caption_by_parent:
            cap = caption_by_parent[tbl_id]
            cap_text = get_element_text(cap, mcid_texts)
            float_eval.has_caption = True
            float_eval.caption_id = cap.get("id")
            float_eval.caption_text = cap_text[:100] if cap_text else ""
            matched_caption_ids.add(cap.get("id"))

            # 验证 Caption 文本是否包含 "Table" 标识
            if cap_text and not re.search(r'(?i)(table|tab\.?)\s*\d', cap_text):
                float_eval.issues.append(f"Caption doesn't contain 'Table X': '{cap_text[:50]}'")

            result.tables_with_caption += 1
        else:
            # 方式2: 检查同页面是否有未匹配的 TableCaption
            found = False
            for cap in caption_elements:
                if cap.get("id") in matched_caption_ids:
                    continue
                cap_page = cap.get("start_page", 0)
                cap_type = cap.get("type", "")
                cap_text = get_element_text(cap, mcid_texts)

                if cap_page == tbl_page:
                    if cap_type == "TableCaption" or re.search(r'(?i)(table|tab\.?)\s*\d', cap_text):
                        float_eval.has_caption = True
                        float_eval.caption_id = cap.get("id")
                        float_eval.caption_text = cap_text[:100] if cap_text else ""
                        matched_caption_ids.add(cap.get("id"))
                        result.tables_with_caption += 1
                        found = True
                        break

            if not found:
                float_eval.issues.append("No caption found for this Table")
                result.issues.append(f"Table {tbl_id} on page {tbl_page} has no caption")

        result.floats.append(float_eval)

    # 统计孤立的 Caption
    for cap in caption_elements:
        if cap.get("id") not in matched_caption_ids:
            result.orphan_captions += 1
            cap_text = get_element_text(cap, mcid_texts)
            result.issues.append(f"Orphan caption (id={cap.get('id')}): '{cap_text[:50] if cap_text else '(empty)'}'")

    return result


def evaluate_paper(
    mcid_json_path: Path,
    pdf_path: Optional[Path] = None,
    verbose: bool = False
) -> PaperEval:
    """评估单篇论文的提取质量"""

    # 解析论文ID和模板
    paper_dir = mcid_json_path.parent
    paper_id = paper_dir.name
    template = paper_id.split("_")[0] if "_" in paper_id else "unknown"

    result = PaperEval(
        paper_id=paper_id,
        template=template,
        pdf_path=str(pdf_path) if pdf_path else ""
    )

    # 加载MCID JSON
    try:
        with open(mcid_json_path) as f:
            data = json.load(f)
    except Exception as e:
        result.issues.append(f"Failed to load JSON: {e}")
        return result

    elements = data.get("elements", [])
    summary = data.get("summary", {})

    result.total_elements = summary.get("total_elements", len(elements))
    result.total_pages = summary.get("total_pages", 0)

    # 提取PDF文本（如果有PDF）
    mcid_texts: Dict[Tuple[int, int], str] = {}
    if pdf_path and pdf_path.exists():
        mcid_texts = extract_text_by_mcid(pdf_path)
        if verbose:
            print(f"  Extracted text from {len(mcid_texts)} MCIDs")

    # ========== 1. 评估 Title ==========
    title_elements = find_elements_by_type(elements, ["Title", "H"])
    result.title.total_count = 1  # 每篇论文应该有一个标题
    result.title.extracted_count = len(title_elements)

    for elem in title_elements:
        text = get_element_text(elem, mcid_texts)
        is_valid, issues = is_valid_title(text)

        eval_elem = ElementEval(
            elem_id=elem.get("id", 0),
            elem_type=elem.get("type", ""),
            page=elem.get("start_page", 0),
            text=text[:100] if text else "",
            is_valid=is_valid,
            issues=issues
        )
        result.title.elements.append(eval_elem)

        if is_valid:
            result.title.valid_count += 1
        else:
            result.title.issues.extend(issues)

    if not title_elements:
        result.title.issues.append("No title element found")

    # ========== 2. 评估 Section Titles ==========
    section_types = ["H1", "H2", "H3"]
    section_elements = find_elements_by_type(elements, section_types)
    result.sections.total_count = len(section_elements)
    result.sections.extracted_count = len(section_elements)

    for elem in section_elements:
        text = get_element_text(elem, mcid_texts)
        level = elem.get("type", "H1")
        is_valid, issues = is_valid_section_title(text, level)

        eval_elem = ElementEval(
            elem_id=elem.get("id", 0),
            elem_type=level,
            page=elem.get("start_page", 0),
            text=text[:100] if text else "",
            is_valid=is_valid,
            issues=issues
        )
        result.sections.elements.append(eval_elem)

        if is_valid:
            result.sections.valid_count += 1
        else:
            result.sections.issues.extend(issues)

    if not section_elements:
        result.sections.issues.append("No section headings found")

    # ========== 3. 评估 Math ==========
    math_types = ["Formula", "InlineMath", "DisplayMath", "Equation"]
    math_elements = find_elements_by_type(elements, math_types)

    # 也检查atom类型的数学
    for elem in elements:
        if elem.get("is_atom") and elem.get("type") in ["InlineMath", "Math"]:
            if elem not in math_elements:
                math_elements.append(elem)

    result.math.total_count = len(math_elements)
    result.math.extracted_count = len(math_elements)

    for elem in math_elements:
        text = get_element_text(elem, mcid_texts)
        is_valid, issues = is_valid_math(text, elem, mcid_texts)

        eval_elem = ElementEval(
            elem_id=elem.get("id", 0),
            elem_type=elem.get("type", ""),
            page=elem.get("start_page", 0),
            text=text[:50] if text else "(math content)",
            is_valid=is_valid,
            issues=issues
        )
        result.math.elements.append(eval_elem)

        if is_valid:
            result.math.valid_count += 1
        else:
            result.math.issues.extend(issues)

    # ========== 4. 评估 Captions ==========
    caption_types = ["Caption", "FigureCaption", "TableCaption"]
    caption_elements = find_elements_by_type(elements, caption_types)

    # 也检查 Figure 和 Table 内部是否有 caption
    figure_elements = find_elements_by_type(elements, ["Figure"])
    table_elements = find_elements_by_type(elements, ["Table"])

    result.captions.total_count = len(caption_elements) + len(figure_elements) + len(table_elements)
    result.captions.extracted_count = len(caption_elements)

    for elem in caption_elements:
        text = get_element_text(elem, mcid_texts)
        is_valid, issues = is_valid_caption(text)

        eval_elem = ElementEval(
            elem_id=elem.get("id", 0),
            elem_type=elem.get("type", ""),
            page=elem.get("start_page", 0),
            text=text[:100] if text else "",
            is_valid=is_valid,
            issues=issues
        )
        result.captions.elements.append(eval_elem)

        if is_valid:
            result.captions.valid_count += 1
        else:
            result.captions.issues.extend(issues)

    # ========== 5. 评估 Figure/Table 与 Caption 的匹配 ==========
    result.float_caption = evaluate_float_caption_matching(
        elements, figure_elements, table_elements, caption_elements, mcid_texts
    )

    # ========== 计算总体得分 (0-100%) ==========
    # 各项权重: Title=20%, Sections=30%, Math=15%, Captions=15%, FloatMatch=20%
    score = 0.0

    # Title: 20%
    if result.title.extracted_count > 0:
        score += 0.20 * result.title.validity_rate
    # 没有提取到标题扣20分

    # Sections: 30%
    if result.sections.extracted_count > 0:
        score += 0.30 * result.sections.validity_rate
    # 没有提取到章节扣30分

    # Math: 15% (只要有提取就得满分，因为数学公式可能没有)
    if result.math.extracted_count > 0:
        score += 0.15
    else:
        score += 0.075  # 有些论文可能没有数学公式，给一半分

    # Captions: 15%
    if result.captions.extracted_count > 0:
        score += 0.15 * result.captions.validity_rate
    else:
        score += 0.075  # 有些论文可能没有图表

    # Float-Caption Matching: 20%
    if result.float_caption.total_figures + result.float_caption.total_tables > 0:
        score += 0.20 * result.float_caption.overall_match_rate
    else:
        score += 0.10  # 没有 Figure/Table 的论文

    result.overall_score = score

    return result


def find_pdf_for_json(json_path: Path) -> Optional[Path]:
    """查找与JSON对应的PDF文件"""
    parent = json_path.parent

    # 尝试找 *_tagged.pdf
    tagged_pdfs = list(parent.glob("*_tagged.pdf"))
    if tagged_pdfs:
        return tagged_pdfs[0]

    # 尝试找普通PDF
    pdfs = list(parent.glob("*.pdf"))
    if pdfs:
        return pdfs[0]

    return None


def evaluate_batch(
    output_dir: Path,
    verbose: bool = False
) -> List[PaperEval]:
    """批量评估目录下的所有论文"""
    results = []

    # 查找所有 mcid.json 文件
    json_files = list(output_dir.rglob("*.mcid.json"))

    if not json_files:
        print(f"No .mcid.json files found in {output_dir}")
        return results

    print(f"Found {len(json_files)} papers to evaluate")
    print("=" * 60)

    for json_path in sorted(json_files):
        paper_id = json_path.parent.name
        print(f"\nEvaluating: {paper_id}")

        pdf_path = find_pdf_for_json(json_path)
        result = evaluate_paper(json_path, pdf_path, verbose)
        results.append(result)

        # 打印简要结果
        print(f"  Title:    {result.title.valid_count}/{result.title.extracted_count} valid")
        print(f"  Sections: {result.sections.valid_count}/{result.sections.extracted_count} valid")
        print(f"  Math:     {result.math.valid_count}/{result.math.extracted_count} valid")
        print(f"  Captions: {result.captions.valid_count}/{result.captions.extracted_count} valid")
        fc = result.float_caption
        print(f"  Fig-Cap:  {fc.figures_with_caption}/{fc.total_figures} figures, {fc.tables_with_caption}/{fc.total_tables} tables matched")
        if fc.orphan_captions > 0:
            print(f"            {fc.orphan_captions} orphan captions")
        print(f"  Score:    {result.overall_score:.2%}")

        if result.issues:
            print(f"  Issues:   {', '.join(result.issues[:3])}")

    return results


def generate_summary_report(results: List[PaperEval]) -> Dict[str, Any]:
    """生成汇总报告"""
    if not results:
        return {"error": "No results to summarize"}

    # 按模板分组
    by_template: Dict[str, List[PaperEval]] = defaultdict(list)
    for r in results:
        by_template[r.template].append(r)

    summary = {
        "total_papers": len(results),
        "average_score": sum(r.overall_score for r in results) / len(results),
        "by_template": {},
        "by_category": {
            "title": {
                "total_extracted": sum(r.title.extracted_count for r in results),
                "total_valid": sum(r.title.valid_count for r in results),
            },
            "sections": {
                "total_extracted": sum(r.sections.extracted_count for r in results),
                "total_valid": sum(r.sections.valid_count for r in results),
            },
            "math": {
                "total_extracted": sum(r.math.extracted_count for r in results),
            },
            "captions": {
                "total_extracted": sum(r.captions.extracted_count for r in results),
                "total_valid": sum(r.captions.valid_count for r in results),
            },
        },
        "papers": [],
    }

    # 按模板统计
    for template, papers in sorted(by_template.items()):
        summary["by_template"][template] = {
            "count": len(papers),
            "average_score": sum(p.overall_score for p in papers) / len(papers),
            "title_valid_rate": sum(p.title.valid_count for p in papers) / max(1, sum(p.title.extracted_count for p in papers)),
            "section_valid_rate": sum(p.sections.valid_count for p in papers) / max(1, sum(p.sections.extracted_count for p in papers)),
        }

    # 每篇论文的详细结果
    for r in results:
        paper_summary = {
            "paper_id": r.paper_id,
            "template": r.template,
            "score": r.overall_score,
            "title": {
                "extracted": r.title.extracted_count,
                "valid": r.title.valid_count,
                "text": r.title.elements[0].text if r.title.elements else "",
                "issues": r.title.issues[:3],
            },
            "sections": {
                "extracted": r.sections.extracted_count,
                "valid": r.sections.valid_count,
                "issues": r.sections.issues[:5],
            },
            "math": {
                "extracted": r.math.extracted_count,
            },
            "captions": {
                "extracted": r.captions.extracted_count,
                "valid": r.captions.valid_count,
                "issues": r.captions.issues[:3],
            },
        }
        summary["papers"].append(paper_summary)

    return summary


def print_summary(summary: Dict[str, Any]):
    """打印汇总报告"""
    print("\n" + "=" * 60)
    print("EVALUATION SUMMARY")
    print("=" * 60)

    print(f"\nTotal Papers: {summary['total_papers']}")
    print(f"Average Score: {summary['average_score']:.2%}")

    print("\n--- By Category ---")
    cats = summary["by_category"]
    print(f"  Title:    {cats['title']['total_valid']}/{cats['title']['total_extracted']} valid")
    print(f"  Sections: {cats['sections']['total_valid']}/{cats['sections']['total_extracted']} valid")
    print(f"  Math:     {cats['math']['total_extracted']} extracted")
    print(f"  Captions: {cats['captions']['total_valid']}/{cats['captions']['total_extracted']} valid")

    print("\n--- By Template ---")
    for template, stats in sorted(summary["by_template"].items()):
        print(f"  {template:15} : {stats['count']:2} papers, score={stats['average_score']:.2%}, "
              f"title={stats['title_valid_rate']:.0%}, sections={stats['section_valid_rate']:.0%}")

    # 找出问题最多的论文
    print("\n--- Papers with Issues ---")
    problem_papers = [p for p in summary["papers"] if p["score"] < 0.8]
    for p in sorted(problem_papers, key=lambda x: x["score"])[:10]:
        print(f"  {p['paper_id']}: score={p['score']:.2%}")
        if p["title"]["issues"]:
            print(f"    - Title: {p['title']['issues'][0]}")
        if p["sections"]["issues"]:
            print(f"    - Sections: {p['sections']['issues'][0]}")


# ============================================================================
# CLI Entry Point
# ============================================================================

def main():
    parser = argparse.ArgumentParser(
        description="Evaluate LPSB extraction quality",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  # 评估单个论文
  python3 evaluate_extraction.py test_output/wacv_2304.00022 --verbose

  # 批量评估
  python3 evaluate_extraction.py test_output/ --batch --report report.json

  # 评估所有模板测试
  python3 evaluate_extraction.py test_output/ --batch
        """
    )
    parser.add_argument("path", help="Path to output directory or .mcid.json file")
    parser.add_argument("--batch", action="store_true", help="Batch evaluate all papers in directory")
    parser.add_argument("--verbose", "-v", action="store_true", help="Verbose output")
    parser.add_argument("--report", "-r", help="Output JSON report path")

    args = parser.parse_args()

    path = Path(args.path)

    if not path.exists():
        print(f"Error: Path not found: {path}", file=sys.stderr)
        sys.exit(1)

    if args.batch or path.is_dir():
        # 批量评估
        results = evaluate_batch(path, verbose=args.verbose)

        if results:
            summary = generate_summary_report(results)
            print_summary(summary)

            if args.report:
                report_path = Path(args.report)
                with open(report_path, "w") as f:
                    json.dump(summary, f, indent=2, ensure_ascii=False)
                print(f"\n✓ Report saved to: {report_path}")
    else:
        # 单个文件评估
        if path.suffix == ".json":
            json_path = path
        else:
            json_files = list(path.glob("*.mcid.json"))
            if not json_files:
                print(f"No .mcid.json found in {path}", file=sys.stderr)
                sys.exit(1)
            json_path = json_files[0]

        pdf_path = find_pdf_for_json(json_path)
        result = evaluate_paper(json_path, pdf_path, verbose=args.verbose)

        # 打印详细结果
        print(f"\nPaper: {result.paper_id}")
        print(f"Template: {result.template}")
        print(f"Pages: {result.total_pages}")
        print(f"Elements: {result.total_elements}")
        print(f"Overall Score: {result.overall_score:.2%}")

        print("\n--- Title ---")
        print(f"  Extracted: {result.title.extracted_count}")
        print(f"  Valid: {result.title.valid_count}")
        for elem in result.title.elements:
            print(f"  Text: '{elem.text}'")
            if elem.issues:
                print(f"  Issues: {elem.issues}")

        print("\n--- Sections ---")
        print(f"  Extracted: {result.sections.extracted_count}")
        print(f"  Valid: {result.sections.valid_count}")
        if args.verbose:
            for elem in result.sections.elements[:10]:
                status = "✓" if elem.is_valid else "✗"
                print(f"  {status} [{elem.elem_type}] '{elem.text}'")
                if elem.issues:
                    print(f"      Issues: {elem.issues}")
        if result.sections.issues:
            print(f"  Issues: {result.sections.issues[:5]}")

        print("\n--- Math ---")
        print(f"  Extracted: {result.math.extracted_count}")

        print("\n--- Captions ---")
        print(f"  Extracted: {result.captions.extracted_count}")
        print(f"  Valid: {result.captions.valid_count}")
        if args.verbose:
            for elem in result.captions.elements[:5]:
                status = "✓" if elem.is_valid else "✗"
                print(f"  {status} '{elem.text}'")
        if result.captions.issues:
            print(f"  Issues: {result.captions.issues[:3]}")

        if args.report:
            report = {
                "paper_id": result.paper_id,
                "template": result.template,
                "score": result.overall_score,
                "title": asdict(result.title),
                "sections": asdict(result.sections),
                "math": asdict(result.math),
                "captions": asdict(result.captions),
            }
            with open(args.report, "w") as f:
                json.dump(report, f, indent=2, ensure_ascii=False)
            print(f"\n✓ Report saved to: {args.report}")


if __name__ == "__main__":
    main()
