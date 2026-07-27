#!/bin/sh
# Generates BOOTSTRAP.md from maintainer mirrors. Run from kit repo root after editing mirrors.
set -eu
root=$(cd "$(dirname "$0")/.." && pwd)
cd "$root"

append() {
  title=$1
  file=$2
  printf '\n---\n\n## %s\n\n' "$title"
  cat "$file"
}

{
  cat <<'HEADER'
# BOOTSTRAP.md — Harness Bootstrap

> **Kit version 1.2.0** — generic, tool-agnostic AI-assisted engineering process.
> Copy this file into **any** repo. Prompt your LLM:
> *"Read BOOTSTRAP.md and complete Step 0 — Bootstrap harness files."*

## v1.2 changelog

- **`HARNESS.md` merged into `AGENTS.md`** — `## Agent process` is the single agent entrypoint; never generate `HARNESS.md`.
- **`README.md` slimmed to pointer** (~15 lines) — humans read optional `<PROJECT_SETUP>.md` for app setup.
- **Step 0 legacy cleanup** — delete kit cruft (`ADOPTION.md`, `LOOP.md`, `SETUP.md`, root `.harness/`, etc.).
- **Brownfield README recovery** — preserve real project README content in a setup doc before overwriting.
- **`skills/.harness/`** replaces root `.harness/` — templates, contracts, STATE, VERSION (gitignored).
- **Path C harvest + consolidation** — merge duplicate MDs into `AGENTS.md`; drop stale facts; delete only after human verify.

---

## Human vs agent docs

| File | Audience | Role |
|------|----------|------|
| `README.md` | Humans | **Short pointer** (~15 lines) — what to read, not the process essay |
| `<PROJECT_SETUP>.md` | Humans | Optional app setup (local dev, deploy, env) — project-specific name |
| `AGENTS.md` | Agents | Single entrypoint — context + **`## Agent process`** |
| `FEATURES.json` | Both | Progress; every `verify` = runnable command |
| `BOOTSTRAP.md` | Maintainers | Bootstrap + appendix source for regeneration |
| `skills/.harness/templates/REVIEW.md` | Reviewers | Production-readiness PR review rubric |
| `skills/.harness/` | Agents | Gitignored working tree — templates, contracts, STATE, VERSION |

Agents read **`AGENTS.md` only** each session (plus `FEATURES.json`, `skills/.harness/STATE.md`, active sprint contract).

---

## How this works

One agent, one repo. **Contract before code.** **Strict TDD** (RED → GREEN → REFACTOR). Working
files under `skills/.harness/` are gitignored; committed context lives in `AGENTS.md`,
`FEATURES.json`, and this file. Every task starts with a human-approved Sprint Contract — no test
or production code before approval.

**Never generate or keep:** `HARNESS.md`, `ADOPTION.md`, `LOOP.md`, `SETUP.md`, root `.harness/`,
duplicate context MDs that repeat `AGENTS.md` / `FEATURES.json`, or committed tool pointer files
(optional: gitignore `CLAUDE.md` instead).

---

## Step 0 — Bootstrap harness files [agent]

Generate **in order**. Copy appendix bodies **verbatim** unless preserve rules apply.

### Brownfield README safety (run before row 5)

If root `README.md` already exists and contains **project setup** (install, Docker, deploy, env vars):

1. **Do not destroy it.** Recover original content from git history if a prior bootstrap overwrote it.
2. Write recovered content to `<PROJECT_SETUP>.md` (pick a name that fits the repo — e.g.
   `DEVELOPMENT.md`, `BACKEND.md`).
3. Link that file from the slim `README.md` (Appendix G) and from `AGENTS.md` header.
4. Only then overwrite root `README.md` with the slim harness pointer.

If `README.md` is already a harness pointer or is empty/scaffold-only, skip recovery.

| # | Output | Source | Preserve if exists? |
|---|--------|--------|---------------------|
| 1 | `skills/.harness/templates/*` | Appendices B–G | N/A (gitignored) |
| 2 | `skills/.harness/contracts/` | — | Create empty directory |
| 3 | `skills/.harness/STATE.md` | Appendix F | Fill `<project-name>` + date |
| 4 | `skills/.harness/VERSION` | — | `version=1.2.0` + `bootstrapped=<YYYY-MM-DD>` |
| 5 | `README.md` | Appendix G | **No** — overwrite with slim pointer (after brownfield recovery if needed) |
| 6 | `AGENTS.md` | Appendix B | **Yes** if already filled — scaffold only; never overwrite harvested/verified content |
| 7 | `FEATURES.json` | Appendix C | **Yes** if seeded — scaffold only |
| 8 | `.gitignore` | — | Append `skills/.harness/`; optionally `CLAUDE.md` |
| 9 | Legacy cleanup | — | Remove kit cruft if present (see list below) |

**Legacy cleanup (row 9)** — delete if present:

- `HARNESS.md` (superseded by `AGENTS.md` § Agent process)
- `ADOPTION.md`, `LOOP.md`, `SETUP.md` (distribution cruft)
- Root `.harness/` (migrate useful content to `skills/.harness/`, then delete)
- `install.sh`, `update.sh` (v1.0 installers)
- Duplicate context MDs: integration matrices, stale planning docs, workspace briefs, audit docs
  against deleted rule files — **only after** content is merged into `AGENTS.md` and human-verified

**Done when:**

- `skills/.harness/` tree exists with VERSION `1.2.0`
- `python3 -m json.tool FEATURES.json` passes (if scaffolded)
- `.gitignore` contains `skills/.harness/`
- No `HARNESS.md` in repo
- `AGENTS.md` contains `## Agent process`
- Humans have a clear setup doc if this is an application repo
- `README.md` is a pointer, not a duplicate of `AGENTS.md`

**Regenerate templates only:** re-run rows 1–4 without touching root `AGENTS.md` or `FEATURES.json`.

---

## The shared skeleton

Every bootstrap path follows:

**Step 0 → context (`AGENTS.md`) → TDD feedback baseline → seed `FEATURES.json` → validate via first contract sprint**

---

## Bootstrap path A — Greenfield (new project)

1. **[agent]** Complete Step 0. — *done when: harness tree present; no `HARNESS.md`.*
2. **[agent+human]** Write `AGENTS.md` from intent — stack, dependency flow, invariants. Only
   decisions actually made. Include full **Agent process** from Appendix B. — *done when: human reviewed.*
3. **[human]** **TDD feedback baseline** BEFORE any feature: lint, format, typecheck, test runner,
   CI green on empty repo. — *done when: test command runs and CI is green.*
4. **[agent]** Seed `FEATURES.json` with **first milestone only** (few features, `FAIL`,
   prioritized). Each `verify` = runnable test command. — *done when: valid JSON.*
5. **[agent+human]** First contract sprint on smallest feature — contract → approve → TDD → verify.
   — *done when: one feature merged and human set `PASS`.*

## Bootstrap path B — Brownfield (existing code, no AI docs)

1. **[agent]** Complete Step 0 (including README recovery if needed). — *done when: harness tree present.*
2. **[agent+human]** Detect conventions — default branch
   (`git symbolic-ref --short refs/remotes/origin/HEAD`), commit style, test layout. Adopt repo
   conventions; do not impose kit defaults. — *done when: recorded in `AGENTS.md` "How we work here".*
3. **[agent+human]** Generate `AGENTS.md` from the **real** codebase; human verifies every fact.
   Merge API/integration notes inline — no separate integration doc. — *done when: facts confirmed.*
4. **[human]** **TDD feedback baseline:** confirm test/lint/build commands run; record in
   `AGENTS.md` "How we work here". — *done when: commands verified.*
5. **[agent+human]** Seed `FEATURES.json`: working → `PASS`, gaps → `FAIL` with test verify
   commands. — *done when: valid JSON.*
6. **[agent+human]** One tiny contract sprint. Surprises → fix `AGENTS.md`, not just code.
   — *done when: sprint completes cleanly.*

> **Legacy v1.0 installs:** repos with root `.harness/` or `install.sh` should re-run Step 0,
> migrate context into `skills/.harness/`, delete root `.harness/`, remove obsolete `.gitignore` entries.

## Bootstrap path C — Brownfield WITH existing informal AI docs

1. **[agent]** Complete Step 0 (+ recover project README → setup doc if needed).
   — *done when: harness tree present.*
2. **[agent+human]** **Harvest** old agent docs (`.cursorrules`, tool rules, scattered MDs) into
   `AGENTS.md`. Preserve intent; **drop stale/wrong facts** (wrong ORM, wrong architecture,
   aspirational port tables). — *done when: harvest draft ready.*
3. **[agent+human]** **Merge duplicate MDs** into `AGENTS.md` — integration matrices, role
   definitions, deploy checklists. One source of truth. — *done when: no unique content left outside.*
4. **[agent+human]** Detect conventions (Path B step 2). — *done when: recorded.*
5. **[human]** **Verify harvest** — every fact in `AGENTS.md` checked against the repo.
   — *done when: human signs off.*
6. **[human]** **Then delete** verified duplicates and legacy kit files (Step 0 row 9).
   **Never delete before verify.** — *done when: `AGENTS.md` is sole agent context.*
7. **[human+agent]** TDD feedback baseline + seed `FEATURES.json` (Path B steps 4–5).
   — *done when: valid JSON, commands verified.*
8. **[agent+human]** First contract sprint on highest-priority `FAIL`.
   — *done when: sprint completes cleanly.*

---

## Multi-repo workspaces (optional)

When the workspace contains multiple git repos:

- **Root `AGENTS.md`** = map only — which repo, ports, how services connect, cross-repo rules.
- **Per-repo `AGENTS.md` + `FEATURES.json`** — local stack, conventions, feature tracker.
- **One session = one repo / one concern** — do not mix contracts across repos.
- **No per-repo `HARNESS.md`, `SETUP.md`, or duplicate integration docs** — integration notes live
  inline in each repo's `AGENTS.md` or the root map.
- **Full contract-first TDD** on the primary application repo; thin frontends may use the
  **condensed Agent process** variant (see Appendix B).

HEADER

  append "Appendix A — Agent process (embedded in AGENTS.md)" templates/AGENT_PROCESS.md
  append "Appendix B — AGENTS.md template" templates/AGENTS.md
  append "Appendix C — FEATURES.json template" templates/FEATURES.json
  append "Appendix D — SPRINT_CONTRACT.md template" templates/SPRINT_CONTRACT.md
  append "Appendix E — SECURITY_CHECKLIST.md template" templates/SECURITY_CHECKLIST.md
  append "Appendix F — STATE.md template" templates/STATE.md
  append "Appendix G — REVIEW.md template" templates/REVIEW.md
  append "Appendix H — README.md template (slim pointer)" templates/README_POINTER.md

  cat <<'FOOTER'

---

## Kit repo note (maintainers)

*Maintainers: edit `templates/*` and this file's Step 0 / paths sections, then run
`scripts/build-bootstrap.sh` to regenerate embedded appendices.*

FOOTER

} > BOOTSTRAP.md

echo "Wrote BOOTSTRAP.md ($(wc -l < BOOTSTRAP.md | tr -d ' ') lines)"
