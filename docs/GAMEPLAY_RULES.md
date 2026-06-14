# Gameplay Rules and Open Questions

## Currently Understood Rules

- Players begin positioned around a large circle.
- The circle is divided into evenly spaced player slots based on the active round player count.
- Each player has an identity. The original playground version often used country names.
- One player is the caller.
- The caller selects another player.
- The called player moves toward the center.
- All other players run away from the circle.
- When the called player reaches the center, they trigger STOP.
- All other active players freeze in place.
- The called player receives exactly three jumps.
- The called player tries to reach and tag another player using only those jumps.
- The outcome determines what happens next in the round.

## Rule Ambiguities To Resolve

### Caller Selection

- For the first prototype, caller assignment is server-owned round-robin selection over active players.
- Later playtests should decide whether caller rotation should become random, winner-based, or score-based.
- Does the caller physically stand somewhere special?
- The caller cannot choose themselves.
- For the first prototype, the caller can lock one target per `CallerChoosing` phase.

### Player Identity

- Are identities chosen by players, randomly assigned, or cosmetic only?
- If countries are used, should they be replaced with fictional flags, colors, animals, foods, planets, or usernames to avoid moderation and localization issues?
- Does identity affect gameplay or just selection clarity?

### Center Run

- Is there a time limit for the called player to reach the center?
- What happens if the called player refuses to move?
- Can other players body-block the called player?
- Should the called player get speed normalization during the center run?

### Freeze Event

- Does STOP happen automatically on center entry or manually by pressing a button?
- Are players frozen immediately or after a short dramatic delay?
- Do frozen players keep momentum or snap to a stop?
- Are players allowed to jump during the run-away phase before STOP?

### Three-Jump Tag Attempt

- What counts as a jump?
- Can the called player walk between jumps, or are they limited to jump movement only?
- Does touching a frozen player count as a tag, or is there an explicit tag button?
- Is there a time limit after STOP?
- What happens if the target leaves, resets, or falls off the map?

### Round Resolution

- If the called player tags someone, who becomes caller next?
- If the called player fails, who becomes caller next?
- Are players eliminated, scored, or simply rotated?
- How long is the reset between rounds?

## Initial Rule Recommendations

These are provisional recommendations for prototype testing:

- Caller is selected by round logic, not by vote.
- Initial caller rotation uses deterministic round-robin selection so the behavior is testable and fair enough for early play.
- Caller chooses from active players through a simple server-validated choice UI.
- Caller target selection is accepted only when the requester is the current caller, the target is active, and no target has already been locked.
- STOP triggers automatically when the called player enters the center zone.
- Frozen players are anchored by server-authoritative movement restriction, with a clear visual freeze effect.
- The called player has three jump actions and a short time limit.
- Tagging uses server-validated proximity, not trusting client touch events alone.
- No elimination in the first prototype. Use points and quick round resets to keep everyone playing.

## First Playable Tuning

Initial playable measurements:

- Start circle radius: 40 studs.
- Center STOP radius: 10 studs.
- Tag radius: 8 studs.
- Called player jump limit: 3 jumps.
- Tag attempt duration: 12 seconds.

Rationale:

- A 40-stud circle keeps the center run short enough that runners get distance without leaving the action space.
- A 10-stud center gives the called player a forgiving STOP trigger while still requiring them to commit to the middle.
- An 8-stud tag radius gives server-side validation enough tolerance for early playtests and Roblox character/network variance.
- Visible circle/slot markers are generated from shared tuning and spawn math so the playground ring matches server-owned placement.
- The values are intentionally easy to change in `src/shared/Tuning.luau` after Studio playtests.

## Prototype Success Criteria

The rule set is good enough to continue if:

- New players understand their immediate objective without reading long instructions.
- A full round can complete in under 60 seconds.
- Frozen players are not waiting too long.
- The called player has meaningful but not guaranteed tagging chances.
- Round outcomes feel fair enough that players want another round.
