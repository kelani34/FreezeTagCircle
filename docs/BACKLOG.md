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

## Phase 1: Core Playable Prototype

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-101 | P0 | Done | Decide whether to configure Rojo before source implementation |
| FTC-102 | P0 | Done | Create shared round state constants |
| FTC-103 | P0 | Done | Implement server round state machine skeleton |
| FTC-104 | P0 | Todo | Implement minimum player waiting state |
| FTC-105 | P0 | Todo | Implement circle spawn placement |
| FTC-106 | P0 | Todo | Implement caller assignment |
| FTC-107 | P0 | Todo | Implement target selection validation |
| FTC-108 | P0 | Todo | Implement center zone detection |
| FTC-109 | P0 | Todo | Implement freeze and unfreeze behavior |
| FTC-110 | P0 | Todo | Implement three-jump tracking |
| FTC-111 | P0 | Todo | Implement server-side tag validation |
| FTC-112 | P0 | Todo | Implement round reset |
| FTC-113 | P0 | Todo | Add basic client UI prompts |
| FTC-114 | P0 | Todo | Test join/leave/reset during every round state |

## Phase 2: Fun and Fairness

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-201 | P1 | Todo | Tune arena radius, center radius, and tag radius |
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
| FTC-405 | P2 | Todo | Add release checklist for tagged playtest builds |

## Current Assessment

As of 2026-06-13:

- Foundation planning and Roblox tooling are complete.
- The first Phase 1 implementation slice is complete with shared round contracts and a server-owned `RoundService` skeleton.
- The next implementation target is `FTC-104`: minimum player waiting state.
