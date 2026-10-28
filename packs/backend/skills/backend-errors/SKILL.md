---
name: backend-errors
description: Set up or apply one error-handling pattern in a TypeScript backend - a typed error factory, a global handler that maps error types to HTTP status and stable error codes, structured logs with request context, and safe client messages. Use when adding error handling, when errors leak stack traces or swallow failures, or when a client needs to branch on an error. Triggers - "error handling", "typed errors", "500 instead of 404", "the API returns a stack trace", "obsluga bledow", "zwraca 500", "dodaj kody bledow".
---

# backend-errors

One way to fail, everywhere: services throw typed errors, one handler turns them into responses, logs keep the details.

## 1. The factory (`src/utils/errors.ts`)

```ts
export const ERROR_STATUS = {
  VALIDATION: 422,
  UNAUTHORIZED: 401,
  FORBIDDEN: 403,
  NOT_FOUND: 404,
  CONFLICT: 409,
  RATE_LIMITED: 429,
  INTERNAL: 500,
} as const;

export type ErrorType = keyof typeof ERROR_STATUS;

export class AppError extends Error {
  constructor(
    readonly type: ErrorType,
    message: string,
    readonly code?: string,
    readonly details?: Record<string, unknown>,
  ) {
    super(message);
    this.name = "AppError";
  }
}

export const buildError = (
  type: ErrorType,
  message: string,
  code?: string,
  details?: Record<string, unknown>,
) => new AppError(type, message, code, details);
```

`code` is a stable machine-readable string the client may branch on (`ACCOUNT_PENDING_DELETION`, `EMAIL_TAKEN`). Once a client uses it, it is part of the API contract.

## 2. Throw in services only

```ts
if (!note) throw buildError("NOT_FOUND", "Note not found");
if (existing) throw buildError("CONFLICT", "Email already in use", "EMAIL_TAKEN");
```

- Routes and controllers never `try/catch`. They let errors reach the handler.
- Catch only where you can add meaning (wrap a provider error into `AppError` with a code) or recover. Never `catch {}` and continue silently.

## 3. One global handler

Elysia:

```ts
app.onError(({ error, code, set, request }) => {
  if (error instanceof AppError) {
    set.status = ERROR_STATUS[error.type];
    if (set.status >= 500) logger.error({ err: error, path: new URL(request.url).pathname }, error.message);
    return { error: { type: error.type, code: error.code ?? error.type, message: error.message, ...error.details } };
  }
  if (code === "VALIDATION") {
    set.status = 422;
    return { error: { type: "VALIDATION", code: "VALIDATION", message: "Invalid request" } };
  }
  logger.error({ err: error, path: new URL(request.url).pathname }, "Unhandled error");
  set.status = 500;
  return { error: { type: "INTERNAL", code: "INTERNAL", message: "Something went wrong" } };
});
```

Express: the same mapping in a final `(err, req, res, next)` middleware, and wrap async handlers so rejections reach it.

## 4. Response rules

- Shape is the same for every error: `{ error: { type, code, message, ...details } }`. Clients parse one shape.
- 4xx messages are short and safe to show. 5xx messages are always generic.
- Never send stack traces, SQL, file paths, provider responses or internal ids in a response.
- Validation errors may list the failing field names, not the rejected values when those could be sensitive.

## 5. Logging

- Use the project logger with levels. No `console.log`.
- Log 5xx at `error` with the error object, route, user id (not email) and a request id. Log expected 4xx at `info` or not at all; they are not incidents.
- Never log tokens, passwords, OTP codes, full card or ID numbers, or request bodies of auth routes.

## 6. Clients

- Mobile maps `code` values to typed failures (`EmailTakenFailure`), with a fallback for unknown codes.
- Admin and web show `message` for 4xx and a generic text for 5xx.

## 7. Check it

Tests per route: one per error type the route can return, asserting status and `code`. Then grep for leaks:

```bash
grep -rn "console\.\(log\|error\)" src/ | grep -v test
grep -rn "catch *(.*) *{ *}" src/
```
