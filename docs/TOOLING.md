# Tooling

FreezeTagCircle uses a source-controlled Roblox toolchain so local development, CI, and releases can use the same tool versions.

## Pinned Tools

Tool versions are pinned in `rokit.toml`:

| Tool | Purpose |
| --- | --- |
| Rojo | Sync and build Roblox place files from source |
| Wally | Roblox package management |
| Selene | Luau static analysis |
| StyLua | Luau formatting |
| Lune | Local Luau automation |

## Local Setup

Install Rokit, then install the project tools:

```sh
rokit install
```

If Rokit is not on your PATH, install it from the official release script or place the binary somewhere on your PATH. Rokit installs project tool shims under:

```text
~/.rokit/bin
```

Add that directory to your shell PATH so `rojo`, `wally`, `selene`, `stylua`, and `lune` resolve to the pinned project tools.

## Common Commands

```sh
rokit install
lune run scripts/tooling-doctor.luau
wally install
stylua src scripts
stylua --check src scripts
selene src scripts
rojo build default.project.json -o build/FreezeTagCircle.rbxlx
rojo serve default.project.json
```

## Formatting

Formatting is controlled by `.stylua.toml`.

Use:

```sh
stylua src scripts
```

CI checks formatting with:

```sh
stylua --check src scripts
```

## Static Analysis

Selene is configured by `selene.toml` with Roblox globals enabled.

Use:

```sh
selene src scripts
```

## Packages

Wally package metadata lives in `Wally.toml`.

The project currently has no runtime package dependencies. Add dependencies only when they solve a clear problem for gameplay, UI, testing, or developer workflow.

Generated Wally package folders should not be committed.

## CI

GitHub Actions runs `.github/workflows/ci.yml` on pull requests and pushes to `main`.

The workflow:

1. Installs Rokit.
2. Trusts and installs pinned tools.
3. Prints tool versions through Lune.
4. Validates the Wally manifest.
5. Checks formatting.
6. Runs Selene.
7. Builds a Rojo `.rbxlx` artifact.

CI does not publish to Roblox yet.

