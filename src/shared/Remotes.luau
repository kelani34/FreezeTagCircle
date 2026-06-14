local Remotes = {
	FolderName = "FreezeTagCircleRemotes",
	RoundDebugStatus = "RoundDebugStatus",
	RoundStateChanged = "RoundStateChanged",
	RequestRoundSnapshot = "RequestRoundSnapshot",
	RequestTargetSelection = "RequestTargetSelection",
	SubmitTargetSelection = "SubmitTargetSelection",
}

return table.freeze(Remotes)
