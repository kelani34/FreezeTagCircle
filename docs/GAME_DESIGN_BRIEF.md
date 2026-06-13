# Game Design Brief

## One-Sentence Pitch

FreezeTagCircle is a fast, social Roblox party game where one called player sprints to the center, freezes everyone else, then gets three jumps to tag a frozen opponent.

## Design Pillars

- **Readable chaos:** The action should be silly and noisy, but every player should understand why something happened.
- **Social pressure:** Calling, running, freezing, and tagging should create reactions between players.
- **Fast re-entry:** Players should spend most of their session moving, reacting, choosing, or spectating something brief.
- **Skillful movement:** Better positioning, jump control, and prediction should matter without making new players helpless.
- **Server fairness:** The server owns round state, freeze state, tag validation, and scoring.

## Core Loop

1. Players gather around the circle.
2. A caller is chosen.
3. The caller chooses a target.
4. The target races to the center.
5. Everyone else runs away.
6. The target reaches the center and triggers STOP.
7. Fleeing players freeze.
8. The target gets three jumps to reach and tag someone.
9. The tag result determines scoring, caller rotation, and the next round.

## Target Session Feel

A public-server player should understand the round within one or two cycles. The game should create moments like:

- A player barely reaches the center before others get away.
- A frozen player realizes they stopped too close.
- A called player spends their last jump and misses by a small distance.
- Friends try to bait each other with risky positions.

## Audience

Primary audience:

- Roblox players who enjoy casual competitive party games.
- Friend groups looking for quick rounds.
- Younger players who can understand simple rules quickly.

Secondary audience:

- Movement-focused players who enjoy optimizing jumps and spacing.
- Social players who enjoy funny callouts and reactions.

## Initial Scope Boundary

The first prototype should not attempt progression, cosmetics, monetization, complex maps, ranked play, or advanced matchmaking. Those depend on the core loop being fun first.

