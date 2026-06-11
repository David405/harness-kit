# Harness Kit

> *Better harness beats better model.*

A reusable, **tool-agnostic** and **project-agnostic** framework for AI-assisted engineering.
Drop it into any repo — new or existing — and it works the same way regardless of which
models or coding tools you use.

> **Agent = Model + Harness.** The model is the intelligence. The harness is everything that
> keeps it on track: the context, the constraints, the plan, the feedback. Better harness
> beats better model. This kit *is* the harness.

---

## What's in here

| File | Purpose |
|------|---------|
| `HARNESS.md` | The process. Read once. The 5 principles, 3 roles, and the session loop. |
| `LOOP.md` | The loop floor above the harness: cadence, state, and automation-readiness seams. |
| `SETUP.md` | Runnable setup checklist; see Adoption concepts below for the why behind the steps. |
| `templates/AGENTS.md` | Canonical project context. The open-standard file every tool reads. |
| `templates/FEATURES.json` | Progress tracker + test spec in one. The cross-session memory. |
| `templates/STATE.md` | Loop/triage working state, distinct from feature status and review packets. |
| `templates/SPRINT_CONTRACT.md` | The plan-before-code artifact (includes the grounded impact map). |
| `templates/EXECUTOR_HANDOFF.md` | The unambiguous instruction you hand to the implementing tool. |
| `templates/REVIEW_CHECKLIST.md` | The reviewer's evaluation artifact. |
| `templates/SECURITY_CHECKLIST.md` | Reviewer's hardening pass for money/auth/data/input changes. |
| `templates/REVIEW_PACKET.md` | Executor's ephemeral review packet — the context handed to the Reviewer. |

---

## The 60-second model

1. **Three roles, not three tools.** Architect plans. Executor implements. Reviewer judges.
   Map them to whatever models/tools you have (see `HARNESS.md` § Roles). The only hard rule:
   **the Reviewer is never the same instance that wrote the code.**

2. **Context lives in the repo, not in a chat.** No tool shares live memory with another.
   They share `AGENTS.md` + `FEATURES.json` + git history — committed files any tool re-reads
   at the start of every session. Keep those current and every tool stays on the same page.

3. **One loop, every time.**
   ```
   BOOT → CONTRACT → (human approves) → EXECUTE one feature → REVIEW → (human merges) → REPEAT
   ```

4. **Build to delete.** Every harness component encodes an assumption about what the model
   *can't* do. As models improve, prune the parts that stop earning their keep.

---

## Quick start

- **New project:** follow `SETUP.md` → "Greenfield". Fill `AGENTS.md`, seed `FEATURES.json`,
  run the loop.
- **Existing project:** follow `SETUP.md` → "Brownfield". Generate `AGENTS.md` from the real
  codebase first, then back-fill `FEATURES.json` from what already exists.

## Adoption concepts

`SETUP.md` is the runnable checklist. This section carries the why behind those steps.

- **Context comes from reality.** In brownfield repos, generate `AGENTS.md` from the actual
  codebase: manifests and lockfiles for stack facts, top-level structure, visible conventions,
  real dependency flow, and the repo's detected default branch. Flag inference; do not invent
  conventions.
- **Brownfield adopts, it does not impose.** The harness records the repo's existing
  conventions — default branch name, commit style, test layout, directory structure — into
  `AGENTS.md`. When the repo and kit disagree, the repo wins; kit defaults are for greenfield.
- **Humans verify the context.** A generated `AGENTS.md` becomes the shared memory every agent
  reads. Wrong facts there poison later sessions, so review it against the repo before trusting
  it.
- **Harvest existing AI docs before deleting them.** Informal files such as `.cursorrules` or
  old agent instructions often encode hard-won intent. Migrate those rules into `AGENTS.md`,
  confirm the harvest, then remove the old files so there is one source of truth.
- **Back-fill status from evidence.** Existing features that demonstrably work become `PASS`;
  known gaps or next work become `FAIL`. Each entry needs a concrete verify step.
- **For multi-repo workspaces, keep a map.** Use a root `AGENTS.md` for the workspace map
  and per-repo `AGENTS.md` files for local conventions. Keep one root `FEATURES.json` with
  area-prefixed IDs, and keep each session focused on one repo or concern.

## Install

Clone the kit and run the installer against your target repo. Review the script first —
it only writes files into the target and never commits or pushes.

```sh
git clone --depth 1 --branch <pinned-version-tag> https://github.com/<owner>/harness-kit /tmp/harness-kit
/tmp/harness-kit/install.sh /path/to/your-repo
```

Then follow the printed next steps (generate AGENTS.md, seed FEATURES.json).

A one-line `curl … | sh` form exists for trusted environments, but piping a remote script
to a shell executes code you haven't read — prefer clone-then-run, especially for repos
that handle money, auth, or user data.

## Update

Use `update.sh` only in a repo where the kit is already installed.

```sh
/tmp/harness-kit/update.sh /path/to/your-repo
```

Unlike install, update refuses to bootstrap a fresh repo. It refreshes kit-owned files only
(`HARNESS.md`, `SETUP.md`, `LOOP.md`, and `.harness/templates/*`), preserves generated
project files such as `AGENTS.md` and `FEATURES.json`, bumps `.harness/VERSION`, and reports
likely drift for manual migration. It never commits or pushes.

---

*This kit is a living standard. It will get simpler as models get better. That's the point.*
