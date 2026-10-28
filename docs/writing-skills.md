# Writing your own skill

A skill is a folder with a `SKILL.md`. Claude Code reads the frontmatter of every installed skill at the start of a session and loads the body only when a request matches the description. So the description decides when the skill fires, and the body decides what Claude does once it does.

## Format

```
my-skill/
  SKILL.md            required
  references/*.md     optional: long material Claude reads only when the body points to it
  templates/*         optional: files the skill copies or fills in
  scripts/*           optional: helpers the skill runs
```

```markdown
---
name: my-skill
description: One sentence on what it does, one on when to use it. Triggers - "phrase people really type", "another phrase", "fraza po polsku".
---

# my-skill

Body: steps, checklists, commands, templates.
```

- `name` equals the folder name: lowercase, hyphens, unique across everything you install.
- `description` is the trigger. Write the words people type, in every language your team uses, including the casual ones ("will this break anything?"). Say when NOT to use it if a neighbor skill is close.

## The body

Write it like a runbook for a capable colleague who has never seen the repo.

1. **Start with what to read or detect.** Most bad output comes from assuming the stack. "Read `pubspec.yaml` and one existing feature first" prevents a page of wrong code.
2. **Steps, not essays.** Numbered steps with the exact commands. A checklist beats a paragraph.
3. **One good template beats three variants.** Show the canonical code once; list the differences for other stacks in a table.
4. **Put the hard rules where they bite.** "Never run X without a backup" goes in the step where X happens, not in an intro nobody rereads.
5. **Define done.** What must be true before Claude says it is finished, and what it must report: what it verified and what a human must still check.
6. **Keep it short.** Aim for under 150 lines. Move rarely needed detail to `references/` and link it from the step that needs it.

## Where rules come from

The best rules are written right after something went wrong. Our habit:

1. Something breaks or a correction repeats ("I said only this element", "this field is called `refId` now").
2. Fix it, then write the rule: in the repo's `CLAUDE.md` if it is about this repo, in a skill if it is about a kind of task.
3. Add the rule at the step where the mistake happens, with the reason in one line. Rules with a reason get followed; bare rules get "optimized" away.

## Skill, CLAUDE.md, agent or command?

| Put it in | When |
|---|---|
| `CLAUDE.md` | Facts and rules about this repo that apply to every task: stack, commands, contracts, anti-patterns |
| A skill | A repeatable kind of task with steps, used across repos (scaffold, release, audit) |
| An agent | A focused reviewer or worker that should run with its own context and return a report |
| A command | A workflow you trigger by hand with `/name` (commit, PR, quality check) |

## Test it

1. Install it (`./install.sh --pack <pack> --target <project>` or copy the folder to `.claude/skills/`) and start a new session.
2. Ask in three different ways, including a lazy one. Does it fire? If not, add those words to the description.
3. Ask something close but different. Does it stay quiet? If not, narrow the description.
4. Run the task end to end on a real repo and read what Claude did against the steps. Every place it improvised is a missing step.

## Style rules in this repo

- English body, triggers in English plus Polish where people would type it.
- Plain ASCII punctuation: no long dashes, curly quotes, one-character ellipsis or invisible spaces.
- No secrets, internal hostnames, client names or private paths. Use `<PROJECT>`, `<bucket>`, `$ENV_VAR`.
- Commands must be copy-pasteable and safe by default (dry runs first, destructive steps behind a confirmation).
