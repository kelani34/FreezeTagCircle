# Decision Log

Record meaningful product, design, and technical decisions here.

Format:

```text
## D-000: Decision Title

Date: YYYY-MM-DD
Status: Proposed | Accepted | Rejected | Superseded

Context:

Decision:

Tradeoffs:

Follow-up:
```

## D-001: Begin With Documentation Before Gameplay Code

Date: 2026-06-13
Status: Accepted

Context:

The project currently contains a Roblox place file but no documented rules, architecture, roadmap, or tracking system. The gameplay concept has several unresolved rule and balance questions.

Decision:

Establish product, design, architecture, risk, decision, assumption, roadmap, and backlog documents before major gameplay implementation.

Tradeoffs:

This delays the first script slightly, but reduces the chance of building the wrong systems or hiding important ambiguity inside code.

Follow-up:

Use the Phase 1 backlog to move from planning into the smallest playable prototype.

## D-002: Prefer No-Elimination Scoring For The First Prototype

Date: 2026-06-13
Status: Proposed

Context:

Elimination can create long downtime in public Roblox servers, especially for new players.

Decision:

The first prototype should use scoring and quick resets rather than elimination.

Tradeoffs:

This may reduce high-stakes tension, but it supports faster learning, less frustration, and easier playtesting.

Follow-up:

Revisit after the core loop is tested with real players.

## D-003: Use Display Names Plus Icons Instead Of Countries Initially

Date: 2026-06-13
Status: Proposed

Context:

The historical playground game often used country names, but a public Roblox game needs a moderation-safe and globally comfortable identity system.

Decision:

Prototype with player display names plus assigned icons or colors. Treat country names as theme inspiration, not a required mechanic.

Tradeoffs:

This slightly reduces nostalgia, but avoids avoidable content, localization, and sensitivity issues.

Follow-up:

Test whether icons/colors are clear enough during caller selection.

