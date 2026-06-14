# Server Source

Server-owned gameplay logic will live here.

Do not trust clients for authoritative round outcomes. The server should own round state, target validation, freeze state, jump counts, tags, scoring, and reset behavior.

Current modules:

- `ArenaService.luau`: calculates server-owned circle spawn assignments and pivots loaded characters into their setup slots.
- `JumpTracker.luau`: validates and counts the called player's three allowed jumps during the tag attempt.
- `MovementControlService.luau`: freezes and restores player humanoid movement using server-owned snapshots.
- `RoundDriverService.luau`: advances the first-playable automatic round loop.
- `RoundReplicationService.luau`: publishes round snapshots to clients and answers late-join snapshot requests.
- `RoundService.luau`: owns round snapshots, minimum-player gating, legal state transitions, setup spawn placement, caller assignment, target locking, center reach checks, jump budget state, and tag attempt outcomes.
- `TagService.luau`: validates tag attempts before `RoundService` records a result.
- `TargetSelection.luau`: validates caller target choices before `RoundService` records a called player.
