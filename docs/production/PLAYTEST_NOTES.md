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
