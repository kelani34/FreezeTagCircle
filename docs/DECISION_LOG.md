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

## D-011: Add Local Roblox Studio Integration Gate

Date: 2026-06-13
Status: Accepted

Context:

Headless Luau tests cannot validate Roblox services, Studio-built place structure, or ModuleScripts loaded from Rojo-built places.

Decision:

Pin `run-in-roblox` through Rokit and add a local integration smoke test that builds the Rojo place, opens it in Roblox Studio, loads shared/server modules, starts `RoundService`, and validates the minimum-player setup gate.

Tradeoffs:

This gives real Roblox coverage locally, but GitHub-hosted Linux runners cannot run Roblox Studio. CI keeps headless tests while Roblox integration tests become a local/staging gate.

Follow-up:

Evaluate TestEZ and self-hosted runner options for richer service-level Roblox integration tests.

## D-012: Require Issues, Labels, And Review Discipline For PRs

Date: 2026-06-13
Status: Accepted

Context:

The project needs tighter GitHub process as gameplay, testing, release, and deployment work grows.

Decision:

Use GitHub issues for meaningful work, label PRs by type/area/priority/review needs, and request review before merging work with meaningful gameplay, infrastructure, release, or security risk.

Tradeoffs:

This adds process overhead, but it creates clearer traceability and review discipline before the game becomes larger.

Follow-up:

For low-risk repository hygiene, document why review is not required in the PR notes.

## D-013: Prefer Project-Local Skills Over Unvetted Roblox Skill Installs

Date: 2026-06-13
Status: Accepted

Context:

No trusted Roblox-specific Codex skill was found in the official curated list, and some search results for Roblox skills were unrelated to professional development or appeared unsafe.

Decision:

Create a project-local `freezetagcircle-roundup` skill and avoid installing unvetted third-party Roblox skills globally.

Tradeoffs:

This does not add broad external skill coverage immediately, but it keeps the agent workflow source-controlled, reviewable, and specific to FreezeTagCircle.

Follow-up:

Revisit third-party skills only after source review and relevance checks.

## D-014: Split Pure Spawn Math From Roblox Arena Placement

Date: 2026-06-14
Status: Accepted

Context:

Circle spawn placement needs to be deterministic, testable, and server-authoritative. Roblox character movement requires Roblox services, but the slot calculation itself does not.

Decision:

Use `src/shared/CircleSpawns.luau` for pure circle slot and user-id assignment math, and `src/server/ArenaService.luau` for Roblox-specific character placement. `RoundService` calls `ArenaService` during the `Setup` transition and stores the resulting spawn placement records in the round snapshot.

Tradeoffs:

This adds one shared helper and one server service, but keeps math covered by fast headless tests while isolating Roblox-specific character pivoting to a server-owned boundary.

Follow-up:

When center-zone detection begins, decide whether arenas remain procedural or move to Studio-authored markers for designer control.

## D-015: Use Deterministic Round-Robin Caller Assignment

Date: 2026-06-14
Status: Accepted

Context:

The prototype needs server-owned caller assignment before target selection can exist. The first version should be easy to test, predictable in snapshots, and fair enough for early play without introducing scoring or winner-based rotation yet.

Decision:

Use `src/shared/CallerSelection.luau` to select callers by sorting active `UserId` values and rotating by `roundNumber`. `RoundService` assigns `callerUserId` when entering `CallerChoosing`, keeps the current caller stable while they remain active, and reassigns during `CallerChoosing` if that caller leaves while enough players remain.

Tradeoffs:

Round-robin selection is less dramatic than winner-based caller transfer, but it is deterministic, simple to validate, and avoids accidentally rewarding or punishing players before the result rules are settled.

Follow-up:

Revisit caller rotation after target selection, tag resolution, and scoring exist.

## D-016: Lock One Server-Validated Target Per CallerChoosing Phase

Date: 2026-06-14
Status: Accepted

Context:

The caller needs to select another player before the round can move into the run-away phase. Public-server safety requires that the client never gets to declare the target as final truth.

Decision:

Add `src/server/TargetSelection.luau` as a pure server-owned validation helper. `RoundService.selectTarget` accepts target selections only during `CallerChoosing`, only from the current caller, only for active non-caller players, and only when no target is already locked. `CallerChoosing -> RunAway` is blocked until `calledUserId` is set to an active player.

Tradeoffs:

Locking the first valid target keeps the prototype simple and blocks target spam. It also means target changes are not supported yet, which is acceptable until caller UI and anti-spam tuning exist.

Follow-up:

Revisit target-change or cooldown behavior in `FTC-204` after the basic caller UI and run-away phase are playable.

## D-017: Detect Center Reach From Server-Owned Character Pivots

Date: 2026-06-14
Status: Accepted

Context:

The called player reaching the center is the trigger for STOP, but clients should not be trusted to declare that moment. The implementation also needs to survive characters without an expected humanoid root part.

Decision:

Use `src/shared/CenterZone.luau` for pure horizontal distance checks and `ArenaService.getPlayerCenterReach` for Roblox character lookup. `RoundService.checkCalledPlayerAtCenter` only runs during `RunAway`, checks the called player's current character pivot, and advances to `StopFrozen` when the character is within `Tuning.CenterZoneRadius`.

Tradeoffs:

Polling/checking from RoundService is simpler than adding a physical trigger part before arena authoring is settled. It may later be replaced or supplemented by a Studio-authored trigger volume.

Follow-up:

When arena authoring is revisited, decide whether center detection should move to explicit Workspace trigger instances.
