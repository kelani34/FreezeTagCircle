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
- `src/shared/GameStates.luau` defines the canonical round states and order.
- `src/shared/Tuning.luau` defines early prototype timing constants.
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

### MovementControlService

Applies server-approved movement restrictions:

- Freeze movement.
- Restore movement.
- Track jump counts during tag attempts.

### TagService

Validates tag attempts:

- Uses server-side distance checks.
- Applies cooldowns.
- Ignores invalid players.
- Resolves success or failure.

### ScoreService

Keeps lightweight round/session scoring:

- Points for successful tags.
- Points or streaks for escaping.
- Round results.

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

Rojo and baseline Luau tooling are now adopted before meaningful source code growth. Runtime systems will start as plain ModuleScripts with explicit ownership boundaries. Arena authoring remains open until spawn and center-zone implementation begins.
