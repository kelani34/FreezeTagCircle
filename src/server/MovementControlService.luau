local Players = game:GetService("Players")

export type FrozenPlayerRecord = {
	userId: number,
	walkSpeed: number,
	jumpPower: number,
	jumpHeight: number,
	autoRotate: boolean,
	effectFolder: Folder?,
}

local MovementControlService = {}

local frozenRecords: { [number]: FrozenPlayerRecord } = {}
local FROZEN_EFFECT_NAME = "FreezeTagCircleFrozenEffect"

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

local function removeFrozenEffect(character: Model?)
	if character == nil then
		return
	end

	local existingEffect = character:FindFirstChild(FROZEN_EFFECT_NAME)

	if existingEffect then
		existingEffect:Destroy()
	end
end

local function addFrozenEffect(player: Player): Folder?
	local character = player.Character

	if character == nil then
		return nil
	end

	removeFrozenEffect(character)

	local effectFolder = Instance.new("Folder")
	effectFolder.Name = FROZEN_EFFECT_NAME

	local highlight = Instance.new("Highlight")
	highlight.Name = "IceHighlight"
	highlight.Adornee = character
	highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
	highlight.FillColor = Color3.fromRGB(127, 225, 255)
	highlight.FillTransparency = 0.45
	highlight.OutlineColor = Color3.fromRGB(235, 252, 255)
	highlight.OutlineTransparency = 0.05
	highlight.Parent = effectFolder

	local pivot = character:GetPivot()
	local iceShell = Instance.new("Part")
	iceShell.Name = "IceShell"
	iceShell.Anchored = true
	iceShell.CanCollide = false
	iceShell.CFrame = pivot
	iceShell.Color = Color3.fromRGB(145, 226, 255)
	iceShell.Material = Enum.Material.Ice
	iceShell.Size = Vector3.new(4.8, 6.8, 4.8)
	iceShell.Transparency = 0.55
	iceShell.Parent = effectFolder

	local sparkle = Instance.new("ParticleEmitter")
	sparkle.Name = "IceSparkles"
	sparkle.Color = ColorSequence.new(Color3.fromRGB(220, 250, 255))
	sparkle.LightEmission = 0.6
	sparkle.Rate = 16
	sparkle.Lifetime = NumberRange.new(0.55, 1)
	sparkle.Speed = NumberRange.new(0.2, 0.8)
	sparkle.SpreadAngle = Vector2.new(25, 25)
	sparkle.Parent = iceShell

	effectFolder.Parent = character

	return effectFolder
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
			effectFolder = addFrozenEffect(player),
		}
	else
		frozenRecords[player.UserId].effectFolder = addFrozenEffect(player)
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

	if record.effectFolder then
		record.effectFolder:Destroy()
	end

	removeFrozenEffect(player.Character)

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

function MovementControlService.FrozenEffectName(): string
	return FROZEN_EFFECT_NAME
end

return table.freeze(MovementControlService)
