# SETUP.md — Setup Flow

> Runnable checklist for installing the harness into a project. For the WHY behind each
> step, see ADOPTION.md. This file is the do-this-in-this-order quickstart.

## The shared skeleton

Every path follows: install → context (AGENTS.md) → feedback baseline → seed FEATURES.json
→ validate via loop. The paths differ only in where context comes from.

## Path A — Greenfield (new project)

1. **[script]** Install kit: `install.sh <project>` — *done when: .harness/ + kit files present.*
2. **[architect+human]** Write AGENTS.md from intent — stack, dependency-flow layering,
   invariants. Aspirational allowed (no code to contradict yet), but only decisions actually
   made. — *done when: reviewed and reflects real decisions.*
3. **[human]** Set up the feedback floor BEFORE any feature: lint, format, typecheck, test
   runner, CI green on the empty repo. — *done when: CI is green on an empty project.*
4. **[architect]** Seed FEATURES.json with the FIRST MILESTONE ONLY (a few features, FAIL,
   prioritized). Don't plan the whole product. — *done when: valid JSON, first features listed.*
5. **[loop]** Run the loop — the first sprint IS the validation. — *done when: first sprint completes cleanly.*

## Path B — Brownfield (existing code, no AI docs)

1. **[script]** Install kit. — *done when: .harness/ + kit files present.*
2. **[script+human]** Detect & record conventions — default branch
   (`git symbolic-ref --short refs/remotes/origin/HEAD`), commit style, test layout. Adopt
   the repo's conventions; do not impose the kit's. — *done when: conventions recorded for AGENTS.md.*
3. **[architect+human]** Generate AGENTS.md from the REAL codebase, then human-verify every
   fact against the repo. — *done when: facts confirmed (a wrong fact here poisons every session).*
4. **[human]** Establish the feedback baseline: confirm the existing test/lint/build commands
   actually run; record them in AGENTS.md "How we work here". — *done when: commands verified to run.*
5. **[architect+human]** Seed FEATURES.json: what works → PASS, what's broken/next → FAIL. — *done when: valid JSON.*
6. **[loop]** Validate with one tiny real sprint. If the executor hits surprises the context
   didn't predict, fix AGENTS.md — not just the code. — *done when: one sprint completes cleanly.*

## Path C — Brownfield WITH existing informal AI docs (.cursorrules, hand-written CLAUDE.md, etc.)

1. **[script]** Install kit. — *done when: .harness/ + kit files present.*
2. **[architect+human]** HARVEST existing AI docs: read .cursorrules / existing CLAUDE.md /
   scattered AI instructions and migrate their conventions and rules into AGENTS.md. These
   encode hard-won intent — preserve all of it. — *done when: every rule copied into AGENTS.md.*
3. **[script+human]** Detect & record conventions (as Path B step 2). — *done when: recorded.*
4. **[architect+human]** Complete AGENTS.md from the real codebase PLUS the harvested rules,
   then human-verify. — *done when: harvested rules confirmed present and facts verified.*
5. **[human]** VERIFY the harvest, THEN delete the old AI docs (.cursorrules / old CLAUDE.md)
   so AGENTS.md is the single source of truth. NEVER delete before verifying — losing
   hand-tuned rules to a bad migration is the failure to avoid. — *done when: harvest confirmed,
   old files removed, AGENTS.md is sole context.*
6. **[human+architect]** Feedback baseline + seed FEATURES.json (as Path B steps 4–5). — *done when: valid JSON, commands verified.*
7. **[loop]** Validate with one tiny real sprint. — *done when: one sprint completes cleanly.*
