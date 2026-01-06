#!/usr/bin/env python3
"""
Analyze PDF line counts to detect visual artifacts.
Compares two PDFs and reports line count differences.
"""
import sys
import pdfplumber

def is_horizontal(line):
    """Check if line is horizontal (within 1pt tolerance)."""
    return abs(line['top'] - line['bottom']) < 1

def analyze_pdf(pdf_path):
    """Extract line statistics from PDF."""
    try:
        pdf = pdfplumber.open(pdf_path)
        if len(pdf.pages) == 0:
            return None
        
        page = pdf.pages[0]
        lines = page.lines
        
        horizontal = [l for l in lines if is_horizontal(l)]
        vertical = [l for l in lines if not is_horizontal(l)]
        
        return {
            'total': len(lines),
            'horizontal': len(horizontal),
            'vertical': len(vertical)
        }
    except Exception as e:
        print(f"Error analyzing {pdf_path}: {e}", file=sys.stderr)
        return None

def main():
    if len(sys.argv) < 3:
        print("Usage: analyze_pdf_lines.py <pdf1> <pdf2>")
        print("  Compares line counts between two PDFs")
        sys.exit(1)
    
    pdf1_path = sys.argv[1]
    pdf2_path = sys.argv[2]
    
    stats1 = analyze_pdf(pdf1_path)
    stats2 = analyze_pdf(pdf2_path)
    
    if stats1 is None or stats2 is None:
        sys.exit(1)
    
    print(f"PDF 1 ({pdf1_path}):")
    print(f"  Total: {stats1['total']} lines")
    print(f"  Horizontal: {stats1['horizontal']}")
    print(f"  Vertical: {stats1['vertical']}")
    print()
    
    print(f"PDF 2 ({pdf2_path}):")
    print(f"  Total: {stats2['total']} lines")
    print(f"  Horizontal: {stats2['horizontal']}")
    print(f"  Vertical: {stats2['vertical']}")
    print()
    
    diff_total = stats1['total'] - stats2['total']
    diff_h = stats1['horizontal'] - stats2['horizontal']
    diff_v = stats1['vertical'] - stats2['vertical']
    
    print("Difference (PDF1 - PDF2):")
    print(f"  Total: {diff_total:+d} lines")
    print(f"  Horizontal: {diff_h:+d}")
    print(f"  Vertical: {diff_v:+d}")
    
    if diff_v != 0:
        print()
        print(f"⚠️  VERTICAL LINE DIFFERENCE DETECTED: {diff_v:+d}")
        if diff_v > 0:
            print(f"   PDF1 has {diff_v} MORE vertical lines")
        else:
            print(f"   PDF1 has {abs(diff_v)} FEWER vertical lines")

if __name__ == '__main__':
    main()

