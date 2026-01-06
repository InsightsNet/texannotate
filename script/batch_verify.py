import os
import shutil
import subprocess
import glob
import sys
from pathlib import Path

# Path setup
LPSB_ROOT = Path(os.environ.get("LPSB_DIR", Path(__file__).resolve().parent)).resolve()
TEST_DIR = Path(os.environ.get("LPSB_OUT_LUA_DIR", os.environ.get("LPSB_OUTPUT_LUA_DIR", str(LPSB_ROOT / "test_output_lua")))).resolve()
LPSB_STY = (LPSB_ROOT / "lpsb.sty").resolve()
DOCKER_IMAGE = os.environ.get("LPSB_DOCKER_IMAGE", "lpsb-texlive:latest")

sys.path.insert(0, str(LPSB_ROOT))
from solver import StructureTreeBuilder

target_roles = ['Table', 'TR', 'L', 'LI', 'P']

if not TEST_DIR.is_dir():
    raise SystemExit(f"TEST_DIR not found: {TEST_DIR} (set LPSB_OUT_LUA_DIR / LPSB_OUTPUT_LUA_DIR)")
if not LPSB_STY.is_file():
    raise SystemExit(f"lpsb.sty not found under LPSB_DIR: {LPSB_ROOT} (set LPSB_DIR)")

papers = [d for d in os.listdir(TEST_DIR) if d.startswith("arXiv-") and (TEST_DIR / d).is_dir()]
papers.sort()

print(f"{'Paper':<25} | {'File':<12} | {'Comp':<5} | {'Mismatches':<15} | {'Status'}")
print("-" * 85)

for paper in papers:
    paper_dir = TEST_DIR / paper
    
    # 1. Detect main file
    tex_files = [p for p in paper_dir.glob("*.tex") if p.is_file()]
    if not tex_files:
        tex_files = [p for p in paper_dir.glob("*/*.tex") if p.is_file()]
    if not tex_files:
        print(f"{paper:<25} | {'???':<12} | {'???':<5} | {'No .tex':<15} | Fail")
        continue
    
    # Simple heuristic: prefer 'main.tex' or 'manuscript.tex', else take first
    main_tex = None
    for name in ['manuscript.tex', 'main.tex', 'article.tex']:
        for f in tex_files:
            if f.name == name:
                main_tex = f
                break
        if main_tex: break
    if not main_tex: main_tex = tex_files[0]
    
    tex_basename = main_tex.name
    json_basename = tex_basename.replace('.tex', '.lpsb.json')
    workdir = main_tex.parent
    
    # 2. Copy lpsb.sty
    shutil.copy(LPSB_STY, workdir / "lpsb.sty")
    
    # 3. Compile (Twice for coords)
    rel_wd = os.path.relpath(str(workdir), str(paper_dir))
    container_wd = "/workdir" if rel_wd == "." else f"/workdir/{rel_wd}"
    cmd = [
        "docker", "run", "--rm",
        "-v", f"{paper_dir}:/workdir",
        "-w", container_wd,
        DOCKER_IMAGE,
        "lualatex", "-interaction=nonstopmode", tex_basename,
    ]
    subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    res = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    comp_status = "OK" if res.returncode == 0 else "Fail"
    
    mismatch_str = "?"
    status_str = "?"
    
    if comp_status == "OK":
        json_path = workdir / json_basename
        if json_path.exists():
            try:
                builder = StructureTreeBuilder(str(json_path))
                builder.load_events()
                mismatches = 0
                stack = []
                for event in builder.events:
                    role = event.get('role')
                    evt_type = event.get('event')
                    if evt_type == 'start': stack.append(role)
                    elif evt_type == 'end':
                        if stack:
                            exp = stack.pop()
                            if exp != role and (role in target_roles or exp in target_roles):
                                mismatches += 1
                        else: mismatches += 1
                
                mismatch_str = str(mismatches)
                if mismatches == 0: status_str = "Perfect"
                elif mismatches < 50: status_str = "Good"
                else: status_str = "Issues"
            except Exception:
                mismatch_str = "JSON Err"
                status_str = "Fail"
        else:
            mismatch_str = "No JSON"
            status_str = "Fail"
            
    print(f"{paper:<25} | {tex_basename:<12} | {comp_status:<5} | {mismatch_str:<15} | {status_str}")
