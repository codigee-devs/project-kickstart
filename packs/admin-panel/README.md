# admin-panel

The panel that runs the product: content, users, configuration. Defaults: Next.js App Router, shadcn/ui, TanStack Query, react-hook-form + zod, a typed API client.

| Skill | Use it when |
|---|---|
| `admin-crud` | The panel needs to manage a new resource. API functions, hooks, list page, create and edit dialog, delete, all typed from the backend contract. |
| `admin-roles` | You add a role, restrict a screen, or need an audit log. One permission map, server-side checks, UI that mirrors them, before and after snapshots of admin writes. |
| `admin-tables-forms` | You build tables, filters, bulk actions, CSV import and export, or complex forms that have to survive real data. |

## What we learned building panels

- A mobile feature usually means three pieces: the backend endpoint, the admin screen to manage it, and the app screen. Plan all three.
- The panel is a client of the API like the app is. It parses responses, it does not trust them.
- When the panel can be driven by automation (scripts or an MCP server for Claude), the writes must go through the same services, validation and audit log as the buttons.
- Search the existing components before adding new ones. Panels rot fastest when every screen has its own table.

## Where it comes from

Admin panels for a household planner (content, recommendation rules, an MCP connector with a change log and revert) and a museum guide platform (venues, artworks, narrations, many UI languages).
