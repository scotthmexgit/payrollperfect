# BUGS

| ID | Title | Severity | Status | Owner | GH# | Opened | Closed | Notes |
|----|-------|----------|--------|-------|-----|--------|--------|-------|
| BUG-0001 | Contact form Formspree ID is literal placeholder | High | TRIAGED | — | — | 2026-04-23 | — | parent: ENH-0001. Form endpoint value is "REPLACE_WITH_FORMSPREE_ID"; submissions fail silently. PARKED pending redesign scope — do not fix in current static site without operator direction. |
| BUG-0002 | Production TLS uses DH key below modern security level | Medium | TRIAGED | — | — | 2026-04-23 | — | parent: ENH-0001. Discovered during INV-0002: curl from segui rejects handshake ("DH key too small"). Browsers still connect; CI health checks will fail by default. Host: 64.182.211.251 (not admin-controlled by operator on segui). PARKED — redesign deploy to modern host expected to resolve; do not mitigate on current production. |
