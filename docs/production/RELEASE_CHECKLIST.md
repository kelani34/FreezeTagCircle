# Release Checklist

Use this checklist for tagged builds, staging publishes, and production releases.

## Before PR Merge

- Branch starts from latest `main`.
- Scope is focused.
- GitHub issue is linked when the change is feature, gameplay, testing, release, or infrastructure work.
- PR labels include type, area, priority, and review needs.
- Review is requested when the change carries meaningful gameplay, infrastructure, release, or security risk.
- Local checks pass:

```sh
lune run scripts/tooling-doctor.luau
wally manifest-to-json > /dev/null
lune run scripts/test.luau
stylua --check src scripts tests
selene src scripts tests
rojo build default.project.json -o build/FreezeTagCircle.rbxlx
```

- Roblox Studio integration test is run when Roblox service behavior changed:

```sh
lune run scripts/integration-test.luau
```

- Backlog is updated.
- Decisions are recorded when tradeoffs changed.
- Research or production docs are updated when process changed.

## Before Staging Publish

- PR is merged into `main` or a release branch.
- CI is green.
- Build artifact exists.
- Staging Roblox place IDs are configured.
- No production credentials are used.
- Manual smoke test plan is written.

## Staging Smoke Test

- Server opens successfully.
- New player can join.
- Round service starts without errors.
- Waiting state shows correct minimum-player status once UI exists.
- No errors appear in Studio output during startup.
- Any changed gameplay system has a focused playtest note.

## Before Production Publish

- Staging smoke test passed.
- Known issues are documented.
- Rollback plan is known.
- Release notes are drafted.
- Production publish is intentional and not automatic from ordinary PR merges.
