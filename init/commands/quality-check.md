---
description: Run the full local pipeline (format, lint, types, tests, build) and stop on the first failure
---

Run the project's quality pipeline. Take the exact commands from `CLAUDE.md` ("Development Commands"). If `CLAUDE.md` has none, detect the stack and use these defaults:

| Stack | Format / lint | Types | Tests | Build |
|---|---|---|---|---|
| Flutter | `dart format --set-exit-if-changed .` then `flutter analyze` | (analyzer) | `flutter test` | `flutter build apk --debug` only if asked |
| Bun + TS | `bunx biome check .` or `bun run lint` | `bunx tsc --noEmit` or `bun run typecheck` | `bun test` | `bun run build` |
| Node/pnpm + TS | `pnpm lint` | `pnpm typecheck` or `pnpm exec tsc --noEmit` | `pnpm test` | `pnpm build` |
| Next.js | lint script | type check script, else the build | test script | `next build` (often the only real type check) |
| Python | `ruff check . && ruff format --check .` | `mypy .` | `pytest` | `docker build .` if there is a Dockerfile |

Rules:

1. Use the package manager the lockfile says (`bun.lock`/`bun.lockb`, `pnpm-lock.yaml`, `package-lock.json`, `yarn.lock`). Never mix them.
2. If the project uses codegen (Flutter `build_runner`, Prisma, Drizzle, OpenAPI clients), run it first when annotated or schema files changed.
3. Run the steps in order and stop at the first failure. Show the failing output, not a summary of it.
4. Do not fix anything unless the user asks. Do not skip or disable a check to get green.
5. Report:
   ```
   Quality check: <repo>
   [1/4] Lint ....... PASS
   [2/4] Types ...... PASS
   [3/4] Tests ...... FAIL (41 passed, 2 failed)
   [4/4] Build ...... not run
   ```
6. A green pipeline proves the code compiles and the tests pass. It does not prove the screen looks right. Say what still needs a human check.
