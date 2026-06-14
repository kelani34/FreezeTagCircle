# Audio And VFX Research

## 2026-06-14 Procedural First-Playable Feedback

Question:

Should the first playable depend on Roblox Studio or Creator Store asset imports for STOP/frozen feedback?

Current answer:

Use source-controlled Roblox-native procedural effects first.

Rationale:

- Rojo sync should make the latest playtest experience visible without manual Studio asset work.
- Marketplace assets can have permission, moderation, availability, or licensing uncertainty.
- Procedural Parts, Highlights, ParticleEmitters, PointLights, TweenService animations, and configurable sound IDs are enough for first-playable readability.
- Curated assets can still be introduced later behind `FeedbackTuning` after playtests prove the effect direction.

Implemented approach:

- `FeedbackTuning` centralizes temporary feedback names, timing, colors, and sound hooks.
- `RoundHud` plays a STOP overlay, sound cue, and local arena shockwave from the live server STOP event.
- `MovementControlService` creates temporary server-owned ice visuals on frozen characters without changing avatar parts permanently.

Follow-up research:

- Test whether the current STOP sound asset is audible and appropriate across local Studio clients.
- Evaluate curated sound IDs only after finalizing the desired STOP/freeze feel.
- Consider authored Roblox Studio assets later for lobby and arena decoration once core round readability is proven.
