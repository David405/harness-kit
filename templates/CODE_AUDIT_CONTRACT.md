# CODE AUDIT CONTRACT — <AUDIT-NNN>: <short title>

> Written by the **agent**. Approved by the **human** before the audit begins.
> Work-type profile: **`code-audit`**. Periodic — never per sprint.
> The audit **produces findings and changes no code**. Fixes are separate contracts.

## Not the per-sprint gate

`CODE_QUALITY.md` and this contract are different instruments. Do not substitute one for the other.

| | `CODE_QUALITY.md` (gate) | This contract (audit) |
|---|---|---|
| Question | "Can this diff ship?" | "Where should we invest refactoring effort, and what is safe to touch?" |
| Scope | The diff | A declared subsystem, at a declared ref |
| Cadence | Every contract, at VERIFY | Milestone / quarter / pre-hardening / before a large refactor |
| Output | Checklist + blocking verdict | Prioritised report + findings |
| Grading | Deterministic — declared linter first | Judgement, validated against the repo |

---

## Absolute constraint — refactor implementation, not behaviour

Every recommendation must preserve **externally observable behaviour exactly as it is today**.
This outranks every other goal in this contract. Where code cleanliness and behavioural safety
conflict, **behavioural safety wins**.

An auditor must not recommend changing: business logic, workflows, calculations, API behaviour or
contracts, request/response shapes, return values, error-handling semantics, exception types or
propagation, persistence or database semantics, observable ordering, timing-dependent behaviour,
concurrency semantics, authentication or authorization, validation rules, configuration or feature-flag
behaviour, operationally-relied-upon logging, public interfaces, or dependency behaviour. Do not
upgrade or replace dependencies for cleanliness. Do not add speculative functionality.

If there is **any reasonable uncertainty** that a change could alter behaviour, do not present it as
ready to apply. File it as **"Potential improvement — requires behavioural verification"** and record
what must be proven first.

### Frozen contracts (work around these, never modify them)

Public APIs · exported functions, classes and types · CLI arguments · environment variables ·
configuration keys · database schemas and values · serialized formats · events · message schemas ·
queue payloads · HTTP routes and methods · request and response bodies · status codes · headers ·
error formats · user-facing strings consumers or tests may depend on · file formats · framework
lifecycle behaviour.

### Behavioural equivalence checklist

Validate before any finding is marked ready to apply. Any uncertain answer downgrades it to
verification-required.

- [ ] Same inputs accepted · same outputs produced · same errors produced
- [ ] Side effects and their ordering unchanged
- [ ] Execution ordering unchanged where observable
- [ ] Database and network operations equivalent
- [ ] State mutations, async behaviour and concurrency semantics equivalent
- [ ] Null/undefined handling and edge cases preserved
- [ ] Frozen contracts untouched
- [ ] Logging/telemetry semantics preserved where operationally relied upon

### How equivalence is proven

Judgement is not proof. For any finding that will become a refactor, name the
**characterization tests** that capture current behaviour. They must be written and **passing against
the code as it stands today** — that is what shows they encode existing behaviour rather than intended
behaviour — and must still pass unchanged afterwards. This replaces product TDD for refactor work, the
same way audits use PoC-first VERIFY.

Never weaken, skip or rewrite an existing test to make a refactor pass. A test failing after a refactor
is evidence the refactor is wrong.

---

## Scope (required — an undeclared scope produces a report nobody can act on)

- **Ref audited:** `<commit SHA or tag>` — findings are meaningless without it
- **Paths / modules in scope:** `<explicit list>`
- **Languages / stack:** `<from AGENTS.md>`
- **Out of scope:** `<paths>` — always excluding generated code, vendored code, migrations, fixtures/snapshots
- **Whole repo?** Allowed, but state it deliberately. On a large codebase it produces a report too big to act on; prefer one subsystem per audit.

## Prior context

- Previous audits / findings still open: `<refs or "none">`
- Known accepted risks not to re-report: `<list or "none">`

---

## Review taxonomy

Work through each category. Record "no material findings" rather than omitting a category.

- [ ] **1. Coding best practices** — separation of concerns, abstraction consistency, responsibility boundaries, encapsulation, coupling, language/framework idioms, resource lifecycle, scope breadth
- [ ] **2. Duplication** — exact and near duplication, repeated conditionals, validation, transformations, mapping, error handling, boilerplate. Separate **harmful** duplication from **acceptable** duplication that represents genuinely different concepts
- [ ] **3. Optimisation** — algorithmic complexity, repeated computation, redundant loops/parsing/serialization, collection use, allocations, duplicate queries, N+1, avoidable I/O, work inside loops, safe early exits
- [ ] **4. Code smells** — long functions, god classes, feature envy, shotgun surgery, divergent change, primitive obsession, data clumps, parameter lists, boolean flags, deep nesting, complex conditionals, temporal coupling, hidden dependencies, shared mutable state, dead code, inappropriate intimacy, lazy classes, middle-man, speculative generality, leaky abstractions, stringly-typed behaviour, magic values, ambiguous null handling
- [ ] **5. Comments** — restating code, explaining obvious syntax, stale or easily-staled, compensating for poor naming, "what" instead of "why", verbose noise, history better held in version control, commented-out code, dead TODOs. **Preserve** comments carrying non-obvious business constraints, external-system limits, compatibility or security reasons, counterintuitive rationale, performance trade-offs, and known-issue workarounds
- [ ] **6. Readability** — naming across all kinds, function size and responsibility, nesting, control flow, grouping, abstraction level, local reasoning, implicit assumptions, cleverness, dense expressions, complex ternaries, ambiguous abbreviations
- [ ] **7. Maintainability** — coupling and cohesion, scattered logic, fragile abstractions, multiple sources of truth, repeated domain rules, module boundaries, isolated side effects, testability, blast radius, scattered configuration, dependency direction, circular dependencies, layering violations
- [ ] **8. Function quality** — single responsibility, accurate naming, mixed abstraction levels, unnecessary mutation, hidden side effects, parameter count, error handling tangled with logic. Do **not** blindly recommend smaller functions; a function should be as small as it can be while staying cohesive
- [ ] **9. Conditional logic** — duplicate or contradictory conditions, repeated guards, unclear booleans, negative complexity, long chains, guard-clause opportunities. Conditionals are a common regression source — never simplify unless equivalence is obvious
- [ ] **10. Error handling** — swallowed errors, empty catches, overly broad catches, duplicated handling, log-and-rethrow producing duplicate logs, resource cleanup, handling tangled with unrelated logic
- [ ] **11. Data flow and state** — unnecessary mutation, duplicate representations of the same state, stored derived data, synchronization, hidden or global state, shared mutable objects, unclear ownership
- [ ] **12. Tests and regression risk** — untested behaviour, high-risk code needing characterization first, existing tests that already prove equivalence, boundary conditions and side effects needing verification
- [ ] **13. Dead / redundant code** — be conservative. Before proposing deletion, consider reflection, dynamic imports, dependency injection, framework conventions, template references, external consumers, public APIs, CLI invocation, configuration references, serialization, plugins, runtime registration. If usage cannot be conclusively determined, **say so**
- [ ] **14. Over-engineering** — excessive abstraction or interfaces, wrappers, single-implementation factories, deep inheritance, premature extensibility, local problems solved with generic frameworks, indirection without value
- [ ] **15. Under-engineering** — repeated domain rules, giant procedural blocks, absent module boundaries, mixed responsibilities, hard-coded assumptions spread across files

---

## Rubrics

**Severity** — Critical · High · Medium · Low · Informational. Same scale as `AUDIT_FINDING.md`.
Do not use Critical casually.

**Confidence** — High (equivalence and benefit clear) · Medium (likely safe, context needs checking) ·
Low (needs investigation). **Low-confidence findings must never be presented as ready to apply.**

**Regression risk** — Very Low · Low · Medium · High, with a stated reason.

**Prioritise by impact × confidence ÷ regression risk.** Prefer strong benefit at low regression risk.

**Optimisation findings** additionally state: proven/obvious · likely · speculative-requires-profiling.
Never present a speculative performance assumption as fact.

---

## Discipline

**Evidence.** Every finding cites file path, module, function, and the actual pattern observed. Never
invent paths, line numbers, dependencies, call sites, or behaviour. If something cannot be verified,
say so explicitly.

**Validate before reporting.** Inspect call sites, imports, consumers, implementations, tests,
interfaces, configuration, serialization, framework registration and routes. A locally attractive
refactor may be unsafe repository-wide.

**Materiality.** A finding must make the code materially harder to understand, create meaningful
duplication, make change riskier, increase defect likelihood, add unnecessary complexity, cause obvious
inefficiency, violate a meaningful convention, obscure behaviour, or create maintenance burden. Code
that is unconventional but clear, safe and locally appropriate is **not** a finding. Do not flood the
report with nits.

**Minimal diff.** Recommend the smallest change achieving a meaningful improvement. No cascading
refactors — a rename should not become rename → interface → move → factory → restructure.

---

## Report

1. **Executive summary** — overall quality, strengths, main maintainability concerns, major duplication patterns, most valuable low-risk improvements, general regression risk of refactoring this codebase. Do not exaggerate.
2. **Prioritised findings** — one `CODE_AUDIT_FINDING.md` each
3. **Duplication report** — table: locations · duplicated concept · impact · suggested refactor · regression risk
4. **Comment quality** — keep · redundant · replace with clearer code · stale/misleading · commented-out
5. **Readability hotspots** — highest cognitive load, and why
6. **Maintainability hotspots** — coupling, responsibilities, repeated domain knowledge, blast radius, fragile abstractions
7. **Optimisation** — safe/obvious, separated from profiling-required
8. **Safe refactors** — Very Low / Low regression risk: location · change · benefit · risk · required verification
9. **Refactors NOT to attempt yet** — tempting but too uncertain, and what must be understood or tested first. **This section is required**, not optional
10. **Suggested sequence** — characterization coverage first, then naming/readability, then unquestionably redundant code, then obvious duplication, then low-risk control flow, then structural work. Each stage leaves the codebase working. No big-bang refactors
11. **Verification checklist** — tailored to this repo's actual commands from `AGENTS.md`

### Possible existing functional bugs — NOT PART OF THIS AUDIT

Report suspected functional bugs here with evidence. **Do not fix them.** Each becomes its own contract.

---

## Findings → tracked work

The audit **proposes** the seed block below. A **human accepts** findings into `FEATURES.json` —
consistent with `PASS` being human-only, and it stops a long report flooding the tracker.
Each accepted finding becomes one sprint contract; behaviour-preserving ones carry the
characterization-test quality gate.

```json
{
  "id": "<AREA-NNN>",
  "name": "<finding title>",
  "priority": "<n>",
  "verify": "<characterization + declared test command from AGENTS.md>",
  "status": "FAIL",
  "notes": "From <AUDIT-NNN>-F<nn>; severity <s>; regression risk <r>"
}
```

## Success criteria (this audit)

1. Every taxonomy category worked, including those recorded as "no material findings"
2. Every finding carries severity, confidence, regression risk, and cited evidence
3. Every ready-to-apply finding passes the equivalence checklist; uncertain ones are marked verification-required
4. Findings are prioritised by the stated formula
5. Section 9 (refactors not to attempt) is populated
6. Seed block proposed; no `FEATURES.json` entry created without human acceptance
7. No code changed by this audit — `git status` clean apart from audit documents

## VERIFY

```bash
# audit produced documents only
git status --porcelain | grep -v '<audit doc path>' | grep -q . && echo "CODE CHANGED — FAIL" || echo "docs only — ok"

# the audited ref is recorded
grep -q '<commit-or-tag>' <this contract>
```

## Human approval gate

- **Scope approved:** <pending / yes + date>
- **Findings accepted into FEATURES.json:** <list, human-signed>
