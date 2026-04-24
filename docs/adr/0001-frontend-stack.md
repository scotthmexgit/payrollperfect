# ADR-0001: Frontend stack for Payroll Perfect website redesign

- Status: APPROVED
- Date: 2026-04-23
- Approved: 2026-04-23 (operator)
- Author: app (reviewer)
- Affects: ENH-0001

## Context

Payroll Perfect's current site is a 147KB single-file static HTML page
served from `/var/www/payrollperfect/` on segui (dev) and from an AWS
host publicly. The redesign's north-star is **lead capture**: convert
visitors to contact-form submissions or phone calls. Secondary goals:
prominent routing to three external portals (`ppx`, `myfileguardian`,
`ex`), preserve contact info (phone/address/hours), and deploy via
GitHub to AWS.

"Nothing is sacred" re: existing copy/design. No CMS need has been
stated. No authenticated features live on this site — all auth lives
in the external portals.

## Decision

**Adopt Astro as the site framework.** Tailwind CSS for styling.
MDX for long-form copy pages. Static output to `dist/`, deployed as
static files.

## Alternatives considered

| Option | Fit | Reason declined |
|---|---|---|
| **Astro** | Strong | Chosen (see below) |
| Plain HTML + Tailwind, no build | Viable | Component reuse breaks down past ~5 pages; no markdown authoring ergonomics |
| Eleventy | Viable | Solid static generator; Astro wins on DX and built-in component model |
| Hugo | Viable | Fast, but Go templates are a regression from component-based authoring |
| Next.js | Poor fit | Built for dynamic + SSR; overkill for static lead-capture |
| SvelteKit | Poor fit | Same as Next.js |
| WordPress | Rejected | Adds CMS surface, security patching, DB — no stated need |
| Wix / Squarespace | Rejected | Incompatible with "GitHub + AWS deploy" stated goal |

## Why Astro specifically

1. **Static by default.** Produces plain HTML/CSS/JS. Matches current
   147KB baseline ethos.
2. **Islands for interactivity.** The contact form may need client-side
   validation or a submission widget; Astro adds interactivity
   per-component without shipping a SPA.
3. **Markdown/MDX first-class.** Lead-capture copy pages (services,
   about, pricing FAQ) are easier to maintain as markdown than JSX.
4. **Framework-agnostic components.** If future work wants a React or
   Vue widget, Astro accepts both without changing the site.
5. **Deploy flexibility.** `dist/` is static HTML — works on any of:
   existing EC2/Apache (rsync), S3+CloudFront (sync), Lightsail, or
   any static host. Decouples stack from deploy decision (ADR-0002).
6. **Fast build times, small output.** Important if we ever add a CI
   budget check.

## Form handling

Deferred to **ADR-0003 (form handling)**. Candidates: Formspree (fix
BUG-0001), Basin, Web3Forms, or tiny AWS Lambda. Decoupled from stack.

## Consequences

- Node.js toolchain required for dev (Astro CLI).
- Content authored in `src/content/` as markdown or MDX.
- Components in `src/components/` (`.astro` files).
- Pages as file-based routing in `src/pages/`.
- Build output: `dist/` — the deploy artifact.
- Designers/copywriters need markdown comfort. Given single-operator
  workflow, acceptable.
- Locks us into Node ecosystem for build-time tooling. Reversible but
  costly after significant content accumulates.

## Reversibility

**Medium.** Switching to Eleventy or plain HTML after 3 months of
content is a 1–2 day port (markdown transfers; component rewrites).
Switching to WordPress or a dynamic framework is significantly more
work — don't do that without a new ADR.

## Open questions (not blocking this ADR)

- Exact Astro version: pin to latest stable at scaffold time.
- Tailwind version: same.
- Whether to ship a sitemap plugin, RSS (probably not — marketing site),
  or an analytics integration out of the gate. Defer to ENH children.

## Links

- INV-0001: /home/seadmin/payrollperfect/docs/sessions/2026-04-23/INV-0001-site-inventory.md
- ENH-0001: umbrella
- ADR-0002: deploy model (pending)
- ADR-0003: form handling (pending)
