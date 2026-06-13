## Summary

- 

## Linked Issues

Closes #

## Labels

Expected labels:

- `type:*`
- `area:*`
- `priority:*`
- `needs:copilot-review`

## Validation

- [ ] `lune run scripts/tooling-doctor.luau`
- [ ] `wally manifest-to-json > /dev/null`
- [ ] `lune run scripts/test.luau`
- [ ] `stylua --check src scripts tests`
- [ ] `selene src scripts tests`
- [ ] `rojo build default.project.json -o build/FreezeTagCircle.rbxlx`
- [ ] Roblox Studio integration test, if Roblox service behavior changed:
  `lune run scripts/integration-test.luau`

## Review Gate

- [ ] Copilot code review requested before merge
- [ ] Review comments addressed or intentionally documented
- [ ] CI green before merge

## Notes

- 

