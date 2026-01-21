#!/usr/bin/env python3
"""
Repo entrypoint.

All script CLIs under ./script/ are invoked through this dispatcher.
Individual scripts no longer have standalone `__main__` entrypoints.
"""

from __future__ import annotations

import argparse
import importlib
import sys
from pathlib import Path
from typing import Callable, Dict, List, Tuple


def _bootstrap_sys_path() -> Path:
    repo_root = Path(__file__).resolve().parent
    # Keep these at the front to avoid accidentally importing third-party modules
    # with the same names as our local files.
    add = [
        repo_root,
        repo_root / "script",
        repo_root / "script" / "parsing",
        repo_root / "script" / "postprocess",
        repo_root / "script" / "visualization",
        repo_root / "script" / "utils",
    ]
    for p in reversed(add):
        sp = str(p)
        if sp not in sys.path:
            sys.path.insert(0, sp)
    return repo_root


def _run_module_main(module_name: str, argv: List[str]) -> int:
    mod = importlib.import_module(module_name)
    fn = getattr(mod, "main", None)
    if not callable(fn):
        raise SystemExit(f"[main] module has no callable main(): {module_name}")

    old_argv = sys.argv[:]
    sys.argv = [module_name] + list(argv)
    try:
        rc = fn()
        if rc is None:
            return 0
        if isinstance(rc, int):
            return rc
        return 0
    except SystemExit as e:
        # Respect sub-command argparse behavior.
        code = e.code
        if code is None:
            return 0
        if isinstance(code, int):
            return code
        return 1
    finally:
        sys.argv = old_argv


def main() -> int:
    _bootstrap_sys_path()

    commands: Dict[str, Tuple[str, str]] = {
        # Top-level
        "compile": ("script.lpsb_compiler", "main"),
        "verify-failures": ("script.verify_failures", "main"),
        # parsing/
        "parse-mcid": ("script.parsing.parse_lpsb_mcid", "main"),
        "build-doc-tree": ("script.parsing.build_doc_tree", "main"),
        # postprocess/
        "fix-split-headings": ("script.postprocess.fix_split_headings", "main"),
        "merge-split-paragraphs": ("script.postprocess.merge_split_paragraphs", "main"),
        "fix-crosspage-mcid": ("script.postprocess.fix_crosspage_mcid", "main"),
        "compute-order-map": ("script.postprocess.compute_order_map", "main"),
        "inject-structtree": ("script.postprocess.inject_structtree", "main"),
        # visualization/
        "visualize-mcid": ("script.visualization.visualize_mcid", "main"),
        "visualize-annotations": ("script.visualization.visualize_annotations", "main"),
    }

    ap = argparse.ArgumentParser(description="LPSB unified entrypoint")
    sp = ap.add_subparsers(dest="cmd", required=True)

    for name in sorted(commands.keys()):
        sp.add_parser(
            name,
            help=f"Run {commands[name][0]}.main()",
            add_help=False,  # pass -h/--help to underlying script
        )

    args, rest = ap.parse_known_args()
    modname, _fn = commands[str(args.cmd)]
    return _run_module_main(modname, list(rest))


if __name__ == "__main__":
    raise SystemExit(main())

