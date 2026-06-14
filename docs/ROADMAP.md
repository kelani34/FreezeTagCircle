# Development Roadmap

## Phase 0: Foundation

Goal: establish product, design, architecture, and tracking structure.

Deliverables:

- Game design brief.
- Gameplay rules and open questions.
- Technical architecture.
- Product strategy.
- Risk register.
- Decision log.
- Backlog.
- Milestone roadmap.

Exit criteria:

- A developer can explain the target prototype.
- Major rule ambiguities are documented.
- First playable prototype scope is clear.

## Phase 1: Core Playable Prototype

Goal: prove the central round loop.

Deliverables:

- Minimum player lobby.
- Circle spawn placement.
- Readable prototype arena with visible circle, start positions, and center STOP zone.
- Caller assignment.
- Target selection.
- Center run.
- STOP freeze.
- Three-jump tag attempt.
- Round resolution.
- Basic UI prompts.

Exit criteria:

- 2-8 players can complete repeated rounds.
- Round state does not break when players join, leave, reset, or die.
- The loop is understandable without developer explanation.
- The arena communicates where players start, where the center is, and where the round action is happening.

## Phase 2: Fun and Fairness Pass

Goal: make the prototype feel good.

Deliverables:

- Tuning for distances, timers, walk speed, jump constraints, and tag radius.
- Clear sound and visual feedback.
- Anti-stall rules.
- Server validation hardening.
- Better round result presentation.

Exit criteria:

- Rounds are usually under 60 seconds.
- Frozen downtime is short.
- Tag success feels skillful but not impossible.

## Phase 3: Public Server Readiness

Goal: make the game survive real players.

Deliverables:

- Robust join/leave handling.
- AFK handling.
- Basic moderation-safe naming and identity flow.
- Exploit-resilient remotes.
- Performance review.
- Simple onboarding.

Exit criteria:

- Public server behavior remains stable with expected player counts.
- New players can join mid-session without confusion.

## Phase 4: Retention Layer

Goal: add replayability without harming the core loop.

Deliverables:

- Session scoring.
- Cosmetic rewards or unlocks.
- Multiple arena variants.
- Daily or streak-based lightweight goals.

Exit criteria:

- Players have reasons to play multiple sessions.
- Monetization, if introduced, remains cosmetic.

## Phase 5: Launch Preparation

Goal: prepare for a Roblox release.

Deliverables:

- Store page assets.
- Icon and thumbnails.
- Final onboarding pass.
- Analytics plan.
- Bug triage.
- Playtest checklist.

Exit criteria:

- The game is understandable, stable, moderated, and presentable.
