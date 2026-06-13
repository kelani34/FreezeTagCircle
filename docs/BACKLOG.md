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

## Phase 1: Core Playable Prototype

| ID | Priority | Status | Item |
| --- | --- | --- | --- |
| FTC-101 | P0 | Todo | Decide whether to configure Rojo before source implementation |
| FTC-102 | P0 | Todo | Create shared round state constants |
| FTC-103 | P0 | Todo | Implement server round state machine skeleton |
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

