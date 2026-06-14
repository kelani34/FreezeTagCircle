local Remotes = {
	FolderName = "FreezeTagCircleRemotes",
	RoundStateChanged = "RoundStateChanged",
	RequestRoundSnapshot = "RequestRoundSnapshot",
	RequestTargetSelection = "RequestTargetSelection",
	SubmitTargetSelection = "SubmitTargetSelection",
}

return table.freeze(Remotes)
