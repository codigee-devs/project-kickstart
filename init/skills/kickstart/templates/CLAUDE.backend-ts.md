# CLAUDE.md

## Overview

<PROJECT> backend: a TypeScript API that serves <mobile app / admin panel / web>. <One sentence on the domain.>

{{WORKING_AGREEMENT}}

## Tech Stack

| Category | Technology | Version |
|---|---|---|
| Runtime | <Bun / Node> | <version> |
| Framework | <Elysia / Express / Fastify / Hono> | <version> |
| Database | PostgreSQL | <version> |
| ORM / query | <Drizzle / Knex / Prisma> | <version> |
| Validation | <Typebox / zod> | |
| Auth | <better-auth / JWT / sessions> | |
| Tests | <bun:test / jest / vitest> | |
| Lint / format | <Biome / ESLint + Prettier> | |

## Development Commands

```bash
<pm> install
<pm> run dev
<pm> test
<pm> run lint
<pm> run typecheck            # or: bunx tsc --noEmit
<pm> run db:generate          # create a migration from the schema
<pm> run db:migrate           # apply migrations (local only without confirmation)
```

Use only the package manager the lockfile names.

## Directory Structure

```
src/
  modules/
    <module>/
      <module>.schema.ts     # request/response schemas
      <module>.service.ts    # business logic, DB access, typed errors
      index.ts               # routes: auth guard + schema + call service
  utils/
    db/                      # client + schema
    errors.ts                # error factory and HTTP mapping
    logger.ts
  index.ts                   # app wiring
drizzle/ | migrations/       # generated migrations, reviewed before applying
test/
```

## Architecture Pattern

Module per domain. Route -> service -> DB. Routes validate and authorize, services decide and persist, nothing else touches the DB.

## Module Structure

Scaffold with the `backend-module` skill: schema, service, routes, tests.

## Naming Conventions

- Module folders `kebab-case`, files `<module>.service.ts`, classes `PascalCase`, constants `SCREAMING_SNAKE`.
- Routes `kebab-case` plural nouns: `/household-members/:id`.
- DB tables and columns: <snake_case in SQL / camelCase in the ORM>.

## Error Handling

Services throw typed errors from one factory (`buildError("NOT_FOUND", "...")`). One global handler maps them to HTTP status and a stable error code. Routes never catch. Clients get a code and a generic message; logs get the details. See the `backend-errors` skill.

## Anti-patterns

1. A route without an auth guard that is not listed as public.
2. User id taken from the body, query or path instead of the session.
3. Raw SQL built from strings.
4. Removing or renaming a response field, enum value or route that a shipped client uses.
5. Dropping or renaming a column in the same deploy that stops using it.
6. Resetting, seeding or force-pushing a database without a backup and a yes.
7. `console.log`. Use the logger.
8. N+1 queries in list endpoints.

## Best Practices

1. Additive API changes only. See the `api-contract` skill.
2. Review generated migration SQL before applying. See the `db-migrations` skill.
3. Index every new filter or sort column on a large table.
4. Tests go through the HTTP layer so auth and validation run.

## Decisions and contracts

Record each contract decision as a dated entry (template in the Working Agreement).

## New Feature Checklist

1. Write the contract first: request, response, errors, who may call it.
2. Schema + migration (expand only), reviewed.
3. Service with typed errors, route with guard and validation.
4. Tests: success, validation error, forbidden, not found.
5. Lint, types, tests. Note consumers and deploy order in the PR.

## Claude Code Integration

| Type | Name | Use |
|---|---|---|
| Agents | architecture-review, code-review, security-review, testing-review | `/review` |
| Commands | /commit, /pr, /review, /quality-check | |
| Skills | backend-module, api-contract, db-migrations, backend-errors | backend pack |
