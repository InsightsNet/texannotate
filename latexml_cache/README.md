# LaTeXML Cache Directory

This directory stores cached LaTeXML state (precompiled formats, expl3 kernel data) to speed up subsequent runs.

## Structure

```
latexml_cache/
├── TL2020/           # TeX Live 2020 specific cache
│   ├── home/         # HOME directory for LaTeXML processes
│   └── xdg-cache/    # XDG_CACHE_HOME for LaTeXML
├── TL2023/           # TeX Live 2023 specific cache
├── TL2025/           # TeX Live 2025 specific cache
└── README.md
```

## How It Works

When `lpsb_compiler.py` runs LaTeXML (Stage B), it mounts this cache directory to:
- `/lpsb_latexml_cache/home` as `$HOME`
- `/lpsb_latexml_cache/xdg-cache` as `$XDG_CACHE_HOME`

This allows LaTeXML to persist parsed package definitions across runs, significantly speeding up packages that use `expl3` (like `siunitx`, `tcolorbox`).

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `LPSB_LATEXML_CACHE` | `1` | Set to `0` to disable caching |
| `LPSB_LATEXML_CACHE_BASE` | `latexml_cache/` | Override cache base directory |

## Performance Impact

Without caching, `expl3` packages can take 20+ minutes to process on first run.
With caching (and `make formats` in Docker build), subsequent runs complete in ~3 seconds.

## Reference

- [LaTeXML issue #2064](https://github.com/brucemiller/LaTeXML/issues/2064) - expl3 performance fix