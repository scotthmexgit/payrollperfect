# ENHANCEMENTS

| ID | Title | Priority | Severity | Status | Owner | GH# | Opened | Closed | Notes |
|----|-------|----------|----------|--------|-------|-----|--------|--------|-------|
| ENH-0001 | Website redesign (umbrella) | TBD | TBD | PROPOSED | CC | — | 2026-04-23 | — | Scope pending INV-0001 |
| ENH-0002 | Retire `superecon` vhost for payrollperfect; use dedicated `payrollperfect` vhost on segui | Low | N/A | PROPOSED | — | — | 2026-04-23 | — | parent: ENH-0001. INV-0002 found LAN preview served via `superecon` vhost on segui; dedicated `payrollperfect` vhost exists but is not the active server block. Clean up during redesign cutover to avoid confusion. |
| ENH-0003 | Remove or relocate /var/www/payrollperfect/x/ desktop review report before launch | Low | N/A | TRIAGED | — | — | 2026-04-23 | — | parent: ENH-0001. Benign dev artifact from 2026-03-30. Action at production cutover (ADR-0004 milestone). |
