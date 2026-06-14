local ArenaVisuals = require("../../src/shared/ArenaVisuals")
local Tuning = require("../../src/shared/Tuning")

return {
	{
		name = "builds a dense circular playground boundary",
		run = function(expect)
			local markers = ArenaVisuals.calculateRingMarkers(Tuning.CircleSpawnRadius)
			local boundaryRadius = ArenaVisuals.getBoundaryRadius(Tuning.CircleSpawnRadius)

			expect.equal(#markers, ArenaVisuals.RingMarkerCount)
			expect.truthy(ArenaVisuals.RingMarkerCount >= 32)
			expect.equal(markers[1].radius, boundaryRadius)
			expect.near(markers[1].x, 0)
			expect.near(markers[1].z, boundaryRadius)
			expect.truthy(boundaryRadius > Tuning.CircleSpawnRadius)
		end,
	},
	{
		name = "builds run markers outside the playground circle",
		run = function(expect)
			local markers = ArenaVisuals.calculateRunMarkers(Tuning.CircleSpawnRadius)

			expect.equal(#markers, ArenaVisuals.RunMarkerCount)
			expect.truthy(
				ArenaVisuals.getRunMarkerRadius(Tuning.CircleSpawnRadius)
					> ArenaVisuals.getBoundaryRadius(Tuning.CircleSpawnRadius)
			)
		end,
	},
	{
		name = "aligns preview slots with gameplay spawn radius",
		run = function(expect)
			local slots = ArenaVisuals.calculatePreviewSlots(Tuning.CircleSpawnRadius)

			expect.equal(#slots, ArenaVisuals.PreviewSlotCount)
			expect.equal(slots[1].radius, Tuning.CircleSpawnRadius)
			expect.near(slots[1].x, 0)
			expect.near(slots[1].z, Tuning.CircleSpawnRadius)
		end,
	},
	{
		name = "rejects invalid marker layouts",
		run = function(expect)
			expect.errors(function()
				ArenaVisuals.calculateMarkers(
					0,
					ArenaVisuals.getBoundaryRadius(Tuning.CircleSpawnRadius),
					1
				)
			end)

			expect.errors(function()
				ArenaVisuals.calculateMarkers(8, 0, 1)
			end)
		end,
	},
}
