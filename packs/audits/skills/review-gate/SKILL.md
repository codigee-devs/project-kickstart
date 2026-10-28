---
name: review-gate
description: Read-only review gate before a merge or a production push - finds regressions and backward-compatibility breaks first, then security, clean code, scalability and missing tests, graded by severity with a clear merge verdict. Works on the working tree, a branch or a GitHub PR, across sibling repos. Never fixes, commits or pushes. Triggers - "review this", "review the PR", "will this break anything", "is it safe to merge", "check before prod", "zrob review", "czy nic nie zepsujemy", "sprawdz PRa", "czy to jest bezpieczne", "przejrzyj zmiany przed pushem".
---

# review-gate

The most expensive bug is the one that breaks a client you did not look at. This gate looks at them first.

## 1. Target

- PR: `gh pr view <n> --json title,baseRefName,headRefName,files,additions,deletions` and `gh pr diff <n>`.
- Branch: `git diff <base>...HEAD` plus `git diff` and `git diff --staged`. Find the base from the repo's branch model; do not assume `main` exists.
- Workspace with sibling repos: run per repo with `git -C <repo>`, for every repo the change touches.

Say in one line what you review: repo, branch or PR, base, file count.

## 2. Stack checklists

Detect from manifests and read the matching rules in each repo's `CLAUDE.md`. If the project has the review agents from `init`, run the ones that match (see `/review`).

## 3. Checklist, in this order

**1. Regressions and backward compatibility (most findings live here)**
- Removed or renamed routes, methods, params, response fields, enum values, error codes, events.
- Type or nullability changes, array <-> object, pagination changes, stricter validation on existing input.
- Migrations that drop, rename or retype columns used by the running code.
- Ids, enum values or payload keys used by another system: grep that system's source, never trust the name.
- For each consumer (mobile, admin, web, workers, partners) write: breaks or not, and why.
- Unrequested changes: refactors, reverts, deleted "unused" code, renamed things. Past regressions came from exactly these.

**2. Security**
- New route without auth guard; user id from input instead of session; missing ownership or tenant filter.
- Missing validation at the boundary; SQL by string concatenation; unsanitized HTML.
- Secrets in the diff, fixtures, docs or logs (refer to them as `path:line`, never print them).

**3. Clean code**
- `any` / `dynamic`, swallowed errors, `console.log` / `print`, magic values, hardcoded styles instead of tokens, missing localization.
- Async UI updates after the owner is gone (Flutter `isClosed`, stale React responses).

**4. Scalability**
- N+1 queries, list endpoints without limits, new filters or sorts without an index, unbounded loops over remote calls, CORS changes.

**5. Tests**
- Changed logic without tests, bug fixes without a regression test.

## 4. Run the gates, do not fix them

Run lint, types and tests for each touched repo and report the result. A red gate is a finding.

## 5. Report

```
## Review: <repo> <branch or PR> vs <base>
Stack: <...> | Files: <n> | +<a> / -<d> | Gates: lint <ok>, types <ok>, tests <x/y>

### Critical
- [REGRESSION] path:line - what - breaks <consumer> because - proposal
### High
### Medium
### Low

### Backward compatibility
<Yes / No, one paragraph per consumer>

### Tests
<covered / missing>

### Verdict
Merge OK / Do not merge until: <list>. If this goes to production: blast radius <repos, branches, clients, migrations>.
```

If the diff is empty, say so and ask what to review.

## Rules

- Read-only. Fixing is a separate request.
- Never merge or push. Production pushes wait for an explicit yes after this report.
- No destructive commands during review.
- Run it more than once on big changes: a second pass with fresh eyes (or a second agent given only the diff) finds what the first one rationalized.
