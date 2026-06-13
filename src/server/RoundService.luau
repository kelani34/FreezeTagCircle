local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameStates = require(Shared.GameStates)

export type RoundSnapshot = {
	state: GameStates.RoundState,
	roundNumber: number,
	stateStartedAt: number,
	stateEndsAt: number?,
	activePlayerCount: number,
	callerUserId: number?,
	calledUserId: number?,
}

type TransitionOptions = {
	durationSeconds: number?,
	activePlayerCount: number?,
	callerUserId: number?,
	calledUserId: number?,
	clearActors: boolean?,
}

local RoundService = {}

local allowedTransitions: { [GameStates.RoundState]: { [GameStates.RoundState]: boolean } } = {
	WaitingForPlayers = {
		Setup = true,
	},
	Setup = {
		CallerChoosing = true,
		WaitingForPlayers = true,
	},
	CallerChoosing = {
		RunAway = true,
		WaitingForPlayers = true,
	},
	RunAway = {
		StopFrozen = true,
		WaitingForPlayers = true,
	},
	StopFrozen = {
		TagAttempt = true,
		WaitingForPlayers = true,
	},
	TagAttempt = {
		Resolve = true,
		WaitingForPlayers = true,
	},
	Resolve = {
		Reset = true,
		WaitingForPlayers = true,
	},
	Reset = {
		WaitingForPlayers = true,
		Setup = true,
	},
}

local currentSnapshot: RoundSnapshot = {
	state = GameStates.DefaultRoundState,
	roundNumber = 0,
	stateStartedAt = os.clock(),
	stateEndsAt = nil,
	activePlayerCount = 0,
	callerUserId = nil,
	calledUserId = nil,
}

local started = false

local function makeSnapshot(
	state: GameStates.RoundState,
	options: TransitionOptions?
): RoundSnapshot
	local now = os.clock()
	local durationSeconds = if options then options.durationSeconds else nil
	local shouldClearActors = if options then options.clearActors == true else false

	return {
		state = state,
		roundNumber = currentSnapshot.roundNumber,
		stateStartedAt = now,
		stateEndsAt = if durationSeconds ~= nil then now + durationSeconds else nil,
		activePlayerCount = if options and options.activePlayerCount ~= nil
			then options.activePlayerCount
			else currentSnapshot.activePlayerCount,
		callerUserId = if shouldClearActors
			then nil
			elseif options and options.callerUserId ~= nil then options.callerUserId
			else currentSnapshot.callerUserId,
		calledUserId = if shouldClearActors
			then nil
			elseif options and options.calledUserId ~= nil then options.calledUserId
			else currentSnapshot.calledUserId,
	}
end

function RoundService.start()
	if started then
		return
	end

	started = true
	currentSnapshot = makeSnapshot(GameStates.RoundStates.WaitingForPlayers, nil)
end

function RoundService.stop()
	started = false
	currentSnapshot = makeSnapshot(GameStates.RoundStates.WaitingForPlayers, {
		clearActors = true,
	})
end

function RoundService.isStarted(): boolean
	return started
end

function RoundService.getSnapshot(): RoundSnapshot
	return table.clone(currentSnapshot)
end

function RoundService.canTransitionTo(nextState: GameStates.RoundState): boolean
	local transitions = allowedTransitions[currentSnapshot.state]

	return transitions ~= nil and transitions[nextState] == true
end

function RoundService.transitionTo(
	nextState: GameStates.RoundState,
	options: TransitionOptions?
): RoundSnapshot
	assert(GameStates.isRoundState(nextState), `Unknown round state: {tostring(nextState)}`)
	assert(
		RoundService.canTransitionTo(nextState),
		`Invalid round transition: {currentSnapshot.state} -> {nextState}`
	)

	if nextState == GameStates.RoundStates.Setup then
		currentSnapshot.roundNumber += 1
	end

	currentSnapshot = makeSnapshot(nextState, options)

	return RoundService.getSnapshot()
end

return table.freeze(RoundService)
