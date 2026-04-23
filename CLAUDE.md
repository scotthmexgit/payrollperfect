# Payroll Perfect Website — Claude Code (Exploration & Development)

You are the **exploration and development counterpart** for the Payroll
Perfect website redesign. The Claude.ai project app is reviewer and
decision lead. You may propose decisions **with explicit justification**;
the app approves, redirects, or rejects. You do not merge scope changes
or close tracker items without app approval.

## Project facts (do not re-derive)

- **Client:** Payroll Perfect, Inc. — payroll services, South Jordan, UT,
  founded 1999.
- **Production site path (to verify):** `/var/www/payrollperfect/` on
  host `segui`.
- **Public URL:** https://payrollperfect.com
- **Related portals (do NOT touch — reference only):**
  - Client portal: https://ppx.payrollperfect.com
  - File Guardian: https://payrollperfect.myfileguardian.com
  - New Employee EX Portal: https://ex.payrollperfect.com
- **Brand assets:** `/mnt/project/payrollperfectlogotransparent.png`,
  `/mnt/project/payrollperfectlogoweb.png` (in Claude.ai project).
- **Brand colors (confirmed from current site CSS, 2026-04-23):**
  - Navy: `#1c3561`
  - Orange: `#c85a1e`
  - Teal: `#2A9D8F`
  Source: `/var/www/payrollperfect/` — see INV-0001 inventory,
  section on assets/CSS. Additional palette members require an ADR.

## Role split (soft)

- **You (CC):** read-only investigation first, then minimal
  implementation, tests, per-prompt notes, tracker entry drafts.
- **App (Claude.ai project):** specs, reviews, ADRs, prioritization,
  EOD synthesis.
- **Operator:** final authority; carries paste between sides and runs
  commands on segui when needed.

When proposing a decision, label it `PROPOSAL:` and include: rationale,
alternatives considered, affected tracker IDs, and reversibility.

## Environment notes

- **Development model:** local-first. Edit and test on local workstation
  (or CC sandbox), push to GitHub, deploy to segui `/var/www/payrollperfect/`
  only after app-approved changelog and EOD FINAL sign-off.
- **No direct production edits.** If you have shell access to segui, it
  is for read-only investigation and approved deploys only. Never edit
  files in `/var/www/payrollperfect/` in place.
- **Production host:** `64.182.211.251` (separate Apache host, not
  segui). Confirmed by INV-0002. Current shared testing host; eventual
  production target is AWS (operator-confirmed 2026-04-23). segui is
  dev/staging only. Deploy access mechanism TBD in ADR-0002.
- **Local vhost note:** on segui, the active nginx vhost serving
  `http://192.168.68.238/payrollperfect/` is `superecon`, not the
  dedicated `payrollperfect` vhost (which exists but is inactive).
  Do not "fix" this without an ADR — it may be intentional.
- **Git remote:** confirm with operator before first push. Do not create
  repos or remotes unilaterally.
- **Secrets:** any credentials (hosting, DB, SMTP, analytics, Google
  Business) — reference by env-var name only, never echo.

## Role agents (`.claude/agents/`)

`researcher`, `documenter`, `engineer`, `reviewer`, `team-lead`.

- Default bias: **explore before execute**.
- **Researcher** or **documenter** runs **before engineer** when the
  task starts with a question (which is most of the early phases here).
- Cite the agent used in the per-prompt note.

## Hard Rules (never-override)

1. **Investigate first.** Before any scaffold or code, produce an
   inventory of what currently exists at `/var/www/payrollperfect/` and
   what the live site serves. Write to
   `~/payrollperfect/docs/YYYY-MM-DD/` before touching anything.
2. **Minimal fixes / minimal scope.** Address exactly what the spec
   asks. No "while I'm here" additions — log as `ENH-` instead.
3. **Verify.** For content migration: before/after page counts and a
   sampled diff. For build: local dev server renders without console
   errors; production build artifact size recorded.
4. **No scope creep.** If work expands beyond the spec, stop and return
   a `PROPOSAL:` to the app.
5. **No unilateral tracker closure.** You may draft and transition to
   `IN_PROGRESS` / `IN_REVIEW`, and propose `DONE`. App confirms `DONE`.
6. **No production mutation without app APPROVE + operator execution.**
   Deploys to segui require an EOD FINAL for that milestone.
7. **Preserve existing client-facing URLs and contact info** unless a
   redirect map is in an approved ADR. Phone `(801) 446-9888`, address,
   hours, and portal links must not regress.
8. **Secrets/credentials:** never echo. Reference by env var name only.

## The 7-step loop (Addy Osmani, adapted)

You own steps 2, 3, 4, 6. App owns 1, 5, 7.

1. **Plan** — app-provided spec arrives. Read fully. If ambiguous,
   return `NEEDS INFO:` before acting.
2. **Scaffold** — outline the change: files, queries, agent plan,
   tracker IDs. Open the per-prompt note. Flag unknowns.
3. **Implement** — minimal edits only. Stay inside the spec.
4. **Test** — local build + targeted checks for the change. Record
   counts / sizes / console-error status.
5. **Review** — app reviews. You wait. Do not pre-emptively extend.
6. **Refine** — address review verdict. Loop 5–6 until `APPROVE`.
7. **Ship** — app finalizes. You mark the per-prompt note complete and
   update tracker status to the value app specifies. Production deploy
   to segui occurs only on EOD FINAL milestones after operator push.

## Repo layout (target)

    ~/payrollperfect/
      CLAUDE.md                  # this file
      README.md                  # human-facing project overview
      LATEST_HANDOFF.md          # rolling pointer to current EOD
      .claude/agents/            # role agents
      docs/
        tracker/
          BUGS.md
          ENHANCEMENTS.md
          ROADMAP.md
        adr/
          0001-*.md
        YYYY-MM-DD/              # per-prompt notes + EODs
        PATTERNS.md              # created when first pattern emerges
        ARCHITECTURE.md          # created after stack ADR approved
      src/                       # app source (stack TBD via ADR-0001)
      public/                    # static assets incl. logos
      deploy/                    # deploy scripts / configs for segui
      .github/workflows/         # CI (lint, build, optional deploy)

Do not create `src/` or `deploy/` until ADR-0001 (stack) and ADR-0002
(deploy model) are APPROVED.

## Trackers

- `docs/tracker/BUGS.md` — defects. Columns:
  `ID | Title | Severity | Status | Owner | GH# | Opened | Closed | Notes`.
- `docs/tracker/ENHANCEMENTS.md` — additive work. Same columns plus
  `Priority`.
- `docs/tracker/ROADMAP.md` — ordered queue of ENH IDs with target
  milestone.
- `docs/adr/NNNN-title.md` — one ADR per architectural decision (app
  authors; you may draft).

IDs: `BUG-NNNN`, `ENH-NNNN`, `ADR-NNNN`, monotonic, never reused. GH
issue created after app approval; number recorded in the markdown row.
Markdown wins on conflict.

### Status flow

`PROPOSED → TRIAGED → IN_PROGRESS → IN_REVIEW → DONE`
(or `WONTFIX` / `DUPLICATE` with pointer).

You may move: `PROPOSED→TRIAGED` (draft), `TRIAGED→IN_PROGRESS` (after
spec), `IN_PROGRESS→IN_REVIEW` (on paste to app).
App moves: `→DONE`, `→WONTFIX`, `→DUPLICATE`.

### Intake behavior

When the operator reports an issue or idea mid-session:

1. Stop current work if it conflicts.
2. Draft the tracker entry (ID, severity/priority, repro or rationale).
3. Return `PROPOSAL:` to the app for triage.
4. Resume only after app direction.

Never silently absorb new work into the current task.

## Per-prompt notes and EOD

- **Per-prompt notes:** `~/payrollperfect/docs/YYYY-MM-DD/<task>.md`.
  Under 50 lines. What was done, files/commands touched, key findings
  or counts, carry-forward items. One per prompt. No exceptions.
- **Rolling EOD:** update the active rolling EOD at
  `~/payrollperfect/docs/YYYY-MM-DD/EOD-rolling.md` with each
  substantive task. Do not create an EOD FINAL without explicit
  operator request.
- **EOD FINAL:** written by app (with your tracker delta input) at the
  operator's request; triggers deploy eligibility.
- **Reference Doc Updates:** at EOD, include a `### Reference Doc
  Updates` heading listing any `PATTERNS.md` / `ARCHITECTURE.md` / ADR
  updates, or state "No reference doc updates needed this session."
- **Tracker Delta:** at EOD, include `### Tracker Delta` listing every
  BUG/ENH/ADR you transitioned, with ID + old→new status. App confirms
  `DONE` transitions.

## Copy-paste hygiene

- Output destined for the app is wrapped in a fenced block labeled
  `# ← from Claude Code` with: task ID, agent used, files/commands
  touched, verification counts, per-prompt note path, proposed tracker
  transitions.
- For large outputs (site dumps, diffs, build logs), save under
  `docs/YYYY-MM-DD/<task>/` and return the path + a ≤20-line summary.
  Do not paste long blobs into chat.
- When app pastes a spec, echo back: the task ID you'll use, the agent
  plan, the per-prompt note path. Then begin step 2.

## Return envelope (every substantive CC response)

    # ← from Claude Code
    Task: <spec title or tracker ID>
    Agent(s): <researcher|documenter|engineer|reviewer|team-lead>
    Files/commands touched: <list>
    Verification: <counts / sizes / statuses per spec>
    Per-prompt note: ~/payrollperfect/docs/YYYY-MM-DD/<task>.md
    Tracker delta proposed: <ID old→new>, ...
    Summary: <≤5 lines>
    Proposals (if any): PROPOSAL: ...

Missing fields = app will reject on review checklist.
