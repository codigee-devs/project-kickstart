---
name: admin-tables-forms
description: Patterns for admin data tables and forms that hold up with real data - server-side pagination, sorting and filters kept in the URL, column definitions, bulk actions, CSV import and export with validation, and react-hook-form + zod forms with server errors mapped to fields. Use when building or fixing a table, a filter bar, a bulk action, an import or a complex form in a panel. Triggers - "data table", "add filters", "pagination", "bulk delete", "CSV import", "form validation", "tabela w panelu", "dodaj filtry", "paginacja", "import CSV", "walidacja formularza".
---

# admin-tables-forms

Reuse the panel's existing `DataTable`, filter and form components first. If there are none, build one shared version, not one per screen.

## Tables

### State lives in the URL

```ts
const searchParams = useSearchParams();
const page = Number(searchParams.get("page") ?? 1);
const pageSize = Math.min(Number(searchParams.get("pageSize") ?? 20), MAX_PAGE_SIZE);
const sort = searchParams.get("sort") ?? "createdAt:desc";
const q = searchParams.get("q") ?? "";
```

Update with `router.replace` and keep the other params. Reload, back button and shared links then just work. Reset `page` to 1 when a filter changes.

### Server-side, always, once data can grow

- The API takes `page`, `pageSize` (with a maximum), `sort` from an allowlist of columns, and filters. It returns `{ items, total }`.
- Search input debounced (300 ms). Filters as selects with values from the backend enum, not free text.
- Every sortable or filterable column has an index on the backend (see `db-migrations`).

### Columns

- Column definitions in their own file. Dates formatted in one helper with the panel's locale and timezone. Enum values shown through a label map, with a fallback for unknown values.
- Row actions in a menu at the end of the row. Destructive ones last, in red, with confirmation.
- Long text truncated with a tooltip; ids copyable.

### Bulk actions

- Selection resets on page or filter change, and the bar says how many are selected.
- The API takes a list of ids and answers per id (succeeded, failed with reason). Show the failures.
- Cap the batch size and say so.

## CSV import and export

Import:
1. Parse in the browser or on the server with a real CSV parser (quotes, commas, UTF-8 BOM).
2. Validate every row with the same zod or Typebox schema the create endpoint uses.
3. Show a preview: valid rows, invalid rows with the reason per cell. Nothing is written yet.
4. Import valid rows in one request that is idempotent on a natural key (re-running the same file does not create duplicates).
5. Report created, updated, skipped, failed.

Reject columns the system no longer supports with a message that says what to use instead, rather than ignoring them silently.

Export: server-side for big tables, same filters as the current view, ISO dates, a header row matching the import format so a file can round-trip.

## Forms

```tsx
const form = useForm<NoteInput>({ resolver: zodResolver(noteInputSchema), defaultValues });

const onSubmit = form.handleSubmit(async (values) => {
  try {
    await save.mutateAsync({ id, input: values });
    onClose();
  } catch (error) {
    const fields = getFieldErrors(error); // from the API's validation response
    if (fields) Object.entries(fields).forEach(([name, message]) => form.setError(name as keyof NoteInput, { message }));
  }
});
```

- One zod schema per form, shared with the API client types. Limits (`max`) match the backend's.
- Labels on every field, errors under the field, required fields marked.
- Submit disabled while pending, no double submit. Unsaved-changes warning on long forms.
- Dependent fields (show B when A = x) are expressed in the schema with `superRefine` or a discriminated union, not only hidden in the UI.
- JSON or config fields get a structured editor or at least validation against the backend's schema before submit; a free textarea that the API rejects with a 422 helps nobody.

## Check

Test with an empty table, one row, more rows than one page, a filter with no results, a slow network (DevTools throttling) and a server error. Report what you tried.
