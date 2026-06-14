local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local function assertEqual(actual, expected, message)
	assert(actual == expected, `{message}: expected {tostring(expected)}, got {tostring(actual)}`)
end

local shared = ReplicatedStorage:WaitForChild("Shared", 5)
assert(shared, "ReplicatedStorage.Shared should exist")

local server = ServerScriptService:WaitForChild("Server", 5)
assert(server, "ServerScriptService.Server should exist")

local ArenaService = require(server:WaitForChild("ArenaService", 5))
local CallerSelection = require(shared:WaitForChild("CallerSelection", 5))
local CircleSpawns = require(shared:WaitForChild("CircleSpawns", 5))
local GameStates = require(shared:WaitForChild("GameStates", 5))
local Remotes = require(shared:WaitForChild("Remotes", 5))
local RoundService = require(server:WaitForChild("RoundService", 5))
local TargetSelection = require(server:WaitForChild("TargetSelection", 5))
local Tuning = require(shared:WaitForChild("Tuning", 5))

assertEqual(GameStates.DefaultRoundState, GameStates.RoundStates.WaitingForPlayers, "Default state")
assertEqual(Remotes.FolderName, "FreezeTagCircleRemotes", "Remote folder name")
assertEqual(Tuning.TagJumpLimit, 3, "Jump limit")
assertEqual(
	Tuning.CircleSpawnRadius > Tuning.CenterZoneRadius,
	true,
	"Spawn radius surrounds center"
)

local slots = ArenaService.calculateSpawnSlotsForCount(4)
assertEqual(#slots, 4, "Arena spawn slot count")
assertEqual(slots[1].radius, Tuning.CircleSpawnRadius, "Arena spawn slot radius")

local assignments = CircleSpawns.assignSlotsToUserIds(
	{ 200, 100 },
	Tuning.CircleSpawnRadius,
	Tuning.CircleSpawnHeight
)
assertEqual(assignments[1].userId, 100, "Deterministic spawn assignment")
assertEqual(CallerSelection.selectCallerUserId({ 200, 100 }, 1), 100, "Deterministic caller")

local targetValidation = TargetSelection.validate({
	isCallerChoosing = true,
	activeUserIds = { 100, 200 },
	callerUserId = 100,
	requestingUserId = 100,
	targetUserId = 200,
	currentTargetUserId = nil,
})
assertEqual(targetValidation.accepted, true, "Valid target selection")

RoundService.start()

local snapshot = RoundService.getSnapshot()

assertEqual(snapshot.state, GameStates.RoundStates.WaitingForPlayers, "RoundService start state")
assertEqual(snapshot.minimumPlayers, Tuning.MinimumPlayers, "Snapshot minimum player count")
assertEqual(snapshot.hasMinimumPlayers, false, "Empty Studio test place should not meet minimum")
assertEqual(#snapshot.spawnPlacements, 0, "Waiting state has no spawn placements")
assertEqual(RoundService.canTransitionTo(GameStates.RoundStates.Setup), false, "Setup gate")

RoundService.stop()

print("Roblox integration smoke test passed")
