local JumpTracker = require("../../src/server/JumpTracker")

return {
	{
		name = "accepts called player jump during tag attempt",
		run = function(expect)
			local result = JumpTracker.recordJump({
				calledUserId = 100,
				jumpsUsed = 0,
				jumpLimit = 3,
				isTagAttempt = true,
			}, 100)

			expect.truthy(result.accepted)
			expect.equal(result.jumpsUsed, 1)
			expect.equal(result.jumpsRemaining, 2)
		end,
	},
	{
		name = "rejects jumps outside tag attempt",
		run = function(expect)
			local result = JumpTracker.recordJump({
				calledUserId = 100,
				jumpsUsed = 0,
				jumpLimit = 3,
				isTagAttempt = false,
			}, 100)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "NotTagAttempt")
			expect.equal(result.jumpsUsed, 0)
			expect.equal(result.jumpsRemaining, 3)
		end,
	},
	{
		name = "rejects non-called player jumps",
		run = function(expect)
			local result = JumpTracker.recordJump({
				calledUserId = 100,
				jumpsUsed = 0,
				jumpLimit = 3,
				isTagAttempt = true,
			}, 200)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "RequesterNotCalled")
			expect.equal(result.jumpsUsed, 0)
			expect.equal(result.jumpsRemaining, 3)
		end,
	},
	{
		name = "rejects after jump limit is reached",
		run = function(expect)
			local result = JumpTracker.recordJump({
				calledUserId = 100,
				jumpsUsed = 3,
				jumpLimit = 3,
				isTagAttempt = true,
			}, 100)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "JumpLimitReached")
			expect.equal(result.jumpsUsed, 3)
			expect.equal(result.jumpsRemaining, 0)
		end,
	},
	{
		name = "remaining jump count never goes negative",
		run = function(expect)
			expect.equal(JumpTracker.getRemainingJumps(4, 3), 0)
		end,
	},
}
