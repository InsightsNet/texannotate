import sys
import re

def check_pdf_pymupdf(pdf_path, check_bib=True):
    """
    Verify PDF content using pymupdf (fitz).
    Checks for:
    1. Basic readability (opening the file).
    2. Presence of bibliography numbers (e.g., [1], [2]) if check_bib is True.
    3. Absence of the [0] artifact pattern.
    """
    try:
        import fitz  # pymupdf
    except ImportError:
        print("Error: pymupdf is not installed. Please run: pip install pymupdf")
        sys.exit(1)

    print(f"Opening {pdf_path} with pymupdf...")
    
    try:
        doc = fitz.open(pdf_path)
    except Exception as e:
        print(f"FAILED: Could not open PDF: {e}")
        return False

    print(f"PDF Info: {doc.page_count} pages, {doc.metadata.get('format', 'PDF')}")
    
    found_bib_numbers = []
    found_zero_numbers = 0
    full_text = ""
    
    # Iterate through pages to extract text
    for page_num, page in enumerate(doc):
        text = page.get_text()
        full_text += text
        
        # Look for [number] patterns
        # We look for patterns typically found in references: line start or explicit brackets
        # But simple search for [1], [2] is usually enough for a sanity check
        
        # Find all [N] occurrences
        matches = re.findall(r'\[(\d+)\]', text)
        for m in matches:
            num = int(m)
            if num == 0:
                found_zero_numbers += 1
            elif num > 0:
                found_bib_numbers.append(num)

    doc.close()

    print("-" * 40)
    print("Verification Results:")
    
    # Analysis
    unique_bibs = sorted(list(set(found_bib_numbers)))
    
    print(f"Found {len(found_bib_numbers)} valid citation numbers ([1], [2]...)")
    print(f"Found {found_zero_numbers} zero citations ([0])")
    
    if unique_bibs:
        print(f"Sample citations found: {unique_bibs[:10]} ...")
    
    is_success = True
    
    if check_bib:
        if len(unique_bibs) == 0:
            print("WARNING: No valid citation numbers [1-9] found.")
            # It might be an author-year style, so we check for that slightly differently or just warn
            # But if we see [0], that's definitely bad.
        
        if found_zero_numbers > 5 and len(unique_bibs) < 5:
            print("FAILURE: found mostly [0] citations. Bibliography broken.")
            is_success = False
        elif found_zero_numbers > 0:
             print(f"WARNING: Found {found_zero_numbers} instances of [0]. check if these are valid.")
             
        if len(unique_bibs) > 0:
            print("SUCCESS: Valid bibliography numbering detected.")
    
    # Optional keyword check
    if len(sys.argv) > 2:
        keyword = sys.argv[2]
        if keyword in full_text:
             print(f"SUCCESS: Found keyword '{keyword}' in text.")
        else:
             print(f"WARNING: Keyword '{keyword}' not found.")
             
    return is_success

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python3 verify_pdf_simple.py <pdf_file> [keyword]")
    else:
        success = check_pdf_pymupdf(sys.argv[1])
        sys.exit(0 if success else 1)
