# Backlog

Backlog statuses:

- `Todo`
- `In Progress`
- `Blocked`
- `Done`

Priorities:

- `P0`: Required for first playable prototype
- `P1`: Required before public testing
- `P2`: Important but can wait
- `P3`: Nice to have

## GitHub Issue Map

Foundation governance work is tracked by [#5](https://github.com/kelani34/FreezeTagCircle/issues/5).

| ID | Issue |
| --- | --- |
| FTC-105 | [#6](https://github.com/kelani34/FreezeTagCircle/issues/6) |
| FTC-106 | [#10](https://github.com/kelani34/FreezeTagCircle/issues/10) |
| FTC-107 | [#11](https://github.com/kelani34/FreezeTagCircle/issues/11) |
| FTC-108 | [#12](https://github.com/kelani34/FreezeTagCircle/issues/12) |
| FTC-109 | [#13](https://github.com/kelani34/FreezeTagCircle/issues/13) |
| FTC-110 | [#14](https://github.com/kelani34/FreezeTagCircle/issues/14) |
| FTC-111 | [#15](https://github.com/kelani34/FreezeTagCircle/issues/15) |
| FTC-112 | [#16](https://github.com/kelani34/FreezeTagCircle/issues/16) |
| FTC-113 | [#17](https://github.com/kelani34/FreezeTagCircle/issues/17) |
| FTC-114 | [#18](https://github.com/kelani34/FreezeTagCircle/issues/18) |
| FTC-115 | [#44](https://github.com/kelani34/FreezeTagCircle/issues/44) |
| FTC-116 | [#56](https://github.com/kelani34/FreezeTagCircle/issues/56) |
| FTC-201 | [#19](https://github.com/kelani34/FreezeTagCircle/issues/19) |
| FTC-202 | [#20](https://github.com/kelani34/FreezeTagCircle/issues/20) |
| FTC-203 | [#21](https://github.com/kelani34/FreezeTagCircle/issues/21) |
| FTC-204 | [#22](https://github.com/kelani34/FreezeTagCircle/issues/22) |
| FTC-205 | [#23](https://github.com/kelani34/FreezeTagCircle/issues/23) |
| FTC-301 | [#24](https://github.com/kelani34/FreezeTagCircle/issues/24) |
| FTC-302 | [#25](https://github.com/kelani34/FreezeTagCircle/issues/25) |
| FTC-303 | [#26](https://github.com/kelani34/FreezeTagCircle/issues/26) |
| FTC-304 | [#27](https://github.com/kelani34/FreezeTagCircle/issues/27) |
| FTC-401 | [#28](https://github.com/kelani34/FreezeTagCircle/issues/28) |
| FTC-402 | [#29](https://github.com/kelani34/FreezeTagCircle/issues/29) |
| FTC-403 | [#30](https://github.com/kelani34/FreezeTagCircle/issues/30) |
| FTC-404 | [#31](https://github.com/kelani34/FreezeTagCircle/issues/31) |
| FTC-405 | [#32](https://github.com/kelani34/FreezeTagCircle/issues/32) |
| FTC-406 | [#8](https://github.com/kelani34/FreezeTagCircle/issues/8) |
| FTC-407 | [#33](https://github.com/kelani34/FreezeTagCircle/issues/33) |
| FTC-408 | [#7](https://github.com/kelani34/FreezeTagCircle/issues/7) |

## Phase 0: Foundation

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-001 | P0 | Done | Create project documentation structure |
| FTC-002 | P0 | Done | Define current game design brief |
| FTC-003 | P0 | Done | Document open gameplay rule questions |
| FTC-004 | P0 | Done | Define initial technical architecture |
| FTC-005 | P0 | Done | Create roadmap, risk register, decision log, and assumptions log |
| FTC-006 | P0 | Done | Pin project tools with Rokit |
| FTC-007 | P0 | Done | Add Wally package manifest |
| FTC-008 | P0 | Done | Add StyLua formatter config |
| FTC-009 | P0 | Done | Add Selene linter config |
| FTC-010 | P0 | Done | Add Lune local tooling script |
| FTC-011 | P0 | Done | Add CI workflow for tooling checks and Rojo build artifact |
| FTC-012 | P0 | Done | Document tooling workflow |
| FTC-013 | P0 | Done | Add headless Luau test runner and shared contract tests |
| FTC-014 | P0 | Done | Document testing strategy |
| FTC-015 | P0 | Done | Document dev, staging, and production environment strategy |
| FTC-016 | P0 | Done | Add local Roblox Studio integration smoke-test runner |
| FTC-017 | P0 | Done | Add GitHub issue templates, PR template, and labels |
| FTC-018 | P0 | Done | Add project-local roundup skill and agent memory file |

## Phase 1: Core Playable Prototype

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-101 | P0 | Done | Decide whether to configure Rojo before source implementation |
| FTC-102 | P0 | Done | Create shared round state constants |
| FTC-103 | P0 | Done | Implement server round state machine skeleton |
| FTC-104 | P0 | Done | Implement minimum player waiting state |
| FTC-105 | P0 | Done | Implement circle spawn placement |
| FTC-106 | P0 | Done | Implement caller assignment |
| FTC-107 | P0 | Done | Implement target selection validation |
| FTC-108 | P0 | Done | Implement center zone detection |
| FTC-109 | P0 | Done | Implement freeze and unfreeze behavior |
| FTC-110 | P0 | Done | Implement three-jump tracking |
| FTC-111 | P0 | Done | Implement server-side tag validation |
| FTC-112 | P0 | Done | Implement round reset |
| FTC-113 | P0 | Done | Add basic client UI prompts |
| FTC-114 | P0 | Done | Test join/leave/reset during every round state |
| FTC-115 | P0 | Done | Add first-playable automatic round driver |
| FTC-116 | P0 | Done | Build readable prototype arena for first playable testing |

## Phase 2: Fun and Fairness

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-201 | P1 | Done | Tune arena radius, center radius, and tag radius |
| FTC-202 | P1 | Todo | Add clear STOP feedback |
| FTC-203 | P1 | Todo | Add tag attempt timer |
| FTC-204 | P1 | Todo | Prevent caller target spam or repeated targeting abuse |
| FTC-205 | P1 | Todo | Add visible frozen state effect |

## Phase 3: Public Server Readiness

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-301 | P1 | Todo | Add AFK detection or skip behavior |
| FTC-302 | P1 | Todo | Add exploit-resistant remote rate limits |
| FTC-303 | P1 | Todo | Add simple onboarding prompts |
| FTC-304 | P1 | Todo | Add performance budget notes |

## Tooling and Release Follow-Up

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-401 | P1 | Todo | Add Roblox Open Cloud secrets and staging place identifiers to GitHub |
| FTC-402 | P1 | Todo | Add staging publish workflow after manual artifact builds are trusted |
| FTC-403 | P2 | Todo | Add automated Roblox test runner once gameplay systems exist |
| FTC-404 | P2 | Todo | Add dependency review process before introducing Wally packages |
| FTC-405 | P2 | Done | Add release checklist for tagged playtest builds |
| FTC-406 | P1 | Todo | Create Roblox staging place and configure staging GitHub variables |
| FTC-407 | P1 | Todo | Add manual staging publish workflow after Open Cloud credentials are ready |
| FTC-408 | P1 | Todo | Evaluate TestEZ for richer Roblox service-level integration specs |

## Current Assessment

As of 2026-06-14:

- Foundation planning and Roblox tooling are complete.
- Headless Luau tests now run in CI for shared contracts.
- The first Phase 1 implementation slice is complete with shared round contracts and a server-owned `RoundService` skeleton.
- The minimum-player waiting gate is complete.
- Circle spawn placement is implemented with deterministic spawn math, `ArenaService`, and RoundService setup wiring.
- Caller assignment is implemented with deterministic round-robin selection over active players.
- Target selection validation is implemented with server-owned checks before `RunAway`.
- Center zone detection is implemented with shared distance math, ArenaService character checks, and a server-owned StopFrozen transition trigger.
- Freeze/unfreeze behavior is implemented with server-owned humanoid movement snapshots and cleanup.
- Three-jump tracking is implemented with a server-owned jump counter and snapshot jump budget.
- Server-side tag validation is implemented with active/frozen actor checks, timing checks, and server-measured character distance.
- Round reset is implemented with cleanup for actors, frozen state, jump budget, tag results, and post-reset setup/waiting decisions.
- Basic client prompts are implemented from server-owned round snapshots with late-join snapshot requests.
- Join/leave/reset lifecycle coverage is implemented through headless fallback-policy tests and Roblox Studio smoke checks for cleanup-safe missing-player paths.
- A first-playable automatic round driver is implemented so Studio sessions can advance through setup, target selection, run-away, STOP, tag attempt, resolve, and reset without manual server console transitions.
- GitHub issues now exist for every remaining backlog item.
- The tagged playtest release checklist exists in `docs/production/RELEASE_CHECKLIST.md`.
- Phase 1 core systems are implemented and the first-playable arena now has a visible floor, center STOP pad, circular boundary markers, spawn pads, outer run markers, and simple spectator framing.
- The first playable tuning pass uses a 40-stud start circle, 10-stud center zone, and 8-stud tag radius.
- The next implementation target is `FTC-202`: add clear STOP feedback.
