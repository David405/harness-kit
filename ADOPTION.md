# ADOPTION.md — Bootstrapping the Harness

Two paths. Pick the one that matches your situation. Both end in the same place: a repo with a
current `AGENTS.md`, a seeded `FEATURES.json`, and the session loop running.

---

## Path A — Existing project (Brownfield)

The hard part of an existing repo is that the context already exists in the code but not in a
form the agent can read at boot. You generate it.

### A1. Generate `AGENTS.md` from the real codebase

Point a capable model (acting as Architect) at the actual repo — via a coding tool with file
access, or by feeding it a flattened snapshot (`repomix`, `files-to-prompt`, or similar).
Prompt:

```
Analyze this repository and produce an AGENTS.md following the provided template.
Use ONLY real, verified facts from the code:
- actual stack and versions (from package manifests / lockfiles)
- real top-level structure (depth 2)
- conventions you can SEE in the code, not ones you'd recommend
- the actual dependency/layering flow if one exists
Flag anything you're inferring vs. confirming. Do not invent conventions.
```

Then **you** review it for accuracy. The model will guess; your job is to correct. This file
becomes the single source of truth, so wrong facts here poison every later session.

### A2. Back-fill `FEATURES.json` from what exists

List the features that already work as `PASS`, and the known gaps / next work as `FAIL`. You
don't need to enumerate the whole history — just enough that a fresh session knows what's done
and what's next. Each entry needs a real `verify` step.

```
From the codebase and any existing docs/tests, produce a FEATURES.json:
- features that demonstrably work (tests pass, in production) → PASS
- known incomplete / broken / next-up work → FAIL
Each entry must have a concrete, runnable verify step. No aspirational features.
```

### A3. Externalize existing conventions into rule files (optional)

If the project already has lint/format/type config, you're partway there (computational
feedforward exists). Add a rule file (`.cursor/rules/*.mdc`, or equivalent) for conventions
that live only in people's heads. Rule of thumb: **if you've explained it to the agent three
times, it belongs in a rule.** Keep always-on rules short — every token loads on every request.

### A4. Run one small loop to validate

Pick the smallest real `FAIL` item. Run the full loop (contract → approve → execute → review).
If the contract's impact map matched reality and the review caught what it should, your
`AGENTS.md` is good enough. If the Executor hit surprises, your context file is missing
something — fix `AGENTS.md`, don't just patch the code.

---

## Path B — New project (Greenfield)

### B1. Write `AGENTS.md` first, before code

Fill the template from your intended design. It's allowed to be aspirational here because
there's no code to contradict it yet — but keep it to decisions you've actually made.

### B2. Establish the dependency flow early

Decide the layering up front (e.g. `Types → Config → Repo → Service → Runtime → UI`) and put
it in `AGENTS.md`. This single constraint prevents most architectural drift later.

### B3. Seed `FEATURES.json` with the first milestone

Don't plan the whole product. List the first few features as `FAIL`, ordered by priority. The
loop will surface the rest.

### B4. Set up computational feedback before feature work

Linter, formatter, type checker, a test runner, and CI green on an empty project. This is the
cheapest, highest-leverage harness investment — it's deterministic feedback that costs nothing
per run. Now every feature ships against a working feedback loop.

### B5. Run the loop

Boot → contract → approve → execute → review → merge. Repeat.

---

## Multi-repo / workspace projects

If your "project" is several separate repos in one workspace (common for service-oriented
products), treat the workspace root as the index:

- A root `AGENTS.md` describing the **map**: which repo does what, ports, how they connect.
- A per-repo `AGENTS.md` for each package's own conventions.
- One `FEATURES.json` at the root, with feature IDs prefixed by area (`STORE-`, `BE-`, `MKT-`).
- **Hard rule:** one session works one repo / one concern. Don't mix a backend session and a
  frontend session, or two services, in the same context.

---

## Keeping it alive

- Update `AGENTS.md` when topology or major conventions change. A stale context file silently
  degrades every session that reads it.
- Update `FEATURES.json` after every ship — it's the cross-session memory.
- Re-run the **control audit** (HARNESS.md § 2×2) when adding tooling.
- Re-run **build-to-delete** on every model upgrade.

The single failure mode that breaks everything: **letting the committed context drift from
reality.** Because no tool shares live memory, the files *are* the shared understanding. Keep
them true.
