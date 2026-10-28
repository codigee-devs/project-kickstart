---
name: flutter-release
description: Ship a Flutter build to TestFlight and Google Play safely - version bump, flavor and env per build, release scripts, store metadata, review notes and demo account, and the backward-compatibility check for app versions already in the field. Use when preparing a release or adding release scripts to a repo. Triggers - "release the app", "bump version", "build for testflight", "upload to the store", "prepare store release", "wydaj apke", "podbij wersje", "zbuduj na testflight", "wrzuc do sklepu".
---

# flutter-release

A release is a one-way door: users keep old builds for weeks, and the store review sees exactly what you upload. This skill makes it boring.

## 1. Use the repo's scripts

Look in `scripts/` first (`version_manager.sh`, `build_release.sh`, `upload_ios.sh` or similar). If they exist, use them and do not improvise commands. If they do not, offer to add them with the templates below, copied from the repo's real flavor and env setup.

## 2. Pre-flight checklist

- [ ] On the right branch and in sync: `git status` clean, `git fetch && git status -sb` not behind.
- [ ] Backend contract: every endpoint and field this build calls is already deployed to the target environment. A build that needs an unreleased backend fails review.
- [ ] Old builds keep working: no backend change in this release removes or renames something the current store version reads. If one must, ship the app first, wait for adoption, then change the backend.
- [ ] `flutter analyze` clean, `flutter test` green.
- [ ] Every flavor updated: permissions, `Info.plist` per flavor, Android manifest placeholders, icons, display name.
- [ ] Permission usage strings explain the user benefit (store review rejects vague ones).
- [ ] Env file for the target exists (`env/.env.<staging|production>` or `--dart-define-from-file`), and it is gitignored.
- [ ] Version bumped: `X.Y.Z+BUILD`, build number strictly higher than anything uploaded before.

## 3. Version bump

`pubspec.yaml` holds `version: X.Y.Z+BUILD`. Every upload needs a new BUILD; a re-upload of the same X.Y.Z bumps only BUILD.

```bash
./scripts/version_manager.sh show
./scripts/version_manager.sh bump patch   # 1.4.2+57 -> 1.4.3+58
./scripts/version_manager.sh bump build   # 1.4.3+58 -> 1.4.3+59
```

Minimal script, if the repo has none:

```bash
#!/usr/bin/env bash
set -euo pipefail
PUBSPEC="$(cd "$(dirname "$0")/.." && pwd)/pubspec.yaml"
current="$(grep '^version:' "$PUBSPEC" | sed 's/version: *//' | tr -d '[:space:]')"
semver="${current%%+*}"; build="${current##*+}"
IFS='.' read -r major minor patch <<< "$semver"
case "${1:-}" in
  major) major=$((major + 1)); minor=0; patch=0 ;;
  minor) minor=$((minor + 1)); patch=0 ;;
  patch) patch=$((patch + 1)) ;;
  build) ;;
  *) echo "usage: $0 <major|minor|patch|build>" >&2; exit 1 ;;
esac
next="$major.$minor.$patch+$((build + 1))"
sed -i.bak "s/^version: .*/version: $next/" "$PUBSPEC" && rm -f "$PUBSPEC.bak"
echo "$current -> $next"
```

## 4. Build

```bash
flutter build ipa --release --flavor <env> --dart-define-from-file=env/.env.<env>
flutter build appbundle --release --flavor <env> --dart-define-from-file=env/.env.<env>
```

A `build_release.sh <staging|production> <ios|android|all> [--upload]` wrapper that validates the env name, checks the env file exists and prints flavor, version and platform before building saves the classic mistake: a production build with staging config.

## 5. Upload

- iOS: `xcrun altool --upload-app` or Transporter, authenticated with an App Store Connect API key. The key file and its ids live outside the repo (an env var pointing to a path in your home folder), never committed.
- Android: upload the `.aab` in Play Console, or with a service account through the Play Developer API. Internal testing track first.

## 6. Store review

- Demo account: reviewers must reach every screen. Give them a fixed account that works in production, with a code path for OTP or magic-link sign-in that does not depend on a real inbox. Seed it with realistic data and rebuild it on a schedule so a reviewer never finds it empty or broken. Write the account details only in the review notes field, not in the repo.
- Review notes: how to reach the main features in three steps, which hardware or region features need explaining.
- Screenshots and descriptions match the build (no feature in screenshots that is behind a flag).

## 7. After upload

Report: version, build number, flavor, platforms, where it was uploaded, and what is still manual (submit for review, release notes, phased rollout). Then tag the commit if the team does that: `git tag v<X.Y.Z>+<BUILD>` (push the tag only with a yes).
