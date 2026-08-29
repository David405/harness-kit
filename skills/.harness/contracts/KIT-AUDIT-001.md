# SPRINT CONTRACT — KIT-AUDIT-001: `code-audit` profile (periodic whole-project quality audit)

> Status: **EXECUTE complete — VERIFY green (24/24) — PENDING_REVIEW.**
> Approved: David 2026-08-27 ("proceed") with recommended answers to Q1–Q4.
> Branch `feat/kit-audit-001-code-audit-profile` from `master` @ `a3af45f`. Version **1.5.0**.
> Feature ID: `KIT-AUDIT-001`
> Repo: **harness-kit only**
> Branch: proposed `feat/kit-audit-001-code-audit-profile` — **human must confirm before checkout**
> Trigger: David (2026-08-27) — "a once in a while behaviour to check for the overall code quality of a project… name that as a separate skill in our harness-kit."

---

## Work-type profile (required)

- [x] `ops-docs` — process/templates change to the kit itself

**Languages / toolchain:** Markdown + POSIX sh. No application code.

> This sprint **adds** the `code-audit` profile. The sprint itself runs under `ops-docs`.

---

## Context (grounded)

| Source | Finding |
| --- | --- |
| `templates/CODE_QUALITY.md` (v1.4, KIT-QUALITY-001) | Per-sprint **gate**: diff-scoped, lint-first, blocking, cheap enough to run every contract. Deliberately narrow. |
| `templates/AUDIT_CONTRACT.md` + `AUDIT_FINDING.md` | Existing precedent for a **periodic, report-producing, code-changing-nothing** profile (`solidity-audit`). Finding template already carries ID / Severity / Status / commit-tag / location. |
| `templates/AGENT_PROCESS.md` §Work-type profiles | Five profiles; profile drives which gates are in force vs N/A. |
| `templates/AGENT_PROCESS.md` §Build to delete / Cost reality | "A full harness costs more per run… choose depth per the matrix." A whole-repo audit is expensive by design and must be explicitly periodic, never per-sprint. |
| Supplied review brief (David, 2026-08-27) | 15 review categories, severity/confidence/regression-risk rubrics, behavioural-equivalence checklist, 5-phase workflow, 11-section report format. |

**Gap:** the kit has a per-diff quality gate and a Solidity security audit, but nothing that steps back
and assesses **a whole codebase's quality** on a cadence. Nothing carries the behaviour-preservation
discipline that makes large-scale refactoring safe.

**Out of scope by correction (David):** the kit must not reference any pack's skills. The kit is
pack-agnostic; optional packs may add their own passes and the kit says nothing about them.

---

## Decisions

| Topic | Decision | Status |
|-------|----------|--------|
| Form | **Work-type profile + contract template**, not a "skill" — the kit's idiom. Parallel to `solidity-audit`. | Locked |
| Name | **`code-audit`** — reads consistently beside `solidity-audit` | Locked |
| Cadence | **Periodic, never per-sprint.** Explicitly not a gate; does not run at VERIFY. | Locked |
| Relationship to `CODE_QUALITY.md` | Two different instruments, stated plainly in both files: the **gate** answers "can this diff ship?"; the **audit** answers "where should we invest refactoring effort?" | Locked |
| Behaviour preservation | **The absolute constraint of the profile.** Made deterministic: characterization tests captured **before** the refactor (passing against current code, proving they encode today's behaviour) and still passing after. | Locked |
| Taxonomy home | **In the kit's contract template.** It is language-neutral — feature envy, primitive obsession, stale comments are not stack-specific, unlike thresholds (which we deliberately kept out in v1.4). The kit cannot depend on a pack existing. | Locked |
| Findings → work | Each accepted finding seeds a **`FEATURES.json`** entry, which becomes a sprint contract. An audit whose findings are not tracked is a document nobody acts on. | Locked |
| Audit changes code | **No.** Like `solidity-audit`, the audit produces findings only. Fixes are separate contracts. | Locked |
| Second profile for fixes? | **No.** Fixes run under existing profiles plus one new quality-gate row for behaviour-preserving work. One new profile, not two. | Locked |
| Severity scale | Reuse the kit's existing **Critical / High / Medium / Low / Informational** from `AUDIT_FINDING.md` — do not introduce a third vocabulary. | Locked |

---

## Scope — WILL do

### A — Profile

1. Add **`code-audit`** to the profile tables in `templates/AGENT_PROCESS.md`, `templates/AGENTS.md`,
   `templates/SPRINT_CONTRACT.md`, and the profile-emphasis table in `templates/REVIEW.md`.
2. Mark the per-sprint gates **N/A** for `code-audit` (it ships no code): TDD, `CODE_QUALITY.md`,
   http-api schema, Solidity gates.
3. Add a **depth-matrix row**: `code-audit` — periodic (per milestone / quarter / pre-hardening),
   never triggered by an ordinary feature.

### B — `templates/CODE_AUDIT_CONTRACT.md` (NEW)

4. Scope in/out: paths, modules, languages, **commit or tag audited** (findings are meaningless
   without the ref), and explicit exclusions (generated, vendored, migrations, fixtures).
5. **Behavioural constraint section** — "refactor implementation, not behaviour", with the frozen-contract
   list (public APIs, exported symbols, CLI args, env vars, config keys, DB schema/values, serialized
   formats, events, queue payloads, routes, status codes, headers, error formats, user-facing strings
   consumers depend on) and the behavioural-equivalence checklist.
6. **Review taxonomy** — the 15 categories, condensed to a checklist the auditor works through:
   best practices; duplication (harmful vs acceptable); optimisation; code smells; comments; readability;
   maintainability; function quality; conditional logic; error handling; data flow and state; tests and
   regression risk; dead code; over-engineering; under-engineering.
7. **Rubrics** — Severity (reuse existing scale); **Confidence** High/Medium/Low; **Regression risk**
   Very Low/Low/Medium/High. Prioritise by *impact × confidence ÷ regression risk*.
8. **Workflow** — Understand → Identify → Validate → Prioritise → Recommend. Validation before reporting
   is mandatory: check call sites, imports, consumers, tests, framework registration before a finding stands.
9. **False-positive discipline** — a finding must meet at least one materiality test; unconventional but
   clear, safe, locally appropriate code is not a finding. Minimal-diff principle: smallest change that
   achieves a meaningful improvement; no cascading refactors.
10. **Report shape** — executive summary; prioritised findings; duplication table; comment-quality report;
    readability hotspots; maintainability hotspots; optimisation (safe vs profiling-required);
    safe refactors; **refactors not to attempt yet**; suggested sequence; verification checklist.
11. **Finding ID scheme** — `<AUDIT-ID>-F<nn>`, same shape as the Solidity audit.
12. **`FEATURES.json` seed block** — one entry per accepted finding, `status: FAIL`, `verify` written from
    the repo's `AGENTS.md` runner. This is the audit → contract bridge.
13. **Separate reporting for suspected functional bugs** — reported, never fixed inside the audit.
14. A short, explicit contrast with `CODE_QUALITY.md` so the two are never confused.

### C — `templates/CODE_AUDIT_FINDING.md` (NEW)

15. Extend the `AUDIT_FINDING.md` shape with: **Category**, **Confidence**, **Regression risk**,
    **Recommended change** (smallest safe), **Behavioural safety** (what must be verified),
    and **Characterization tests required**. Keep ID / Severity / Status / parent / commit / location.

### D — Behaviour-preserving refactor gate

16. `templates/SPRINT_CONTRACT.md` — one new quality-gate row:
    *behaviour-preserving refactor only: characterization tests captured and passing **before** the
    change; the same tests pass after; declared frozen contracts untouched — or **N/A***.
17. `templates/AGENT_PROCESS.md` §6 EXECUTE — one line: for behaviour-preserving refactor work,
    characterization tests replace product TDD as the RED/GREEN mechanism, mirroring the existing
    PoC-first rule for audits.

### E — Version, docs, bootstrap

18. **Appendix L** (`CODE_AUDIT_CONTRACT.md`) and **Appendix M** (`CODE_AUDIT_FINDING.md`) in
    `scripts/build-bootstrap.sh`; Step 0 path table `Appendices B–M`.
19. Version bump + changelog bullet — see **Q1** for the number.
20. Add `KIT-AUDIT-001` to root `FEATURES.json`; re-run `./scripts/build-bootstrap.sh`.

## Scope — will NOT do (this sprint)

- Reference, absorb, or reconcile any pack's skills. The kit is pack-agnostic (David, 2026-08-27).
- Put language-specific thresholds, linters, or tool mandates in the kit.
- Add a second profile for implementing findings — existing profiles plus one gate row cover it.
- Change `CODE_QUALITY.md`, the v1.4 gate, or any existing profile's behaviour.
- Introduce a third severity vocabulary.
- Run an actual audit on any repo.
- Modify any consumer repo.

## Target

- **Repo / package:** `harness-kit`.
- **Not touching:** consumer repos; any pack repo; application source.

---

## Branch (feature branch — mandatory)

- **Default branch:** `master` — **[GROUNDED]**
- **Base:** `master` @ `a3af45f` (PR #15 merged; v1.4.0 live, `templates/CODE_QUALITY.md` present) — **[GROUNDED]**
- **Proposed feature branch:** `feat/kit-audit-001-code-audit-profile`
- **Human confirmed:** yes — "proceed" (2026-08-27)

---

## Tests first (TDD)

**N/A** — documentation/process sprint. VERIFY uses falsifiable deterministic checks.

- **Expected RED (today):**
  - `test -f templates/CODE_AUDIT_CONTRACT.md` → fails
  - `test -f templates/CODE_AUDIT_FINDING.md` → fails
  - `grep -q 'code-audit' templates/AGENT_PROCESS.md` → fails

---

## Impact map

| Path | Change | Grounding |
|------|--------|-----------|
| `templates/CODE_AUDIT_CONTRACT.md` | **NEW** | [NEW] |
| `templates/CODE_AUDIT_FINDING.md` | **NEW** | [NEW] |
| `templates/AGENT_PROCESS.md` | `code-audit` profile row; depth-matrix row; N/A gates; EXECUTE characterization-test line | [GROUNDED] |
| `templates/AGENTS.md` | Profile list | [GROUNDED] |
| `templates/SPRINT_CONTRACT.md` | Profile checkbox + behaviour-preserving refactor gate row | [GROUNDED] |
| `templates/REVIEW.md` | `code-audit` row in the profile-emphasis table | [GROUNDED] |
| `scripts/build-bootstrap.sh` | Appendices L + M; Step 0 path table | [GROUNDED] |
| `BOOTSTRAP.md` | Regenerated; version + changelog | [GROUNDED] |
| `FEATURES.json` (root) | Add `KIT-AUDIT-001` | [GROUNDED] |

**Reuse:** `AUDIT_CONTRACT.md` structure and severity scale; `AUDIT_FINDING.md` meta block. Extend, do not fork.

---

## Success criteria

1. `code-audit` appears in the profile tables of `AGENT_PROCESS.md`, `AGENTS.md`, `SPRINT_CONTRACT.md`, `REVIEW.md`.
2. `templates/CODE_AUDIT_CONTRACT.md` and `templates/CODE_AUDIT_FINDING.md` exist.
3. The contract template states the behavioural constraint and carries the frozen-contract list and equivalence checklist.
4. All 15 review categories are present as a worked checklist.
5. Severity / Confidence / Regression-risk rubrics present; prioritisation formula stated; severity scale matches `AUDIT_FINDING.md` (no third vocabulary).
6. Template requires the audited **commit or tag** to be recorded.
7. Template contains a `FEATURES.json` seed block, one entry per accepted finding.
8. Template states the audit changes no code, and reports suspected functional bugs separately without fixing them.
9. Both `CODE_AUDIT_CONTRACT.md` and `CODE_QUALITY.md` state the gate-vs-audit distinction.
10. `SPRINT_CONTRACT.md` carries the behaviour-preserving refactor gate row with an explicit **N/A** path.
11. Kit neutrality: no linter names, thresholds, or pack references in either new template.
12. `grep -ri 'ponytail' templates/` returns **no matches**.
13. Bootstrap regenerates clean; `BOOTSTRAP.md` contains `CODE_AUDIT_CONTRACT`; both `FEATURES.json` parse.
14. Diff confined to the impact map; work on the confirmed feature branch.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria — see VERIFY
- [ ] Trust-boundary / partial deps / http-api / solidity — **N/A** (docs-only)
- [ ] Code-quality gate — **N/A** (`ops-docs`)
- [ ] Behaviour-preserving refactor gate — **N/A** (no code)

## Edge cases / failure modes

| Risk | Mitigation |
| --- | --- |
| Confused with the v1.4 per-sprint gate (both say "quality") | Success criteria 9: an explicit contrast paragraph in **both** files |
| Audit run every sprint; cost explodes | Depth-matrix row marks it periodic; §Cost reality already warns |
| Findings rot unread | Seed block turns accepted findings into `FEATURES.json` entries (§B12) |
| Auditor "fixes" a functional bug mid-audit | §B13 — report separately, never fix |
| Refactors ship without equivalence proof | Characterization-test gate row (§D16/17) |
| Taxonomy becomes a nit generator | False-positive materiality test + minimal-diff principle (§B9) |
| Kit accretes pack coupling | Success criterion 12 is a grep gate |

## Threat model

**SKIP** — documentation/process only.

---

## Blocking questions (gates)

**Q1 — RESOLVED.** KIT-QUALITY-001 merged via **PR #15** (`a3af45f`); kit v1.4.0 live with
`templates/CODE_QUALITY.md` present. This branches from updated `master` and takes **1.5.0**.
KIT-ERD-001 rebases and takes 1.6.0.

**Q2 — Audit scope default.** Whole repo, or one declared subsystem per audit?
- **Recommendation:** the contract **requires** a declared scope — paths/modules plus commit or tag.
  "Whole repo" is allowed but must be stated deliberately, because on a large codebase it produces a
  report too big to act on. Mirrors `AUDIT_CONTRACT.md`'s scope-in/out discipline.

**Q3 — Who accepts a finding into `FEATURES.json`?** Auditor seeds all, or human triages first?
- **Recommendation:** the audit **proposes** the seed block; the **human** accepts findings into the
  ledger. Consistent with `PASS` being human-only, and stops a long report flooding the tracker.

**Q4 — Cadence.** Leave it to each repo's `AGENTS.md`, or state a kit default?
- **Recommendation:** leave it to the repo, with the depth matrix naming the usual triggers
  (milestone, quarter, pre-hardening, pre-handover, before a large refactor). The kit should not
  impose a calendar.

*Approve only if Q1–Q4 (or your edits) are acceptable.*

---

## VERIFY (run after EXECUTE)

```bash
cd "$HOME/mnt/harness-kit"

# profile registered
grep -q 'code-audit' templates/AGENT_PROCESS.md
grep -q 'code-audit' templates/AGENTS.md
grep -q 'code-audit' templates/SPRINT_CONTRACT.md
grep -q 'code-audit' templates/REVIEW.md

# new templates
test -f templates/CODE_AUDIT_CONTRACT.md
test -f templates/CODE_AUDIT_FINDING.md

# behavioural spine
grep -qi 'refactor implementation, not behaviour' templates/CODE_AUDIT_CONTRACT.md
grep -qi 'characterization' templates/CODE_AUDIT_CONTRACT.md
grep -qi 'characterization' templates/SPRINT_CONTRACT.md
grep -qi 'frozen' templates/CODE_AUDIT_CONTRACT.md

# rubrics + prioritisation, single severity vocabulary
grep -qi 'confidence' templates/CODE_AUDIT_FINDING.md
grep -qi 'regression risk' templates/CODE_AUDIT_FINDING.md
grep -qi 'Informational' templates/CODE_AUDIT_FINDING.md
! grep -qi 'Major / Minor' templates/CODE_AUDIT_FINDING.md

# audit hygiene
grep -qi 'commit\|tag' templates/CODE_AUDIT_CONTRACT.md
grep -qi 'FEATURES.json' templates/CODE_AUDIT_CONTRACT.md
grep -qi 'not part of this refactor\|report separately' templates/CODE_AUDIT_CONTRACT.md

# gate vs audit distinction stated in both
grep -qi 'CODE_QUALITY' templates/CODE_AUDIT_CONTRACT.md
grep -qi 'CODE_AUDIT' templates/CODE_QUALITY.md

# neutrality: no tools, no pack coupling
! grep -Eqi 'eslint|golangci|clippy|solhint' templates/CODE_AUDIT_CONTRACT.md
! grep -riq 'ponytail' templates/

# bootstrap + json
./scripts/build-bootstrap.sh
grep -q 'CODE_AUDIT_CONTRACT' BOOTSTRAP.md
python3 -m json.tool FEATURES.json >/dev/null
grep -q 'KIT-AUDIT-001' FEATURES.json
git branch --show-current | grep -qv '^master$'
```

---

## FEATURES.json entry

```json
{
  "id": "KIT-AUDIT-001",
  "name": "code-audit profile: periodic whole-project quality audit with behaviour-preservation discipline",
  "priority": 2,
  "verify": "test -f templates/CODE_AUDIT_CONTRACT.md && test -f templates/CODE_AUDIT_FINDING.md && grep -q code-audit templates/AGENT_PROCESS.md && grep -qi characterization templates/SPRINT_CONTRACT.md && ./scripts/build-bootstrap.sh >/dev/null && python3 -m json.tool FEATURES.json >/dev/null",
  "status": "FAIL",
  "notes": "Contract: skills/.harness/contracts/KIT-AUDIT-001.md; profile: ops-docs; depends on KIT-QUALITY-001 (CODE_QUALITY.md must exist)"
}
```

---

## Criteria block

```criteria
- [KIT-AUDIT-001-1] code-audit profile registered in AGENT_PROCESS, AGENTS, SPRINT_CONTRACT, REVIEW
- [KIT-AUDIT-001-2] CODE_AUDIT_CONTRACT.md and CODE_AUDIT_FINDING.md exist
- [KIT-AUDIT-001-3] Behavioural constraint, frozen-contract list, equivalence checklist present
- [KIT-AUDIT-001-4] All 15 review categories present as a worked checklist
- [KIT-AUDIT-001-5] Severity/Confidence/Regression rubrics; single severity vocabulary; prioritisation formula
- [KIT-AUDIT-001-6] Audited commit/tag required; FEATURES seed block present; functional bugs reported not fixed
- [KIT-AUDIT-001-7] Gate-vs-audit distinction in both files; characterization-test gate row in SPRINT_CONTRACT
- [KIT-AUDIT-001-8] No tool names, no thresholds, no pack references anywhere in templates/
```

---

## Deviations from the approved contract (declare, do not hide)

| # | Contract said | Actually done | Why | Verdict |
|---|---------------|---------------|-----|---------|
| 1 | Impact map listed `templates/AGENT_PROCESS.md` and `templates/AGENTS.md` for profile wiring only | Also removed the **pre-existing** named-pack references from both (`agent-harness`, `ponytail` → generic wording); `templates/CODE_QUALITY.md` gained the audit cross-reference | Success criterion 12 (`grep -ri 'ponytail' templates/` → no matches) failed on **v1.3 text already on master**, not on anything this contract added. The named references contradict the pack-agnostic rule David stated on 2026-08-27. Meaning preserved exactly: "a shared agent-harness submodule" → "a shared skills submodule"; "ponytail simplicity" → "simplicity passes". | **Declared scope expansion** — corrective, zero behavioural risk, one revert if unwanted |

`templates/CODE_QUALITY.md` was always implied by §B14 ("an explicit contrast with `CODE_QUALITY.md`")
but was omitted from the impact-map table. Listed here for completeness.

## VERIFY result

24/24 green, including the neutrality gates (no tool names in the audit contract; no named-pack
references anywhere in `templates/`) and a structural check that all 15 taxonomy categories are present.

## Note for the human

`KIT-QUALITY-001` is still `PENDING_REVIEW` in `FEATURES.json` although PR #15 is merged.
**`PASS` is human-only** — deliberately left for David rather than repeating the undeclared
ledger edit made under KIT-QUALITY-001.
