---
name: harness-review
description: >-
  Reviews a pull request as a production merge gate, starting with contract
  compliance: scope met or missing, impact map versus changed files, each success
  criterion pass or fail, quality gates, then correctness, architecture, reliability,
  performance, security, testing and operational readiness. Use when reviewing a PR,
  grading work at PENDING_REVIEW, or when the user asks whether a change should ship.
---

# Harness review

> Kit-owned. Edit in the harness-kit repo, not in the consumer repo.

Decide whether this change should ship. Correctness over style.

## When to use

Reviewing a PR, or grading a feature sitting at `PENDING_REVIEW`.

## Order matters

**§0 contract compliance first**, before any code reading: locate the contract, note the profile,
walk Scope WILL and will NOT, compare the impact map to the actually changed files, mark every
success criterion Pass / Fail / Untested with the observable quoted, then the quality gates.

Contract drift — partial or missing scope, failed criteria, scope creep — is **request changes**
unless it was explicitly re-contracted.

If no contract exists, say so plainly and review on production readiness alone.

## Rules that matter

- Apply only the gates the declared profile puts in force; mark the rest N/A.
- Architecture packs are graded only where `AGENTS.md` opts in.
- Code-quality limits are graded by `code-quality-gate`, not re-litigated here.
- The executor sets `PENDING_REVIEW`. **`PASS` is human-only.**

## Form

`templates/REVIEW.md`
