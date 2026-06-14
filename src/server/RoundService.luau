local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local ArenaService = require(script.Parent.ArenaService)
local CallerSelection = require(Shared.CallerSelection)
local GameStates = require(Shared.GameStates)
local TargetSelection = require(script.Parent.TargetSelection)
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
	spawnPlacements: { ArenaService.PlayerSpawnPlacement },
}

export type TargetSelectionAttempt = {
	accepted: boolean,
	reason: TargetSelection.FailureReason?,
	snapshot: RoundSnapshot,
}

export type CenterCheckResult = {
	reached: boolean,
	reason: "NotRunAway" | "NoCalledPlayer" | "NoPlayer" | "NoCharacter" | "OutsideCenter" | nil,
	distance: number?,
	snapshot: RoundSnapshot,
}

type TransitionOptions = {
	durationSeconds: number?,
	activePlayerCount: number?,
	callerUserId: number?,
	calledUserId: number?,
	spawnPlacements: { ArenaService.PlayerSpawnPlacement }?,
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
	spawnPlacements = {},
}

local started = false
local playerAddedConnection: RBXScriptConnection? = nil
local playerRemovingConnection: RBXScriptConnection? = nil

local function getActivePlayerCount(): number
	return #Players:GetPlayers()
end

local function getUserIds(players: { Player }): { number }
	local userIds = {}

	for index, player in players do
		userIds[index] = player.UserId
	end

	return userIds
end

local function isUserIdActive(activeUserIds: { number }, userId: number?): boolean
	if userId == nil then
		return false
	end

	for _, activeUserId in activeUserIds do
		if activeUserId == userId then
			return true
		end
	end

	return false
end

local function hasMinimumPlayers(activePlayerCount: number): boolean
	return activePlayerCount >= Tuning.MinimumPlayers
end

local function copySpawnPlacements(placements: { ArenaService.PlayerSpawnPlacement })
	local copiedPlacements = {}

	for index, placement in placements do
		copiedPlacements[index] = table.clone(placement)
	end

	return copiedPlacements
end

local function copySnapshot(snapshot: RoundSnapshot): RoundSnapshot
	local copiedSnapshot = table.clone(snapshot)
	copiedSnapshot.spawnPlacements = copySpawnPlacements(snapshot.spawnPlacements)

	return copiedSnapshot
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
		spawnPlacements = if shouldClearActors
			then {}
			elseif options and options.spawnPlacements ~= nil then copySpawnPlacements(
				options.spawnPlacements
			)
			else copySpawnPlacements(currentSnapshot.spawnPlacements),
	}
end

local function updateActivePlayerCount(activePlayerCount: number)
	currentSnapshot.activePlayerCount = activePlayerCount
	currentSnapshot.minimumPlayers = Tuning.MinimumPlayers
	currentSnapshot.hasMinimumPlayers = hasMinimumPlayers(activePlayerCount)
end

local function updateCallerForActivePlayers(activePlayers: { Player })
	local activeUserIds = getUserIds(activePlayers)

	if not isUserIdActive(activeUserIds, currentSnapshot.calledUserId) then
		currentSnapshot.calledUserId = nil
	end

	if isUserIdActive(activeUserIds, currentSnapshot.callerUserId) then
		return
	end

	if currentSnapshot.state == GameStates.RoundStates.CallerChoosing then
		currentSnapshot.callerUserId =
			CallerSelection.selectCallerUserId(activeUserIds, currentSnapshot.roundNumber)
	else
		currentSnapshot.callerUserId = nil
	end

	currentSnapshot.calledUserId = nil
end

local function moveToWaitingForPlayers(activePlayerCount: number)
	currentSnapshot = makeSnapshot(GameStates.RoundStates.WaitingForPlayers, {
		activePlayerCount = activePlayerCount,
		clearActors = true,
	})
end

local function refreshActivePlayerCount(): number
	local activePlayers = Players:GetPlayers()
	local activePlayerCount = #activePlayers

	if
		started
		and currentSnapshot.state ~= GameStates.RoundStates.WaitingForPlayers
		and not hasMinimumPlayers(activePlayerCount)
	then
		moveToWaitingForPlayers(activePlayerCount)
	else
		updateActivePlayerCount(activePlayerCount)
		updateCallerForActivePlayers(activePlayers)
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
	return copySnapshot(currentSnapshot)
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

	if
		currentSnapshot.state == GameStates.RoundStates.CallerChoosing
		and nextState == GameStates.RoundStates.RunAway
	then
		return isUserIdActive(getUserIds(Players:GetPlayers()), currentSnapshot.calledUserId)
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
		local activePlayers = Players:GetPlayers()

		options = table.clone(options or {})
		options.activePlayerCount = #activePlayers
		options.spawnPlacements = ArenaService.placePlayersAroundCircle(activePlayers)
		currentSnapshot.roundNumber += 1
	elseif nextState == GameStates.RoundStates.CallerChoosing then
		local activePlayers = Players:GetPlayers()

		options = table.clone(options or {})
		options.activePlayerCount = #activePlayers
		options.callerUserId = CallerSelection.selectCallerUserId(
			getUserIds(activePlayers),
			currentSnapshot.roundNumber
		)
	end

	currentSnapshot = makeSnapshot(nextState, options)

	return RoundService.getSnapshot()
end

function RoundService.canSelectTarget(
	requestingUserId: unknown,
	targetUserId: unknown
): TargetSelection.ValidationResult
	return TargetSelection.validate({
		isCallerChoosing = currentSnapshot.state == GameStates.RoundStates.CallerChoosing,
		activeUserIds = getUserIds(Players:GetPlayers()),
		callerUserId = currentSnapshot.callerUserId,
		requestingUserId = requestingUserId,
		targetUserId = targetUserId,
		currentTargetUserId = currentSnapshot.calledUserId,
	})
end

function RoundService.selectTarget(
	requestingUserId: unknown,
	targetUserId: unknown
): TargetSelectionAttempt
	local result = RoundService.canSelectTarget(requestingUserId, targetUserId)

	if result.accepted then
		currentSnapshot.calledUserId = result.targetUserId
	end

	return {
		accepted = result.accepted,
		reason = result.reason,
		snapshot = RoundService.getSnapshot(),
	}
end

function RoundService.checkCalledPlayerAtCenter(): CenterCheckResult
	if currentSnapshot.state ~= GameStates.RoundStates.RunAway then
		return {
			reached = false,
			reason = "NotRunAway",
			distance = nil,
			snapshot = RoundService.getSnapshot(),
		}
	end

	if currentSnapshot.calledUserId == nil then
		return {
			reached = false,
			reason = "NoCalledPlayer",
			distance = nil,
			snapshot = RoundService.getSnapshot(),
		}
	end

	local centerReach = ArenaService.getPlayerCenterReach(currentSnapshot.calledUserId)

	if centerReach.reached then
		RoundService.transitionTo(GameStates.RoundStates.StopFrozen)
	end

	return {
		reached = centerReach.reached,
		reason = centerReach.reason,
		distance = centerReach.distance,
		snapshot = RoundService.getSnapshot(),
	}
end

return table.freeze(RoundService)
