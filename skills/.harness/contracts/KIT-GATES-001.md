# SPRINT CONTRACT — KIT-GATES-001: deterministic gates (RED/BASELINE/GREEN + `verify-harness.sh` + CI)

> Status: **EXECUTE complete — VERIFY green (20/20) — PENDING_REVIEW.**
> Approved: David 2026-08-28 ("approve") with recommended Q1–Q4. Version **2.3.0**.
> Feature ID: `KIT-GATES-001`
> Repo: **harness-kit only**
> Branch: proposed `feat/kit-gates-001-deterministic-gates`, **stacked on**
> `feat/kit-rules-001-rules-and-erd-routing` (`65aeb7f`, PENDING_REVIEW). Rebase onto `master` when that merges.
> Version → **2.3.0**.
> Trigger: David (2026-08-28) — "how do we put a gate to ensure that a contract delivers/executes a
> feature without regression or hallucination, especially as features/slices would not have an ERD?"

---

## Work-type profile (required)

- [x] `ops-docs` — process/templates change to the kit itself

**Languages / toolchain:** POSIX sh + Markdown + one CI workflow. No application code.

---

## Context — the kit currently has no enforced gate (grounded)

| Finding | Evidence | Consequence |
| --- | --- | --- |
| Every "gate" is self-reported | `AGENT_PROCESS` §VERIFY *asks* the agent to run commands; nothing confirms it | An executor can set `PENDING_REVIEW` without running anything |
| The RED field asks for a **prediction** | `SPRINT_CONTRACT.md:75` — "**Expected** RED output: `<command to run + what failure looks like>`" | Nothing ever compares the prediction to reality. A test that never failed proves nothing: it may be vacuous or already passing |
| No CI, no hooks | No `.github/` in the kit; zero hook configs | The only thing in the repo that can fail and stop something is `setup-harness-kit.sh` |
| `FEATURES.json` is unvalidated | No schema check anywhere | Status drift went unnoticed **four times** this month across two repos (harness-kit 3 entries, order-service 10/10) |
| **CI cannot read a contract** | `git check-ignore skills/.harness/contracts` → ignored | The artifact `harness-review` §0 grades a PR against is invisible to CI, to reviewers, and (as observed 2026-08-28) to the author in Finder and the editor sidebar |

**The gap:** rules and skills are instructions to a model that can misread them under load. A gate is a
fact. The kit has the first two layers and not the third.

---

## Decisions

| Topic | Decision | Status |
|-------|----------|--------|
| Prediction → recording | `SPRINT_CONTRACT` gains **RED / BASELINE / GREEN** artifact blocks holding real command, real output, real exit code | Locked |
| Delivery gate | The acceptance test must have **failed before EXECUTE**, on an **assertion** | Locked |
| Regression gate | Baseline suite recorded before, re-run after; **diff ⊆ declared impact map** | Locked |
| Hallucination gate | Claims replaced by artifacts: every `[GROUNDED]` path must exist; every `verify` must exit 0 | Locked |
| Slices with no ERD | Handled by the same gate. If you cannot write a test that fails today, you do not have a falsifiable criterion and the contract is not approvable | Locked |
| Implementation | **One script, three invocation points** — `scripts/verify-harness.sh`, called by CI and optionally by hooks. Never reimplemented per surface | Locked |
| Unforgeable layer | **CI re-runs VERIFY itself**, so the agent's claim stops mattering | Locked |
| Hooks | **Optional, opt-in**, documented as an example. Vendor-specific; CI and the script are universal | Locked |
| Vacuous tests | Out of reach of any cheap gate. Mitigate by requiring an assertion-shaped RED and reviewing the test **at contract approval**. Mutation testing documented as an option, **not** a default | Locked |

---

## Scope — WILL do

### A — `scripts/verify-harness.sh`

1. New POSIX script, exits non-zero on any violation, runnable from a consumer repo root. Checks:

| # | Check | Catches |
|---|-------|---------|
| 1 | `FEATURES.json` parses; every `status` is from the legend; every `verify` non-empty and not prose | Ledger rot |
| 2 | Every `PENDING_REVIEW` entry has a contract file where it claims | Phantom work |
| 3 | `STATE.md` current contract points at a real file | Stale state |
| 4 | Every skill has valid frontmatter (`name`, `description`) | Skills that cannot be retrieved |
| 5 | Every rule has valid frontmatter and `alwaysApply` | Rules that never load |
| 6 | Every `[GROUNDED]` path in the active contract's impact map **exists** | **Invented files** — the most common contract hallucination |
| 7 | `git diff --name-only <base>..HEAD` ⊆ impact map | Undeclared scope creep, the main regression vector |
| 8 | RED artifact present, and its recorded failure is an **assertion**, not an import/path error | Vacuous or never-failing tests |
| 9 | No implementation commits on the default branch | Branch discipline |

2. Checks 6–8 **degrade gracefully**: when no contract is reachable they report `skipped (no contract)`
   rather than failing, so the script is useful in a repo mid-adoption. Checks 1–5 and 9 always run.
3. `--strict` turns skips into failures, for repos that have fully adopted.

### B — Contract form: prediction becomes recording

4. Replace `**Expected RED output:**` with three blocks:

```
### RED (recorded before EXECUTE)
- Command:        <exact command>
- Exit code:      <non-zero>
- Failure reason: <the assertion message — not "module not found">
- Captured:       <ISO-8601>

### BASELINE (recorded before EXECUTE)
- Command:  <full suite>
- Result:   <pass/fail counts>

### GREEN (recorded after EXECUTE)
- Command:  <same as RED>   Exit code: 0
- Command:  <same as BASELINE>  Result: <counts, compared to baseline>
```

5. State the rule plainly in the form: **a test that never failed proves nothing**, and a RED that
   failed on an import error proves the test file is wrong, not that the behaviour is absent.
6. Add the no-ERD line: without an ERD the contract's own criteria are the whole story, and each must
   be expressible as a failing test **before** work starts, or the contract is not approvable.

### C — CI

7. `.github/workflows/harness.yml` — on pull request: run `verify-harness.sh`, then re-run the
   contract's VERIFY block. Kit-owned, shipped to consumers via the skill tree.
8. Document that CI is the only layer an agent cannot fake, and that a green local run is not evidence.

### D — Hooks (optional)

9. `docs/hooks.md` (or a README section) with one worked example calling the same script. Explicitly
   opt-in and vendor-specific; the kit never requires it.

### E — Process + wiring

10. `AGENT_PROCESS.md` §VERIFY — require the three artifacts, and say the executor may set
    `PENDING_REVIEW` only when `verify-harness.sh` exits 0.
11. `harness-review` form §0 — reviewer confirms the artifacts exist and that CI ran the gate.
12. `code-quality-gate` — one line pointing at the shared script so the two do not drift.
13. Version **2.3.0**, changelog, `FEATURES.json` entry, bootstrap appendix for the new script/workflow.

## Scope — will NOT do (this sprint)

- Mutation testing, coverage thresholds, or any quality metric beyond pass/fail.
- Language-specific test runners — commands come from the consumer's `AGENTS.md`.
- Reconcile the forked global harness (`KIT-RECONCILE-001`).
- The `code-audit` partial-coverage amendment (separate, small).
- Retro-fit artifacts onto already-merged contracts.
- Migrate any consumer repo.

---

## Branch

- **Base:** `feat/kit-rules-001-rules-and-erd-routing` @ `65aeb7f` — needs `rules/` to exist for check 5.
- **Proposed:** `feat/kit-gates-001-deterministic-gates`
- **Human confirmed:** **pending.**

## Tests first

**N/A** as product TDD — but this sprint **dogfoods its own gate**: `verify-harness.sh` is run against
harness-kit itself as part of VERIFY, and must exit 0.

- **Expected RED today:** `test -f scripts/verify-harness.sh` fails; `test -d .github/workflows` fails.

---

## Impact map

| Path | Change | Grounding |
|------|--------|-----------|
| `scripts/verify-harness.sh` | **NEW** | [NEW] |
| `.github/workflows/harness.yml` | **NEW** | [NEW] |
| `skills/sprint-contract/templates/SPRINT_CONTRACT.md` | RED/BASELINE/GREEN blocks; no-ERD rule | [GROUNDED] |
| `skills/harness-onboard/templates/AGENT_PROCESS.md` | VERIFY requires artifacts + script exit 0 | [GROUNDED] |
| `skills/harness-review/templates/REVIEW.md` | §0 confirms artifacts and CI | [GROUNDED] |
| `skills/code-quality-gate/templates/CODE_QUALITY.md` | Pointer to the shared script | [GROUNDED] |
| `README.md`, `scripts/build-bootstrap.sh`, `BOOTSTRAP.md`, `FEATURES.json` | Gates section, appendix, 2.3.0, ledger | [GROUNDED] |
| `.gitignore` | Contracts untracked→tracked; legacy `.harness/` rule anchored to root | [GROUNDED] |
| `skills/.harness/contracts/KIT-V13-001.md` | Becomes tracked (Q1 consequence) | [GROUNDED] |
| `skills/.harness/contracts/KIT-QUALITY-001.md` | Becomes tracked (Q1 consequence) | [GROUNDED] |
| `skills/.harness/contracts/KIT-AUDIT-001.md` | Becomes tracked (Q1 consequence) | [GROUNDED] |
| `skills/.harness/contracts/KIT-SKILLS-001.md` | Becomes tracked (Q1 consequence) | [GROUNDED] |
| `skills/.harness/contracts/KIT-ERD-001.md` | Becomes tracked (Q1 consequence) | [GROUNDED] |
| `skills/.harness/contracts/KIT-RULES-001.md` | Becomes tracked (Q1 consequence) | [GROUNDED] |

---

## Success criteria

1. `scripts/verify-harness.sh` exists, is executable, POSIX-clean, and **exits 0 against harness-kit itself**.
2. Running it against a repo with a deliberately broken `FEATURES.json` exits non-zero — demonstrated, not asserted.
3. Checks 6–8 report `skipped (no contract)` rather than failing when no contract is reachable; `--strict` flips that.
4. `.github/workflows/harness.yml` runs the script and the contract VERIFY block on pull requests.
5. `SPRINT_CONTRACT.md` carries RED/BASELINE/GREEN blocks; the phrase "Expected RED output" is gone.
6. The form states that a test which never failed proves nothing, and the no-ERD rule.
7. `AGENT_PROCESS.md` §VERIFY conditions `PENDING_REVIEW` on the script exiting 0.
8. `REVIEW.md` §0 confirms artifacts exist and CI ran.
9. One implementation: neither CI nor the hooks doc reimplements a check — both invoke the script.
10. 2.3.0 everywhere; bootstrap regenerates; `FEATURES.json` parses; diff confined to the impact map.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria — criteria 1 and 2 are executable
- [ ] Trust-boundary — **N/A** (docs/script)
- [ ] Code-quality gate — **N/A** (`ops-docs`)
- [ ] Behaviour-preserving refactor — **N/A**

## Edge cases / failure modes

| Risk | Mitigation |
| --- | --- |
| Gate blocks a repo mid-adoption | Graceful skips; `--strict` is opt-in |
| Contract checks silently no-op forever | The skip is **printed**, not swallowed, so "skipped" is visible in CI logs |
| CI and hooks drift | Criterion 9: single script, both invoke it |
| Vacuous test passes every check | Acknowledged limit. Assertion-shaped RED + review the test at approval; mutation testing documented, not mandated |
| Diff-⊆-impact-map fights legitimate discoveries | The remedy is amending the contract, which is the intended behaviour |
| Script becomes a second process spine | It validates the spine, adds no rules of its own |

## Threat model

**SKIP** — no network, no credentials, no privileged operations. CI runs only repo-declared commands.

---

## Blocking questions (gates)

**Q1 — Contracts are gitignored, so CI cannot read them.** This is now forcing, not cosmetic: checks
6–8 need the contract, and `harness-review` §0 already tells a reviewer to grade the PR against a file
that is not in the PR. You hit this yourself on 2026-08-28 when the contract was invisible in Finder
and the editor sidebar.
- **Recommendation:** **track contracts.** Move `skills/.harness/contracts/` out of `.gitignore` and
  keep `STATE.md` and local scratch ignored. They are markdown, the audit trail is worth having in git,
  and it makes the contract reviewable, CI-checkable and findable in one move.
- Alternatives: CI runs only checks 1–5 and 9 (weaker, and the hallucination gate is the valuable one);
  or CI pastes the contract into the PR body (solves review, not checking).

**Q2 — Should the diff-⊆-impact-map check block, or warn?** It is the strongest regression gate and
also the most likely to annoy.
- **Recommendation:** **block**, with the remedy being to amend the contract. Warning-only gates get ignored.

**Q3 — Baseline on every contract, or only behaviour changes?** Recording a full-suite baseline costs a
run each time.
- **Recommendation:** behaviour changes only; **N/A** for `ops-docs`, `code-audit`, `product-erd`.

**Q4 — Does the kit ship the CI workflow to consumers, or document it?** Shipping means the kit writes
into `.github/`, which some repos guard.
- **Recommendation:** ship it as a template the setup script **offers** but never overwrites, following
  the same marker-guard discipline as the rules assembly.

*Approve only if Q1–Q4 (or your edits) are acceptable.*

---

## VERIFY (run after EXECUTE)

```bash
cd "$HOME/mnt/harness-kit"

# the gate exists and passes against this repo (dogfood)
test -x scripts/verify-harness.sh
sh -n scripts/verify-harness.sh
./scripts/verify-harness.sh

# and it actually fails on a broken ledger (demonstrated, not claimed)
cp FEATURES.json /tmp/f.bak
python3 - <<'PY'
import json;d=json.load(open('FEATURES.json'));d['features'][0]['status']='BOGUS'
open('FEATURES.json','w').write(json.dumps(d,indent=2))
PY
./scripts/verify-harness.sh && echo "GATE DID NOT FAIL — BAD" && exit 1
cp /tmp/f.bak FEATURES.json
./scripts/verify-harness.sh

# CI wired
test -f .github/workflows/harness.yml
grep -q 'verify-harness.sh' .github/workflows/harness.yml

# prediction replaced by recording
! grep -q 'Expected RED output' skills/sprint-contract/templates/SPRINT_CONTRACT.md
grep -q 'RED (recorded before EXECUTE)' skills/sprint-contract/templates/SPRINT_CONTRACT.md
grep -q 'BASELINE' skills/sprint-contract/templates/SPRINT_CONTRACT.md
grep -qi 'never failed proves nothing' skills/sprint-contract/templates/SPRINT_CONTRACT.md

# process + review wired to the same script
grep -q 'verify-harness.sh' skills/harness-onboard/templates/AGENT_PROCESS.md
grep -q 'verify-harness.sh' skills/harness-review/templates/REVIEW.md

# single implementation
test "$(grep -rlc 'FEATURES.json parses' .github scripts 2>/dev/null | wc -l)" -le 1

# version + ledger
grep -q '2.3.0' BOOTSTRAP.md && sh scripts/build-bootstrap.sh
python3 -m json.tool FEATURES.json >/dev/null && grep -q 'KIT-GATES-001' FEATURES.json
git branch --show-current | grep -qv '^master$'
```

---

## FEATURES.json entry

```json
{
  "id": "KIT-GATES-001",
  "name": "Deterministic gates: RED/BASELINE/GREEN artifacts, verify-harness.sh, CI re-running VERIFY",
  "priority": 1,
  "verify": "test -x scripts/verify-harness.sh && ./scripts/verify-harness.sh && test -f .github/workflows/harness.yml && ! grep -q 'Expected RED output' skills/sprint-contract/templates/SPRINT_CONTRACT.md && grep -q '2.3.0' BOOTSTRAP.md && ./scripts/build-bootstrap.sh >/dev/null && python3 -m json.tool FEATURES.json >/dev/null",
  "status": "FAIL",
  "notes": "Contract: skills/.harness/contracts/KIT-GATES-001.md; profile: ops-docs; stacked on KIT-RULES-001; Q1 decides whether contracts become tracked"
}
```

## Criteria block

```criteria
- [KIT-GATES-001-1] verify-harness.sh exists, POSIX, executable, exits 0 against harness-kit
- [KIT-GATES-001-2] Demonstrated non-zero exit on a broken FEATURES.json
- [KIT-GATES-001-3] Contract checks skip visibly without a contract; --strict flips to failure
- [KIT-GATES-001-4] CI workflow runs the script and the contract VERIFY block on PRs
- [KIT-GATES-001-5] Expected-RED prediction replaced by RED/BASELINE/GREEN recordings
- [KIT-GATES-001-6] No-ERD rule stated: no failing test means no falsifiable criterion
- [KIT-GATES-001-7] AGENT_PROCESS conditions PENDING_REVIEW on the gate; REVIEW s0 confirms artifacts
- [KIT-GATES-001-8] Single implementation — CI and hooks both invoke the script
```

---

## RED (recorded before EXECUTE)

- **Command:** `test -x scripts/verify-harness.sh && test -f .github/workflows/harness.yml`
- **Exit code:** `1`
- **Failure reason:** neither file existed at `aea8fb2` — the gate and its CI surface were absent
- **Captured:** 2026-08-28, before the first edit on this branch

**BASELINE** — N/A: no test suite exists in this repo; the gate itself is the suite from this sprint on.

## GREEN (recorded after EXECUTE)

- `./scripts/verify-harness.sh` → **exit 0**, 8 pass / 1 skip (RED artifact, on a contract predating the format)
- Contract VERIFY block → **20/20 pass**

## Criterion 2 — demonstrated, not asserted

The gate was shown to fail on four separate defects, each restored afterwards:

| Injected defect | Gate output | Exit |
|---|---|---|
| `status: "BOGUS"` | `KIT-RULES-001: status 'BOGUS' not in legend` | 1 |
| `verify: "tested"` (prose) | `KIT-RULES-001: verify does not look like a command` | 1 |
| `PENDING_REVIEW` with no contract | `PENDING_REVIEW without a contract: GHOST-001` | 1 |
| Rule with no frontmatter | `rules with bad frontmatter: rules/status-ownership.mdc` | 1 |

## Deviations / clarifications

| # | Item | Resolution |
|---|------|------------|
| 1 | **The gate found a false positive in itself.** Check 6 read `master` and `ef393c3` as paths, because branch names and SHAs are also backticked on `[GROUNDED]` lines in the Branch section | Narrowed the heuristic to tokens containing `/` or carrying a known extension. Caught by dogfooding before shipping — which is the argument for criterion 1 |
| 2 | Q1 required more than a `.gitignore` edit | The legacy rule `.harness/` is **unanchored**, so it matched `skills/.harness` at any depth and kept contracts ignored regardless of the new negation. Anchored it to `/.harness/` (its intended root-only meaning). Found with `git check-ignore -v` rather than assumed |
| 3 | Contract listed `.gitignore` as conditional on Q1 | Q1 answered "track contracts", so it changed |
| 4 | **The gate failed on its own contract, correctly.** Tracking contracts pulled six pre-existing contract files into the diff that the impact map never declared | Scope containment reported them as undeclared. Per the design, the remedy is **amending the contract**, not relaxing the check — the impact map now lists all six. First live catch, on the sprint that introduced the check |

## Q1–Q4 as executed

- **Q1** contracts **tracked**; `STATE.md`, drafts and PR bodies stay local.
- **Q2** scope containment **blocks**; the remedy is amending the contract.
- **Q3** BASELINE for behaviour changes only; N/A for `ops-docs`, `code-audit`, `product-erd`.
- **Q4** CI workflow shipped as a kit file; consumers adopt it through the skill tree rather than having it written into their `.github/` by the setup script.
