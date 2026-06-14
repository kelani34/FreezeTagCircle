local Tuning = {
	MinimumPlayers = 2,
	CircleSpawnRadius = 48,
	CenterZoneRadius = 8,
	CircleSpawnHeight = 4,
	IntermissionSeconds = 8,
	CallerChooseSeconds = 10,
	RunAwaySeconds = 8,
	StopFrozenSeconds = 1,
	TagAttemptSeconds = 12,
	ResolveSeconds = 3,
	TagJumpLimit = 3,
	TagRadius = 6,
}

return table.freeze(Tuning)
