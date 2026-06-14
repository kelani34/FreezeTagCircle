local fs = require("@lune/fs")
local process = require("@lune/process")

local buildPath = process.args[1] or "build/FreezeTagCircle.rbxlx"

assert(fs.isFile(buildPath), `Build file does not exist: {buildPath}`)

local contents = fs.readFile(buildPath)

local checks = {
	{
		name = "client entry requires child RoundHud module",
		pattern = 'require(script:WaitForChild("RoundHud"))',
	},
	{
		name = "client entry is a LocalScript",
		pattern = '<Item class="LocalScript"',
	},
	{
		name = "RoundHud module is included",
		pattern = '<string name="Name">RoundHud</string>',
	},
	{
		name = "remotes folder is included",
		pattern = '<string name="Name">FreezeTagCircleRemotes</string>',
	},
	{
		name = "snapshot request remote function is included",
		pattern = '<Item class="RemoteFunction"',
	},
	{
		name = "stop feedback remote event is included",
		pattern = '<string name="Name">StopFeedback</string>',
	},
	{
		name = "round debug status value is included",
		pattern = '<string name="Name">RoundDebugStatus</string>',
	},
	{
		name = "ArenaVisuals shared module is included",
		pattern = '<string name="Name">ArenaVisuals</string>',
	},
	{
		name = "readable arena folder is included",
		pattern = '<string name="Name">Arena</string>',
	},
	{
		name = "readable arena floor is included",
		pattern = '<string name="Name">ArenaFloor</string>',
	},
	{
		name = "center stop pad is included",
		pattern = '<string name="Name">CenterStopPad</string>',
	},
	{
		name = "waiting room lobby is included",
		pattern = '<string name="Name">Lobby</string>',
	},
	{
		name = "waiting room spawn pad is included",
		pattern = '<string name="Name">LobbySpawnPad</string>',
	},
	{
		name = "generated circular arena folder is included",
		pattern = '<string name="Name">GeneratedCircleArena</string>',
	},
	{
		name = "generated circle boundary folder is included",
		pattern = '<string name="Name">CircleBoundary</string>',
	},
	{
		name = "generated player slots folder is included",
		pattern = '<string name="Name">PlayerCircleSlots</string>',
	},
	{
		name = "generated run-away markers folder is included",
		pattern = '<string name="Name">RunAwayMarkers</string>',
	},
	{
		name = "server entry is a Script",
		pattern = '<Item class="Script"',
	},
	{
		name = "ArenaVisualService module is included",
		pattern = '<string name="Name">ArenaVisualService</string>',
	},
	{
		name = "server entry starts arena visuals",
		pattern = "ArenaVisualService.start()",
	},
	{
		name = "server entry requires child RoundService module",
		pattern = 'require(script:WaitForChild("RoundService"))',
	},
}

for _, check in checks do
	assert(
		string.find(contents, check.pattern, 1, true) ~= nil,
		`Missing build inspection check: {check.name}`
	)
end

print(`Build inspection passed for {buildPath}`)
