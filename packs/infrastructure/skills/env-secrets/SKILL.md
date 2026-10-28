---
name: env-secrets
description: Keep secrets out of git, logs, reports and chat - .env and .env.example hygiene, gitignore patterns, a pre-commit secret scan, what to do when a secret is pasted into a prompt or committed, and moving secrets to a new machine. Use when adding env vars, setting up a repo, before committing, and whenever a key, token or password shows up in text. Triggers - "add an env var", "set up .env", "I pasted a key", "secret in the repo", "rotate the token", "dodaj zmienna srodowiskowa", "wkleilem klucz", "sekret w repo", "przeniesc sekrety".
---

# env-secrets

## Rules

1. Secrets live in the deploy platform's env settings and in a password manager. Locally in `.env` files that are gitignored.
2. Every repo has an `.env.example` with every variable name and a placeholder value, committed.
3. Never write a real secret into any file you generate: code, docs, reports, test fixtures, commit messages, PR text, logs. Use `<PLACEHOLDER>` or `${ENV_NAME}` and say that you did.
4. If the user pastes a secret into the chat, do not repeat it back, do not write it anywhere, and suggest rotating it if it might have been shared further.

## Gitignore baseline

```gitignore
.env
.env.*
!.env.example
*.pem
*.p8
*.p12
*.key
*.jks
*.keystore
service-account*.json
*credentials*.json
GoogleService-Info.plist
google-services.json
backups/
*.dump
*.sql.gz
keys/
```

Mobile config files like `google-services.json` are not strictly secret, but they identify your projects; keep them out of public repos and provide them in CI.

## Adding a variable

1. Add it to `.env.example` with a placeholder and a comment on where to get it.
2. Read it in one config module that validates presence and type at startup (zod or a small check). Fail fast with the variable name, never the value.
3. Add it to the platform for each environment.
4. Mention it in the PR under deploy notes.

```ts
const envSchema = z.object({
  DATABASE_URL: z.string().url(),
  PAYMENT_API_KEY: z.string().min(1),
  LOG_LEVEL: z.enum(["debug", "info", "warn", "error"]).default("info"),
});
export const env = envSchema.parse(process.env);
```

## Scan before committing

```bash
# files that must never be staged
git status --porcelain -z | tr '\0' '\n' | cut -c4- \
  | grep -iE '(^|/)\.env($|\.)|\.pem$|\.p8$|\.p12$|\.key$|\.jks$|\.keystore$|service-account.*\.json|credentials.*\.json'

# secret-looking strings in the staged diff
git diff --staged | grep -nE '(sk|pk|rk)_(live|test)_[A-Za-z0-9]{10,}|AKIA[0-9A-Z]{16}|ghp_[A-Za-z0-9]{30,}|-----BEGIN [A-Z ]*PRIVATE KEY-----|xox[abp]-[A-Za-z0-9-]{10,}'
```

For a team, add a scanner to pre-commit or CI (gitleaks or trufflehog) so it does not depend on memory.

## A secret was committed

1. Rotate it first. Removing it from history does not un-leak it; anyone who cloned or any cache may have it.
2. Remove it from the current tree and move it to env.
3. Rewriting history (`git filter-repo`) is a destructive operation: only with a backup of the repo and an explicit yes, and every collaborator must re-clone.

## Logs and reports

- Never log tokens, passwords, OTP codes, API keys, full request headers or auth request bodies.
- Before writing a report, audit or HTML summary, scrub keys, tokens, internal hostnames and private IPs to placeholders.

## New machine

Secrets do not come with `git clone`. List the files each repo needs (from `.env.example`), copy them over a secure channel or rebuild them from the platform and the password manager. Write the list into the workspace setup doc, without values.
