---
name: admin-roles
description: Add or review roles and permissions in an admin panel and its API - a permission map as the single source, server-side checks on every admin route, UI gating that mirrors it, an audit log of admin writes, and safe handling of impersonation and disabled accounts. Use when adding an admin role, restricting a screen, or reviewing who can do what. Triggers - "add a role", "only admins can", "permissions in the panel", "who can edit this", "audit log", "dodaj role", "uprawnienia w panelu", "tylko admin moze", "log zmian w panelu".
---

# admin-roles

The rule that matters: the server decides. Hiding a button is a convenience, not a control.

## 1. One permission map

Define permissions as data, shared by the API and the panel (a contracts package, or duplicated with a test that compares them):

```ts
export const ROLES = ["owner", "admin", "editor", "viewer"] as const;
export type Role = (typeof ROLES)[number];

export const PERMISSIONS = {
  "content.read": ["owner", "admin", "editor", "viewer"],
  "content.write": ["owner", "admin", "editor"],
  "users.manage": ["owner", "admin"],
  "billing.manage": ["owner"],
} as const satisfies Record<string, readonly Role[]>;

export type Permission = keyof typeof PERMISSIONS;
export const can = (role: Role, permission: Permission) =>
  (PERMISSIONS[permission] as readonly Role[]).includes(role);
```

Check permissions, not role names, in code. Adding a role then means editing the map, not every route.

## 2. Server: every admin route

- A guard that reads the role from the verified session and checks `can(role, permission)`. Missing permission = 403 with a stable code.
- Tenant scoping: an admin of tenant A never reads or writes tenant B. Put the tenant filter in the query.
- Admin-only routes live under one prefix (`/admin/...`) with the guard applied to the group, so a new route cannot forget it.
- Disabled or deleted accounts are refused at the session check, not per route.
- Tests: for each admin route, one test per role that must be refused.

## 3. Panel: mirror, do not decide

- Sidebar entries and page routes carry the permission they need; hide what the role cannot use.
- The page still handles 403 from the API (someone opened the URL directly, or the role changed mid-session): show "You do not have access" instead of an error.
- Never ship admin-only data in client bundles or public props for users who should not see it.

## 4. Audit log of admin writes

Every create, update, delete and permission change from the panel writes one row:

| Column | Content |
|---|---|
| `actorId` | who (user id) |
| `action` | `content.update`, `user.role_change`, ... |
| `entity`, `entityId` | what |
| `before`, `after` | JSON snapshots of the changed fields |
| `createdAt` | when |

Write it in the same service call (or transaction) as the change. With before and after stored, a "revert" button is a replay of `before` through the same service, journaled as its own entry. If you expose admin writes to automation (scripts, an MCP server, Claude), route them through the same services and the same validation and log, never a parallel write path.

## 5. Sensitive actions

- Role changes, user deletion, data export and impersonation need the higher permission and a confirmation dialog that names the target.
- Impersonation is time-limited, visible in the UI as a banner, and logged with both ids.
- Nobody can raise their own role or remove the last owner.

## 6. Review checklist

- [ ] Every admin route has the guard (grep the router for routes without it).
- [ ] Role comes from the session, never from the request body.
- [ ] Tenant filter in every admin query.
- [ ] UI gating matches the permission map.
- [ ] Admin writes are logged with before and after.
- [ ] Tests cover refused roles, not only allowed ones.
