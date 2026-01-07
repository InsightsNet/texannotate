"""
LPSB Docker Compilation Service

FastAPI service that compiles LaTeX with LPSB injector and returns
both PDF and probe data.
"""

import base64
import os
import subprocess
import tarfile
import tempfile
from pathlib import Path
from typing import Optional

import aiofiles
from fastapi import FastAPI, File, Form, UploadFile, HTTPException
from fastapi.responses import JSONResponse

app = FastAPI(
    title="LPSB Compilation Service",
    description="LaTeX-PDF Semantic Bridge compilation with probe injection",
    version="1.0.0"
)

# Path to LPSB injector (copied into Docker image)
LPSB_INJECTOR = Path("/lpsb/lpsb_injector.tex")


def find_main_tex(sources_dir: Path) -> Optional[Path]:
    """Find the main .tex file in a directory."""
    # Priority order for detecting main file
    candidates = [
        "main.tex", "paper.tex", "article.tex", "document.tex",
        "manuscript.tex", "thesis.tex"
    ]
    
    for name in candidates:
        path = sources_dir / name
        if path.exists():
            return path
    
    # Fallback: find any .tex file with \documentclass
    for tex_file in sources_dir.glob("*.tex"):
        try:
            content = tex_file.read_text(errors='ignore')
            if r'\documentclass' in content:
                return tex_file
        except:
            continue
    
    # Last resort: first .tex file
    tex_files = list(sources_dir.glob("*.tex"))
    if tex_files:
        return tex_files[0]
    
    return None


def compile_latex_with_lpsb(sources_dir: Path, main_tex: str) -> dict:
    """
    Compile LaTeX with LPSB injector.
    
    Returns dict with:
    - success: bool
    - pdf: base64 encoded PDF bytes (if successful)
    - jsonl: LPSB probe data as string (if successful)
    - log: compilation log
    """
    main_tex_path = sources_dir / main_tex
    if not main_tex_path.exists():
        return {
            "success": False,
            "log": f"Main tex file not found: {main_tex}"
        }
    
    # Copy LPSB injector to sources directory
    injector_dest = sources_dir / "lpsb_injector.tex"
    injector_dest.write_text(LPSB_INJECTOR.read_text())
    
    # Build compilation command
    # Use \input{lpsb_injector.tex} before the main document
    jobname = main_tex_path.stem
    
    # Create wrapper that loads injector first
    wrapper_content = f"\\input{{lpsb_injector.tex}}\\input{{{main_tex}}}"
    
    cmd = [
        "pdflatex",
        "-interaction=nonstopmode",
        "-halt-on-error",
        f"-jobname={jobname}",
        wrapper_content
    ]
    
    try:
        # Run compilation (may need multiple passes)
        for _ in range(2):  # Two passes for references
            result = subprocess.run(
                cmd,
                cwd=sources_dir,
                capture_output=True,
                text=True,
                timeout=300  # 5 minute timeout
            )
        
        log = result.stdout + result.stderr
        
        # Check for output files
        pdf_path = sources_dir / f"{jobname}.pdf"
        jsonl_path = sources_dir / f"{jobname}.lpsb.jsonl"
        
        if pdf_path.exists():
            pdf_bytes = pdf_path.read_bytes()
            pdf_b64 = base64.b64encode(pdf_bytes).decode('utf-8')
            
            jsonl_content = ""
            if jsonl_path.exists():
                jsonl_content = jsonl_path.read_text()
            
            return {
                "success": True,
                "pdf": pdf_b64,
                "jsonl": jsonl_content,
                "log": log[-5000:] if len(log) > 5000 else log  # Truncate long logs
            }
        else:
            return {
                "success": False,
                "log": log[-10000:] if len(log) > 10000 else log
            }
            
    except subprocess.TimeoutExpired:
        return {
            "success": False,
            "log": "Compilation timeout (5 minutes exceeded)"
        }
    except Exception as e:
        return {
            "success": False,
            "log": f"Compilation error: {str(e)}"
        }


@app.post("/compile")
async def compile_endpoint(
    sources: UploadFile = File(..., description="Gzipped tarball of LaTeX sources"),
    main_tex: str = Form(default="", description="Main .tex filename (auto-detected if empty)")
):
    """
    Compile LaTeX sources with LPSB probe injection.
    
    Returns JSON with:
    - success: bool
    - pdf: base64 encoded PDF (if successful)
    - jsonl: LPSB probe data (if successful)
    - log: compilation log
    """
    with tempfile.TemporaryDirectory() as temp_dir:
        temp_path = Path(temp_dir)
        
        # Save uploaded archive
        archive_path = temp_path / "sources.tar.gz"
        async with aiofiles.open(archive_path, 'wb') as f:
            content = await sources.read()
            await f.write(content)
        
        # Extract archive
        sources_dir = temp_path / "sources"
        sources_dir.mkdir()
        
        try:
            with tarfile.open(archive_path, 'r:gz') as tar:
                tar.extractall(sources_dir)
        except tarfile.ReadError:
            # Maybe it's just a gzipped single file
            import gzip
            with gzip.open(archive_path, 'rb') as gz:
                content = gz.read()
                (sources_dir / "main.tex").write_bytes(content)
        
        # Find or use specified main tex file
        if not main_tex:
            main_tex_path = find_main_tex(sources_dir)
            if main_tex_path:
                main_tex = main_tex_path.name
            else:
                return JSONResponse({
                    "success": False,
                    "log": "No .tex file found in sources"
                })
        
        # Compile with LPSB
        result = compile_latex_with_lpsb(sources_dir, main_tex)
        
        return JSONResponse(result)


@app.get("/health")
async def health_check():
    """Health check endpoint for container readiness."""
    return {"status": "healthy", "service": "lpsb-compilation"}


@app.get("/")
async def root():
    """Root endpoint with service info."""
    return {
        "service": "LPSB Compilation Service",
        "version": "1.0.0",
        "endpoints": {
            "/compile": "POST - Compile LaTeX with LPSB injection",
            "/health": "GET - Health check"
        }
    }
