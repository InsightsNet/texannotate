This project assumes that the AutoTeX library has been installed to the location where Perl can find it.

To compile a TeX project, run the following command:

```bash
python compile.py \
  --sources sources.tgz
  --texlive-path /path/to/texlive/installation
  --path /path/to/latex/binaries:/usr/bin:/bin:/sbin:/usr/sbin  
  --perl /usr/local/bin/perl
```

Which will return the following result:

```json
{
    "success": true,
    "main_tex_files": ["main.tex", ...],
    "output": [
        {
            "type": "pdf",
            "path": "main.pdf",
            "contents": "<Base64 representation of contents>"
        }
    ],
    "autotex_logs": "..."
}