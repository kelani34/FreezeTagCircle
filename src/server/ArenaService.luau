local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local CenterZone = require(Shared.CenterZone)
local CircleSpawns = require(Shared.CircleSpawns)
local Tuning = require(Shared.Tuning)

export type PlayerSpawnPlacement = {
	userId: number,
	slotIndex: number,
	totalSlots: number,
	radius: number,
	x: number,
	y: number,
	z: number,
	placed: boolean,
}

export type LobbyPlacement = {
	userId: number,
	slotIndex: number,
	x: number,
	y: number,
	z: number,
	placed: boolean,
}

export type CenterReachResult = {
	userId: number,
	reached: boolean,
	distance: number?,
	reason: "NoPlayer" | "NoCharacter" | "OutsideCenter" | nil,
}

export type PlayerDistanceResult = {
	sourceUserId: number,
	targetUserId: number,
	distance: number?,
	reason: "NoSourcePlayer" | "NoTargetPlayer" | "NoSourceCharacter" | "NoTargetCharacter" | nil,
}

local ArenaService = {}

local function getPlayers(players: { Player }?): { Player }
	return players or Players:GetPlayers()
end

local function getUserIds(players: { Player }): { number }
	local userIds = {}

	for index, player in players do
		userIds[index] = player.UserId
	end

	return userIds
end

local function getPlayerByUserId(userId: number, players: { Player }): Player?
	for _, player in players do
		if player.UserId == userId then
			return player
		end
	end

	return nil
end

local function copyPlacement(
	assignment: CircleSpawns.SpawnAssignment,
	placed: boolean
): PlayerSpawnPlacement
	return {
		userId = assignment.userId,
		slotIndex = assignment.slotIndex,
		totalSlots = assignment.totalSlots,
		radius = assignment.radius,
		x = assignment.x,
		y = assignment.y,
		z = assignment.z,
		placed = placed,
	}
end

local function getSortedPlayers(players: { Player }): { Player }
	local sortedPlayers = table.clone(players)

	table.sort(sortedPlayers, function(leftPlayer, rightPlayer)
		return leftPlayer.UserId < rightPlayer.UserId
	end)

	return sortedPlayers
end

local function copyLobbyPlacement(
	player: Player,
	slotIndex: number,
	position: Vector3,
	placed: boolean
): LobbyPlacement
	return {
		userId = player.UserId,
		slotIndex = slotIndex,
		x = position.X,
		y = position.Y,
		z = position.Z,
		placed = placed,
	}
end

local function getLobbyPosition(slotIndex: number, totalSlots: number): Vector3
	local maxColumns = 4
	local columns = math.min(math.max(totalSlots, 1), maxColumns)
	local row = math.floor((slotIndex - 1) / maxColumns)
	local column = (slotIndex - 1) % maxColumns
	local xOffset = (column - ((columns - 1) / 2)) * Tuning.LobbySpawnSpacing
	local zOffset = row * Tuning.LobbySpawnSpacing

	return Vector3.new(
		Tuning.LobbyCenterX + xOffset,
		Tuning.LobbySpawnHeight,
		Tuning.LobbyCenterZ + zOffset
	)
end

function ArenaService.calculateSpawnSlotsForCount(totalSlots: number): { CircleSpawns.SpawnSlot }
	return CircleSpawns.calculateSlots(
		totalSlots,
		Tuning.CircleSpawnRadius,
		Tuning.CircleSpawnHeight
	)
end

function ArenaService.isPositionInCenterZone(position: Vector3): boolean
	return CenterZone.isWithinRadius(position.X, position.Z, Tuning.CenterZoneRadius)
end

function ArenaService.getPlayerCenterReach(userId: number, players: { Player }?): CenterReachResult
	local selectedPlayers = getPlayers(players)
	local selectedPlayer = getPlayerByUserId(userId, selectedPlayers)

	if selectedPlayer == nil then
		return {
			userId = userId,
			reached = false,
			distance = nil,
			reason = "NoPlayer",
		}
	end

	local character = selectedPlayer.Character

	if character == nil then
		return {
			userId = userId,
			reached = false,
			distance = nil,
			reason = "NoCharacter",
		}
	end

	local position = character:GetPivot().Position
	local distance = CenterZone.getHorizontalDistance(position.X, position.Z)

	return {
		userId = userId,
		reached = distance <= Tuning.CenterZoneRadius,
		distance = distance,
		reason = if distance <= Tuning.CenterZoneRadius then nil else "OutsideCenter",
	}
end

function ArenaService.getDistanceBetweenPlayers(
	sourceUserId: number,
	targetUserId: number,
	players: { Player }?
): PlayerDistanceResult
	local selectedPlayers = getPlayers(players)
	local sourcePlayer = getPlayerByUserId(sourceUserId, selectedPlayers)

	if sourcePlayer == nil then
		return {
			sourceUserId = sourceUserId,
			targetUserId = targetUserId,
			distance = nil,
			reason = "NoSourcePlayer",
		}
	end

	local targetPlayer = getPlayerByUserId(targetUserId, selectedPlayers)

	if targetPlayer == nil then
		return {
			sourceUserId = sourceUserId,
			targetUserId = targetUserId,
			distance = nil,
			reason = "NoTargetPlayer",
		}
	end

	local sourceCharacter = sourcePlayer.Character

	if sourceCharacter == nil then
		return {
			sourceUserId = sourceUserId,
			targetUserId = targetUserId,
			distance = nil,
			reason = "NoSourceCharacter",
		}
	end

	local targetCharacter = targetPlayer.Character

	if targetCharacter == nil then
		return {
			sourceUserId = sourceUserId,
			targetUserId = targetUserId,
			distance = nil,
			reason = "NoTargetCharacter",
		}
	end

	return {
		sourceUserId = sourceUserId,
		targetUserId = targetUserId,
		distance = (sourceCharacter:GetPivot().Position - targetCharacter:GetPivot().Position).Magnitude,
		reason = nil,
	}
end

function ArenaService.getSpawnAssignments(players: { Player }?): { CircleSpawns.SpawnAssignment }
	local selectedPlayers = getPlayers(players)

	return CircleSpawns.assignSlotsToUserIds(
		getUserIds(selectedPlayers),
		Tuning.CircleSpawnRadius,
		Tuning.CircleSpawnHeight
	)
end

function ArenaService.getLobbyPosition(slotIndex: number, totalSlots: number): Vector3
	return getLobbyPosition(slotIndex, totalSlots)
end

function ArenaService.placePlayerInLobby(
	player: Player,
	slotIndex: number?,
	totalSlots: number?
): LobbyPlacement
	local selectedSlotIndex = slotIndex or 1
	local selectedTotalSlots = totalSlots or 1
	local position = getLobbyPosition(selectedSlotIndex, selectedTotalSlots)
	local character = player.Character
	local placed = false

	if character then
		character:PivotTo(CFrame.lookAt(position, Vector3.new(0, position.Y, 0)))
		placed = true
	end

	return copyLobbyPlacement(player, selectedSlotIndex, position, placed)
end

function ArenaService.placePlayersInLobby(players: { Player }?): { LobbyPlacement }
	local selectedPlayers = getSortedPlayers(getPlayers(players))
	local placements = {}

	for index, player in selectedPlayers do
		placements[index] = ArenaService.placePlayerInLobby(player, index, #selectedPlayers)
	end

	return placements
end

function ArenaService.placePlayersAroundCircle(players: { Player }?): { PlayerSpawnPlacement }
	local selectedPlayers = getPlayers(players)
	local playerByUserId = {}

	for _, player in selectedPlayers do
		playerByUserId[player.UserId] = player
	end

	local placements = {}

	for index, assignment in ArenaService.getSpawnAssignments(selectedPlayers) do
		local player = playerByUserId[assignment.userId]
		local character = if player then player.Character else nil
		local placed = false

		if character then
			local position = Vector3.new(assignment.x, assignment.y, assignment.z)
			local center = Vector3.new(0, assignment.y, 0)

			character:PivotTo(CFrame.lookAt(position, center))
			placed = true
		end

		placements[index] = copyPlacement(assignment, placed)
	end

	return placements
end

return table.freeze(ArenaService)
