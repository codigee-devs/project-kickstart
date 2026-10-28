---
name: admin-crud
description: Scaffold a full CRUD screen in a Next.js admin panel - typed API functions, zod schemas, React Query hooks, a list page with a server-paginated table, a create and edit dialog, delete with confirmation, loading and error states. Use when the panel needs to manage a new resource, often right after a backend endpoint is added. Triggers - "add admin screen for", "CRUD in the panel", "manage X in the admin", "dodaj zarzadzanie w panelu", "zrob CRUD w adminie", "ekran w panelu do".
---

# admin-crud

One resource, one folder. Defaults: Next.js App Router, shadcn/ui, TanStack Query, react-hook-form + zod, a typed fetch client. Read the panel's `CLAUDE.md` and copy an existing resource folder before using these defaults.

## 0. Confirm the backend contract

Open the backend module (schema file or OpenAPI) and copy field names, enum values, pagination params and error codes from it. Do not guess them from the UI design. If the endpoint does not exist yet, build it first (`backend-module`), then come back.

## 1. Files

```
src/lib/api/endpoints/<resources>.ts        # typed API functions
src/lib/validators/<resource>.ts            # zod: form schema + response schema
src/app/(dashboard)/<resources>/
  page.tsx                                  # server component, page header + client table
  loading.tsx / error.tsx
  components/<resource>-table.tsx           # "use client", DataTable wiring
  components/<resource>-columns.tsx
  components/<resource>-form-dialog.tsx     # create + edit
  hooks/use-<resources>.ts                  # useQuery / useMutation
src/config/navigation.ts                    # sidebar entry (with the role that may see it)
```

## 2. API functions

```ts
import { apiClient } from "@/lib/api/client";
import { noteListSchema, noteSchema, type NoteInput } from "@/lib/validators/note";

export async function getNotes(params: { page: number; pageSize: number; search?: string }) {
  const data = await apiClient.get("/admin/notes", { params });
  return noteListSchema.parse(data);
}

export async function createNote(input: NoteInput) {
  return noteSchema.parse(await apiClient.post("/admin/notes", input));
}

export async function updateNote(id: string, input: NoteInput) {
  return noteSchema.parse(await apiClient.put(`/admin/notes/${id}`, input));
}

export async function deleteNote(id: string) {
  await apiClient.delete(`/admin/notes/${id}`);
}
```

Parsing responses with zod turns a silent contract drift into a clear error on the screen that caused it.

## 3. Hooks

```ts
export const notesKey = (params: NotesParams) => ["notes", params] as const;

export function useNotes(params: NotesParams) {
  return useQuery({ queryKey: notesKey(params), queryFn: () => getNotes(params), placeholderData: keepPreviousData });
}

export function useSaveNote() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: ({ id, input }: { id?: string; input: NoteInput }) => (id ? updateNote(id, input) : createNote(input)),
    onSuccess: () => {
      toast.success("Saved");
      queryClient.invalidateQueries({ queryKey: ["notes"] });
    },
    onError: (error) => toast.error(getErrorMessage(error)),
  });
}
```

No `useEffect` + `fetch` for server data.

## 4. List page

- Pagination, sorting and search are server-side and live in the URL (`?page=2&q=lamp`), so a reload or a shared link shows the same view. See `admin-tables-forms`.
- Empty state with the create action. Error state with retry. Skeleton rows while loading.

## 5. Form dialog

- react-hook-form with `zodResolver(noteInputSchema)`. The same dialog for create and edit (`defaultValues` from the row).
- Submit button disabled while pending. Server validation errors mapped back onto fields when the API returns field names.
- Close the dialog only on success.

## 6. Delete

- Confirmation dialog that names the item ("Delete note 'Lamp history'?").
- If the backend archives instead of deleting (rows still referenced elsewhere), the button says "Archive" and the toast says what happened.

## 7. Access

- The page is inside the protected route group. The sidebar entry and the page both check the role (see `admin-roles`). The backend checks it too; the panel check is only UX.

## 8. Check and report

```bash
<pm> run lint && <pm> run typecheck && <pm> test
```

Open the page in the browser: list, search, create, edit, delete, and one forced error. Report what you clicked through and what the user should check with real data.
