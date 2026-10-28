---
name: flutter-feature
description: Scaffold a Flutter feature in Clean Architecture - freezed entity, repository interface and implementation, data source, Cubit with freezed state, DI registration, and a page that uses theme tokens and ARB strings. Use when adding a new screen or module to a Flutter app. Triggers - "new flutter feature", "scaffold feature", "create module with cubit", "add a screen with a cubit", "nowy feature flutter", "dodaj feature", "stworz modul", "zescaffolduj feature".
---

# flutter-feature

Creates `lib/features/<name>/` with domain, data and presentation layers. The project's `CLAUDE.md` wins over every default below.

Not for small UI tweaks on an existing screen. Those are minimal edits to one widget.

## 1. Detect the stack before writing a line

Read `pubspec.yaml`, `analysis_options.yaml`, `CLAUDE.md` and one existing feature folder. Decide on these axes and copy what the existing feature does:

| Axis | Common options | Why it matters |
|---|---|---|
| freezed major | 2.x or 3.x | v3 needs `abstract class` / `sealed class` with the mixin; v2 code does not compile on v3 and back |
| Error type | own `Result<T>` + `Failure`, or `fpdart` `Either<Failure, T>` | repository signatures and Cubit code differ |
| Navigation | `go_router` or `auto_route` | how the page is registered |
| HTTP | `dio` + `retrofit`, or plain `dio` | data source shape |
| DI | `injectable` + `get_it`, or manual `get_it` | annotations vs registration code |

If there is no existing feature and the manifest does not decide it, ask one question. Do not emit code that will not compile.

Check that `lib/features/<name>/` does not exist. If it does, stop and ask.

## 2. Folders

```bash
mkdir -p lib/features/<name>/domain/{entities,repositories}
mkdir -p lib/features/<name>/data/{models,datasources,repositories}
mkdir -p lib/features/<name>/presentation/{cubit,pages,widgets}
```

Add `domain/usecases/` only if the project uses use cases. Many Cubit-based apps call repositories directly; follow the existing features.

## 3. Domain

`domain/entities/<name>.dart` (freezed 3 shown; for 2.x drop `abstract`):

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part '<name>.freezed.dart';

@freezed
abstract class <Name> with _$<Name> {
  const factory <Name>({required String id, required String title}) = _<Name>;
}
```

`domain/repositories/<name>_repository.dart`:

```dart
abstract interface class <Name>Repository {
  Future<Result<List<<Name>>>> getAll();
}
```

## 4. Data

- `data/models/<name>_model.dart`: freezed + `json_serializable`, with `toEntity()`. Field names and enum values copied from the backend's schema or API docs, never guessed. Unknown enum values map to a fallback (`@JsonKey(unknownEnumValue: ...)`) so a newer backend does not crash an older app.
- `data/datasources/<name>_remote_data_source.dart`: the HTTP call (retrofit `@RestApi` or a `dio` class).
- `data/repositories/<name>_repository_impl.dart`: the only place with `try/catch`.

```dart
@LazySingleton(as: <Name>Repository)
class <Name>RepositoryImpl implements <Name>Repository {
  const <Name>RepositoryImpl(this._remote);
  final <Name>RemoteDataSource _remote;

  @override
  Future<Result<List<<Name>>>> getAll() async {
    try {
      final models = await _remote.getAll();
      return Result.success(models.map((m) => m.toEntity()).toList());
    } on Exception catch (error, stackTrace) {
      return Result.failure(Failure.fromException(error, stackTrace));
    }
  }
}
```

## 5. Presentation

State, one variant per screen state:

```dart
@freezed
sealed class <Name>State with _$<Name>State {
  const factory <Name>State.initial() = <Name>Initial;
  const factory <Name>State.loading() = <Name>Loading;
  const factory <Name>State.loaded(List<<Name>> items) = <Name>Loaded;
  const factory <Name>State.error(Failure failure) = <Name>Error;
}
```

Cubit. The `isClosed` check after every `await` is mandatory: the user can leave the screen while the request runs, and emitting on a closed Cubit throws.

```dart
@injectable
class <Name>Cubit extends Cubit<<Name>State> {
  <Name>Cubit(this._repository) : super(const <Name>State.initial());
  final <Name>Repository _repository;

  Future<void> load() async {
    emit(const <Name>State.loading());
    final result = await _repository.getAll();
    if (isClosed) return;
    result.when(
      success: (items) => emit(<Name>State.loaded(items)),
      failure: (failure) => emit(<Name>State.error(failure)),
    );
  }
}
```

Page rules:
- Colors, text styles, spacing and radii come from the theme or token classes the app already has. No `Color(0xFF...)`, no inline `TextStyle`, no `EdgeInsets.all(16)`.
- Every visible string comes from `AppLocalizations` (ARB). Add the keys to every locale file in the same change.
- Tappable widgets get `Semantics` (label, button: true) unless the widget already provides it.
- Reuse the app's existing buttons, app bars, empty and error views. Search `lib/core/` and `lib/shared/` first.
- Layout must not shift when something is pressed or selected: reserve the space.

## 6. Generate and check

```bash
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n        # if l10n is not generated by the build
flutter analyze
```

Never hand-edit `*.g.dart`, `*.freezed.dart` or `*.config.dart`.

## 7. Wire it and report

Tell the user what is left that codegen cannot infer: the route entry, a DI module if the project registers some by hand, ARB keys in every locale, and the backend endpoint if it does not exist yet.

Report "analyzer clean, codegen OK" as what you verified, and ask the user to open the screen on a device or simulator (or use `device-verify`). Then offer tests with `flutter-test`.
