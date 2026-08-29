---
name: sprint-contract
description: >-
  Writes a sprint contract before any test or production code — work-type profile,
  scope in and out, feature branch, locked decisions, tests-first plan, grounded
  impact map, falsifiable success criteria, quality gates and blocking questions.
  Use when starting any non-trivial change, when the user says write a contract,
  plan this sprint, scope this work, or before implementing a FEATURES.json entry.
---

# Sprint contract

> Kit-owned. Edit in the harness-kit repo, not in the consumer repo.

**Contract before code.** No test or production code exists before the human approves this
and confirms the branch name.

## When to use

Any non-trivial change. Trivial fixes (typo, one-line config) may use a condensed contract
if `AGENTS.md` allows it.

## When not to use

A Solidity security review → `solidity-audit`. A periodic quality audit → `code-audit`.

## Steps

1. **Pick one work-type profile.** It decides which quality gates are in force and which are N/A.
2. **Scope, both halves.** What this sprint delivers, and explicitly what it does not.
3. **Propose a feature branch.** Ask: *"Confirm feature branch `<name>` (yes / or another name)."*
   Do not create or check out anything until the human replies. Never implement on the default branch.
4. **Lock decisions**, or record them Open with an owner and a needed-by.
5. **Tests first.** Name the failing tests and the repo's real verify commands from `AGENTS.md`.
   For behaviour-preserving refactors, characterization tests replace product TDD.
6. **Impact map**, every path marked `[GROUNDED]` (verified in the repo) or `[EDUCATED]` (re-verify first).
7. **Falsifiable success criteria** — command output, status and body, a revert, a log field.
   Never "works correctly" or "clear error".
8. **Blocking questions** with a recommendation each, so approval is one message.

## Opening the PR

The contract is not in git, so the **PR body carries it** between the contract markers, together with
the verbatim local gate output. A reviewer grades the PR against that; CI covers only repo-owned checks.

**No tool attribution** in the title, body or commit messages, and a commit's author is the human.

## Form

`templates/SPRINT_CONTRACT.md`
