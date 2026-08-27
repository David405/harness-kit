---
name: code-quality-gate
description: >-
  Runs the per-diff code quality gate at VERIFY for service, http-api and
  solidity-build work: runs the repo's declared linter, checks complexity, length,
  coupling, magic values, duplication, dead code and error handling on the changed
  code, and blocks PENDING_REVIEW on violations. Use before setting PENDING_REVIEW,
  or when the user asks to check code quality on a change or diff.
---

# Code quality gate

> Kit-owned. Edit in the harness-kit repo, not in the consumer repo.

**Deterministic-first.** The linter declared in `AGENTS.md` is run and its result recorded.
Model judgement is the documented fallback, not the default. The kit ships no thresholds.

## When to use

At VERIFY, on the diff, for `service` / `http-api` / `solidity-build`.

## When not to use

**N/A** for `ops-docs`, `code-audit` and `solidity-audit` — those judge a target's code as
findings rather than their own diff. For a periodic whole-subsystem assessment use `code-audit`;
this gate only ever looks at the diff.

## Rules that matter

- **You own what you touch.** New code is judged fresh. A pre-existing breach the diff did not
  worsen is noted once as debt and does not block.
- A `violation` (hard limit, no documented exception) blocks `PENDING_REVIEW`. `warn` never blocks.
- Credentials are **not** this gate's rule — raise them under `security-checklist` and do not double-report.
- `PASS` remains human-only.

## Form

`templates/CODE_QUALITY.md`
