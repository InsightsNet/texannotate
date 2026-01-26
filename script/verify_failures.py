#!/usr/bin/env python3
"""
Verify compilation failures by re-running without LPSB injection.

For each failed paper:
1. Compile WITHOUT injecting lpsb-mcid.sty
2. If compilation succeeds without LPSB -> TRUE FAILURE (LPSB caused it)
3. If compilation fails without LPSB -> FALSE POSITIVE (source is inherently broken)

Usage:
  python3 verify_failures.py --failed-list failed_papers.txt --data-dir data/arxiv/arxiv_extracted --output-dir output/batch_final_v3 [--workers 8] [--timeout 120]
"""

import argparse
import os
import re
import shutil
import subprocess
import tarfile
import gzip
import tempfile
from pathlib import Path
from concurrent.futures import ProcessPoolExecutor, as_completed
from typing import Optional, Tuple

# Default timeout for compilation (seconds)
DEFAULT_TIMEOUT = 120

# Docker image for compilation
DOCKER_IMAGE = "lpsb-texlive:TL2020-historic"


def find_main_tex(work_dir: Path) -> Optional[Path]:
    """Heuristic to find the main tex file."""
    tex_files = list(work_dir.rglob("*.tex"))
    if not tex_files:
        return None
        
    # Prefer files with \documentclass
    for f in tex_files:
        try:
            content = f.read_text(errors='ignore')[:5000]
            if r'\documentclass' in content and r'\begin{document}' in content:
                return f
        except:
            continue
    
    # Fallback: first .tex file
    if tex_files:
        print(f"[WARN] verify_failures: fallback to first .tex file ({tex_files[0].name})")
        return tex_files[0]
    return None


def extract_paper(src_file: Path, dst_dir: Path) -> bool:
    """Extract .gz archive (tar or single file) to dst_dir."""
    if not src_file.exists():
        return False
        
    # Check if it's a tar.gz
    try:
        if tarfile.is_tarfile(src_file):
            with tarfile.open(src_file) as tar:
                safe_members = [m for m in tar.getmembers() 
                               if not m.name.startswith('/') and '..' not in m.name]
                tar.extractall(path=dst_dir, members=safe_members, filter='data')
            return True
    except:
        print("[WARN] verify_failures: tar detection failed, falling back to single-file gzip")
    
    # Single-file gzip
    try:
        target_name = src_file.stem
        if not target_name.endswith('.tex'):
            target_path = dst_dir / f"{target_name}.tex"
        else:
            target_path = dst_dir / target_name
            
        with gzip.open(src_file, 'rb') as f_in:
            with open(target_path, 'wb') as f_out:
                shutil.copyfileobj(f_in, f_out)
        return True
    except Exception as e:
        return False


def compile_without_lpsb(paper_id: str, data_dir: Path, timeout: int) -> Tuple[str, str, bool]:
    """
    Compile a paper WITHOUT LPSB injection.
    
    Returns:
        (paper_id, status, compiled_successfully)
        status: "SUCCESS" | "FAIL" | "TIMEOUT" | "ERROR"
    """
    # Find source file
    year = paper_id[:4]
    src_patterns = [
        data_dir / year / f"{paper_id}.gz",
        data_dir / year / paper_id,
        data_dir / f"{paper_id}.gz",
    ]
    
    src_file = None
    for p in src_patterns:
        if p.exists():
            src_file = p
            break
            
    if src_file is None:
        return (paper_id, "SOURCE_NOT_FOUND", False)
    
    # Create temp work directory
    with tempfile.TemporaryDirectory(prefix=f"verify_{paper_id}_") as tmp_dir:
        work_dir = Path(tmp_dir)
        
        # Extract
        if src_file.is_dir():
            # Copy directory
            shutil.copytree(src_file, work_dir / "src", dirs_exist_ok=True)
            work_dir = work_dir / "src"
        else:
            if not extract_paper(src_file, work_dir):
                return (paper_id, "EXTRACT_FAILED", False)
        
        # Find main tex
        main_tex = find_main_tex(work_dir)
        if main_tex is None:
            return (paper_id, "NO_MAIN_TEX", False)
        
        main_name = main_tex.name
        tex_dir = main_tex.parent
        
        # Compile WITHOUT LPSB (just vanilla pdflatex)
        log_file = work_dir / "compile.log"
        
        try:
            docker_cmd = [
                "docker", "run", "--rm",
                "--net", "none",
                "-v", f"{tex_dir}:/work",
                "-w", "/work",
                DOCKER_IMAGE,
                "pdflatex", "-interaction=nonstopmode", "-synctex=0", main_name
            ]
            
            with open(log_file, "w") as log:
                result = subprocess.run(
                    docker_cmd,
                    stdout=log,
                    stderr=subprocess.STDOUT,
                    timeout=timeout,
                    check=False
                )
            
            # Check if PDF was created
            pdf_path = tex_dir / main_name.replace('.tex', '.pdf')
            if pdf_path.exists() and pdf_path.stat().st_size > 1000:
                return (paper_id, "SUCCESS", True)
            else:
                return (paper_id, "FAIL", False)
                
        except subprocess.TimeoutExpired:
            return (paper_id, "TIMEOUT", False)
        except Exception as e:
            return (paper_id, f"ERROR: {str(e)[:50]}", False)


def main():
    parser = argparse.ArgumentParser(description="Verify compilation failures")
    parser.add_argument('--failed-list', required=True, 
                        help="File containing failed paper IDs (one per line)")
    parser.add_argument('--data-dir', required=True,
                        help="Directory containing arxiv source files (e.g. data/arxiv/arxiv_extracted)")
    parser.add_argument('--output-dir', default=None,
                        help="Output directory for verification results")
    parser.add_argument('--workers', type=int, default=8,
                        help="Number of parallel workers")
    parser.add_argument('--timeout', type=int, default=DEFAULT_TIMEOUT,
                        help=f"Compilation timeout in seconds (default: {DEFAULT_TIMEOUT})")
    parser.add_argument('--limit', type=int, default=0,
                        help="Limit number of papers to verify (0 = all)")
    
    args = parser.parse_args()
    
    # Read failed paper list
    failed_list = Path(args.failed_list)
    if not failed_list.exists():
        print(f"Error: Failed list not found: {failed_list}")
        return
        
    papers = [line.strip() for line in failed_list.read_text().splitlines() if line.strip()]
    if args.limit > 0:
        papers = papers[:args.limit]
        
    print(f"Verifying {len(papers)} failed papers (timeout={args.timeout}s, workers={args.workers})")
    
    data_dir = Path(args.data_dir)
    
    # Process papers in parallel
    true_failures = []    # LPSB caused failure (source works without LPSB)
    false_positives = []  # Source is inherently broken
    other_issues = []     # Couldn't verify
    
    with ProcessPoolExecutor(max_workers=args.workers) as executor:
        futures = {
            executor.submit(compile_without_lpsb, pid, data_dir, args.timeout): pid 
            for pid in papers
        }
        
        for f in as_completed(futures):
            pid = futures[f]
            try:
                paper_id, status, success_without_lpsb = f.result()
                
                if success_without_lpsb:
                    # Source compiles without LPSB -> LPSB caused the failure
                    true_failures.append(paper_id)
                    print(f"[TRUE FAILURE] {paper_id} - LPSB caused this failure")
                elif status in ("FAIL", "TIMEOUT"):
                    # Source also fails without LPSB -> inherently broken
                    false_positives.append(paper_id)
                    print(f"[FALSE POSITIVE] {paper_id} - source is inherently broken")
                else:
                    # Other issues (source not found, etc.)
                    other_issues.append((paper_id, status))
                    print(f"[{status}] {paper_id}")
                    
            except Exception as e:
                other_issues.append((pid, str(e)[:50]))
                print(f"[ERROR] {pid}: {e}")
    
    # Summary
    print("\n" + "="*60)
    print("VERIFICATION SUMMARY")
    print("="*60)
    print(f"TRUE FAILURES (LPSB caused):     {len(true_failures):4d}")
    print(f"FALSE POSITIVES (source broken): {len(false_positives):4d}")
    print(f"OTHER ISSUES:                    {len(other_issues):4d}")
    print("="*60)
    
    # Write results to files
    if args.output_dir:
        out_dir = Path(args.output_dir)
        out_dir.mkdir(parents=True, exist_ok=True)
        
        # True failures - these need LPSB fixes
        true_file = out_dir / "true_failures.txt"
        true_file.write_text("\n".join(true_failures) + "\n")
        print(f"\nTrue failures written to: {true_file}")
        
        # False positives - source is broken, not LPSB's fault
        false_file = out_dir / "false_positives.txt"
        false_file.write_text("\n".join(false_positives) + "\n")
        print(f"False positives written to: {false_file}")
        
        # Other issues
        other_file = out_dir / "verification_other.txt"
        other_file.write_text("\n".join(f"{pid}: {status}" for pid, status in other_issues) + "\n")
        print(f"Other issues written to: {other_file}")
    
    print("\nDone.")


# Standalone execution entrypoints are intentionally removed.
# Use repo root `main.py` instead:
#   python3 main.py verify-failures ...
