# infrastructure

Shipping and keeping things safe: self-hosted Docker deploys, secrets, backups, object storage and multi-repo git.

| Skill | Use it when |
|---|---|
| `coolify-deploy` | You deploy to staging or production on Coolify or a similar Docker platform, set up a service, or debug "works locally, not on prod". |
| `env-secrets` | You add an env var, set up a repo, commit, or a key shows up in text. |
| `backup-first` | Anything irreversible is about to happen: reset, seed, drop, bulk delete, bucket cleanup, history rewrite. |
| `object-storage` | You store media in MinIO, S3 or R2, wire uploads, or move big files out of git. |
| `multi-repo-git` | One product lives in several sibling repos and you pull, switch, commit or push across all of them. |

## Rules this pack enforces

- A push to a branch with a deploy webhook is a deploy. Know which branches those are.
- The running container is the source of truth for configuration.
- No destructive step without a verified backup and an explicit yes.
- Secrets never land in git, logs, reports or chat output.
- Production pushes and merges always wait for a person.

## Where it comes from

Running our products on self-hosted Coolify with Docker, PostgreSQL and MinIO, across workspaces of four to eight sibling repos. One local database reset that wiped real test data is why `backup-first` exists.
