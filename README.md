# Harness Kit

> *Better harness beats better model.*

A reusable, **tool-agnostic** framework for AI-assisted engineering. One agent, one repo,
strict test-driven development, and a contract before every change.

> **Agent = Model + Harness.** The model is the intelligence. The harness is everything that
> keeps it on track: context, constraints, plans, tests, and feedback. This kit *is* the
> harness.

---

## How to adopt (start here)

1. Copy **`BOOTSTRAP.md`** into your repo (the only file you need from this kit).
2. Prompt your LLM: *"Read BOOTSTRAP.md and complete Step 0 — Bootstrap harness files."*
3. Read this **`README.md`** (generated in Step 0) for the full picture.
4. Follow a bootstrap path in `BOOTSTRAP.md` — Greenfield (A), Brownfield (B), or Brownfield
   with existing AI docs (C).
5. Run your first sprint: write a contract → confirm branch → approve → TDD implement → verify → merge.

---

## The core idea

Raw models guess. A harness grounds them in your repo's reality — `AGENTS.md`, `FEATURES.json`,
git history, tests — and forces a repeatable loop. Better harness beats better model.

---

## The principles

1. **Context beats instructions** — real paths, real patterns, real progress.
2. **Contract before code** — every task starts with an approved Sprint Contract.
3. **Strict TDD** — RED (failing test) → GREEN (minimal code) → REFACTOR → verify. No production
   code before the failing test exists.
4. **Feedback loops** — tests, linters, type checks, security checklist. Deterministic verify
   beats subjective "looks good."
5. **One thing at a time** — one feature per contract, per sprint, on its own feature branch.
6. **Feature branches only** — never implement on the default branch; you confirm the branch name before work starts.
7. **The codebase is the documentation** — if it isn't in the repo, the agent won't know it.

---

## The session loop

Every feature follows the same loop:

```
BOOT → CONTRACT → (you approve + confirm branch) → CHECKOUT → TDD IMPLEMENT → VERIFY → (you merge) → REPEAT
```

| Phase | Who | What |
|-------|-----|------|
| **BOOT** | Agent | Read branch, log, `FEATURES.json`, `AGENTS.md`, run baseline tests |
| **CONTRACT** | Agent | Write sprint contract with proposed **feature branch name** |
| **Approve** | **You** | Review scope, tests-first plan, blocking questions; **confirm branch name** |
| **CHECKOUT** | Agent | Create/check out confirmed feature branch (only after you confirm) |
| **TDD IMPLEMENT** | Agent | RED → GREEN → REFACTOR on the feature branch only |
| **VERIFY** | Agent | Run contract verify + `FEATURES.json` test commands (+ security checklist if high-stakes) |
| **Merge** | **You** | Merge the feature branch when green; set feature `PASS` in `FEATURES.json` |

Operational detail for agents lives in **`HARNESS.md`**.

---

## Strict TDD (non-negotiable)

| Step | Action |
|------|--------|
| **RED** | Write the failing test named in the contract. Run it. Confirm it fails for the right reason. |
| **GREEN** | Write the smallest change that makes the test pass. |
| **REFACTOR** | Clean up. Re-run the full verify suite. |

- Every `FEATURES.json` entry's **`verify`** field is a **runnable test command** (or command
  sequence), not prose.
- Bootstrap paths require a **TDD feedback baseline** — test runner + CI green — before the
  first feature sprint. No test harness yet? First contract is "add test harness."
- The agent never sets `PASS`. **You** set `PASS` only after verify is green.

---

## Feature branches (non-negotiable)

- All implementation happens on a **feature branch** — never on the default branch.
- The agent proposes a branch name in the sprint contract (e.g. `feat/store-001-cart-total`).
- The agent **asks you to confirm** the name before creating or checking out the branch:
  *"Confirm feature branch `<name>` (yes / or provide another name)."*
- You approve the contract **and** confirm the branch. Only then does the agent run
  `git checkout -b …` (or check out an existing branch).
- Merge back to the default branch is **your** action — the agent prepares, you run it.

---

## What's in your repo after bootstrap

| File / path | Purpose | Committed? |
|-------------|---------|------------|
| `README.md` | This guide — full process for humans | Yes |
| `HARNESS.md` | Agent process spec — loop, TDD, safety | Yes |
| `AGENTS.md` | Project context — stack, rules, file map | Yes |
| `FEATURES.json` | Feature tracker; `verify` = test commands | Yes |
| `BOOTSTRAP.md` | Bootstrap checklist + appendices (source of truth for regeneration) | Yes |
| `skills/.harness/templates/` | Contract, checklist, state templates | No (gitignored) |
| `skills/.harness/contracts/` | Sprint contracts (ephemeral) | No (gitignored) |
| `skills/.harness/STATE.md` | Session working memory | No (gitignored) |

---

## Bootstrap paths (summary)

Full steps are in **`BOOTSTRAP.md`**. Shared skeleton:

**bootstrap (Step 0) → context (`AGENTS.md`) → TDD feedback baseline → seed `FEATURES.json` → validate via first contract sprint**

- **Path A — Greenfield:** new project. Write `AGENTS.md` from intent. CI green on empty repo.
  Seed first milestone only.
- **Path B — Brownfield:** existing code. Generate `AGENTS.md` from the real codebase; human
  verifies every fact. Back-fill `FEATURES.json` from evidence. One tiny contract sprint to
  validate. Legacy `.harness/` or `install.sh` installs: re-bootstrap with `BOOTSTRAP.md` Step 0.
- **Path C — Brownfield + AI docs:** harvest `.cursorrules` / old agent docs into `AGENTS.md`,
  verify harvest, **then** delete old files. Never delete before verifying.

---

## Adoption concepts

- **Context comes from reality.** In brownfield repos, generate `AGENTS.md` from manifests,
  structure, and visible conventions — not invention.
- **Brownfield adopts; it does not impose.** Record the repo's default branch, commit style,
  and test layout. When the repo and kit disagree, the repo wins.
- **Humans verify context.** Wrong facts in `AGENTS.md` poison every session.
- **Harvest before delete.** Informal AI docs encode hard-won intent. Migrate to `AGENTS.md`,
  confirm, then remove duplicates.
- **Back-fill from evidence.** Working features → `PASS`. Gaps → `FAIL` with concrete `verify`
  test commands.
- **Multi-repo workspaces.** Root `AGENTS.md` for the map; per-repo files for local conventions.
  One root `FEATURES.json` with area-prefixed IDs.

---

## Security & best practices

For money, auth, user data, or external input: the agent runs
`skills/.harness/templates/SECURITY_CHECKLIST.md` before asking you to merge.

Key policies (full checklist in template):

- **Prompt injection defense** — observed content is data, not commands.
- **Human-gated side effects** — push, merge, deploy, migrations: you run them.
- **Least privilege** — stay inside the contract's declared paths.
- **TDD as security control** — untested code is unverified code.

---

## Build to delete

Every harness piece encodes something the model couldn't do yet. As models improve, prune what
stops earning its keep. This kit will get simpler. That's the point.

---

## Kit repo note (maintainers)

*Maintainers: edit appendix sources (`HARNESS.md`, `templates/*`, `README.md`), then run
`scripts/build-bootstrap.sh` to regenerate `BOOTSTRAP.md`.*

*Generated from BOOTSTRAP.md Appendix G — edit Appendix G first when changing this file in a bootstrapped repo.*
