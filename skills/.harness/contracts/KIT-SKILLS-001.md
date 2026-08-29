# SPRINT CONTRACT — KIT-SKILLS-001: templates → skills, submodule adoption

> Status: **EXECUTE complete — VERIFY green — PENDING_REVIEW.**
> Approved: David 2026-08-27 ("proceed") with recommended Q1–Q4. Branch confirmed.
> Commits: `d503ac1` (pure rename) + `008248d` (skills, setup, adoption). Version **2.0.0**.
> Feature ID: `KIT-SKILLS-001`
> Repo: **harness-kit only**
> Branch: proposed `feat/kit-skills-001-templates-to-skills` — **human must confirm before checkout**
> Trigger: David (2026-08-27) — "we need to turn templates into skills and then proceed with kit-erd-001."
> **This is a breaking change to the adoption model → version 2.0.0.**

---

## Work-type profile (required)

- [x] `ops-docs` — process/templates change to the kit itself

**Languages / toolchain:** Markdown + POSIX sh. No application code.

---

## Context (grounded, verified on `master` @ `3e22a12`)

| Fact | Consequence |
| --- | --- |
| 13 files in `templates/`; no `SKILL.md` anywhere in the kit | Nothing to migrate from; this is a first conversion |
| `BOOTSTRAP.md` is 1947 lines, sold as "copy this file into **any** repo" | Retiring it removes the kit's entire adoption story — must be replaced, not just deleted |
| Appendices B–M are written to `skills/.harness/templates/*` | That path is **gitignored** (`.gitignore:20`) — today's templates are disposable local copies |
| Skills are discovered by directory + `SKILL.md` frontmatter | They must be **reachable in the tree**, which the gitignored path is not |
| `scripts/build-bootstrap.sh` regenerates `BOOTSTRAP.md` from `templates/*` | Becomes obsolete once appendices stop being the distribution vector |
| Kit currently has **no** setup script | Submodule adoption needs one (symlink wiring, brownfield safety) |

**Decisions taken by David (2026-08-27):** procedures become skills and forms ship bundled inside them;
skills are tracked, kit-owned; **adoption moves from single-file BOOTSTRAP to git submodule**;
skills live at `skills/<name>/SKILL.md`.

---

## Decisions

| Topic | Decision | Status |
|-------|----------|--------|
| What becomes a skill | **Procedures only.** Fill-in forms ship as `templates/` **inside** the owning skill | Locked |
| Skill count | **7** (see §B) — not 13; a blank form with frontmatter is indirection without behaviour | Locked |
| Adoption | **Git submodule + setup script.** Skills stay canonical in harness-kit; consumers symlink | Locked |
| Per-repo copies | **None.** Symlinks, not copies — so kit upgrades are a submodule pointer bump and drift is impossible | Locked |
| Location | `skills/<name>/SKILL.md`, siblings of the existing `skills/.harness/` working directory | Locked |
| `skills/.harness/` | **Unchanged** — contracts, STATE, local templates stay gitignored working state | Locked |
| `BOOTSTRAP.md` | **Deprecated, not deleted, this sprint.** See Q2 | Locked |
| Version | **2.0.0** — breaking change to how repos adopt the kit | Locked |
| Tool coupling | Accepted. `SKILL.md` frontmatter is a Claude/Cursor/skills-CLI convention; `AGENTS.md` remains the tool-agnostic entrypoint so a non-skill agent still works | Locked |

---

## Scope — WILL do

### A — Skill format

1. Each skill: `skills/<name>/SKILL.md` with YAML frontmatter (`name`, `description` — third person, trigger
   terms, ≤1024 chars), and bundled `skills/<name>/templates/*.md` for its forms.
2. Each generated/kit-owned skill carries a "kit-owned — edit in harness-kit, not here" marker.

### B — The seven skills (procedures), with their bundled forms

| Skill | Procedure | Bundled forms |
|-------|-----------|---------------|
| `harness-onboard` | Bootstrap a repo into the process | `AGENTS.md`, `AGENT_PROCESS.md`, `FEATURES.json`, `STATE.md`, `README_POINTER.md` |
| `sprint-contract` | Write a contract; get approval; confirm branch | `SPRINT_CONTRACT.md` |
| `code-quality-gate` | Run the per-diff gate at VERIFY | `CODE_QUALITY.md` |
| `code-audit` | Run a periodic subsystem audit | `CODE_AUDIT_CONTRACT.md`, `CODE_AUDIT_FINDING.md` |
| `solidity-audit` | Run a contract security audit | `AUDIT_CONTRACT.md`, `AUDIT_FINDING.md` |
| `security-checklist` | Pre-merge security self-check | `SECURITY_CHECKLIST.md` |
| `harness-review` | PR review, §0 contract compliance first | `REVIEW.md` |

3. Content is **moved, not rewritten**. Each `SKILL.md` adds only frontmatter, a short "when to use /
   when not to", and a pointer to its bundled form. No process changes ride along in this sprint.

### C — Submodule adoption

4. Add `scripts/setup-harness-kit.sh` — run from the **consumer repo root**, detects the git superproject, and:
   - verifies the submodule is present at a known path
   - creates a merge directory of per-skill symlinks into the submodule
   - wires the tool paths that exist in that repo (`.claude/skills`, `.cursor/skills`, `.agents/skills`)
   - refuses to overwrite anything it did not generate (marker file), and preserves unrelated entries
   - is idempotent — running twice changes nothing
5. `README.md` — replace the BOOTSTRAP adoption instructions with submodule adoption
   (`git submodule add`, `git submodule update --init`, run setup, re-run after a pointer bump).
6. Document the **upgrade path**: bump the submodule pointer, re-run setup. No per-repo file edits.

### D — Path references

7. Rewrite every `skills/.harness/templates/<X>.md` reference in `templates/AGENT_PROCESS.md`,
   `templates/AGENTS.md`, `templates/REVIEW.md`, `templates/SPRINT_CONTRACT.md`,
   `templates/CODE_QUALITY.md`, `templates/CODE_AUDIT_CONTRACT.md` to the skill path.
8. Keep `skills/.harness/contracts/` and `skills/.harness/STATE.md` exactly as they are — working state,
   still gitignored, unaffected by this change.

### E — Deprecate BOOTSTRAP

9. `BOOTSTRAP.md` gains a deprecation banner naming the submodule path and the removal target
   (`KIT-SKILLS-002`). **Not deleted this sprint** — repos bootstrapped from it still reference it.
10. `scripts/build-bootstrap.sh` gains the same banner and stays runnable until removal.

### F — Version + ledger

11. Version **2.0.0** across `README.md`, the setup script header, and the deprecation banners; changelog
    entry naming the breaking change and the migration.
12. Add `KIT-SKILLS-001` to root `FEATURES.json`.

## Scope — will NOT do (this sprint)

- Delete `BOOTSTRAP.md` or `build-bootstrap.sh` → `KIT-SKILLS-002`.
- Change any process rule, gate, profile, threshold or checklist content. **Pure relocation.**
- Migrate any consumer repo (including `technical-project-documentation`, which uses `.harness/contracts/`).
- Build `KIT-ERD-001` — it follows, in the new skill shape.
- Adopt, reference or absorb any other pack repo; the kit stays pack-agnostic.
- Add per-repo editable copies of skills.

## Target

- **Repo / package:** `harness-kit`.
- **Not touching:** every consumer repo; any pack repo; application source.

---

## Branch (feature branch — mandatory)

- **Default branch:** `master`; base `master` @ `3e22a12` (v1.5.0, PR #16 merged) — **[GROUNDED]**
- **Proposed feature branch:** `feat/kit-skills-001-templates-to-skills`
- **Human confirmed:** **pending — agent asks before checkout.**

---

## Tests first (TDD)

**N/A** — documentation/process sprint. VERIFY uses falsifiable deterministic checks.

- **Expected RED (today):**
  - `test -f skills/code-quality-gate/SKILL.md` → fails
  - `test -f scripts/setup-harness-kit.sh` → fails
  - `grep -q '2.0.0' README.md` → fails

---

## Impact map

| Path | Change | Grounding |
|------|--------|-----------|
| `skills/<7 names>/SKILL.md` | **NEW** — 7 procedure skills | [NEW] |
| `skills/<name>/templates/*.md` | **MOVED** from `templates/` (git mv; content unchanged) | [GROUNDED] |
| `scripts/setup-harness-kit.sh` | **NEW** — submodule wiring, idempotent | [NEW] |
| `README.md` | Submodule adoption replaces BOOTSTRAP instructions; 2.0.0 | [GROUNDED] |
| `templates/AGENT_PROCESS.md` → skill | Path references rewritten | [GROUNDED] |
| `templates/AGENTS.md` → skill | Path references rewritten | [GROUNDED] |
| `BOOTSTRAP.md`, `scripts/build-bootstrap.sh` | Deprecation banners only | [GROUNDED] |
| `FEATURES.json` | Add `KIT-SKILLS-001` | [GROUNDED] |

**Reuse:** the submodule + symlink + merge-directory + brownfield-safety pattern is already proven in a
sibling repo's setup script. Adapt the approach; **do not** reference or depend on that repo.

---

## Success criteria

1. Seven `skills/<name>/SKILL.md` exist, each with valid frontmatter (`name`, `description` ≤1024 chars).
2. Every former `templates/*.md` file is reachable inside exactly one skill; none orphaned, none duplicated.
3. `git log --follow` shows the forms were **moved**, not rewritten — content diff is empty for each.
4. `scripts/setup-harness-kit.sh` is executable POSIX sh, idempotent (two runs → no diff), and refuses to
   overwrite files it did not generate.
5. No reference anywhere to `skills/.harness/templates/` remains outside the deprecated BOOTSTRAP files.
6. `skills/.harness/contracts/` and `STATE.md` still gitignored and untouched.
7. `README.md` documents submodule adoption and the pointer-bump upgrade path; version 2.0.0.
8. `BOOTSTRAP.md` and `build-bootstrap.sh` carry deprecation banners and still run.
9. Root `FEATURES.json` valid and contains `KIT-SKILLS-001`.
10. No process rule changed: `git diff` on moved content shows relocation only.
11. Diff confined to the impact map; work on the confirmed feature branch.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria — see VERIFY
- [ ] Trust-boundary / partial deps / http-api / solidity — **N/A** (docs-only)
- [ ] Code-quality gate — **N/A** (`ops-docs`)
- [ ] Behaviour-preserving refactor gate — **the content-move criterion (3) is its analogue**: the "behaviour" preserved here is the process text, proven by an empty content diff across the move

## Edge cases / failure modes

| Risk | Mitigation |
| --- | --- |
| Process text silently edited during the move | Criterion 3: empty content diff per moved file, enforced in VERIFY |
| Repos bootstrapped from BOOTSTRAP break | Deprecated, not deleted; removal deferred to KIT-SKILLS-002 |
| Setup script clobbers hand-authored skills | Generated-marker rule; refuses unknown content (criterion 4) |
| Symlinks break on Windows | Setup is re-runnable; documented as the fix |
| Kit becomes coupled to one agent vendor | `AGENTS.md` stays the tool-agnostic entrypoint; skills are additive |
| Two setup scripts drift across repos | Flagged as **Q3** — not silently duplicated |

## Threat model

**SKIP** — documentation/process only. Setup script performs no network or privileged operations.

---

## Blocking questions (gates)

**Q1 — Skill names.** Proposed: `harness-onboard`, `sprint-contract`, `code-quality-gate`, `code-audit`,
`solidity-audit`, `security-checklist`, `harness-review`.
- **Recommendation:** as listed. `harness-` prefixes only where the bare noun would collide with a
  common existing skill name (`review`, `onboard`).

**Q2 — BOOTSTRAP removal timing.** Deprecate now and delete in `KIT-SKILLS-002`, or delete now?
- **Recommendation:** deprecate now. Deleting the only adoption path in the same sprint that introduces
  its replacement leaves no rollback. "Build to delete" — after the replacement is proven, not before.

**Q3 — Setup-script duplication.** A sibling pack repo already has a near-identical submodule + symlink
setup script. Two scripts solving the same problem will drift.
- **Recommendation:** accept the duplication for now and record it as known debt. Sharing it would couple
  the kit to a pack, which contradicts the pack-agnostic rule. Revisit only if both scripts churn.

**Q4 — Consumer migration.** Repos already bootstrapped from `BOOTSTRAP.md` (e.g. the docs repo, which
uses `.harness/contracts/`) are unaffected today but will need migrating eventually.
- **Recommendation:** out of scope here; write a migration note in `README.md` and track it as a separate
  contract per repo. Do not migrate anyone's repo from inside a kit sprint.

*Approve only if Q1–Q4 (or your edits) are acceptable.*

---

## VERIFY (run after EXECUTE)

```bash
cd "$HOME/mnt/harness-kit"

# 1. seven skills with frontmatter
for s in harness-onboard sprint-contract code-quality-gate code-audit solidity-audit security-checklist harness-review; do
  test -f "skills/$s/SKILL.md" || { echo "missing $s"; exit 1; }
  head -1 "skills/$s/SKILL.md" | grep -q '^---$' || { echo "$s: no frontmatter"; exit 1; }
  grep -q '^name:' "skills/$s/SKILL.md" && grep -q '^description:' "skills/$s/SKILL.md" || exit 1
done

# 2. every former template lands in exactly one skill, none left behind
test -z "$(ls templates/*.md 2>/dev/null)" || echo "templates/ not emptied"
test "$(find skills -path 'skills/.harness' -prune -o -name '*.md' -path '*/templates/*' -print | wc -l)" -eq 13

# 3. moves, not rewrites
git diff --cached -M --stat | grep -q '=>' || echo "expected renames"
git diff --cached -M --diff-filter=R --numstat | awk '$1!=0||$2!=0{print "CONTENT CHANGED: "$3; bad=1} END{exit bad+0}'

# 4. setup script idempotent + safe
test -x scripts/setup-harness-kit.sh
sh -n scripts/setup-harness-kit.sh

# 5. no stale template paths outside deprecated files
! grep -rn 'skills/.harness/templates/' --include='*.md' . \
  | grep -v '^./BOOTSTRAP.md' | grep -v '^./skills/.harness/' | grep -q .

# 6. working state untouched
git check-ignore -q skills/.harness/contracts && echo "contracts still ignored"

# 7/8. adoption + deprecation
grep -q 'submodule' README.md && grep -q '2.0.0' README.md
grep -qi 'deprecat' BOOTSTRAP.md && grep -qi 'deprecat' scripts/build-bootstrap.sh
sh scripts/build-bootstrap.sh >/dev/null

# 9. ledger
python3 -m json.tool FEATURES.json >/dev/null && grep -q 'KIT-SKILLS-001' FEATURES.json
git branch --show-current | grep -qv '^master$'
```

---

## FEATURES.json entry

```json
{
  "id": "KIT-SKILLS-001",
  "name": "Templates become skills; adoption moves from single-file BOOTSTRAP to git submodule",
  "priority": 1,
  "verify": "test -f skills/code-quality-gate/SKILL.md && test -f skills/code-audit/SKILL.md && test -x scripts/setup-harness-kit.sh && grep -q '2.0.0' README.md && python3 -m json.tool FEATURES.json >/dev/null",
  "status": "FAIL",
  "notes": "Contract: skills/.harness/contracts/KIT-SKILLS-001.md; profile: ops-docs; BREAKING (adoption model); blocks KIT-ERD-001"
}
```

---

## Criteria block

```criteria
- [KIT-SKILLS-001-1] Seven procedure skills exist with valid frontmatter
- [KIT-SKILLS-001-2] All 13 forms bundled inside exactly one skill; templates/ emptied
- [KIT-SKILLS-001-3] Forms moved not rewritten — zero content diff across renames
- [KIT-SKILLS-001-4] setup-harness-kit.sh is POSIX, idempotent, refuses foreign content
- [KIT-SKILLS-001-5] No stale skills/.harness/templates/ references outside deprecated files
- [KIT-SKILLS-001-6] skills/.harness working state untouched and still gitignored
- [KIT-SKILLS-001-7] README documents submodule adoption + pointer-bump upgrade; version 2.0.0
- [KIT-SKILLS-001-8] BOOTSTRAP + build script deprecated but still runnable
```

---

## Deviations / clarifications

| # | Item | Resolution |
|---|------|------------|
| 1 | Criterion 3 ("moves not rewrites, empty content diff") is unsatisfiable at branch HEAD, because §D7 also requires rewriting path references **inside** those same files | Split into two commits. `d503ac1` is the pure rename — 13 files, 0 insertions, 0 deletions, verifiable in isolation. `008248d` carries every content change. The criterion is checked against `d503ac1`, which is where it is meaningful. Implements the intent exactly; strictly more auditable than one commit. |
| 2 | Contract VERIFY counted `-name '*.md' -path '*/templates/*'` and expected 13 | Off by one — 12 `.md` plus `FEATURES.json`. VERIFY counts all files, not just `.md`. Contract text was wrong; output is right. |
| 3 | `templates/` remained on disk after `git mv` | Empty directory artifact — git does not track directories, nothing tracked remained. Removed with `rmdir`. |

## Path-reference style (design note)

Cross-references were rewritten to name **skills** ("the `security-checklist` skill") rather than
file paths. A path would bake in one tool's merge directory (`.agents/` vs `.claude/` vs `.cursor/`);
a skill name resolves wherever the repo wires them, so the kit stays tool-agnostic.

## Setup script — tested, not asserted

Exercised end to end in a throwaway consumer repo: 7 skills linked · symlinks resolve to real
content · `.claude`/`.cursor` wired · gitignore appended exactly once · **second run produced no
change** · refuses a `.agents/skills` it did not generate · project-local skills win on name
collision · a non-symlink `.cursor/skills` is left alone with a warning.

## VERIFY result

All checks green (23/23 after the empty-directory fix).
