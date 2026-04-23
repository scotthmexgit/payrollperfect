# Payroll Perfect — Website

Marketing site for Payroll Perfect, Inc.
Built with Astro, Tailwind CSS, and MDX.

## Development

    nvm use       # reads .nvmrc (Node 22)
    npm install
    npm run dev   # http://localhost:4321

## Build

    npm run build      # outputs to dist/
    npm run preview    # serves dist/ locally

## Project structure

See `docs/adr/` for architectural decisions.
See `CLAUDE.md` for the AI-assisted development workflow.

## Deploy

Production deploy is deferred per ADR-0004 (pending).
CI runs on every push (lint + build). Artifacts retained 7 days.
