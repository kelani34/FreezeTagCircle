local RoundPrompts = require("../../src/shared/RoundPrompts")

return {
	{
		name = "shows waiting player count",
		run = function(expect)
			local prompt = RoundPrompts.getPrompt({
				state = "WaitingForPlayers",
				activePlayerCount = 1,
				minimumPlayers = 2,
			}, 100)

			expect.equal(prompt.title, "Waiting for players")
			expect.equal(prompt.body, "Need 1 more player(s) to start.")
		end,
	},
	{
		name = "shows caller-specific prompt",
		run = function(expect)
			local prompt = RoundPrompts.getPrompt({
				state = "CallerChoosing",
				callerUserId = 100,
			}, 100)

			expect.equal(prompt.title, "You are the caller")
		end,
	},
	{
		name = "shows called player run prompt",
		run = function(expect)
			local prompt = RoundPrompts.getPrompt({
				state = "RunAway",
				calledUserId = 100,
			}, 100)

			expect.equal(prompt.title, "Run to the center")
		end,
	},
	{
		name = "shows runner run-away prompt",
		run = function(expect)
			local prompt = RoundPrompts.getPrompt({
				state = "RunAway",
				calledUserId = 100,
			}, 200)

			expect.equal(prompt.title, "Run away")
		end,
	},
	{
		name = "shows stop prompt for frozen players",
		run = function(expect)
			local prompt = RoundPrompts.getPrompt({
				state = "StopFrozen",
				calledUserId = 100,
				jumpLimit = 3,
			}, 200)

			expect.equal(prompt.title, "STOP")
			expect.equal(prompt.body, "Freeze where you are.")
		end,
	},
	{
		name = "shows jump count during tag attempt",
		run = function(expect)
			local prompt = RoundPrompts.getPrompt({
				state = "TagAttempt",
				calledUserId = 100,
				jumpsRemaining = 2,
			}, 100)

			expect.equal(prompt.title, "Tag someone")
			expect.equal(prompt.detail, "2 jump(s) left.")
		end,
	},
	{
		name = "shows tagged result",
		run = function(expect)
			local prompt = RoundPrompts.getPrompt({
				state = "Resolve",
				tagSucceeded = true,
				taggedUserId = 200,
			}, 100)

			expect.equal(prompt.title, "Tagged")
		end,
	},
}
