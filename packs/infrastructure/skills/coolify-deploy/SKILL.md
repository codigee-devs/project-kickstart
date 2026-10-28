---
name: coolify-deploy
description: Deploy Docker apps on Coolify (or any self-hosted Docker platform) without surprises - know what triggers a deploy per environment, Dockerfile and healthcheck basics, env vars in the platform, deploying and checking status through the API, verifying the deployed commit, timing restarts, and rolling back. Use when shipping to staging or production, setting up a new service, or when "it works locally but not on prod". Triggers - "deploy", "release to production", "set up the app on coolify", "why is prod different", "the deploy failed", "wdroz", "zdeployuj", "puszczamy na proda", "na prodzie nie dziala".
---

# coolify-deploy

Before any production deploy: state the blast radius (service, environment, migrations, clients affected) and get an explicit go-ahead.

## 1. Know what deploys what

Write this table into the workspace `CLAUDE.md` once, and check it before every push:

| Service | Environment | Built from | Trigger |
|---|---|---|---|
| api | staging | `develop` | webhook on push |
| api | production | `main` | manual (API or panel) |
| web | production | `main` | webhook on push |

Consequences:
- If a branch has a webhook, a push IS a deploy. There is no "I will just push and deploy later".
- Webhooks get lost sometimes. After pushing, confirm a deployment actually started.
- "It does not work on prod" starts with: is the fix even on the production branch?
  ```bash
  git fetch && git rev-list --left-right --count origin/main...origin/develop
  ```

## 2. Dockerfile and healthcheck basics

- Multi-stage build, pinned base image version, non-root user, only runtime files in the final stage.
- `.dockerignore` with `.git`, `node_modules`, `.env*`, test output.
- The app reads config from env vars only and listens on `0.0.0.0:$PORT`.
- A cheap health endpoint (`GET /health` -> 200 without touching slow dependencies) and the platform healthcheck pointing at it. Without a healthcheck the platform reports an unknown state and cannot stop a broken container from taking traffic.
- Migrations: run them in a release step or at boot with a lock, never from a developer laptop against production.

## 3. Env vars

- Set them in the platform, per environment. Never bake them into the image or commit them.
- The running container is the source of truth, not docs or memory: `docker exec <container> printenv <NAME>` (on the server) shows what the app really sees.
- Build-time variables (`NEXT_PUBLIC_*`, Flutter web `--dart-define`) need a rebuild, not a restart, to change.
- Changing an env var while a build runs may need a forced redeploy afterwards.

## 4. Deploy and check through the API

Keep the token in your shell env or a password manager, never in the repo.

```bash
# start a deployment
curl -fsS -H "Authorization: Bearer $COOLIFY_TOKEN" \
  "$COOLIFY_URL/api/v1/deploy?uuid=$APP_UUID&force=false"

# running deployments; when yours disappears from the list it has finished
curl -fsS -H "Authorization: Bearer $COOLIFY_TOKEN" "$COOLIFY_URL/api/v1/deployments"

# one deployment: status and the commit it built
curl -fsS -H "Authorization: Bearer $COOLIFY_TOKEN" "$COOLIFY_URL/api/v1/deployments/$DEPLOYMENT_UUID"
```

Check the API reference of your Coolify version for the exact methods; they changed between releases.

## 5. Verify the deployed commit, not the green badge

1. The deployment built the commit you expect (compare with `git rev-parse origin/main`).
2. Expose the build sha in the app (`/health` returns `{ sha }`, or a build-time env shown in the footer of an admin page) and check it.
3. Hit the changed endpoint or page yourself. A 502 for a few seconds right after a deploy is the container swap; a 502 after a minute is a failed start: read the container logs.
4. Report what you checked, and what the user should click through.

## 6. Timing

- A backend restart drops WebSocket connections, in-flight jobs and in-memory state. Deploy realtime services when traffic is low and nothing long-running is active.
- Queue workers: drain or make jobs idempotent before redeploying.

## 7. Rollback

- Redeploy the previous successful deployment or image tag from the platform.
- A rollback does not undo a migration. That is why migrations are expand-only (see `db-migrations`).
- Write down what happened and the fix in the PR or an incident note.

## 8. Data changes on shared environments

Backup first (`backup-first`), apply with that environment's credentials, and record what changed in a `PENDING-DEPLOYS.md` or the PR so the next deploy does not surprise anyone.
