#!/bin/sh
# DEPRECATED as of kit 2.2.0 — adoption moved to git submodule + scripts/setup-harness-kit.sh.
# Retained so repos bootstrapped from BOOTSTRAP.md keep working. Removal: KIT-SKILLS-002.
# Generates BOOTSTRAP.md from the forms now bundled inside skills/<name>/templates/.
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

> **DEPRECATED — kit 2.2.0 adopts via git submodule; see README.md. This file is retained for
> repos already bootstrapped from it and will be removed in KIT-SKILLS-002.**
>
> **Kit version 2.2.0** — generic, tool-agnostic AI-assisted engineering process for TypeScript,
> Rust, Go, Solidity build, and Solidity auditing. Copy this file into **any** repo. Prompt your LLM:
> *"Read BOOTSTRAP.md and complete Step 0 — Bootstrap harness files."*

## v2.2 changelog

- **`rules/` directory** — six always-on process-law rules as `.mdc`, linked into the editor's rules
  directory and assembled (frontmatter stripped) into a marked block in `AGENTS.md`, so agents without
  a rules feature still receive them. `.agents/local-rules/` merges alongside and wins on collision.
- **Rules budget** — six is deliberate. Rules compete for the same always-on attention; a seventh has
  to displace one. `rules/README.md` states the ownership tiers and the gate-skill-rule ordering.
- **ERD routing in the loop** — `BOOT → ERD? → RESEARCH? → CONTRACT`. Step 2 is a **routing test**
  with three conditions, not a stage everyone runs; a feature inside a documented service skips it.
- **Two research moments distinguished** — discovery research lives in `erd-authoring` S0; the loop's
  `RESEARCH?` is contract-scoped. Never dual-run.
- **Contracts cite the slice they implement** and inherit its acceptance criteria.

## v1.5 changelog (retained)

- **`code-audit` profile** — periodic whole-subsystem code-quality audit. Produces findings, changes no
  code; fixes become ordinary sprint contracts. The counterpart to the per-sprint `CODE_QUALITY.md` gate.
- **Behaviour preservation made deterministic** — `CODE_AUDIT_CONTRACT.md` carries the frozen-contract
  list and equivalence checklist, and **characterization tests** replace product TDD for refactor work:
  written to pass against the code as it stands, then required to pass unchanged after.
- **`CODE_AUDIT_FINDING.md`** — extends the audit finding shape with category, confidence, regression
  risk, recommended change, behavioural safety, and required characterization tests.
- **Findings are human-accepted** — the audit proposes a `FEATURES.json` seed; a human accepts findings
  into the ledger, consistent with `PASS` being human-only.
- **Severity vocabulary unchanged** — reuses Critical/High/Medium/Low/Informational; no third scale.

## v1.4 changelog (retained)

- **Code-quality gate** — `CODE_QUALITY.md`: deterministic, lint-first checklist run at VERIFY for
  `service` / `http-api` / `solidity-build`. A `violation` blocks `PENDING_REVIEW`; `warn` and
  pre-existing debt never block. **N/A** for `ops-docs` and `solidity-audit`.
- **No thresholds in the kit** — the gate defers to the lint/static-analysis command declared in the
  consumer's `AGENTS.md`; model judgement is the documented fallback, not the default.
- **Single owner per rule** — credentials stay with `SECURITY_CHECKLIST.md`; the quality gate routes
  them there instead of double-reporting. `REVIEW.md` §11 no longer restates complexity rules.
- **Gate vs craft** — packs may supply thresholds and fix recipes and may tighten the gate; they may
  never replace it, waive a violation, or set `PASS`.

## v1.3 changelog (retained)

- **`PENDING_REVIEW` status** — three-state FEATURES legend; executor sets `PENDING_REVIEW`; human sets `PASS`.
- **Work-type profiles** — `service` | `http-api` | `solidity-build` | `solidity-audit` | `ops-docs`.
- **Language-neutral VERIFY** — runners come from consumer `AGENTS.md` (bun/cargo/go/forge/…).
- **Contract quality gates** — falsifiable AC; trust-boundary / HTTP / Solidity gates with **N/A** paths.
- **REVIEW §0** — sprint/audit contract compliance before production rubric.
- **Solidity audit templates** — `AUDIT_CONTRACT.md`, `AUDIT_FINDING.md`; security checklist Solidity section.
- **Optional skill packs** — must not replace FEATURES/contracts/VERIFY; hexagonal/TDD routers are opt-in.
- **Depth matrix** — trivial / medium / large / audit; optional Research without a second approved `plan.md`.

## v1.2 changelog (retained)

- **`HARNESS.md` merged into `AGENTS.md`** — `## Agent process` is the single agent entrypoint; never generate `HARNESS.md`.
- **`README.md` slimmed to pointer** (~15 lines) — humans read optional `<PROJECT_SETUP>.md` for app setup.
- **Step 0 legacy cleanup** — delete kit cruft (`ADOPTION.md`, `LOOP.md`, `SETUP.md`, root `.harness/`, etc.).
- **Brownfield README recovery** — preserve real project README content in a setup doc before overwriting.
- **`skills/.harness/`** replaces root `.harness/` — templates, contracts, STATE, VERSION (gitignored). Existing repos may keep `.harness/contracts/` if `AGENTS.md` says so.
- **Path C harvest + consolidation** — merge duplicate MDs into `AGENTS.md`; drop stale facts; delete only after human verify.

---

## Human vs agent docs

| File | Audience | Role |
|------|----------|------|
| `README.md` | Humans | **Short pointer** — what to read, not the process essay |
| `<PROJECT_SETUP>.md` | Humans | Optional app setup (local dev, deploy, env) — project-specific name |
| `AGENTS.md` | Agents | Single entrypoint — context + **`## Agent process`** |
| `FEATURES.json` | Both | Progress: FAIL → PENDING_REVIEW → PASS; every `verify` = runnable command |
| `BOOTSTRAP.md` | Maintainers | Bootstrap + appendix source for regeneration |
| the `harness-review` skill | Reviewers | §0 contract compliance + production rubric |
| the `solidity-audit` skill | Auditors | Solidity audit slice contract |
| `skills/.harness/` | Agents | Gitignored working tree — templates, contracts, STATE, VERSION |

Agents read **`AGENTS.md` only** each session (plus `FEATURES.json`, `skills/.harness/STATE.md`, active sprint or audit contract).

---

## How this works

One agent, one repo. **Contract before code.** **TDD when behaviour changes** (RED → GREEN → REFACTOR)
using **this repo's** test runner. Solidity audits use PoC-first VERIFY for High/Critical findings.
Working files under `skills/.harness/` are gitignored; committed context lives in `AGENTS.md`,
`FEATURES.json`, and this file. Every non-trivial task starts with a human-approved Sprint or Audit
Contract — no test or production code before approval.

**Never generate or keep:** `HARNESS.md`, `ADOPTION.md`, `LOOP.md`, `SETUP.md`, root committed
`.harness/` mirrors of kit templates, duplicate context MDs that repeat `AGENTS.md` / `FEATURES.json`,
or committed tool pointer files (optional: gitignore `CLAUDE.md` instead).

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
| 1 | kit skills (symlinked by `setup-harness-kit.sh`) | Appendices B–P | N/A — canonical in the submodule |
| 2 | `skills/.harness/contracts/` | — | Create empty directory |
| 3 | `skills/.harness/STATE.md` | Appendix F | Fill `<project-name>` + date |
| 4 | `skills/.harness/VERSION` | — | `version=2.2.0` + `bootstrapped=<YYYY-MM-DD>` |
| 5 | `README.md` | Appendix G | **No** — overwrite with slim pointer (after brownfield recovery if needed) |
| 6 | `AGENTS.md` | Appendix B | **Yes** if already filled — scaffold only; never overwrite harvested/verified content |
| 7 | `FEATURES.json` | Appendix C | **Yes** if seeded — scaffold only |
| 8 | `.gitignore` | — | Append `skills/.harness/`; optionally `CLAUDE.md` |
| 9 | Legacy cleanup | — | Remove kit cruft if present (see list below) |

**Legacy cleanup (row 9)** — delete if present:

- `HARNESS.md` (superseded by `AGENTS.md` § Agent process)
- `ADOPTION.md`, `LOOP.md`, `SETUP.md` (distribution cruft)
- Root `.harness/` **kit template mirrors** (migrate useful content to `skills/.harness/`, then delete). Do not delete a live `.harness/contracts/` tree if `AGENTS.md` still points there — migrate or document.
- `install.sh`, `update.sh` (v1.0 installers)
- Duplicate context MDs: integration matrices, stale planning docs, workspace briefs, audit docs
  against deleted rule files — **only after** content is merged into `AGENTS.md` and human-verified

**Done when:**

- `skills/.harness/` tree exists with VERSION `2.2.0`
- `python3 -m json.tool FEATURES.json` passes (if scaffolded)
- `.gitignore` contains `skills/.harness/`
- No `HARNESS.md` in repo
- `AGENTS.md` contains `## Agent process` and work-type profiles
- Templates include `AUDIT_CONTRACT.md`, `CODE_QUALITY.md`, `CODE_AUDIT_CONTRACT.md`, and `REVIEW.md` §0
- Humans have a clear setup doc if this is an application repo
- `README.md` is a pointer, not a duplicate of `AGENTS.md`

**Regenerate templates only:** re-run rows 1–4 without touching root `AGENTS.md` or `FEATURES.json`.

---

## The shared skeleton

Every bootstrap path follows:

**Step 0 → context (`AGENTS.md`) → feedback baseline (stack test commands) → seed `FEATURES.json` → validate via first contract sprint**

---

## Bootstrap path A — Greenfield (new project)

1. **[agent]** Complete Step 0. — *done when: harness tree present; no `HARNESS.md`.*
2. **[agent+human]** Write `AGENTS.md` from intent — stack, dependency flow, invariants, primary verify commands. Only decisions actually made. Include full **Agent process** from Appendix A/B. — *done when: human reviewed.*
3. **[human]** **Feedback baseline** BEFORE any feature: lint, format, typecheck, test runner,
   CI green on empty repo (use this stack's tools). — *done when: test command runs and CI is green.*
4. **[agent]** Seed `FEATURES.json` with **first milestone only** (few features, `FAIL`,
   prioritized). Each `verify` = runnable test command. — *done when: valid JSON.*
5. **[agent+human]** First contract sprint on smallest feature — contract → approve → TDD → verify → PENDING_REVIEW → PASS.
   — *done when: one feature merged and human set `PASS`.*

## Bootstrap path B — Brownfield (existing code, no AI docs)

1. **[agent]** Complete Step 0 (including README recovery if needed). — *done when: harness tree present.*
2. **[agent+human]** Detect conventions — default branch
   (`git symbolic-ref --short refs/remotes/origin/HEAD`), commit style, test layout. Adopt repo
   conventions; do not impose kit defaults. — *done when: recorded in `AGENTS.md` "How we work here".*
3. **[agent+human]** Generate `AGENTS.md` from the **real** codebase; human verifies every fact.
   Merge API/integration notes inline — no separate integration doc. — *done when: facts confirmed.*
4. **[human]** **Feedback baseline:** confirm test/lint/build commands run; record in
   `AGENTS.md` "How we work here". — *done when: commands verified.*
5. **[agent+human]** Seed `FEATURES.json`: working → `PASS`, gaps → `FAIL` with test verify
   commands. — *done when: valid JSON.*
6. **[agent+human]** One tiny contract sprint. Surprises → fix `AGENTS.md`, not just code.
   — *done when: sprint completes cleanly.*

> **Legacy v1.0 installs:** repos with root `.harness/` or `install.sh` should re-run Step 0,
> migrate context into `skills/.harness/` (or document `.harness/contracts/`), delete obsolete
> installers, remove obsolete `.gitignore` entries carefully.

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
7. **[human+agent]** Feedback baseline + seed `FEATURES.json` (Path B steps 4–5).
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
- **Full contract-first process** on the primary application / contracts repo; thin frontends may use the
  **condensed Agent process** variant (see Appendix B).

HEADER

  append "Appendix A — Agent process (embedded in AGENTS.md)" skills/harness-onboard/templates/AGENT_PROCESS.md
  append "Appendix B — AGENTS.md template" skills/harness-onboard/templates/AGENTS.md
  append "Appendix C — FEATURES.json template" skills/harness-onboard/templates/FEATURES.json
  append "Appendix D — SPRINT_CONTRACT.md template" skills/sprint-contract/templates/SPRINT_CONTRACT.md
  append "Appendix E — SECURITY_CHECKLIST.md template" skills/security-checklist/templates/SECURITY_CHECKLIST.md
  append "Appendix F — STATE.md template" skills/harness-onboard/templates/STATE.md
  append "Appendix G — REVIEW.md template" skills/harness-review/templates/REVIEW.md
  append "Appendix H — README.md template (slim pointer)" skills/harness-onboard/templates/README_POINTER.md
  append "Appendix I — AUDIT_CONTRACT.md template" skills/solidity-audit/templates/AUDIT_CONTRACT.md
  append "Appendix J — AUDIT_FINDING.md template" skills/solidity-audit/templates/AUDIT_FINDING.md
  append "Appendix K — CODE_QUALITY.md template" skills/code-quality-gate/templates/CODE_QUALITY.md
  append "Appendix L — CODE_AUDIT_CONTRACT.md template" skills/code-audit/templates/CODE_AUDIT_CONTRACT.md
  append "Appendix M — CODE_AUDIT_FINDING.md template" skills/code-audit/templates/CODE_AUDIT_FINDING.md
  append "Appendix N — ERD_CONTRACT.md template" skills/erd-authoring/templates/ERD_CONTRACT.md
  append "Appendix O — ERD.md template" skills/erd-authoring/templates/ERD.md
  append "Appendix P — ARCHITECTURE.md template" skills/erd-authoring/templates/ARCHITECTURE.md
  append "Appendix Q — rules/README.md (rule budget + ownership tiers)" rules/README.md

  cat <<'FOOTER'

---

## Kit repo note (maintainers)

*Maintainers: edit `templates/*` and this file's Step 0 / paths sections, then run
`scripts/build-bootstrap.sh` to regenerate embedded appendices.*

FOOTER

} > BOOTSTRAP.md

echo "Wrote BOOTSTRAP.md ($(wc -l < BOOTSTRAP.md | tr -d ' ') lines)"
