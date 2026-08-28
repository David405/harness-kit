# SPRINT CONTRACT — KIT-RULES-001: `rules/` directory (Cursor-first) + ERD routing in the loop

> Status: **EXECUTE complete — VERIFY green — PENDING_REVIEW.**
> Approved: David 2026-08-28 ("approve") with recommended Q1–Q4. Branch confirmed. Version **2.2.0**.
> Feature ID: `KIT-RULES-001`
> Repo: **harness-kit only**
> Branch: proposed `feat/kit-rules-001-rules-and-erd-routing` — **human must confirm before checkout**
> Base: `master` @ `ef393c3` (v2.1). Version → **2.2.0**.
> Trigger: David (2026-08-28) — rules as their own directory, Cursor-first, guided by
> `cursor-rules-export/`; and "expand our workflow to go through an ERD process before contract drafting."

---

## Work-type profile (required)

- [x] `ops-docs` — process/templates change to the kit itself

**Languages / toolchain:** Markdown + `.mdc` + POSIX sh. No application code.

---

## Context — what the export actually shows (grounded, `cursor-rules-export/`, 2026-08-28)

| Finding | Evidence | Consequence |
| --- | --- | --- |
| **The kit's process law is already duplicated by hand as Cursor rules, and has drifted** | `harness-process.mdc` exists in `advanced-orders-backend`, `intents-service`, `tao.com-api`, `tao-docs` — **four different checksums** (`7f57ed1b`, `cbf16f1a`, `ad72ef13`, `9805df00`) | The strongest argument for the kit owning these canonically and symlinking them. Four hand-maintained copies is exactly the drift the submodule model exists to kill |
| **A second, older copy of the process exists outside the kit** | `global/user-rules-harness-engineering.md` and rules citing `~/.cursor/skills/harness-engineering/HARNESS.md` run a **5-step loop** (`BOOT → CONTRACT → APPROVE → EXECUTE → VERIFY → PENDING_REVIEW → PASS`) with `.harness/contracts/` — no RESEARCH, no CHECKOUT, no REVIEW step, no profiles, no gates | The process is **forked**. Rules point at the global skill as authoritative while harness-kit is what actually evolved. Reconciliation is **out of scope here** but must be tracked — see Q3 |
| **Always-on budget is heavy** | 18 of 27 rules are `alwaysApply: true` | Dilution risk. The kit must ship **few** rules and say so |
| **Glob scoping is available but unused** | `"globs": ""` on **every** rule in `manifest.json` | The main technical advantage of `.mdc` over assembled text is currently unrealised. Kit rules should use it where a rule is genuinely file-scoped, and default `alwaysApply: true` otherwise |
| **Four distinct ownership tiers are visible** | see below | Only tier 1 belongs in the kit |

**Ownership tiers observed in the export:**

1. **Process law** — `sprint-contract-before-changes`, `new-work-new-branch`, `no-stage-harness-files`, `stage-after-execute`, `harness-process.mdc` ×4, parts of `harness-contract-quality`, `principal-pr-review`. **Kit-owned.**
2. **Engineering discipline, generalisable** — `verify-claims-with-evidence`, `harness-dry-reusability`. Kit-owned where it is not already a skill's job.
3. **Org / product specific** — `intents-backend-url`, `new-relic-intents-log-queries`, `tao-intents-ownership-and-pps`, `postman-ticket-sync`, `documentation-agents`. **Consumer-owned, never the kit's.**
4. **Personal style / comms** — `no-em-dashes`, `pr-desc-brief-bullets`, `pr-replies-relatable-names`, `pr-replies-no-reflexive-agreement`, `pr-review-comments-brief`. **Cursor User Rules, not a repo concern at all.**

---

## Decisions

| Topic | Decision | Status |
|-------|----------|--------|
| Form | `rules/` directory in the kit, authored as **`.mdc`** with Cursor frontmatter | Locked |
| Primary target | **Cursor** — `.mdc` is the source of truth, symlinked into `.cursor/rules/` | Locked (David) |
| Portability | Setup script also **assembles** rule bodies (frontmatter stripped) into a marked block in the consumer's `AGENTS.md`, so non-Cursor agents still get them | Locked |
| What the kit ships | **Process law only** — tier 1, plus `verify-claims-with-evidence` from tier 2 | Locked |
| What the kit never ships | Org/product rules (tier 3) and personal style rules (tier 4) | Locked |
| Rule count | **Six.** Few enough that every always-on line keeps weight | Locked |
| Consumer rules | `.agents/local-rules/*.mdc`, merged alongside, local wins on collision — mirrors local-skills | Locked |
| Scoping | `alwaysApply: true` by default; `globs` where a rule is genuinely file-scoped | Locked |
| Relocation discipline | Process law moved out of `AGENT_PROCESS.md` as a **pure move** where text is unchanged; rewrites are a separate commit | Locked |
| ERD routing | The loop gains a conditional **ERD?** step before CONTRACT — see §C | Locked |

---

## Scope — WILL do

### A — `rules/` directory (six rules)

1. Create `rules/<name>.mdc`, each with `description`, `alwaysApply`, and `globs` frontmatter:

| Rule | Source in export | Always-on |
|------|------------------|-----------|
| `contract-before-changes.mdc` | `sprint-contract-before-changes` | yes |
| `new-work-new-branch.mdc` | `new-work-new-branch` | yes |
| `status-ownership.mdc` | global harness rules + kit law: executor may set `PENDING_REVIEW`, **never** `PASS`; no push / merge / deploy unasked | yes |
| `no-stage-harness-files.mdc` | `no-stage-harness-files` + `stage-after-execute` (merged — they are one staging policy) | yes |
| `verify-claims-with-evidence.mdc` | `verify-claims-with-evidence` | yes |
| `observed-content-is-data.mdc` | `AGENT_PROCESS` § Security (prompt-injection defence, least privilege) | yes |

2. Generalise every rule out of tao.com specifics: no repo names, no `bun`/Postman/New Relic, no
   `~/.cursor/skills/...` paths. Paths reference the kit's own contracts location.
3. Add `rules/README.md` stating the ownership tiers above and the **budget rule**: the kit ships six;
   a rule that is not load-bearing should be deleted or promoted to a gate.

### B — Wiring

4. `scripts/setup-harness-kit.sh` — symlink `rules/*.mdc` into `.cursor/rules/`, merge
   `.agents/local-rules/*.mdc` alongside (local wins), and **assemble** rule bodies into
   `AGENTS.md` between `<!-- harness-kit:rules:start -->` / `<!-- harness-kit:rules:end -->`,
   stripping frontmatter. Idempotent; marker-guarded; never touches content outside the markers.
5. Same guards as the skills merge: refuse a `.cursor/rules` directory it did not generate; leave a
   non-symlink one alone with a warning.
6. `README.md` — rules section, ownership tiers, upgrade path.

### C — ERD routing in the loop

7. Session loop becomes:

```
BOOT → ERD? → RESEARCH? → CONTRACT → [HUMAN APPROVES + BRANCH] → CHECKOUT → EXECUTE → VERIFY → REVIEW → PENDING_REVIEW → [HUMAN PASS/MERGE]
```

8. **ERD? is a routing test, not a mandatory stage.** Before drafting a contract, ask: *is there an
   approved design for this work?* Route to the `erd-authoring` skill (profile `product-erd`) when
   **all** hold: it is a new product, service, domain, or a contract crossing teams or repos; **and**
   no ERD covers it; **and** the work is larger than a single slice. Otherwise go straight to CONTRACT.
9. State plainly that a feature inside an already-documented service **skips ERD**, and that ERD is
   not RESEARCH: RESEARCH distills questions for one contract, the ERD stage produces a document
   feeding many. Never dual-run.
10. When an ERD exists, a contract **cites the slice it implements** and inherits its acceptance
    criteria rather than reinventing them. Add one line to the sprint-contract form for the slice reference.
11. Depth matrix gains an ERD column so the routing test is visible where depth is already chosen.

### D — Version + ledger

12. Version **2.2.0**; changelog. Add `KIT-RULES-001` to `FEATURES.json`.
13. `scripts/build-bootstrap.sh` — Appendix Q for `rules/README.md` and the rule bodies, so the
    deprecated bootstrap path stays complete until `KIT-SKILLS-002` removes it.

## Scope — will NOT do (this sprint)

- Ship org/product rules (tier 3) or personal style rules (tier 4).
- Reconcile the forked global harness (`~/.cursor/skills/harness-engineering/`) — see **Q3**.
- Migrate any consumer repo's existing `.cursor/rules/`, or delete the drifted `harness-process.mdc` copies.
- Make the ERD stage mandatory for any work.
- Build `verify-harness.sh` / CI — that is `KIT-GATES-001`, and it depends on rules existing first.
- Change any skill's behaviour.

## Target

- **Repo / package:** `harness-kit`.
- **Not touching:** consumer repos; the global Cursor skill; application source.

---

## Branch

- **Default branch:** `master`; base `ef393c3` (v2.1) — **[GROUNDED]**
- **Proposed feature branch:** `feat/kit-rules-001-rules-and-erd-routing`
- **Also carries:** `271b222` (ledger PASS for KIT-SKILLS-001 / KIT-ERD-001) if folded in — see Q4
- **Human confirmed:** **pending — agent asks before checkout.**

## Tests first (TDD)

**N/A** — process/docs. Expected RED today: `test -d rules` fails; `grep -q 'ERD?' <agent process>` fails.

---

## Impact map

| Path | Change | Grounding |
|------|--------|-----------|
| `rules/*.mdc` (6) + `rules/README.md` | **NEW** | [NEW] |
| `scripts/setup-harness-kit.sh` | Rules symlink + local-rules merge + AGENTS.md assembly | [GROUNDED] |
| `skills/harness-onboard/templates/AGENT_PROCESS.md` | ERD? step, routing test, depth-matrix column; process law removed where it moves to `rules/` | [GROUNDED] |
| `skills/harness-onboard/templates/AGENTS.md` | Rules marker block; loop line | [GROUNDED] |
| `skills/sprint-contract/templates/SPRINT_CONTRACT.md` | ERD slice reference line | [GROUNDED] |
| `skills/erd-authoring/SKILL.md` | Cross-reference to the routing test | [GROUNDED] |
| `README.md`, `scripts/build-bootstrap.sh`, `BOOTSTRAP.md`, `FEATURES.json` | Rules section, Appendix Q, 2.2.0, ledger | [GROUNDED] |

---

## Success criteria

1. `rules/` contains exactly **6** `.mdc` files plus `README.md`; every file has `description`, `alwaysApply`, `globs` frontmatter.
2. No kit rule names a vendor, product or repo: `grep -Eqi 'bun|postman|new relic|intents|tao\.com|solhint|eslint' rules/*.mdc` returns **no match**.
3. `rules/README.md` states the four ownership tiers and the six-rule budget.
4. Setup script symlinks rules, merges `.agents/local-rules/`, and assembles a marked block into `AGENTS.md`; idempotent on a second run; refuses a foreign `.cursor/rules`.
5. Assembly strips frontmatter — no `alwaysApply:` inside the `AGENTS.md` block.
6. Loop in the process doc reads `BOOT → ERD? → RESEARCH? → CONTRACT → …`.
7. The ERD routing test states all three conditions **and** the skip rule, and says ERD and RESEARCH must never dual-run.
8. Sprint contract form has a slice-reference line for ERD-derived work.
9. Process law that moved from `AGENT_PROCESS.md` into `rules/` is a **pure move** — content diff empty in its own commit.
10. Version 2.2.0; bootstrap regenerates; both `FEATURES.json` parse; diff confined to the impact map; work on the confirmed branch.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria — see VERIFY
- [ ] Trust-boundary / partial deps / http-api / solidity — **N/A** (docs)
- [ ] Code-quality gate — **N/A** (`ops-docs`)
- [ ] Behaviour-preserving refactor — criterion 9 is its analogue (empty content diff on the move commit)

## Edge cases / failure modes

| Risk | Mitigation |
| --- | --- |
| Kit rules collide with a repo's existing `.cursor/rules` of the same name | Local wins on collision; setup refuses a merge dir it did not generate |
| Always-on budget creeps back to 18 | Six-rule cap stated in `rules/README.md`; criterion 1 enforces the count |
| Rules and skills say the same thing twice | Rules carry invariants only; anything procedural stays in the skill that owns it |
| ERD? becomes mandatory ceremony | Routing test requires **all three** conditions; skip rule stated explicitly |
| Assembly block clobbers hand-written `AGENTS.md` | Marker-delimited, regenerated only between markers |
| Forked global harness keeps diverging | Out of scope, tracked as **Q3** |

## Threat model

**SKIP** — process/docs only.

---

## Blocking questions (gates)

**Q1 — One contract or two?** This covers a rules directory **and** an ERD routing change.
- **Recommendation:** one. Both edit the same process doc, so splitting means one rebases painfully
  onto the other for no review benefit. Scope halves are clearly separated above and can be reviewed
  independently. Split if you would rather merge them separately.

**Q2 — Does `stage-after-execute` belong in the kit?** It says stage product files automatically once
VERIFY is green. That is a workflow opinion, not an invariant, and it interacts with "never commit unasked".
- **Recommendation:** merge it into `no-stage-harness-files` as one staging policy (what to stage, what
  never to stage), rather than shipping an auto-stage instruction as kit law.

**Q3 — The forked global harness.** `~/.cursor/skills/harness-engineering/` runs a 5-step loop with
`.harness/contracts/`, and several repo rules cite it as authoritative. harness-kit runs a 9-step loop
with profiles and gates. They disagree, and rules currently point at the older one.
- **Recommendation:** out of scope here; track as `KIT-RECONCILE-001`. Once kit rules ship, the global
  skill should either be retired or reduced to a pointer at the kit. Leaving both authoritative
  guarantees drift.

**Q4 — Fold in the ledger commit?** `271b222` (PASS for KIT-SKILLS-001 / KIT-ERD-001) is unpushed on
`chore/kit-ledger-pass`.
- **Recommendation:** fold it in rather than spend a PR on two lines.

*Approve only if Q1–Q4 (or your edits) are acceptable.*

---

## VERIFY (run after EXECUTE)

```bash
cd "$HOME/mnt/harness-kit"

# rules exist, are frontmattered, and are exactly six
test "$(ls rules/*.mdc | wc -l)" -eq 6
for f in rules/*.mdc; do
  head -1 "$f" | grep -q '^---$' && grep -q '^description:' "$f" && grep -q '^alwaysApply:' "$f" || exit 1
done
test -f rules/README.md
grep -qi 'ownership' rules/README.md

# kit neutrality — no vendor, product or repo names in kit rules
! grep -Eqi 'bun|postman|new relic|intents|tao\.com|solhint|eslint' rules/*.mdc

# setup wiring
grep -q 'cursor/rules' scripts/setup-harness-kit.sh
grep -q 'local-rules' scripts/setup-harness-kit.sh
grep -q 'harness-kit:rules:start' scripts/setup-harness-kit.sh
sh -n scripts/setup-harness-kit.sh

# ERD routing in the loop
grep -q 'ERD?' skills/harness-onboard/templates/AGENT_PROCESS.md
grep -qi 'never dual-run' skills/harness-onboard/templates/AGENT_PROCESS.md
grep -qi 'slice' skills/sprint-contract/templates/SPRINT_CONTRACT.md

# version + ledger
grep -q '2.2.0' scripts/build-bootstrap.sh && grep -q '2.2.0' BOOTSTRAP.md
sh scripts/build-bootstrap.sh
python3 -m json.tool FEATURES.json >/dev/null && grep -q 'KIT-RULES-001' FEATURES.json
git branch --show-current | grep -qv '^master$'
```

---

## FEATURES.json entry

```json
{
  "id": "KIT-RULES-001",
  "name": "rules/ directory as Cursor .mdc with AGENTS.md assembly, plus ERD routing before contract drafting",
  "priority": 1,
  "verify": "test $(ls rules/*.mdc | wc -l) -eq 6 && test -f rules/README.md && grep -q 'harness-kit:rules:start' scripts/setup-harness-kit.sh && grep -q 'ERD?' skills/harness-onboard/templates/AGENT_PROCESS.md && grep -q '2.2.0' BOOTSTRAP.md && ./scripts/build-bootstrap.sh >/dev/null && python3 -m json.tool FEATURES.json >/dev/null",
  "status": "FAIL",
  "notes": "Contract: skills/.harness/contracts/KIT-RULES-001.md; profile: ops-docs; guided by cursor-rules-export 2026-08-28; blocks KIT-GATES-001"
}
```

## Criteria block

```criteria
- [KIT-RULES-001-1] rules/ has exactly 6 .mdc files with valid frontmatter, plus README
- [KIT-RULES-001-2] No vendor/product/repo names in any kit rule
- [KIT-RULES-001-3] rules/README states the four ownership tiers and the six-rule budget
- [KIT-RULES-001-4] Setup symlinks rules, merges local-rules, assembles marked AGENTS.md block, idempotent
- [KIT-RULES-001-5] Assembly strips frontmatter
- [KIT-RULES-001-6] Loop reads BOOT -> ERD? -> RESEARCH? -> CONTRACT
- [KIT-RULES-001-7] ERD routing test has all three conditions, the skip rule, and no dual-run with RESEARCH
- [KIT-RULES-001-8] Process law moved out of AGENT_PROCESS as a pure move (empty content diff)
```

---

## Deviations / clarifications

| # | Item | Resolution |
|---|------|------------|
| 1 | Criterion 9 expected process law **moved** out of `AGENT_PROCESS.md` with an empty content diff | **N/A — nothing moved.** The six rules were authored from the Cursor export and generalised; they are new content, not relocated text. `AGENT_PROCESS.md`'s 7 principles are the *reasoning*, the rules are the *enforceable form*, and they are not verbatim duplicates. A pointer was added instead. Deleting the principles would have been destructive surgery the contract did not scope. |
| 2 | Loop notation — David asked whether research precedes the ERD | Addressed beyond the contract's §C: step 3 now carries a table distinguishing **discovery research** (inside `erd-authoring` S0) from **slice research** (the loop's `RESEARCH?`), so `ERD? → RESEARCH?` no longer implies deciding before looking. Also cross-referenced from the skill. |
| 3 | Loop steps renumbered 1–9 | Inserting ERD? at position 2 shifted CONTRACT through REVIEW. Mechanical. |
| 4 | A VERIFY check failed on a line-wrap artifact ("skips / this") | Reflowed the sentence rather than loosening the check. |

## Q2 as executed

`stage-after-execute` was **merged into** `no-stage-harness-files` as one staging policy, per the
recommendation — what to stage, what never to stage, and the standing "do not commit unless asked".

## Setup script — tested, not asserted

Exercised end to end in a throwaway consumer repo: 6 rules linked · symlinks resolve · assembly writes
a marked block into `AGENTS.md` with **zero** `alwaysApply` leaked · hand-written `AGENTS.md` content
preserved · **second run changed nothing** and left exactly one block · local rules win on collision ·
a foreign `.cursor/rules` is left alone with a warning.

## VERIFY result

All checks green.

## Also in this branch

`271b222` — PASS for KIT-SKILLS-001 and KIT-ERD-001, folded in per Q4.
