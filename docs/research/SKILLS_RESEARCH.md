# Skills Research Notes

## Summary

No vetted Roblox-specific Codex skill was installed from the official curated skill list or the local environment during this pass.

## Findings

- No local `skills` or `skills.sh` executable was available on PATH.
- The official OpenAI curated skills listing did not surface Roblox, Luau, or Rojo-specific skills.
- Search results for Roblox-related third-party skills included unverified or unrelated repositories, including executor-style Roblox content that is not appropriate for professional game development.
- A project-local `freezetagcircle-roundup` skill was created instead so the repo carries its own workflow memory.

## Decision

Do not install unvetted third-party Roblox skills globally. Prefer:

- Project-local skills committed to this repository.
- Pinned Roblox tools through Rokit.
- Official or primary-source Roblox tooling, such as Rojo, run-in-roblox, and TestEZ.

## Follow-Up

- Re-evaluate third-party skills only if they are source-reviewable, relevant to Roblox development, and safe to install.
- Consider adding a dedicated Roblox implementation skill if repeated patterns emerge around services, remotes, character handling, or Studio test workflows.

