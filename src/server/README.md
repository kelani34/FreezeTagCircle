# Server Source

Server-owned gameplay logic will live here.

Do not trust clients for authoritative round outcomes. The server should own round state, target validation, freeze state, jump counts, tags, scoring, and reset behavior.

Current modules:

- `ArenaService.luau`: calculates server-owned circle spawn assignments and pivots loaded characters into their setup slots.
- `RoundService.luau`: owns round snapshots, minimum-player gating, legal state transitions, setup spawn placement, and caller assignment.
- `TargetSelection.luau`: validates caller target choices before `RoundService` records a called player.
