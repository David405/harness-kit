---
name: solidity-audit
description: >-
  Runs a Solidity contract security audit against a declared commit or tag: scope,
  assets, actors and trust boundaries, a severity rubric, a tooling plan, and
  findings where High and Critical require a reproducible proof of concept. Use
  when auditing smart contracts, reviewing contract security, or when the user asks
  for a security review of Solidity code.
---

# Solidity audit

> Kit-owned. Edit in the harness-kit repo, not in the consumer repo.

Security review of contracts. Produces findings; fixes are separate `solidity-build` contracts.

## When to use

Auditing smart contracts for security, before a deployment or an external review.

## When not to use

Implementing or fixing contracts → a `solidity-build` sprint contract.
General code quality → `code-audit`.

## Rules that matter

- **PoC first.** High and Critical findings need a reproducible verify command. An unreproducible
  Critical claim is unverified, not a finding.
- Record the exact commit or tag audited, and what is explicitly out of scope.
- Run the Solidity section of `security-checklist` against the target.
- Assign finding IDs; keep severity honest against the declared rubric.

## Forms

`templates/AUDIT_CONTRACT.md` · `templates/AUDIT_FINDING.md`
