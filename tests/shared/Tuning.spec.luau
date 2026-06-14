local Tuning = require("../../src/shared/Tuning")

return {
	{
		name = "requires at least two players",
		run = function(expect)
			expect.truthy(Tuning.MinimumPlayers >= 2)
		end,
	},
	{
		name = "preserves the three-jump rule",
		run = function(expect)
			expect.equal(Tuning.TagJumpLimit, 3)
		end,
	},
	{
		name = "uses a positive tag radius",
		run = function(expect)
			expect.truthy(Tuning.TagRadius > 0)
			expect.truthy(Tuning.TagRadius < Tuning.CircleSpawnRadius)
		end,
	},
	{
		name = "uses positive phase durations",
		run = function(expect)
			expect.truthy(Tuning.IntermissionSeconds > 0)
			expect.truthy(Tuning.CallerChooseSeconds > 0)
			expect.truthy(Tuning.RunAwaySeconds > 0)
			expect.truthy(Tuning.StopFrozenSeconds > 0)
			expect.truthy(Tuning.TagAttemptSeconds > 0)
			expect.truthy(Tuning.ResolveSeconds > 0)
		end,
	},
	{
		name = "uses playable arena measurements",
		run = function(expect)
			expect.truthy(Tuning.CircleSpawnRadius > 0)
			expect.truthy(Tuning.CenterZoneRadius > 0)
			expect.truthy(Tuning.CircleSpawnHeight > 0)
			expect.truthy(Tuning.CircleSpawnRadius > Tuning.CenterZoneRadius)
		end,
	},
}
