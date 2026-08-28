---
name: erd-authoring
description: >-
  Turns a brief or PRD into an Engineering Requirements Document and its
  architecture companion, through five human-gated stages — frame, decisions,
  design, contracts, slices — then seeds FEATURES.json so each slice becomes a
  sprint contract. Work-type profile product-erd. Use when defining a new
  product, service or substantial feature before any contract exists, or when
  the user asks to write an ERD, design doc, or engineering requirements.
---

# ERD authoring

> Kit-owned. Edit in the harness-kit repo, not in the consumer repo.

Profile: **`product-erd`**. The step before contracts exist. Produces `erd.md` +
`architecture.md`, and a `FEATURES.json` seed that turns each slice into a sprint contract.

## When to use

A new product or service, a new domain, or a contract crossing teams or repos.

## Where it sits in the loop

`BOOT → **ERD?** → RESEARCH? → CONTRACT`. Step 2 is a routing test with three conditions (see the
agent process). This skill carries its own discovery research in **S0**; the loop's `RESEARCH?` is
contract-scoped and comes after. Never dual-run them.

## When not to use

**A feature inside an already-documented service goes straight to `sprint-contract`.** This stage
is expensive by design; running it on ordinary work is ceremony. Not the same as optional RESEARCH:
RESEARCH distills open questions for *one* contract, this produces a durable document feeding *many*.

## The five stages — stop at every gate

The agent stops at every gate and waits for a human. Do not run stages together.

| Stage | Produce | Gate |
|-------|---------|------|
| **S0 Frame** | Input inventory (brief, PRD, designs, tickets, related repos, code to reuse); executive summary; goals; **non-goals** | Human confirms the scope boundary |
| **S1 Decisions** | Every decision the ERD must lock — `Topic \| Options \| Recommendation \| Status`. **No design written yet** | Human locks or defers each; deferrals become Open Questions with an owner and needed-by |
| **S2 Design** | `architecture.md` — mental model, diagram, boundaries, control flows, data ownership | Human confirms the shape |
| **S3 Contracts** | ERD design sections: standards, API/event/data contracts, error model, acceptance criteria, risks | Human confirms contracts and falsifiable criteria |
| **S4 Slices** | `Implementation plan: Feature slices` **plus** the `FEATURES.json` seed | Human PASS |

**S1 is the load-bearing stage.** Decisions elicited before prose is written are decisions that do
not resurface later as a string of one-line lock contracts, or as reversals of already-written text.

## Rules that matter

- **Slices are written last**, only after S0–S3 are stable.
- Slice 1 is scaffolding for a deployable service; **N/A** for a library, contract or docs target.
- Every slice states a concrete working behaviour and a functional test mirroring a user story —
  never a layer cake ("schema", then "API", then "UI").
- **S4 emits one `FEATURES.json` entry per slice**, `verify` written from the repo's `AGENTS.md`
  runner. That seed is the ERD → contract bridge; without it the ERD is a document nobody acts on.
- Apply the **standards pack the consumer's `AGENTS.md` declares**. Record any divergence in Design
  Decisions with rationale — never diverge silently. The kit names no standard of its own.

## Forms

`templates/ERD_CONTRACT.md` · `templates/ERD.md` · `templates/ARCHITECTURE.md`
