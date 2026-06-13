# Release and Access Plan

This document defines how FreezeTagCircle should handle source control, pull requests, releases, Roblox Studio access, and deployments.

## Current Access State

As of 2026-06-13:

- Git remote is configured: `https://github.com/kelani34/FreezeTagCircle.git`
- GitHub CLI is authenticated as `kelani34`
- GitHub token has `repo` and `workflow` scopes
- Rojo CLI is installed: `7.6.1`
- Rokit is installed locally and project tools are pinned in `rokit.toml`
- Wally, Selene, StyLua, and Lune are installed through Rokit
- Roblox Studio is installed locally

This is enough to manage branches, commits, pull requests, GitHub releases, and CI setup from the repository side.

## Repository Operations

The project workflow supports:

- Branch creation
- Commits
- Pull requests
- PR descriptions
- Review response changes
- Tags
- GitHub releases
- GitHub Actions workflow files
- Version files and changelogs
- Merge strategy and PR merge execution when checks and project state support it

Preferred branch naming:

```text
feature/<short-purpose>
fix/<short-purpose>
chore/<short-purpose>
release/<version>
```

Default operating rules:

- Check out and fast-forward sync `main` before creating a new work branch.
- Use feature branches for meaningful work.
- Prefer draft PRs until validation is complete.
- Keep `main` releasable.
- Do not mix unrelated work in one PR.
- Run available local checks before pushing when practical.
- Use semantic version tags for releases.
- Do not auto-publish to Roblox production until staging deployment is proven.

Recommended release tag format:

```text
v0.1.0
v0.2.0
v1.0.0
```

Until the game is public, versions should use `0.x.y`:

- `0.1.0`: first local playable prototype
- `0.2.0`: first private playtest build
- `0.3.0`: first public-server readiness build
- `1.0.0`: launch candidate promoted to launch

## Roblox Studio Access Model

Source changes should not rely on manually clicking inside Roblox Studio. The durable workflow is:

1. Runtime code is edited in source-controlled files under `src/`.
2. Rojo serves the project from the repo.
3. Roblox Studio connects through the Rojo plugin.
4. Studio remains the place for visual map/layout editing and playtesting.

This keeps code, documentation, release scripts, and project files reviewable while keeping Studio useful for what it does best.

## Required Studio Setup

Install or update the Rojo Roblox Studio plugin so Studio can sync from the local Rojo server.

Command-line option:

```sh
rojo plugin install
```

After that:

1. Open Roblox Studio.
2. Open `Place1.rbxl` or the project place.
3. Start a Rojo server from this repository.
4. In Studio, open the Rojo plugin and connect to the local server.

## Deployment Access

For automated Roblox publishing without manual Studio publishing, the project needs Roblox Open Cloud credentials.

Recommended setup:

- Create a Roblox Open Cloud API key for this experience.
- Give it the narrowest permissions needed for place publishing.
- Add it to GitHub repository secrets as `ROBLOX_API_KEY`.
- Add universe/place identifiers as repository variables or config files.

Do not commit API keys to the repo.

Suggested GitHub secret and variable names:

```text
ROBLOX_API_KEY
ROBLOX_UNIVERSE_ID
ROBLOX_PLACE_ID
```

## Recommended Local Toolchain

The project currently has Rojo installed but not the rest of the Roblox quality toolchain.

Recommended additions:

- `rokit`: project-local Roblox toolchain manager.
- `wally`: package manager for Roblox dependencies.
- `selene`: Luau/Lua static analysis.
- `stylua`: formatter.
- `lune`: Luau scripting runtime for local automation.
- `run-in-roblox` or an equivalent test runner later, once automated in-Studio tests are useful.

Current project setup:

```sh
rokit install
```

Pinned tools:

- `rojo-rbx/rojo@7.6.1`
- `UpliftGames/wally@0.3.2`
- `Kampfkarren/selene@0.31.0`
- `JohnnyMorganz/StyLua@2.5.2`
- `lune-org/lune@0.10.4`

## CI Goals

The initial CI pipeline now:

1. Installs Rokit.
2. Installs pinned tools.
3. Validates the Wally manifest.
4. Runs formatting checks.
5. Runs static analysis.
6. Builds the Roblox place from Rojo.
7. Uploads the `.rbxlx` artifact.

Do not wire production auto-publishing until staging deployment is proven.

Environment details live in `docs/production/ENVIRONMENTS.md`.

## Release Discipline

Every meaningful release should include:

- Version tag
- Changelog entry
- Build artifact
- Roblox place version or deployment note
- Known issues
- Rollback path

The release path should be:

```text
feature branch -> PR -> main -> tagged build -> staging publish -> playtest -> production publish
```

For the earliest prototype, manual Studio playtesting is acceptable. Automated publishing should arrive once the Rojo build is stable.
