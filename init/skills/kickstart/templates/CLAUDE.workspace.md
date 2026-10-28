# CLAUDE.md

## Overview

<PROJECT> workspace: a folder that holds several git repositories for one product. This file only routes work; each repo has its own `CLAUDE.md` with the real conventions.

{{WORKING_AGREEMENT}}

## Project Map

| Alias | Folder | Stack | What it is |
|---|---|---|---|
| backend | `<project>-backend/` | <TS, Bun, Elysia, Postgres> | API, auth, jobs |
| admin | `<project>-admin/` | <Next.js, shadcn/ui> | Admin panel |
| mobile | `<project>-mobile/` | <Flutter> | iOS and Android app |
| website | `<project>-website/` | <Next.js> | Marketing site |
| docs | `<project>-docs/` | Markdown | Specs, schemas, decisions |

"The app" means mobile + backend + admin together. A behavior question usually spans the client and the backend: look at both.

## Routing

| The user mentions | Look in |
|---|---|
| API, endpoint, database, migration, auth | backend |
| panel, dashboard, CRUD, roles | admin |
| app, screen, widget, Cubit, device | mobile |
| landing page, SEO, marketing copy | website |
| spec, schema doc, decision | docs |

Always read the repo's own `CLAUDE.md` before editing it.

## Multi-repo rules

1. Every git command is scoped: `git -C <repo> ...`. Never run a blanket command over the whole tree.
2. Before "pull / commit / push everywhere", list in one line the repos and branches you will touch. Use the `multi-repo-git` skill.
3. Cross-repo change order: backend contract and migration first, then admin and mobile, then docs.
4. A field, enum or route used across repos is grepped in the defining repo before another repo uses it.
5. Branch model per repo: <develop = staging, main = production; note any repo where production is another branch>.
6. Secrets do not travel with a clone. Each repo has an `.env.example`; real values come from the deploy platform or a password manager.

## Development Commands

| Repo | Dev | Test | Lint |
|---|---|---|---|
| backend | `<pm> run dev` | `<pm> test` | `<pm> run lint` |
| admin | `<pm> run dev` | `<pm> test` | `<pm> run lint` |
| mobile | `flutter run` | `flutter test` | `flutter analyze` |
| website | `<pm> run dev` | `<pm> test` | `<pm> run lint` |

## New Machine

```bash
git clone <workspace-repo> <PROJECT> && cd <PROJECT>
./bootstrap.sh     # clones every repo listed in it; safe to re-run (pulls fast-forward)
```

## Claude Code Integration

Workspace-level skills: multi-repo-git, review-gate, coolify-deploy, backup-first. Repo-level agents, commands and skills live in each repo's `.claude/`.
