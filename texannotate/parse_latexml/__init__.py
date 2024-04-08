from texannotate.parse_latexml.latexml_parser import parse_latexml
from texannotate.parse_latexml.markdown import format_document

def standardize_tex2md(html_text):
    try:
        doc = parse_latexml(html_text)
    except ValueError as e:
        print(e)
        return
    if doc is None:
        return
    out, fig = format_document(doc, keep_refs=True)
    return out