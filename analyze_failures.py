import os
import re
import argparse
from pathlib import Path
from collections import Counter, defaultdict

def get_error(log_path):
    if not os.path.exists(log_path):
        return "Log file missing"
    
    with open(log_path, 'r', errors='ignore') as f:
        content = f.read()
        
    # Check if FALSE POSITIVE (verification says source failed too)
    if "=== VERIFICATION: Source also fails WITHOUT LPSB ===" in content:
        return "FALSE_POSITIVE (Ignored)"

    lines = content.splitlines()
    error = None
    context = []
    
    # Simple state machine to capture the first error
    for i, line in enumerate(lines):
        if line.startswith("!"):
            # Skip some common meaningless errors
            if "fail" in line.lower() and "pdf" in line.lower(): 
                 continue
            if "Emergency stop" in line:
                # Emergency stop usually follows the real error
                continue
            if "Command \\lpsb@layout already defined" in line:
                 continue
                 
            error = line.strip()
            # Grab context
            if i+1 < len(lines): context.append(lines[i+1].strip())
            
            # --- CLUSTERING LOGIC ---
            
            # 1. Recursion / Capacity
            if "TeX capacity exceeded" in error:
                return "TeX Capacity Exceeded (Recursion)"
                
            # 2. PDF Metadata / Hyperref
            if "Token not allowed in a PDF string" in error:
                return "PDF Metadata Pollution (Token not allowed)"
                
            # 3. URL Scanning
            if "File ended while scanning use of" in error and ("url" in error or "Url" in error):
                return "URL Scanning Error"
                
            # 4. Undefined Control Sequence
            if "Undefined control sequence" in error:
                 seq = context[0] if context else ""
                 if "lpsb" in seq:
                     return f"Undefined LPSB Command: {seq}"
                 if "url" in seq or "href" in seq:
                     return f"Undefined URL/Href: {seq}"
                 return f"Undefined control sequence: {seq}"

            # 5. Argument Scanning (Hook Mismatch)
            if "Use of" in error and "doesn't match its definition" in error:
                if "lpsb@" in error or "institute" in error or "author" in error:
                     return "LPSB Hook Mismatch (Institute/Author)"
                return f"Hook Mismatch: {error}"
            if "Argument of" in error and "has an extra }" in error:
                 return f"Argument Scanning Error: {error}"

            # 6. DVI Mode
            if "pdfTeX error" in error and "DVI mode" in error:
                return "DVI Mode Conflict"
            
            return error
            
    return "No '!' error found (check log)"

def main():
    parser = argparse.ArgumentParser()
    parser.add_argument('scan_dir', help="Directory to scan (e.g., output/batch_v4)")
    args = parser.parse_args()
    
    scan_path = Path(args.scan_dir)
    compile_logs = list(scan_path.rglob("compile.log"))
    
    print(f"Scanning {len(compile_logs)} logs in {scan_path}...")
    
    counter = Counter()
    details = defaultdict(list)
    
    for log in compile_logs:
        paper_id = log.parent.name
        err = get_error(log)
        if err.startswith("FALSE_POSITIVE"):
            continue
            
        counter[err] += 1
        details[err].append(paper_id)
        
    print(f"\nAnalyzed {sum(counter.values())} TRUE FAILURES (excluding False Positives)\n")
    print("Error Summary:")
    print("-" * 60)
    for err, count in counter.most_common():
        print(f"{count:4d} : {err}")
        if count < 10:
             print(f"        IDs: {', '.join(details[err])}")

if __name__ == '__main__':
    main()
