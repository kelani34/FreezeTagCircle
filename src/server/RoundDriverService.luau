local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local GameStates = require(Shared.GameStates)
local RoundService = require(script.Parent.RoundService)
local TargetSelection = require(script.Parent.TargetSelection)
local Tuning = require(Shared.Tuning)

local RoundDriverService = {}

local StepSeconds = 0.25

local running = false

local function isExpired(snapshot: RoundService.RoundSnapshot): boolean
	return snapshot.stateEndsAt ~= nil and os.clock() >= snapshot.stateEndsAt
end

local function getActiveUserIds(): { number }
	local userIds = {}

	for index, player in Players:GetPlayers() do
		userIds[index] = player.UserId
	end

	return userIds
end

local function transitionIfAllowed(
	nextState: GameStates.RoundState,
	durationSeconds: number?
): boolean
	if not RoundService.canTransitionTo(nextState) then
		return false
	end

	RoundService.transitionTo(nextState, {
		durationSeconds = durationSeconds,
	})

	return true
end

local function selectAutomaticTarget(snapshot: RoundService.RoundSnapshot): boolean
	if snapshot.callerUserId == nil then
		return false
	end

	local targetUserId =
		TargetSelection.selectAutomaticTargetUserId(getActiveUserIds(), snapshot.callerUserId)

	if targetUserId == nil then
		return false
	end

	return RoundService.selectTarget(snapshot.callerUserId, targetUserId).accepted
end

local function attemptProximityTag(snapshot: RoundService.RoundSnapshot): boolean
	if snapshot.calledUserId == nil then
		return false
	end

	for _, frozenUserId in snapshot.frozenUserIds do
		if RoundService.attemptTag(snapshot.calledUserId, frozenUserId).accepted then
			return true
		end
	end

	return false
end

local function step()
	local snapshot = RoundService.getSnapshot()

	if snapshot.state == GameStates.RoundStates.WaitingForPlayers then
		if RoundService.hasMinimumPlayers() then
			transitionIfAllowed(GameStates.RoundStates.Setup, Tuning.IntermissionSeconds)
		end
	elseif snapshot.state == GameStates.RoundStates.Setup then
		if isExpired(snapshot) then
			transitionIfAllowed(GameStates.RoundStates.CallerChoosing, Tuning.CallerChooseSeconds)
		end
	elseif snapshot.state == GameStates.RoundStates.CallerChoosing then
		if snapshot.calledUserId == nil then
			selectAutomaticTarget(snapshot)
		end

		if RoundService.canTransitionTo(GameStates.RoundStates.RunAway) then
			RoundService.transitionTo(GameStates.RoundStates.RunAway, {
				durationSeconds = Tuning.RunAwaySeconds,
			})
		end
	elseif snapshot.state == GameStates.RoundStates.RunAway then
		local centerResult = RoundService.checkCalledPlayerAtCenter()

		if not centerResult.reached and isExpired(snapshot) then
			transitionIfAllowed(GameStates.RoundStates.StopFrozen, Tuning.StopFrozenSeconds)
		end
	elseif snapshot.state == GameStates.RoundStates.StopFrozen then
		if isExpired(snapshot) then
			transitionIfAllowed(GameStates.RoundStates.TagAttempt, Tuning.TagAttemptSeconds)
		end
	elseif snapshot.state == GameStates.RoundStates.TagAttempt then
		if not attemptProximityTag(snapshot) and isExpired(snapshot) then
			RoundService.resolveTagAttemptWithoutTag()
		end
	elseif snapshot.state == GameStates.RoundStates.Resolve then
		if snapshot.stateStartedAt + Tuning.ResolveSeconds <= os.clock() then
			RoundService.resetRound()
		end
	end
end

function RoundDriverService.start()
	if running then
		return
	end

	running = true

	task.spawn(function()
		while running do
			step()
			task.wait(StepSeconds)
		end
	end)
end

function RoundDriverService.stop()
	running = false
end

function RoundDriverService.isRunning(): boolean
	return running
end

return table.freeze(RoundDriverService)
