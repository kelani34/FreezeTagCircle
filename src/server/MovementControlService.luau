local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local FeedbackTuning = require(Shared.FeedbackTuning)

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
local FROZEN_EFFECT_NAME = FeedbackTuning.FrozenEffectName
local ICE_SHARD_DEFINITIONS = {
	{
		name = "IceShardFront",
		offset = Vector3.new(0, 0.2, -2.8),
		size = Vector3.new(0.65, 5.2, 1.1),
		rotation = Vector3.new(-8, 12, -10),
	},
	{
		name = "IceShardBack",
		offset = Vector3.new(0.1, 0.4, 2.7),
		size = Vector3.new(0.7, 4.7, 1.2),
		rotation = Vector3.new(10, -18, 8),
	},
	{
		name = "IceShardLeft",
		offset = Vector3.new(-2.6, 0, 0),
		size = Vector3.new(1.1, 5.4, 0.6),
		rotation = Vector3.new(6, -8, 14),
	},
	{
		name = "IceShardRight",
		offset = Vector3.new(2.6, -0.1, 0.2),
		size = Vector3.new(1, 5, 0.65),
		rotation = Vector3.new(-5, 10, -16),
	},
	{
		name = "IceShardLow",
		offset = Vector3.new(0.9, -2.2, -0.8),
		size = Vector3.new(1.2, 2.5, 0.6),
		rotation = Vector3.new(22, 36, 12),
	},
	{
		name = "IceShardHigh",
		offset = Vector3.new(-0.7, 2.1, 0.6),
		size = Vector3.new(0.8, 2.8, 0.5),
		rotation = Vector3.new(-28, -26, -10),
	},
}

assert(
	#ICE_SHARD_DEFINITIONS == FeedbackTuning.FrozenShardCount,
	"Frozen shard definitions must match FeedbackTuning.FrozenShardCount"
)

local function colorFromRgb(rgb: { number }): Color3
	return Color3.fromRGB(rgb[1], rgb[2], rgb[3])
end

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

local function createIceShard(
	parent: Instance,
	name: string,
	pivot: CFrame,
	offset: Vector3,
	size: Vector3,
	rotation: Vector3
)
	local shard = Instance.new("Part")
	shard.Name = name
	shard.Anchored = true
	shard.CanCollide = false
	shard.CastShadow = false
	shard.CFrame = pivot
		* CFrame.new(offset)
		* CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z))
	shard.Color = colorFromRgb(FeedbackTuning.FrozenIceColorRgb)
	shard.Material = Enum.Material.Ice
	shard.Size = size
	shard.Transparency = 0.42
	shard.Parent = parent
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
	highlight.FillColor = colorFromRgb(FeedbackTuning.FrozenHighlightFillColorRgb)
	highlight.FillTransparency = 0.45
	highlight.OutlineColor = colorFromRgb(FeedbackTuning.FrozenHighlightOutlineColorRgb)
	highlight.OutlineTransparency = 0.05
	highlight.Parent = effectFolder

	local pivot = character:GetPivot()
	local iceShell = Instance.new("Part")
	iceShell.Name = "IceShell"
	iceShell.Anchored = true
	iceShell.CanCollide = false
	iceShell.CastShadow = false
	iceShell.CFrame = pivot
	iceShell.Color = colorFromRgb(FeedbackTuning.FrozenIceColorRgb)
	iceShell.Material = Enum.Material.Ice
	iceShell.Size = Vector3.new(5.2, 6.9, 5.2)
	iceShell.Transparency = 0.62
	iceShell.Parent = effectFolder

	local glow = Instance.new("PointLight")
	glow.Name = "IceGlow"
	glow.Brightness = 1.2
	glow.Color = colorFromRgb(FeedbackTuning.FrozenHighlightFillColorRgb)
	glow.Range = 12
	glow.Parent = iceShell

	for _, definition in ICE_SHARD_DEFINITIONS do
		createIceShard(
			effectFolder,
			definition.name,
			pivot,
			definition.offset,
			definition.size,
			definition.rotation
		)
	end

	local sparkle = Instance.new("ParticleEmitter")
	sparkle.Name = "IceSparkles"
	sparkle.Color = ColorSequence.new(colorFromRgb(FeedbackTuning.FrozenHighlightOutlineColorRgb))
	sparkle.LightEmission = 0.75
	sparkle.Rate = 26
	sparkle.Lifetime = NumberRange.new(0.7, 1.25)
	sparkle.Speed = NumberRange.new(0.35, 1.15)
	sparkle.SpreadAngle = Vector2.new(45, 45)
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
