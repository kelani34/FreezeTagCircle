# Technical Architecture

## Architecture Principles

- Server owns gameplay truth.
- Clients present state and collect input.
- Shared modules define constants and simple data contracts.
- Gameplay systems should be small, testable, and replaceable.
- The first prototype should avoid framework complexity unless the project clearly needs it.

## Roblox Service Ownership

### ServerScriptService

Server-owned systems:

- Automatic first-playable round driver
- Round state machine
- Player lifecycle
- Spawn placement
- Caller selection
- Target selection validation
- Freeze and unfreeze state
- Jump allowance tracking
- Tag validation
- Scoring

### ReplicatedStorage

Shared modules and remotes:

- Round state constants
- Remote event names
- Shared tuning values
- UI-facing state snapshots
- Server-triggered STOP feedback event

### StarterPlayerScripts

Client-owned systems:

- Round status UI
- Caller selection UI
- Local prompts
- Input capture for tag/jump intent where needed
- Camera and feedback polish

### Workspace

World-owned instances:

- Circle arena
- Waiting room lobby
- Spawn markers
- Center trigger zone
- Boundary markers
- Optional map hazards later

Initial implementation:

- `default.project.json` owns the prototype arena under `Workspace.Arena` so the Studio playtest build is readable without manual place edits.
- The static arena includes a grass floor, a visible red center STOP pad, and a small STOP beacon.
- `default.project.json` also owns a physical `Workspace.Lobby` outside the circle with a lobby floor, spawn pad, and walkway toward the playground.
- `src/server/ArenaVisualService.luau` generates the circular boundary, preview/player slot pads, and outer run-away markers at runtime from shared tuning and spawn math.
- These are prototype readability assets, not final art. They are intentionally built from anchored Parts so Rojo, CI build inspection, and Studio runtime smoke checks stay predictable.

## Proposed Runtime Systems

### RoundService

Controls the round lifecycle:

```text
WaitingForPlayers -> Setup -> CallerChoosing -> RunAway -> StopFrozen -> TagAttempt -> Resolve -> Reset
```

Responsibilities:

- Start and stop rounds.
- Advance states only when valid.
- Broadcast state changes.
- Handle timeouts.

Initial implementation:

- `src/server/RoundService.luau` owns the current round snapshot.
- `RoundService` tracks active Roblox player count and prevents `WaitingForPlayers -> Setup` until `Tuning.MinimumPlayers` is met.
- If the active player count drops below the minimum during a later state, `RoundService` fails safely back to `WaitingForPlayers` and clears round actors.
- `GameStates.shouldFallbackToWaiting` defines the join/leave safety rule used by `RoundService`.
- When transitioning into `Setup`, `RoundService` asks `ArenaService` to place active players around the circle and stores the resulting spawn placements in the round snapshot.
- When transitioning into `CallerChoosing`, `RoundService` assigns a caller and exposes `callerUserId` in the round snapshot.
- If the caller leaves during `CallerChoosing` and enough players remain, `RoundService` reassigns the caller from the remaining active players.
- `RoundService.selectTarget` validates caller target choices on the server, records `calledUserId` only for accepted selections, and blocks `CallerChoosing -> RunAway` until a valid active target is locked.
- `RoundService.checkCalledPlayerAtCenter` uses `ArenaService` to check the called player's character position during `RunAway` and advances to `StopFrozen` when the center zone is reached.
- When entering `StopFrozen`, `RoundService` asks `MovementControlService` to freeze every active player except the called player and stores `frozenUserIds` in the snapshot.
- When entering `TagAttempt`, `RoundService` resets the called player's jump budget and records accepted called-player jumps through `JumpTracker`.
- During `TagAttempt`, `RoundService.attemptTag` validates active/frozen actors, timer state, and server-measured distance before resolving a successful tag.
- `RoundService.resetRound` moves completed rounds through cleanup and then into either `Setup` or `WaitingForPlayers` based on active player count.
- `RoundService` restores frozen movement when returning to waiting/reset states or when the service stops.
- `RoundService.onSnapshotChanged` lets replication systems observe authoritative state changes.
- `src/shared/CallerSelection.luau` defines deterministic round-robin caller selection over sorted active user IDs.
- `src/shared/CenterZone.luau` defines pure center-zone distance checks.
- `src/server/JumpTracker.luau` defines pure server-side jump count validation.
- `src/server/TagService.luau` defines pure server-side tag validation rules.
- `src/server/TargetSelection.luau` defines pure server-side target validation rules.
- `src/shared/GameStates.luau` defines the canonical round states and order.
- `GameStates.getPostResetState` defines the repeated-round decision after cleanup.
- `GameStates.shouldFallbackToWaiting` defines the minimum-player fallback decision for disruptive player lifecycle events.
- `src/shared/RoundPrompts.luau` maps round snapshots to client-facing prompt text.
- `src/shared/Tuning.luau` defines early prototype timing and arena measurement constants.
- `src/shared/CircleSpawns.luau` defines pure spawn-slot math so deterministic placement can be tested headlessly.
- `src/shared/Remotes.luau` defines remote names used by server/client replication and intent flows.

### RoundReplicationService

Replicates server-owned snapshots to clients:

- Creates the `FreezeTagCircleRemotes` folder.
- Publishes `RoundStateChanged` events when `RoundService` changes.
- Answers `RequestRoundSnapshot` for late joiners and newly started clients.
- Fires `StopFeedback` only when a live snapshot enters `StopFrozen`; late joiners request snapshots but do not receive stale STOP effects.
- Does not accept gameplay outcomes from clients.

### RoundDriverService

Runs the first-playable automatic loop:

- Starts setup when enough players are present.
- Advances timed phases without manual server console transitions.
- Selects a deterministic automatic target until caller UI exists.
- Polls center reach during `RunAway`.
- Polls server-side proximity tags during `TagAttempt`.
- Resolves by timeout when no tag is recorded.
- Resets through `RoundService.resetRound`.

This is intentionally conservative scaffolding for local playtests. It should remain server-owned and easy to replace as richer caller controls, timers, and feedback are added.

### PlayerStateService

Tracks per-player gameplay state:

- Active
- Spectating
- Caller
- Called
- Fleeing
- Frozen
- Tagger

### ArenaService

Handles map-specific placement and zones:

- Circle spawn positions.
- Center zone detection.
- Safe reset positions.
- Map tuning values.

Initial implementation:

- `src/server/ArenaService.luau` owns Roblox-specific placement behavior.
- `ArenaService.placePlayersInLobby` owns deterministic lobby placement for waiting, late-join, reset, and respawn cases.
- Player spawn assignment is deterministic by ascending `UserId`, which makes setup stable even if `Players:GetPlayers()` order changes.
- Loaded characters are pivoted to circle slots facing the arena center.
- Missing characters still receive spawn placement records, but are marked as not placed so later lifecycle work can decide how to recover.
- Center-zone detection uses character pivots rather than trusting client-reported position or requiring a specific humanoid root part.
- First-playable tuning uses `Tuning.CircleSpawnRadius = 40`, `Tuning.CenterZoneRadius = 10`, and `Tuning.TagRadius = 8`; visible start pads and center geometry are kept aligned with those values in `default.project.json`.
- `src/shared/ArenaVisuals.luau` defines the generated circular boundary, preview slot count, and run-away marker layout so visible arena math can be tested headlessly.
- Late joiners are connected players, but once setup has created round placements, participant-sensitive operations use the placement user IDs rather than every connected player.

### Lobby Flow

The first public-server flow is automatic:

- Players spawn or respawn in the physical waiting room.
- The automatic driver starts setup when the minimum player count is met.
- Setup moves eligible players to circle slots.
- Late joiners stay in the lobby until the next setup.
- After a completed round, reset returns through `WaitingForPlayers`, which places players back in the lobby before the next automatic setup.

### ArenaVisualService

Generates source-controlled prototype visuals at runtime:

- Builds a dense circular boundary around the playground.
- Builds preview slots for the waiting/playtest view.
- Rebuilds player slot pads from `RoundService` spawn placements when a round enters setup.
- Keeps visual slots aligned with `CircleSpawns` instead of hand-authored square markers.

### Client STOP Feedback

`RoundHud` listens to the server-owned `StopFeedback` RemoteEvent:

- Shows a short full-screen STOP pulse.
- Plays a short audio cue.
- Cleans up the effect locally after the pulse.
- Does not infer STOP from late snapshot requests, which prevents stale feedback for late joiners.

### MovementControlService

Applies server-approved movement restrictions:

- Freeze movement.
- Restore movement.
- Apply and remove temporary frozen character visuals.

Initial implementation:

- `src/server/MovementControlService.luau` snapshots humanoid `WalkSpeed`, `JumpPower`, `JumpHeight`, and `AutoRotate`.
- Frozen players are set to zero movement and rotation disabled.
- Frozen players receive a non-destructive `FreezeTagCircleFrozenEffect` folder with a highlight, translucent ice shell, and particles parented to their character.
- The called player is excluded from runner freeze so they remain controllable for the tag attempt path.
- Movement and visual effects are restored on reset, waiting fallback, or service shutdown.

### JumpTracker

Counts the called player's tag-attempt jumps:

- Accepts jumps only during `TagAttempt`.
- Accepts jumps only from the current called player.
- Enforces `Tuning.TagJumpLimit`.
- Exposes remaining jump budget through `RoundService` snapshots.

### TagService

Validates tag attempts:

- Uses server-side distance checks.
- Requires the round to be in `TagAttempt`.
- Rejects late attempts after the tag timer expires.
- Requires the requesting player to be the called player.
- Requires an active frozen target.
- Uses `Tuning.TagRadius` for distance validation.

Initial implementation:

- `src/server/TagService.luau` is a pure validator for tag attempt rules.
- `ArenaService.getDistanceBetweenPlayers` measures character pivot distance on the server.
- `RoundService.attemptTag` records successful tag result fields in the round snapshot and advances to `Resolve`.

### TargetSelection

Validates caller target choice before the round can leave `CallerChoosing`:

- Only the current caller can select.
- The selected target must be an active player.
- The caller cannot target themselves.
- A target can only be locked once per `CallerChoosing` phase.
- If the caller or selected target leaves before `RunAway`, RoundService clears or reassigns state safely.

### ScoreService

Keeps lightweight round/session scoring:

- Points for successful tags.
- Points or streaks for escaping.
- Round results.

### Reset Policy

Round reset cleanup is owned by `RoundService`:

- Restore frozen movement.
- Clear caller, target, spawn placements, frozen user IDs, jump counts, and tag result fields.
- Re-check active player count.
- Continue to `Setup` when enough players remain.
- Fall back to `WaitingForPlayers` when the server no longer has enough players.

### RoundHud

Renders the first playable prompt panel:

- Requests the current snapshot on startup.
- Listens for `RoundStateChanged`.
- Uses `RoundPrompts` so UI copy is derived from round state rather than duplicated client rules.
- Displays waiting, caller, run, STOP, jump, resolve, and reset prompts.

## Networking Rules

- Never trust the client to declare a tag success.
- Never trust the client to choose an invalid target.
- Remote events should express intent, not final truth.
- Server should rate-limit sensitive inputs.
- UI should be driven by server state snapshots.

## Suggested Source Layout

```text
src/
├── server/
│   ├── RoundService.lua
│   ├── PlayerStateService.lua
│   ├── ArenaService.lua
│   ├── MovementControlService.lua
│   ├── TagService.lua
│   └── ScoreService.lua
├── client/
│   ├── RoundHud.client.lua
│   ├── CallerSelect.client.lua
│   └── Feedback.client.lua
├── shared/
│   ├── GameStates.lua
│   ├── Remotes.lua
│   └── Tuning.lua
└── tools/
```

These files should be introduced gradually as the prototype is implemented.

## Open Technical Decisions

- How to represent arena markers so designers can edit maps safely in Studio.
- Whether future arenas should use Studio-authored spawn markers, procedural slots, or a hybrid.

Rojo and baseline Luau tooling are now adopted before meaningful source code growth. Runtime systems will start as plain ModuleScripts with explicit ownership boundaries. Arena authoring remains open until spawn and center-zone implementation begins.
