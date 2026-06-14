# Shared Source

Shared constants, simple types, tuning values, and remote names will live here.

Keep shared modules small and stable. If a module changes gameplay truth, it probably belongs on the server.

Current modules:

- `CallerSelection.luau`: pure deterministic caller rotation helpers.
- `CenterZone.luau`: pure center-zone distance and radius checks.
- `CircleSpawns.luau`: pure circle slot and deterministic user-id assignment helpers.
- `GameStates.luau`: round state names and small helpers.
- `Remotes.luau`: remote object names used by server/client code.
- `RoundPrompts.luau`: maps server-owned round snapshots to client prompt copy.
- `Tuning.luau`: prototype tuning constants.
