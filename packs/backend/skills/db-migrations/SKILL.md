---
name: db-migrations
description: Change a database schema safely - generate the migration from the schema, read the SQL before applying, keep it compatible with the code that is running, add indexes for new queries, and never reset, seed, drop or force-push a database without a backup and an explicit yes. Covers Drizzle, Knex and Prisma on PostgreSQL. Triggers - "add a column", "create a table", "migration", "db:push", "reset the database", "seed the db", "dodaj kolumne", "nowa tabela", "migracja", "zresetuj baze", "zaseeduj baze".
---

# db-migrations

A migration runs against live data while the old code is still serving requests. Treat it as a deploy, not as a file.

## Hard rule

Never run any of these without a fresh backup and an explicit yes from the user, on any database that holds data someone cares about (local included, if it holds real test accounts):

`db:reset`, `db:seed` on a non-empty database, `drizzle-kit push --force`, `prisma migrate reset`, `knex migrate:rollback --all`, `DROP`, `TRUNCATE`, `DELETE` without `WHERE`, re-running all migrations from zero.

Backup first (see the `backup-first` skill):

```bash
pg_dump --format=custom --no-owner --file "backups/<db>-$(date +%Y%m%d-%H%M%S).dump" "$DATABASE_URL"
```

## Workflow

1. **Change the schema file**, not the database. Match the existing table pattern: `id` uuid default random, `createdAt`/`updatedAt`, `onDelete` on every foreign key, explicit lengths, sorted keys if the project sorts them.
2. **Generate:** `bun run db:generate` / `pnpm drizzle-kit generate` / `npx knex migrate:make <name>` / `npx prisma migrate dev --create-only`.
3. **Read the generated SQL.** Look for `DROP`, `ALTER ... TYPE`, `SET NOT NULL` on an existing column, renames that the tool turned into drop + add, and missing `IF NOT EXISTS`.
4. **Apply locally**, run the tests, then hand off. Staging and production migrations run through the deploy, not from your machine.
5. Never edit a migration that has already run anywhere. Write a new one.

## Compatible with running code: expand, migrate, contract

| Goal | Safe sequence |
|---|---|
| Add a column | Add as nullable or with a default. Backfill in batches. Add `NOT NULL` in a later migration |
| Rename a column | Add new, write both, backfill, read new, stop writing old, drop old in a later release |
| Change a type | New column with the new type, backfill, switch reads, drop the old one later |
| Drop a column | Stop reading and writing it in one release, drop it in the next |
| Add an enum value (Postgres) | `ALTER TYPE ... ADD VALUE IF NOT EXISTS`, ship clients that tolerate it first |
| Add a unique constraint | Check for duplicates first: `SELECT col, count(*) FROM t GROUP BY col HAVING count(*) > 1` |

## Indexes

- Every foreign key you join on and every column in a new `WHERE`, `ORDER BY` or filter on a large table gets an index.
- Composite index in the order of the query: equality columns first, then the range or sort column.
- On a large live table use `CREATE INDEX CONCURRENTLY` (outside a transaction; most tools need a raw SQL migration for it).
- Check the plan for new list or analytics queries: `EXPLAIN ANALYZE <query>` on realistic data. A `Seq Scan` on a big table is a finding.

## Data migrations

- Separate from schema migrations. Idempotent (safe to run twice). In batches for big tables.
- Data change on staging or production: backup first, run with that environment's credentials, write down what was changed and when (a `PENDING-DEPLOYS.md` or the PR).

## JSON columns

If a driver may store JSON differently depending on how a row was written (some drivers double-encode, so a `jsonb` column ends up holding a JSON string for some rows), do not read it with a bare `->>` or `jsonb_array_length`: check `jsonb_typeof` or use one shared helper that tolerates both shapes, and test both write paths.

## Report

Migration file name, the SQL statements it runs, whether it is safe against the code currently deployed, indexes added, and what was applied where (local only, unless told otherwise).
