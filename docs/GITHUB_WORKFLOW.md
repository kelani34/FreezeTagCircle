# GitHub Workflow

FreezeTagCircle uses GitHub issues, labels, pull requests, reviews, and CI as part of the development process.

## Branch Flow

Every work session should start from a clean, current `main`:

```sh
git switch main
git pull --ff-only origin main
git switch -c feature/<short-purpose>
```

Use:

- `feature/<short-purpose>` for game or product capability.
- `fix/<short-purpose>` for bugs.
- `chore/<short-purpose>` for process, docs, tooling, or repo maintenance.
- `release/<version>` for release preparation.

## Issues

Use GitHub issues for:

- Gameplay features.
- Testing infrastructure.
- Roblox staging and deployment work.
- Bugs and regressions.
- Playtest plans and results.
- Research tasks that affect implementation direction.

Every implementation PR should link an issue unless the change is very small repository hygiene.

## Labels

Use at least one label from each relevant group:

- Type: `type:feature`, `type:bug`, `type:chore`, `type:docs`, `type:test`, `type:infra`
- Area: `area:roblox`, `area:gameplay`, `area:ci`, `area:release`, `area:docs`
- Priority: `priority:p0`, `priority:p1`, `priority:p2`
- Status: `status:ready`, `status:blocked`
- Review or environment needs: `needs:copilot-review`, `needs:roblox-studio`

## Pull Requests

PRs should include:

- Summary.
- Linked issue.
- Labels.
- Validation commands.
- Notes about skipped checks or manual Roblox Studio requirements.

Default PR flow:

1. Open as draft.
2. Add labels.
3. Link the issue.
4. Run local validation.
5. Wait for CI.
6. Request Copilot code review.
7. Address or explicitly respond to review feedback.
8. Mark ready.
9. Squash merge when green and scoped.
10. Delete the branch.

## Copilot Review Gate

Before merging, request review from GitHub Copilot's pull request reviewer when available.

If Copilot review cannot be requested by CLI or GitHub API, document the failed request in the PR and use the GitHub UI as the fallback.

Do not ignore Copilot review comments. Either implement the change or explain the tradeoff in the PR before merging.

