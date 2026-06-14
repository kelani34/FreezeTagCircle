local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
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

function ArenaService.calculateSpawnSlotsForCount(totalSlots: number): { CircleSpawns.SpawnSlot }
	return CircleSpawns.calculateSlots(
		totalSlots,
		Tuning.CircleSpawnRadius,
		Tuning.CircleSpawnHeight
	)
end

function ArenaService.getSpawnAssignments(players: { Player }?): { CircleSpawns.SpawnAssignment }
	local selectedPlayers = getPlayers(players)

	return CircleSpawns.assignSlotsToUserIds(
		getUserIds(selectedPlayers),
		Tuning.CircleSpawnRadius,
		Tuning.CircleSpawnHeight
	)
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
