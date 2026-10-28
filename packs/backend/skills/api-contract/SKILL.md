---
name: api-contract
description: Keep API changes backward compatible with clients already in the field - classify a change as additive or breaking, find every consumer, plan expand-then-contract for breaking changes, and record the contract in CLAUDE.md. Use for any change to a response, request, route, enum, status code, auth rule or event payload, and before every production push of a backend. Triggers - "will this break the app", "is this backward compatible", "change the response", "rename this field", "czy nic nie zepsujemy", "czy to jest kompatybilne wstecz", "zmien response", "zmien nazwe pola".
---

# api-contract

A mobile build in the store cannot be updated together with the server. People run old versions for weeks. Anything that reaches production has to work with every client version still in use.

## 1. Classify the change

| Change | Safe? |
|---|---|
| New optional response field | Safe |
| New endpoint | Safe |
| New optional request field with a default | Safe |
| New enum value in a response | Safe only if clients tolerate unknown values. Check the client's parser first |
| Remove or rename a response field | Breaking |
| Change a field type, nullability (non-null -> null), or array <-> object | Breaking |
| New required request field, stricter validation on an existing field | Breaking |
| Remove or rename a route, method, query param or path param | Breaking |
| Change a status code, error code or redirect | Breaking for clients that branch on it |
| Change pagination defaults or shape | Breaking |
| Tighter auth, rate limit or CORS on an existing route | Breaking for the clients it locks out |
| Rename or remove an enum value clients send or read | Breaking |

## 2. Find every consumer

Do not trust memory. Grep each client repo for the route path, the field name and the enum values:

```bash
git -C ../<project>-mobile grep -n "notes/" -- lib/
git -C ../<project>-mobile grep -n "createdAt\|created_at" -- lib/features/notes/
git -C ../<project>-admin grep -n "/notes" -- src/
```

Also check workers, webhooks you send, analytics events, exports and partner integrations. Name each consumer in the PR.

## 3. If it is breaking: expand, migrate, contract

1. **Expand:** add the new field, route or value next to the old one. Server sends both, accepts both.
2. **Migrate:** ship clients that use the new shape. Wait until the old app versions are below the share you accept (store analytics), or force an update with a minimum-version check.
3. **Contract:** remove the old shape in a later release, and say so in the PR.

If none of that is possible, do not push it to production on your own: list the consumers that break and ask.

## 4. Additive habits that prevent most breaks

- Add fields, do not repurpose them.
- Make clients tolerant: unknown enum values map to a fallback, unknown fields are ignored, missing optional fields have defaults.
- Version deliberately (`/v2/...` or a header) only when a resource really changes meaning.
- Keep one source for shared types (generated client, contracts package, OpenAPI). Hand-copied types drift.

## 5. Record the contract

After a non-trivial contract change, add a dated entry to the backend's `CLAUDE.md`:

```markdown
### Notes list returns pinned first (2026-03-14)
- What: GET /notes orders by pinned desc, then createdAt desc. Adds `pinned: boolean`.
- Must not change: field name `pinned`, the ordering, default page size 20.
- Why: mobile renders pinned notes in a separate section from the first page.
- Consumers: mobile >= 2.3 (reads pinned), admin (ignores it). Older mobile ignores the field.
```

This is what stops the next session from "simplifying" it away.

## 6. Before a production push

State in the PR or chat:

- Contract changes in this diff (response, request, routes, enums, auth, migrations).
- Verdict: backward compatible yes or no, and why, per consumer.
- Deploy order (migration before code, backend before clients).

Then wait for an explicit go-ahead.
