## Working Agreement

These rules apply to every task in this repo.

1. **Read before you write.** Read this file and the files you are about to change. Detect the stack from manifests, never from folder names.
2. **Minimal diff.** Change only what was asked. No drive-by refactors, renames, reverts, dependency bumps or deleted "unused" code. For anything broad, state the blast radius and ask first.
3. **Reuse before you build.** Search the existing components, widgets and helpers first. Extend one with a prop or variant when it almost fits. Ask before creating a new shared component.
4. **Done means what the user sees.** Lint, types and tests passing is your evidence, not proof. For UI or runtime changes, say what you verified and what a human must confirm on the device or in the browser. "Still broken" means the same bug: keep the diagnosis, do not start over.
5. **Verify identifiers from the source.** Any id, enum value, payload field, route or config key used by another system is grepped from its source of truth before you write it. Never infer it from a naming pattern.
6. **Hunt regressions.** A bug reported at the start of a session may be a regression of earlier work. Read `git log -p` on the touched path before changing it, and do not undo a recorded decision (see "Decisions and contracts").
7. **Destructive operations need a backup and a yes.** Database seed/reset/truncate/drop/re-migrate, bucket deletes, and git history rewrites (rebase, force-push, `reset --hard`) require a backup first and an explicit confirmation.
8. **Production is gated.** Never push or merge to the production branch on your own. State the blast radius (repo, branch, consumers, migrations) and wait for a go-ahead.
9. **Secrets stay out.** Never commit `.env*`, keys, tokens or dumps. Never echo a secret into a file, log, report or commit message: write a `<PLACEHOLDER>` and say you did. Stage files by path, never `git add -A`.
10. **Write decisions down.** After a non-trivial fix, add a dated entry to "Decisions and contracts": what changed, the value or contract that must not change, and why.
11. **Plain text.** No long dashes, curly quotes, one-character ellipsis or invisible spaces in code, docs, commits or UI copy. Use `-`, `"`, `'` and `...`.
12. **Commits.** Conventional Commits. Run the gates in "Development Commands" first. After an implementation, offer to write tests.

## Decisions and contracts

Dated entries, newest first. One entry per decision that a future session must not undo.

```
### <Short title> (<YYYY-MM-DD>)
- What: <the behavior or contract now in place>
- Must not change: <field names, enum values, branch, URL shape, env var>
- Why: <the incident or requirement behind it>
- Consumers: <mobile / admin / web / workers that depend on it>
```
