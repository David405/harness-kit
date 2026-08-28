# ERD CONTRACT — <ERD-NNN>: <product or feature>

> Written by the **agent**. Approved by the **human** before S0 begins.
> Work-type profile: **`product-erd`**. Produces documents; ships no code.

## Sources (required)

- **Brief / PRD:** `<link or path>`
- **Designs, tickets, prior art:** `<list>`
- **Related repos / code to reuse:** `<list>`
- **Standards pack declared in `AGENTS.md`:** `<name, or "none">`

## Target

- **Deliverables:** `<path>/erd.md` + `<path>/architecture.md`
- **Consuming repo(s):** `<where the sprint contracts will run>`
- **Deployable shape:** `<service | library | contract | docs>` — decides whether slice 1 is scaffolding

---

## Stage gate log

The agent stops at every gate. Record who approved and when; an unsigned gate blocks the next stage.

| Stage | Output | Approved by | Date |
|-------|--------|-------------|------|
| S0 Frame — summary, goals, **non-goals** | | | |
| S1 Decisions — locked or deferred with owner | | | |
| S2 Design — `architecture.md` | | | |
| S3 Contracts — API/data/error/acceptance/risks | | | |
| S4 Slices — slice table + `FEATURES.json` seed | | | |

---

## S1 decision register

Every decision the ERD must lock. Deferred rows move to the ERD's Open Questions **with an owner and
a needed-by** — never left implicit.

| Topic | Options | Recommendation | Status | Owner | Needed by |
|-------|---------|----------------|--------|-------|-----------|
|  |  |  | Locked / Open |  |  |

## Non-goals (from S0 — restate, do not summarise)

- <what this explicitly does not cover, and where that work goes instead>

---

## Success criteria

1. Every required ERD section present; no `TODO`/`TBD` placeholders remain.
2. Non-goals explicit (at least one).
3. Every decision either **Locked**, or Open with an owner and a needed-by.
4. Acceptance criteria falsifiable — each names its verification method.
5. Slices are ticket-ready, dependency-ordered; each has a concrete working behaviour and a functional test.
6. Slice 1 is scaffolding **or** explicitly N/A for a non-deployable target.
7. `FEATURES.json` seed emitted, one entry per slice, each `verify` a runnable command from `AGENTS.md`.
8. Risks carry an early signal and a mitigation.
9. Declared standards pack applied, or divergence recorded in Design Decisions with rationale.
10. `erd.md` and `architecture.md` link to each other.

## Quality gates (tick or N/A)

- [ ] Falsifiable success criteria (always required)
- [ ] Non-goals explicit
- [ ] Decisions locked or owned
- [ ] Slices ticket-ready with functional tests
- [ ] `FEATURES.json` seed emitted
- [ ] Standards divergence recorded — or **N/A**
- [ ] Code-quality gate — **N/A** (`product-erd` ships no code)
- [ ] TDD / behaviour-preserving refactor — **N/A**

## VERIFY

```bash
# structure
grep -q '## Goals and Non-Goals'                 <erd path>
grep -q '## Implementation plan: Feature slices' <erd path>
grep -q '## Design Decisions'                    <erd path>

# no unresolved placeholders
! grep -Eqi 'TODO|TBD|<fill' <erd path> <architecture path>

# every open question has an owner (no empty owner cells)
# every slice row has a functional test (no empty test cells)

# both documents cross-link
grep -q architecture <erd path> && grep -q erd <architecture path>

# the seed parses
python3 -m json.tool <seed file> >/dev/null
```

## Blocking questions

<Anything that must be answered before S0. If none, write "None.">

## Human approval gate

- **Scope approved:** <pending / yes + date>
- **Seed accepted into `FEATURES.json`:** <human-signed — the agent never accepts its own seed>
