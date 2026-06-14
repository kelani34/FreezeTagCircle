local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Shared = ReplicatedStorage:WaitForChild("Shared")
local Remotes = require(Shared.Remotes)
local RoundService = require(script.Parent.RoundService)

local RoundReplicationService = {}

local started = false
local playerAddedConnection: RBXScriptConnection? = nil
local snapshotConnection: RBXScriptConnection? = nil
local remoteFolder: Folder? = nil
local roundDebugStatus: StringValue? = nil
local roundStateChanged: RemoteEvent? = nil
local requestRoundSnapshot: RemoteFunction? = nil

local function getOrCreateChild(parent: Instance, className: string, name: string): Instance
	local existing = parent:FindFirstChild(name)

	if existing ~= nil then
		assert(existing.ClassName == className, `{name} must be a {className}`)

		return existing
	end

	local instance = Instance.new(className)
	instance.Name = name
	instance.Parent = parent

	return instance
end

local function ensureRemotes()
	remoteFolder = getOrCreateChild(ReplicatedStorage, "Folder", Remotes.FolderName) :: Folder
	roundStateChanged =
		getOrCreateChild(remoteFolder, "RemoteEvent", Remotes.RoundStateChanged) :: RemoteEvent
	roundDebugStatus =
		getOrCreateChild(remoteFolder, "StringValue", Remotes.RoundDebugStatus) :: StringValue
	requestRoundSnapshot = getOrCreateChild(
		remoteFolder,
		"RemoteFunction",
		Remotes.RequestRoundSnapshot
	) :: RemoteFunction
end

local function updateDebugStatus(snapshot: RoundService.RoundSnapshot?)
	ensureRemotes()

	local selectedSnapshot = snapshot or RoundService.getSnapshot()
	local status = roundDebugStatus :: StringValue
	status.Value =
		`Server {selectedSnapshot.state} | players {selectedSnapshot.activePlayerCount}/{selectedSnapshot.minimumPlayers} | round {selectedSnapshot.roundNumber}`
end

function RoundReplicationService.broadcastSnapshot(snapshot: RoundService.RoundSnapshot?)
	ensureRemotes()

	local selectedSnapshot = snapshot or RoundService.getSnapshot()
	updateDebugStatus(selectedSnapshot)

	local stateRemote = roundStateChanged :: RemoteEvent
	stateRemote:FireAllClients(selectedSnapshot)
end

function RoundReplicationService.sendSnapshot(player: Player, snapshot: RoundService.RoundSnapshot?)
	ensureRemotes()

	local selectedSnapshot = snapshot or RoundService.getSnapshot()
	updateDebugStatus(selectedSnapshot)

	local stateRemote = roundStateChanged :: RemoteEvent
	stateRemote:FireClient(player, selectedSnapshot)
end

function RoundReplicationService.start()
	if started then
		return
	end

	started = true
	ensureRemotes()

	local snapshotRemote = requestRoundSnapshot :: RemoteFunction
	snapshotRemote.OnServerInvoke = function()
		local snapshot = RoundService.refreshActivePlayerCount()
		updateDebugStatus(snapshot)

		return snapshot
	end

	snapshotConnection = RoundService.onSnapshotChanged(function(snapshot)
		RoundReplicationService.broadcastSnapshot(snapshot)
	end)

	playerAddedConnection = Players.PlayerAdded:Connect(function(player)
		task.defer(function()
			RoundReplicationService.sendSnapshot(player)
		end)
	end)

	local snapshot = RoundService.refreshActivePlayerCount()
	RoundReplicationService.broadcastSnapshot(snapshot)

	for _, player in Players:GetPlayers() do
		RoundReplicationService.sendSnapshot(player, snapshot)
	end

	task.spawn(function()
		while started do
			task.wait(1)

			if started then
				RoundReplicationService.broadcastSnapshot(RoundService.refreshActivePlayerCount())
			end
		end
	end)
end

function RoundReplicationService.stop()
	started = false

	if playerAddedConnection then
		playerAddedConnection:Disconnect()
		playerAddedConnection = nil
	end

	if snapshotConnection then
		snapshotConnection:Disconnect()
		snapshotConnection = nil
	end

	if requestRoundSnapshot then
		requestRoundSnapshot.OnServerInvoke = nil
	end
end

function RoundReplicationService.isStarted(): boolean
	return started
end

return table.freeze(RoundReplicationService)
