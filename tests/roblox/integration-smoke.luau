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
local CenterZone = require(shared:WaitForChild("CenterZone", 5))
local CircleSpawns = require(shared:WaitForChild("CircleSpawns", 5))
local GameStates = require(shared:WaitForChild("GameStates", 5))
local JumpTracker = require(server:WaitForChild("JumpTracker", 5))
local MovementControlService = require(server:WaitForChild("MovementControlService", 5))
local Remotes = require(shared:WaitForChild("Remotes", 5))
local RoundService = require(server:WaitForChild("RoundService", 5))
local TagService = require(server:WaitForChild("TagService", 5))
local TargetSelection = require(server:WaitForChild("TargetSelection", 5))
local Tuning = require(shared:WaitForChild("Tuning", 5))

assertEqual(GameStates.DefaultRoundState, GameStates.RoundStates.WaitingForPlayers, "Default state")
assertEqual(Remotes.FolderName, "FreezeTagCircleRemotes", "Remote folder name")
assertEqual(Tuning.TagJumpLimit, 3, "Jump limit")
assertEqual(Tuning.TagRadius > 0, true, "Tag radius")
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
assertEqual(CenterZone.isWithinRadius(0, 0, Tuning.CenterZoneRadius), true, "Center zone origin")
assertEqual(ArenaService.isPositionInCenterZone(Vector3.new(0, 0, 0)), true, "Arena center zone")
assertEqual(JumpTracker.getRemainingJumps(1, Tuning.TagJumpLimit), 2, "Remaining jumps")
assertEqual(#MovementControlService.getFrozenUserIds(), 0, "No frozen users at smoke start")

local tagValidation = TagService.validate({
	isTagAttempt = true,
	isExpired = false,
	activeUserIds = { 100, 200 },
	frozenUserIds = { 200 },
	calledUserId = 100,
	requestingUserId = 100,
	targetUserId = 200,
	distance = Tuning.TagRadius,
	tagRadius = Tuning.TagRadius,
})
assertEqual(tagValidation.accepted, true, "Valid tag selection")

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
assertEqual(#snapshot.frozenUserIds, 0, "Waiting state has no frozen users")
assertEqual(snapshot.jumpsRemaining, Tuning.TagJumpLimit, "Waiting state has full jump budget")
assertEqual(RoundService.canTransitionTo(GameStates.RoundStates.Setup), false, "Setup gate")

RoundService.stop()

print("Roblox integration smoke test passed")
