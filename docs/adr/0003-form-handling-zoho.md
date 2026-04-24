# ADR-0003: Form handling via Zoho Forms

- Status: APPROVED
- Date: 2026-04-23
- Approved: 2026-04-23 (operator)
- Author: app (reviewer)
- Affects: ENH-0001, BUG-0001
- Related: ADR-0001 (stack), ADR-0002 (dev+CI)

## Context

The redesign's primary goal is lead capture. Forms are the core
conversion mechanism. Operator has a Zoho One subscription and will
build forms in Zoho Forms, then integrate into the site.

Current state: the legacy site has a placeholder Formspree integration
(`REPLACE_WITH_FORMSPREE_ID`) which does not work (BUG-0001). This ADR
supersedes the Formspree direction.

## Decision

**Use Zoho Forms as the form provider. Embed via two patterns:
JavaScript snippet for inline page forms, Lightbox for modal CTAs.**

During initial development, use visual placeholders that match the
intended size and shape. Real Zoho Forms embed codes replace
placeholders in a follow-up task once forms exist in Zoho.

## Alternatives considered

| Option | Reason declined |
|---|---|
| **Zoho Forms** | Chosen — operator subscription in place, tight integration with Zoho One ecosystem where leads will ultimately flow |
| Formspree | Operator declined in favor of Zoho (which they already pay for); would still require fixing BUG-0001 |
| Basin / Web3Forms | Third-party dependency when operator already has Zoho |
| Netlify Forms | Incompatible with AWS deploy target |
| Serverless (AWS Lambda) | Over-engineered for a marketing site; Zoho handles spam, validation, notifications out of the box |

## Embed patterns

### Pattern 1 — Inline embed (JavaScript snippet)

Used for dedicated form pages (Contact page). Zoho's JavaScript
snippet creates an iframe that auto-resizes via postMessage, so the
form grows/shrinks with content without scrollbars.

Implementation:
- Astro component `src/components/forms/ZohoFormEmbed.astro` accepts
  `formUrl` as prop.
- Wrapper div styled to match page padding / max-width.
- Placeholder mode: when `formUrl` is not provided or is the literal
  string `"PLACEHOLDER"`, component renders a visually styled box with
  the correct dimensions and fake field rows to show layout intent.

### Pattern 2 — Lightbox (modal CTA)

Used for primary CTA buttons on home page and elsewhere ("Get a
quote", "Contact us"). Button opens a modal containing the Zoho form.

Implementation:
- Astro component `src/components/forms/ZohoFormLightbox.astro` accepts
  `formUrl` prop and renders the trigger button + modal shell.
- Uses a lightweight native `<dialog>` element (no JS modal library
  needed).
- Placeholder mode: trigger button opens a modal containing the same
  placeholder styling as Pattern 1.

### Placeholder visual spec

Placeholders must communicate:
- The approximate height of the form (so page layout doesn't shift
  when real form loads).
- The field count and types (text input, textarea, select, submit
  button) so the layout ships close to final.
- A clear "FORM PLACEHOLDER" label + comment-style note naming which
  Zoho form will replace it.

## Form roster (expected initial set)

Operator will build these forms in Zoho. Names/fields approximate
until operator confirms:

1. **Contact** — name, email, phone, company, message. Primary
   conversion form. Inline on /contact.
2. **Quote request** — name, email, phone, company, employee count,
   services needed (checkboxes), preferred contact method. Lightbox
   from home hero + CTA buttons.

Both forms should route to the operator's Zoho CRM or a Zoho-hosted
inbox; routing is operator-configurable in Zoho Forms.

## Consequences

- Two small Astro components added under `src/components/forms/`.
- Placeholders ship in the initial site; functional forms ship as a
  follow-up ENH after operator builds them in Zoho.
- Site loads Zoho's iframe-hosting domain at runtime — one additional
  third-party request. No CORS concerns (iframe handles its own
  origin).
- BUG-0001 (Formspree placeholder) will close as WONTFIX with pointer
  to this ADR when the Zoho forms go live — the legacy Formspree field
  is discarded entirely, not fixed.

## Reversibility

**High.** Form component swap is contained; replacing Zoho with any
other provider is a one-component rewrite. Placeholders make the
transition path explicit.

## Open questions (not blocking)

- Exact Zoho form URLs (after operator builds them).
- Whether to use Zoho's themed form designer to match site colors, or
  embed with default Zoho styling. Defer to visual-QA pass after
  forms exist.
- Analytics on form submissions (Zoho provides its own; site-level
  analytics is a separate ADR if/when added).

## Links

- ADR-0001: stack decision
- BUG-0001: Formspree placeholder (will WONTFIX when this ADR ships)
- ENH-0004: Home page (this ADR's first consumer)
