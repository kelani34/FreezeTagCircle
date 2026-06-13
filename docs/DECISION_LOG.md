# Decision Log

Record meaningful product, design, and technical decisions here.

Format:

```text
## D-000: Decision Title

Date: YYYY-MM-DD
Status: Proposed | Accepted | Rejected | Superseded

Context:

Decision:

Tradeoffs:

Follow-up:
```

## D-001: Begin With Documentation Before Gameplay Code

Date: 2026-06-13
Status: Accepted

Context:

The project currently contains a Roblox place file but no documented rules, architecture, roadmap, or tracking system. The gameplay concept has several unresolved rule and balance questions.

Decision:

Establish product, design, architecture, risk, decision, assumption, roadmap, and backlog documents before major gameplay implementation.

Tradeoffs:

This delays the first script slightly, but reduces the chance of building the wrong systems or hiding important ambiguity inside code.

Follow-up:

Use the Phase 1 backlog to move from planning into the smallest playable prototype.

## D-002: Prefer No-Elimination Scoring For The First Prototype

Date: 2026-06-13
Status: Proposed

Context:

Elimination can create long downtime in public Roblox servers, especially for new players.

Decision:

The first prototype should use scoring and quick resets rather than elimination.

Tradeoffs:

This may reduce high-stakes tension, but it supports faster learning, less frustration, and easier playtesting.

Follow-up:

Revisit after the core loop is tested with real players.

## D-003: Use Display Names Plus Icons Instead Of Countries Initially

Date: 2026-06-13
Status: Proposed

Context:

The historical playground game often used country names, but a public Roblox game needs a moderation-safe and globally comfortable identity system.

Decision:

Prototype with player display names plus assigned icons or colors. Treat country names as theme inspiration, not a required mechanic.

Tradeoffs:

This slightly reduces nostalgia, but avoids avoidable content, localization, and sensitivity issues.

Follow-up:

Test whether icons/colors are clear enough during caller selection.

## D-004: Pin Roblox Tooling With Rokit

Date: 2026-06-13
Status: Accepted

Context:

The project needs reproducible Roblox tooling before gameplay code grows. Rojo was installed globally, but Wally, Selene, StyLua, and Lune were not available on the project PATH.

Decision:

Use Rokit as the project toolchain manager and pin Rojo, Wally, Selene, StyLua, and Lune in `rokit.toml`.

Tradeoffs:

This adds a small setup step for new developers, but it avoids version drift between local machines and CI.

Follow-up:

Keep tool updates intentional and review any CI failures caused by tool upgrades before accepting new pinned versions.

## D-005: CI Builds Artifacts But Does Not Deploy Yet

Date: 2026-06-13
Status: Accepted

Context:

The project needs automated quality checks, but Roblox deployment credentials and staging release rules are not finalized.

Decision:

Add CI for pinned tool installation, package manifest validation, formatting, static analysis, and Rojo artifact builds. Do not publish to Roblox from CI yet.

Tradeoffs:

CI will catch basic tooling and source issues early, while deployment remains manual until Open Cloud credentials and staging workflow are ready.

Follow-up:

Add staging deployment after `ROBLOX_API_KEY`, `ROBLOX_UNIVERSE_ID`, and `ROBLOX_PLACE_ID` are configured safely.

## D-006: Start Gameplay Architecture With Plain ModuleScript Services

Date: 2026-06-13
Status: Accepted

Context:

The first Phase 1 implementation needs server-owned gameplay structure, but the project does not yet justify a larger framework.

Decision:

Start with plain ModuleScript services under `src/server`, shared contract modules under `src/shared`, and explicit entry points through `init.server.luau` and `init.client.luau`.

Tradeoffs:

This keeps the prototype easy for newer Roblox developers to understand. If service count or cross-service coordination becomes hard to manage later, the project can introduce a lightweight framework intentionally.

Follow-up:

Keep each service small and server-authoritative. Revisit framework needs only after the core loop is playable.

## D-007: Gate Round Start On Minimum Player Count

Date: 2026-06-13
Status: Accepted

Context:

The game needs to work in public Roblox servers where players can join or leave at any time. Starting the round loop with too few players would create broken or boring states.

Decision:

`RoundService` tracks active Roblox players, exposes minimum-player status in its snapshot, blocks `WaitingForPlayers -> Setup` until the configured minimum is met, and returns to `WaitingForPlayers` if the count drops too low mid-round.

Tradeoffs:

This does not yet auto-start rounds. That keeps the waiting gate independent from arena setup and spawn placement, which are separate Phase 1 tasks.

Follow-up:

Use this gate when implementing `FTC-105` and the first automatic setup transition.

## D-008: Add Headless Luau Tests Before More Gameplay

Date: 2026-06-13
Status: Accepted

Context:

The project is entering gameplay implementation, and shared contracts such as round states, remote names, and tuning constants will be referenced across server, client, and documentation.

Decision:

Add a small Lune-based test runner and initial shared-contract tests. Run these tests in CI before formatting, linting, and Rojo build validation.

Tradeoffs:

Headless tests cannot validate Roblox services or physics, but they are fast and protect contracts that should remain stable.

Follow-up:

Add Roblox-aware integration tests once server/client gameplay systems require Workspace, Players, characters, and remotes.

## D-009: Use Staging Before Production Publishing

Date: 2026-06-13
Status: Accepted

Context:

The project will eventually publish builds to Roblox through Open Cloud, but production publishing should not be the first automated deployment target.

Decision:

Use local development and PR CI first, then add a dedicated Roblox staging place for private playtests. Production publishing remains manual or separately gated until staging publish and smoke tests are proven.

Tradeoffs:

This adds setup work before public release, but it lowers the risk of breaking the player-facing game and gives playtests a safe target.

Follow-up:

Create the staging Roblox place, configure staging IDs in GitHub variables, and add a manual staging publish workflow after Open Cloud credentials are ready.

## D-010: Keep Main As The Integration Branch For Now

Date: 2026-06-13
Status: Accepted

Context:

The project needs disciplined branching, but adding a long-lived `develop` branch too early can create process overhead without solving a current problem.

Decision:

Use short-lived `feature/`, `fix/`, and `chore/` branches from the latest `main`. Keep `main` releasable and CI-backed. Add release branches or a long-lived development branch only if release preparation becomes difficult.

Tradeoffs:

This keeps the workflow simple and fast while the project is small. It requires consistent PR discipline and staging deployment gates before production.

Follow-up:

Revisit branch strategy once staging publishing exists and multiple gameplay features are in flight at the same time.
