# Test Strategy

FreezeTagCircle should treat tests as product infrastructure, not an afterthought. The game is multiplayer, stateful, and timing-sensitive, so testing needs to grow in layers.

## Testing Layers

### Headless Unit Tests

Purpose:

- Validate pure Luau modules.
- Protect shared contracts from accidental drift.
- Run quickly in local development and CI.

Current command:

```sh
lune run scripts/test.luau
```

Current coverage:

- `CallerSelection`
- `CenterZone`
- `CircleSpawns`
- `GameStates`
- `Remotes`
- `TargetSelection`
- `Tuning`

### Server Service Tests

Purpose:

- Validate state-machine transitions.
- Validate player-count gates.
- Validate fail-safe behavior when players leave.

Status:

- Planned. `RoundService` currently depends on Roblox services, so server service tests should use a Roblox-aware test runner or dependency injection once the service surface stabilizes.

### Roblox Integration Tests

Purpose:

- Validate behavior that needs Roblox services, characters, physics, remotes, and Workspace instances.
- Catch bugs that headless Luau cannot see.

Status:

- Local smoke test runner added with `run-in-roblox`.
- Smoke coverage now loads `ArenaService`, validates arena spawn/center tuning, and checks deterministic spawn, caller assignment, target validation, and center-zone helpers inside Roblox Studio.
- GitHub-hosted Linux CI does not run Roblox Studio integration tests.
- Use `lune run scripts/integration-test.luau` on a machine with Roblox Studio installed.

### Manual Studio Playtests

Purpose:

- Validate fun, clarity, pacing, and player comprehension.
- Catch social and movement issues that automated tests cannot judge.

Playtest notes:

- Use `docs/production/PLAYTEST_NOTES.md`.

## CI Requirements

Every PR should run:

```sh
lune run scripts/tooling-doctor.luau
wally manifest-to-json > /dev/null
lune run scripts/test.luau
stylua --check src scripts tests
selene src scripts tests
rojo build default.project.json -o build/FreezeTagCircle.rbxlx
```

Local Roblox integration gate when Roblox Studio behavior changed:

```sh
lune run scripts/integration-test.luau
```

## Test Case Priorities

Highest priority:

- Round state transition legality.
- Minimum player gating.
- Player join/leave during every round state.
- Server rejection of invalid client intent.
- Caller assignment determinism and reassignment when needed.
- Target selection accepts only the current caller and active non-caller targets.
- Center-zone checks use server-side position and tuning.
- Spawn placement determinism.
- Tag validation rules.

Medium priority:

- Tuning values remain within playable ranges.
- Caller rotation remains deterministic for a given active-player set and round number.
- Repeated target selections stay rejected until later anti-spam tuning changes the rule.
- Circle spawn slots remain deterministic and evenly distributed.
- Remotes are named consistently.
- UI state snapshots remain backward compatible.

Low priority:

- Cosmetic-only effects.
- Non-critical presentation helpers.

## Current Gaps

- Roblox integration tests run locally through Studio, but not in GitHub-hosted CI.
- `RoundService` currently has smoke coverage through Roblox Studio, but not detailed service-level scenario coverage.
- No performance budget tests yet.
- No staging publish smoke tests yet.

These gaps are acceptable for the current phase, but they should be closed before public-server readiness.
