local CenterZone = require("../../src/shared/CenterZone")

return {
	{
		name = "calculates horizontal distance from center",
		run = function(expect)
			expect.near(CenterZone.getHorizontalDistance(3, 4), 5)
		end,
	},
	{
		name = "accepts positions inside or on the center radius",
		run = function(expect)
			expect.truthy(CenterZone.isWithinRadius(0, 0, 8))
			expect.truthy(CenterZone.isWithinRadius(6, 8, 10))
		end,
	},
	{
		name = "rejects positions outside the center radius",
		run = function(expect)
			expect.falsy(CenterZone.isWithinRadius(9, 0, 8))
		end,
	},
	{
		name = "rejects invalid radius",
		run = function(expect)
			expect.errors(function()
				CenterZone.isWithinRadius(0, 0, -1)
			end)
		end,
	},
}
