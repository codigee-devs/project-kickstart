---
name: object-storage
description: Work with S3-compatible object storage (MinIO, AWS S3, R2) - bucket layout and key naming, public-read objects without public listing, presigned uploads, idempotent upload scripts, cache headers, local vs staging vs production buckets, and safe cleanup. Use when storing media, wiring uploads, moving files out of the repo, or touching a bucket policy. Triggers - "upload to s3", "minio bucket", "store images", "presigned url", "move media out of the repo", "bucket policy", "wrzuc do bucketa", "media w minio", "upload plikow".
---

# object-storage

## Layout

- One bucket per product and environment (`<project>-prod`, `<project>-staging`), or one bucket with environment prefixes. Never let local development write to the production bucket.
- Keys are stable and meaningful: `<entity>/<id>/<purpose>.<ext>` (`artworks/9f2c.../cover.webp`, `case-studies/<slug>/hero.mp4`). Do not encode things that change (titles) in keys.
- Put a content hash or version in the key for files that change (`cover.3f9a1c.webp`). Then they can be cached forever and old links keep working.

## Access

- Default: private bucket. Serve through presigned GET URLs or your API.
- Public media (marketing images, video): allow anonymous `s3:GetObject` on the objects or a prefix, but NOT `s3:ListBucket`. Anyone may fetch a known URL; nobody can enumerate the bucket.

MinIO example (anonymous read on a prefix, no listing):

```bash
mc anonymous set download <alias>/<bucket>/public
mc anonymous get <alias>/<bucket>
curl -sI "$S3_PUBLIC_URL/<bucket>/" | head -1     # expect 403 for the listing
```

- Credentials: one access key per app with access to its bucket only. Never the root key in an app.

## Uploads from clients

- Client asks the API for a presigned PUT URL; the API checks auth, content type and size, and decides the key. The client never chooses the key.
- Short expiry (minutes). After upload, the client tells the API, which verifies the object exists (HEAD) before saving the reference.
- Images: generate resized and WebP or AVIF variants in a job, not on every request.

## Upload scripts (media out of the repo)

Large media (video, high-res images) does not belong in git or LFS. A small script uploads a folder to the bucket:

- Idempotent: skip objects that exist with the same size or hash, so re-running is safe.
- Sets `Content-Type` per extension and `Cache-Control: public, max-age=31536000, immutable` for hashed keys.
- Prints the public URL of each file, and a dry-run mode.
- Reads credentials from env, never from the script.

```bash
aws s3 cp ./media "s3://<bucket>/case-studies/<slug>/" --recursive \
  --endpoint-url "$S3_ENDPOINT" --cache-control "public, max-age=31536000, immutable" --dryrun
```

## Environments

- Local, staging and production use different buckets and credentials. Write in the repo `CLAUDE.md` which bucket each environment uses, so nobody assumes a local upload reached production.
- When a site or app links straight to bucket URLs, the bucket is part of production. Treat its objects as a contract.

## Cleanup

Deleting, renaming or re-keying objects is destructive. Follow `backup-first`: list what will go, grep code, content and database for those keys, mirror them to a backup, then ask. Prefer lifecycle rules for temporary prefixes (`tmp/` expires after 7 days) over manual cleanups.

## Front-end notes

- `next/image` and similar need the bucket host in their allowed remote patterns.
- Video: provide a poster image, `preload="metadata"`, and for alpha video put the HEVC source first for Safari.
