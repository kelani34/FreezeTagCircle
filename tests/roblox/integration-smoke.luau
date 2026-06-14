local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")

local function assertEqual(actual, expected, message)
	assert(actual == expected, `{message}: expected {tostring(expected)}, got {tostring(actual)}`)
end

local shared = ReplicatedStorage:WaitForChild("Shared", 5)
assert(shared, "ReplicatedStorage.Shared should exist")

local server = ServerScriptService:WaitForChild("Server", 5)
assert(server, "ServerScriptService.Server should exist")

local GameStates = require(shared:WaitForChild("GameStates", 5))
local Remotes = require(shared:WaitForChild("Remotes", 5))
local RoundService = require(server:WaitForChild("RoundService", 5))
local Tuning = require(shared:WaitForChild("Tuning", 5))

assertEqual(GameStates.DefaultRoundState, GameStates.RoundStates.WaitingForPlayers, "Default state")
assertEqual(Remotes.FolderName, "FreezeTagCircleRemotes", "Remote folder name")
assertEqual(Tuning.TagJumpLimit, 3, "Jump limit")

RoundService.start()

local snapshot = RoundService.getSnapshot()

assertEqual(snapshot.state, GameStates.RoundStates.WaitingForPlayers, "RoundService start state")
assertEqual(snapshot.minimumPlayers, Tuning.MinimumPlayers, "Snapshot minimum player count")
assertEqual(snapshot.hasMinimumPlayers, false, "Empty Studio test place should not meet minimum")
assertEqual(RoundService.canTransitionTo(GameStates.RoundStates.Setup), false, "Setup gate")

RoundService.stop()

print("Roblox integration smoke test passed")
