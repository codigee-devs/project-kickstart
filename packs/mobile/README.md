# mobile

Flutter apps in Clean Architecture with Cubit, from the first feature to the store.

| Skill | Use it when |
|---|---|
| `flutter-feature` | You add a new screen or module. Scaffolds domain, data and presentation, with the stack choices (freezed major, Result or Either, router, DI) read from the repo first. |
| `flutter-test` | You need tests for a Cubit, repository or widget. AAA, `bloc_test`, `mocktail`, failure paths and the "no emit after close" case. |
| `flutter-release` | You bump a version, build a flavor, upload to TestFlight or Play, or prepare store review (demo account, notes). |
| `device-verify` | Before you say a UI change is done, and whenever the user says it still does not work. Restart first, record animations, batch logs for device-only bugs. |

## Conventions these skills assume

- `lib/features/<name>/{domain,data,presentation}`, Cubit + freezed state, `get_it` + `injectable`, ARB localization, theme tokens instead of hardcoded styles.
- `try/catch` only in repositories. Every post-`await` emit guarded with `if (isClosed) return;`.
- The repo's `CLAUDE.md` wins. Each skill reads the manifest and an existing feature before writing.

## Where it comes from

Mobile apps we built and maintain: a museum guide app with two flavors and many UI languages, a household planner, a field sales app that works offline all day, and apps that host Unity inside Flutter. The rules here are the ones that cost us a rebuild or a review cycle when we skipped them.
