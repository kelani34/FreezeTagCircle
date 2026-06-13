# Release and Access Plan

This document defines how FreezeTagCircle should handle source control, pull requests, releases, Roblox Studio access, and deployments.

## Current Access State

As of 2026-06-13:

- Git remote is configured: `https://github.com/kelani34/FreezeTagCircle.git`
- GitHub CLI is authenticated as `kelani34`
- GitHub token has `repo` and `workflow` scopes
- Rojo CLI is installed: `7.6.1`
- Roblox Studio is installed locally

This is enough to manage branches, commits, pull requests, GitHub releases, and CI setup from the repository side.

## Git Authority

Codex may manage:

- Branch creation
- Commits
- Pull requests
- PR descriptions
- Review response changes
- Tags
- GitHub releases
- GitHub Actions workflow files
- Version files and changelogs

Preferred branch naming:

```text
codex/<short-purpose>
```

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

Codex should not rely on manually clicking inside Roblox Studio for source changes. The durable workflow is:

1. Codex edits source-controlled files in `src/`.
2. Rojo serves the project from the repo.
3. Roblox Studio connects through the Rojo plugin.
4. Studio remains the place for visual map/layout editing and playtesting.

This gives Codex reliable control over code, documentation, release scripts, and project files while keeping Studio useful for what it does best.

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

For Codex to publish builds to Roblox without manual Studio publishing, the project needs Roblox Open Cloud credentials.

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

Recommended first step:

```sh
brew install rokit
```

Then pin tools in `rokit.toml` so every machine and CI runner uses the same versions.

## CI Goals

The initial CI pipeline should eventually:

1. Validate project file structure.
2. Run formatting checks.
3. Run static analysis.
4. Build the Roblox place from Rojo.
5. Upload build artifacts.
6. Optionally publish to a staging Roblox place on tags or release branches.

Do not wire production auto-publishing until staging deployment is proven.

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

