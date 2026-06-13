# Environments

FreezeTagCircle needs separate development, staging, and production paths before automated Roblox publishing is enabled.

## Local Development

Purpose:

- Source editing.
- Rojo sync.
- Local Studio playtests.
- Headless tests and CI-equivalent checks.

Source:

- Any feature branch.

Commands:

```sh
rojo serve default.project.json
lune run scripts/test.luau
stylua --check src scripts tests
selene src scripts tests
rojo build default.project.json -o build/FreezeTagCircle.rbxlx
```

## GitHub PR Environment

Purpose:

- Validate every branch before merge.
- Produce a build artifact.
- Prevent broken infrastructure from reaching `main`.

Current status:

- CI runs on pull requests and pushes to `main`.
- CI does not deploy to Roblox.

## Roblox Staging

Purpose:

- Test the built game in a real Roblox experience before production.
- Validate Open Cloud publishing.
- Run private playtests safely.

Required before use:

- Create a dedicated Roblox staging place or experience.
- Add GitHub secret: `ROBLOX_API_KEY`.
- Add GitHub variables: `ROBLOX_STAGING_UNIVERSE_ID`, `ROBLOX_STAGING_PLACE_ID`.
- Add a staging publish workflow that runs only after CI passes.

Recommended trigger:

- Manual `workflow_dispatch` first.
- Later, release branches or `v0.x.0-rc` tags if the manual path is stable.

## Roblox Production

Purpose:

- Public player-facing game.

Required before use:

- Staging publishing is proven.
- Release checklist is complete.
- Rollback path is understood.
- Production place IDs are configured separately from staging.

Suggested GitHub variables:

- `ROBLOX_PRODUCTION_UNIVERSE_ID`
- `ROBLOX_PRODUCTION_PLACE_ID`

Production publishing should never be the first automated publishing target.

## Branch Policy

Default branch:

- `main`

Branch naming:

- `feature/<short-purpose>`
- `fix/<short-purpose>`
- `chore/<short-purpose>`
- `release/<version>`

Required workflow:

1. Check out `main`.
2. Pull latest `origin/main` with fast-forward only.
3. Create a scoped branch.
4. Commit with conventional commit naming.
5. Open a PR.
6. Wait for CI.
7. Squash merge when green and scoped.
8. Delete the branch.

Long-lived `develop` branch:

- Not recommended yet.
- Add only if `main` becomes too active for stable release preparation.
- Prefer staging deployments from validated PRs, release branches, or tags before adding branch complexity.

