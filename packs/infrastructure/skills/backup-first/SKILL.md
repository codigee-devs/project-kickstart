---
name: backup-first
description: Make and verify a backup before any destructive operation - PostgreSQL dumps and restores, S3 or MinIO bucket mirrors, git repo bundles - and get an explicit confirmation before running the destructive step. Use before reset, seed, truncate, drop, re-migrate, bulk delete, bucket cleanup, re-keying objects, or rewriting git history. Triggers - "reset the database", "wipe the data", "delete these files from the bucket", "rewrite git history", "force push", "clean up old data", "zresetuj baze", "wyczysc dane", "usun z bucketa", "wyczysc historie gita".
---

# backup-first

Every irreversible operation follows the same four steps. No exceptions for "it is only local" when the data is real (test accounts, uploaded content, someone's afternoon of work).

1. **Say what will be destroyed**: which database, bucket or branch, how many rows or objects, which environment.
2. **Back up** to a timestamped file outside the thing being changed.
3. **Verify the backup** (size, list, test restore).
4. **Ask for an explicit yes**, quoting the backup path. Then run the destructive step, and only that step.

## PostgreSQL

```bash
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p backups
pg_dump --format=custom --no-owner --file "backups/<db>-$STAMP.dump" "$DATABASE_URL"

# verify: lists the tables and data in the dump
pg_restore --list "backups/<db>-$STAMP.dump" | head -30
ls -lh "backups/<db>-$STAMP.dump"
```

Single table before a risky update:

```bash
pg_dump --format=custom --table=public.<table> --file "backups/<table>-$STAMP.dump" "$DATABASE_URL"
```

Restore (into a scratch database first, to prove it works):

```bash
createdb <db>_restore_check
pg_restore --no-owner --dbname "<scratch-db-url>" "backups/<db>-$STAMP.dump"
```

Database in a container: `docker exec <container> pg_dump -U <user> -Fc <db> > backups/<db>-$STAMP.dump`.

## S3 / MinIO buckets

```bash
# MinIO client
mc alias set src "$S3_ENDPOINT" "$S3_ACCESS_KEY" "$S3_SECRET_KEY"
mc mirror --preserve src/<bucket>/<prefix> "backups/<bucket>-$STAMP/"
mc ls --recursive src/<bucket>/<prefix> | wc -l     # compare with:
find "backups/<bucket>-$STAMP" -type f | wc -l

# AWS CLI against any S3-compatible endpoint
aws s3 sync "s3://<bucket>/<prefix>" "backups/<bucket>-$STAMP/" --endpoint-url "$S3_ENDPOINT"
```

Before deleting or renaming objects, check that nothing still links to them: grep the code, content files and the database for the keys.

## Git

```bash
git bundle create "backups/<repo>-$STAMP.bundle" --all
git bundle verify "backups/<repo>-$STAMP.bundle"
```

Also note the current sha of every branch you will rewrite (`git rev-parse <branch>`), so it can be restored with `git branch -f`.

## Rules

- Backups go in a gitignored folder or outside the repo. Never commit a dump: it is full of personal data and secrets.
- Delete old local dumps when they are no longer needed; they are a liability.
- Never chain the backup and the destructive step in one command without the confirmation in between.
- If any step of the backup fails, stop. A failed backup is a no-go, not a warning.
- After the operation, report: what was destroyed, the backup path, how to restore.
