# CLAUDE.md

## Overview

<PROJECT> is a Flutter app for <who> that <does what>. <One more sentence: backend it talks to, platforms, flavors.>

{{WORKING_AGREEMENT}}

## Tech Stack

| Category | Technology | Version |
|---|---|---|
| Framework | Flutter / Dart | <from pubspec.yaml> |
| State | flutter_bloc (Cubit) | <version> |
| DI | get_it + injectable | <version> |
| Models | freezed + json_serializable | <major matters: v2 and v3 APIs differ> |
| Navigation | <go_router / auto_route> | <version> |
| HTTP | <dio + retrofit / dio> | <version> |
| Errors | <Result<T> + Failure / fpdart Either> | |
| i18n | intl + ARB (`lib/l10n/`) | |
| Tests | flutter_test, bloc_test, mocktail | |
| Lint | <very_good_analysis / flutter_lints>, page width <80/120> | |

## Development Commands

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # after any @freezed/@injectable/@RestApi change
flutter gen-l10n                                            # after ARB changes, if not wired into build
flutter analyze                                             # must be clean
flutter test
./scripts/version_manager.sh bump <major|minor|patch|build> # if the release scripts exist
./scripts/build_release.sh <staging|production> <ios|android|all>
```

## Directory Structure

```
lib/
  core/            # theme tokens, DI setup, network, Result/Failure, logger, router
  features/
    <feature>/
      domain/      # entities, repository interfaces, use cases (pure Dart)
      data/        # models, data sources, repository implementations (try/catch lives here)
      presentation/
        cubit/     # Cubit + freezed state
        pages/     # screens
        widgets/   # widgets used only by this feature
  l10n/            # ARB files
test/              # mirrors lib/
```

## Architecture Pattern

Clean Architecture, feature-first. Presentation -> domain -> data. Widgets never call data sources. Cubits call repositories or use cases and emit freezed states.

## Module Structure

One feature = `lib/features/<name>/{domain,data,presentation}`. Scaffold with the `flutter-feature` skill. Tests with the `flutter-test` skill.

## Naming Conventions

- Files `snake_case.dart`, classes `PascalCase`, members `camelCase`, constants `SCREAMING_SNAKE` or `static const`.
- `<Name>Cubit`, `<Name>State`, `<Name>Repository` (interface), `<Name>RepositoryImpl`, `<Name>RemoteDataSource`.
- ARB keys `camelCase`, prefixed by feature: `tasksEmptyTitle`.

## Error Handling

Repositories catch exceptions and return `<Result / Either>` with a typed `Failure`. Cubits never catch. Every post-`await` emit is guarded with `if (isClosed) return;`.

## Anti-patterns

1. Hardcoded `Color(0xFF...)`, inline `TextStyle`, magic `EdgeInsets` or radii. Use the theme tokens.
2. User-facing strings outside ARB.
3. Interactive widgets without `Semantics` or labels.
4. Hand-editing `*.g.dart`, `*.freezed.dart`, `*.config.dart`.
5. `BackdropFilter`/heavy blur on scrolling or animated screens (Android jank).
6. Layout that shifts when a button is pressed or selected.
7. `print()`. Use the logger.

## Best Practices

1. Reuse widgets from `core/` and the feature before writing new ones.
2. Full restart, not hot reload, before saying a UI change does not work.
3. Platform changes (permissions, Info.plist, manifest) go to every flavor.
4. Release only through the scripts in `scripts/`.

## New Feature Checklist

1. Backend contract confirmed (endpoint, fields, enums grepped from the backend).
2. `flutter-feature` scaffold, then wire route and DI.
3. ARB keys in every locale, `Semantics` on interactive widgets.
4. `build_runner`, `flutter analyze`, `flutter test`.
5. Run on a device or simulator. Report what you saw and what the user must confirm.

## Claude Code Integration

| Type | Name | Use |
|---|---|---|
| Agents | architecture-review, code-review, security-review, testing-review | `/review` routes to them |
| Commands | /commit, /pr, /review, /quality-check | |
| Skills | flutter-feature, flutter-test, flutter-release, device-verify | mobile pack |
