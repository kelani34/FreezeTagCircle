# Risk Register

| ID | Risk | Impact | Likelihood | Mitigation | Status |
| --- | --- | --- | --- | --- | --- |
| R-001 | Players do not understand whether to run inward or outward | High | High | Strong UI prompts, sound cues, arrows, and short round tutorialization | Open |
| R-002 | Frozen players wait too long | High | Medium | Keep tag attempt short, use no-elimination scoring, reset quickly | Open |
| R-003 | Called player cannot reach anyone in three jumps | High | Medium | Tune circle size, flee time, jump rules, and tag radius | Open |
| R-004 | Called player almost always tags someone | Medium | Medium | Tune STOP timing, freeze delay, tag radius, and jump restrictions | Open |
| R-005 | Network latency causes unfair tag outcomes | High | Medium | Server-side validation with reasonable distance tolerance | Open |
| R-006 | Exploiters spoof remotes for tag or target selection | High | Medium | Treat remotes as intent only, validate all state transitions server-side | Open |
| R-007 | Body blocking prevents called player reaching center | Medium | Medium | Consider collision groups or temporary no-collide during center run | Open |
| R-008 | Identity system creates moderation/localization issues | Medium | Medium | Start with display names plus icons/colors instead of country names | Open |
| R-009 | Rounds become repetitive | Medium | Medium | Add map variants and cosmetic progression only after core loop succeeds | Open |
| R-010 | Project becomes hard to maintain if code remains only in `.rbxl` | High | Medium | Move runtime code into source-controlled Luau files through Rojo | Open |

