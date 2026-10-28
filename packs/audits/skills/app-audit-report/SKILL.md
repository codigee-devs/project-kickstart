---
name: app-audit-report
description: Audit an existing app (mobile, backend, admin, web) end to end and deliver the result as one self-contained HTML file - inventory, scorecard per area, findings by severity with evidence, risks for a takeover or launch, and a phased fix plan. Also renders other audits (security, SEO, review) as a shareable HTML report. Use when taking over a codebase, before a launch, or when a client asks "what state is our app in". Triggers - "audit this app", "app audit", "code audit report", "html report", "takeover audit", "audyt aplikacji", "audyt w htmlu", "raport html", "w jakim stanie jest ta aplikacja".
---

# app-audit-report

The deliverable is one `.html` file that opens offline, prints well and can be sent to someone who will never open the repo. The template is in `templates/report.html` next to this file.

## 1. Inventory (facts, no opinions yet)

- Repos, stacks and versions (from manifests), size (`git ls-files | wc -l`, lines per language), age and activity (`git log --reverse --format=%ad | head -1`, commits in the last 90 days, number of contributors).
- How it builds and runs: does `install`, `build`, `test` work from a clean clone? Time it. Anything undocumented you had to guess is a finding.
- Environments, deploy method, where secrets live (names only).

## 2. Areas and what to check

| Area | Check |
|---|---|
| Architecture | layering, module boundaries, god files (`find . -name '*.dart' -o -name '*.ts' | xargs wc -l | sort -n | tail`), duplication, dead code |
| Code quality | analyzer or lint output count, `any`/`dynamic` count, TODO/FIXME count, error handling pattern |
| Tests | test count, what they cover, do they pass, CI runs them? |
| Security | run `security-audit` (secrets, auth on routes, validation, dependencies) |
| Dependencies | outdated majors, abandoned packages, known vulnerabilities, framework end-of-life |
| Performance | app start, list screens, N+1 queries, bundle size, Lighthouse for web |
| UX and accessibility | localization coverage, semantics, contrast, offline and error states |
| Release and ops | versioning, release scripts, store setup, backups, monitoring, logs |
| Documentation | README, CLAUDE.md or onboarding docs, API docs |

Collect evidence for every finding: a file path and line, a command and its output, a screenshot. A finding without evidence does not go in the report.

## 3. Grade

Per area: a score from 1 to 5 with one sentence why. Per finding: Critical, High, Medium, Low, with impact in business terms ("users on Android 10 cannot log in", "a leaked key gives write access to all uploads") and effort (S, M, L).

## 4. Plan

Three phases: **Now** (critical and cheap high items, days), **Next** (stability and tests, weeks), **Later** (refactors and upgrades). Each item: what, why, effort, dependency. Be honest about what a rewrite would and would not fix; a full rewrite is rarely the right first recommendation.

## 5. Render the HTML

1. Copy `templates/report.html` to the output path: the path the user gave, else `reports/<type>-<YYYY-MM-DD>.html` in the repo (create `reports/`), else a scratch folder.
2. Replace the `{{...}}` slots. Repeat the finding rows and area cards as needed. Keep it one file: inline CSS, no external fonts, scripts or images (embed small screenshots as `data:` URIs or link to them).
3. HTML-escape all dynamic text (`&`, `<`, `>`, `"`, `'`).
4. Scrub secrets, internal hostnames, private IPs and personal data to placeholders before writing. Say if you did.
5. Write in the language the user asked in; match the repo's docs language if the file lives in a docs repo.
6. Plain ASCII punctuation in the copy.
7. Open it (`open <file>` on macOS, `xdg-open` on Linux) and give the absolute path.

Do not commit the report unless asked; it may contain details the client has not approved for the repo.

## 6. Say what you did not check

A section "Not covered" with what was out of reach (production data, real devices, load testing, third-party systems). An audit that hides its limits is worse than a short one.
