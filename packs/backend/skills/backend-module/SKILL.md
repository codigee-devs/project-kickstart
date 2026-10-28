---
name: backend-module
description: Scaffold a TypeScript backend module - request and response schemas, a service with typed errors, routes with an auth guard and validation, a table and migration if needed, and route-level tests. Default templates for Bun + Elysia + Drizzle, with notes for Express, Fastify, Knex and Prisma. Use when adding an endpoint group or a new domain to an API. Triggers - "new endpoint", "add a module", "create an API for X", "scaffold backend module", "nowy endpoint", "dodaj modul na backendzie", "zrob API do".
---

# backend-module

One module per domain: `src/modules/<name>/` with `<name>.schema.ts`, `<name>.service.ts`, `index.ts` (routes) and tests. Copy the structure of an existing module before using the defaults here.

## 0. Detect the stack

| Lockfile and deps | Commands | Typical stack |
|---|---|---|
| `bun.lock` / `bun.lockb` + `elysia` | `bun run ...`, `bun test` | Elysia, Typebox (`t`), Drizzle, Eden Treaty tests |
| `pnpm-lock.yaml` / `package-lock.json` + `express` or `fastify` | `pnpm ...` / `npm run ...`, jest or vitest | zod, Knex or Prisma, supertest |

Never run npm scripts in a Bun repo or the other way round.

## 1. Contract first

Before code, write down (in the PR description or a docs file):

- Routes: method, path, who may call it (role, ownership), request schema, response schema, error codes.
- Consumers: which clients will call it (mobile, admin, web, worker).
- Every field and enum name the client will read. These are now a contract (see `api-contract`).

## 2. Schema (`<name>.schema.ts`)

```ts
import { t } from "elysia";

export const createNoteSchema = t.Object({
  title: t.String({ minLength: 1, maxLength: 200 }),
  body: t.Optional(t.String({ maxLength: 10_000 })),
});

export const noteResponseSchema = t.Object({
  id: t.String({ format: "uuid" }),
  title: t.String(),
  body: t.Nullable(t.String()),
  createdAt: t.String(),
});

export const listQuerySchema = t.Object({
  limit: t.Optional(t.Numeric({ minimum: 1, maximum: 100, default: 20 })),
  offset: t.Optional(t.Numeric({ minimum: 0, default: 0 })),
});
```

zod equivalent: `z.object({ title: z.string().min(1).max(200), ... })`, validated in a middleware before the handler.

## 3. Service (`<name>.service.ts`)

Business rules, ownership checks and DB access. Throws typed errors (see `backend-errors`). No HTTP types.

```ts
import { and, desc, eq } from "drizzle-orm";
import { db } from "@/utils/db";
import { notes } from "@/utils/db/schema";
import { buildError } from "@/utils/errors";

export class NotesService {
  static async getById(userId: string, id: string) {
    const [note] = await db
      .select()
      .from(notes)
      .where(and(eq(notes.id, id), eq(notes.ownerId, userId)))
      .limit(1);
    if (!note) throw buildError("NOT_FOUND", "Note not found");
    return note;
  }

  static async list(userId: string, limit: number, offset: number) {
    return db
      .select()
      .from(notes)
      .where(eq(notes.ownerId, userId))
      .orderBy(desc(notes.createdAt))
      .limit(limit)
      .offset(offset);
  }

  static async create(userId: string, input: { title: string; body?: string }) {
    const [created] = await db.insert(notes).values({ ...input, ownerId: userId }).returning();
    return created;
  }
}
```

The ownership filter is in the query, so another user's id answers 404, not 403. That does not leak which ids exist.

## 4. Routes (`index.ts`)

```ts
import { Elysia } from "elysia";
import { auth } from "@/utils/auth";
import { createNoteSchema, listQuerySchema, noteResponseSchema } from "./notes.schema";
import { NotesService } from "./notes.service";

export const notesModule = new Elysia({ prefix: "/notes" })
  .use(auth)
  .get("/", ({ user, query }) => NotesService.list(user.id, query.limit ?? 20, query.offset ?? 0), {
    auth: true,
    query: listQuerySchema,
  })
  .post("/", ({ user, body }) => NotesService.create(user.id, body), {
    auth: true,
    body: createNoteSchema,
    response: noteResponseSchema,
  });
```

- `auth: true` stands for whatever guard your auth plugin exposes (a macro, `beforeHandle`, a middleware). Use the one the existing modules use.
- Every route has the guard. A public route says so in a comment with the reason.
- The user id comes from the session, never from the body or path.
- No `try/catch` here: the global error handler maps typed errors.
- Register the module in the app entry file.

## 5. Table and migration (if new data)

Add the table to the schema file with `id` (uuid, default random), `createdAt`, `updatedAt`, foreign keys with an explicit `onDelete`, and an index for every column you filter or sort by. Then follow `db-migrations` (generate, read the SQL, apply locally).

## 6. Tests

Go through the HTTP layer so the guard and validation run too:

| Case | Expect |
|---|---|
| Create with valid body | 200/201 and the response shape |
| Invalid body (empty title, too long) | 422 / 400 with the validation code |
| No session | 401 |
| Another user's resource | 404 |
| List pagination | `limit` respected, max enforced |

## 7. Gates and report

```bash
bun run lint && bunx tsc --noEmit && bun test
```

Report the routes added, the migration file, test results, and the consumers that need to be updated (with the exact field names).
