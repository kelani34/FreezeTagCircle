# Client Source

Client-owned presentation logic will live here.

Client scripts should show prompts, play local feedback, collect player intent, and display round state. They should not decide authoritative gameplay outcomes.

Current modules:

- `RoundHud.luau`: renders the first round prompt panel from server-owned round snapshots.
