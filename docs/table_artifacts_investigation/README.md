# Table Artifacts Investigation

This directory contains technical reports related to the investigation and resolution of table rendering artifacts in LPSB.

## Contents

- **[INVESTIGATION_REPORT.md](INVESTIGATION_REPORT.md)**  
  A comprehensive post-mortem detailing the root cause analysis, A/B testing methodology, and the final technical solution for the "extra vertical lines" artifact issue.

- **[STATUS_REPORT.md](STATUS_REPORT.md)**  
  A summary of the current capabilities, supported environments (tabular, longtable, etc.), and known limitations of the table extraction module.

## Context

In early 2026, we identified that the initial `\AddToHook` implementation for table tracking was causing visual corruption in generated PDFs. This investigation led to the adoption of the Direct Command Patching strategy currently in use.
