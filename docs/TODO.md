# LPSB TODO / Future Improvements

## Open Issues

### 1. Safe `\href` Hooking (lpsb-mcid.sty:3972)

**Priority**: Low
**Status**: Not Implemented

**Description**:
Currently, `\href` commands are not hooked for Link atom tagging. The hyperref URL primitives (`\hyper@linkurl`, `\hyper@link`) are hooked instead to avoid catcode issues with `#` in URLs.

**Reason for Deferral**:
- `\href{url}{text}` has complex argument parsing
- URL may contain special characters (`#`, `%`, `&`)
- Current hyperref primitive hooks cover most use cases

**Potential Implementation**:
```tex
% Hook \href to tag the visible text as Link atom
\let\lpsb@orig@href\href
\renewcommand{\href}[2]{%
  \lpsbTagAtom{Link}{\lpsb@orig@href{#1}{#2}}%
}
```

**Risk**: May break with URLs containing `#` or other special characters.

---

## Completed

See [KNOWN_ISSUES.md](./KNOWN_ISSUES.md) for all fixed issues.
