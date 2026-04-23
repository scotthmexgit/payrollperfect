# ADR-0002: Development and CI pipeline

- Status: APPROVED
- Date: 2026-04-23
- Approved: 2026-04-23 (operator)
- Author: app (reviewer)
- Affects: ENH-0001
- Supersedes: none
- Superseded by: none
- Related: ADR-0001 (stack), ADR-0004 (production deploy — deferred)

## Context

ADR-0001 selected Astro + Tailwind + MDX. The project needs a
development loop and continuous integration before any production
deploy decision is made. Per operator direction 2026-04-23, the
current public host (`64.182.211.251`) is out of scope until cutover;
production deploy target is deferred to ADR-0004.

This ADR defines: where development happens, how code reaches
GitHub, and what CI verifies on every push.

## Decision

**Local development on segui. GitHub-hosted repository. GitHub
Actions CI that lints and builds but does NOT deploy.**

### Development environment

- **Host:** segui.
- **Workspace:** `/home/seadmin/payrollperfect/`.
- **Node version:** pinned to Node 22 LTS via `.nvmrc` containing
  the literal string `22`. Rationale: Astro 6 requires Node 22.12+;
  Node 20 reaches EOL in April 2026. Floating within v22 line
  avoids patch-level churn.
- **Package manager:** npm (ships with Node, no extra tooling).
- **Dev server:** `npm run dev` (Astro default on port 4321).
- **LAN preview:** existing nginx on segui serves
  `/var/www/payrollperfect/` for the current static site.
  Redesign dev server runs on a separate port (4321). A later
  ENH may route the LAN URL to the dev build; out of scope here.

### Repository

- **Remote:** `github.com/scotthmexgit/payrollperfect` (lowercase,
  per operator decision 2026-04-23).
- **Default branch:** `main`.
- **Branch model:** trunk-based for now. Feature branches are fine
  but PRs are not required until a second contributor joins.
- **Repository visibility:** operator decision at creation time.
  Private recommended initially (contains brand assets and
  pre-launch content); can flip public later.

### CI (GitHub Actions)

One workflow: `.github/workflows/ci.yml`. Triggers on push to any
branch and on PR to `main`. Steps:

1. Checkout.
2. Setup Node from `.nvmrc`.
3. `npm ci`.
4. `npm run lint` (if a lint script exists; skip otherwise — do
   not fail the build on missing script).
5. `npm run build` (Astro production build).
6. Upload `dist/` as a workflow artifact (retention 7 days).

No secrets required. No deploy step. No environment config.

### What this ADR explicitly does NOT decide

- Production deploy target (ADR-0004).
- DNS / domain cutover (ADR-0004).
- TLS on production host (ADR-0004).
- Form handling backend (ADR-0003).
- Preview/staging URL on segui (future ENH).
- Code formatting tool choice, linter config (defer to scaffold
  task; Prettier + ESLint with Astro plugin is the likely default).

## Alternatives considered

| Option | Reason declined |
|---|---|
| Develop locally on operator workstation instead of segui | segui already hosts the current site and has the filesystem context; dev on segui simplifies comparisons and LAN preview |
| GitLab / Gitea / Codeberg | Operator's prior project uses GitHub (`scotthmexgit/SUPERECON`); consistency wins |
| CircleCI / Travis / Jenkins | GitHub Actions is free for public repos, generous for private, and zero-config for a GitHub-hosted repo |
| Deploy directly from CI now | Operator explicitly deferred production until ready; deploying to the legacy host would be throwaway work |
| No CI at all | Lint + build on push catches breakage cheaply; cost to add is one YAML file |

## Consequences

- Every push to GitHub triggers a build. Broken builds are visible
  in the GitHub UI.
- Artifacts are downloadable from the Actions run page for 7 days
  — useful for manual QA or sharing a preview zip with a reviewer
  before production deploy exists.
- No deploy happens automatically. Production updates are entirely
  manual until ADR-0004 lands.
- Operator must create the GitHub repository before first push.
  Scaffold task will NOT create the repo — that requires operator
  credentials.
- Non-interactive non-login shells (e.g., cron, systemd) do NOT inherit
  nvm's Node 22 by default; explicit sourcing required for those cases.
  Interactive dev and GitHub Actions CI unaffected.

## Reversibility

**High.** Switching CI providers is a single YAML file swap.
Changing default branch or repo naming is a one-time rename.
Adding deploy steps later is additive.

## Approval and next step

On APPROVE:
1. App emits scaffold spec (separate paste).
2. CC scaffolds: Astro project, Tailwind, MDX, `.nvmrc`,
   `.gitignore`, `README.md`, `.github/workflows/ci.yml`.
3. Operator creates `github.com/scotthmexgit/payrollperfect`
   (private or public — operator's call).
4. Operator pushes initial commit. First CI run verifies the
   pipeline.

No scaffold begins until ADR-0002 is APPROVED.

## Links

- ADR-0001: stack decision
- ADR-0004: production deploy (deferred, not yet drafted)
- INV-0003: GitHub namespace discovery
