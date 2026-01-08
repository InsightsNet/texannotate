# `arxiv_stubs/`

This directory contains **template / class / style files** that some arXiv submissions rely on but do not ship in their source archives.
LPSB can copy these files into a paper’s build directory **only when the paper source tree does not already provide them**, to unblock compilation for structure extraction.

## Licensing / copyright notice

- **We do not claim copyright** over the upstream files placed in this directory.
- Copyright and licensing remain with the respective rights holders (publishers, organizations, and/or original authors).
- Many files include their own copyright / license headers. Those headers are the authoritative source for reuse terms.

It is common that certain publisher templates are **not included** in some TeX Live images and are also **not shipped** inside arXiv source archives. The exact reasons can vary (packaging, redistribution policies, licensing, etc.). This repository does **not** make any legal claims about why a file is or is not present in TeX Live.

## Removal policy

If any rights holder believes a file in this directory should not be distributed as part of this repository, please contact the maintainers.
We will promptly review the request and **remove the file(s)** if needed.

## How LPSB uses these files

- LPSB copies a stub/template file into the build directory **only if** the paper does not already provide the same filename.
- Author-provided files take precedence; LPSB does **not** overwrite them.
- Some files may be used as **filename aliases** (e.g., copying `aastex631.cls` as `aastex63.cls`) to match legacy expectations.

## What should be placed here

Prefer adding **official upstream distributions** (from the publisher or project homepage, or CTAN where appropriate).
Avoid hand-written replacements unless you fully control the licensing and semantics.


