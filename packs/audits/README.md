# audits

Gates and audits that catch problems before users do. All of them are read-only: they report, they do not fix.

| Skill | Use it when |
|---|---|
| `review-gate` | Before a merge or a production push. Regressions and backward compatibility first, then security, clean code, scalability, tests, and a merge verdict. |
| `security-audit` | Before a launch, after taking over a codebase, or on a schedule. Secrets, a route-by-route auth table, input and output, dependencies, headers, mobile storage, infrastructure. |
| `seo-audit` | Before or after a launch, migration or redesign, or when traffic drops. Crawl, index, on-page, structured data, performance, content, AI-answer visibility. |
| `app-audit-report` | Someone needs the state of an app in one document. Inventory, scorecard, findings with evidence, phased plan, rendered as one self-contained HTML file (template included). |

## How we use them

- `review-gate` runs on every change that goes to production, often twice on big ones. The second pass catches what the first one talked itself out of.
- Findings need evidence: `path:line`, a command and its output, or a screenshot.
- Every report says what was not checked.
- Secrets found during an audit are referred to by location, never printed.

## Where it comes from

Pre-release reviews on our own products, code audits when we take over apps from other teams, and SEO audits of our company site.
