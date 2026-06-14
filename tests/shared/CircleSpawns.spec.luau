local CircleSpawns = require("../../src/shared/CircleSpawns")

local RADIUS = 48
local HEIGHT = 4

return {
	{
		name = "calculates cardinal slots around the circle",
		run = function(expect)
			local slots = CircleSpawns.calculateSlots(4, RADIUS, HEIGHT)

			expect.equal(#slots, 4)
			expect.near(slots[1].x, 0)
			expect.near(slots[1].y, HEIGHT)
			expect.near(slots[1].z, RADIUS)
			expect.near(slots[2].x, RADIUS)
			expect.near(slots[2].z, 0)
			expect.near(slots[3].x, 0)
			expect.near(slots[3].z, -RADIUS)
			expect.near(slots[4].x, -RADIUS)
			expect.near(slots[4].z, 0)
		end,
	},
	{
		name = "assigns user ids in deterministic order",
		run = function(expect)
			local assignments = CircleSpawns.assignSlotsToUserIds({ 30, 10, 20 }, RADIUS, HEIGHT)

			expect.equal(#assignments, 3)
			expect.equal(assignments[1].userId, 10)
			expect.equal(assignments[1].slotIndex, 1)
			expect.equal(assignments[2].userId, 20)
			expect.equal(assignments[2].slotIndex, 2)
			expect.equal(assignments[3].userId, 30)
			expect.equal(assignments[3].slotIndex, 3)
		end,
	},
	{
		name = "does not mutate caller-owned user id lists",
		run = function(expect)
			local userIds = { 30, 10, 20 }

			CircleSpawns.assignSlotsToUserIds(userIds, RADIUS, HEIGHT)

			expect.sequence(userIds, { 30, 10, 20 })
		end,
	},
	{
		name = "returns no assignments for no users",
		run = function(expect)
			expect.equal(#CircleSpawns.assignSlotsToUserIds({}, RADIUS, HEIGHT), 0)
		end,
	},
	{
		name = "rejects invalid slot input",
		run = function(expect)
			expect.errors(function()
				CircleSpawns.calculateSlot(0, 4, RADIUS, HEIGHT)
			end)

			expect.errors(function()
				CircleSpawns.calculateSlot(1, 0, RADIUS, HEIGHT)
			end)

			expect.errors(function()
				CircleSpawns.calculateSlot(1, 4, 0, HEIGHT)
			end)
		end,
	},
}
