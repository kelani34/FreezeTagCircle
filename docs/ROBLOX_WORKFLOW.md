# Roblox Development Workflow

## Current State

The repository currently contains a Roblox Studio place file:

- `Place1.rbxl`

This is acceptable for early exploration, but source-controlled Luau files should be introduced before gameplay systems grow.

## Recommended Workflow

1. Keep product and architecture decisions in `docs/`.
2. Add gameplay code under `src/` once the first implementation begins.
3. Use Roblox Studio for scene layout, arena markers, and visual iteration.
4. Use Rojo sync before runtime code becomes substantial.
5. Keep server gameplay logic out of client-only scripts.

## Rojo Direction

Rojo is configured through `default.project.json`.

Current source mappings:

- `src/server` maps to `ServerScriptService.Server`
- `src/client` maps to `StarterPlayer.StarterPlayerScripts.Client`
- `src/shared` maps to `ReplicatedStorage.Shared`

Use:

```sh
rojo serve default.project.json
```

Build a place artifact with:

```sh
rojo build default.project.json -o build/FreezeTagCircle.rbxlx
```

The repository now uses Rokit to pin Rojo and companion tools. See `docs/TOOLING.md`.

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
