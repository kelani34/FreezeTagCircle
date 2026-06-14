export type RoundState =
	"WaitingForPlayers"
	| "Setup"
	| "CallerChoosing"
	| "RunAway"
	| "StopFrozen"
	| "TagAttempt"
	| "Resolve"
	| "Reset"

local RoundStates = {
	WaitingForPlayers = "WaitingForPlayers" :: "WaitingForPlayers",
	Setup = "Setup" :: "Setup",
	CallerChoosing = "CallerChoosing" :: "CallerChoosing",
	RunAway = "RunAway" :: "RunAway",
	StopFrozen = "StopFrozen" :: "StopFrozen",
	TagAttempt = "TagAttempt" :: "TagAttempt",
	Resolve = "Resolve" :: "Resolve",
	Reset = "Reset" :: "Reset",
}

local OrderedRoundStates: { RoundState } = {
	RoundStates.WaitingForPlayers,
	RoundStates.Setup,
	RoundStates.CallerChoosing,
	RoundStates.RunAway,
	RoundStates.StopFrozen,
	RoundStates.TagAttempt,
	RoundStates.Resolve,
	RoundStates.Reset,
}

local RoundStateSet: { [string]: boolean } = {}
local NextRoundState: { [RoundState]: RoundState? } = {}

for index, state in OrderedRoundStates do
	RoundStateSet[state] = true
	NextRoundState[state] = OrderedRoundStates[index + 1]
end

local GameStates = {
	DefaultRoundState = RoundStates.WaitingForPlayers,
	RoundStates = table.freeze(RoundStates),
	OrderedRoundStates = table.freeze(OrderedRoundStates),
}

function GameStates.isRoundState(value: unknown): boolean
	return typeof(value) == "string" and RoundStateSet[value] == true
end

function GameStates.getNextRoundState(state: RoundState): RoundState?
	return NextRoundState[state]
end

function GameStates.getPostResetState(activePlayerCount: number, minimumPlayers: number): RoundState
	assert(activePlayerCount >= 0, "activePlayerCount must be non-negative")
	assert(minimumPlayers >= 1, "minimumPlayers must be positive")

	return if activePlayerCount >= minimumPlayers
		then RoundStates.Setup
		else RoundStates.WaitingForPlayers
end

return table.freeze(GameStates)
