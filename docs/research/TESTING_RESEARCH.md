# Testing Research Notes

## Current Position

The project now has headless Luau tests through Lune and a local Roblox Studio smoke-test path through `run-in-roblox`.

## What Headless Tests Are Good For

- Shared state constants.
- Tuning constraints.
- Remote-name contracts.
- Pure utility functions.
- Deterministic state-transition helpers if extracted from services.

## What Headless Tests Are Not Enough For

- `Players` service behavior.
- Character spawn and movement.
- Touch/tag detection.
- Anchoring/freezing characters.
- RemoteEvent security.
- Studio-authored Workspace markers.
- Physics timing.

## Roblox Integration Runner

`run-in-roblox` can run a place and script inside Roblox Studio while piping output back to the terminal. This gives the project a local integration gate for Roblox services and Rojo-built places.

Current command:

```sh
lune run scripts/integration-test.luau
```

This should run on a machine with Roblox Studio installed. It should not be required in GitHub-hosted Linux CI.

## Recommended Next Research

- Evaluate TestEZ for richer Roblox-side service specs.
- Decide whether to make services injectable for headless tests or keep Roblox integration tests as the primary service-level coverage.
- Identify whether a self-hosted runner can safely run Roblox Studio integration tests in CI.

## Testing Rule Of Thumb

If a behavior can break the round loop, it needs either an automated test, a repeatable Studio test checklist, or both.
