import pdfplumber
import sys

def check_lines(pdf_path):
    print(f"Checking {pdf_path}...")
    try:
        with pdfplumber.open(pdf_path) as pdf:
            for i, page in enumerate(pdf.pages):
                lines = page.lines
                height = page.height
                print(f"Page {i+1}: Found {len(lines)} lines. Page Height: {height:.2f}")
                # Sort by top position (y)
                lines.sort(key=lambda x: x['top'])
                
                # Check for lines very close to bottom
                bottom_threshold = height - 50 # Arbitrary threshold near bottom
                bottom_lines = [l for l in lines if l['top'] > bottom_threshold]
                
                if bottom_lines:
                    print(f"  Found {len(bottom_lines)} lines near bottom:")
                    for l in bottom_lines:
                        print(f"    Line: top={l['top']:.2f}, bottom={l['bottom']:.2f}, x0={l['x0']:.2f}, x1={l['x1']:.2f}")
                    
                    # Check for duplicates (lines with very similar y coordinates)
                    last_y = -1
                    for l in bottom_lines:
                        y = l['top']
                        if abs(y - last_y) < 2.0: # 2 points threshold
                            print(f"    !!! POTENTIAL ARTIFACT: Line at {y:.2f} is suspiciously close to line at {last_y:.2f}")
                        last_y = y
                else:
                    print("  No lines near bottom.")

    except Exception as e:
        print(f"Error opening/processing PDF: {e}")

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python verify_lines.py <pdf_path>")
    else:
        check_lines(sys.argv[1])
