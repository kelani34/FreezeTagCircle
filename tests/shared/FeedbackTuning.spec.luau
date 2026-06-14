local FeedbackTuning = require("../../src/shared/FeedbackTuning")

local function assertRgbTriplet(expect, rgb: { number }, name: string)
	expect.equal(#rgb, 3, `{name} should be an RGB triplet`)

	for _, channel in rgb do
		expect.truthy(channel >= 0 and channel <= 255, `{name} channel should be 0-255`)
	end
end

return {
	{
		name = "centralizes named feedback assets and instances",
		run = function(expect)
			expect.equal(FeedbackTuning.FrozenEffectName, "FreezeTagCircleFrozenEffect")
			expect.equal(FeedbackTuning.ClientEffectsFolderName, "FreezeTagCircleClientEffects")
			expect.truthy(string.find(FeedbackTuning.StopSoundId, "rbxasset", 1, true) ~= nil)
		end,
	},
	{
		name = "keeps STOP pulse timings and radii visible",
		run = function(expect)
			expect.truthy(FeedbackTuning.StopPulseSegmentCount >= 24)
			expect.truthy(FeedbackTuning.StopPulseEndRadius > FeedbackTuning.StopPulseStartRadius)
			expect.truthy(FeedbackTuning.StopPulseSeconds > 0)
			expect.truthy(FeedbackTuning.StopOverlayHoldSeconds > 0)
			expect.truthy(FeedbackTuning.StopOverlayFadeSeconds > 0)
		end,
	},
	{
		name = "uses plain RGB data for headless test compatibility",
		run = function(expect)
			assertRgbTriplet(expect, FeedbackTuning.StopPulseColorRgb, "StopPulseColorRgb")
			assertRgbTriplet(expect, FeedbackTuning.StopTextColorRgb, "StopTextColorRgb")
			assertRgbTriplet(expect, FeedbackTuning.FrozenIceColorRgb, "FrozenIceColorRgb")
			assertRgbTriplet(
				expect,
				FeedbackTuning.FrozenHighlightFillColorRgb,
				"FrozenHighlightFillColorRgb"
			)
			assertRgbTriplet(
				expect,
				FeedbackTuning.FrozenHighlightOutlineColorRgb,
				"FrozenHighlightOutlineColorRgb"
			)
		end,
	},
}
