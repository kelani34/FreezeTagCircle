---
name: freezetagcircle-roundup
description: Prepare, validate, and close out FreezeTagCircle development sessions. Use when starting work in the FreezeTagCircle repo, ending a session, creating or merging PRs, updating project memory, checking docs/backlog/decisions/research/production notes, enforcing branch/issue/label/Copilot-review workflow, or running the project roundup before handing off.
---

# FreezeTagCircle Roundup

## Start-Of-Session Workflow

1. Read `AGENTS.md`.
2. Check out `main`.
3. Pull latest `origin/main` with `--ff-only`.
4. Inspect `git status --short --branch`.
5. Read `docs/BACKLOG.md`, `docs/DECISION_LOG.md`, and the most relevant design or architecture docs.
6. Create a scoped branch only after `main` is clean and current.

Use branch names:

- `feature/<short-purpose>`
- `fix/<short-purpose>`
- `chore/<short-purpose>`
- `release/<version>`

Use conventional commit names such as:

- `feat: add circle spawn placement`
- `fix: preserve round snapshot actors`
- `chore: update release checklist`

## Required Validation

Before every PR, run the relevant checks:

```sh
lune run scripts/tooling-doctor.luau
wally manifest-to-json > /dev/null
lune run scripts/test.luau
stylua --check src scripts tests
selene src scripts tests
rojo build default.project.json -o build/FreezeTagCircle.rbxlx
```

If Roblox services, Studio-authored instances, remotes, characters, or server/client behavior changed, also run when Roblox Studio is available:

```sh
lune run scripts/integration-test.luau
```

## Documentation Roundup

Update project docs in the same PR when behavior or process changes:

- `docs/BACKLOG.md` for task status and next target.
- `docs/DECISION_LOG.md` for accepted tradeoffs.
- `docs/TECHNICAL_ARCHITECTURE.md` for runtime ownership changes.
- `docs/TEST_STRATEGY.md` for testing changes.
- `docs/research/` for evaluated options, tool research, or rejected approaches.
- `docs/production/` for release, staging, playtest, or deployment changes.
- `AGENTS.md` when durable project operating memory changes.

## GitHub Workflow

Every meaningful change should have:

- A linked GitHub issue when it represents product, gameplay, testing, release, or infrastructure work.
- Labels covering type, area, priority, and status.
- A draft PR until validation is complete.
- Copilot code review requested before merge.
- CI green before merge.
- Review comments resolved or explicitly answered before merge.

Use squash merges for ordinary feature/chore/fix PRs and delete merged branches.

## End-Of-Session Roundup

Before final handoff:

1. Confirm `git status --short --branch`.
2. Confirm branch, PR, CI, and merge state.
3. Summarize what changed.
4. List validations run and any skipped checks.
5. State the next backlog item.
6. Mention open blockers, staging needs, or review follow-ups.

