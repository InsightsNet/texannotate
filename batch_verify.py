
import os
import shutil
import subprocess
import glob
import sys

# Path setup
LPSB_ROOT = "/home/duan/rainbow_2/LPSB"
TEST_DIR = os.path.join(LPSB_ROOT, "test_output_lua")
LPSB_STY = os.path.join(LPSB_ROOT, "lpsb.sty")
sys.path.insert(0, LPSB_ROOT)
from solver import StructureTreeBuilder

target_roles = ['Table', 'TR', 'L', 'LI', 'P']

papers = [d for d in os.listdir(TEST_DIR) if d.startswith("arXiv-") and os.path.isdir(os.path.join(TEST_DIR, d))]
papers.sort()

print(f"{'Paper':<25} | {'File':<12} | {'Comp':<5} | {'Mismatches':<15} | {'Status'}")
print("-" * 85)

for paper in papers:
    paper_dir = os.path.join(TEST_DIR, paper)
    
    # 1. Detect main file
    tex_files = glob.glob(os.path.join(paper_dir, "*.tex"))
    if not tex_files:
        print(f"{paper:<25} | {'???':<12} | {'???':<5} | {'No .tex':<15} | Fail")
        continue
    
    # Simple heuristic: prefer 'main.tex' or 'manuscript.tex', else take first
    main_tex = None
    for name in ['manuscript.tex', 'main.tex', 'article.tex']:
        for f in tex_files:
            if os.path.basename(f) == name:
                main_tex = f
                break
        if main_tex: break
    if not main_tex: main_tex = tex_files[0]
    
    tex_basename = os.path.basename(main_tex)
    json_basename = tex_basename.replace('.tex', '.lpsb.json')
    
    # 2. Copy lpsb.sty
    shutil.copy(LPSB_STY, os.path.join(paper_dir, "lpsb.sty"))
    
    # 3. Compile (Twice for coords)
    cmd = f"docker run --rm -v {paper_dir}:/workdir -w /workdir lpsb-texlive:latest lualatex -interaction=nonstopmode {tex_basename}"
    
    # Run silently
    subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    res = subprocess.run(cmd, shell=True, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
    
    comp_status = "OK" if res.returncode == 0 else "Fail"
    
    mismatch_str = "?"
    status_str = "?"
    
    if comp_status == "OK":
        json_path = os.path.join(paper_dir, json_basename)
        if os.path.exists(json_path):
            try:
                builder = StructureTreeBuilder(json_path)
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
            except: 
                mismatch_str = "JSON Err"
                status_str = "Fail"
        else:
            mismatch_str = "No JSON"
            status_str = "Fail"
            
    print(f"{paper:<25} | {tex_basename:<12} | {comp_status:<5} | {mismatch_str:<15} | {status_str}")
