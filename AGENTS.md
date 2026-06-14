# FreezeTagCircle Agent Memory

FreezeTagCircle is a Roblox multiplayer game in Phase 1 prototype development.

## Current Operating Rules

- Always check out `main` and pull `origin/main --ff-only` before creating a new work branch.
- Use scoped branches:
  - `feature/<short-purpose>`
  - `fix/<short-purpose>`
  - `chore/<short-purpose>`
  - `release/<version>`
- Use conventional commits.
- Keep PRs focused and reviewable.
- Use draft PRs until validation is complete.
- Request review when the change carries meaningful gameplay, infrastructure, release, or security risk.
- Resolve or explicitly answer review comments before merge.
- Squash merge ordinary PRs and delete merged branches.

## Required Local Checks

Run these before PRs unless a check is not relevant and the final response explains why:

```sh
lune run scripts/tooling-doctor.luau
wally manifest-to-json > /dev/null
lune run scripts/test.luau
stylua --check src scripts tests
selene src scripts tests
rojo build default.project.json -o build/FreezeTagCircle.rbxlx
```

Run this when Roblox services, remotes, server/client integration, Studio-authored instances, or gameplay systems change and Roblox Studio is available:

```sh
lune run scripts/integration-test.luau
```

## Documentation Duties

Update these docs whenever the work changes their domain:

- `docs/BACKLOG.md`
- `docs/DECISION_LOG.md`
- `docs/TECHNICAL_ARCHITECTURE.md`
- `docs/TEST_STRATEGY.md`
- `docs/research/`
- `docs/production/`

## Environment Policy

- `main` is the releasable integration branch.
- Do not add a long-lived `develop` branch yet.
- Create a Roblox staging place before any production publishing.
- Do not enable production auto-publish until staging publish and smoke tests are proven.

## Current Next Target

The next gameplay target is `FTC-113`: basic client UI prompts.
