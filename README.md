# project-kickstart

Claude Code skills, review agents and project templates from Codigee, a senior Flutter and full-stack studio. This is the setup we start every project with, packaged so you can use it too. Free, MIT licensed.

We use AI the way a senior team uses any power tool: to move faster and to be more careful at the same time. Every skill here carries the guardrails we learned the hard way: review gates before production, tests next to the code, backups before anything destructive, and "done" judged by what the user actually sees on the screen, not by a green terminal.

## What is inside

```
init/        kickstart skill, CLAUDE.md templates, safe settings.json, 4 review agents, 4 commands
packs/       10 skill packs, install the ones you need
docs/        how to write your own skills, guide to the creative packs
install.sh   installer
```

### init

Run `kickstart` in any repo. It detects the stack, writes a `CLAUDE.md` with the working agreement and the stack's conventions, and adds `.claude/` with safe permissions, four read-only review agents (architecture, code, security, testing) and `/commit`, `/pr`, `/review`, `/quality-check`. Details in [init/README.md](init/README.md).

### Engineering packs

| Pack | Skills | For |
|---|---|---|
| [mobile](packs/mobile) | `flutter-feature`, `flutter-test`, `flutter-release`, `device-verify` | Flutter apps in Clean Architecture with Cubit, from feature scaffold to store release |
| [backend](packs/backend) | `backend-module`, `api-contract`, `db-migrations`, `backend-errors` | TypeScript APIs (Bun, Elysia, Drizzle, PostgreSQL by default) that never break clients in the field |
| [admin-panel](packs/admin-panel) | `admin-crud`, `admin-roles`, `admin-tables-forms` | Next.js admin panels: CRUD screens, permissions with an audit log, tables, imports and forms |
| [infrastructure](packs/infrastructure) | `coolify-deploy`, `env-secrets`, `backup-first`, `object-storage`, `multi-repo-git` | Self-hosted Docker deploys, secrets hygiene, backups, S3 or MinIO, workspaces of sibling repos |
| [website](packs/website) | `site-page`, `site-seo`, `site-i18n`, `site-quality` | Next.js marketing sites: pages, technical SEO, a second language, performance and accessibility |
| [audits](packs/audits) | `review-gate`, `security-audit`, `seo-audit`, `app-audit-report` | Read-only gates and audits, with a one-file HTML report template |

### Creative packs

| Pack | Skills | For |
|---|---|---|
| [marketing](packs/marketing) | `research-with-sources`, `positioning-and-copy`, `ad-creatives`, `aso-store-listing`, `launch-checklist` | Research you can trust, copy without AI tells, ads, store listings, launches you can measure |
| [video](packs/video) | `ai-video-production`, `voice-over`, `video-editing-qa` | Product videos with generative models and synthetic voices that do not look cheap |
| [animation](packs/animation) | `motion-principles`, `scroll-story`, `verify-motion-by-recording` | Motion for web and apps, scroll stories that stay readable, proof that an animation works |
| [ideas-prototyping](packs/ideas-prototyping) | `html-prototype`, `compare-concepts`, `game-design-spec`, `user-test-plan` | From idea to a clickable prototype and a decision in hours, then a test with real people |

A short guide to the creative packs: [docs/creative.md](docs/creative.md).

## Install

Requirements: [Claude Code](https://docs.claude.com/en/docs/claude-code/overview), bash, git.

```bash
git clone https://github.com/codigee-devs/project-kickstart.git
cd your-project

# everything, into ./.claude of this project
../project-kickstart/install.sh --all

# only some packs
../project-kickstart/install.sh --pack init,mobile,backend,audits

# for every project on this machine (~/.claude)
../project-kickstart/install.sh --all --global

# see the plan first, or list what is available
../project-kickstart/install.sh --all --dry-run
../project-kickstart/install.sh --list
```

- Skills go to `.claude/skills/<skill>/`, agents to `.claude/agents/`, commands to `.claude/commands/`.
- Re-running is safe: identical files are skipped, and a file you changed is kept unless you pass `--force`.
- `--target <dir>` installs into another project without `cd`.
- Start a new Claude Code session afterwards, then try: "kickstart this repo", "scaffold a flutter feature for notes", "will this break the app?".

Commit the installed `.claude/` folder into your project so every teammate and every cloud session gets the same setup.

## How we got here

Claude Code is part of how our senior team works on every project, from the first prototype to the store release. The setup in this repo grew out of that work:

- **Museo**, an AI museum guide with apps, an admin panel and an AI pipeline, went from concept to a live product in about three months, with the app UI in 28 languages.
- **Prenta**, a household to-do app that plans ahead: app, backend, an admin panel with MCP and a calendar agent.
- **Buzzin**, a party game show for any TV with phones as buzzers, live on 9 TV platforms for 2 to 16 players.
- **FishPRO**, a fishing app with a catch log, maps and a bite forecast: app, backend, web panel and a mini-game, rated 4.5 in the App Store.

Each project kept a `CLAUDE.md` and a `.claude/` folder. Every time something went wrong (a change that went further than asked, a fix declared done while the screen still showed the bug, an id guessed from a naming pattern, a local database reset without a backup) we wrote the rule down where it would be read next time. This repo is those rules, cleaned up and made generic, so they work in your repo and not only in ours.

## Write your own

Skills are plain Markdown. See [docs/writing-skills.md](docs/writing-skills.md) for the format, how to write triggers that fire, and how to test a skill.

## Contributing

Issues and pull requests are welcome. Keep skills short and actionable, use plain ASCII punctuation, and never include secrets, internal hostnames or client data.

## License

[MIT](LICENSE). Made by [Codigee](https://codigee.com).
