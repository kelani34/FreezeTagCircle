# Testing Research Notes

## Current Position

The project now has headless Luau tests through Lune. This is useful for shared contracts and pure logic, but it cannot fully validate Roblox services, characters, physics, or client/server networking.

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

## Recommended Next Research

- Evaluate a Roblox-aware test runner after `FTC-105` and `FTC-106`.
- Decide whether to make services injectable for headless tests or keep Roblox integration tests as the primary service-level coverage.
- Identify how to run server/client test places in CI without requiring manual Studio interaction.

## Testing Rule Of Thumb

If a behavior can break the round loop, it needs either an automated test, a repeatable Studio test checklist, or both.

