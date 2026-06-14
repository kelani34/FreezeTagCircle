local Players = game:GetService("Players")

export type FrozenPlayerRecord = {
	userId: number,
	walkSpeed: number,
	jumpPower: number,
	jumpHeight: number,
	autoRotate: boolean,
}

local MovementControlService = {}

local frozenRecords: { [number]: FrozenPlayerRecord } = {}

local function getPlayers(players: { Player }?): { Player }
	return players or Players:GetPlayers()
end

local function getHumanoid(player: Player): Humanoid?
	local character = player.Character

	if character == nil then
		return nil
	end

	return character:FindFirstChildOfClass("Humanoid")
end

local function freezePlayer(player: Player): boolean
	local humanoid = getHumanoid(player)

	if humanoid == nil then
		return false
	end

	if frozenRecords[player.UserId] == nil then
		frozenRecords[player.UserId] = {
			userId = player.UserId,
			walkSpeed = humanoid.WalkSpeed,
			jumpPower = humanoid.JumpPower,
			jumpHeight = humanoid.JumpHeight,
			autoRotate = humanoid.AutoRotate,
		}
	end

	humanoid.WalkSpeed = 0
	humanoid.JumpPower = 0
	humanoid.JumpHeight = 0
	humanoid.AutoRotate = false

	return true
end

local function restorePlayer(player: Player)
	local record = frozenRecords[player.UserId]

	if record == nil then
		return
	end

	local humanoid = getHumanoid(player)

	if humanoid then
		humanoid.WalkSpeed = record.walkSpeed
		humanoid.JumpPower = record.jumpPower
		humanoid.JumpHeight = record.jumpHeight
		humanoid.AutoRotate = record.autoRotate
	end

	frozenRecords[player.UserId] = nil
end

function MovementControlService.freezePlayersExcept(
	exceptUserId: number?,
	players: { Player }?
): { number }
	local frozenUserIds = {}

	for _, player in getPlayers(players) do
		if player.UserId ~= exceptUserId and freezePlayer(player) then
			table.insert(frozenUserIds, player.UserId)
		end
	end

	table.sort(frozenUserIds)

	return frozenUserIds
end

function MovementControlService.restorePlayers(players: { Player }?)
	for _, player in getPlayers(players) do
		restorePlayer(player)
	end
end

function MovementControlService.restoreAll()
	MovementControlService.restorePlayers()
	table.clear(frozenRecords)
end

function MovementControlService.isFrozen(userId: number): boolean
	return frozenRecords[userId] ~= nil
end

function MovementControlService.getFrozenUserIds(): { number }
	local userIds = {}

	for userId in frozenRecords do
		table.insert(userIds, userId)
	end

	table.sort(userIds)

	return userIds
end

return table.freeze(MovementControlService)
