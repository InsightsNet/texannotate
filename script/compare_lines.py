import pdfplumber
import sys

def check_lines(pdf_path, label):
    print(f"--- Checking {label} ({pdf_path}) ---")
    try:
        with pdfplumber.open(pdf_path) as pdf:
            pages = list(pdf.pages)
            last_page_idx = len(pages) - 1
            last_page = pages[last_page_idx]
            
            print(f"Last Page ({last_page_idx+1}): Height {last_page.height:.2f}")
            lines = last_page.lines
            lines.sort(key=lambda x: (x['top'], x['x0']))
            
            print(f"Found {len(lines)} lines on last page:")
            for l in lines:
                print(f"  Line: top={l['top']:.2f}, bottom={l['bottom']:.2f}, x0={l['x0']:.2f}, x1={l['x1']:.2f}, width={l['width']:.2f}, height={l['height']:.2f}")

            # If rotated, maybe check Page 2?
            if "rotated" in pdf_path:
                print("Checking Page 2 (Rotated table body):")
                p2 = pages[1]
                lines2 = p2.lines
                lines2.sort(key=lambda x: (x['top'], x['x0']))
                print(f"Found {len(lines2)} lines on Page 2:")
                for l in lines2:
                     print(f"  Line: top={l['top']:.2f}, bottom={l['bottom']:.2f}, x0={l['x0']:.2f}, x1={l['x1']:.2f}")

    except Exception as e:
        print(f"Error: {e}")
    print("\n")

if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: python compare_lines.py <lpsb_pdf> <control_pdf> [rotated_pdf]")
    else:
        check_lines(sys.argv[1], "LPSB Longtable")
        check_lines(sys.argv[2], "Control Longtable")
        if len(sys.argv) > 3:
            check_lines(sys.argv[3], "LPSB Rotated")
