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
import time
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, as_completed
from tqdm import tqdm

# Configuration
LPSB_IMAGE = "lpsb-texlive:latest"
TIMEOUT_SEC = 300  # 5 mins per paper

# Auto-verification: When compilation fails, retry without LPSB injection
# to determine if failure is LPSB-caused (TRUE_FAIL) or source-inherent (FALSE_POSITIVE)
VERIFY_ON_FAIL = True
VERIFY_TIMEOUT_SEC = 120  # Shorter timeout for verification pass

import re
import json
from typing import Tuple
import threading
import atexit

# Import post-processing modules for direct function calls (no subprocess overhead)
from .postprocess.fix_split_headings import merge_split_headings_aux, retag_pdf_mcid_types
from .postprocess.merge_split_paragraphs import merge_split_paragraphs as merge_split_paragraphs_func
from .parsing.parse_lpsb_mcid import parse_aux_file, elements_to_json, reconcile_element_pages
from .postprocess.fix_crosspage_mcid import process_pdf_synctex as fix_crosspage_process_pdf
from .postprocess.inject_structtree import inject_structtree as inject_structtree_func
from .visualization.visualize_mcid import visualize_mcid as visualize_mcid_func
from .visualization.visualize_mcid import augment_mcid_json_bboxes


def verify_without_lpsb_injection(
    work_dir: Path, 
    main_tex_path: Path, 
    docker_image: str, 
    log_file: Path,
    timeout: int = VERIFY_TIMEOUT_SEC
) -> bool:
    """Re-compile without LPSB injection to verify if source is inherently broken.
    
    Args:
        work_dir: Working directory containing source files
        main_tex_path: Path to main .tex file
        docker_image: Docker image to use
        log_file: Log file to append verification results
        timeout: Timeout in seconds
        
    Returns:
        True if source compiles successfully WITHOUT LPSB (meaning LPSB caused failure)
        False if source also fails without LPSB (source is inherently broken)
    """
    import tempfile
    import shutil
    
    try:
        # Create a clean copy without LPSB injection
        with tempfile.TemporaryDirectory(prefix="lpsb_verify_") as verify_dir:
            verify_path = Path(verify_dir)
            
            # Copy source files
            tex_dir = main_tex_path.parent
            for item in tex_dir.iterdir():
                if item.is_file():
                    shutil.copy(item, verify_path / item.name)
                elif item.is_dir() and item.name not in ('_pdflatex', '__pycache__'):
                    shutil.copytree(item, verify_path / item.name)
            
            # Remove LPSB package files if present
            for lpsb_file in verify_path.glob("lpsb*.sty"):
                lpsb_file.unlink()
            
            # Remove \usepackage{lpsb-mcid} from main tex
            main_name = main_tex_path.name
            verify_tex = verify_path / main_name
            if verify_tex.exists():
                content = verify_tex.read_text(errors='ignore')
                # Remove LPSB usepackage line
                content = re.sub(r'\\usepackage\{lpsb-mcid\}.*\n?', '', content)
                content = re.sub(r'\\usepackage\{lpsb\}.*\n?', '', content)
                verify_tex.write_text(content)
            
            # Compile without LPSB
            docker_cmd = [
                "docker", "run", "--rm",
                "--net", "none",
                "-v", f"{verify_path}:/work",
                "-w", "/work",
                docker_image,
                "pdflatex", "-interaction=nonstopmode", "-synctex=0", main_name
            ]
            
            result = subprocess.run(
                docker_cmd,
                capture_output=True,
                timeout=timeout,
                check=False
            )
            
            # Check if PDF was created
            pdf_name = main_name.replace('.tex', '.pdf')
            pdf_path = verify_path / pdf_name
            
            if pdf_path.exists() and pdf_path.stat().st_size > 1000:
                with open(log_file, "a") as log:
                    log.write("\n=== VERIFICATION: Source compiles WITHOUT LPSB ===\n")
                    log.write("==> This is a TRUE FAILURE (LPSB caused the failure)\n")
                return True  # Source works without LPSB = LPSB caused failure
            else:
                with open(log_file, "a") as log:
                    log.write("\n=== VERIFICATION: Source also fails WITHOUT LPSB ===\n")
                    log.write("==> This is a FALSE POSITIVE (source is inherently broken)\n")
                return False  # Source also fails = not LPSB's fault
                
    except subprocess.TimeoutExpired:
        with open(log_file, "a") as log:
            log.write("\n=== VERIFICATION: Timed out (source likely broken) ===\n")
        return False
    except Exception as e:
        with open(log_file, "a") as log:
            log.write(f"\n=== VERIFICATION: Error - {e} ===\n")
        return False


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
    
    def __init__(
        self,
        image: str,
        shared_volume: Path,
        pool_size: int = 1,
        extra_mounts: list = None,
        extra_env: dict = None,
    ):
        """
        Args:
            image: Docker image name
            shared_volume: Host path to mount as /workdir in all containers
            pool_size: Number of containers to start
        """
        self.image = image
        self.shared_volume = Path(shared_volume).resolve()
        self.pool_size = pool_size
        self.extra_mounts = list(extra_mounts) if extra_mounts else []
        self.extra_env = dict(extra_env) if extra_env else {}
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
                # Start container with shared volume (+ optional extra mounts/env)
                r = subprocess.run(
                    (
                        [
                            "docker", "run", "-d",
                            "--name", name,
                            "--net", "none",
                            "-v", f"{self.shared_volume}:/workdir",
                        ]
                        + sum([["-v", f"{hp}:{cp}"] for (hp, cp) in self.extra_mounts if hp and cp], [])
                        + sum([["-e", f"{k}={v}"] for (k, v) in self.extra_env.items() if k and v is not None], [])
                        + [self.image, "sleep", "infinity"]
                    ),
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


class MultiVersionContainerPool:
    """Manages container pools for multiple TeX Live versions.
    
    Pre-scans papers to detect required TeX Live versions, then starts
    one container per version. Each paper is assigned to the matching container.
    """
    
    def __init__(self, shared_volume: Path, default_image: str = LPSB_IMAGE):
        self.shared_volume = Path(shared_volume).resolve()
        self.default_image = default_image
        self.pools = {}  # version -> DockerContainerPool
        self.version_containers = {}  # version -> container_name
        self._started = False
    
    def start_for_versions(self, versions: set) -> None:
        """Start one container per TeX Live version."""
        if self._started:
            return

        for ver in sorted(versions):
            image = _select_docker_image_from_year(ver)
            extra_mounts = []
            extra_env = {}

            pool = DockerContainerPool(
                image,
                self.shared_volume,
                pool_size=1,
                extra_mounts=extra_mounts,
                extra_env=extra_env,
            )
            try:
                pool.start()
                self.pools[ver] = pool
                self.version_containers[ver] = pool.containers[0]
            except Exception as e:
                # Clean up on failure
                self.stop()
                raise RuntimeError(f"Failed to start container for TL{ver}: {e}")
        
        self._started = True
    
    def get_container_for_version(self, version: str) -> str:
        """Get container name for a specific TeX Live version."""
        if version in self.version_containers:
            return self.version_containers[version]
        # Fallback to default (latest)
        if ARXIV_TEXLIVE_DEFAULT in self.version_containers:
            print(f"[WARN] texlive: version {version} missing, using default {ARXIV_TEXLIVE_DEFAULT}")
            return self.version_containers[ARXIV_TEXLIVE_DEFAULT]
        # Return any available container
        if self.version_containers:
            print(f"[WARN] texlive: version {version} missing, using any available container")
            return next(iter(self.version_containers.values()))
        raise RuntimeError("No containers started")
    
    def stop(self) -> None:
        """Stop all container pools."""
        for pool in self.pools.values():
            try:
                pool.stop()
            except Exception:
                pass
        self.pools.clear()
        self.version_containers.clear()
        self._started = False
    
    def __enter__(self):
        return self
    
    def __exit__(self, *args):
        self.stop()


def prescan_paper_version(src_path: Path, temp_dir: Path = None) -> str:
    """Quickly detect TeX Live version requirement for a paper.
    
    This is a lightweight version of _select_docker_image() that works
    on the source before extraction into work_dir.
    
    Returns:
        TeX Live year (e.g., "2023") or ARXIV_TEXLIVE_DEFAULT
    """
    src_path = Path(src_path)
    paper_id = _paper_id_from_src(src_path)
    
    tl_min = os.environ.get("LPSB_TEXLIVE_MIN", TEXLIVE_MIN_DEFAULT).strip()
    if not re.fullmatch(r"\d{4}", tl_min):
        tl_min = TEXLIVE_MIN_DEFAULT
    
    def clamp(y: str) -> str:
        if int(y) < int(tl_min):
            return tl_min
        return y
    
    # For directories, check 00README.json and .bbl files directly
    if src_path.is_dir():
        tl = _read_00readme_texlive_version(src_path)
        if tl and re.fullmatch(r"\d{4}", tl):
            return clamp(tl)
        
        # Check for .bbl files
        for bbl in src_path.glob("*.bbl"):
            fmt = _detect_biblatex_bbl_format_version(bbl)
            if fmt:
                year = _map_bbl_format_to_texlive_year(fmt)
                if year:
                    return clamp(year)
            break  # Only check first .bbl
    
    # For archives, we can't easily peek inside without extraction
    # Fall back to arXiv ID-based detection
    year = _texlive_year_from_arxiv_id(paper_id)
    if year:
        return clamp(year)
    
    return clamp(ARXIV_TEXLIVE_DEFAULT)


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

# Two-pass compilation for accurate float/cross-page tagging
# Set LPSB_TWO_PASS=0 to disable (adds one extra pdflatex pass)
LPSB_TWO_PASS_DEFAULT = True


def _is_two_pass_enabled() -> bool:
    """Check if two-pass compilation mode is enabled."""
    default_val = "1" if LPSB_TWO_PASS_DEFAULT else "0"
    env_val = os.environ.get("LPSB_TWO_PASS", default_val).strip().lower()
    return env_val in ("1", "true", "yes", "on")

def _scan_compile_log_for_issues(log_path: Path):
    """Best-effort scan for errors that still allow a PDF to be produced.

    This repo historically treated 'PDF exists' as success, but LaTeX can keep going
    under -interaction=nonstopmode and still emit a PDF with broken citations/refs.
    
    IMPORTANT: Only scans pdflatex output. This compiler no longer runs any
    secondary "Stage B" enrichment passes.
    """
    issues = {
        "fatal": False,
        "undef_citation": False,
        "undef_reference": False,
        "bibtex_problem": False,
        "biber_seen": False,
        "latex_error_lines": 0,  # Count of "! LaTeX Error:" lines (soft by default)
    }
    try:
        with open(log_path, "r", errors="replace") as f:
            # Track per-run fatality: treat "fatal" only if the *current* pdflatex run
            # hard-stopped and did not produce a PDF. Earlier hard-stops can be fixed by
            # retries (e.g., after copying missing stubs) and should not poison the result.
            run_fatal = False
            run_pdf_written = False
            for line in f:
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
    # Insert usepackage directly - do NOT use AddToHook{begindocument/before}
    # as it causes \AtBeginDocument hooks in lpsb-mcid modules to never execute
    lines.insert(docclass_end_idx + 1, f"\\usepackage{opt}{{{pkg}}}{newline}")

    try:
        tex_file.write_text("".join(lines))
    except Exception:
        return


def _detect_native_tagged_class(tex_file: Path) -> str | None:
    """Detect if document uses a class with native PDF tagging (e.g., acmart-tagged).
    
    These classes implement their own PDF tagging mechanism which conflicts with
    LPSB's tagging. When detected, LPSB injection should be skipped.
    
    Args:
        tex_file: Path to the main .tex file
        
    Returns:
        Name of the native-tagged class if detected, None otherwise
    """
    # List of classes known to have native PDF tagging
    NATIVE_TAGGED_CLASSES = [
        "acmart-tagged",  # ACM's tagged PDF version of acmart
    ]
    
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return None
    
    # Look for \documentclass[...]{classname} or \documentclass{classname}
    # Must be on a NON-COMMENTED line (not starting with %)
    # Pattern handles optional arguments and whitespace
    docclass_pattern = re.compile(
        r"^[^%\n]*\\documentclass\s*(?:\[[^\]]*\])?\s*\{([^}]+)\}",
        re.MULTILINE
    )
    
    match = docclass_pattern.search(content)
    if match:
        classname = match.group(1).strip()
        if classname in NATIVE_TAGGED_CLASSES:
            return classname

    return None


def _convert_dollar_math_to_latex(tex_file: Path) -> bool:
    r"""Convert $...$ to \(...\) and $$...$$ to \[...\] for robust math mode detection.

    This conversion is necessary because:
    1. $...$ is a TeX primitive that's hard to hook into
    2. \(...\) and \[...\] are LaTeX commands that can be properly detected
    3. This allows lpsb-mcid.sty to correctly identify math mode and avoid
       creating spurious P tags for subscripts/superscripts

    IMPORTANT: This function carefully avoids converting dollar signs in:
    - Comments (% ... to end of line)
    - Verbatim environments (\verb, \begin{verbatim}, \begin{lstlisting}, etc.)
    - Already escaped dollar signs (\$)
    - Minted/listings code blocks

    Args:
        tex_file: Path to the .tex file to process

    Returns:
        True if conversion was successful, False otherwise
    """
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return False

    original_content = content

    # Use a state machine approach for robust parsing
    result = []
    i = 0
    n = len(content)

    # Verbatim-like environments that should not be processed
    VERBATIM_ENVS = {
        'verbatim', 'Verbatim', 'lstlisting', 'minted', 'alltt',
        'filecontents', 'filecontents*', 'comment'
    }

    def is_escaped(pos: int) -> bool:
        """Check if character at pos is escaped by counting preceding backslashes."""
        count = 0
        p = pos - 1
        while p >= 0 and content[p] == '\\':
            count += 1
            p -= 1
        return count % 2 == 1  # Odd number of backslashes = escaped

    def skip_to_end_of_line(pos: int) -> int:
        """Skip to end of line (for comments)."""
        while pos < n and content[pos] != '\n':
            pos += 1
        return pos

    def find_verb_end(pos: int, delimiter: str) -> int:
        """Find end of \verb|...| construct."""
        while pos < n and content[pos] != delimiter:
            pos += 1
        return pos + 1 if pos < n else pos

    def find_env_end(pos: int, env_name: str) -> int:
        r"""Find \end{env_name} and return position after it."""
        end_pattern = f"\\end{{{env_name}}}"
        idx = content.find(end_pattern, pos)
        if idx == -1:
            return n  # Not found, skip to end
        return idx + len(end_pattern)

    while i < n:
        # Check for comment (unescaped %)
        if content[i] == '%' and not is_escaped(i):
            # Copy everything to end of line
            line_end = skip_to_end_of_line(i)
            result.append(content[i:line_end])
            i = line_end
            continue

        # Check for \verb
        if content[i:i+5] == '\\verb' and i + 5 < n:
            # \verb|...| or \verb*|...|
            j = i + 5
            if j < n and content[j] == '*':
                j += 1
            if j < n:
                delimiter = content[j]
                j += 1
                end_pos = find_verb_end(j, delimiter)
                result.append(content[i:end_pos])
                i = end_pos
                continue

        # Check for verbatim-like environments
        if content[i:i+7] == '\\begin{':
            # Find environment name
            j = i + 7
            env_end = content.find('}', j)
            if env_end != -1:
                env_name = content[j:env_end]
                # Handle optional arguments like \begin{lstlisting}[...]
                base_env = env_name.split('[')[0].split(']')[0].strip()
                if base_env in VERBATIM_ENVS:
                    # Skip entire environment
                    close_brace = env_end + 1
                    env_content_end = find_env_end(close_brace, base_env)
                    result.append(content[i:env_content_end])
                    i = env_content_end
                    continue

        # Check for escaped dollar sign
        if content[i:i+2] == '\\$':
            result.append('\\$')
            i += 2
            continue

        # Check for display math $$...$$
        if content[i:i+2] == '$$':
            # Find closing $$
            j = i + 2
            depth = 0  # Track nested braces for safety
            while j < n - 1:
                if content[j] == '\\' and j + 1 < n:
                    # Skip escaped character
                    j += 2
                    continue
                if content[j:j+2] == '$$' and depth == 0:
                    # Found closing $$
                    inner = content[i+2:j]
                    result.append('\\[')
                    result.append(inner)
                    result.append('\\]')
                    i = j + 2
                    break
                if content[j] == '{':
                    depth += 1
                elif content[j] == '}':
                    depth = max(0, depth - 1)
                j += 1
            else:
                # No closing $$ found, keep original
                result.append('$$')
                i += 2
            continue

        # Check for inline math $...$
        if content[i] == '$':
            # Make sure it's not $$ (already handled above)
            if i + 1 < n and content[i+1] == '$':
                # This shouldn't happen as $$ is handled above, but be safe
                result.append('$')
                i += 1
                continue

            # Find closing $
            j = i + 1
            while j < n:
                if content[j] == '\\' and j + 1 < n:
                    # Skip escaped character
                    j += 2
                    continue
                if content[j] == '$':
                    # Found closing $
                    inner = content[i+1:j]
                    # Sanity check: inner should not be empty or just whitespace
                    if inner and not inner.isspace():
                        result.append('\\(')
                        result.append(inner)
                        result.append('\\)')
                    else:
                        # Keep original if empty
                        result.append(content[i:j+1])
                    i = j + 1
                    break
                if content[j] == '\n':
                    # Inline math shouldn't span lines in most cases
                    # Keep original $ and continue
                    result.append('$')
                    i += 1
                    break
                j += 1
            else:
                # No closing $ found, keep original
                result.append('$')
                i += 1
            continue

        # Regular character
        result.append(content[i])
        i += 1

    new_content = ''.join(result)

    # Only write if content changed
    if new_content != original_content:
        try:
            tex_file.write_text(new_content)
            return True
        except Exception:
            return False

    return True  # No changes needed is also success


def _convert_dollar_math_in_directory(tex_dir: Path) -> int:
    """Convert dollar math notation in all .tex files in a directory.

    Args:
        tex_dir: Directory containing .tex files

    Returns:
        Number of files processed
    """
    count = 0
    for tex_file in tex_dir.rglob("*.tex"):
        if _convert_dollar_math_to_latex(tex_file):
            count += 1
    return count


def _disable_conflicting_packages(tex_dir: Path) -> int:
    """Disable packages that are known to conflict with LPSB tagging.

    Some packages (like axessibility, tagpdf, etc.) modify the PDF structure or
    hook into LaTeX internals in ways that conflict with LPSB's PDF tagging additions.
    To ensure correct tagging, we disable these packages in the source.

    Conflicting packages handled:
    - axessibility: Embeds raw LaTeX in PDF text layer
    - accsupp: Similar to axessibility (used by it)
    - tagpdf: Conflicts with our tagging primitives
    - accessibility: Older accessibility package
    - pdfcomment: Injects PDF annotations that can break tag structure
    - floatrow: Often conflicts with float tagging hooks

    Args:
        tex_dir: Directory containing .tex files

    Returns:
        Number of files modified
    """
    count = 0
    # List of conflicting packages to disable
    conflicts = [
        "axessibility",
        "accsupp",
        "tagpdf",
        "accessibility",
        "pdfcomment",
        "floatrow"
    ]
    
    # Check for both \usepackage and \RequirePackage
    # Handles:
    #   \usepackage{pkg}
    #   \usepackage[opt]{pkg}
    #   \usepackage[opt, multi=line]{pkg}
    #   \RequirePackage...
    package_list_pattern = "|".join(re.escape(pkg) for pkg in conflicts)
    
    # Regex breakdown:
    # 1. ^(\s*) -> capture indentation (Group 1)
    # 2. ( -> capture the whole command to comment out (Group 2)
    # 3. \\(?:usepackage|RequirePackage) -> match command
    # 4. \s* -> optional whitespace
    # 5. (?:\[[^\]]*\])? -> optional [options] (non-capturing)
    # 6. \s* -> optional whitespace
    # 7. \{ -> open brace
    # 8. \s* -> optional whitespace
    # 9. (?: ... ) -> match the package name
    # 10. \} -> close brace
    # 11. ) -> end capture Group 2
    #
    # Flags: MULTILINE (for ^), DOTALL usually not needed if we iterate lines,
    # but some style files span lines. To imply specific packages we match explicitly.
    pattern = re.compile(
        r'^(\s*)(\\(?:usepackage|RequirePackage)\s*(?:\[[^\]]*\])?\s*\{(?:\s*(?:' + package_list_pattern + r')\s*)\})',
        re.MULTILINE
    )

    for tex_file in tex_dir.rglob("*.tex"):
        try:
            content = tex_file.read_text(errors="ignore")
        except Exception:
            continue

        if not pattern.search(content):
            continue

        # Comment out the matching lines
        # Replacement: \1% [LPSB DISABLED] \2
        new_content = pattern.sub(
            r'\1% [LPSB DISABLED] \2',
            content
        )

        if new_content != content:
            try:
                tex_file.write_text(new_content)
                count += 1
                print(f"  [LPSB] Disabled conflicting packages in {tex_file.name}")
            except Exception:
                pass

    return count


def _inject_lpsb_mcid_after_packages(tex_file: Path, options: str = "") -> None:
    """Inject lpsb-mcid after the LAST \\usepackage, before \\title/\\author.

    This ensures lpsb-mcid loads after all other packages, allowing proper
    detection of template types and installation of hooks (header/footer
    artifact marking, layout tracking via shipout hooks, etc.).

    Args:
        tex_file: Path to the main .tex file
        options: Package options string (e.g., "pass-one" for two-pass compilation)
    """
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return

    # Check if lpsb-mcid already present (with any options)
    if re.search(r"\\usepackage(\[[^\]]*\])?\{lpsb-mcid\}", content):
        return
    newline = "\r\n" if "\r\n" in content else "\n"

    # Strategy: Find a safe insertion point for lpsb-mcid.
    # We prefer to insert just before \begin{document} to avoid conditional blocks.
    #
    # Problem: Some templates have \usepackage inside \if...\fi blocks (e.g., WACV).
    # Inserting after the last \usepackage can place lpsb-mcid inside a conditional,
    # causing it to not load in some modes.
    #
    # Solution: Insert just before \begin{document} which is always outside conditionals.
    #
    # CRITICAL: Do NOT use \AddToHook{begindocument/before} - this causes \AtBeginDocument
    # hooks registered by lpsb-mcid modules to never execute because the hook queue
    # has already been processed by the time lpsb-mcid loads.
    lines = content.splitlines(keepends=True)

    opt_str = f"[{options}]" if options else ""
    usepackage_line = f"\\usepackage{opt_str}{{lpsb-mcid}}"

    # Find \begin{document} line
    begin_doc_idx = -1
    begin_doc_pattern = re.compile(r"^\s*\\begin\s*\{\s*document\s*\}")
    for i, line in enumerate(lines):
        stripped = line.lstrip()
        if stripped.startswith("%"):
            continue
        if begin_doc_pattern.match(line):
            begin_doc_idx = i
            break

    if begin_doc_idx >= 0:
        # Insert just before \begin{document}
        lines.insert(begin_doc_idx, f"{usepackage_line} % LPSB MCID{newline}")
        try:
            tex_file.write_text("".join(lines))
        except Exception:
            pass
    else:
        # No \begin{document} found, fall back to after documentclass
        _inject_pkg_after_documentclass(tex_file, "lpsb-mcid", options)


def _modify_lpsb_mcid_options(tex_file: Path, new_options: str) -> bool:
    """Modify the options of an already-injected lpsb-mcid package.
    
    Used for two-pass compilation to switch from pass-one mode to normal mode.
    
    Args:
        tex_file: Path to the main .tex file
        new_options: New options string (empty string for no options)
    
    Returns:
        True if modification was successful, False otherwise
    """
    try:
        content = tex_file.read_text(errors="ignore")
    except Exception:
        return False
    
    # Pattern to match lpsb-mcid usepackage (direct style only now)
    pkg_pattern = r"\\usepackage(\[[^\]]*\])?\{lpsb-mcid\}"
    # Also match old AddToHook style for backwards compatibility during migration
    old_hook_pattern = r"\\AddToHook\{begindocument/before\}\{\\usepackage(\[[^\]]*\])?\{lpsb-mcid\}\}"

    opt_str = f"[{new_options}]" if new_options else ""
    repl = f"\\usepackage{opt_str}{{lpsb-mcid}}"

    if re.search(old_hook_pattern, content):
        # Convert old AddToHook style to direct usepackage
        new_content = re.sub(old_hook_pattern, lambda _m: repl, content)
    elif re.search(pkg_pattern, content):
        # Direct usepackage style
        new_content = re.sub(pkg_pattern, lambda _m: repl, content)
    else:
        return False  # lpsb-mcid not found
    
    try:
        tex_file.write_text(new_content)
        return True
    except Exception:
        return False

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
from dataclasses import dataclass
from typing import List


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
                # Check for unsafe members (ZipSlip) - simplified
                safe_members = [m for m in tar.getmembers() if not m.name.startswith('/') and '..' not in m.name]
                tar.extractall(path=dst_dir, members=safe_members, filter='data')
            return True
        except Exception as e:
            # Fallback to gunzip if tar fails (sometimes misidentified)
            print(f"[WARN] extract: tar failed, falling back to gunzip ({e})")

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


@dataclass
class _DollarMathConvertStats:
    files_total: int = 0
    files_changed: int = 0
    files_skipped: int = 0
    dollars_converted: int = 0


_VERBATIM_ENVS = {
    "verbatim",
    "verbatim*",
    "lstlisting",
    "minted",
    "Verbatim",
    "Verbatim*",
    "comment",
}


def _convert_inline_dollar_math_to_paren(tex: str) -> Tuple[str, int]:
    """Convert inline $...$ to \\(...\\) (best-effort, line-local).

    This avoids global "unbalanced $" issues by only converting lines that have
    an even number of single-dollar math shifts. Lines with odd counts are left
    untouched.

    Rules:
    - Leaves $$...$$ untouched.
    - Ignores escaped dollars \\$.
    - Skips conversion inside verbatim-like environments.
    - Does not touch the comment portion of a line (after an unescaped '%').
    """
    if "$" not in tex:
        return tex, 0

    env_stack: List[str] = []
    converted = 0

    def in_verbatim_env() -> bool:
        return bool(env_stack) and (env_stack[-1] in _VERBATIM_ENVS)

    def _split_comment(line: str) -> Tuple[str, str]:
        # Split at first unescaped %, keep '%' in comment part.
        for idx, ch in enumerate(line):
            if ch == "%" and (idx == 0 or line[idx - 1] != "\\"):
                return line[:idx], line[idx:]
        return line, ""

    def _convert_segment(seg: str) -> Tuple[str, int]:
        # Convert single-dollar toggles within seg, preserving $$ and \$.
        out_chars: List[str] = []
        i = 0
        n = len(seg)
        toggles = 0

        # First pass: count convertible single dollars.
        while i < n:
            ch = seg[i]
            if ch == "\\" and i + 1 < n and seg[i + 1] == "$":
                i += 2
                continue
            if ch == "$":
                if i + 1 < n and seg[i + 1] == "$":
                    i += 2
                    continue
                toggles += 1
            i += 1

        if toggles == 0 or (toggles % 2) != 0:
            return seg, 0

        # Second pass: rewrite.
        i = 0
        in_inline = False
        local_conv = 0
        while i < n:
            ch = seg[i]
            if ch == "\\" and i + 1 < n and seg[i + 1] == "$":
                out_chars.append("\\$")
                i += 2
                continue
            if ch == "$":
                if i + 1 < n and seg[i + 1] == "$":
                    out_chars.append("$$")
                    i += 2
                    continue
                out_chars.append("\\)" if in_inline else "\\(")
                in_inline = not in_inline
                local_conv += 1
                i += 1
                continue
            out_chars.append(ch)
            i += 1
        return "".join(out_chars), local_conv

    out_lines: List[str] = []
    for line in tex.splitlines(keepends=True):
        # Track env transitions on the raw line (best-effort).
        if "\\begin{" in line:
            m = re.search(r"\\begin\{([^}]+)\}", line)
            if m:
                env_stack.append(m.group(1).strip())
        if "\\end{" in line:
            m = re.search(r"\\end\{([^}]+)\}", line)
            if m:
                env = m.group(1).strip()
                if env_stack and env_stack[-1] == env:
                    env_stack.pop()

        if in_verbatim_env():
            out_lines.append(line)
            continue

        seg, comment = _split_comment(line)
        new_seg, conv = _convert_segment(seg)
        converted += conv
        out_lines.append(new_seg + comment)

    return "".join(out_lines), converted


def _rewrite_tree_inline_dollar_math(work_dir: Path, log_file: Path) -> _DollarMathConvertStats:
    """Rewrite $...$ -> \\(...\\) across .tex files in work_dir (best-effort)."""
    stats = _DollarMathConvertStats()
    try:
        tex_files = list(work_dir.rglob("*.tex"))
    except Exception:
        tex_files = []

    stats.files_total = len(tex_files)
    for p in tex_files:
        # Skip obvious generated/aux dirs.
        if any(seg.startswith("_") for seg in p.parts):
            continue
        try:
            raw = p.read_text(errors="ignore")
        except Exception:
            stats.files_skipped += 1
            continue

        new, conv = _convert_inline_dollar_math_to_paren(raw)
        if conv <= 0 or new == raw:
            continue

        try:
            p.write_text(new)
            stats.files_changed += 1
            stats.dollars_converted += conv
        except Exception:
            stats.files_skipped += 1

    if stats.files_changed > 0:
        try:
            with open(log_file, "a") as log:
                log.write(
                    "\n"
                    f"Info: Converted inline $...$ to \\(...\\) in {stats.files_changed}/{stats.files_total} .tex files "
                    f"(single-$ toggles converted: {stats.dollars_converted}).\n"
                )
        except Exception:
            pass

    return stats


def _log_duration(log_file: Path, label: str, start: float, end: float = None) -> None:
    try:
        dur = (end if end is not None else time.perf_counter()) - start
        with open(log_file, "a") as log:
            log.write(f"[timing] {label}: {dur:.2f}s\n")
    except Exception:
        pass

def process_one_paper(src_path, out_dir, lpsb_root, use_ramdisk=False, disable_bbl_underscore_fix=False, container_name=None, final_output_dir=None, lpsb_debug=False):
    """Process a single paper directory or file.

    Args:
        src_path: Path to paper source (directory, .tex, or .gz file)
        out_dir: Output directory for build/work files (may be shared_vol in container reuse mode)
        lpsb_root: Path to LPSB root directory
        use_ramdisk: Use /dev/shm for temp workspace
        disable_bbl_underscore_fix: Disable .bbl underscore workaround
        container_name: Optional pre-started Docker container name for reuse.
                        If provided, uses docker exec instead of docker run.
        final_output_dir: Directory for final outputs (PDF, JSON). If None, uses out_dir.
        lpsb_debug: Enable debug mode for lpsb-mcid.sty
    """
    src_path = Path(src_path).resolve()
    out_dir = Path(out_dir).resolve()
    lpsb_root = Path(lpsb_root).resolve()
    
    # Use final_output_dir for results if provided, otherwise use out_dir
    result_base = Path(final_output_dir).resolve() if final_output_dir else out_dir

    
    paper_id = _paper_id_from_src(src_path)
        
    res_dir = result_base / paper_id
    res_dir.mkdir(parents=True, exist_ok=True)
    
    log_file = res_dir / "compile.log"
    
    work_dir_obj = None
    work_dir = None

    # In container reuse mode (container_name is set), out_dir IS the shared_vol
    # which is mounted as /workdir in Docker. So we must use out_dir/build/paper_id
    # directly, NOT a random tempfile path.
    if container_name is not None:
        # Container reuse mode: work_dir must be under shared_vol (out_dir)
        work_dir = out_dir / "build" / paper_id
        if work_dir.exists():
            shutil.rmtree(work_dir)
        work_dir.mkdir(parents=True)
    elif use_ramdisk and Path("/dev/shm").exists():
        # Non-container mode with ramdisk: use tempfile for isolation
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

    total_start = time.perf_counter()
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

        # Optional: rewrite inline $...$ to \( ... \) so we can reliably hook inline math.
        # This is intentionally opt-in: it mutates sources and can be wrong for edge cases.
        if os.environ.get("LPSB_CONVERT_DOLLAR_INLINE_MATH", "").strip() in ("1", "true", "TRUE", "yes", "YES"):
            _rewrite_tree_inline_dollar_math(work_dir, log_file)

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

        # 3. Compile (pdflatex only)
        pdflatex_dir = work_dir / "_pdflatex"
        if pdflatex_dir.exists():
            shutil.rmtree(pdflatex_dir, ignore_errors=True)

        ignore = shutil.ignore_patterns("_pdflatex")
        shutil.copytree(work_dir, pdflatex_dir, ignore=ignore)

        pd_tex_dir = pdflatex_dir if tex_dir_rel == "." else (pdflatex_dir / tex_dir_rel)
        pd_tex_dir.mkdir(parents=True, exist_ok=True)

        def _copy_if_exists(name: str, dst_dir: Path) -> None:
            # LPSB support files used to live at repo root; some branches move them
            # under ./archive/. Keep the compiler resilient by searching both.
            candidates = [
                lpsb_root / name,
                lpsb_root.parent / name,
                lpsb_root / "modules" / name,
                lpsb_root.parent / "modules" / name,
            ]
            for src in candidates:
                if src.exists():
                    shutil.copy(src, dst_dir / name)
                    return
            print(f"Warning: {name} not found in {candidates}")

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
                "lpsb-mcid.sty",
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

        pd_main_tex_full = pdflatex_dir / main_tex
        two_pass_enabled = False
        
        # Check if document uses a class with native PDF tagging (e.g., acmart-tagged)
        # These classes implement their own tagging which conflicts with LPSB
        native_tagged_class = _detect_native_tagged_class(pd_main_tex_full)
        skip_lpsb_injection = native_tagged_class is not None
        
        if skip_lpsb_injection:
            print(f"  [INFO] Detected native-tagged class '{native_tagged_class}' - skipping LPSB injection")
        else:
            # LPSB tagging: use lpsb-mcid.sty exclusively (modern MCID-based approach)
            # Note: lpsb.sty (archive) is legacy and should NOT be used
            _copy_if_exists("lpsb-mcid.sty", pd_tex_dir)
            _copy_if_exists("lpsb-templates.sty", pd_tex_dir)
            _copy_if_exists("lpsb-algorithms.sty", pd_tex_dir)
            _copy_if_exists("lpsb-subfigure.sty", pd_tex_dir)
            _copy_if_exists("lpsb-math.sty", pd_tex_dir)
            _copy_if_exists("lpsb-lists.sty", pd_tex_dir)
            _copy_if_exists("lpsb-refs.sty", pd_tex_dir)
            _copy_if_exists("lpsb-floats.sty", pd_tex_dir)
            _copy_if_exists("lpsb-footnotes.sty", pd_tex_dir)
            _copy_if_exists("lpsb-sections.sty", pd_tex_dir)
            _copy_if_exists("lpsb-headers.sty", pd_tex_dir)
            _copy_if_exists("lpsb-metadata.sty", pd_tex_dir)
            _copy_if_exists("lpsb-toc.sty", pd_tex_dir)
            _copy_if_exists("lpsb-graphics.sty", pd_tex_dir)
            _copy_if_exists("lpsb-theorems.sty", pd_tex_dir)
            _copy_if_exists("lpsb-code.sty", pd_tex_dir)
            _copy_if_exists("lpsb-tables.sty", pd_tex_dir)
            _copy_if_exists("lpsb-frames.sty", pd_tex_dir)
            _copy_if_exists("lpsb-quotes.sty", pd_tex_dir)

            # Convert $...$ to \(...\) and $$...$$ to \[...\] for robust math mode detection
            # This allows lpsb-mcid.sty to correctly identify math mode via \ifmmode
            _convert_dollar_math_in_directory(pd_tex_dir)

            # Disable axessibility package - it embeds LaTeX source in text layer,
            # causing mismatch between            # Step 1b: Disable conflicting packages (e.g. axessibility, tagpdf)
            _disable_conflicting_packages(pd_tex_dir)

            # Two-pass compilation: first pass uses pass-one option to collect positioning info
            two_pass_enabled = _is_two_pass_enabled()

            # Build options string for lpsb-mcid
            lpsb_options = []
            if two_pass_enabled:
                lpsb_options.append("pass-one")
            if lpsb_debug:
                lpsb_options.append("debug")
            options_str = ",".join(lpsb_options)

            _inject_lpsb_mcid_after_packages(pd_main_tex_full, options=options_str)

        docker_image, selected_tl, selected_reason = _select_docker_image(work_dir, tex_dir_rel, main_base, paper_id)

        # Stub injection must be on-demand: dumping a whole stub set into the build dir is
        # wrong (it overrides TeX Live and can break output). We'll only copy stubs that
        # pdflatex/bibtex/biber actually report as missing.
        copy_stub_pd = _copy_collected_packages(pd_tex_dir, selected_tl)

        with open(log_file, "w") as log:
            log.write(f"Docker image: {docker_image}\n")
            if selected_tl:
                log.write(f"TeX Live selected: {selected_tl}\n")
            log.write(f"TeX Live reason: {selected_reason}\n")

        pd_container_wd = "/workdir" if tex_dir_rel == "." else f"/workdir/{tex_dir_rel}"

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
                        # In reuse mode, out_dir is mounted as /workdir.
                        # stage_dir is typically out_dir/build/paper_id/_pdflatex
                        # which maps to /workdir/build/paper_id/_pdflatex inside the container
                        try:
                            rel_stage = stage_dir.relative_to(out_dir)
                            exec_wd = f"/workdir/{rel_stage}"
                        except ValueError:
                            # stage_dir not under out_dir - this shouldn't happen in reuse mode
                            exec_wd = "/workdir"
                        

                        exec_cmd = ["docker", "exec", "-w", exec_wd]
                        # In exec mode we cannot add mounts; those must be configured when the
                        # long-running container is started. We *can* pass env vars per exec.
                        if extra_env:
                            for k, v in extra_env.items():
                                if k and v is not None:
                                    exec_cmd += ["-e", f"{k}={v}"]
                        exec_cmd += [container_name] + cmd
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
                    with open(log_file, "a") as log:
                        log.write("\nInfo: Preflight detected '_' in bibliography \\bibitem keys; enabled LPSB_BBL_UNDERSCORE_FIX\n")

        # Stage A: pdflatex gold (3 passes)
        stage_a_start = time.perf_counter()
        with open(log_file, "a") as log:
            log.write("\n=== Stage A: pdflatex (gold) ===\n")
        had_rc_error = False
        missing_seen = set()
        for attempt in range(1, 6):
            rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-synctex=1", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
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
                with open(log_file, "a") as log:
                    log.write("\nInfo: Detected '_' in .bbl \\\\bibitem keys; enabled LPSB_BBL_UNDERSCORE_FIX\n")

        rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-synctex=1", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
        had_rc_error |= (rc != 0)
        rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-synctex=1", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
        had_rc_error |= (rc != 0)
        _log_duration(log_file, "stage_a_pdflatex", stage_a_start)

        # Two-pass compilation: Second pass uses the collected positioning data
        # to emit accurate BDC markers for float/cross-page elements
        if (not skip_lpsb_injection) and two_pass_enabled:
            two_pass_start = time.perf_counter()
            with open(log_file, "a") as log:
                log.write("\n=== Two-Pass: Pass 2 (using collected positioning data) ===\n")
            
            # Modify lpsb-mcid to remove pass-one option (enable normal tagging mode)
            if _modify_lpsb_mcid_options(pd_main_tex_full, ""):
                with open(log_file, "a") as log:
                    log.write("Info: Modified lpsb-mcid to use positioning data from pass-one\n")
            
            # Run additional pdflatex passes to generate the final PDF with accurate tags
            rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-synctex=1", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
            had_rc_error |= (rc != 0)
            rc = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-synctex=1", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
            had_rc_error |= (rc != 0)
            _log_duration(log_file, "two_pass_pdflatex", two_pass_start)

        aux_file = pd_tex_dir / f"{main_base}.aux"
        pdf_file = pd_tex_dir / f"{main_base}.pdf"
        dvi_file = pd_tex_dir / f"{main_base}.dvi"
        
        # DVI-to-PDF fallback: some legacy documents produce DVI instead of PDF
        # (e.g., using dvips.def or explicit DVI mode). Convert using dvipdf.
        if not pdf_file.exists() and dvi_file.exists():
            print("[WARN] compile: PDF missing, converting DVI to PDF")
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
        if pdf_file.exists():
            try:
                shutil.copy(pdf_file, final_pdf)
            except Exception:
                pass

        # If gold artifacts are missing, try targeted retries for known high-impact, fixable errors.
        if not (aux_file.exists() and pdf_file.exists()):
            natbib_err = "Package natbib Error: Bibliography not compatible with author-year citations."
            try:
                log_txt = Path(log_file).read_text(errors="ignore")
            except Exception:
                log_txt = ""

            if natbib_err in log_txt:
                # Off by default: this injects code into the staged main .tex.
                if _env_truthy("LPSB_ENABLE_NATBIB_NUMBERS_FIX"):
                    _inject_natbib_numbers_fix(pd_main_tex_full)
                    with open(log_file, "a") as log:
                        log.write("\nInfo: Detected natbib author-year incompatibility; enabled LPSB_NATBIB_NUMBERS_FIX and retrying gold passes\n")
                rc1 = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-synctex=1", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
                rc2 = _run(pdflatex_dir, pd_container_wd, ["pdflatex", "-synctex=1", "-interaction=nonstopmode", f"-jobname={main_base}", main_tex_basename], TIMEOUT_SEC)
                if rc1 == 0 and rc2 == 0:
                    had_rc_error = False

                if pdf_file.exists():
                    try:
                        shutil.copy(pdf_file, final_pdf)
                    except Exception:
                        pass
            else:
                with open(log_file, "a") as log:
                    log.write("\nInfo: natbib author-year incompatibility not detected or cannot auto-fix\n")

            if not (aux_file.exists() and pdf_file.exists()):
                with open(log_file, 'a') as log:
                    log.write("\nError: COMPILATION_FAILED (missing gold artifacts)\n")
                
                if VERIFY_ON_FAIL:
                    # pd_main_tex_full is available from earlier
                    if not verify_without_lpsb_injection(work_dir, pd_main_tex_full, docker_image, log_file):
                        return "FALSE_POSITIVE"
                
                return "FAIL"

        # Many LaTeX runs return rc=1 due to warnings but still produce a valid PDF.
        if not (aux_file.exists() and pdf_file.exists()):
            with open(log_file, 'a') as log:
                log.write("\nError: COMPILATION_FAILED (missing artifacts)\n")
            
            if VERIFY_ON_FAIL:
                 if not verify_without_lpsb_injection(work_dir, pd_main_tex_full, docker_image, log_file):
                        return "FALSE_POSITIVE"
            
            return "FAIL"
        
        # Copy auxiliary files for debugging (aux, bbl, blg, log, synctex, etc.)
        debug_extensions = ['.aux', '.bbl', '.blg', '.bcf', '.log', '.synctex.gz']
        for ext in debug_extensions:
            src = pd_tex_dir / f"{main_base}{ext}"
            if src.exists():
                try:
                    shutil.copy(src, res_dir / f"{main_base}{ext}")
                except Exception:
                    pass
        
        try:
            # Copy compile log
            shutil.copy(log_file, res_dir / "compile.log")
        except Exception:
            pass
        # Copy main TeX source (best-effort)
        try:
            shutil.copy(pd_tex_dir / main_tex_basename, res_dir / f"{main_base}.tex")
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

        # Success! Collect any custom packages for future reuse
        if selected_tl:
            _collect_successful_packages(work_dir, selected_tl)

        # =========================================================================
        # Post-processing: MCID parsing and fixes (direct function calls)
        # =========================================================================
        script_dir = Path(__file__).parent

        with open(log_file, "a") as log:
            log.write(f"\nInfo: Running post-processing (direct imports, no subprocess)\n")

        # Fix split headings in AUX for downstream consumers (tree/StructTree).
        # This targets the classic pattern produced by LaTeX's staged heading output,
        # especially around \section* and bibliography headings.
        aux_for_downstream = aux_file
        aux_fixed = pd_tex_dir / f"{main_base}.aux.fixed"
        if not aux_file.exists():
            raise SystemExit(f"[postprocess] ERROR: aux not found: {aux_file}")
        try:
            merge_count, promoted_mcid_map = merge_split_headings_aux(aux_file, aux_fixed)
        except Exception as e:
            raise SystemExit(f"[postprocess] ERROR: fix-split-headings failed: {e}")
        if not aux_fixed.exists():
            raise SystemExit(f"[postprocess] ERROR: fix-split-headings produced no output: {aux_fixed}")
        aux_for_downstream = aux_fixed
        with open(log_file, "a") as log:
            log.write(f"\nInfo: Split headings fixed (aux): {aux_fixed} (merged {merge_count})\n")

        # Merge cross-column split paragraphs in aux (two-column layout).
        aux_merged = pd_tex_dir / f"{main_base}.aux.merged"
        synctex_file = pd_tex_dir / f"{main_base}.synctex.gz"
        if not (aux_for_downstream.exists() and pdf_file.exists()):
            raise SystemExit("[postprocess] ERROR: cannot merge split paragraphs: missing aux/pdf")
        merge_start = time.perf_counter()
        merge_count = merge_split_paragraphs_func(aux_for_downstream, pdf_file, synctex_file, aux_merged)
        _log_duration(log_file, "merge_split_paragraphs", merge_start)
        if not aux_merged.exists():
            raise SystemExit(f"[postprocess] ERROR: merge-split-paragraphs produced no output: {aux_merged}")
        aux_for_downstream = aux_merged
        with open(log_file, "a") as log:
            log.write(f"\nInfo: Cross-column split paragraphs merged (aux): {aux_merged} (merged {merge_count})\n")

        # 1. Fix cross-page / cross-column MCID issues in PDF (SyncTeX-driven injection/splitting)
        # IMPORTANT: This must run BEFORE parse_aux_file because it adds continuation MCIDs to aux
        pdf_fixed = pd_tex_dir / f"{main_base}_fixed.pdf"
        if not pdf_file.exists():
            raise SystemExit(f"[postprocess] ERROR: pdf not found for crosspage fix: {pdf_file}")
        synctex_file = pd_tex_dir / f"{main_base}.synctex.gz"
        if not synctex_file.exists():
            raise SystemExit(f"[postprocess] ERROR: synctex not found (required): {synctex_file}")
        crosspage_start = time.perf_counter()
        fix_crosspage_process_pdf(
            str(pdf_file),
            str(aux_for_downstream),
            str(synctex_file),
            str(pdf_fixed),
            verbose=False,
        )
        _log_duration(log_file, "fix_crosspage_mcid", crosspage_start)
        if not pdf_fixed.exists():
            raise SystemExit(f"[postprocess] ERROR: fix-crosspage-mcid produced no output: {pdf_fixed}")
        with open(log_file, "a") as log:
            log.write(f"\nInfo: Cross-page MCIDs fixed: {pdf_fixed}\n")
        # Replace the output PDF with the fixed version
        shutil.copy(pdf_fixed, final_pdf)

        # 1b. Retag promoted split headings in the fixed PDF (keep MCIDs, fix tag name)
        if promoted_mcid_map:
            pdf_retagged = pd_tex_dir / f"{main_base}_fixed_retagged.pdf"
            retag_start = time.perf_counter()
            retag_count = retag_pdf_mcid_types(pdf_fixed, pdf_retagged, promoted_mcid_map)
            _log_duration(log_file, "retag_split_headings_pdf", retag_start)
            if retag_count:
                shutil.copy(pdf_retagged, pdf_fixed)
                with open(log_file, "a") as log:
                    log.write(f"\nInfo: Retagged split headings in PDF: {pdf_fixed} (updated {retag_count} BDC markers)\n")

        # 2. Parse MCID data from aux file to JSON
        # NOTE: Must run AFTER fix_crosspage because it reads the updated aux with continuation MCIDs
        mcid_json = pd_tex_dir / f"{main_base}.mcid.json"
        if not aux_for_downstream.exists():
            raise SystemExit(f"[postprocess] ERROR: aux for downstream not found: {aux_for_downstream}")
        elements, summary = parse_aux_file(aux_for_downstream)
        # Reconcile element pages with PDF (fixes "Phantom Figure" float issues)
        reconcile_element_pages(elements, pdf_file, verbose=False)
        output_data = elements_to_json(elements, summary)
        with open(mcid_json, "w") as f:
            json.dump(output_data, f, indent=2)
        if not mcid_json.exists():
            raise SystemExit(f"[postprocess] ERROR: parse-mcid produced no output: {mcid_json}")
        with open(log_file, "a") as log:
            log.write(f"\nInfo: MCID JSON generated: {mcid_json}\n")
        # Augment JSON with MCID bboxes to maximize coverage (aligned with viz).
        augment_mcid_json_bboxes(str(pdf_fixed), str(mcid_json))

        # 3. Reading order map:
        # Inject StructTree auto-detects an adjacent *.order.json, and will compute one
        # on-demand if missing. We keep the conventional path here for log/copy only.
        order_map_json = pd_tex_dir / f"{main_base}.order.json"
        
        # 3. Inject StructTree into PDF (for PDF/UA compliance)
        # Keep fixed PDF name in the output for clarity.
        pdf_tagged = pd_tex_dir / f"{main_base}_fixed_tagged.pdf"
        if not (pdf_fixed.exists() and aux_for_downstream.exists()):
            raise SystemExit("[postprocess] ERROR: cannot inject StructTree: missing fixed pdf or aux")
        structtree_start = time.perf_counter()
        success = inject_structtree_func(str(pdf_fixed), str(aux_for_downstream), str(pdf_tagged), verbose=False)
        _log_duration(log_file, "inject_structtree", structtree_start)
        if not success:
            raise RuntimeError("inject_structtree returned False")
        if not pdf_tagged.exists():
            raise SystemExit(f"[postprocess] ERROR: inject-structtree produced no output: {pdf_tagged}")
        with open(log_file, "a") as log:
            log.write(f"\nInfo: StructTree injected: {pdf_tagged}\n")
        # Replace the output PDF with the tagged version
        shutil.copy(pdf_tagged, final_pdf)
        
        # Copy post-processed files to result directory
        # Default: only keep final outputs (json + tagged pdf).
        # Debug: keep full intermediate artifacts.
        if lpsb_debug:
            src_list = [mcid_json, aux_fixed, aux_merged, pdf_fixed, pdf_tagged, order_map_json]
        else:
            src_list = [mcid_json, pdf_tagged]
        for src_file in src_list:
            if src_file.exists():
                try:
                    shutil.copy(src_file, res_dir / src_file.name)
                except Exception:
                    pass
        
        # Support visualization (debug only): copy aux to match paper_id
        if lpsb_debug and aux_merged.exists():
            try:
                shutil.copy(aux_merged, res_dir / f"{paper_id}.aux")
            except Exception:
                pass

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
        _log_duration(log_file, "total", total_start)
        if work_dir_obj:
            try:
                work_dir_obj.cleanup()
            except:
                pass

# Global container pool reference (set by main process before forking workers)
_CONTAINER_POOL = None
_CONTAINER_NAMES = []  # List of container names for workers to use

def _run_visualization(output_dir: str, script_dir: Path) -> None:
    """Run MCID visualization on the compiled PDF.

    Finds the main_tagged.pdf in the output directory and generates
    a visualization with colored MCID boxes.
    Uses direct function call instead of subprocess.
    """
    output_path = Path(output_dir)

    # Find *_fixed_tagged.pdf first (preferred - has matching mcid.json)
    pdf_candidates: list[Path] = list(output_path.glob("**/*_fixed_tagged.pdf"))

    # Fallback: look for <paper_id>.pdf
    if not pdf_candidates and output_path.is_dir():
        print("[WARN] visualize: no *_fixed_tagged.pdf found, falling back to <paper_id>.pdf")
        # If output_dir is the paper dir, look for <paper_id>.pdf.
        paper_id = output_path.name
        final_pdf = output_path / f"{paper_id}.pdf"
        if final_pdf.exists():
            pdf_candidates = [final_pdf]
        else:
            # If output_dir is a parent, require <subdir>/<subdir>.pdf.
            for sub in output_path.iterdir():
                if not sub.is_dir():
                    continue
                cand = sub / f"{sub.name}.pdf"
                if cand.exists():
                    pdf_candidates.append(cand)

    # Filter out visualization outputs
    pdf_candidates = [p for p in pdf_candidates if "_mcid_viz" not in p.name]

    if not pdf_candidates:
        raise SystemExit("[Visualize] ERROR: No final post-processed PDF found to visualize")
    
    # Use the first found PDF
    pdf_path = pdf_candidates[0]
    
    # Output file: same directory with _mcid_viz suffix
    viz_output = pdf_path.with_name(pdf_path.stem + "_mcid_viz.pdf")
    
    print(f"[Visualize] Generating MCID visualization: {viz_output.name}")
    
    # Direct function call instead of subprocess
    try:
        # Pass mcid.json explicitly to enforce json-viz alignment.
        json_path = pdf_path.with_suffix(".mcid.json")
        visualize_mcid_func(str(pdf_path), str(viz_output), json_path=str(json_path))
        print(f"[Visualize] Success: {viz_output}")
    except BaseException as e:
        import traceback
        traceback.print_exc()
        # Ensure we don't leave behind a stale/incorrect visualization file.
        if viz_output.exists():
            viz_output.unlink()
        if isinstance(e, SystemExit):
             raise
        raise SystemExit(f"[Visualize] ERROR: visualize-mcid failed: {e}")

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
    parser.add_argument('--reuse-containers', action='store_true', default=True,
                        help="Reuse Docker containers across papers (default: enabled)")
    parser.add_argument('--no-reuse-containers', action='store_false', dest='reuse_containers',
                        help="Disable container reuse (start new container per command)")
    parser.add_argument('--flat', action='store_true',
                        help="Treat all top-level subdirectories in --batch path as papers (disable recursive search)")
    parser.add_argument('--visualize', action='store_true', default=True,
                        help="Generate MCID visualization after successful compile (default: enabled)")
    parser.add_argument('--no-visualize', action='store_false', dest='visualize',
                        help="Disable MCID visualization output")
    parser.add_argument('--debug', action='store_true', default=False,
                        help="Enable debug mode for lpsb-mcid.sty (outputs verbose debug info to log)")

    args = parser.parse_args()

    # Determine LPSB root (parent of script dir)
    script_dir = Path(__file__).parent.resolve()
    lpsb_root = script_dir.parent # usually LPSB/script/.. -> LPSB
    if args.single:
        print(f"Processing SINGLE paper: {args.single}")
        res = process_one_paper(args.single, args.output, lpsb_root, not args.no_ramdisk, lpsb_debug=args.debug)
        print(f"Result: {res}")
        
        # Optional visualization of MCID tags
        if res == "SUCCESS" and args.visualize:
            _run_visualization(args.output, script_dir)
        
    elif args.batch:
        src_root = Path(args.batch)
        papers = []
        # Prefer directory-per-paper layout when present (common for extracted corpora
        # and for our own cached build dirs). This avoids treating every auxiliary
        # *.tex file inside a paper as a separate "paper".
        if args.flat:
            # Explicit flat mode: accept all subdirectories
            try:
                papers = [
                    p for p in src_root.iterdir()
                    if p.is_dir() and not p.name.startswith(('.', '_'))
                ]
                papers = sorted(papers)
            except Exception:
                papers = []
        else:
            # Auto-detection mode
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
        multi_version_pool = None
        paper_versions = {}  # paper_path -> version
        use_container_reuse = args.reuse_containers
        
        if use_container_reuse:
            out_path = Path(args.output).resolve()
            out_path.mkdir(parents=True, exist_ok=True)
            
            # Determine shared volume - use RAMdisk if available and enabled
            if not args.no_ramdisk and Path("/dev/shm").exists():
                shared_vol = Path("/dev/shm/lpsb_workdir")
                shared_vol.mkdir(parents=True, exist_ok=True)
                print("Using RAM disk shared volume for container reuse: /dev/shm/lpsb_workdir")
            else:
                shared_vol = out_path
                if not args.no_ramdisk:
                    print("Warning: RAMdisk requested but /dev/shm not available, using output directory")
            
            # Pre-scan papers to detect TeX Live versions
            print("Pre-scanning papers to detect TeX Live versions...")
            versions_needed = set()
            for p in papers:
                ver = prescan_paper_version(p)
                paper_versions[str(p)] = ver
                versions_needed.add(ver)
            
            print(f"Detected versions: {', '.join(f'TL{v}' for v in sorted(versions_needed))}")
            
            # Start multi-version container pool
            multi_version_pool = MultiVersionContainerPool(shared_volume=shared_vol)
            try:
                multi_version_pool.start_for_versions(versions_needed)
                print(f"Started containers: {list(multi_version_pool.version_containers.keys())}")
            except Exception as e:
                print(f"Failed to start container pool: {e}")
                print("Falling back to non-reuse mode")
                use_container_reuse = False
                multi_version_pool = None
        
        tasks = []
        for i, p in enumerate(papers):
            # Assign container based on detected version
            if use_container_reuse and multi_version_pool:
                ver = paper_versions.get(str(p), ARXIV_TEXLIVE_DEFAULT)
                cname = multi_version_pool.get_container_for_version(ver)
                # When using container reuse, work directory must be under shared_vol
                # which is mounted as /workdir in the container
                work_base = shared_vol
            else:
                cname = None
                work_base = Path(args.output)
            tasks.append((p, work_base, lpsb_root, not args.no_ramdisk, False, cname, args.output))

            
        results = {'SUCCESS': 0, 'FAIL': 0, 'TIMEOUT': 0, 'ERROR': 0, 'NO_MAIN': 0}
        
        with ProcessPoolExecutor(max_workers=args.workers) as executor:
            futures = {executor.submit(batch_worker, task): task[0].name for task in tasks}
            
            # Use tqdm for progress bar
            pbar = tqdm(as_completed(futures), total=len(futures), desc="Compiling", unit="paper")
            
            for f in pbar:
                pid = futures[f]
                try:
                    res = f.result()
                    # Track WITHDRAWN and NOT_TEX as SKIPPED (source issues, not LPSB bugs)
                    if res in ('WITHDRAWN', 'NOT_TEX', 'FALSE_POSITIVE'):
                        results['SKIPPED'] = results.get('SKIPPED', 0) + 1
                        if res == 'FALSE_POSITIVE':
                            results['FALSE_POSITIVE'] = results.get('FALSE_POSITIVE', 0) + 1
                    else:
                        results[res] = results.get(res, 0) + 1
                    pbar.set_postfix(
                        S=results.get('SUCCESS', 0), 
                        F=results.get('FAIL', 0), 
                        FP=results.get('FALSE_POSITIVE', 0),
                        Skip=results.get('SKIPPED', 0)
                    )
                except Exception as e:
                    pbar.set_postfix(S=results.get('SUCCESS', 0), F=results.get('FAIL', 0), E=results.get('ERROR', 0)+1)
                    results['ERROR'] = results.get('ERROR', 0) + 1
                    
        print("\nSummary:")
        print(results)
        
        # Clean up container pool
        if multi_version_pool is not None:
            print("Stopping Docker containers...")
            multi_version_pool.stop()
            print("Containers stopped.")
        
    else:
        parser.print_help()

if __name__ == "__main__":
    main()
