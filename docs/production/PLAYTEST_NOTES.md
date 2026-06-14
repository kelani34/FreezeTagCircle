# Playtest Notes

Use this file to record observations from manual playtests.

## 2026-06-14 Local Studio Multiplayer Startup

Date: 2026-06-14
Build: main after PR #55
Players: 2 local Studio clients
Round Count: Startup verification

What players understood quickly:

- Two local clients can join the same test session.
- The HUD now receives server state instead of staying on `Server not initialized`.

What confused players:

- The place still reads as a blank baseplate. The current prototype geometry is not enough for a new player to understand the circle, start positions, center STOP zone, or intended play space.

Best moment:

- The server/client initialization blocker was confirmed fixed in Studio.

Worst moment:

- The technical round loop can be alive while the player-facing experience still appears unfinished.

Balance notes:

- Do not spend serious time on radius and timing balance until the arena is visually readable.

Bugs:

- The prior server entry module startup bug was fixed by PR #55.

Decisions or follow-up tasks:

- Track a new first-playable gate as FTC-116 / issue #56: build a readable prototype arena before FTC-201 tuning.

## 2026-06-14 Prototype Arena Readability Pass

Date: 2026-06-14
Build: feature/readable-prototype-arena
Players: Pending Studio retest
Round Count: Pending Studio retest

What players understood quickly:

- Pending manual validation.

What confused players:

- Pending manual validation.

Best moment:

- The map now has source-controlled visual anchors for the circle, center STOP zone, start pads, and run-away area.

Worst moment:

- This is still prototype geometry, not a finished Roblox environment.

Balance notes:

- Use FTC-201 to tune distances after testing the new arena with multiple clients.

Bugs:

- None known from build inspection.

Decisions or follow-up tasks:

- Rebuild/open the place in Studio and verify the new arena is visible from multiple client windows.

## 2026-06-14 First Playable Tuning Pass

Date: 2026-06-14
Build: feature/tune-first-playable-arena
Players: Automated checks only
Round Count: Automated checks only

What players understood quickly:

- Pending manual multiplayer playtest.

What confused players:

- Pending manual multiplayer playtest.

Best moment:

- Server tuning and visible arena markers now agree: players spawn on a 40-stud circle, STOP uses a 10-stud center zone, and tags validate at 8 studs.

Worst moment:

- Tag success rate and average round length still need a real multi-client Studio playtest.

Balance notes:

- Expected center run from the start circle is roughly short enough to keep STOP dramatic without letting runners vanish from the arena.
- Keep watching whether the called player succeeds too often with 12 seconds and 8-stud tag radius.

Bugs:

- None known from automated validation.

Decisions or follow-up tasks:

- Test 2-player and 4-player Studio sessions and record average round length plus rough tag success rate.
- Continue with FTC-202 for stronger STOP feedback before deeper balance changes.

## 2026-06-14 Circular Playground Correction

Date: 2026-06-14
Build: feature/circular-playground-arena
Players: Automated checks only
Round Count: Automated checks only

What players understood quickly:

- Pending manual Studio validation.

What confused players:

- Pending manual Studio validation.

Best moment:

- The arena is now represented as a generated circular playground with slot pads derived from the same spawn math that places players.

Worst moment:

- A physical waiting room still needs to be added so players do not enter directly into the playground space.

Balance notes:

- The generated ring preserves the 40-stud active player circle and 56-stud visible boundary.

Bugs:

- None known from automated validation.

Decisions or follow-up tasks:

- Continue with FTC-118 for the waiting room and lobby-to-circle flow.

## 2026-06-14 Waiting Room And Entry Flow

Date: 2026-06-14
Build: feature/waiting-room-entry-flow
Players: Automated checks only
Round Count: Automated checks only

What players understood quickly:

- Pending manual Studio validation.

What confused players:

- Pending manual Studio validation.

Best moment:

- The game now has a separate physical lobby and server placement helpers for moving players from waiting room to circle slots.

Worst moment:

- The lobby has prototype geometry only and still needs visual polish after gameplay flow is proven.

Balance notes:

- Automatic start remains the default public-server flow. A manual start button should wait for private/custom modes.

Bugs:

- None known from automated validation.

Decisions or follow-up tasks:

- Test with 2+ Studio clients and confirm players start in the lobby, then move to circle slots on setup.
- Confirm a late-joining client remains in the lobby until the next round.
- Continue with FTC-202 for STOP feedback.

## Template

```text
Date:
Build:
Players:
Round Count:

What players understood quickly:

What confused players:

Best moment:

Worst moment:

Balance notes:

Bugs:

Decisions or follow-up tasks:
```
