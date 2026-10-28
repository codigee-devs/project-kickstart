# CLAUDE.md

## Overview

<PROJECT> is a Next.js <marketing site / admin panel / web app> for <who>. <Where content and data come from.>

{{WORKING_AGREEMENT}}

> Next.js changes between majors. Before writing framework code, check the version in `package.json` and the docs shipped in `node_modules/next/dist/docs/` if present. Heed deprecation notices.

## Tech Stack

| Category | Technology | Version |
|---|---|---|
| Framework | Next.js (App Router) | <version> |
| UI | React | <version> |
| Styling | Tailwind CSS <+ shadcn/ui> | <version> |
| Data | <React Query / server components / CMS / JSON content> | |
| Forms | <react-hook-form + zod> | |
| State | <Zustand / none> | |
| i18n | <next-intl / none> | |
| Tests | <vitest / jest / bun test>, Playwright for e2e | |
| Package manager | <bun / pnpm / npm> | |

## Development Commands

```bash
<pm> install
<pm> run dev
<pm> run lint
<pm> run test
<pm> run build        # often the only full type check: run it before every commit
<pm> run test:e2e     # needs a running build
```

## Directory Structure

```
src/
  app/                 # routes only: thin page.tsx, layout.tsx, metadata
  views/<Name>View/    # page-level server components
    parts/             # sections of that view, barrel index.ts
  components/          # shared UI, reused across views
  services/            # data access, SEO helpers, business logic
  messages/            # translations, one file per locale and namespace (if i18n)
```

## Architecture Pattern

`page.tsx` fetches and renders a View. Views compose parts. Parts reuse components. Data and logic live in `services/`. Server components by default; `"use client"` only on interactive leaves.

## Module Structure

New page or section: the `site-page` skill (website pack) or the `admin-crud` skill (admin-panel pack).

## Naming Conventions

- Components and views `PascalCase.tsx`, hooks `useThing`, services and utils `kebab-case.ts` or the project's existing style.
- Route segments `kebab-case`. Never a dot in a slug.

## Error Handling

Server: services return typed results or throw typed errors; `notFound()` for missing content; `error.tsx` per segment where data can fail. Client: one `getErrorMessage()` helper plus toast; never show raw errors.

## Anti-patterns

1. A new component when one in `components/` already fits.
2. Logic or fetching inside presentational components.
3. Hardcoded colors, fonts or spacing outside the Tailwind theme.
4. A page without `metadata` / `generateMetadata` and a canonical URL.
5. Images without dimensions or `alt`.
6. Animation without a `prefers-reduced-motion` path.
7. Importing content JSON straight into components instead of through a service.

## Best Practices

1. Reuse first (search `components/` and `views/*/parts/`).
2. Every page: title, description, canonical, OG image, one h1.
3. Check the rendered page at 375 px and 1440 px before saying it is done.

## New Feature Checklist

1. Find components to reuse. Ask before creating a shared one.
2. Page -> View -> parts -> services.
3. Metadata, sitemap entry, internal links.
4. Lint, test, build. Open the page in a browser and report what you saw.

## Claude Code Integration

| Type | Name | Use |
|---|---|---|
| Agents | architecture-review, code-review, security-review, testing-review | `/review` |
| Commands | /commit, /pr, /review, /quality-check | |
| Skills | site-page, site-seo, site-i18n, site-quality / admin-crud, admin-roles, admin-tables-forms | website, admin-panel packs |
