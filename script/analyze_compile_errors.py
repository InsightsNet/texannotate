#!/usr/bin/env python3
"""
Analyze compilation errors from batch_compile_all.sh output.
Generates a categorized error report.
"""
import sys
import re
import os
from pathlib import Path
from collections import defaultdict
from datetime import datetime

def extract_error_patterns(log_file):
    """Extract error patterns from a compilation log."""
    errors = {
        'fatal': [],
        'latex_errors': [],
        'missing_files': [],
        'undefined_commands': [],
        'overfull': 0,
        'underfull': 0,
        'other_warnings': []
    }
    
    if not os.path.exists(log_file):
        return errors
    
    try:
        with open(log_file, 'r', encoding='utf-8', errors='ignore') as f:
            content = f.read()
            lines = content.split('\n')
            
            for i, line in enumerate(lines):
                # Fatal errors
                if line.startswith('!'):
                    errors['fatal'].append(line.strip())
                
                # LaTeX errors
                if 'LaTeX Error:' in line:
                    error_msg = line.strip()
                    # Try to get next line for context
                    if i + 1 < len(lines):
                        next_line = lines[i + 1].strip()
                        if next_line and not next_line.startswith('!'):
                            error_msg += f" ({next_line})"
                    errors['latex_errors'].append(error_msg)
                
                # Missing files
                if 'File' in line and 'not found' in line:
                    match = re.search(r"File `([^']+)' not found", line)
                    if match:
                        errors['missing_files'].append(match.group(1))
                
                # Undefined control sequences
                if 'Undefined control sequence' in line:
                    match = re.search(r"Undefined control sequence.*?\\?([a-zA-Z@]+)", line)
                    if match:
                        errors['undefined_commands'].append(match.group(1))
                
                # Overfull/underfull boxes
                if 'Overfull' in line:
                    errors['overfull'] += 1
                if 'Underfull' in line:
                    errors['underfull'] += 1
                
                # Other warnings
                if 'Warning:' in line and 'LaTeX Warning:' not in line:
                    errors['other_warnings'].append(line.strip())
    except Exception as e:
        print(f"Error reading {log_file}: {e}", file=sys.stderr)
    
    return errors

def analyze_paper(paper_dir):
    """Analyze a single paper's compilation results."""
    paper_name = os.path.basename(paper_dir)
    result = {
        'name': paper_name,
        'pdf_exists': False,
        'json_exists': False,
        'errors': {},
        'status': 'unknown'
    }
    
    # Check for PDF
    pdf_files = list(Path(paper_dir).glob('*.pdf'))
    if pdf_files:
        result['pdf_exists'] = True
        result['pdf_size'] = pdf_files[0].stat().st_size
        result['status'] = 'success'
    else:
        result['status'] = 'failed'
    
    # Check for JSON
    json_files = list(Path(paper_dir).glob('*.lpsb.json'))
    if json_files:
        result['json_exists'] = True
        result['json_lines'] = sum(1 for _ in open(json_files[0], 'rb'))
    
    # Analyze compilation logs
    log_file = os.path.join(paper_dir, 'compile3.log')
    if os.path.exists(log_file):
        result['errors'] = extract_error_patterns(log_file)
        if result['errors']['fatal'] or result['errors']['latex_errors']:
            if result['status'] == 'success':
                result['status'] = 'success_with_errors'
            else:
                result['status'] = 'failed'
    
    return result

def generate_report(results_dir, output_file=None):
    """Generate a comprehensive error report."""
    results_dir = Path(results_dir)
    
    if not results_dir.exists():
        print(f"Error: Results directory not found: {results_dir}", file=sys.stderr)
        return 1
    
    # Analyze all papers
    papers = []
    for paper_dir in sorted(results_dir.iterdir()):
        if paper_dir.is_dir():
            papers.append(analyze_paper(str(paper_dir)))
    
    if not papers:
        print(f"No papers found in {results_dir}", file=sys.stderr)
        return 1
    
    # Categorize errors
    error_categories = {
        'missing_files': defaultdict(list),
        'undefined_commands': defaultdict(int),
        'common_errors': []
    }
    
    status_counts = defaultdict(int)
    total_papers = len(papers)
    successful = 0
    failed = 0
    
    for paper in papers:
        status_counts[paper['status']] += 1
        if paper['status'] == 'success':
            successful += 1
        elif paper['status'] == 'failed':
            failed += 1
        
        # Collect missing files
        for missing_file in paper['errors'].get('missing_files', []):
            error_categories['missing_files'][missing_file].append(paper['name'])
        
        # Collect undefined commands
        for cmd in paper['errors'].get('undefined_commands', []):
            error_categories['undefined_commands'][cmd] += 1
        
        # Collect fatal errors
        if paper['errors'].get('fatal'):
            error_categories['common_errors'].append({
                'paper': paper['name'],
                'type': 'fatal',
                'errors': paper['errors']['fatal'][:3]
            })
    
    # Generate report
    report_lines = []
    report_lines.append("=" * 70)
    report_lines.append("LPSB Compilation Error Analysis Report")
    report_lines.append(f"Generated: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}")
    report_lines.append("=" * 70)
    report_lines.append("")
    
    # Summary
    report_lines.append("SUMMARY")
    report_lines.append("-" * 70)
    report_lines.append(f"Total papers: {total_papers}")
    report_lines.append(f"Successful: {successful} ({successful/total_papers*100:.1f}%)")
    report_lines.append(f"Failed: {failed} ({failed/total_papers*100:.1f}%)")
    report_lines.append(f"Success with errors: {status_counts.get('success_with_errors', 0)}")
    report_lines.append("")
    
    # Status breakdown
    report_lines.append("STATUS BREAKDOWN")
    report_lines.append("-" * 70)
    for status, count in sorted(status_counts.items()):
        report_lines.append(f"  {status}: {count}")
    report_lines.append("")
    
    # Missing files analysis
    if error_categories['missing_files']:
        report_lines.append("MISSING FILES (Most Common)")
        report_lines.append("-" * 70)
        sorted_missing = sorted(
            error_categories['missing_files'].items(),
            key=lambda x: len(x[1]),
            reverse=True
        )[:10]
        for missing_file, papers_list in sorted_missing:
            report_lines.append(f"  {missing_file}")
            report_lines.append(f"    Affects {len(papers_list)} paper(s): {', '.join(papers_list[:3])}")
            if len(papers_list) > 3:
                report_lines.append(f"    ... and {len(papers_list) - 3} more")
        report_lines.append("")
    
    # Undefined commands analysis
    if error_categories['undefined_commands']:
        report_lines.append("UNDEFINED COMMANDS (Most Common)")
        report_lines.append("-" * 70)
        sorted_commands = sorted(
            error_categories['undefined_commands'].items(),
            key=lambda x: x[1],
            reverse=True
        )[:15]
        for cmd, count in sorted_commands:
            report_lines.append(f"  \\{cmd}: appears in {count} paper(s)")
        report_lines.append("")
    
    # Failed papers details
    failed_papers = [p for p in papers if p['status'] == 'failed']
    if failed_papers:
        report_lines.append("FAILED PAPERS DETAILS")
        report_lines.append("-" * 70)
        for paper in failed_papers:
            report_lines.append(f"\nPaper: {paper['name']}")
            if paper['errors'].get('fatal'):
                report_lines.append("  Fatal errors:")
                for err in paper['errors']['fatal'][:3]:
                    report_lines.append(f"    {err}")
            if paper['errors'].get('latex_errors'):
                report_lines.append("  LaTeX errors:")
                for err in paper['errors']['latex_errors'][:3]:
                    report_lines.append(f"    {err}")
            if paper['errors'].get('missing_files'):
                report_lines.append(f"  Missing files: {', '.join(paper['errors']['missing_files'][:5])}")
        report_lines.append("")
    
    # Successful papers
    successful_papers = [p for p in papers if p['status'] == 'success']
    if successful_papers:
        report_lines.append("SUCCESSFUL PAPERS")
        report_lines.append("-" * 70)
        for paper in successful_papers:
            pdf_size_kb = paper.get('pdf_size', 0) // 1024
            json_info = ""
            if paper.get('json_exists'):
                json_info = f", JSON: {paper.get('json_lines', 0)} lines"
            report_lines.append(f"  {paper['name']}: PDF {pdf_size_kb}KB{json_info}")
        report_lines.append("")
    
    report_text = '\n'.join(report_lines)
    
    # Output
    if output_file:
        with open(output_file, 'w', encoding='utf-8') as f:
            f.write(report_text)
        print(f"Report written to: {output_file}")
    else:
        print(report_text)
    
    return 0

def main():
    if len(sys.argv) < 2:
        print("Usage: analyze_compile_errors.py <results_directory> [output_file]")
        print("  Analyzes compilation results from batch_compile_all.sh")
        sys.exit(1)
    
    results_dir = sys.argv[1]
    output_file = sys.argv[2] if len(sys.argv) > 2 else None
    
    return generate_report(results_dir, output_file)

if __name__ == '__main__':
    sys.exit(main())

