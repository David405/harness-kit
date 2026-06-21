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

> **The only file you need to adopt this workflow.** Copy this file into your repo. Prompt your LLM:
> "Read BOOTSTRAP.md and complete Step 0 — Bootstrap harness files."
> After Step 0, read `README.md` (generated from Appendix G) for the full process explained to humans.

---

## How this works

One agent, one repo. **Contract before code.** **Strict TDD** (RED → GREEN → REFACTOR). Working
files under `skills/.harness/` are gitignored; committed context lives in `AGENTS.md`,
`FEATURES.json`, `HARNESS.md`, and this file. Every task starts with a human-approved Sprint
Contract — no test or production code before approval.

---

## Step 0 — Bootstrap harness files [agent]

Generate these files **in order**. Copy appendix bodies **verbatim** unless preserve rules apply.

| # | Output path | Source | Preserve if exists? |
|---|-------------|--------|---------------------|
| 1 | `README.md` | Appendix G | **No** — overwrite (sync with kit) |
| 2 | `HARNESS.md` | Appendix A | **No** — overwrite |
| 3 | `skills/.harness/templates/AGENTS.md` | Appendix B | N/A (gitignored tree) |
| 4 | `skills/.harness/templates/FEATURES.json` | Appendix C | N/A |
| 5 | `skills/.harness/templates/SPRINT_CONTRACT.md` | Appendix D | N/A |
| 6 | `skills/.harness/templates/SECURITY_CHECKLIST.md` | Appendix E | N/A |
| 7 | `skills/.harness/templates/STATE.md` | Appendix F | N/A |
| 8 | `skills/.harness/contracts/` | — | Create empty directory |
| 9 | `skills/.harness/STATE.md` | Appendix F | Fill placeholders (project name, timestamp) |
| 10 | `skills/.harness/VERSION` | — | `version=1.1.0` + `bootstrapped=<YYYY-MM-DD>` |
| 11 | `AGENTS.md` | Appendix B | **Yes** — scaffold only if missing; never overwrite filled file |
| 12 | `FEATURES.json` | Appendix C | **Yes** — scaffold only if missing; never overwrite seeded file |
| 13 | `.gitignore` | — | Append `skills/.harness/` if missing (skip if not a git repo) |

**Done when:** all paths exist; `python3 -m json.tool FEATURES.json` passes (if FEATURES.json
was scaffolded); `.gitignore` contains `skills/.harness/`.

**Regenerate templates only:** re-run rows 3–10 without touching root `AGENTS.md` or
`FEATURES.json`.

---

## The shared skeleton

Every bootstrap path follows:

**bootstrap (Step 0) → context (`AGENTS.md`) → TDD feedback baseline → seed `FEATURES.json` → validate via first contract sprint**

---

## Bootstrap path A — Greenfield (new project)

1. **[agent]** Complete Step 0. — *done when: harness tree present.*
2. **[agent+human]** Write `AGENTS.md` from intent — stack, dependency flow, invariants. Only
   decisions actually made. — *done when: human reviewed.*
3. **[human]** **TDD feedback baseline** BEFORE any feature: lint, format, typecheck, test runner,
   CI green on empty repo. — *done when: test command runs and CI is green.*
4. **[agent]** Seed `FEATURES.json` with **first milestone only** (few features, `FAIL`,
   prioritized). Each `verify` = runnable test command. — *done when: valid JSON.*
5. **[agent+human]** First contract sprint on smallest feature — contract → approve → TDD → verify.
   — *done when: one feature merged and human set `PASS`.*

## Bootstrap path B — Brownfield (existing code, no AI docs)

1. **[agent]** Complete Step 0. — *done when: harness tree present.*
2. **[agent+human]** Detect conventions — default branch
   (`git symbolic-ref --short refs/remotes/origin/HEAD`), commit style, test layout. Adopt repo
   conventions; do not impose kit defaults. — *done when: recorded for `AGENTS.md`.*
3. **[agent+human]** Generate `AGENTS.md` from the **real** codebase; human verifies every fact.
   — *done when: facts confirmed.*
4. **[human]** **TDD feedback baseline:** confirm test/lint/build commands run; record in
   `AGENTS.md` "How we work here". — *done when: commands verified.*
5. **[agent+human]** Seed `FEATURES.json`: working → `PASS`, gaps → `FAIL` with test verify
   commands. — *done when: valid JSON.*
6. **[agent+human]** One tiny contract sprint. Surprises → fix `AGENTS.md`, not just code.
   — *done when: sprint completes cleanly.*

> **Legacy installs:** repos with `.harness/` or `install.sh` layouts should re-run Step 0 and
> migrate context into `skills/.harness/`. Remove obsolete `.harness/` entries from `.gitignore`.

## Bootstrap path C — Brownfield WITH existing informal AI docs

1. **[agent]** Complete Step 0. — *done when: harness tree present.*
2. **[agent+human]** **Harvest** existing AI docs (`.cursorrules`, old `CLAUDE.md`, scattered
   instructions) into `AGENTS.md`. Preserve all rules. — *done when: every rule copied.*
3. **[agent+human]** Detect conventions (Path B step 2). — *done when: recorded.*
4. **[agent+human]** Complete `AGENTS.md` from codebase + harvested rules; human verifies.
   — *done when: harvest confirmed.*
5. **[human]** **Verify harvest, THEN delete** old AI docs. NEVER delete before verifying.
   — *done when: `AGENTS.md` is sole context.*
6. **[human+agent]** TDD feedback baseline + seed `FEATURES.json` (Path B steps 4–5).
   — *done when: valid JSON, commands verified.*
7. **[agent+human]** One tiny contract sprint. — *done when: sprint completes cleanly.*

HEADER

  append "Appendix A — HARNESS.md" HARNESS.md
  append "Appendix B — AGENTS.md template" templates/AGENTS.md
  append "Appendix C — FEATURES.json template" templates/FEATURES.json
  append "Appendix D — SPRINT_CONTRACT.md template" templates/SPRINT_CONTRACT.md
  append "Appendix E — SECURITY_CHECKLIST.md template" templates/SECURITY_CHECKLIST.md
  append "Appendix F — STATE.md template" templates/STATE.md
  append "Appendix G — README.md" README.md

} > BOOTSTRAP.md

echo "Wrote BOOTSTRAP.md ($(wc -l < BOOTSTRAP.md | tr -d ' ') lines)"
