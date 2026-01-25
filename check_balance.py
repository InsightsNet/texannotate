import re
import sys

def check_balance(filename):
    with open(filename, 'r') as f:
        content = f.read()

    # We need to preserve newlines to count lines
    # So we can't just strip comments blindly if we want specific line numbers
    # But regex matching on full content with newlines is okay.
    
    # Strategy: iterate through tokens found by regex, calculate line number by counting newlines up to that point.
    
    # First, strip comments but keep newlines
    # Replace comment content with spaces to preserve char indices? 
    # Or just careful parsing.
    
    # Simplest: Split by lines, parse line by line.
    
    lines = content.split('\n')
    stack = [] # (token, line_num, original_line_content)
    
    errors = []
    
    in_if_stack_depth = 0
    
    for line_idx, line in enumerate(lines):
        line_num = line_idx + 1
        
        # Strip comment from line: %...
        # Be careful of \%
        # Simple approach: 
        stripped_line = re.sub(r'([^\\])%.*', r'\1', line)
        if line.lstrip().startswith('%'):
             stripped_line = ''
             
        # Also remove \newif\if...
        stripped_line = re.sub(r'\\newif\s*\\if[a-zA-Z@]+', '', stripped_line)
        
        # Find tokens
        tokens = re.finditer(r'\\([a-zA-Z@]+)', stripped_line)
        
        for match in tokens:
            token = match.group(1)
            
            if token in ['newif', 'iff']:
                continue
            
            if token == 'iftoggle': 
                continue
                
            if token.startswith('if'):
                stack.append((token, line_num, stripped_line.strip()))
            
            elif token == 'fi':
                if not stack:
                    errors.append(f"Extra \\fi at line {line_num}: {stripped_line.strip()}")
                else:
                    stack.pop()

    print(f"--- {filename} ---")
    if errors:
        for e in errors: print(e)
    if stack:
        print(f"Unclosed \\if(s):")
        for item in stack:
            print(f"  Line {item[1]}: {item[0]} (Context: {item[2]})")

if __name__ == "__main__":
    for arg in sys.argv[1:]:
        check_balance(arg)
