---
name: harness-onboard
description: >-
  Bootstraps a repository into the harness process: scaffolds AGENTS.md with the
  embedded agent process, FEATURES.json, STATE.md and a slim README pointer, then
  verifies the wiring. Use when adopting the harness kit into a new or existing
  repo, when the user says onboard, bootstrap, set up the harness, adopt the kit,
  or when AGENTS.md is missing its Agent process section.
---

# Harness onboard

> Kit-owned. Edit in the harness-kit repo, not in the consumer repo.

Scaffold a repo into the process. Run once per repo, then re-run after a kit upgrade.

## When to use

Adopting the kit into a repo; recovering a repo whose `AGENTS.md` lost its process section;
verifying wiring after a submodule pointer bump.

## When not to use

Ordinary feature work — that starts at `sprint-contract`.

## Steps

1. **Detect** the repo's default branch, stack, package manager and test/lint commands. Never assume.
2. **Scaffold, preserving what exists.** `AGENTS.md` is filled from `templates/AGENTS.md` with the
   process from `templates/AGENT_PROCESS.md` embedded — **never overwrite** a filled `AGENTS.md`;
   scaffold only what is missing.
3. **Seed** `FEATURES.json` and `skills/.harness/STATE.md` from their templates if absent.
4. **README safety.** If the root `README.md` holds real project setup, move it to a project setup
   doc and link it before writing the slim pointer. Never destroy project content.
5. **Gitignore** `skills/.harness/` so contracts and state stay local working files.
6. **Verify:** `AGENTS.md` names the stack, the default branch and real verify commands;
   `FEATURES.json` parses; the skill symlinks resolve.

## Forms

`templates/AGENTS.md` · `templates/AGENT_PROCESS.md` · `templates/FEATURES.json` ·
`templates/STATE.md` · `templates/README_POINTER.md`
