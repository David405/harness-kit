# SPRINT CONTRACT — KIT-GATES-002: remove the path heuristic, close the STATE drift

> Status: **EXECUTE complete — VERIFY green (12/12) — PENDING_REVIEW.**
> Approved: David 2026-08-28 ("yes") with recommended Q1–Q2. Version **2.4.0**.
> Feature ID: `KIT-GATES-002`
> Repo: **harness-kit only**
> Branch: proposed `feat/kit-gates-002-tighten-gate`, **stacked on**
> `feat/kit-gates-001-deterministic-gates` (`734a8df`, PENDING_REVIEW). Rebase when that merges.
> Version → **2.4.0**.
> Trigger: findings from the gate's own first run against this repo.

---

## Work-type profile (required)

- [x] `ops-docs`

**Languages / toolchain:** POSIX sh + Markdown. No application code.

---

## Context — two findings from `verify-harness.sh` running against harness-kit

**1. `[GROUNDED]` is overloaded, so check 6 has to guess.**

The marker appears on Branch-section lines as well as impact-map rows:

```
- **Default branch:** `master`; base `ef393c3` (v2.1) — **[GROUNDED]**
```

On its first run check 6 reported `master` and `ef393c3` as missing paths. The patch shipped in
KIT-GATES-001 was a **heuristic** — accept a token only if it contains `/` or carries a known
extension. That is a guess, and it will misfire in both directions: a real path with no slash and no
extension (`Makefile`, `Dockerfile`) is silently skipped, and a backticked symbol that happens to end
in `.ts` is checked as a file. A check that silently skips is worse than one that fails loudly.

**2. `STATE.md` drifts exactly like `FEATURES.json`, and nothing notices.**

Two of six inbox entries in this repo were stale — work already `PASS`. The gate catches that class of
rot in the ledger; in `STATE.md` it verifies only that the named contract exists. Demonstrated below:
an inbox entry pointing at a `PASS` feature leaves the gate green.

**Root cause in both:** the kit asked the script to interpret prose. The fix is to make the artifact
unambiguous and let the script read structure.

---

## Decisions

| Topic | Decision | Status |
|-------|----------|--------|
| `[GROUNDED]` scope | **Impact map only.** Stated in the contract form; the Branch section stops using it | Locked |
| Check 6 | **Parse the impact-map table**, first column, rows marked `[GROUNDED]`. Delete the extension heuristic | Locked |
| Silent skips | A `[GROUNDED]` row whose path cannot be parsed **fails**, rather than being skipped | Locked |
| New check 10 | No `STATE.md` inbox entry references a feature that is already `PASS` | Locked |
| Scope | These two findings only. No new gate concepts | Locked |

---

## Scope — WILL do

1. `sprint-contract` form — state that `[GROUNDED]` / `[EDUCATED]` / `[NEW]` mark **impact-map rows only**,
   and remove the marker from the Branch section example so the template stops teaching the ambiguity.
2. `verify-harness.sh` check 6 — parse the impact-map table: take the first cell of each row whose line
   carries `[GROUNDED]`, strip backticks, verify it exists. **Delete** the extension/slash heuristic.
3. Same check — a `[GROUNDED]` row whose first cell is not a parseable path is a **failure**, not a skip.
4. `verify-harness.sh` **check 10** — read the `Human-attention inbox` section of `STATE.md`; any
   feature id mentioned there that is `PASS` in `FEATURES.json` is a failure, naming the ids.
5. Version **2.4.0**, changelog, `FEATURES.json` entry, bootstrap regenerated.

## Scope — will NOT do

- New gate concepts, coverage or metrics.
- Changes to CI, the RED/BASELINE/GREEN blocks, or any skill or rule.
- Anything in a consumer repo.
- Auto-repair: the gate reports, a human fixes.

## Target

- **Repo:** `harness-kit`. **Not touching:** consumer repos, application source.

---

## Branch

- **Base:** `feat/kit-gates-001-deterministic-gates` @ `734a8df` — needs check 6 to exist.
- **Proposed:** `feat/kit-gates-002-tighten-gate`
- **Human confirmed:** **pending.**

---

## RED (recorded before EXECUTE)

- **Command:** `grep -qi 'impact map only' skills/sprint-contract/templates/SPRINT_CONTRACT.md; grep -qi 'inbox' scripts/verify-harness.sh`
- **Exit code:** `1`
- **Failure reason:** assertion — expected the string `impact map only` in the contract form and found
  none; expected an inbox check in the gate and found none. Check 6 still matches on
  `*.md|*.sh|*.json|…` at `scripts/verify-harness.sh:137` rather than parsing the table.
- **Captured:** 2026-08-28, before any edit on this branch

**Behavioural RED, demonstrated:** an inbox entry naming `KIT-RULES-001` (which is `PASS`) was injected
into `STATE.md`. The gate reported `PASS STATE.md current contract exists` and **exited 0**. It should
exit 1. Restored afterwards.

**BASELINE** — the gate itself: `./scripts/verify-harness.sh` → exit 0, 9 pass / 0 skip at `734a8df`.

## GREEN (recorded after EXECUTE)

- Both RED assertions → **exit 0**: `impact map only` present in the form; `inbox` present in the gate
- Injected inbox entry naming `KIT-SKILLS-001` (a `PASS` feature) → gate **exit 1**,
  `FAIL STATE inbox references work already PASS: KIT-SKILLS-001`. Restored → exit 0
- `./scripts/verify-harness.sh` → **exit 0**, **10** checks reported, 0 skipped
- Contract VERIFY block → **12/12**

---

## Impact map

| Path | Change | Marker |
|------|--------|--------|
| `scripts/verify-harness.sh` | Check 6 parses the table; heuristic deleted; check 10 added | [GROUNDED] |
| `skills/sprint-contract/templates/SPRINT_CONTRACT.md` | `[GROUNDED]` restricted to the impact map | [GROUNDED] |
| `skills/.harness/contracts/KIT-GATES-002.md` | This contract | [NEW] |
| `scripts/build-bootstrap.sh` | 2.4.0 + changelog | [GROUNDED] |
| `BOOTSTRAP.md` | Regenerated | [GROUNDED] |
| `FEATURES.json` | Add `KIT-GATES-002` | [GROUNDED] |
| `README.md` | Version | [GROUNDED] |

---

## Success criteria

1. `scripts/verify-harness.sh` contains no extension-list heuristic — `grep -q '\*\.md|\*\.sh' ` finds nothing.
2. Check 6 resolves paths from the impact-map table; a malformed `[GROUNDED]` row **fails**, demonstrated.
3. Check 10 exists; a `STATE.md` inbox entry naming a `PASS` feature makes the gate exit 1, **demonstrated**.
4. Clean tree: gate exits 0 with **10** checks reported.
5. The contract form states `[GROUNDED]` is impact-map only, and its Branch example no longer uses the marker.
6. 2.4.0 everywhere; bootstrap regenerates; `FEATURES.json` parses; diff confined to the impact map.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria — 2, 3 and 4 are executable
- [ ] Trust-boundary / http-api / solidity / code-quality — **N/A** (`ops-docs`)
- [ ] Behaviour-preserving refactor — **N/A**

## Edge cases / failure modes

| Risk | Mitigation |
| --- | --- |
| Table parsing is as brittle as the heuristic | It reads a fixed position — first cell of a marked row — rather than inferring meaning. Unparseable rows fail loudly |
| Older contracts lack a table-shaped impact map | Those rows fail rather than skip, which is the intended signal to fix the contract |
| Check 10 false-positives on prose mentioning a `PASS` id | Match feature-id shaped tokens only, inside the inbox section only |
| Gate grows into a linter | Scope explicitly forbids new concepts |

## Threat model

**SKIP** — no network, no credentials, no side effects.

## Blocking questions

**Q1 — Older contracts whose impact map is a bullet list, not a table.** Six tracked contracts predate
the table convention.
- **Recommendation:** check 6 applies only to rows inside a markdown table; a bullet-list impact map
  reports `skipped (impact map not tabular)`. Loud enough to notice, not a wall for history.

**Q2 — Should check 10 also fail on an inbox entry naming a feature that does not exist at all?**
- **Recommendation:** yes, same check, same failure. A typo'd id is the same rot.

---

## VERIFY (run after EXECUTE)

```bash
cd "$HOME/mnt/harness-kit"

# heuristic gone, table parse in
! grep -q '\*\.md|\*\.sh' scripts/verify-harness.sh
grep -qi 'impact map' scripts/verify-harness.sh
sh -n scripts/verify-harness.sh

# convention stated
grep -qi 'impact map only' skills/sprint-contract/templates/SPRINT_CONTRACT.md

# check 10 present, and the gate reports ten checks on a clean tree
grep -qi 'inbox' scripts/verify-harness.sh
./scripts/verify-harness.sh
test "$(./scripts/verify-harness.sh | grep -cE '^  (PASS|FAIL|SKIP)')" -eq 10

# version + ledger
grep -q '2.4.0' BOOTSTRAP.md && sh scripts/build-bootstrap.sh
python3 -m json.tool FEATURES.json >/dev/null && grep -q 'KIT-GATES-002' FEATURES.json
git branch --show-current | grep -qv '^master$'
```

## FEATURES.json entry

```json
{
  "id": "KIT-GATES-002",
  "name": "Gate reads structure not prose: impact-map parse replaces the path heuristic; STATE inbox drift check",
  "priority": 2,
  "verify": "! grep -q '[*].md|[*].sh' scripts/verify-harness.sh && grep -qi inbox scripts/verify-harness.sh && ./scripts/verify-harness.sh && grep -q '2.4.0' BOOTSTRAP.md && python3 -m json.tool FEATURES.json >/dev/null",
  "status": "FAIL",
  "notes": "Contract: skills/.harness/contracts/KIT-GATES-002.md; profile: ops-docs; stacked on KIT-GATES-001; from the gate's own first run"
}
```

## Criteria block

```criteria
- [KIT-GATES-002-1] Extension heuristic removed from verify-harness.sh
- [KIT-GATES-002-2] Check 6 parses the impact-map table; malformed rows fail loudly
- [KIT-GATES-002-3] Check 10 catches a STATE inbox entry naming a PASS feature, demonstrated
- [KIT-GATES-002-4] Clean tree reports 10 checks and exits 0
- [KIT-GATES-002-5] Contract form restricts [GROUNDED] to the impact map
- [KIT-GATES-002-6] 2.4.0; bootstrap regenerates; FEATURES.json valid
```

---

## Deviations / clarifications

| # | Item | Resolution |
|---|------|------------|
| 1 | **The contract assumed check 6 could scan for `[GROUNDED]` anywhere.** It cannot | The first marked table row in most contracts belongs to **Context** or **Decisions**, not the impact map — verified across all eight tracked contracts. The parser is **section-scoped**: it locates `## Impact map`, reads to the next heading, and takes the first cell of marked table rows only. Stronger than the contract specified |
| 2 | **Q2 was wrong, and the gate proved it in seconds.** I recommended failing on inbox ids absent from the ledger | On first run it flagged four, and **none was rot**: `AUDIT-001` belongs to another repo, `KIT-AUDIT-002` and `KIT-RECONCILE-001` are planned work deliberately named, and `PR-KIT-GATES-001` was a **filename** the regex matched inside. Narrowed to the half that is real signal — ids present in the ledger and already `PASS` — and taught it to strip backticked and path-shaped tokens first |
| 3 | First demonstration of check 10 used `KIT-RULES-001`, which is `PENDING_REVIEW`, not `PASS` | Correctly produced no failure. Re-run against `KIT-SKILLS-001` (`PASS`) — failed as designed. The test was wrong, not the check |
| 4 | Glob paths in impact maps (`rules/*.mdc`) | Handled: a first cell containing `*` is treated as a glob and must match at least one file |

## Q1 as executed

A bullet-list impact map reports `SKIP impact map not tabular`; a section with no marked rows reports
`SKIP no [GROUNDED] rows`. Both are printed, never swallowed.

## Note for review

`KIT-RULES-001` still reads `PENDING_REVIEW` in the ledger although it merged at `aea8fb2` — the same
drift class this sprint closes for `STATE.md`. `PASS` is human-only, so it is left for David.
