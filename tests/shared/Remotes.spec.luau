local Remotes = require("../../src/shared/Remotes")

return {
	{
		name = "uses stable non-empty names",
		run = function(expect)
			for key, value in Remotes do
				expect.equal(typeof(key), "string")
				expect.equal(typeof(value), "string")
				expect.truthy(#value > 0, `Remote name must not be empty: {key}`)
			end
		end,
	},
	{
		name = "does not duplicate names",
		run = function(expect)
			local seen = {}

			for _, value in Remotes do
				expect.falsy(seen[value], `Duplicate remote name: {value}`)
				seen[value] = true
			end
		end,
	},
	{
		name = "includes runtime diagnostics value",
		run = function(expect)
			expect.equal(Remotes.RoundDebugStatus, "RoundDebugStatus")
		end,
	},
	{
		name = "includes server-triggered stop feedback event",
		run = function(expect)
			expect.equal(Remotes.StopFeedback, "StopFeedback")
		end,
	},
}
