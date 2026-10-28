---
name: kickstart
description: Set up Claude Code in a repository - detect the stack, write a CLAUDE.md from the matching template, add .claude/settings.json with safe permissions and the four review agents plus /commit, /pr, /review and /quality-check. Use when starting a new project or onboarding an existing repo. Triggers - "kickstart this repo", "set up claude for this project", "bootstrap .claude", "create CLAUDE.md", "init claude code here", "przygotuj repo pod claude", "zrob CLAUDE.md", "zainicjuj projekt".
---

# kickstart

Gives a repo the setup we start every project with: a `CLAUDE.md` that holds the working agreement and the stack's conventions, a `.claude/` folder with safe permissions, review agents and workflow commands. The templates live in `templates/` next to this file.

## 1. Look before writing

```bash
ls -a
git rev-parse --show-toplevel 2>/dev/null || echo "not a git repo"
ls .claude CLAUDE.md 2>/dev/null
```

- If `CLAUDE.md` or `.claude/` already exist, read them. Never overwrite: merge missing sections in and show the user what you added.
- If this is not a git repo, ask whether to run `git init` before going on.

## 2. Detect the stack (from manifests, never from the folder name)

| Signal | Template |
|---|---|
| `pubspec.yaml` | `CLAUDE.flutter.md` |
| `package.json` with `next` | `CLAUDE.nextjs.md` |
| `package.json` with `elysia`, `express`, `fastify`, `hono`, `@nestjs/core`, or `drizzle-orm`/`knex`/`prisma` and no `next` | `CLAUDE.backend-ts.md` |
| Several sibling folders that each contain `.git` | `CLAUDE.workspace.md` (and run kickstart per repo after) |
| Anything else (`pyproject.toml`, `go.mod`, `Cargo.toml`, empty repo) | `CLAUDE.generic.md` |

Also read: the lockfile (package manager), the lint config, the test setup, `README.md`, and `git log --oneline -15` (commit style). If two templates fit, ask one question with both options.

## 3. Write CLAUDE.md

1. Copy the chosen template to `./CLAUDE.md`.
2. Replace `{{WORKING_AGREEMENT}}` with the full content of `templates/working-agreement.md`.
3. Fill every `<placeholder>` from what you read: versions from the manifest, real commands from `package.json` scripts or the Makefile, the real directory tree (`find src lib -maxdepth 2 -type d`). Delete rows that do not apply. If a value is unknown, leave a visible `TODO:` rather than inventing it.
4. Keep it short. A CLAUDE.md that nobody reads protects nothing. Target under 250 lines; move long reference material into a skill.

## 4. Write .claude/

```bash
mkdir -p .claude/agents .claude/commands .claude/skills
```

- `settings.json`: copy `templates/settings.json`. Add the stack's own commands to `allow`, for example:
  - Flutter: `Bash(flutter analyze:*)`, `Bash(flutter test:*)`, `Bash(flutter pub get:*)`, `Bash(dart run build_runner:*)`, `Bash(dart format:*)`
  - Bun: `Bash(bun test:*)`, `Bash(bun run lint:*)`, `Bash(bun run typecheck:*)`, `Bash(bun run build:*)`, `Bash(bunx biome check:*)`
  - pnpm / npm: the same with `pnpm` or `npm run`
  - Python: `Bash(pytest:*)`, `Bash(ruff:*)`, `Bash(mypy:*)`
  Keep migrations, seeds, deploys and pushes out of `allow`: they belong in `ask`.
- Agents and commands: copy `architecture-review.md`, `code-review.md`, `security-review.md`, `testing-review.md` into `.claude/agents/` and `commit.md`, `pr.md`, `review.md`, `quality-check.md` into `.claude/commands/`. Take them from wherever project-kickstart was installed: `~/.claude/agents/` and `~/.claude/commands/` (global install) or the project-kickstart repo's `init/agents/` and `init/commands/`. If none are found, tell the user to run `install.sh --pack init` and stop.
- Committing these files into the repo means every teammate and every cloud session gets the same setup.

## 5. Secrets baseline

- Make sure `.gitignore` covers: `.env`, `.env.*` (but not `.env.example`), `*.pem`, `*.p8`, `*.p12`, `*.jks`, `*.keystore`, `service-account*.json`, local dumps (`*.sql.gz`, `backups/`).
- If an `.env` exists without an `.env.example`, create the example with the variable names only, values replaced by `<PLACEHOLDER>`. Never copy a value.

## 6. Suggest packs

Name the project-kickstart packs that fit the detected stack (mobile, backend, admin-panel, website, infrastructure, audits) and the install command, for example `install.sh --pack mobile,audits --target .`. Do not install them without a yes.

## 7. Report

List the files created or changed, the placeholders left as `TODO:`, and the next step ("fill the TODOs, then commit `CLAUDE.md` and `.claude/`"). Do not commit unless asked. Never add secrets to any file you write.
