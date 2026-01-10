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

try:
    from tqdm import tqdm
    HAS_TQDM = True
except ImportError:
    HAS_TQDM = False

# Configuration
LPSB_IMAGE = "lpsb-texlive:latest"
TIMEOUT_SEC = 300  # 5 mins per paper

import re
import json
from typing import Tuple
import threading
import atexit

# -----------------------------------------------------------------------------
# Docker Container Pool
# -----------------------------------------------------------------------------

class DockerContainerPool:
    """Manages a pool of long-running Docker containers for reuse.
    
    Instead of starting a new container per command (docker run), this pool
    starts containers once with a shared volume mount and reuses them via
    docker exec. This eliminates ~0.5-1s overhead per command.
    """
    
    _instances = {}  # class-level registry for cleanup
    _lock = threading.Lock()
    
    def __init__(self, image: str, shared_volume: Path, pool_size: int = 1):
        """
        Args:
            image: Docker image name
            shared_volume: Host path to mount as /workdir in all containers
            pool_size: Number of containers to start
        """
        self.image = image
        self.shared_volume = Path(shared_volume).resolve()
        self.pool_size = pool_size
        self.containers = []  # List of container names
        self._started = False
    
    def start(self) -> None:
        """Start all containers in the pool."""
        if self._started:
            return
        
        for i in range(self.pool_size):
            name = f"lpsb_pool_{os.getpid()}_{i}_{id(self)}"
            try:
                # Remove any stale container with same name
                subprocess.run(
                    ["docker", "rm", "-f", name],
                    capture_output=True, check=False
                )
                # Start container with shared volume
                r = subprocess.run(
                    [
                        "docker", "run", "-d",
                        "--name", name,
                        "--net", "none",
                        "-v", f"{self.shared_volume}:/workdir",
                        self.image,
                        "sleep", "infinity"
                    ],
                    capture_output=True, check=True, text=True
                )
                self.containers.append(name)
            except subprocess.CalledProcessError as e:
                # If starting fails, clean up any containers we did start
                self.stop()
                raise RuntimeError(f"Failed to start container pool: {e.stderr}")
        
        self._started = True
        # Register for cleanup
        with DockerContainerPool._lock:
            DockerContainerPool._instances[id(self)] = self
    
    def get_container(self, index: int) -> str:
        """Get container name by index (for worker assignment)."""
        if not self.containers:
            raise RuntimeError("Container pool not started")
        return self.containers[index % len(self.containers)]
    
    def exec_command(
        self,
        container_name: str,
        workdir: str,
        cmd: list,
        timeout: int = 300,
        log_file: "Path | None" = None,
    ) -> int:
        """Execute command in container via docker exec.
        
        Args:
            container_name: Name of the container to exec in
            workdir: Working directory inside container (must be under /workdir)
            cmd: Command and arguments to run
            timeout: Timeout in seconds
            log_file: Optional file to write output to
            
        Returns:
            Return code of the command (124 for timeout)
        """
        exec_cmd = ["docker", "exec", "-w", workdir, container_name] + cmd
        
        try:
            if log_file:
                with open(log_file, "a") as log:
                    log.write(f"\n=== EXEC: {' '.join(cmd)} ===\n")
                    r = subprocess.run(
                        exec_cmd,
                        stdout=log,
                        stderr=subprocess.STDOUT,
                        timeout=timeout,
                        check=False
                    )
                    log.write(f"=== EXIT: {cmd[0]} rc={r.returncode} ===\n")
                    return r.returncode
            else:
                r = subprocess.run(
                    exec_cmd,
                    capture_output=True,
                    timeout=timeout,
                    check=False
                )
                return r.returncode
        except subprocess.TimeoutExpired:
            if log_file:
                with open(log_file, "a") as log:
                    log.write("\nError: TIMEOUT during exec\n")
            return 124
    
    def stop(self) -> None:
        """Stop and remove all containers in the pool."""
        for name in self.containers:
            try:
                subprocess.run(
                    ["docker", "rm", "-f", name],
                    capture_output=True, check=False, timeout=10
                )
            except Exception:
                pass
        self.containers.clear()
        self._started = False
        # Unregister
        with DockerContainerPool._lock:
            DockerContainerPool._instances.pop(id(self), None)
    
    def __enter__(self):
        self.start()
        return self
    
    def __exit__(self, *args):
        self.stop()
    
    @classmethod
    def cleanup_all(cls) -> None:
        """Clean up all registered container pools (called at exit)."""
        with cls._lock:
            for pool in list(cls._instances.values()):
                try:
                    pool.stop()
                except Exception:
                    pass

# Register cleanup handler
atexit.register(DockerContainerPool.cleanup_all)

# -----------------------------------------------------------------------------
# Log helpers
# -----------------------------------------------------------------------------


def _scan_log_for_missing_tex_inputs(log_path: Path) -> set:
    """Extract missing TeX inputs (foo.sty/foo.cls/foo.bst/...) from a LaTeX log."""
    missing = set()
    if not log_path.exists():
        return missing
    try:
        txt = log_path.read_text(errors="ignore")
    except Exception:
        return missing

    pats = [
        r"! LaTeX Error: File `([^`']+)' not found\.",
        r"! I can't find file `([^`']+)'",
    ]
    exts = (".sty", ".cls", ".bst", ".clo", ".tex")
    for pat in pats:
        for m in re.finditer(pat, txt, flags=re.MULTILINE):
            name = (m.group(1) or "").strip()
            if not name:
                continue
            name = Path(name).name
            if name.lower().endswith(exts):
                missing.add(name)
    return missing

# arXiv currently supports TeX Live 2023 and TeX Live 2025, with 2025 being the default.
ARXIV_TEXLIVE_DEFAULT = "2025"
# LPSB requires a modern LaTeX kernel (hooks). Clamp very old arXiv papers up to a minimum.
TEXLIVE_MIN_DEFAULT = "2020"

def _scan_compile_log_for_issues(log_path: Path):
    """Best-effort scan for errors that still allow a PDF to be produced.

    This repo historically treated 'PDF exists' as success, but LaTeX can keep going
    under -interaction=nonstopmode and still emit a PDF with broken citations/refs.
    
    IMPORTANT: Only scans Stage A (pdflatex gold) for fatal errors. Stage B (lualatex
    enrichment) errors are recorded but do not cause failure, since Stage B is optional
    enhancement and the gold PDF was already produced by Stage A.
    """
    issues = {
        "fatal": False,
        "undef_citation": False,
        "undef_reference": False,
        "bibtex_problem": False,
        "biber_seen": False,
        "stage_b_errors": 0,  # Count of errors in Stage B (for informational purposes)
        "latex_error_lines": 0,  # Count of "! LaTeX Error:" lines (soft by default)
    }
    try:
        with open(log_path, "r", errors="replace") as f:
            in_stage_b = False
            # Track per-run fatality: treat "fatal" only if the *current* pdflatex run
            # hard-stopped and did not produce a PDF. Earlier hard-stops can be fixed by
            # retries (e.g., after copying missing stubs) and should not poison the result.
            run_fatal = False
            run_pdf_written = False
            for line in f:
                # Detect Stage B section - errors here are non-fatal
                if "=== Stage B:" in line or "Stage B: lualatex" in line:
                    in_stage_b = True
                
                # Count Stage B errors but don't treat as fatal
                if in_stage_b:
                    if line.startswith("! ") or ("! Package" in line and " Error:" in line):
                        issues["stage_b_errors"] += 1
                    continue  # Skip Stage B errors for fatal/undef checks

                # New pdflatex run boundary (best-effort).
                # pdflatex always prints "This is pdfTeX" early in each run.
                if line.startswith("This is pdfTeX"):
                    run_fatal = False
                    run_pdf_written = False

                if "Output written on " in line and ".pdf" in line:
                    run_pdf_written = True
                
                # Fatal-ish: LaTeX continues but output is not trustworthy.
                # IMPORTANT:
                # - Many real-world arXiv sources emit "! LaTeX Error:" but still produce a usable PDF
                #   under -interaction=nonstopmode. Treat those as "soft errors" and leave strictness
                #   to the caller (see strict env vars below).
                # - Only treat clear hard-stops as fatal here.
                if line.startswith("! LaTeX Error:"):
                    issues["latex_error_lines"] += 1
                if line.startswith("! Emergency stop."):
                    run_fatal = True
                elif "Fatal error occurred" in line or "==> Fatal error" in line:
                    run_fatal = True

                # Undefined citations typically render as '?' in PDF.
                if ("Citation `" in line and "undefined" in line) or ("There were undefined citations" in line):
                    issues["undef_citation"] = True

                # Undefined cross-refs typically render as '??' in PDF.
                if ("LaTeX Warning: Reference `" in line and "undefined" in line) or ("There were undefined references" in line):
                    issues["undef_reference"] = True

                # BibTeX problems strongly correlate with broken bibliography output.
                if (
                    "I found no \\bibdata command" in line
                    or "I found no \\bibstyle command" in line
                    or "I found no \\citation commands" in line
                    or "couldn't open database file" in line
                    or "couldn't open style file" in line
                    or ("No file " in line and line.rstrip().endswith(".bbl"))
                ):
                    issues["bibtex_problem"] = True

                if "biber" in line.lower():
                    issues["biber_seen"] = True

                if issues["fatal"] and issues["undef_citation"] and issues["undef_reference"] and issues["bibtex_problem"]:
                    break
    except Exception:
        # If we cannot read the log, do not block compilation; caller can still use file presence checks.
        return issues
    # Only count fatal if the last observed pdflatex run hard-stopped and no PDF was written.
    issues["fatal"] = bool(run_fatal and not run_pdf_written)
    return issues

def _aux_mentions_bibdata(aux_file: Path) -> bool:
    try:
        if not aux_file.exists():
            return False
        # Read a bounded prefix; we only care about control lines.
        data = aux_file.read_text(errors="ignore")[:200000]
        return "\\bibdata" in data
    except Exception:
        return False

def _bcf_exists(tex_dir: Path, jobname: str) -> bool:
    try:
        return (tex_dir / f"{jobname}.bcf").exists()
    except Exception:
        return False

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

def _inject_pkg_after_documentclass(tex_file: Path, pkg: str, options: str = "") -> None:
    """Idempotent insertion of \\usepackage{pkg} right after \\documentclass.
    
    Handles multi-line \\documentclass declarations where options span multiple lines.
    Skips commented lines (starting with %).
    """
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return

    # Check if package already present
    pat = re.compile(r"\\usepackage(\[[^\]]*\])?\{\s*" + re.escape(pkg) + r"\s*\}")
    if pat.search(content):
        return

    # Respect the file's newline style for minimal churn.
    newline = "\r\n" if "\r\n" in content else "\n"

    # Work with lines for insertion, but locate the *end* of \documentclass by parsing
    # until the mandatory {class} argument closes. Counting braces per-line is wrong
    # when \documentclass options span multiple lines before the first '{'.
    lines = content.splitlines(keepends=True)

    def _strip_tex_comment(s: str) -> str:
        # Remove TeX comments, preserving escaped \% (best-effort).
        out = []
        esc = False
        for ch in s:
            if esc:
                out.append(ch)
                esc = False
                continue
            if ch == "\\":
                out.append(ch)
                esc = True
                continue
            if ch == "%":
                break
            out.append(ch)
        return "".join(out)

    in_docclass = False
    saw_open_brace = False
    brace_depth = 0
    docclass_end_idx = -1

    for i, raw in enumerate(lines):
        stripped = raw.lstrip()
        if stripped.startswith("%"):
            continue

        line = _strip_tex_comment(raw)

        if not in_docclass:
            if "\\documentclass" not in line:
                continue
            in_docclass = True

            # Continue parsing *from this line*; do not assume '{' is present.
            # Fall through to brace scanning below.

        if in_docclass:
            for ch in line:
                if not saw_open_brace:
                    if ch == "{":
                        saw_open_brace = True
                        brace_depth = 1
                    continue
                # after we saw the mandatory '{', track nested braces until it closes
                if ch == "{":
                    brace_depth += 1
                elif ch == "}":
                    brace_depth -= 1
                    if brace_depth == 0:
                        docclass_end_idx = i
                        break
            if docclass_end_idx >= 0:
                break

    if docclass_end_idx < 0:
        return  # No valid \documentclass{...} found

    opt = f"[{options}]" if options else ""
    lines.insert(docclass_end_idx + 1, f"\\usepackage{opt}{{{pkg}}}{newline}")

    try:
        tex_file.write_text("".join(lines))
    except Exception:
        return

def _has_unsafe_bibitem_key_in_text(s: str) -> bool:
    """Return True if text contains \\bibitem{<key>} where <key> contains a raw '_'."""
    i = 0
    n = len(s)
    while True:
        j = s.find(r"\bibitem", i)
        if j < 0:
            return False
        k = j + len(r"\bibitem")
        # Skip whitespace
        while k < n and s[k].isspace():
            k += 1
        # Optional argument [..] may exist; skip it if present.
        if k < n and s[k] == "[":
            depth = 1
            k += 1
            while k < n and depth > 0:
                if s[k] == "[":
                    depth += 1
                elif s[k] == "]":
                    depth -= 1
                k += 1
            while k < n and s[k].isspace():
                k += 1
        # Some .bbl put a % line break between \bibitem[...] and {key}; skip comments.
        while k < n:
            while k < n and s[k].isspace():
                k += 1
            if k < n and s[k] == "%":
                while k < n and s[k] not in "\r\n":
                    k += 1
                continue
            break
        if k >= n or s[k] != "{":
            i = j + 1
            continue
        # Parse {key} with brace counting.
        depth = 1
        k += 1
        start = k
        while k < n and depth > 0:
            if s[k] == "{":
                depth += 1
            elif s[k] == "}":
                depth -= 1
                if depth == 0:
                    break
            k += 1
        if depth != 0:
            i = j + 1
            continue
        key = s[start:k]
        if "_" in key:
            return True
        i = k + 1


def _bbl_has_unsafe_bibitem_key(bbl: Path) -> bool:
    """Return True if the .bbl contains a \\bibitem key with raw '_' characters."""
    if not bbl.exists():
        return False
    try:
        s = bbl.read_text(errors="ignore")
    except Exception:
        return False
    return _has_unsafe_bibitem_key_in_text(s)


def _tex_has_unsafe_bibitem_key(tex: Path) -> bool:
    """Like _bbl_has_unsafe_bibitem_key, but for generic .tex bibliography includes."""
    if not tex.exists():
        return False
    try:
        s = tex.read_text(errors="ignore")
    except Exception:
        return False
    return _has_unsafe_bibitem_key_in_text(s)

def _inject_bbl_underscore_catcode_fix(tex_file: Path) -> None:
    """Inject a minimal, localized fix for underscores in .bbl files.

    Some .bbl files contain raw '_' in \\bibitem keys (e.g. {nearly_sorted}), which
    triggers TeX's 'Missing $ inserted.' during \\@input{\\jobname.bbl}.  Using the
    underscore package can make '_' an active character and may break other tooling
    (e.g., labels written to .aux that contain underscores).  Instead, temporarily
    set catcode('_')=12 only while inputting \\jobname.bbl, then restore.
    """
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return
    if "LPSB_BBL_UNDERSCORE_FIX" in content:
        return

    newline = "\r\n" if "\r\n" in content else "\n"
    lines = content.splitlines(keepends=True)

    # Insert immediately after \documentclass block (same placement as other injected packages).
    # Reuse the same docclass end parsing logic by calling _inject_pkg_after_documentclass
    # with an empty package and then patching the inserted line? No: keep it self-contained.

    # Find insertion index: end of \documentclass{...}
    in_docclass = False
    saw_open_brace = False
    brace_depth = 0
    docclass_end_idx = -1

    def _strip_tex_comment(s: str) -> str:
        out = []
        esc = False
        for ch in s:
            if esc:
                out.append(ch)
                esc = False
                continue
            if ch == "\\":
                out.append(ch)
                esc = True
                continue
            if ch == "%":
                break
            out.append(ch)
        return "".join(out)

    for i, raw in enumerate(lines):
        stripped = raw.lstrip()
        if stripped.startswith("%"):
            continue
        line = _strip_tex_comment(raw)
        if not in_docclass:
            if "\\documentclass" not in line:
                continue
            in_docclass = True
        if in_docclass:
            for ch in line:
                if not saw_open_brace:
                    if ch == "{":
                        saw_open_brace = True
                        brace_depth = 1
                    continue
                if ch == "{":
                    brace_depth += 1
                elif ch == "}":
                    brace_depth -= 1
                    if brace_depth == 0:
                        docclass_end_idx = i
                        break
            if docclass_end_idx >= 0:
                break

    if docclass_end_idx < 0:
        return

    snippet = (
        "% LPSB_BBL_UNDERSCORE_FIX" + newline +
        "\\makeatletter" + newline +
        "% Delay file-input hooking until \\begin{document}." + newline +
        "% Babel (and other core packages) use scratch macros like \\reserved@c while" + newline +
        "% loading language files in the preamble; hooking too early can break that" + newline +
        "% path and manifest as \"I can't find file `}'\" in babel.def." + newline +
        "\\AtBeginDocument{%" + newline +
        "  \\providecommand\\lpsb@olduscat{}" + newline +
        "  \\let\\lpsb@orig@input\\@input" + newline +
        "  \\@ifundefined{@input@}{}{\\let\\lpsb@orig@inputat\\@input@}" + newline +
        "  \\def\\lpsb@catcode@underscore@do#1#2{%" + newline +
        "    \\begingroup\\xdef\\lpsb@olduscat{\\the\\catcode`\\_}\\endgroup" + newline +
        "    \\catcode`\\_=12\\relax" + newline +
        "    #1{#2}%" + newline +
        "    \\catcode`\\_=\\lpsb@olduscat\\relax" + newline +
        "  }"+ newline +
        "  % Only enable underscore-catcode fix for bibliography-like inputs." + newline +
        "  \\edef\\lpsb@jobnamebbl{\\jobname.bbl}" + newline +
        "  \\edef\\lpsb@jobnameaux{\\jobname.aux}" + newline +
        "  \\def\\lpsb@bbltex{bbl.tex}" + newline +
        "  \\def\\lpsb@bbl{bbl}" + newline +
        "  \\def\\lpsb@maybe@fix@file#1#2{%" + newline +
        "    \\edef\\lpsb@tmp{#2}%" + newline +
        "    \\ifx\\lpsb@tmp\\lpsb@jobnamebbl" + newline +
        "      \\lpsb@catcode@underscore@do#1{#2}%" + newline +
        "    \\else\\ifx\\lpsb@tmp\\lpsb@jobnameaux" + newline +
        "      \\lpsb@catcode@underscore@do#1{#2}%" + newline +
        "    \\else\\ifx\\lpsb@tmp\\lpsb@bbltex" + newline +
        "      \\lpsb@catcode@underscore@do#1{#2}%" + newline +
        "    \\else\\ifx\\lpsb@tmp\\lpsb@bbl" + newline +
        "      \\lpsb@catcode@underscore@do#1{#2}%" + newline +
        "    \\else" + newline +
        "      #1{#2}%" + newline +
        "    \\fi\\fi\\fi\\fi" + newline +
        "  }"+ newline +
        "  \\def\\@input#1{\\lpsb@maybe@fix@file\\lpsb@orig@input{#1}}" + newline +
        "  \\@ifundefined{@input@}{}{\\def\\@input@#1{\\lpsb@maybe@fix@file\\lpsb@orig@inputat{#1}}}" + newline +
        "  % Wrap plain \\input *safely*: only intercept the braced form \\input{...}." + newline +
        "  % Many packages use the unbraced form (e.g. \\input xstring.tex); a naive" + newline +
        "  % \\def\\input#1{...} would only capture the first token ('x'), breaking them." + newline +
        "  \\let\\lpsb@orig@plaininput\\input" + newline +
        "  \\def\\input{\\futurelet\\lpsb@next\\lpsb@input@maybe@fix}" + newline +
        "  \\def\\lpsb@input@maybe@fix{%" + newline +
        "    \\ifx\\lpsb@next\\bgroup" + newline +
        "      \\expandafter\\lpsb@input@maybe@fix@braced" + newline +
        "    \\else" + newline +
        "      \\lpsb@orig@plaininput" + newline +
        "    \\fi" + newline +
        "  }" + newline +
        "  \\def\\lpsb@input@maybe@fix@braced#1{\\lpsb@maybe@fix@file\\lpsb@orig@plaininput{#1}}" + newline +
        "}" + newline +
        "\\makeatother" + newline
    )
    lines.insert(docclass_end_idx + 1, snippet)
    try:
        tex_file.write_text("".join(lines))
    except Exception:
        return


def _inject_natbib_numbers_fix(tex_file: Path) -> None:
    """Inject a natbib compatibility workaround.

    Some papers ship a bibliography that natbib cannot parse in author-year mode, causing:
      Package natbib Error: Bibliography not compatible with author-year citations.

    For structure extraction, switching natbib to numeric mode is usually sufficient.
    We do this conservatively:
    - only if natbib is loaded
    - only if \\setcitestyle exists
    - delayed to \\AtBeginDocument (safe around package preamble loading)
    """
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return
    if "LPSB_NATBIB_NUMBERS_FIX" in content:
        return

    newline = "\r\n" if "\r\n" in content else "\n"
    lines = content.splitlines(keepends=True)

    # Find insertion index: end of \documentclass{...}
    in_docclass = False
    saw_open_brace = False
    brace_depth = 0
    docclass_end_idx = -1

    def _strip_tex_comment(s: str) -> str:
        out = []
        esc = False
        for ch in s:
            if esc:
                out.append(ch)
                esc = False
                continue
            if ch == "\\":
                out.append(ch)
                esc = True
                continue
            if ch == "%":
                break
            out.append(ch)
        return "".join(out)

    for i, raw in enumerate(lines):
        stripped = raw.lstrip()
        if stripped.startswith("%"):
            continue
        line = _strip_tex_comment(raw)
        if not in_docclass:
            if "\\documentclass" not in line:
                continue
            in_docclass = True
        if in_docclass:
            for ch in line:
                if not saw_open_brace:
                    if ch == "{":
                        saw_open_brace = True
                        brace_depth = 1
                    continue
                if ch == "{":
                    brace_depth += 1
                elif ch == "}":
                    brace_depth -= 1
                    if brace_depth == 0:
                        docclass_end_idx = i
                        break
            if docclass_end_idx >= 0:
                break

    if docclass_end_idx < 0:
        return

    snippet = (
        "% LPSB_NATBIB_NUMBERS_FIX" + newline +
        "\\makeatletter" + newline +
        "\\AtBeginDocument{%" + newline +
        "  \\@ifpackageloaded{natbib}{%" + newline +
        "    \\@ifundefined{setcitestyle}{}{\\setcitestyle{numbers}}%" + newline +
        "  }{}%" + newline +
        "}" + newline +
        "\\makeatother" + newline
    )
    lines.insert(docclass_end_idx + 1, snippet)
    try:
        tex_file.write_text("".join(lines))
    except Exception:
        return

def _env_truthy(name: str) -> bool:
    val = os.environ.get(name, "").strip().lower()
    return val in ("1", "true", "yes", "y", "on")

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
        
    def _looks_like_latex_main(s: str) -> bool:
        # We only support LaTeX-style entrypoints. Reject obvious non-TeX payloads
        # (some arXiv sources contain HTML mistakenly named *.tex).
        head = s.lstrip()[:2000].lower()
        if head.startswith("<!doctype html") or head.startswith("<html") or "<html" in head:
            return False
        # Must have at least one real LaTeX marker. This avoids picking arbitrary
        # fragments or non-LaTeX text files as "main".
        return ("\\documentclass" in s) or ("\\begin{document}" in s) or ("\\end{document}" in s)

    # Priority 1: Score likely entrypoints.
    candidates = []
    for f in tex_files:
        try:
            content = f.read_text(errors='ignore')
            score = 0

            name = (f.name or "").lower()
            stem = f.stem.lower()

            # Hard de-prioritize known template/docs files that are often shipped
            # alongside real manuscripts.
            if name in ("natbib.tex", "natnotes.tex", "aassymbols.tex"):
                score -= 50
            for bad in ("template", "sample", "example", "instructions", "readme"):
                if bad in stem:
                    score -= 10

            if r'\begin{document}' in content:
                score += 10
            if r'\end{document}' in content:
                score += 2
            if r'\documentclass' in content:
                score += 5

            # Real papers tend to have title/author blocks; templates often do not.
            if r'\title' in content:
                score += 3
            if r'\author' in content:
                score += 2
            if r'\begin{abstract}' in content:
                score += 1

            # Filename hints.
            if stem in ("main", "ms", "paper", "manuscript", "arxiv"):
                score += 4
            if "main" in stem:
                score += 2
            if "ms" == stem or stem.startswith("ms_") or stem.endswith("_ms"):
                score += 1

            # Tie-breaker: prefer larger files (real manuscripts are usually bigger).
            try:
                score += min(5, int(f.stat().st_size / 20000))  # +0..+5
            except Exception:
                pass
            candidates.append((score, f))
        except:
            pass
            
    candidates.sort(key=lambda x: (x[0], x[1].stat().st_size if x[1].exists() else 0), reverse=True)
    if candidates and candidates[0][0] > 0:
        try:
            return str(candidates[0][1].relative_to(Path(work_dir)))
        except Exception:
            return candidates[0][1].name
        
    # Priority 2: Largest .tex file
    tex_files.sort(key=lambda x: x.stat().st_size, reverse=True)
    try:
        # Avoid selecting non-LaTeX garbage (e.g. HTML) as the entrypoint.
        content = tex_files[0].read_text(errors="ignore")
        if not _looks_like_latex_main(content):
            return None
        return str(tex_files[0].relative_to(Path(work_dir)))
    except Exception:
        return None

import tarfile
import gzip
import tempfile


def _detect_withdrawn_or_invalid(work_dir: Path) -> str:
    """Detect if extracted content is an arXiv withdrawn placeholder or non-TeX file.
    
    Returns:
        "" if content looks valid
        "WITHDRAWN" if it's an arXiv withdrawal placeholder
        "NOT_TEX" if it's not a TeX file (HTML, PDF, etc.)
    """
    # Check all files in work_dir
    all_files = list(work_dir.rglob("*"))
    if not all_files:
        return "WITHDRAWN"  # Empty extraction
    
    # Filter to actual files (not dirs)
    files = [f for f in all_files if f.is_file()]
    if not files:
        return "WITHDRAWN"
    
    # Check for withdrawn placeholder: typically a single tiny file with "%auto-ignore"
    total_size = sum(f.stat().st_size for f in files)
    if total_size < 100:
        # Very small - check content
        for f in files:
            try:
                content = f.read_text(errors="ignore").strip()
                if content == "%auto-ignore" or content.startswith("%auto-ignore"):
                    return "WITHDRAWN"
            except Exception:
                pass
    
    # Check if any file looks like TeX (and NOT HTML/PDF mislabeled as .tex)
    has_tex = False
    for f in files:
        suffix = f.suffix.lower()
        if suffix in (".tex", ".sty", ".cls", ".bbl", ".bib"):
            # Even with .tex extension, verify it's not actually HTML/PDF
            try:
                head = f.read_bytes()[:500].decode("utf-8", errors="ignore").lower()
                if "<html" in head or "<!doctype html" in head:
                    # This is HTML mislabeled as .tex
                    return "NOT_TEX"
                if head.strip().startswith("%pdf-"):
                    # This is a PDF mislabeled
                    return "NOT_TEX"
            except Exception:
                pass
            has_tex = True
            break
        # Also check content for \documentclass
        if suffix in ("", ".txt") or not suffix:
            try:
                head = f.read_bytes()[:2000].decode("utf-8", errors="ignore")
                if "\\documentclass" in head or "\\begin{document}" in head:
                    has_tex = True
                    break
            except Exception:
                pass
    
    if not has_tex:
        # Check what we actually have
        for f in files:
            try:
                head = f.read_bytes()[:500].decode("utf-8", errors="ignore").lower()
                if "<html" in head or "<!doctype html" in head:
                    return "NOT_TEX"
                if head.startswith("%pdf-"):
                    return "NOT_TEX"
            except Exception:
                pass
        # No TeX found but also not clearly HTML/PDF - might be binary or other
        # Still try to compile, might work
    
    return ""


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

def process_one_paper(src_path, out_dir, lpsb_root, use_ramdisk=False, disable_bbl_underscore_fix=False, container_name=None):
    """Process a single paper directory or file.
    
    Args:
        src_path: Path to paper source (directory, .tex, or .gz file)
        out_dir: Output directory for results
        lpsb_root: Path to LPSB root directory
        use_ramdisk: Use /dev/shm for temp workspace
        disable_bbl_underscore_fix: Disable .bbl underscore workaround
        container_name: Optional pre-started Docker container name for reuse.
                        If provided, uses docker exec instead of docker run.
    """
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

        # 1b. Check for withdrawn placeholders or non-TeX content
        invalid_status = _detect_withdrawn_or_invalid(work_dir)
        if invalid_status:
            with open(log_file, 'a') as log:
                log.write(f"Error: {invalid_status} (source is not valid TeX)\n")
            return invalid_status

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

        stage_b_engine = os.environ.get("LPSB_STAGE_B_ENGINE", "latexml").strip().lower()
        if stage_b_engine not in ("lua", "latexml", "none"):
            stage_b_engine = "latexml"

        # 3. Compile (gold pipeline only)
        pdflatex_dir = work_dir / "_pdflatex"
        lualatex_dir = work_dir / "_lualatex"
        latexml_dir = work_dir / "_latexml"
        if pdflatex_dir.exists():
            shutil.rmtree(pdflatex_dir, ignore_errors=True)
        if lualatex_dir.exists():
            shutil.rmtree(lualatex_dir, ignore_errors=True)
        if latexml_dir.exists():
            shutil.rmtree(latexml_dir, ignore_errors=True)

        ignore = shutil.ignore_patterns("_pdflatex", "_lualatex", "_latexml")
        shutil.copytree(work_dir, pdflatex_dir, ignore=ignore)
        if stage_b_engine == "lua":
            shutil.copytree(work_dir, lualatex_dir, ignore=ignore)
        elif stage_b_engine == "latexml":
            shutil.copytree(work_dir, latexml_dir, ignore=ignore)

        pd_tex_dir = pdflatex_dir if tex_dir_rel == "." else (pdflatex_dir / tex_dir_rel)
        pd_tex_dir.mkdir(parents=True, exist_ok=True)
        lua_tex_dir = None
        latexml_tex_dir = None
        if stage_b_engine == "lua":
            lua_tex_dir = lualatex_dir if tex_dir_rel == "." else (lualatex_dir / tex_dir_rel)
            lua_tex_dir.mkdir(parents=True, exist_ok=True)
        elif stage_b_engine == "latexml":
            latexml_tex_dir = latexml_dir if tex_dir_rel == "." else (latexml_dir / tex_dir_rel)
            latexml_tex_dir.mkdir(parents=True, exist_ok=True)

        def _copy_if_exists(name: str, dst_dir: Path) -> None:
            src = lpsb_root / name
            if not src.exists():
                src = lpsb_root.parent / name
            if src.exists():
                shutil.copy(src, dst_dir / name)

        def _collect_successful_packages(work_dir: Path, tl_version: str):
            """Collect custom .sty/.cls/.bst files from successful compilations."""
            # Define collection root (organized by TL version + extension)
            collect_root = lpsb_root / "arxiv_stubs" / "collected" / f"TL{tl_version}"
            try:
                collect_root.mkdir(parents=True, exist_ok=True)
            except Exception:
                return

            # Extensions to collect
            exts = {".sty", ".cls", ".bst", ".clo"}
            
            # Files to ignore (avoid polluting the stub set with LPSB itself or TeX Live core).
            #
            # NOTE: Copying "core" packages into the working directory is actively harmful:
            # TeX will prefer ./foo.sty over the distro version, and you end up with a random,
            # possibly mismatched package version that can break output (including producing
            # garbage text in the PDF).
            ignore_files = {
                "lpsb.sty",
                "lpsb-luamath.sty",
                "lpsb-luatable.sty",
                "lpsb-latexml.sty",
            }
            deny_exact = {
                # biblatex/biber core (should NEVER be sourced from random papers).
                "biblatex.sty",
                "biblatex.def",
                "biber",
                "biber.exe",
                # LaTeX3 / kernel-ish.
                "expl3.sty",
                "xparse.sty",
            }
            deny_prefixes = (
                "biblatex",
                "blx-",
                "l3",
                "expl3",
                "latex",
            )

            def _deny_collect(name: str) -> bool:
                n = (name or "").strip().lower()
                if not n:
                    return True
                if n in ignore_files:
                    return True
                if n in deny_exact:
                    return True
                for pfx in deny_prefixes:
                    if n.startswith(pfx):
                        return True
                return False
            
            # Traverse work_dir and copy interesting files
            for root, dirs, files in os.walk(work_dir):
                # Skip hidden dirs
                dirs[:] = [d for d in dirs if not d.startswith(('.', '_'))]
                
                for f in files:
                    if Path(f).suffix.lower() in exts and not _deny_collect(f):
                        src = Path(root) / f
                        subdir = src.suffix.lower().lstrip(".")
                        dst = collect_root / subdir / f
                        # Only copy if not already in collection (first come first served, or overwrite?)
                        # Let's overwrite to get latest versions found from papers
                        try:
                            (collect_root / subdir).mkdir(parents=True, exist_ok=True)
                            # Check if file is non-standard (heuristic: don't copy if it's potentially huge or irrelevant)
                            if src.stat().st_size < 1024 * 1024: # Limit to 1MB
                                shutil.copy2(src, dst)
                        except Exception:
                            pass

        def _copy_collected_packages(dst_dir: Path, tl_version: str):
            """Return a function that copies a requested stub file into dst_dir.
            
            Search order:
            1. Own TL version (arxiv_stubs/collected/TL{tl_version}/)
            2. All other TL versions (newest first)
            3. arxiv_stubs/manual/ (manual stubs)
            """
            stubs_root = lpsb_root / "arxiv_stubs"
            if not stubs_root.exists():
                stubs_root = lpsb_root.parent / "arxiv_stubs"

            collected_root = stubs_root / "collected"
            if not collected_root.exists():
                # Legacy layout (pre-2026-01): top-level collected dir.
                legacy = lpsb_root / "arxiv_stubs_collected"
                if not legacy.exists():
                    legacy = lpsb_root.parent / "arxiv_stubs_collected"
                if legacy.exists():
                    collected_root = legacy

            manual_root = stubs_root / "manual"
            if not manual_root.exists():
                # Legacy layout: curated files lived directly under arxiv_stubs/.
                manual_root = stubs_root

            deny_exact = {
                # Never inject TeX Live core packages into ./ ; they override distro files.
                "biblatex.sty",
                "biblatex.def",
                "blx-case-expl3.sty",
                "biber",
                "biber.exe",
                "expl3.sty",
                "xparse.sty",
            }
            deny_prefixes = (
                "biblatex",
                "blx-",
                "l3",
                "expl3",
                "latex",
            )

            def _deny_copy(name: str) -> bool:
                n = (name or "").strip().lower()
                if not n:
                    return True
                if n in deny_exact:
                    return True
                for pfx in deny_prefixes:
                    if n.startswith(pfx):
                        return True
                return False

            def _copy_one_exact(name: str) -> bool:
                if _deny_copy(name):
                    return False

                ext = Path(name).suffix.lower().lstrip(".")
                # Collected stubs are organized by extension subdir (sty/cls/bst/clo).
                subdirs = [ext] if ext in ("sty", "cls", "bst", "clo") else []

                # Search collected roots first (fast direct path).
                for tl_dir in tl_dirs:
                    for sd in subdirs:
                        cand = tl_dir / sd / name
                        if cand.exists():
                            try:
                                shutil.copy2(cand, dst_dir / name)
                                return True
                            except Exception:
                                return False

                # Manual stubs may be nested. Keep it exact-name only.
                if manual_root.exists():
                    try:
                        for cand in manual_root.rglob(name):
                            if cand.is_file():
                                shutil.copy2(cand, dst_dir / name)
                                return True
                    except Exception:
                        pass
                return False
            
            tl_dirs = []
            if tl_version and re.fullmatch(r"\d{4}", tl_version):
                # Get all TL version dirs, prioritize own version then sort descending
                own_dir = collected_root / f"TL{tl_version}"
                if own_dir.exists():
                    tl_dirs.append(own_dir)

                # Add other TL versions (newest first)
                if collected_root.exists():
                    for d in sorted(collected_root.iterdir(), reverse=True):
                        if d.is_dir() and d.name.startswith("TL") and d != own_dir:
                            tl_dirs.append(d)

            # Filename aliases: some upstream bundles use patch-level filenames (e.g. aastex631.cls),
            # while sources expect the shorter historic name (aastex63.cls). Allow a controlled rename.
            stub_aliases = {
                "aastex63.cls": ["aastex631.cls"],
                "aastex7.cls": ["aastex701.cls"],
            }

            def _copy_one(name: str) -> bool:
                # Exact first.
                if _copy_one_exact(name):
                    return True
                # Alias: copy candidate as target name.
                for cand in stub_aliases.get(name, []):
                    if _copy_one_exact(cand):
                        try:
                            shutil.copy2(dst_dir / cand, dst_dir / name)
                            return True
                        except Exception:
                            return False
                return False

            return _copy_one

        # Like batch_compile_all.sh: pdflatex needs only lpsb.sty.
        _copy_if_exists("lpsb.sty", pd_tex_dir)
        if stage_b_engine == "lua" and lua_tex_dir is not None:
            # Lua stage: structure + math/table enrich.
            _copy_if_exists("lpsb.sty", lua_tex_dir)
            _copy_if_exists("lpsb-luamath.sty", lua_tex_dir)
            _copy_if_exists("lpsb-math.lua", lua_tex_dir)
            _copy_if_exists("lpsb-luatable.sty", lua_tex_dir)
            _copy_if_exists("lpsb-table.lua", lua_tex_dir)
        if stage_b_engine == "latexml" and latexml_tex_dir is not None:
            _copy_if_exists("lpsb.sty", latexml_tex_dir)
            _copy_if_exists("lpsb.sty.ltxml", latexml_tex_dir)
            _copy_if_exists("lpsb-latexml.sty", latexml_tex_dir)

        pd_main_tex_full = pdflatex_dir / main_tex
        _inject_pkg_after_documentclass(pd_main_tex_full, "lpsb")
        lua_main_tex_full = None
        if stage_b_engine == "lua":
            lua_main_tex_full = lualatex_dir / main_tex
            _inject_pkg_after_documentclass(lua_main_tex_full, "lpsb")
            _inject_pkg_after_documentclass(lua_main_tex_full, "lpsb-luamath")
            _inject_pkg_after_documentclass(lua_main_tex_full, "lpsb-luatable")
        if stage_b_engine == "latexml":
            _inject_pkg_after_documentclass(latexml_dir / main_tex, "lpsb")

        docker_image, selected_tl, selected_reason = _select_docker_image(work_dir, tex_dir_rel, main_base, paper_id)

        # Stub injection must be on-demand: dumping a whole stub set into the build dir is
        # wrong (it overrides TeX Live and can break output). We'll only copy stubs that
        # pdflatex/bibtex/biber actually report as missing.
        copy_stub_pd = _copy_collected_packages(pd_tex_dir, selected_tl)
        copy_stub_lua = _copy_collected_packages(lua_tex_dir, selected_tl) if lua_tex_dir is not None else None
        copy_stub_latexml = _copy_collected_packages(latexml_tex_dir, selected_tl) if latexml_tex_dir is not None else None

        with open(log_file, "w") as log:
            log.write(f"Docker image: {docker_image}\n")
            if selected_tl:
                log.write(f"TeX Live selected: {selected_tl}\n")
            log.write(f"TeX Live reason: {selected_reason}\n")

        pd_container_wd = "/workdir" if tex_dir_rel == "." else f"/workdir/{tex_dir_rel}"
        lua_container_wd = "/workdir" if tex_dir_rel == "." else f"/workdir/{tex_dir_rel}"
        latexml_container_wd = "/workdir" if tex_dir_rel == "." else f"/workdir/{tex_dir_rel}"

        container_counter = [0]  # mutable for closure
        
        def _run(
            stage_dir: Path,
            container_wd: str,
            cmd: list,
            timeout: int,
            extra_mounts: list = None,
            extra_env: dict = None,
        ) -> int:
            """Run command in Docker with proper timeout handling.
            
            If container_name (from outer scope) is provided, uses docker exec
            for container reuse. Otherwise, uses docker run (creates new container).
            """
            container_counter[0] += 1
            
            with open(log_file, "a") as log:
                try:
                    log.write("\n=== RUN: " + " ".join(cmd) + " ===\n")
                    
                    # Container reuse mode: use docker exec
                    if container_name is not None:
                        # Compute the working directory relative to the shared /workdir mount
                        # In reuse mode, stage_dir should be under out_dir/build/paper_id
                        # which maps to /workdir/build/paper_id inside the container
                        try:
                            rel_stage = stage_dir.relative_to(out_dir)
                            exec_wd = f"/workdir/{rel_stage}"
                            if container_wd != "/workdir":
                                # Append any sub-path from container_wd
                                subpath = container_wd.replace("/workdir", "", 1).lstrip("/")
                                if subpath:
                                    exec_wd = f"{exec_wd}/{subpath}"
                        except ValueError:
                            # stage_dir not under out_dir, use container_wd as-is
                            exec_wd = container_wd
                        
                        exec_cmd = ["docker", "exec", "-w", exec_wd, container_name] + cmd
                        r = subprocess.run(exec_cmd, stdout=log, stderr=subprocess.STDOUT, timeout=timeout, check=False)
                        log.write(f"=== EXIT: {cmd[0]} rc={r.returncode} ===\n")
                        return r.returncode
                    
                    # Fresh container mode: use docker run
                    tmp_container_name = f"lpsb_{paper_id}_{container_counter[0]}_{os.getpid()}"
                    
                    docker_cmd = [
                        "docker", "run", "--rm",
                        "--name", tmp_container_name,
                        # Always mount the whole stage at /workdir; set -w separately.
                        # Mounting at a subdir breaks relative paths and makes it impossible
                        # for TeX to access sibling/parent resources.
                        "-v", f"{stage_dir}:/workdir",
                        "--net", "none",
                        "-w", container_wd,
                    ]
                    if extra_mounts:
                        for m in extra_mounts:
                            try:
                                host_path, container_path = m
                            except Exception:
                                continue
                            if host_path and container_path:
                                docker_cmd += ["-v", f"{host_path}:{container_path}"]
                    if extra_env:
                        for k, v in extra_env.items():
                            if k and v is not None:
                                docker_cmd += ["-e", f"{k}={v}"]
                    docker_cmd += [docker_image] + cmd
                    r = subprocess.run(docker_cmd, stdout=log, stderr=subprocess.STDOUT, timeout=timeout, check=False)
                    log.write(f"=== EXIT: {cmd[0]} rc={r.returncode} ===\n")
                    return r.returncode
                except subprocess.TimeoutExpired:
                    log.write("\nError: TIMEOUT - killing container\n")
                    # Kill the container explicitly (only for docker run mode)
                    if container_name is None:
                        tmp_container_name = f"lpsb_{paper_id}_{container_counter[0]}_{os.getpid()}"
                        try:
                            subprocess.run(["docker", "kill", tmp_container_name], 
                                          capture_output=True, timeout=10)
                        except:
                            pass
                        try:
                            subprocess.run(["docker", "rm", "-f", tmp_container_name],
                                          capture_output=True, timeout=10)
                        except:
                            pass
                    return 124


        if not disable_bbl_underscore_fix:
            # Preflight: some papers ship a pre-generated .bbl that is read on the *first* pdflatex pass.
            # If it contains raw '_' in \\bibitem keys, pdflatex can fail before we get a chance to
            # detect and inject a workaround. Detect early and inject before the first run.
            pre_bbl = pd_tex_dir / f"{main_base}.bbl"
            pre_bbltex = pd_tex_dir / "bbl.tex"
            pre_any_bbl = []
            try:
                pre_any_bbl = sorted(pd_tex_dir.glob("*.bbl"))[:5]
            except Exception:
                pre_any_bbl = []
            preflight_underscore = False
            if (pre_bbl.exists() and _bbl_has_unsafe_bibitem_key(pre_bbl)) or _tex_has_unsafe_bibitem_key(pre_bbltex):
                preflight_underscore = True
            else:
                for b in pre_any_bbl:
                    if _bbl_has_unsafe_bibitem_key(b):
                        preflight_underscore = True
                        break
                if preflight_underscore:
                    _inject_bbl_underscore_catcode_fix(pd_main_tex_full)
                    if lua_main_tex_full is not None:
                        _inject_bbl_underscore_catcode_fix(lua_main_tex_full)
                    with open(log_file, "a") as log:
                        log.write("\nInfo: Preflight detected '_' in bibliography \\bibitem keys; enabled LPSB_BBL_UNDERSCORE_FIX\n")

        # Stage A: pdflatex gold (3 passes)
        with open(log_file, "a") as log:
            log.write("\n=== Stage A: pdflatex (gold) ===\n")
        had_rc_error = False
        missing_seen = set()
        for attempt in range(1, 6):
            rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
            had_rc_error |= (rc != 0)
            miss = _scan_log_for_missing_tex_inputs(pd_tex_dir / f"{main_base}.log")
            miss = {m for m in miss if m not in missing_seen}
            if not miss:
                break
            copied_any = False
            for name in sorted(miss):
                try:
                    if copy_stub_pd(name):
                        copied_any = True
                        missing_seen.add(name)
                except Exception:
                    pass
            if copied_any:
                with open(log_file, "a") as log:
                    log.write(f"\nInfo: copied missing stubs into build dir: {', '.join(sorted(miss))}\n")
                continue
            break

        # Bibliography for gold: detect from generated aux/bcf, not by grepping the source.
        aux0 = pd_tex_dir / f"{main_base}.aux"
        if (pd_tex_dir / f"{main_base}.bbl").exists():
            pass
        elif _bcf_exists(pd_tex_dir, main_base) or _file_mentions(pd_main_tex_full, "biblatex"):
            rc = _run(pdflatex_dir, pd_container_wd, ["biber", main_base], TIMEOUT_SEC)
            had_rc_error |= (rc != 0)
        elif _aux_mentions_bibdata(aux0):
            rc = _run(pdflatex_dir, pd_container_wd, ["bibtex", main_base], TIMEOUT_SEC)
            had_rc_error |= (rc != 0)

        if not disable_bbl_underscore_fix:
            # If the bibliography includes raw underscores in \bibitem keys, TeX will
            # throw "Missing $ inserted." when reading the .bbl. Mitigate by applying a
            # localized catcode fix for '_' only while inputting \jobname.bbl.
            bbl = pd_tex_dir / f"{main_base}.bbl"
            bbltex = pd_tex_dir / "bbl.tex"
            if (bbl.exists() and _bbl_has_unsafe_bibitem_key(bbl)) or _tex_has_unsafe_bibitem_key(bbltex):
                _inject_bbl_underscore_catcode_fix(pd_main_tex_full)
                if lua_main_tex_full is not None:
                    _inject_bbl_underscore_catcode_fix(lua_main_tex_full)
                with open(log_file, "a") as log:
                    log.write("\nInfo: Detected '_' in .bbl \\\\bibitem keys; enabled LPSB_BBL_UNDERSCORE_FIX\n")

        rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
        had_rc_error |= (rc != 0)
        rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
        had_rc_error |= (rc != 0)

        aux_file = pd_tex_dir / f"{main_base}.aux"
        pdf_file = pd_tex_dir / f"{main_base}.pdf"
        dvi_file = pd_tex_dir / f"{main_base}.dvi"
        json_file = pd_tex_dir / f"{main_base}.lpsb.json"
        
        # DVI-to-PDF fallback: some legacy documents produce DVI instead of PDF
        # (e.g., using dvips.def or explicit DVI mode). Convert using dvipdf.
        if not pdf_file.exists() and dvi_file.exists():
            with open(log_file, "a") as log:
                log.write("\nInfo: DVI file detected, converting to PDF with dvipdf\n")
            rc_dvipdf = _run(pdflatex_dir, pd_container_wd, 
                            ["dvipdf", f"{main_base}.dvi", f"{main_base}.pdf"], 
                            TIMEOUT_SEC)
            if rc_dvipdf != 0:
                with open(log_file, "a") as log:
                    log.write(f"Warning: dvipdf returned {rc_dvipdf}\n")
        
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

        # If gold artifacts are missing, try targeted retries for known high-impact, fixable errors.
        if not (aux_file.exists() and pdf_file.exists() and json_file.exists()):
            natbib_err = "Package natbib Error: Bibliography not compatible with author-year citations."
            try:
                log_txt = Path(log_file).read_text(errors="ignore")
            except Exception:
                log_txt = ""

                if natbib_err in log_txt:
                    # Off by default: this injects code into the staged main .tex, which some users
                    # consider too invasive. Enable explicitly via env var.
                    if _env_truthy("LPSB_ENABLE_NATBIB_NUMBERS_FIX"):
                        _inject_natbib_numbers_fix(pd_main_tex_full)
                        if lua_main_tex_full is not None:
                            _inject_natbib_numbers_fix(lua_main_tex_full)
                        with open(log_file, "a") as log:
                            log.write("\nInfo: Detected natbib author-year incompatibility; enabled LPSB_NATBIB_NUMBERS_FIX and retrying gold passes\n")
                    rc1 = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
                    rc2 = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
                    # If the retry succeeded cleanly, treat earlier RCs as superseded by the fix.
                    if rc1 == 0 and rc2 == 0:
                        had_rc_error = False

                    # Re-check artifacts and re-copy outputs for users.
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
                else:
                    with open(log_file, "a") as log:
                        log.write("\nInfo: Detected natbib author-year incompatibility; LPSB_NATBIB_NUMBERS_FIX is disabled (set LPSB_ENABLE_NATBIB_NUMBERS_FIX=1 to enable)\n")

            if not (aux_file.exists() and pdf_file.exists() and json_file.exists()):
                with open(log_file, 'a') as log:
                    log.write("\nError: COMPILATION_FAILED (missing gold artifacts)\n")
                return "FAIL"

        # If pdflatex returned non-zero at any point but we have valid artifacts, continue with enrichment.
        # Many LaTeX runs return rc=1 due to warnings (undefined refs, hyperref issues) but still produce
        # valid PDF and JSON. We should not skip enrichment for these cases.
        if had_rc_error:
            if aux_file.exists() and pdf_file.exists() and json_file.exists():
                with open(log_file, "a") as log:
                    log.write("\nWarning: pdflatex had non-zero return code but artifacts exist; continuing with enrichment\n")
            else:
                with open(log_file, "a") as log:
                    log.write("\nError: NONZERO_RETURN_CODE (gold stage) and missing artifacts\n")
                return "FAIL_LATEX_RC"

        # Stage B: optional enrichment (LuaLaTeX or LaTeXML). Non-fatal: gold artifacts already exist.
        math_json = None
        table_json = None
        had_rc_error_stage_b = False

        if stage_b_engine == "lua" and lua_tex_dir is not None and lua_main_tex_full is not None:
            with open(log_file, "a") as log:
                log.write("\n=== Stage B: lualatex (enrichment) ===\n")
            rc = _run(lualatex_dir, lua_container_wd, ["lualatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
            had_rc_error_stage_b |= (rc != 0)
            aux1 = lua_tex_dir / f"{main_base}.aux"
            if (lua_tex_dir / f"{main_base}.bbl").exists():
                pass
            elif _bcf_exists(lua_tex_dir, main_base) or _file_mentions(lua_main_tex_full, "biblatex"):
                rc = _run(lualatex_dir, lua_container_wd, ["biber", main_base], TIMEOUT_SEC)
                had_rc_error_stage_b |= (rc != 0)
            elif _aux_mentions_bibdata(aux1):
                rc = _run(lualatex_dir, lua_container_wd, ["bibtex", main_base], TIMEOUT_SEC)
                had_rc_error_stage_b |= (rc != 0)
            rc = _run(lualatex_dir, lua_container_wd, ["lualatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
            had_rc_error_stage_b |= (rc != 0)
            rc = _run(lualatex_dir, lua_container_wd, ["lualatex", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
            had_rc_error_stage_b |= (rc != 0)

            mj = lua_tex_dir / f"{main_base}.lpsb-math.json"
            tj = lua_tex_dir / f"{main_base}.lpsb-table.json"
            if mj.exists():
                math_json = mj
            if tj.exists():
                table_json = tj

        elif stage_b_engine == "latexml" and latexml_tex_dir is not None:
            with open(log_file, "a") as log:
                log.write("\n=== Stage B: latexml (math/table) ===\n")
            latexml_xhtml = latexml_tex_dir / f"{main_base}.latexml.xhtml"
            latexml_xml = latexml_tex_dir / f"{main_base}.latexml.xml"
            latexml_log = latexml_tex_dir / f"{main_base}.latexml.log"
            latexml_timeout = 600
            try:
                latexml_timeout = int(os.environ.get("LPSB_LATEXML_TIMEOUT_SEC", "600"))
            except Exception:
                latexml_timeout = 600

            script = (
                "set -euo pipefail\n"
                f"main='{main_tex_basename}'\n"
                f"xml='{latexml_xml.name}'\n"
                f"xhtml='{latexml_xhtml.name}'\n"
                f"log='{latexml_log.name}'\n"
                "rm -f \"$xml\" \"$xhtml\" \"$log\" || true\n"
                "mkdir -p \"${HOME:-/tmp}\" || true\n"
                "if [ -n \"${XDG_CACHE_HOME:-}\" ]; then mkdir -p \"$XDG_CACHE_HOME\" || true; fi\n"
                "if command -v latexmlc >/dev/null 2>&1; then\n"
                "  (latexmlc --format=xhtml --pmml --nographicimages --nopictureimages --nosvg --dest=\"$xhtml\" \"$main\" || latexmlc --format=xhtml --pmml --nographicimages --nopictureimages --nosvg --destination=\"$xhtml\" \"$main\") >\"$log\" 2>&1 || exit $?\n"
                "elif command -v latexml >/dev/null 2>&1 && command -v latexmlpost >/dev/null 2>&1; then\n"
                "  (latexml --dest=\"$xml\" \"$main\" || latexml --destination=\"$xml\" \"$main\") >\"$log\" 2>&1 || exit $?\n"
                "  (latexmlpost --format=xhtml --pmml --nographicimages --nopictureimages --nosvg --dest=\"$xhtml\" \"$xml\" || latexmlpost --format=xhtml --pmml --nographicimages --nopictureimages --nosvg --destination=\"$xhtml\" \"$xml\") >>\"$log\" 2>&1 || exit $?\n"
                "else\n"
                "  echo 'Error: latexml not installed in this image' >\"$log\"\n"
                "  exit 127\n"
                "fi\n"
                "test -s \"$xhtml\"\n"
            )
            # Persist LaTeXML caches (notably expl3) across runs, keyed by TeX Live year.
            # LaTeXML typically caches under $HOME; we mount a stable host directory and
            # point HOME/XDG_CACHE_HOME at it to reuse caches in subsequent compilations.
            # https://github.com/brucemiller/LaTeXML/issues/2064
            latexml_cache_flag = os.environ.get("LPSB_LATEXML_CACHE", "1").strip().lower()
            latexml_extra_mounts = []
            latexml_extra_env = {}
            if latexml_cache_flag not in ("", "0", "false", "no"):
                cache_base_env = os.environ.get("LPSB_LATEXML_CACHE_ROOT", "").strip()
                cache_base = Path(cache_base_env) if cache_base_env else (lpsb_root / "latexml_cache")
                tl_key = selected_tl if (selected_tl and re.fullmatch(r"\d{4}", selected_tl)) else "unknown"
                cache_dir = cache_base / f"TL{tl_key}"
                try:
                    cache_dir.mkdir(parents=True, exist_ok=True)
                    latexml_extra_mounts.append((str(cache_dir), "/lpsb_latexml_cache"))
                    latexml_extra_env["HOME"] = "/lpsb_latexml_cache/home"
                    latexml_extra_env["XDG_CACHE_HOME"] = "/lpsb_latexml_cache/xdg-cache"
                    with open(log_file, "a") as log:
                        log.write(f"\nInfo: LaTeXML cache enabled: {cache_dir}\n")
                except Exception:
                    with open(log_file, "a") as log:
                        log.write("\nWarning: Failed to initialize LaTeXML cache dir; continuing without cache\n")
            else:
                with open(log_file, "a") as log:
                    log.write(f"\nInfo: LaTeXML cache disabled (LPSB_LATEXML_CACHE={latexml_cache_flag})\n")
            rc = _run(
                latexml_dir,
                latexml_container_wd,
                ["bash", "-lc", script],
                latexml_timeout,
                extra_mounts=latexml_extra_mounts,
                extra_env=latexml_extra_env,
            )
            had_rc_error_stage_b |= (rc != 0)

            if latexml_xhtml.exists():
                conv_script = lpsb_root / "script" / "latexml_to_lpsb.py"
                if not conv_script.exists():
                    conv_script = lpsb_root / "latexml_to_lpsb.py"
                out_math = latexml_tex_dir / f"{main_base}.lpsb-math.latexml.json"
                out_table = latexml_tex_dir / f"{main_base}.lpsb-table.latexml.json"
                if conv_script.exists():
                    cmd = [
                        sys.executable,
                        str(conv_script),
                        "--structure",
                        str(json_file),
                        "--xhtml",
                        str(latexml_xhtml),
                        "--out-math",
                        str(out_math),
                        "--out-table",
                        str(out_table),
                    ]
                    with open(log_file, "a") as log:
                        log.write("\n=== LaTeXML→LPSB (math/table) ===\n")
                        subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT, check=False)
                    if out_math.exists():
                        math_json = out_math
                    if out_table.exists():
                        table_json = out_table
                else:
                    with open(log_file, "a") as log:
                        log.write("\nWarning: latexml_to_lpsb.py not found, skipping LaTeXML conversion\n")
            else:
                with open(log_file, "a") as log:
                    log.write("\nWarning: latexml did not produce XHTML, skipping LaTeXML merge\n")

        # Merge (math/table) into the gold structure stream, if any sidecar exists.
        if (math_json and math_json.exists()) or (table_json and table_json.exists()):
            merged_json = work_dir / f"{main_base}.lpsb.merged.json"
            merge_script = lpsb_root / "script" / "merge_lpsb.py"
            if not merge_script.exists():
                merge_script = lpsb_root / "merge_lpsb.py"
            if merge_script.exists():
                # merge_lpsb.py requires positional args; pass a non-existent math file path when absent.
                math_arg = str(math_json) if (math_json and math_json.exists()) else str(Path(str(json_file)).with_suffix(".lpsb-math.json"))
                cmd = [sys.executable, str(merge_script), str(json_file), math_arg, str(merged_json)]
                if table_json and table_json.exists():
                    cmd.append(str(table_json))
                with open(log_file, "a") as log:
                    log.write("\n=== Merge (math/table) ===\n")
                    subprocess.run(cmd, stdout=log, stderr=subprocess.STDOUT, check=False)
                if merged_json.exists():
                    json_file = merged_json
            else:
                with open(log_file, "a") as log:
                    log.write("\nWarning: merge_lpsb.py not found, skipping merge\n")

        # 5. Enrich Positions
        
        if not (aux_file.exists() and pdf_file.exists() and json_file.exists()):
            with open(log_file, 'a') as log:
                log.write("\nError: COMPILATION_FAILED (missing artifacts)\n")
            return "FAIL"

        if had_rc_error_stage_b:
            with open(log_file, "a") as log:
                log.write(f"\nWarning: NONZERO_RETURN_CODE (stage_b={stage_b_engine}) - continuing with gold artifacts\n")
            
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
            r = subprocess.run(enrich_cmd, stdout=log, stderr=subprocess.STDOUT, timeout=180, check=False)
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
        
        # Final sanity: if log indicates fatal errors or broken citations, do not claim success.
        issues = _scan_compile_log_for_issues(log_file)
        # Undefined references may require one more LaTeX pass, but in batch mode we already did 3 passes.
        # Treat fatal errors as hard failures; refs/citations/bib problems can be made strict via env vars.
        strict_refs = os.environ.get("LPSB_STRICT_UNDEF_REFS", "").strip() not in ("", "0", "false", "False")
        strict_citations = os.environ.get("LPSB_STRICT_UNDEF_CIT", "").strip() not in ("", "0", "false", "False")
        strict_bib = os.environ.get("LPSB_STRICT_BIBTEX", "").strip() not in ("", "0", "false", "False")
        if issues["fatal"]:
            with open(log_file, "a") as log:
                log.write("\nError: LOG_DETECTED_FATAL_LATEX_ERROR\n")
            return "FAIL_LATEX_LOG"
        if strict_citations and issues["undef_citation"]:
            with open(log_file, "a") as log:
                log.write("\nError: LOG_DETECTED_UNDEFINED_CITATIONS (strict)\n")
            return "FAIL_UNDEF_CIT"
        if strict_bib and issues["bibtex_problem"]:
            with open(log_file, "a") as log:
                log.write("\nError: LOG_DETECTED_BIBTEX_PROBLEM (strict)\n")
            return "FAIL_BIB"
        if strict_refs and issues["undef_reference"]:
            with open(log_file, "a") as log:
                log.write("\nError: LOG_DETECTED_UNDEFINED_REFERENCES (strict)\n")
            return "FAIL_UNDEF_REF"

        # Log Stage B errors count (informational, not a failure)
        if issues.get("stage_b_errors", 0) > 0:
            with open(log_file, "a") as log:
                log.write(f"\nInfo: Stage B (lualatex enrichment) had {issues['stage_b_errors']} errors (non-fatal, gold PDF already produced)\n")

        # Success! Collect any custom packages for future reuse
        if selected_tl:
            _collect_successful_packages(work_dir, selected_tl)

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

# Global container pool reference (set by main process before forking workers)
_CONTAINER_POOL = None
_CONTAINER_NAMES = []  # List of container names for workers to use

def batch_worker(args):
    """Worker function for batch processing.
    
    Args is a tuple: (src_path, out_dir, lpsb_root, use_ramdisk, disable_bbl_underscore_fix, container_name)
    """
    return process_one_paper(*args)

def main():
    parser = argparse.ArgumentParser(description="LPSB Compiler")
    parser.add_argument('--single', help="Compile a single paper directory")
    parser.add_argument('--batch', help="Compile all subdirectories in this path")
    parser.add_argument('--output', '-o', required=True, help="Output directory")
    parser.add_argument('--no-ramdisk', action='store_true', help="Disable RAM disk workspace (default: enabled if /dev/shm exists)")
    parser.add_argument('--workers', type=int, default=16, help="Number of parallel workers")
    parser.add_argument('--limit', type=int, default=0, help="Limit number of items processed in batch mode (0 = no limit)")
    parser.add_argument('--reuse-containers', action='store_true',
                        help="Reuse Docker containers across papers (faster, requires --no-ramdisk)")
    
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
        # Prefer directory-per-paper layout when present (common for extracted corpora
        # and for our own cached build dirs). This avoids treating every auxiliary
        # *.tex file inside a paper as a separate "paper".
        try:
            paper_dirs = [
                p for p in src_root.iterdir()
                if p.is_dir() and re.fullmatch(r"\d{4}\.\d{5}", p.name or "")
            ]
        except Exception:
            paper_dirs = []

        if paper_dirs:
            papers = sorted(paper_dirs)
        else:
            # Recursive discovery (archive or single-tex layout)
            papers.extend(src_root.rglob("*.gz"))
            papers.extend(src_root.rglob("*.tex"))
            # Remove duplicates
            papers = sorted(list(set(papers)))
        if args.limit and args.limit > 0:
            papers = papers[:args.limit]
        
        print(f"Processing BATCH of {len(papers)} items using {args.workers} workers")
        print(f"Output: {args.output}")
        if not args.no_ramdisk:
            print("Using RAM disk for workspace (default)")
        
        # Container reuse mode
        container_pool = None
        container_names = []
        use_container_reuse = args.reuse_containers
        
        if use_container_reuse:
            if not args.no_ramdisk:
                print("Warning: --reuse-containers requires --no-ramdisk, enabling --no-ramdisk")
                args.no_ramdisk = True
            
            out_path = Path(args.output).resolve()
            out_path.mkdir(parents=True, exist_ok=True)
            
            # Start container pool (one container per worker)
            print(f"Starting {args.workers} Docker containers for reuse...")
            container_pool = DockerContainerPool(
                image=LPSB_IMAGE,
                shared_volume=out_path,
                pool_size=args.workers
            )
            try:
                container_pool.start()
                container_names = container_pool.containers[:]
                print(f"Started containers: {', '.join(container_names)}")
            except Exception as e:
                print(f"Failed to start container pool: {e}")
                print("Falling back to non-reuse mode")
                use_container_reuse = False
                container_names = []
        
        tasks = []
        for i, p in enumerate(papers):
            # Assign container to task based on index (round-robin across workers)
            cname = container_names[i % len(container_names)] if container_names else None
            tasks.append((p, args.output, lpsb_root, not args.no_ramdisk, False, cname))
            
        results = {'SUCCESS': 0, 'FAIL': 0, 'TIMEOUT': 0, 'ERROR': 0, 'NO_MAIN': 0}
        
        with ProcessPoolExecutor(max_workers=args.workers) as executor:
            futures = {executor.submit(batch_worker, task): task[0].name for task in tasks}
            
            # Use tqdm for progress bar if available
            if HAS_TQDM:
                pbar = tqdm(as_completed(futures), total=len(futures), desc="Compiling", unit="paper")
            else:
                pbar = as_completed(futures)
            
            for f in pbar:
                pid = futures[f]
                try:
                    res = f.result()
                    # Track WITHDRAWN and NOT_TEX as SKIPPED (source issues, not LPSB bugs)
                    if res in ('WITHDRAWN', 'NOT_TEX'):
                        results['SKIPPED'] = results.get('SKIPPED', 0) + 1
                    else:
                        results[res] = results.get(res, 0) + 1
                    if HAS_TQDM:
                        pbar.set_postfix(
                            S=results.get('SUCCESS', 0), 
                            F=results.get('FAIL', 0), 
                            Skip=results.get('SKIPPED', 0)
                        )
                    else:
                        print(f"[{res}] {pid}")
                except Exception as e:
                    if HAS_TQDM:
                        pbar.set_postfix(S=results.get('SUCCESS', 0), F=results.get('FAIL', 0), E=results.get('ERROR', 0)+1)
                    else:
                        print(f"[CRASH] {pid}: {e}")
                    results['ERROR'] = results.get('ERROR', 0) + 1
                    
        print("\nSummary:")
        print(results)
        
        # Clean up container pool
        if container_pool is not None:
            print("Stopping Docker containers...")
            container_pool.stop()
            print("Containers stopped.")
        

    else:
        parser.print_help()

if __name__ == '__main__':
    main()
