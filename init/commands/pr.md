---
description: Open a pull request with a summary, change list, test steps and blast radius
argument-hint: "[base branch, default: the repo's integration branch]"
---

Open a pull request for the current branch. Base branch: $ARGUMENTS (if empty, use the integration branch named in `CLAUDE.md`, usually `develop` or `main`; confirm it exists with `git rev-parse --verify origin/<base>`).

1. Make sure the branch is committed and pushed: `git status --short` must be clean for the files in scope; push with `git push -u origin <branch>` if there is no upstream.
2. Collect the facts: `git log --oneline origin/<base>..HEAD` and `git diff --stat origin/<base>...HEAD`.
3. Run the `/quality-check` gates if they have not run on this commit. Put the real result in the PR.
4. Write the PR in English. Title = Conventional Commit style summary of the whole branch. Body:
   ```markdown
   ## Summary
   One or two sentences: what changes for the user and why.

   ## Changes
   - Bullet per meaningful change, grouped by area.

   ## Contracts and blast radius
   - API, DB, events or config this touches, and every consumer (mobile, admin, web, workers).
   - Backward compatible: yes / no, and why.
   - Deploy notes: migrations, env vars, flags, order of deploys.

   ## How to test
   1. Steps a reviewer can follow, with the preview URL if the platform builds one.

   ## Verified
   - What was actually run (lint, types, tests, manual check) and what still needs a human check on a device or in the browser.
   ```
5. Create it: `gh pr create --base <base> --title "<title>" --body-file <file>`.
6. Return the PR URL. Never merge it yourself, and never target the production branch without an explicit go-ahead.
