---
name: multi-repo-git
description: Pull, switch branches, commit and push across every git repo in a workspace folder (backend, admin, mobile, website as siblings) with a status table at the end - discovers repos instead of hardcoding them, never touches dirty trees blindly, stages by path, guards secrets, and stops for confirmation before pushing or merging to production branches. Triggers - "pull all repos", "switch everything to develop", "commit and push everywhere", "sync the workspace", "zrob pulla na wszystkich repo", "przelacz wszystko na develop", "commit i push na kazdym repo", "zsynchronizuj repo".
---

# multi-repo-git

A product often lives in several sibling repos. One request ("pull everything", "push everything") means every repo, each scoped on its own. Never run a blanket git command from the parent folder.

## 1. Discover and restate

```bash
for d in "$PWD"/*/; do [ -e "$d/.git" ] && echo "${d%/}"; done   # -e: worktrees have a .git file
```

Include the current folder if it is itself a repo. Then say in one line which repos and branches you are about to touch, before acting.

## 2. Status of each repo

```bash
for r in <repos>; do
  git -C "$r" fetch --prune --quiet
  branch="$(git -C "$r" branch --show-current)"
  dirty="$(git -C "$r" status --porcelain | wc -l | tr -d ' ')"
  counts="$(git -C "$r" rev-list --left-right --count '@{u}...HEAD' 2>/dev/null || echo 'no upstream')"
  printf '%s\t%s\tdirty=%s\tbehind/ahead=%s\n' "$(basename "$r")" "$branch" "$dirty" "$counts"
done
```

## 3. Pull

- Clean repo with an upstream: `git -C "$r" pull --ff-only`. If it is not a fast-forward, stop for that repo and report; never merge or rebase silently.
- Dirty repo: skip it and mark it "dirty, skipped". Only if the user says so: `git -C "$r" stash push -u -m "sync autostash"`, pull, `git -C "$r" stash pop`, and report the stash if pop conflicts. Never discard changes.

## 4. Switch branch

- Confirm the target exists per repo: `git -C "$r" rev-parse --verify --quiet "refs/remotes/origin/<branch>"`. Repos differ: one may use `master` for production where others use `main`. Do not assume.
- Dirty repos: skip, same rule as above.
- `git -C "$r" switch <branch>` then `pull --ff-only`.

## 5. Commit and push

Per repo with changes:

1. `git -C "$r" status --short`, then the secret guard:
   ```bash
   git -C "$r" status --porcelain -z | tr '\0' '\n' | cut -c4- \
     | grep -iE '(^|/)\.env($|\.)|\.pem$|\.p8$|\.p12$|\.key$|\.jks$|\.keystore$|service-account.*\.json|credentials.*\.json'
   ```
   Matches are never staged; warn about them.
2. Stage by path (`git -C "$r" add <files>`). In a shared working tree, check that every hunk is yours (`git -C "$r" diff --staged`).
3. Conventional Commit written from that repo's staged diff, in that repo's commit style. Use a heredoc (`git -C "$r" commit -F - <<'EOF'`).
4. Push the current feature branch (`git -C "$r" push`, or `push -u origin <branch>` without upstream). A rejected push is reported, never forced.

## 6. Production branches and merges

Pushing to `main`, `master`, `production` or `release/*`, and any merge, needs an explicit yes per repo. Before asking, give the blast radius: repo, branch, what deploys from it (see `coolify-deploy`), which clients are affected, migrations included. Two different repos are two confirmations.

## 7. Report

| Repo | Branch | Result | Commit | Pushed |
|---|---|---|---|---|
| api | feature/notes | committed | `feat(notes): add pinned flag` | yes |
| admin | develop | pulled 3 commits | - | - |
| mobile | develop | dirty, skipped | - | - |
| website | main | waiting for confirmation | `fix(seo): canonical on blog` | no |

Say what was done and what is waiting for the user. A status question ("pushed?") is answered from this table, without re-running anything.

## Workspace bootstrap

A small workspace repo that holds only `CLAUDE.md`, `.claude/`, an editor workspace file and a `bootstrap.sh` that clones the sibling repos (skipping existing ones, pulling them fast-forward) makes a new machine or a new teammate ready in one command. Keep the sibling repos in its `.gitignore`.
