#!/usr/bin/env python3
"""PDF-derived cache helpers (MCID bboxes/positions/stats).

The cache is stored next to the PDF as: <stem>.mcid.cache.json
It is invalidated when the PDF mtime or size changes.
"""

from __future__ import annotations

import json
import hashlib
import os
from pathlib import Path
from typing import Dict, Tuple, Optional, Any

import pdfplumber

CACHE_VERSION = 1


def _cache_path(pdf_path: Path) -> Path:
    return pdf_path.with_suffix(".mcid.cache.json")


def _cache_dir(pdf_path: Path) -> Path:
    # Allow override for shared cache directory.
    env = os.environ.get("LPSB_PDF_CACHE_DIR", "").strip()
    if env:
        return Path(env)
    return pdf_path.parent / ".mcid_cache"


def _global_cache_path(pdf_path: Path, sha256: str) -> Path:
    return _cache_dir(pdf_path) / f"{sha256}.mcid.cache.json"


def _pdf_meta(pdf_path: Path) -> Tuple[int, int]:
    st = pdf_path.stat()
    return int(st.st_mtime), int(st.st_size)


def _hash_pdf(pdf_path: Path) -> str:
    h = hashlib.sha256()
    with open(pdf_path, "rb") as f:
        for chunk in iter(lambda: f.read(1024 * 1024), b""):
            h.update(chunk)
    return h.hexdigest()


def _load_cache(pdf_path: Path, sha256: Optional[str] = None) -> Optional[Dict[str, Any]]:
    cp = _cache_path(pdf_path)
    if not cp.exists():
        return None
    try:
        raw = json.loads(cp.read_text(errors="replace"))
    except Exception:
        return None
    if not isinstance(raw, dict):
        return None
    if int(raw.get("version", 0)) != CACHE_VERSION:
        return None
    try:
        mtime = int(raw.get("pdf_mtime", -1))
        size = int(raw.get("pdf_size", -1))
    except Exception:
        return None
    cur_mtime, cur_size = _pdf_meta(pdf_path)
    if mtime != cur_mtime or size != cur_size:
        # If the file is identical, allow reuse by content hash.
        sha = sha256 or _hash_pdf(pdf_path)
        if str(raw.get("pdf_sha256", "")) != sha:
            return None
    return raw


def _save_cache(pdf_path: Path, payload: Dict[str, Any]) -> None:
    cp = _cache_path(pdf_path)
    try:
        cp.write_text(json.dumps(payload, indent=2))
    except Exception:
        pass
    # Also write to shared cache dir keyed by content hash.
    try:
        sha = str(payload.get("pdf_sha256") or "")
        if sha:
            cd = _cache_dir(pdf_path)
            cd.mkdir(parents=True, exist_ok=True)
            _global_cache_path(pdf_path, sha).write_text(json.dumps(payload, indent=2))
    except Exception:
        pass


def _scan_pdf(pdf_path: Path, sha256: Optional[str] = None) -> Dict[str, Any]:
    """Scan PDF once and compute per-page MCID data."""
    mcid_bboxes: Dict[str, Dict[str, list]] = {}
    mcid_first_chars: Dict[str, Dict[str, list]] = {}
    mcid_char_stats: Dict[str, Dict[str, Dict[str, Any]]] = {}

    with pdfplumber.open(str(pdf_path)) as pdf:
        for page_idx, page in enumerate(pdf.pages):
            page_num = page_idx + 1
            by_mcid: Dict[int, list] = {}
            for c in page.chars or []:
                mcid = c.get("mcid")
                if mcid is None:
                    continue
                try:
                    mcid = int(mcid)
                except Exception:
                    continue
                by_mcid.setdefault(mcid, []).append(c)

            if not by_mcid:
                continue

            for mcid, chars in by_mcid.items():
                chars.sort(key=lambda c: (c.get("top", 0.0), c.get("x0", 0.0)))
                try:
                    x0 = min(float(c["x0"]) for c in chars)
                    y0 = min(float(c["top"]) for c in chars)
                    x1 = max(float(c["x1"]) for c in chars)
                    y1 = max(float(c["bottom"]) for c in chars)
                except Exception:
                    continue

                mcid_bboxes.setdefault(str(page_num), {})[str(mcid)] = [x0, y0, x1, y1]
                first = chars[0]
                mcid_first_chars.setdefault(str(page_num), {})[str(mcid)] = [
                    float(first["x0"]),
                    float(first["top"]),
                ]
                preview = "".join(c.get("text", "") for c in chars)[:40]
                mcid_char_stats.setdefault(str(page_num), {})[str(mcid)] = {
                    "count": len(chars),
                    "preview": preview.strip(),
                }

    mtime, size = _pdf_meta(pdf_path)
    return {
        "version": CACHE_VERSION,
        "pdf_mtime": mtime,
        "pdf_size": size,
        "pdf_sha256": sha256 or _hash_pdf(pdf_path),
        "mcid_bboxes": mcid_bboxes,
        "mcid_first_chars": mcid_first_chars,
        "mcid_char_stats": mcid_char_stats,
    }


def _load_or_build(pdf_path: Path) -> Dict[str, Any]:
    cached = _load_cache(pdf_path)
    if cached is not None:
        return cached
    sha = _hash_pdf(pdf_path)

    # Try shared cache by hash.
    gp = _global_cache_path(pdf_path, sha)
    if gp.exists():
        try:
            raw = json.loads(gp.read_text(errors="replace"))
            if isinstance(raw, dict) and int(raw.get("version", 0)) == CACHE_VERSION:
                # Update file meta and persist locally.
                mtime, size = _pdf_meta(pdf_path)
                raw["pdf_mtime"] = mtime
                raw["pdf_size"] = size
                raw["pdf_sha256"] = sha
                _save_cache(pdf_path, raw)
                return raw
        except Exception:
            pass

    data = _scan_pdf(pdf_path, sha256=sha)
    _save_cache(pdf_path, data)
    return data


def get_mcid_bboxes_by_mcid(pdf_path: Path) -> Dict[int, Dict[int, Tuple[float, float, float, float]]]:
    """Return {mcid: {page: (x0,y0,x1,y1)}} from cache or scan."""
    data = _load_or_build(pdf_path)
    out: Dict[int, Dict[int, Tuple[float, float, float, float]]] = {}
    for p_str, by_mcid in (data.get("mcid_bboxes") or {}).items():
        try:
            page = int(p_str)
        except Exception:
            continue
        for mcid_str, bb in (by_mcid or {}).items():
            try:
                mcid = int(mcid_str)
                x0, y0, x1, y1 = map(float, bb)
            except Exception:
                continue
            out.setdefault(mcid, {})[page] = (x0, y0, x1, y1)
    return out


def get_mcid_first_char_positions(pdf_path: Path) -> Dict[Tuple[int, int], Tuple[float, float]]:
    """Return {(page, mcid): (x, y)} from cache or scan."""
    data = _load_or_build(pdf_path)
    out: Dict[Tuple[int, int], Tuple[float, float]] = {}
    for p_str, by_mcid in (data.get("mcid_first_chars") or {}).items():
        try:
            page = int(p_str)
        except Exception:
            continue
        for mcid_str, pos in (by_mcid or {}).items():
            try:
                mcid = int(mcid_str)
                x, y = map(float, pos)
            except Exception:
                continue
            out[(page, mcid)] = (x, y)
    return out


def get_mcid_char_stats(pdf_path: Path) -> Dict[Tuple[int, int], Tuple[int, str]]:
    """Return {(page, mcid): (count, preview)} from cache or scan."""
    data = _load_or_build(pdf_path)
    out: Dict[Tuple[int, int], Tuple[int, str]] = {}
    for p_str, by_mcid in (data.get("mcid_char_stats") or {}).items():
        try:
            page = int(p_str)
        except Exception:
            continue
        for mcid_str, st in (by_mcid or {}).items():
            try:
                mcid = int(mcid_str)
                count = int(st.get("count", 0))
                preview = str(st.get("preview", ""))
            except Exception:
                continue
            out[(page, mcid)] = (count, preview)
    return out
