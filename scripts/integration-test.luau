local process = require("@lune/process")

local placePath = "build/FreezeTagCircle.integration.rbxlx"
local scriptPath = "tests/roblox/integration-smoke.luau"

local function execTool(command: string, args: { string })
	local ok, result = pcall(process.exec, command, args)

	if ok and result.ok then
		return result
	end

	local rokitBin = `{process.env.HOME}/.rokit/bin/{command}`
	return process.exec(rokitBin, args)
end

local function run(command: string, args: { string })
	local result = execTool(command, args)

	if not result.ok then
		if result.stdout ~= "" then
			print(result.stdout)
		end

		if result.stderr ~= "" then
			warn(result.stderr)
		end

		error(`Command failed: {command}`)
	end

	if result.stdout ~= "" then
		print(result.stdout)
	end
end

run("mkdir", { "-p", "build" })
run("rojo", { "build", "default.project.json", "-o", placePath })
run("run-in-roblox", { "--place", placePath, "--script", scriptPath })
