# init

What we put into every repo before the first feature. Install it once (`./install.sh --pack init --global`) and run the `kickstart` skill in any repo.

| Path | What it is |
|---|---|
| `skills/kickstart/` | Skill that detects the stack and writes `CLAUDE.md` and `.claude/` for the repo |
| `skills/kickstart/templates/` | `CLAUDE.md` templates (Flutter, TypeScript backend, Next.js, multi-repo workspace, generic), the shared working agreement and a `settings.json` with safe permissions |
| `agents/` | Four review agents: architecture, code, security, testing. Read-only, they report and never edit |
| `commands/` | `/commit`, `/pr`, `/review`, `/quality-check` |

## Why these four agents

Every agent answers one question, so each review stays short and specific:

- **architecture-review**: is the code in the right place, and does it break a boundary or a contract?
- **code-review**: is it correct, typed, readable and inside the scope that was asked?
- **security-review**: can someone reach data they should not, and did a secret leak?
- **testing-review**: would the tests catch this bug next time?

`/review` routes the changed files to the agents that matter for them and merges the answers into one report.

## The settings.json

- `allow`: read-only git, local commits, listing and searching files.
- `ask`: anything that leaves the machine or changes shared state: push, merge, rebase, PR create and merge, docker, psql, rm.
- `deny`: force-push, `reset --hard`, `clean -fd`, `rm -rf`, and reading `.env` files and key files.

Add your stack's lint, test and build commands to `allow`. Keep migrations, seeds and deploys out of it.

## The working agreement

`templates/working-agreement.md` holds the twelve rules every generated `CLAUDE.md` starts with. Each rule exists because breaking it cost us time on a real project: changes that went beyond the ask, "done" claimed on a green test while the screen was still wrong, an id guessed from a naming pattern, a local database reset without a backup. Edit the rules to fit your team, but keep the section: it is what makes a fresh session behave like the last one.
