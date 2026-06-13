# Shared Source

Shared constants, simple types, tuning values, and remote names will live here.

Keep shared modules small and stable. If a module changes gameplay truth, it probably belongs on the server.

Current modules:

- `GameStates.luau`: round state names and small helpers.
- `Remotes.luau`: remote object names used by server/client code.
- `Tuning.luau`: prototype tuning constants.
