# Roblox Development Workflow

## Current State

The repository currently contains a Roblox Studio place file:

- `Place1.rbxl`

This is acceptable for early exploration, but source-controlled Luau files should be introduced before gameplay systems grow.

## Recommended Workflow

1. Keep product and architecture decisions in `docs/`.
2. Add gameplay code under `src/` once the first implementation begins.
3. Use Roblox Studio for scene layout, arena markers, and visual iteration.
4. Use Rojo or an equivalent sync workflow before runtime code becomes substantial.
5. Keep server gameplay logic out of client-only scripts.

## Suggested Rojo Direction

When ready, introduce:

- `default.project.json`
- `src/server` mapped to `ServerScriptService`
- `src/client` mapped to `StarterPlayerScripts`
- `src/shared` mapped to `ReplicatedStorage`

Do this before there are many manually created scripts inside the `.rbxl`, so source control remains useful.

## Roblox Multiplayer Guidance

- The server should decide who is caller, called, frozen, and tagged.
- Clients may request actions, but should not authoritatively set round outcomes.
- Client UI should mirror server state.
- Handle players leaving during every state.
- Handle character death or reset during every state.
- Avoid long waits for dead, frozen, or newly joined players.

## Playtest Checklist

Before calling a prototype stable, test:

- 1 player in server.
- 2 players in server.
- 3-4 players in server.
- Larger group if available.
- Player leaves while caller.
- Player leaves while called.
- Player leaves while frozen.
- Player resets during run-away phase.
- Player resets during tag attempt.
- Called player fails to reach center.
- Called player reaches center but fails tag.
- Called player tags successfully.

