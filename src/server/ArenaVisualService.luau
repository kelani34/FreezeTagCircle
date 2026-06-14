local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local ArenaVisuals = require(Shared.ArenaVisuals)
local RoundService = require(script.Parent.RoundService)
local Tuning = require(Shared.Tuning)

local ArenaVisualService = {}

local ARENA_FOLDER_NAME = "Arena"
local GENERATED_FOLDER_NAME = "GeneratedCircleArena"
local RING_FOLDER_NAME = "CircleBoundary"
local SLOT_FOLDER_NAME = "PlayerCircleSlots"
local RUN_FOLDER_NAME = "RunAwayMarkers"

local CYAN = Color3.fromRGB(0, 217, 255)
local BLUE = Color3.fromRGB(0, 102, 255)
local GOLD = Color3.fromRGB(255, 193, 0)

local started = false
local snapshotConnection: RBXScriptConnection? = nil

local function getOrCreateFolder(parent: Instance, name: string): Folder
	local existingFolder = parent:FindFirstChild(name)

	if existingFolder and existingFolder:IsA("Folder") then
		return existingFolder
	end

	if existingFolder then
		existingFolder:Destroy()
	end

	local folder = Instance.new("Folder")
	folder.Name = name
	folder.Parent = parent

	return folder
end

local function clearChildren(parent: Instance)
	for _, child in parent:GetChildren() do
		child:Destroy()
	end
end

local function createMarkerPart(
	parent: Instance,
	name: string,
	position: Vector3,
	size: Vector3,
	color: Color3,
	transparency: number
): Part
	local part = Instance.new("Part")
	part.Name = name
	part.Anchored = true
	part.CanCollide = false
	part.Color = color
	part.Material = Enum.Material.Neon
	part.Size = size
	part.Transparency = transparency
	part.CFrame = CFrame.lookAt(position, Vector3.new(0, position.Y, 0))
	part.Parent = parent

	return part
end

local function getGeneratedFolder(): Folder
	local arena = getOrCreateFolder(Workspace, ARENA_FOLDER_NAME)
	return getOrCreateFolder(arena, GENERATED_FOLDER_NAME)
end

local function buildRing(generatedFolder: Folder)
	local ringFolder = getOrCreateFolder(generatedFolder, RING_FOLDER_NAME)
	clearChildren(ringFolder)

	for _, marker in ArenaVisuals.calculateRingMarkers(Tuning.CircleSpawnRadius) do
		createMarkerPart(
			ringFolder,
			`CircleBoundary_{string.format("%02d", marker.index)}`,
			Vector3.new(marker.x, marker.y, marker.z),
			Vector3.new(3.4, 1.4, 1.2),
			CYAN,
			0.08
		)
	end
end

local function buildRunMarkers(generatedFolder: Folder)
	local runFolder = getOrCreateFolder(generatedFolder, RUN_FOLDER_NAME)
	clearChildren(runFolder)

	for _, marker in ArenaVisuals.calculateRunMarkers(Tuning.CircleSpawnRadius) do
		createMarkerPart(
			runFolder,
			`RunAwayMarker_{string.format("%02d", marker.index)}`,
			Vector3.new(marker.x, marker.y, marker.z),
			Vector3.new(7, 0.8, 3),
			GOLD,
			0.18
		)
	end
end

local function createSlot(
	slotFolder: Folder,
	index: number,
	totalSlots: number,
	x: number,
	y: number,
	z: number
)
	local slot = createMarkerPart(
		slotFolder,
		`PlayerSlot_{string.format("%02d", index)}`,
		Vector3.new(x, y, z),
		Vector3.new(9, 0.7, 9),
		BLUE,
		0.12
	)

	slot:SetAttribute("SlotIndex", index)
	slot:SetAttribute("TotalSlots", totalSlots)
end

local function buildPreviewSlots(generatedFolder: Folder)
	local slotFolder = getOrCreateFolder(generatedFolder, SLOT_FOLDER_NAME)
	clearChildren(slotFolder)

	for _, slot in ArenaVisuals.calculatePreviewSlots(Tuning.CircleSpawnRadius) do
		createSlot(slotFolder, slot.slotIndex, slot.totalSlots, slot.x, slot.y, slot.z)
	end
end

local function buildRoundSlots(generatedFolder: Folder, placements: { any }?)
	if placements == nil or #placements == 0 then
		buildPreviewSlots(generatedFolder)
		return
	end

	local slotFolder = getOrCreateFolder(generatedFolder, SLOT_FOLDER_NAME)
	clearChildren(slotFolder)

	for index, placement in placements do
		createSlot(
			slotFolder,
			placement.slotIndex or index,
			placement.totalSlots,
			placement.x,
			ArenaVisuals.SlotHeight,
			placement.z
		)
	end
end

function ArenaVisualService.rebuildStaticArena()
	local generatedFolder = getGeneratedFolder()

	buildRing(generatedFolder)
	buildRunMarkers(generatedFolder)
	buildPreviewSlots(generatedFolder)
end

function ArenaVisualService.start()
	if started then
		return
	end

	started = true
	ArenaVisualService.rebuildStaticArena()
	buildRoundSlots(getGeneratedFolder(), RoundService.getSnapshot().spawnPlacements)

	snapshotConnection = RoundService.onSnapshotChanged(function(snapshot)
		buildRoundSlots(getGeneratedFolder(), snapshot.spawnPlacements)
	end)
end

function ArenaVisualService.stop()
	started = false

	if snapshotConnection then
		snapshotConnection:Disconnect()
		snapshotConnection = nil
	end
end

function ArenaVisualService.isStarted(): boolean
	return started
end

return table.freeze(ArenaVisualService)
