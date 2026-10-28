---
description: Route the changed files to the review agents and merge their findings into one report
argument-hint: "[base branch or PR number]"
---

Review the current change. Target: $ARGUMENTS (a PR number or URL, a base branch, or empty for the working tree against the integration branch).

1. Get the change set:
   - PR: `gh pr diff <n>` and `gh pr view <n> --json title,baseRefName,files`
   - Branch: `git diff --name-only <base>...HEAD` plus `git status --short`
   State in one line what you are reviewing (repo, branch or PR, base).
2. Route files to agents in `.claude/agents/`:

   | Changed | Agents |
   |---|---|
   | New module, feature folder, moved files, new dependency | architecture-review, code-review |
   | Routes, controllers, auth, middleware, config, env handling | security-review, code-review |
   | Services, cubits, hooks, business logic | code-review, testing-review |
   | DB schema, migrations, queries | architecture-review, security-review (plus a database specialist if the project has one) |
   | Tests only | testing-review |
   | UI components, pages | code-review (plus accessibility or theme specialists if present) |

   Run every agent that matches at least one file. Give each one the file list and the base, not your own conclusions.
3. Merge the results into one report, deduplicated, ordered by severity:
   ```
   ## Review: <target>
   ### Critical (blocks merge)
   ### High
   ### Medium / Low
   ### Backward compatibility
   Can this break an existing consumer (shipped app versions, admin, web, integrations)? Yes or no, and why.
   ### Tests
   ### Verdict
   Merge OK, or not until: <list>.
   ```
4. Do not fix anything as part of the review. Fixing is a separate step the user asks for.
