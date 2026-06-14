local Tuning = {
	MinimumPlayers = 2,
	CircleSpawnRadius = 40,
	CenterZoneRadius = 10,
	CircleSpawnHeight = 4,
	IntermissionSeconds = 8,
	CallerChooseSeconds = 10,
	RunAwaySeconds = 8,
	StopFrozenSeconds = 1,
	TagAttemptSeconds = 12,
	ResolveSeconds = 3,
	TagJumpLimit = 3,
	TagRadius = 8,
}

return table.freeze(Tuning)
