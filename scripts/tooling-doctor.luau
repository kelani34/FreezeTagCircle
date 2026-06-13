local process = require("@lune/process")

local tools = {
	{ command = "rojo", args = { "--version" } },
	{ command = "wally", args = { "--version" } },
	{ command = "selene", args = { "--version" } },
	{ command = "stylua", args = { "--version" } },
	{ command = "lune", args = { "--version" } },
	{ command = "run-in-roblox", args = { "--version" } },
}

local function execTool(command: string, args: { string })
	local ok, result = pcall(process.exec, command, args)

	if ok and result.ok then
		return result
	end

	local rokitBin = `{process.env.HOME}/.rokit/bin/{command}`
	return process.exec(rokitBin, args)
end

for _, tool in tools do
	local result = execTool(tool.command, tool.args)

	if not result.ok then
		error(`Required tool failed: {tool.command}`)
	end

	local output = string.gsub(result.stdout, "%s+$", "")
	print(output)
end
