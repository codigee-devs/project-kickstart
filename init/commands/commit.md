---
description: Run the project gates, then make one Conventional Commit of the intended files only
argument-hint: "[optional scope or message hint]"
---

Make a commit of the current change. Hint from the user: $ARGUMENTS

1. Show the state: `git status --short` and `git diff --stat`. Restate in one line which files you will commit and which you will leave out.
2. Secret guard. Never stage these, and warn if any are present:
   ```bash
   git status --porcelain -z | tr '\0' '\n' | cut -c4- \
     | grep -iE '(^|/)\.env($|\.)|\.pem$|\.p8$|\.p12$|\.key$|\.jks$|\.keystore$|id_rsa|id_ed25519|credentials.*\.json|service-account.*\.json'
   ```
3. Run the gates from `CLAUDE.md` ("Development Commands"): lint, type check, tests. If one fails, stop and report the error. Do not commit around a red gate.
4. Stage by path: `git add <file> <file>`. Never `git add -A` or `git add .`: working trees collect env files, dumps and other people's work.
5. Write the message from the staged diff (`git diff --staged`), not from memory:
   - `<type>(<scope>): <imperative summary>` with type one of feat, fix, refactor, perf, test, docs, style, chore, build, ci.
   - Optional body: why the change was needed and any contract it touches.
   - Match the language and style of `git log --oneline -10`.
   - No `Co-Authored-By` trailer: the person who owns the change is the author.
6. Commit with a heredoc so backticks and quotes survive:
   ```bash
   git commit -F - <<'EOF'
   fix(auth): keep the session when the token refresh races a resume

   Body explaining why.
   EOF
   ```
7. Report the commit hash and subject. Do not push unless the user asked for it.
