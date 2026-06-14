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
		name = "round debug status value is included",
		pattern = '<string name="Name">RoundDebugStatus</string>',
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
		name = "circle boundary is included",
		pattern = '<string name="Name">BoundaryNorth</string>',
	},
	{
		name = "circle marker ring is included",
		pattern = '<string name="Name">CircleMarkerNorthEast</string>',
	},
	{
		name = "spawn start pads are included",
		pattern = '<string name="Name">StartPadNorthEast</string>',
	},
	{
		name = "outer run markers are included",
		pattern = '<string name="Name">RunMarkerNorth</string>',
	},
	{
		name = "server entry is a Script",
		pattern = '<Item class="Script"',
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
