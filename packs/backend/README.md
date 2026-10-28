# backend

TypeScript APIs that serve mobile apps and admin panels. Templates default to Bun + Elysia + Drizzle + PostgreSQL, with notes for Express, Fastify, Knex and Prisma.

| Skill | Use it when |
|---|---|
| `backend-module` | You add an endpoint group or a new domain. Contract first, then schema, service, guarded routes, table and tests. |
| `api-contract` | You change anything a client reads or sends, and before every production push. Additive vs breaking, consumer grep, expand then contract, dated contract notes. |
| `db-migrations` | You add or change tables, or someone asks to reset or seed. Read the SQL, stay compatible with running code, index new queries, backup before anything destructive. |
| `backend-errors` | You set up or fix error handling. One factory, one handler, stable codes, safe messages, useful logs. |

## The two rules behind this pack

1. **Clients in the field do not update with you.** A response field that disappears breaks every store build that reads it. So changes are additive, and breaking ones go through expand, migrate, contract.
2. **Data loss is the one mistake you cannot undo.** Resets, seeds, drops and history rewrites need a backup and a yes, every time, also on "just the local database".

## Where it comes from

Backends behind our mobile products: a household planner API with an admin panel, an MCP endpoint and a calendar worker; a museum guide API with queues and GPU jobs; a realtime game server. The dated "Decisions and contracts" entries in their `CLAUDE.md` files are where most of these rules were written down first.
