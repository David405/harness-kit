# HARNESS.md — The Process

> Tool-agnostic, project-agnostic AI-assisted engineering process.
> Version 1.0 (generalized from AI_WORKFLOW.md v2.1).

---

## The core idea

**Agent = Model + Harness.** The harness is everything that isn't the model — constraints,
feedback loops, documentation, tool permissions. Strip it away and you have a raw model
guessing through your codebase. Add the right harness and you have a system that ships
correct code.

OS analogy: Model = CPU, context window = RAM, **harness = the operating system**, agent =
the app. Most people run apps with no OS. That's why their agents fail in production.

---

## The 5 principles

Everything below derives from these. Three independent teams arrived at them separately.

1. **Context beats instructions.** Show the model the *real* state of the world — actual file
   paths, existing patterns, current progress — not abstract instructions. Grounded context
   produces code that fits. Vague descriptions produce hallucinated APIs.

2. **Planning and execution must be separated.** Never plan and build in the same pass. The
   planning step can be done by AI, but it must be a *separate* step whose output is reviewed
   before implementation begins.

3. **Feedback loops are non-negotiable.** A harness without feedback is a prompt with extra
   steps. Use both deterministic feedback (tests, linters, type checks) and inferential
   feedback (a reviewing model). Layer them.

4. **One thing at a time.** Forced incrementalism. One feature → implement → verify → commit →
   repeat. Agents doing too much at once run out of context and silently drop requirements.

5. **The codebase IS the documentation.** No separate knowledge base. If a convention or
   decision isn't in the repo, the agent won't know it. Invest in code organization and you
   get better agent performance for free.

---

## The 3 roles

Roles are abstract. Map each to whatever model or tool you have. **The mapping is
configurable; the separation is not.**

| Role | Job | Hard rule |
|------|-----|-----------|
| **Architect** | System design. Sprint contracts. Grounded impact maps. Defines `FEATURES.json` + verify criteria. | Plans; does not implement in the same pass. |
| **Executor** | Implements one feature against the approved contract. Runs the verify step. | Does not decide scope or architecture. |
| **Reviewer** | Evaluates executor output against the contract's success criteria. The skeptical judge. | **Never the same instance that wrote the code.** |
| *(Human)* | Approves the contract. Merges or loops back. Owns the gates. | Final authority at every boundary. |

**Why the separation is non-negotiable:** a model evaluating its own output gives itself
straight A's even when the work is mediocre. The Executor is incentivized toward "done"; the
Reviewer toward "correct." Making a standalone reviewer skeptical is far easier than making a
generator self-critical. If one tool both wrote and reviewed the code, the review is theatre.

> **Guardrail:** even if the Architect writes implementation directly in a pinch, that code
> still gets an independent review pass before merge — a fresh instance, or a different tool.
> No code ships reviewed only by the thing that wrote it.

**Example mapping** (yours may differ — that's fine):
`Architect + Reviewer = a strong reasoning model in chat/CLI` · `Executor = an in-editor coding tool`.

---

## The session loop

```
BOOT → CONTRACT → [HUMAN APPROVES] → EXECUTE one feature → REVIEW → [HUMAN MERGES] → REPEAT
```

### 1. BOOT (same every session)

```
1. Confirm working directory + current git branch
2. Read git log (last ~10 commits) and FEATURES.json
3. Identify highest-priority feature with status FAIL
4. Confirm the build compiles / dev server runs
5. Run basic end-to-end verification of current state
6. Implement ONE feature (the one from step 3)  ← happens in EXECUTE
7. Commit with a descriptive message + update FEATURES.json  ← happens after REVIEW
```

Wire steps 1–5 into a `/boot` command or a pinned prompt so no session starts blind.

### 2. CONTRACT (Architect)

Before any code: produce a **Sprint Contract** (template provided). It states scope (in and
out), the files that will change, success criteria, and edge cases — plus a **grounded impact
map** using real paths verified against the repo. Iterate until correct. This is cheap;
fixing half-built code is expensive. Target each contract at one feature / a handful of files.

> **Grounded vs educated:** an impact map is only *grounded* if the instance producing it saw
> the repo. If the Architect is working from a summary, the map is *educated* — useful for
> planning, but the Executor must verify every path against reality before implementing.

### 3. HUMAN APPROVES

The human reviews the contract, answers any blocking questions, adjusts scope. Implementation
does not begin until approved. Blocking questions are explicit gates, not optional.

### 4. EXECUTE (Executor)

Implements the single feature against the approved contract. Prompt discipline:
- One task per prompt. No chaining.
- Structured output: "Return only the changed code, no commentary."
- Specify depth: "Minimal working implementation."
- Paste snippets, not whole files. Reference `path:Lstart-Lend`.
- Compress error logs to the meaningful lines.
- Fresh session after ~10–15 turns; long contexts degrade and cost grows quadratically.

### 5. REVIEW (Reviewer — different instance)

Evaluate the diff against the contract's success criteria. Use the Review Checklist template.
Check the invariants, look for hallucinated paths, dropped requirements, scope creep. Flag, don't fix.

### 6. HUMAN MERGES → update `FEATURES.json` → REPEAT

Mark the feature PASS only after it actually verifies. Commit. Loop to the next FAIL.

---

## The control audit (2×2)

Periodically check the harness is balanced. Classify every control:

|  | **Computational** (deterministic, ms) | **Inferential** (uses a model, sec) |
|---|---|---|
| **Feedforward** (before — guides) | type system, linters, arch rules, rule files | spec docs, sprint contracts, impact maps |
| **Feedback** (after — sensors) | test suites, coverage, CI | model code-reviewer, behavior validator, E2E |

**Neither feedforward nor feedback alone works.** If a project is all rules and no tests
confirming the agent followed them, the harness is broken. Aim to populate all four cells.

---

## Build to delete

Every harness component encodes an assumption about what the model *can't* do. As models
improve, those assumptions expire and the component becomes pure overhead — tokens on every
run, zero added quality.

- Design every component to be **removable**. Don't hard-wire harness logic into business code.
- **On every model upgrade, ask first: "what can we now delete?"**
- Periodically turn each component off, re-run a representative task, measure. No change → delete.

Trend to ride: better model → simpler harness → cheaper run → faster output.

---

## Cost reality (set expectations)

A full harness costs meaningfully more per run than a raw one-shot — more passes, more
review, more tokens. That buys working software instead of a demo that only looks right in
screenshots. Whether it's worth it depends entirely on what a broken release costs you.
High-stakes paths (money, auth, data integrity) justify the full harness. Throwaway
prototypes don't. Choose per task.
