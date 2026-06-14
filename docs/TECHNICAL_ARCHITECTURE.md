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
- Spawn markers
- Center trigger zone
- Boundary markers
- Optional map hazards later

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
- `src/shared/CallerSelection.luau` defines deterministic round-robin caller selection over sorted active user IDs.
- `src/shared/CenterZone.luau` defines pure center-zone distance checks.
- `src/server/JumpTracker.luau` defines pure server-side jump count validation.
- `src/server/TagService.luau` defines pure server-side tag validation rules.
- `src/server/TargetSelection.luau` defines pure server-side target validation rules.
- `src/shared/GameStates.luau` defines the canonical round states and order.
- `GameStates.getPostResetState` defines the repeated-round decision after cleanup.
- `src/shared/Tuning.luau` defines early prototype timing and arena measurement constants.
- `src/shared/CircleSpawns.luau` defines pure spawn-slot math so deterministic placement can be tested headlessly.
- `src/shared/Remotes.luau` reserves remote names without wiring gameplay remotes yet.

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
- Player spawn assignment is deterministic by ascending `UserId`, which makes setup stable even if `Players:GetPlayers()` order changes.
- Loaded characters are pivoted to circle slots facing the arena center.
- Missing characters still receive spawn placement records, but are marked as not placed so later lifecycle work can decide how to recover.
- Center-zone detection uses character pivots rather than trusting client-reported position or requiring a specific humanoid root part.

### MovementControlService

Applies server-approved movement restrictions:

- Freeze movement.
- Restore movement.

Initial implementation:

- `src/server/MovementControlService.luau` snapshots humanoid `WalkSpeed`, `JumpPower`, `JumpHeight`, and `AutoRotate`.
- Frozen players are set to zero movement and rotation disabled.
- The called player is excluded from runner freeze so they remain controllable for the tag attempt path.
- Movement is restored on reset, waiting fallback, or service shutdown.

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
