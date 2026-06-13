local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameStates = require(Shared.GameStates)
local Tuning = require(Shared.Tuning)

export type RoundSnapshot = {
	state: GameStates.RoundState,
	roundNumber: number,
	stateStartedAt: number,
	stateEndsAt: number?,
	activePlayerCount: number,
	minimumPlayers: number,
	hasMinimumPlayers: boolean,
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
	minimumPlayers = Tuning.MinimumPlayers,
	hasMinimumPlayers = false,
	callerUserId = nil,
	calledUserId = nil,
}

local started = false
local playerAddedConnection: RBXScriptConnection? = nil
local playerRemovingConnection: RBXScriptConnection? = nil

local function getActivePlayerCount(): number
	return #Players:GetPlayers()
end

local function hasMinimumPlayers(activePlayerCount: number): boolean
	return activePlayerCount >= Tuning.MinimumPlayers
end

local function makeSnapshot(
	state: GameStates.RoundState,
	options: TransitionOptions?
): RoundSnapshot
	local now = os.clock()
	local durationSeconds = if options then options.durationSeconds else nil
	local shouldClearActors = if options then options.clearActors == true else false
	local activePlayerCount = if options and options.activePlayerCount ~= nil
		then options.activePlayerCount
		else currentSnapshot.activePlayerCount

	return {
		state = state,
		roundNumber = currentSnapshot.roundNumber,
		stateStartedAt = now,
		stateEndsAt = if durationSeconds ~= nil then now + durationSeconds else nil,
		activePlayerCount = activePlayerCount,
		minimumPlayers = Tuning.MinimumPlayers,
		hasMinimumPlayers = hasMinimumPlayers(activePlayerCount),
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

local function updateActivePlayerCount(activePlayerCount: number)
	currentSnapshot.activePlayerCount = activePlayerCount
	currentSnapshot.minimumPlayers = Tuning.MinimumPlayers
	currentSnapshot.hasMinimumPlayers = hasMinimumPlayers(activePlayerCount)
end

local function moveToWaitingForPlayers(activePlayerCount: number)
	currentSnapshot = makeSnapshot(GameStates.RoundStates.WaitingForPlayers, {
		activePlayerCount = activePlayerCount,
		clearActors = true,
	})
end

local function refreshActivePlayerCount(): number
	local activePlayerCount = getActivePlayerCount()

	if
		started
		and currentSnapshot.state ~= GameStates.RoundStates.WaitingForPlayers
		and not hasMinimumPlayers(activePlayerCount)
	then
		moveToWaitingForPlayers(activePlayerCount)
	else
		updateActivePlayerCount(activePlayerCount)
	end

	return activePlayerCount
end

local function disconnectPlayerSignals()
	if playerAddedConnection then
		playerAddedConnection:Disconnect()
		playerAddedConnection = nil
	end

	if playerRemovingConnection then
		playerRemovingConnection:Disconnect()
		playerRemovingConnection = nil
	end
end

local function connectPlayerSignals()
	if playerAddedConnection or playerRemovingConnection then
		return
	end

	playerAddedConnection = Players.PlayerAdded:Connect(function()
		refreshActivePlayerCount()
	end)

	playerRemovingConnection = Players.PlayerRemoving:Connect(function()
		task.defer(refreshActivePlayerCount)
	end)
end

function RoundService.start()
	if started then
		return
	end

	started = true
	connectPlayerSignals()
	moveToWaitingForPlayers(getActivePlayerCount())
end

function RoundService.stop()
	started = false
	disconnectPlayerSignals()
	currentSnapshot = makeSnapshot(GameStates.RoundStates.WaitingForPlayers, {
		activePlayerCount = getActivePlayerCount(),
		clearActors = true,
	})
end

function RoundService.isStarted(): boolean
	return started
end

function RoundService.getSnapshot(): RoundSnapshot
	return table.clone(currentSnapshot)
end

function RoundService.hasMinimumPlayers(): boolean
	return currentSnapshot.hasMinimumPlayers
end

function RoundService.refreshActivePlayerCount(): RoundSnapshot
	refreshActivePlayerCount()

	return RoundService.getSnapshot()
end

function RoundService.canTransitionTo(nextState: GameStates.RoundState): boolean
	if
		started
		and currentSnapshot.state == GameStates.RoundStates.WaitingForPlayers
		and nextState == GameStates.RoundStates.Setup
	then
		updateActivePlayerCount(getActivePlayerCount())
	end

	local transitions = allowedTransitions[currentSnapshot.state]

	if transitions == nil or transitions[nextState] ~= true then
		return false
	end

	if
		currentSnapshot.state == GameStates.RoundStates.WaitingForPlayers
		and nextState == GameStates.RoundStates.Setup
	then
		return currentSnapshot.hasMinimumPlayers
	end

	return true
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
