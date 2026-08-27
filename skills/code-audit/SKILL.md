---
name: code-audit
description: >-
  Runs a periodic whole-subsystem code quality audit against a declared commit or
  tag, producing prioritised findings with severity, confidence and regression risk
  while preserving existing behaviour exactly. Changes no code. Use for a milestone,
  quarterly or pre-hardening review, before a large refactor, or when the user asks
  to audit a codebase, assess overall code quality, or find refactoring opportunities.
---

# Code audit

> Kit-owned. Edit in the harness-kit repo, not in the consumer repo.

**Periodic, never per sprint.** The gate asks "can this diff ship?"; this asks "where should we
invest refactoring effort, and what is safe to touch?"

## When to use

Milestone, quarter, pre-hardening, pre-handover, or before a large refactor.

## When not to use

Per-contract checking → `code-quality-gate`. Security review of contracts → `solidity-audit`.

## The absolute constraint

**Refactor implementation, not behaviour.** Every recommendation preserves externally observable
behaviour. Where cleanliness and behavioural safety conflict, safety wins. Equivalence is proven,
not asserted: characterization tests must pass against the code as it stands today, then pass
unchanged after the refactor.

Any uncertainty downgrades a finding to *"Potential improvement — requires behavioural verification"*.

## Rules that matter

- Declare **scope and the audited commit or tag**. Findings without a ref are unactionable.
- Work all 15 taxonomy categories; record "no material findings" rather than omitting one.
- Validate before reporting — call sites, consumers, tests, framework registration.
- Materiality test: unconventional but clear, safe, locally appropriate code is not a finding.
- Suspected functional bugs are **reported, never fixed** inside the audit.
- The audit **proposes** a `FEATURES.json` seed; a **human accepts** findings into the ledger.

## Forms

`templates/CODE_AUDIT_CONTRACT.md` · `templates/CODE_AUDIT_FINDING.md`
