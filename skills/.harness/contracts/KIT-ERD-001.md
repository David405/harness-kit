# SPRINT CONTRACT — KIT-ERD-001: `product-erd` profile + ERD authoring stage

> Status: **EXECUTE complete — VERIFY green (21/21) — PENDING_REVIEW.**
> Approved: (David, "proceed", 2026-08-27), with recommended Q2–Q4.
> **Revised for kit v2.0:** deliverables are a **skill**, not `templates/*`. Version **2.1.0**.
> Feature ID: `KIT-ERD-001`
> Repo: **harness-kit only**
> Branch: proposed `feat/kit-erd-001-product-erd-profile` — **human must confirm before checkout**
> Trigger: David (2026-08-27) — "build an ERD creation process within our agent harness kit … the first bit of building out a product or a feature for us before that is translated to a sprint contract."

---

## Work-type profile (required)

- [x] `ops-docs` — process/templates change to the kit itself

**Languages / toolchain:** Markdown + POSIX sh (`scripts/build-bootstrap.sh`). No application code.

> Note: this sprint **adds** the `product-erd` profile. The sprint itself runs under `ops-docs`.

---

## Context (grounded)

Read before writing this contract:

| Source | Finding |
| --- | --- |
| `templates/AGENT_PROCESS.md` | Loop is `BOOT → RESEARCH? → CONTRACT → [APPROVE+BRANCH] → CHECKOUT → EXECUTE → VERIFY → REVIEW → PENDING_REVIEW → [PASS]`. 5 profiles. Optional RESEARCH "distills open questions", explicitly **does not** create a second approved artifact. |
| `technical-project-documentation/.harness/contracts/ORDER-SVC-001..019` | The kit is **already** authoring ERDs — 19 contracts, all `ops-docs`, all Markdown-only, all grep-based VERIFY. |
| Same, 006/007/008/011/012 | Several are single-decision lock contracts (006 is 740 bytes: "lock amount encoding"). Decisions surfaced **during** doc work, not before it. |
| Same, 009 → 010, and 015 | 009 fully superseded; 015 reversed the stake-limit / `batchAll` / `extrinsicToken` locks from 010–014. Rework caused by late decision discovery. |
| `technical-project-documentation/.agents/skills/erd-authoring/SKILL.md` | Good **style guide** — section flow, slice-table rules, diagram + quality bar. Not a **process**: no cold-start, no decision elicitation, no gates. |
| `technical-project-documentation/.agents/skills/erd-engineering-standards/SKILL.md` | tao.com-specific defaults (HAL, RFC 9457, hexagonal, K8s probes, New Relic). Must **not** move into the kit — kit stays stack-neutral. |
| `products/order-service/v1/{erd.md,architecture.md}` | Reference output shape for the two-document deliverable. |

**Gap this contract closes:** (1) no cold-start path from brief → first complete ERD; (2) decisions arrive reactively instead of being elicited and locked up front; (3) no mechanical ERD → `FEATURES.json` → sprint-contract handoff.

---

## Scope — WILL do

### A — New work-type profile

1. Add **`product-erd`** as the sixth work-type profile in `templates/AGENT_PROCESS.md`, `templates/AGENTS.md`, and `templates/SPRINT_CONTRACT.md`.
2. Profile applies when defining a **new product, service, or substantial feature** whose design is not yet locked. Its deliverable is documentation; its consumers are the sprint contracts that follow.

### B — New skill (v2.0 shape) — supersedes the original "three templates"

3. `templates/ERD_CONTRACT.md` — the contract governing an ERD-authoring sprint (analogue of `AUDIT_CONTRACT.md`). Carries the staged gate log in §C below.
4. `skills/erd-authoring/templates/ERD.md` — the ERD document. Section flow: Executive Summary; Goals and Non-Goals; Engineering Standards / Goals; Implementation Overview; Design Decisions (+ Acceptance Criteria); API Conventions and Contracts; Risks / Security / Pre-Mortem; Open Questions; **Implementation plan: Feature slices**; Appendices (Data Dictionary, Glossary, References).
5. `skills/erd-authoring/templates/ARCHITECTURE.md` — companion doc. Owns: mental model, system diagram (Mermaid), component/boundary table, ports or module map **only where `AGENTS.md` declares that pattern**, primary control flows, data ownership, deployable boundaries.

### C — The staged EXECUTE (progressive, human-gated)

6. Document in `templates/AGENT_PROCESS.md` a new subsection **"ERD stage (`product-erd`)"**. EXECUTE for this profile is **five stages with a human gate between each**. The agent stops at every gate.

```
BRIEF/PRD ─► S0 Frame ─► S1 Decisions ─► S2 Design ─► S3 Contracts ─► S4 Slices ─► erd.md + architecture.md
                 ▲            ▲             ▲             ▲              ▲                    │
              [gate]       [gate]        [gate]        [gate]         [gate]                  ▼
                                                                              FEATURES.json seed ─► sprint contracts
```

| Stage | Agent produces | Human gate |
| --- | --- | --- |
| **S0 Frame** | Input inventory (PRD/brief/design/tickets/related repos + code to reuse); draft **Executive Summary** + **Goals** + **Non-Goals** | Confirms the scope boundary. Non-goals must be explicit here, not discovered later. |
| **S1 Decisions** | Every decision the ERD must lock, as a table: `Topic \| Options \| Recommendation \| Status`. No design written yet. | Answers or defers each. Deferred rows move to **Open Questions** with an owner and a needed-by. **This is the stage that replaces reactive lock contracts.** |
| **S2 Design** | `architecture.md`: mental model, diagram, boundaries, control flows, data ownership | Confirms the shape before contracts are written against it. |
| **S3 Contracts** | ERD design sections: standards, API/event/data contracts, error model, acceptance criteria, risks / pre-mortem | Confirms contracts and falsifiable acceptance criteria. |
| **S4 Slices** | `Implementation plan: Feature slices` table **plus** the `FEATURES.json` seed block — one entry per slice | PASS. ERD is now the input to sprint contracts. |

7. **Slices are written last**, only after S0–S3 are stable. Slice 1 is scaffolding (incl. readiness/liveness probes) when the target is a deployable service; **N/A** for library, contract, or docs targets. Every slice row needs a concrete working behaviour and a functional test that mimics a user story or a meaningful part of one.
8. **The ERD → contract bridge (the point of this sprint):** S4 emits a `FEATURES.json` seed block, one entry per slice, `status: FAIL`, `verify` written from the consumer repo's `AGENTS.md` runner. Each seeded entry then becomes exactly one sprint contract under the normal loop. The handoff is mechanical, not interpretive.

### D — Depth matrix + skip rule

9. Extend the depth matrix in `templates/AGENT_PROCESS.md` with an ERD row, and state plainly **when to skip the ERD stage**: a feature inside an already-documented service goes straight to a sprint contract. The ERD stage is for a new product/service, a new domain, or a contract crossing teams or repos. Cite "build to delete" / cost reality.
10. State that optional **RESEARCH** and the **ERD stage** are not the same thing and must not be dual-run: RESEARCH distills open questions for one contract; the ERD stage produces a durable design document that feeds many contracts.

### E — Kit neutrality (explicit)

11. The kit ships the **process and the document skeleton only**. Organisation standards — HAL, RFC 9457, hexagonal, camelCase, probe endpoints, log destinations — stay in the consumer repo's `AGENTS.md` or its docs skill pack. the ERD form references "the standards pack declared in `AGENTS.md`" and never names one.
12. The ERD form instructs: record any divergence from the declared standards pack in **Design Decisions** with rationale. Never diverge silently.

### F — Review + gates

13. The `sprint-contract` form: add `product-erd` to the profile checklist and add one quality-gate row — *`product-erd` only: decisions locked or owner+needed-by; non-goals explicit; slices ticket-ready with functional tests; FEATURES seed emitted — or **N/A***.
14. The `harness-review` form: add `product-erd` to the profile-aware review hints — *scope honesty (non-goals real), decision completeness, falsifiable acceptance criteria, slice ticketability, no silent standards divergence*.

### G — Version, docs, bootstrap

15. Bump kit version to **2.1.0** in `scripts/build-bootstrap.sh` (which regenerates the deprecated `BOOTSTRAP.md`) and `README.md`.
16. Append **Appendix K** (`ERD_CONTRACT.md`), **Appendix L** (`ERD.md`), **Appendix M** (`ARCHITECTURE.md`) in `scripts/build-bootstrap.sh`; add the three files to the Step 0 path table.
17. Add `erd-authoring` to the skills table in `README.md`; mention the `product-erd` profile.
18. Add the `KIT-ERD-001` entry to root `FEATURES.json`.
19. Re-run `./scripts/build-bootstrap.sh` so `BOOTSTRAP.md` stays in sync.

---

## Scope — will NOT do (this sprint)

- Copy tao.com standards (HAL, RFC 9457, hexagonal, New Relic, K8s probes) into the kit.
- Modify `technical-project-documentation`, `order-service`, or any other consumer repo.
- Migrate the existing `ORDER-SVC-001..019` contracts or rewrite `products/order-service/v1/*`.
- Adopt or absorb `agent-harness` / its RPI skills (still out of scope per KIT-V13-001).
- Add an ERD amendment / change-log template — see blocking question Q3.
- Add PRD authoring. The ERD stage takes a brief or PRD as **input**; it does not write one.
- Automate ERD linting beyond grep-based VERIFY commands.
- Change the existing five profiles, the status model, or the session loop outside the additions above.

## Target

- **Repo / package:** `harness-kit` — the kit owns the process spine.
- **Not touching:** every consumer repo; `agent-harness`; application source anywhere.

---

## Branch (feature branch — mandatory)

- **Default branch:** `master` (via `git symbolic-ref refs/remotes/origin/HEAD`) — **[GROUNDED]**
- **Upstream reality (verified 2026-08-27):** KIT-V13-001 **is already merged** to `origin/master` via **PR #14** (`e3b98b1`). Kit v1.3.0 is live; `templates/AUDIT_CONTRACT.md` present on master. Local `master` is **2 commits behind** and local `FEATURES.json` still reads `PENDING_REVIEW` — ledger drift, not a blocker — **[GROUNDED]**
- **Proposed feature branch:** `feat/kit-erd-001-product-erd-profile`
- **Base:** stacked on `feat/kit-skills-001-templates-to-skills` (`2b37249`). KIT-SKILLS-001 is
  PENDING_REVIEW and unmerged, and this work needs the v2.0 skill layout that exists only there.
  **Rebase onto `master` once KIT-SKILLS-001 merges.**
- **Human confirmed:** **pending — agent asks before checkout.**

---

## Decisions

| Topic | Decision | Status |
|-------|----------|--------|
| Home of the ERD process | **harness-kit core** — part of the default spine, not an opt-in pack | Locked (David, 2026-08-27) |
| Deliverable set | **`erd.md` + `architecture.md`** pair, matching the order-service precedent | Locked (David, 2026-08-27) |
| Interaction model | **Progressive, human-gated stages** S0–S4 | Locked (David, 2026-08-27) |
| Governance | **New `product-erd` work-type profile**, governed by the contract system | Locked (David, 2026-08-27) |
| Profile name | `product-erd` | Open — **Q2** |
| ERD → contract bridge | S4 emits a `FEATURES.json` seed block, one entry per slice; each becomes one sprint contract | Locked |
| Org standards | Stay in consumer `AGENTS.md` / docs pack; kit references, never names them | Locked |
| Slice ordering | Slices written last; slice 1 = scaffolding for deployable services, N/A otherwise | Locked |
| `openapi.yaml` | **Not** an ERD-stage deliverable — it churned across ORDER-SVC-014/016 as decisions moved. Freeze it in a later `http-api` contract | Locked |
| Amendment change-log | Not this sprint | Open — **Q3** |
| Base branch | Updated `master` (v1.3 already merged, PR #14) | Locked |

---

## Tests first (TDD)

**N/A** — documentation/process sprint, no behaviour change. Per kit law, VERIFY uses falsifiable deterministic checks (below), not application tests.

- **Expected RED (today):**
  - `grep -q 'product-erd' templates/AGENT_PROCESS.md` → fails
  - `test -f templates/ERD.md` → fails
  - `test -f templates/ARCHITECTURE.md` → fails
  - `test -f templates/ERD_CONTRACT.md` → fails
  - `grep -q '1.4.0' BOOTSTRAP.md` → fails

---

## Impact map

| Path | Change | Grounding |
|------|--------|-----------|
| `skills/erd-authoring/SKILL.md` | **NEW** | [NEW] |
| `skills/erd-authoring/templates/ERD_CONTRACT.md` | **NEW** — staged gate log | [NEW] |
| `skills/erd-authoring/templates/ERD.md` | **NEW** — ERD skeleton | [NEW] |
| `skills/erd-authoring/templates/ARCHITECTURE.md` | **NEW** — architecture companion | [NEW] |
| `skills/harness-onboard/templates/AGENT_PROCESS.md` | `product-erd` row; ERD stage (S0–S4); depth-matrix row; RESEARCH-vs-ERD separation | [GROUNDED] |
| `skills/harness-onboard/templates/AGENTS.md` | Profile list + ERD pointer | [GROUNDED] |
| `skills/sprint-contract/templates/SPRINT_CONTRACT.md` | Profile checkbox + quality-gate row | [GROUNDED] |
| `skills/harness-review/templates/REVIEW.md` | `product-erd` review row | [GROUNDED] |
| `README.md` | Skills table + profile | [GROUNDED] |
| `scripts/build-bootstrap.sh` | 2.1.0; Appendices N/O/P | [GROUNDED] |
| `BOOTSTRAP.md` | Regenerated (still deprecated) | [GROUNDED] |
| `README.md`, `templates/README_POINTER.md` | Mention profile + ERD stage | [GROUNDED] |
| `FEATURES.json` (root) | Add `KIT-ERD-001` | [GROUNDED] |

**Reuse (do not reinvent):** `AUDIT_CONTRACT.md` structure for `ERD_CONTRACT.md`; the ORDER-SVC grep-VERIFY idiom; the erd-authoring section flow and slice-table rules (**re-expressed stack-neutrally — not copied verbatim**, since the source is tao.com-coupled).

---

## Success criteria

1. `product-erd` appears as a profile in `AGENT_PROCESS.md`, `AGENTS.md`, and `SPRINT_CONTRACT.md`.
2. `templates/ERD.md`, `templates/ARCHITECTURE.md`, `templates/ERD_CONTRACT.md` all exist.
3. `AGENT_PROCESS.md` documents stages **S0–S4** with an explicit human gate between each, and states the agent stops at every gate.
4. `AGENT_PROCESS.md` states slices are written **last** and that S4 emits a `FEATURES.json` seed block, one entry per slice.
5. `AGENT_PROCESS.md` contains an explicit **skip rule** for the ERD stage and distinguishes it from optional RESEARCH.
6. Kit neutrality holds: no `HAL|RFC 9457|hexagonal|New Relic` in the ERD or architecture forms.
7. The ERD form contains the heading `## Implementation plan: Feature slices` verbatim.
8. The `sprint-contract` and `harness-review` forms each carry a `product-erd` line.
9. Kit version `2.1.0`; regenerated `BOOTSTRAP.md` contains `ERD_CONTRACT`; `erd-authoring` has valid frontmatter.
10. `./scripts/build-bootstrap.sh` exits 0; both `FEATURES.json` files parse.
11. Diff confined to the impact map; `git status` shows only those paths.
12. All work on the confirmed feature branch — not `master`.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria (always required) — see VERIFY
- [ ] Trust-boundary failure mode — **N/A** (docs-only)
- [ ] Partial/optional deps — **N/A**
- [ ] `http-api` schema/envelope — **N/A**
- [ ] `solidity-build` — **N/A**
- [ ] `solidity-audit` — **N/A**
- [ ] No consumer-repo edits — asserted in Scope/will NOT

## Edge cases / failure modes

| Risk | Mitigation |
| --- | --- |
| ERD stage becomes mandatory ceremony on small features | Explicit skip rule + depth-matrix row (§D9); "build to delete" cited |
| Kit accretes tao.com standards through the ERD template | Success criterion 6 is a hard grep gate |
| Gates get skipped and S0–S4 collapse into one draft | `ERD_CONTRACT.md` carries a gate log with a human sign-off line per stage |
| ERD and sprint contracts drift after implementation starts | Partially unmitigated this sprint — see **Q3** |
| Two competing approved artifacts (ERD *and* a `plan.md`) | §D10 states RESEARCH and the ERD stage must not be dual-run |
| Slices written before design settles (the erd-authoring failure mode) | §C7 + success criterion 4 |

## Threat model

**SKIP** — documentation/process only; no runtime surface, no credentials, no side effects.

---

## Blocking questions (gates)

**Q1 — RESOLVED (was: base branch).** v1.3 is already merged (PR #14). Branch from an updated `master`; no stacking needed. Residual action: pull local `master`, and set `KIT-V13-001` to `PASS` in root `FEATURES.json` so the ledger matches reality.

**Q2 — Profile name.** `product-erd` vs `discovery` vs plain `erd`.
- **Recommendation:** `product-erd` — says what it produces, and reads correctly for a feature-level ERD as well as a whole product.

**Q3 — Amendment change-log.** Your docs repo has `engineering-amendment-change-log` for when implementation diverges from an ERD. ORDER-SVC-009 and 015 were reversals, so this path is real. Ship `templates/ERD_AMENDMENT.md` in this sprint, or defer to `KIT-ERD-002`?
- **Recommendation:** defer to `KIT-ERD-002` — "one thing at a time." This sprint adds a one-line pointer in `templates/ERD.md` so the seam exists.

**Q4 — Slice-1 scaffolding rule.** The tao.com skill hardcodes "slice 1 is always scaffolding + K8s probes." The kit is stack-neutral and covers Solidity and libraries.
- **Recommendation:** as drafted in §C7 — slice 1 is scaffolding *for deployable services*, explicitly N/A otherwise, with the probe specifics left to the consumer's `AGENTS.md`.

*Approve only if Q1–Q4 (or your edits) are acceptable.*

---

## VERIFY (run after EXECUTE)

```bash
cd "$HOME/mnt/harness-kit"

# profile registered in all three places
grep -q 'product-erd' templates/AGENT_PROCESS.md
grep -q 'product-erd' templates/AGENTS.md
grep -q 'product-erd' templates/SPRINT_CONTRACT.md
grep -q 'product-erd' templates/REVIEW.md

# new templates exist
test -f templates/ERD.md
test -f templates/ARCHITECTURE.md
test -f templates/ERD_CONTRACT.md

# staged, gated EXECUTE documented
grep -q 'S0' templates/AGENT_PROCESS.md
grep -q 'S4' templates/AGENT_PROCESS.md
grep -qi 'human gate' templates/AGENT_PROCESS.md

# ERD -> contract bridge + slices last
grep -qi 'seed' templates/AGENT_PROCESS.md
grep -q 'Implementation plan: Feature slices' templates/ERD.md
grep -qi 'skip' templates/AGENT_PROCESS.md

# gate log present in the ERD contract template
grep -qi 'gate log\|Gate log' templates/ERD_CONTRACT.md

# kit neutrality — org standards must NOT leak into kit templates
! grep -Eqi 'HAL|RFC 9457|hexagonal|New Relic' templates/ERD.md
! grep -Eqi 'HAL|RFC 9457|hexagonal|New Relic' templates/ARCHITECTURE.md

# version + bootstrap regen
grep -q '1.4.0' BOOTSTRAP.md
grep -q '1.4.0' scripts/build-bootstrap.sh
./scripts/build-bootstrap.sh
grep -q 'ERD_CONTRACT' BOOTSTRAP.md
grep -q '1.4.0' BOOTSTRAP.md

# json validity + feature entry
python3 -m json.tool FEATURES.json >/dev/null
python3 -m json.tool templates/FEATURES.json >/dev/null
grep -q 'KIT-ERD-001' FEATURES.json

# branch discipline
git branch --show-current | grep -qv '^master$'
```

---

## FEATURES.json entry

```json
{
  "id": "KIT-ERD-001",
  "name": "product-erd profile + staged ERD authoring stage (erd.md + architecture.md) feeding FEATURES seed",
  "priority": 1,
  "verify": "grep -q product-erd templates/AGENT_PROCESS.md && test -f templates/ERD.md && test -f templates/ARCHITECTURE.md && test -f templates/ERD_CONTRACT.md && grep -q '1.4.0' BOOTSTRAP.md && ./scripts/build-bootstrap.sh >/dev/null && python3 -m json.tool FEATURES.json >/dev/null",
  "status": "FAIL",
  "notes": "Contract: skills/.harness/contracts/KIT-ERD-001.md; profile: ops-docs; depends on KIT-V13-001"
}
```

---

## Criteria block

```criteria
- [KIT-ERD-001-1] product-erd registered in AGENT_PROCESS, AGENTS, SPRINT_CONTRACT, REVIEW
- [KIT-ERD-001-2] templates/ERD.md, ARCHITECTURE.md, ERD_CONTRACT.md exist
- [KIT-ERD-001-3] Stages S0-S4 documented with a human gate between each
- [KIT-ERD-001-4] Slices written last; S4 emits FEATURES.json seed, one entry per slice
- [KIT-ERD-001-5] Explicit ERD-stage skip rule; distinguished from optional RESEARCH
- [KIT-ERD-001-6] Kit neutrality: no org-specific standards in ERD/ARCHITECTURE templates
- [KIT-ERD-001-7] Version 1.4.0; Appendices K/L/M; build-bootstrap.sh green; FEATURES.json valid
```

---

## Deviations / clarifications

| # | Item | Resolution |
|---|------|------------|
| 1 | Contract (pre-v2.0) specified `templates/ERD.md`, `ARCHITECTURE.md`, `ERD_CONTRACT.md` and Appendices K/L/M | Revised to the v2.0 skill shape before execution: `skills/erd-authoring/` with the three forms bundled, Appendices **N/O/P**, version **2.1.0**. Recorded in the contract header. |
| 2 | Skill name is `erd-authoring`; profile is `product-erd` | Deliberate. Not every skill maps to a profile (`sprint-contract`, `harness-onboard`, `security-checklist`, `harness-review` have none), and `erd-authoring` names the activity while `product-erd` names the work type. Both files state the relationship. |
| 3 | VERIFY expected the literal phrase "stops at every gate" in `SKILL.md`, which said "stops and waits at each gate" | Semantically identical; phrasing aligned across both files rather than loosening the check — consistent vocabulary is worth having. |

## Q2–Q4 as executed

- **Q2 profile name:** `product-erd` (recommended).
- **Q3 amendment change-log:** deferred to `KIT-ERD-002` as recommended; the seam exists — divergence from the declared standards pack is recorded in Design Decisions.
- **Q4 slice-1 rule:** scaffolding for deployable services, explicitly **N/A** for library / contract / docs targets, with probe specifics left to the consumer's `AGENTS.md`.

## Note

Stacked on `feat/kit-skills-001-templates-to-skills`, which is PENDING_REVIEW and unmerged.
**Rebase onto `master` once KIT-SKILLS-001 merges.**
