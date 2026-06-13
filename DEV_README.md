# FreezeTagCircle Developer Notes

Generated from a Rojo starter project and upgraded with pinned Roblox tooling.

## Getting Started

Install project tools:

```bash
rokit install
```

To build the place from scratch, use:

```bash
rojo build default.project.json -o "build/FreezeTagCircle.rbxlx"
```

Next, open the built place in Roblox Studio or start the Rojo server:

```bash
rojo serve default.project.json
```

Quality checks:

```bash
lune run scripts/tooling-doctor.luau
lune run scripts/test.luau
stylua --check src scripts tests
selene src scripts tests
wally manifest-to-json > /dev/null
```

For more help, see `docs/TOOLING.md` and the Rojo documentation.
