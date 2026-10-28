---
name: flutter-test
description: Write Flutter and Dart tests in Arrange-Act-Assert style - bloc_test for Cubits (initial, success, failure, edge cases, no emit after close), mocktail for repositories and data sources, widget tests by semantics. Use after implementing Dart logic or when asked for tests. Triggers - "write tests", "add tests", "cover this cubit with tests", "test this repository", "napisz testy", "dodaj testy", "pokryj testami", "testy do tego cubita".
---

# flutter-test

## 1. Read first

- `pubspec.yaml`: `bloc_test`, `mocktail` (or `mockito`), freezed major, the error type (`Result`/`Failure` or `Either`).
- The unit under test and one existing test file. Copy its style, helpers and fixtures.
- If the unit uses generated code, run `dart run build_runner build --delete-conflicting-outputs` first.

## 2. Where the file goes

Mirror the path: `lib/features/tasks/presentation/cubit/tasks_cubit.dart` -> `test/features/tasks/presentation/cubit/tasks_cubit_test.dart`.

## 3. What to cover

For a Cubit:

| Case | Assert |
|---|---|
| Initial state | `cubit.state` equals the documented initial state |
| Success | `[loading, loaded(items)]`, repository called once with the right args |
| Failure | `[loading, error(failure)]` |
| Edge | empty list, null or blank input, second call while the first runs, pagination end |
| Closed mid-request | after `close()`, nothing more is emitted (guards the `isClosed` check) |

For a repository: the data source returns data -> success with mapped entities; throws `DioException` (or the HTTP error type) -> the matching `Failure`; malformed JSON -> failure, not a crash. This mapping is the whole job of the repository, so pin it down.

For a widget: pump it with a mocked Cubit (`MockCubit` from `bloc_test`), find by text from the localizations or by `find.bySemanticsLabel`, tap, verify the Cubit call. No real network.

## 4. Skeleton

```dart
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTasksRepository extends Mock implements TasksRepository {}

void main() {
  late MockTasksRepository repository;

  setUp(() {
    repository = MockTasksRepository();
  });

  group('TasksCubit.load', () {
    const task = Task(id: 'task-1', title: 'Water the plants');

    test('starts in initial state', () {
      expect(TasksCubit(repository).state, const TasksState.initial());
    });

    blocTest<TasksCubit, TasksState>(
      'emits loading then loaded when the repository succeeds',
      setUp: () => when(() => repository.getAll())
          .thenAnswer((_) async => const Result.success([task])),
      build: () => TasksCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => const [TasksState.loading(), TasksState.loaded([task])],
      verify: (_) => verify(() => repository.getAll()).called(1),
    );

    blocTest<TasksCubit, TasksState>(
      'emits loading then error when the repository fails',
      setUp: () => when(() => repository.getAll())
          .thenAnswer((_) async => const Result.failure(ServerFailure())),
      build: () => TasksCubit(repository),
      act: (cubit) => cubit.load(),
      expect: () => const [TasksState.loading(), TasksState.error(ServerFailure())],
    );

    blocTest<TasksCubit, TasksState>(
      'emits nothing after close while the request is still running',
      setUp: () => when(() => repository.getAll()).thenAnswer((_) async {
        await Future<void>.delayed(Duration.zero);
        return const Result.success([task]);
      }),
      build: () => TasksCubit(repository),
      act: (cubit) async {
        final pending = cubit.load();
        await cubit.close();
        await pending;
      },
      expect: () => const [TasksState.loading()],
    );
  });
}
```

For `fpdart`, swap `Result.success/failure` for `Right(...)` / `Left(...)`. For custom argument types used with `any()`, call `registerFallbackValue(...)` in `setUpAll`.

## 5. Rules

- One behavior per test, name it as a sentence.
- No shared mutable state between tests. Fresh mocks in `setUp`.
- No network, real database, real clock or platform channels in unit tests. Inject a clock if time matters.
- Fixtures use placeholder ids and tokens, never real ones.
- Do not change production code to make it testable without asking. If it cannot be tested as is, say why and propose the smallest seam.

## 6. Run and report

```bash
flutter test test/features/<feature>/
flutter analyze test/
```

Iterate to green. Report the cases covered and the exact command output summary (passed / failed). Never report coverage you did not run.
