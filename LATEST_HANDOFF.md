# LATEST HANDOFF

Most recent EOD: `docs/sessions/2026-04-23/EOD-FINAL.md`

## At a glance

- **Stack:** Astro 6 + Tailwind 4 + MDX 5, Node 22.12+
- **Repo:** github.com/scotthmexgit/payrollperfect (SSH auth)
- **Dev preview:** http://192.168.68.238/payrollperfect/ (segui LAN)
- **Production:** https://payrollperfect.com (legacy AWS, untouched)
- **Deploy to LAN:** `./deploy/segui-deploy.sh`

## Next session starting points

1. Open LAN preview and react to home page design.
2. Iterate design or start next page (Services / About / Contact).
3. Resolve `run.sh` carry-forward (unknown origin — delete or .gitignore).
4. Draft ADR-0004 (app-side) documenting proven LAN deploy model.
5. Provide second CI run fields to close CI-VERIFY-0001 authoritative baseline.

## To start the next session

```bash
cd ~/payrollperfect
cat LATEST_HANDOFF.md
cat docs/sessions/2026-04-23/EOD-FINAL.md
git status
git log --oneline -5
```
