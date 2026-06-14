local Remotes = {
	FolderName = "FreezeTagCircleRemotes",
	RoundDebugStatus = "RoundDebugStatus",
	RoundStateChanged = "RoundStateChanged",
	RequestRoundSnapshot = "RequestRoundSnapshot",
	RequestTargetSelection = "RequestTargetSelection",
	StopFeedback = "StopFeedback",
	SubmitTargetSelection = "SubmitTargetSelection",
}

return table.freeze(Remotes)
