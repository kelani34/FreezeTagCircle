# FreezeTagCircle

FreezeTagCircle is a Roblox multiplayer game inspired by a playground freeze-tag circle game.

Players start around a large circle. One player becomes the caller. The caller selects another player, who must reach the center while everyone else runs away. When the called player reaches the center, they trigger STOP: fleeing players freeze, and the called player gets exactly three jumps to reach and tag someone.

This repository is currently in foundation phase. The goal is to define the product, rules, architecture, development plan, and tracking systems before major gameplay implementation begins.

## Current Phase

**Phase 0: Foundation**

Primary goals:

- Clarify the core game loop.
- Identify ambiguous rules and design risks.
- Establish a maintainable Roblox project structure.
- Track decisions, assumptions, risks, milestones, and backlog items.
- Prepare for a small playable prototype.

## Project Documents

- [Game Design Brief](docs/GAME_DESIGN_BRIEF.md)
- [Gameplay Rules and Open Questions](docs/GAMEPLAY_RULES.md)
- [Product Strategy](docs/PRODUCT_STRATEGY.md)
- [Technical Architecture](docs/TECHNICAL_ARCHITECTURE.md)
- [Development Roadmap](docs/ROADMAP.md)
- [Backlog](docs/BACKLOG.md)
- [Risk Register](docs/RISK_REGISTER.md)
- [Decision Log](docs/DECISION_LOG.md)
- [Assumptions Log](docs/ASSUMPTIONS.md)
- [Roblox Development Workflow](docs/ROBLOX_WORKFLOW.md)
- [Release and Access Plan](docs/RELEASE_AND_ACCESS.md)

## Repository Structure

```text
.
├── docs/                  Project planning, design, architecture, and tracking
├── src/
│   ├── client/            LocalScripts and client-only presentation logic
│   ├── server/            Server-authoritative gameplay systems
│   ├── shared/            Shared constants, types, utility modules
│   └── tools/             Development helpers and non-runtime scripts
├── Place1.rbxl            Current Roblox place file
└── Place1.rbxl.lock       Roblox Studio lock file
```

The `src/` folders are intentionally light for now. Gameplay code should be added only after the foundation docs define the rules and implementation priorities clearly enough to avoid expensive rewrites.

## Near-Term Build Priority

The first playable prototype should prove the core loop with the smallest useful feature set:

1. Round lobby and minimum player handling.
2. Circle spawn positions.
3. Caller assignment.
4. Called-player selection.
5. Run-away phase.
6. Center reached detection.
7. Freeze event.
8. Three-jump tag attempt.
9. Round resolution and reset.

Anything outside that loop is secondary until the prototype is fun and understandable.
