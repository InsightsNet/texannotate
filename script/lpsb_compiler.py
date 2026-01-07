#!/usr/bin/env python3
"""
LPSB Compiler Driver
Unified script for compiling arXiv papers (single or batch) with LPSB injection.

Usage:
  # Single paper
  python3 lpsb_compiler.py --single /path/to/source --output /path/to/output

  # Batch processing (100 papers)
  python3 lpsb_compiler.py --batch /path/to/arxiv_dirs --output /path/to/results --workers 8 --docker
"""

import argparse
import os
import shutil
import subprocess
import sys
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, as_completed

# Configuration
LPSB_IMAGE = "lpsb-texlive:latest"
TIMEOUT_SEC = 300  # 5 mins per paper

import re
import json
from typing import Tuple

# arXiv currently supports TeX Live 2023 and TeX Live 2025, with 2025 being the default.
ARXIV_TEXLIVE_DEFAULT = "2025"
# LPSB requires a modern LaTeX kernel (hooks). Clamp very old arXiv papers up to a minimum.
TEXLIVE_MIN_DEFAULT = "2020"

def _require_docker() -> None:
    try:
        r = subprocess.run(
            ["docker", "version"],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )
        if r.returncode != 0:
            raise RuntimeError("docker version failed")
    except Exception as e:
        raise RuntimeError(f"Docker is required but not available: {e}")

def _docker_image_exists(img: str) -> bool:
    try:
        r = subprocess.run(
            ["docker", "image", "inspect", img],
            stdout=subprocess.DEVNULL,
            stderr=subprocess.DEVNULL,
            check=False,
        )
        return r.returncode == 0
    except Exception:
        return False

def _read_00readme_texlive_version(work_dir: Path) -> str:
    p = work_dir / "00README.json"
    if not p.exists():
        return ""
    try:
        data = json.loads(p.read_text(errors="ignore"))
        v = data.get("texlive_version", "")
        if v is None:
            return ""
        v = str(v).strip()
        if re.fullmatch(r"\d{4}", v):
            return v
        return ""
    except Exception:
        return ""

def _detect_biblatex_bbl_format_version(bbl: Path) -> str:
    # Example line: "% $ biblatex bbl format version 3.1 $"
    if not bbl.exists():
        return ""
    try:
        for line in bbl.read_text(errors="ignore").splitlines()[:200]:
            m = re.search(r"biblatex bbl format version\s*([0-9]+\.[0-9]+)", line)
            if m:
                return m.group(1)
    except Exception:
        pass
    return ""

def _map_bbl_format_to_texlive_year(fmt: str) -> str:
    # Keep this conservative; sync with script/archive/batch_compile_all.sh
    return {
        "3.0": "2021",
        "3.1": "2022",
        "3.2": "2023",
        "3.3": "2024",
        "3.4": "2025",
    }.get(fmt, "")

def _select_docker_image_from_year(year: str) -> str:
    # Prefer a matching historic image when we have one.
    # Note: arXiv currently supports TL2023 and TL2025 (default 2025), but we keep
    # older historic tags if available for better compatibility with older sources.
    if year in ("2011", "2016", "2020", "2022", "2023", "2024", "2025"):
        cand = f"lpsb-texlive:TL{year}-historic"
        if _docker_image_exists(cand):
            return cand
        cand = f"texlive/texlive:TL{year}-historic"
        if _docker_image_exists(cand):
            return cand
    cand = "lpsb-texlive:latest"
    if _docker_image_exists(cand):
        return cand
    return "texlive/texlive:latest"

def _infer_tex_dir_and_main(main_tex_rel: str) -> Tuple[str, str]:
    p = Path(main_tex_rel)
    tex_dir_rel = str(p.parent) if str(p.parent) not in ("", ".") else "."
    return tex_dir_rel, p.name

def _paper_id_from_src(src_path: Path) -> str:
    if src_path.is_dir():
        return src_path.name
    name = src_path.name
    if name.endswith(".tar.gz"):
        return name[:-7]
    if name.endswith(".gz"):
        name = name[:-3]
    if name.endswith(".tex"):
        name = name[:-4]
    return name

def _inject_pkg_after_documentclass(tex_file: Path, pkg: str) -> None:
    """Idempotent insertion of \\usepackage{pkg} right after \\documentclass.
    
    Handles multi-line \\documentclass declarations where options span multiple lines.
    """
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return

    # Check if package already present
    pat = re.compile(r"\\usepackage(\[[^\]]*\])?\{\s*" + re.escape(pkg) + r"\s*\}")
    if pat.search(content):
        return

    # Find documentclass - may span multiple lines
    # Match: \documentclass followed by optional [...] and then {...}
    docclass_pattern = re.compile(
        r"(\\documentclass\s*(?:\[[^\]]*\])?\s*\{[^}]+\})",
        re.MULTILINE | re.DOTALL
    )
    
    match = docclass_pattern.search(content)
    if not match:
        # Fallback: try to find just \documentclass and insert after that line
        lines = content.splitlines(True)
        out = []
        inserted = False
        in_docclass = False
        brace_depth = 0
        
        for line in lines:
            out.append(line)
            
            if not inserted:
                if "\\documentclass" in line:
                    in_docclass = True
                
                if in_docclass:
                    brace_depth += line.count('{') - line.count('}')
                    if brace_depth <= 0 and '{' in line:
                        # End of documentclass
                        out.append("\\usepackage{" + pkg + "}\n")
                        inserted = True
                        in_docclass = False
        
        if inserted:
            try:
                tex_file.write_text("".join(out))
            except Exception:
                pass
        return
    
    # Insert \usepackage right after the documentclass
    insert_pos = match.end()
    new_content = content[:insert_pos] + "\n\\usepackage{" + pkg + "}" + content[insert_pos:]
    
    try:
        tex_file.write_text(new_content)
    except Exception:
        pass

def _find_any_bib_files(tex_dir: Path) -> bool:
    try:
        return any(tex_dir.glob("*.bib"))
    except Exception:
        return False

def _file_mentions(tex_file: Path, needle: str) -> bool:
    try:
        return needle in tex_file.read_text(errors="ignore")
    except Exception:
        return False

def _texlive_year_from_arxiv_id(paper_id: str) -> str:
    # Best-effort mapping from arXiv ID to TeX Live year based on arXiv's official update dates.
    # Only supports new-style YYMM.NNNN / YYMMNNN-ish IDs.
    match = re.search(r'(?:^|[a-zA-Z\-/])(\d{2})(\d{2})', paper_id or "")
    if not match:
        return ""
    try:
        yy = int(match.group(1))
        mm = int(match.group(2))
    except Exception:
        return ""

    date_val = (2000 + yy) * 100 + mm

    # Follow arXiv's official TeX Live update dates:
    # - TL2025: 2025-08-03
    # - TL2023: 2023-05-21
    # - TL2020: 2020-10-01
    # - TL2016: 2017-02-09
    # - TL2011: 2011-12-06
    if date_val >= 202508:
        return "2025"
    if date_val >= 202305:
        return "2023"
    if date_val >= 202010:
        return "2020"
    if date_val >= 201702:
        return "2016"
    if date_val >= 201112:
        return "2011"
    return "2011"

def _select_docker_image(work_dir: Path, tex_dir_rel: str, jobname: str, paper_id: str) -> Tuple[str, str, str]:
    # Returns (docker_image, selected_texlive_version_or_empty, reason)
    tl_min = os.environ.get("LPSB_TEXLIVE_MIN", TEXLIVE_MIN_DEFAULT).strip()
    if not re.fullmatch(r"\d{4}", tl_min):
        tl_min = TEXLIVE_MIN_DEFAULT

    img_override = os.environ.get("LPSB_DOCKER_IMAGE_OVERRIDE", "").strip()
    if img_override:
        return img_override, "", "docker_image_override"

    tl_override = os.environ.get("LPSB_TEXLIVE_VERSION_OVERRIDE", "").strip()
    if tl_override and re.fullmatch(r"\d{4}", tl_override):
        y = tl_override
        reason = "texlive_version_override"
        if int(y) < int(tl_min):
            y = tl_min
            reason += f"_clamped_to_min{tl_min}"
        return _select_docker_image_from_year(y), y, reason

    tl = _read_00readme_texlive_version(work_dir)
    if tl:
        # arXiv currently supports 2023 and 2025. If we see anything newer than 2025,
        # treat it as 2025 (default/latest).
        if tl in ("2011", "2016", "2020", "2022", "2023", "2024", "2025"):
            y = tl
            reason = "00README.json"
            if int(y) < int(tl_min):
                y = tl_min
                reason += f"_clamped_to_min{tl_min}"
            return _select_docker_image_from_year(y), y, reason
        if int(tl) > int(ARXIV_TEXLIVE_DEFAULT):
            y = ARXIV_TEXLIVE_DEFAULT
            reason = "00README.json_clamped_to_default"
            if int(y) < int(tl_min):
                y = tl_min
                reason += f"_clamped_to_min{tl_min}"
            return _select_docker_image_from_year(y), y, reason
        # Older values (e.g. 2020/2016) may have local historic images; attempt direct selection.
        y = tl
        reason = "00README.json"
        if re.fullmatch(r"\d{4}", y) and int(y) < int(tl_min):
            y = tl_min
            reason += f"_clamped_to_min{tl_min}"
        return _select_docker_image_from_year(y), y, reason

    bbl_dir = work_dir if tex_dir_rel == "." else (work_dir / tex_dir_rel)
    bbl = bbl_dir / f"{jobname}.bbl"
    if not bbl.exists():
        try:
            one = next(iter(bbl_dir.glob("*.bbl")), None)
            if one:
                bbl = one
        except Exception:
            pass

    fmt = _detect_biblatex_bbl_format_version(bbl)
    year = _map_bbl_format_to_texlive_year(fmt) if fmt else ""
    if year:
        y = year
        reason = f"biblatex_bbl_format:{fmt}"
        if int(y) < int(tl_min):
            y = tl_min
            reason += f"_clamped_to_min{tl_min}"
        return _select_docker_image_from_year(y), y, reason

    # No explicit hints: fall back to arXiv-id time mapping, else arXiv default.
    year = _texlive_year_from_arxiv_id(paper_id)
    if year:
        y = year
        reason = "arxiv_id_date"
        if int(y) < int(tl_min):
            y = tl_min
            reason += f"_clamped_to_min{tl_min}"
        return _select_docker_image_from_year(y), y, reason

    y = ARXIV_TEXLIVE_DEFAULT
    reason = "default"
    if int(y) < int(tl_min):
        y = tl_min
        reason += f"_clamped_to_min{tl_min}"
    return _select_docker_image_from_year(y), y, reason

def find_main_tex(work_dir):
    """Heuristic to find the main tex file."""
    # ... (unchanged part) ...
    # arXiv sources often keep the real entrypoint under subdirs.
    tex_files = list(Path(work_dir).rglob("*.tex"))
    if not tex_files:
        return None
        
    # Priority 1: File containing \documentclass and \begin{document}
    candidates = []
    for f in tex_files:
        try:
            content = f.read_text(errors='ignore')
            score = 0
            ifr = r'\documentclass' in content
            if r'\begin{document}' in content:
                score += 10
            if ifr:
                score += 5
            if 'ms.tex' in f.name or 'main.tex' in f.name:
                score += 1
            candidates.append((score, f))
        except:
            pass
            
    candidates.sort(key=lambda x: x[0], reverse=True)
    if candidates and candidates[0][0] > 0:
        try:
            return str(candidates[0][1].relative_to(Path(work_dir)))
        except Exception:
            return candidates[0][1].name
        
    # Priority 2: Largest .tex file
    tex_files.sort(key=lambda x: x.stat().st_size, reverse=True)
    try:
        return str(tex_files[0].relative_to(Path(work_dir)))
    except Exception:
        return tex_files[0].name

import tarfile
import gzip
import tempfile

def extract_archive(src_file, dst_dir):
    """Extract .gz archive (tar or single file) to dst_dir."""
    src_file = Path(src_file)
    dst_dir = Path(dst_dir)
    
    is_tar = False
    try:
        if tarfile.is_tarfile(src_file):
            is_tar = True
    except:
        pass
        
    if is_tar:
        try:
            with tarfile.open(src_file) as tar:
                def is_within_directory(directory, target):
                    abs_directory = os.path.abspath(directory)
                    abs_target = os.path.abspath(target)
                    prefix = os.path.commonprefix([abs_directory, abs_target])
                    return prefix == abs_directory
                
                # Check for unsafe members (ZipSlip) - simplified
                safe_members = [m for m in tar.getmembers() if not m.name.startswith('/') and '..' not in m.name]
                tar.extractall(path=dst_dir, members=safe_members)
            return True
        except Exception as e:
            # Fallback to gunzip if tar fails (sometimes misidentified)
            pass

    # Gunzip (Single file)
    try:
        # Determine target filename
        # 1234.5678.gz -> 1234.5678 or 1234.5678.tex
        target_name = src_file.stem
        # Check if we should append .tex
        if  not target_name.endswith('.tex'):
             target_path = dst_dir / f"{target_name}.tex"
        else:
             target_path = dst_dir / target_name
             
        with gzip.open(src_file, 'rb') as f_in:
            with open(target_path, 'wb') as f_out:
                shutil.copyfileobj(f_in, f_out)
        return True
    except Exception as e:
        return False

def process_one_paper(src_path, out_dir, lpsb_root, use_ramdisk=False):
    """Process a single paper directory or file."""
    src_path = Path(src_path).resolve()
    out_dir = Path(out_dir).resolve()
    lpsb_root = Path(lpsb_root).resolve()
    
    paper_id = _paper_id_from_src(src_path)
        
    res_dir = out_dir / paper_id
    res_dir.mkdir(parents=True, exist_ok=True)
    
    log_file = res_dir / "compile.log"
    
    work_dir_obj = None
    work_dir = None

    if use_ramdisk and Path("/dev/shm").exists():
        try:
            work_dir_obj = tempfile.TemporaryDirectory(prefix=f"lpsb_{paper_id}_", dir="/dev/shm")
            work_dir = Path(work_dir_obj.name)
        except Exception as e:
            with open(log_file, 'a') as log:
                log.write(f"Warning: Failed to create RAM disk: {e}. Falling back to disk.\n")
    
    if work_dir is None:
        work_dir = out_dir / "build" / paper_id
        # Clean previous build
        if work_dir.exists():
            shutil.rmtree(work_dir)
        work_dir.mkdir(parents=True)

    
    log_file = res_dir / "compile.log"
    
    main_tex_override = None

    try:
        # 1. Copy/Extract source
        if src_path.is_file():
            if src_path.suffix == '.gz':
                # Extract archive
                if not extract_archive(src_path, work_dir):
                     with open(log_file, 'a') as log:
                        log.write(f"Error: FAILED_TO_EXTRACT {src_path}\n")
                     return "FAIL_EXTRACT"
            elif src_path.suffix == '.tex':
                shutil.copy(src_path, work_dir / src_path.name)
                main_tex_override = src_path.name
            else:
                # Unknown file type, try copy
                shutil.copy(src_path, work_dir / src_path.name)
        else:
            shutil.copytree(src_path, work_dir, dirs_exist_ok=True)

        # 2. Find main tex (relative path under work_dir)
        if main_tex_override:
            main_tex = main_tex_override
        else:
            main_tex = find_main_tex(work_dir)
            
        if not main_tex:
            with open(log_file, 'a') as log: # Append mode, because check image wrote to it
                log.write("Error: NO_MAIN_TEX_FOUND\n")
            return "NO_MAIN"
            
        main_base = Path(main_tex).stem
        tex_dir_rel, main_tex_basename = _infer_tex_dir_and_main(main_tex)
        
        docker_image = LPSB_IMAGE
        selected_tl = ""

        # 3. Compile (gold pipeline only)
        pdflatex_dir = work_dir / "_pdflatex"
        lualatex_dir = work_dir / "_lualatex"
        if pdflatex_dir.exists():
            shutil.rmtree(pdflatex_dir, ignore_errors=True)
        if lualatex_dir.exists():
            shutil.rmtree(lualatex_dir, ignore_errors=True)

        ignore = shutil.ignore_patterns("_pdflatex", "_lualatex")
        shutil.copytree(work_dir, pdflatex_dir, ignore=ignore)
        shutil.copytree(work_dir, lualatex_dir, ignore=ignore)

        pd_tex_dir = pdflatex_dir if tex_dir_rel == "." else (pdflatex_dir / tex_dir_rel)
        lua_tex_dir = lualatex_dir if tex_dir_rel == "." else (lualatex_dir / tex_dir_rel)
        pd_tex_dir.mkdir(parents=True, exist_ok=True)
        lua_tex_dir.mkdir(parents=True, exist_ok=True)

        def _copy_if_exists(name: str, dst_dir: Path) -> None:
            src = lpsb_root / name
            if not src.exists():
                src = lpsb_root.parent / name
            if src.exists():
                shutil.copy(src, dst_dir / name)

        # Like batch_compile_all.sh: pdflatex needs only lpsb.sty.
        _copy_if_exists("lpsb.sty", pd_tex_dir)
        # Lua stage: structure + math/table enrich.
        _copy_if_exists("lpsb.sty", lua_tex_dir)
        _copy_if_exists("lpsb-luamath.sty", lua_tex_dir)
        _copy_if_exists("lpsb-math.lua", lua_tex_dir)
        _copy_if_exists("lpsb-luatable.sty", lua_tex_dir)
        _copy_if_exists("lpsb-table.lua", lua_tex_dir)

        pd_main_tex_full = pdflatex_dir / main_tex
        lua_main_tex_full = lualatex_dir / main_tex
        _inject_pkg_after_documentclass(pd_main_tex_full, "lpsb")
        _inject_pkg_after_documentclass(lua_main_tex_full, "lpsb")
        _inject_pkg_after_documentclass(lua_main_tex_full, "lpsb-luamath")
        _inject_pkg_after_documentclass(lua_main_tex_full, "lpsb-luatable")

        docker_image, selected_tl, selected_reason = _select_docker_image(work_dir, tex_dir_rel, main_base, paper_id)

        with open(log_file, "w") as log:
            log.write(f"Docker image: {docker_image}\n")
            if selected_tl:
                log.write(f"TeX Live selected: {selected_tl}\n")
            log.write(f"TeX Live reason: {selected_reason}\n")

        pd_container_wd = "/workdir" if tex_dir_rel == "." else f"/workdir/{tex_dir_rel}"
        lua_container_wd = "/workdir" if tex_dir_rel == "." else f"/workdir/{tex_dir_rel}"

        container_counter = [0]  # mutable for closure
        
        def _run(stage_dir: Path, container_wd: str, cmd: list, timeout: int) -> int:
            """Run command in Docker with proper timeout handling."""
            container_counter[0] += 1
            container_name = f"lpsb_{paper_id}_{container_counter[0]}_{os.getpid()}"
            
            with open(log_file, "a") as log:
                try:
                    docker_cmd = [
                        "docker", "run", "--rm",
                        "--name", container_name,
                        "-v", f"{stage_dir}:/workdir",
                        "-w", container_wd,
                        docker_image
                    ] + cmd
                    r = subprocess.run(docker_cmd, stdout=log, stderr=subprocess.STDOUT, timeout=timeout, check=False)
                    return r.returncode
                except subprocess.TimeoutExpired:
                    log.write("\nError: TIMEOUT - killing container\n")
                    # Kill the container explicitly
                    try:
                        subprocess.run(["docker", "kill", container_name], 
                                      capture_output=True, timeout=10)
                    except:
                        pass
                    try:
                        subprocess.run(["docker", "rm", "-f", container_name],
                                      capture_output=True, timeout=10)
                    except:
                        pass
                    return 124

        # Stage A: pdflatex gold (3 passes)
        _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)

        # Bibliography for gold (best effort, like batch script)
        if (pd_tex_dir / f"{main_base}.bbl").exists():
            pass
        elif _file_mentions(pd_main_tex_full, "biblatex"):
            _run(pdflatex_dir, pd_container_wd, ["biber", main_base], TIMEOUT_SEC)
        elif _file_mentions(pd_main_tex_full, "bibliography") or _find_any_bib_files(pd_tex_dir):
            _run(pdflatex_dir, pd_container_wd, ["bibtex", main_base], TIMEOUT_SEC)

        _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
        _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)

        aux_file = pd_tex_dir / f"{main_base}.aux"
        pdf_file = pd_tex_dir / f"{main_base}.pdf"
        json_file = pd_tex_dir / f"{main_base}.lpsb.json"
        # Expose gold artifacts early: RAM-disk workdir will be cleaned, but users still need outputs.
        final_pdf = res_dir / f"{paper_id}.pdf"
        gold_json = res_dir / f"{paper_id}.lpsb.json"
        if pdf_file.exists():
            try:
                shutil.copy(pdf_file, final_pdf)
            except Exception:
                pass
        if json_file.exists():
            try:
                shutil.copy(json_file, gold_json)
            except Exception:
                pass

        if not (aux_file.exists() and pdf_file.exists() and json_file.exists()):
            with open(log_file, 'a') as log:
                log.write("\nError: COMPILATION_FAILED (missing gold artifacts)\n")
            return "FAIL"

        # Stage B: lualatex enrichment (3 passes)
        _run(lualatex_dir, lua_container_wd, ["lualatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
        if (lua_tex_dir / f"{main_base}.bbl").exists():
            pass
        elif _file_mentions(lua_main_tex_full, "biblatex"):
            _run(lualatex_dir, lua_container_wd, ["biber", main_base], TIMEOUT_SEC)
        elif _file_mentions(lua_main_tex_full, "bibliography") or _find_any_bib_files(lua_tex_dir):
            _run(lualatex_dir, lua_container_wd, ["bibtex", main_base], TIMEOUT_SEC)
        _run(lualatex_dir, lua_container_wd, ["lualatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
        _run(lualatex_dir, lua_container_wd, ["lualatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)

        math_json = lua_tex_dir / f"{main_base}.lpsb-math.json"
        table_json = lua_tex_dir / f"{main_base}.lpsb-table.json"

        if math_json.exists():
            merged_json = work_dir / f"{main_base}.lpsb.merged.json"
            merge_script = lpsb_root / "script" / "merge_lpsb.py"
            if not merge_script.exists():
                merge_script = lpsb_root / "merge_lpsb.py"
            if merge_script.exists():
                cmd = [sys.executable, str(merge_script), str(json_file), str(math_json), str(merged_json)]
                if table_json.exists():
                    cmd.append(str(table_json))
                with open(log_file, 'a') as log:
                    log.write("\n=== Merge (math/table) ===\n")
                    subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT, check=False)
                if merged_json.exists():
                    json_file = merged_json
            else:
                with open(log_file, 'a') as log:
                    log.write("\nWarning: merge_lpsb.py not found, skipping merge\n")

        # 5. Enrich Positions
        
        if not (aux_file.exists() and pdf_file.exists() and json_file.exists()):
            with open(log_file, 'a') as log:
                log.write("\nError: COMPILATION_FAILED (missing artifacts)\n")
            return "FAIL"
            
        final_json = res_dir / f"{paper_id}.json"
        
        enrich_script = lpsb_root / "script" / "enrich_positions.py"
        if not enrich_script.exists():
             enrich_script = lpsb_root / "enrich_positions.py"
        
        # Find main tex file for LaTeX source extraction
        main_tex_for_enrich = pd_tex_dir / main_tex_basename
             
        enrich_cmd = [
            sys.executable, str(enrich_script),
            str(aux_file), str(pdf_file), str(json_file),
            "-o", str(final_json),
            "-t", str(main_tex_for_enrich)  # LaTeX source extraction
        ]
        
        with open(log_file, 'a') as log:
            log.write("\n=== Enrichment ===\n")
            r = subprocess.run(enrich_cmd, stdout=log, stderr=subprocess.STDOUT, timeout=60, check=False)
            if r.returncode != 0:
                log.write(f"\nWarning: enrichment returned {r.returncode}; falling back to raw structure JSON\n")
        if not final_json.exists():
            try:
                shutil.copy(json_file, final_json)
            except Exception:
                pass
            
        # 6. Copy PDF (already copied early; refresh best-effort)
        try:
            shutil.copy(pdf_file, final_pdf)
        except Exception:
            pass
        
        # Cleanup (optional, keeping build for debug)
        # shutil.rmtree(work_dir)
        
        return "SUCCESS"
        
    except subprocess.TimeoutExpired:
        with open(log_file, 'a') as log:
            log.write("\nError: TIMEOUT\n")
        return "TIMEOUT"
    except Exception as e:
        with open(log_file, 'a') as log:
            log.write(f"\nError: EXCEPTION {str(e)}\n")
        return "ERROR"
    finally:
        if work_dir_obj:
            try:
                work_dir_obj.cleanup()
            except:
                pass

def batch_worker(args):
    return process_one_paper(*args)

def main():
    parser = argparse.ArgumentParser(description="LPSB Compiler")
    parser.add_argument('--single', help="Compile a single paper directory")
    parser.add_argument('--batch', help="Compile all subdirectories in this path")
    parser.add_argument('--output', '-o', required=True, help="Output directory")
    parser.add_argument('--no-ramdisk', action='store_true', help="Disable RAM disk workspace (default: enabled if /dev/shm exists)")
    parser.add_argument('--workers', type=int, default=1, help="Number of parallel workers")
    
    args = parser.parse_args()
    
    # Determine LPSB root (parent of script dir)
    script_dir = Path(__file__).parent.resolve()
    lpsb_root = script_dir.parent # usually LPSB/script/.. -> LPSB
    if args.single:
        print(f"Processing SINGLE paper: {args.single}")
        res = process_one_paper(args.single, args.output, lpsb_root, not args.no_ramdisk)
        print(f"Result: {res}")
        
    elif args.batch:
        src_root = Path(args.batch)
        papers = []
        # Recursive discovery
        papers.extend(src_root.rglob("*.gz"))
        papers.extend(src_root.rglob("*.tex"))
        # Remove duplicates
        papers = sorted(list(set(papers)))
        
        print(f"Processing BATCH of {len(papers)} items using {args.workers} workers")
        print(f"Output: {args.output}")
        if not args.no_ramdisk:
            print("Using RAM disk for workspace (default)")
        
        tasks = []
        for p in papers:
            tasks.append((p, args.output, lpsb_root, not args.no_ramdisk))
            
        results = {'SUCCESS': 0, 'FAIL': 0, 'TIMEOUT': 0, 'ERROR': 0, 'NO_MAIN': 0}
        
        with ProcessPoolExecutor(max_workers=args.workers) as executor:
            futures = {executor.submit(batch_worker, task): task[0].name for task in tasks}
            
            for f in as_completed(futures):
                pid = futures[f]
                try:
                    res = f.result()
                    results[res] = results.get(res, 0) + 1
                    print(f"[{res}] {pid}")
                except Exception as e:
                    print(f"[CRASH] {pid}: {e}")
                    results['ERROR'] += 1
                    
        print("\nSummary:")
        print(results)
        
    else:
        parser.print_help()

if __name__ == '__main__':
    main()
