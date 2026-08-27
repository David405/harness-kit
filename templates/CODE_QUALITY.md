# CODE QUALITY GATE — <FEATURE>

> Run by the **agent** at VERIFY, before setting `PENDING_REVIEW`.
> Required for `service`, `http-api`, and `solidity-build`. **N/A** for `ops-docs` and `product-erd`.
> `solidity-audit` reviews the target's quality as findings, not its own diff — mark N/A.
>
> This gate is **deterministic-first**: it defers to the linter this repo declares in `AGENTS.md`.
> The kit does not ship thresholds. Depth of craft guidance lives in an optional skill pack.

## 0. Sensor

- [ ] Repo's declared lint / static-analysis command from `AGENTS.md` was **run** on the diff
- [ ] Command and result recorded below (not "looks fine")

```
Command:  <exact command from AGENTS.md, e.g. `bun lint`, `golangci-lint run`, `cargo clippy -- -D warnings`, `solhint 'contracts/**/*.sol'`>
Result:   <pass | N failures — list them>
```

- [ ] If **no** linter is configured: stated explicitly, and findings below are marked as
      **judgement, not enforced config**. A recurring judgement finding becomes a
      follow-up contract to configure the rule.

## 1. Scope of this gate

- [ ] Reviewed the **diff**, not the whole repo (whole-repo sweeps are their own contract)
- [ ] New functions / files judged on their own — no grandfathering
- [ ] Pre-existing breaches the diff did not worsen are noted once as debt, **not** blocking
- [ ] Exempt paths excluded: generated code, migrations, vendored code, fixtures/snapshots

## 2. Limits (thresholds from this repo's linter config)

Mark **Pass / Warn / Violation / N/A**. Where the repo configures a rule, its number wins.

- [ ] Function / method complexity within configured limit
- [ ] Function / method length within configured limit
- [ ] Class / module length within configured limit
- [ ] Parameter count within configured limit
- [ ] Module dependency count / coupling within configured limit
- [ ] Nesting depth within configured limit

## 3. Smells

- [ ] No environment-specific values hardcoded in logic that must work across environments
      (URLs, chain IDs, addresses, timeouts) — read from injected config
- [ ] No unexplained magic numbers / strings used for their meaning
- [ ] No non-trivial logic duplicated 3+ times
- [ ] No boolean flag parameters that silently switch behaviour
- [ ] No swallowed errors (empty catch, or log-and-continue where the caller must know)
- [ ] No dead code introduced (commented-out blocks, unreachable branches, unused exports)
- [ ] Names state what the value is, not its type
- [ ] No new mutable module-level shared state

## 4. Test code

- [ ] Tests contain no conditionals or loops driving assertions
- [ ] One behaviour per test; the test name states the behaviour
- [ ] No `sleep` / arbitrary timeout used to sequence async work
- [ ] Tests are exempt from length / duplication limits — do **not** file findings for those

## 5. Boundary with other gates (do not double-report)

| Concern | Owned by | Action here |
|---------|----------|-------------|
| Secrets, keys, tokens, credentials in code/fixtures/logs | `SECURITY_CHECKLIST.md` → *Secrets & configuration* | Raise as a **security** finding; do not file as code quality |
| Error handling that leaks data to clients | `SECURITY_CHECKLIST.md` → *Error handling & data leakage* | Security finding |
| Architecture / boundary violations | `REVIEW.md` §3, and only if `AGENTS.md` declares a pattern | Review finding |
| Whole-repo accumulated bloat | Its own contract | Out of scope |

- [ ] No finding in this gate duplicates one already raised under the checklist above

## 6. Documented exceptions

A hard-limit breach may ship only with an in-code exception comment naming **the rule, the
measured value, and the reason**. An exception without all three is a violation.

- [ ] Every hard-limit breach in the diff has a conforming exception comment, or is fixed
- [ ] Exceptions added this sprint are listed here:

| Location | Rule | Measured | Reason |
|----------|------|----------|--------|
|          |      |          |        |

## Findings

| Location | Rule | Value | Verdict | Fix |
|----------|------|-------|---------|-----|
|          |      |       |         |     |

Verdicts: `pass` · `warn` (over warn, under hard — never blocks) · `violation` (over hard,
no documented exception — **blocks**) · `pre-existing` (untouched by this diff — does not block).

## Verdict

- **Status:** READY FOR PENDING_REVIEW / FIX REQUIRED
- **Summary:** `<N violations, N warns, N pre-existing>`
- **Blocking issues:** <numbered list, or "none">
- **Non-blocking notes:** <optional>

> The executor may set `PENDING_REVIEW` only when violations = 0.
> As everywhere else in this kit, `PASS` remains human-only.
