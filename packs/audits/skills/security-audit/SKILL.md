---
name: security-audit
description: Whole-project security audit of an app, API or admin panel (not just a diff) - secrets in the repo and its history, auth and authorization on every route, input validation, data exposure, dependency vulnerabilities, headers and CORS, mobile app storage and transport, infrastructure basics - with findings graded by severity and fixes in priority order. Use before a launch, after taking over a codebase, or on a schedule. Triggers - "security audit", "audit the security", "is this app secure", "pentest checklist", "audyt bezpieczenstwa", "czy aplikacja jest bezpieczna", "sprawdz bezpieczenstwo".
---

# security-audit

Read-only. You report and propose; fixes are separate requests. Never print a secret you find: refer to it as `path:line` (or commit sha) and its type.

## 1. Scope and inventory

List the repos, the deployable services, the public URLs and the data that matters (personal data, payments, health, children, location). State what is in scope and what you could not reach.

## 2. Secrets

```bash
git ls-files | grep -iE '\.env($|\.)|\.pem$|\.p8$|\.p12$|\.key$|\.jks$|\.keystore$|service-account|credentials'
git log --all --diff-filter=A --name-only --format='' | grep -iE '\.env($|\.)|\.pem$|\.p8$|\.key$' | sort -u
```

Run a scanner over the full history if available (`gitleaks detect`, `trufflehog git file://.`). Any real secret ever committed: rotate, then remove.

## 3. Auth and authorization (the biggest category in practice)

- Make a route table: method, path, guard, role or permission, ownership check. Build it by reading the router, not the docs.
- Every route without a guard is either intentionally public (justify it) or a finding.
- Identity from the session only. Test: can user A read or change user B's resource by changing an id? (IDOR)
- Admin routes check the role on the server. Disabled or deleted accounts are refused.
- Sessions: httpOnly, Secure, SameSite cookies or short-lived tokens with refresh; logout invalidates; password reset and OTP are single-use, expire, and are rate-limited.
- Webhooks verify signatures.

## 4. Input and output

- Validation schema on every body, query and path param; max sizes on strings, arrays, uploads, page sizes.
- No raw SQL with interpolation, no shell commands with user input, no path joins with user input.
- Responses select fields explicitly. Look for password hashes, tokens, internal flags, other users' emails.
- Errors: generic messages, no stack traces in production.
- Rich text or HTML from users is sanitized on output.

## 5. Dependencies

```bash
npm audit --omit=dev     # or: pnpm audit --prod / bun pm audit
pip-audit                # Python
flutter pub outdated     # Flutter: then check advisories for the outdated ones
```

Report high and critical issues that are reachable in production code, with the fixed version.

## 6. Web and API surface

```bash
curl -sI https://<site> | grep -iE 'strict-transport|content-security|x-frame|x-content-type|referrer-policy|permissions-policy'
curl -sI -H "Origin: https://evil.example" https://<api>/<route> | grep -i access-control
```

- HTTPS only with HSTS, a CSP that fits the app, frame protection, no wildcard CORS with credentials.
- Rate limits on auth, OTP, password reset, contact forms and anything that spends money (LLM, SMS, email).
- Non-production environments are not indexed and not open to everyone with production data.

## 7. Mobile apps

- Tokens in secure storage (Keychain / Keystore via `flutter_secure_storage` or equivalent), not in shared preferences.
- No secrets compiled into the app: anything in the binary is public. API keys in the app are restricted by bundle id or proxied.
- TLS only; certificate pinning only if you can rotate it safely.
- Logs in release builds contain no personal data or tokens.
- Deep links validate their parameters and do not perform actions without confirmation.

## 8. Infrastructure

- Databases and object storage not reachable from the internet except through the app; buckets not listable.
- Backups exist, are encrypted, and a restore has been tested.
- Least-privilege credentials per service. Admin panels of the hosting platform behind strong auth.

## 9. Report

Severity: Critical (exploitable now, data at risk), High, Medium, Low, Info. Per finding: where, what, impact, how to reproduce (safely), fix, effort. End with the top five fixes in order. For a shareable document, render it with `app-audit-report`.
