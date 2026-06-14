local CallerSelection = require("../../src/shared/CallerSelection")

return {
	{
		name = "returns nil when no users are active",
		run = function(expect)
			expect.equal(CallerSelection.selectCallerUserId({}, 1), nil)
		end,
	},
	{
		name = "selects callers from sorted user ids",
		run = function(expect)
			expect.equal(CallerSelection.selectCallerUserId({ 30, 10, 20 }, 1), 10)
			expect.equal(CallerSelection.selectCallerUserId({ 30, 10, 20 }, 2), 20)
			expect.equal(CallerSelection.selectCallerUserId({ 30, 10, 20 }, 3), 30)
		end,
	},
	{
		name = "wraps caller rotation across rounds",
		run = function(expect)
			expect.equal(CallerSelection.selectCallerUserId({ 20, 10 }, 1), 10)
			expect.equal(CallerSelection.selectCallerUserId({ 20, 10 }, 2), 20)
			expect.equal(CallerSelection.selectCallerUserId({ 20, 10 }, 3), 10)
		end,
	},
	{
		name = "does not mutate caller-owned user id lists",
		run = function(expect)
			local userIds = { 30, 10, 20 }

			CallerSelection.selectCallerUserId(userIds, 1)

			expect.sequence(userIds, { 30, 10, 20 })
		end,
	},
	{
		name = "checks active caller membership",
		run = function(expect)
			expect.truthy(CallerSelection.isUserIdActive({ 10, 20 }, 20))
			expect.falsy(CallerSelection.isUserIdActive({ 10, 20 }, 30))
			expect.falsy(CallerSelection.isUserIdActive({ 10, 20 }, nil))
		end,
	},
	{
		name = "rejects invalid round numbers",
		run = function(expect)
			expect.errors(function()
				CallerSelection.selectCallerUserId({ 10, 20 }, 0)
			end)
		end,
	},
}
