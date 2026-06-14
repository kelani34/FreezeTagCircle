local FeedbackTuning = {
	FrozenEffectName = "FreezeTagCircleFrozenEffect",
	ClientEffectsFolderName = "FreezeTagCircleClientEffects",
	StopSoundId = "rbxassetid://9118823101",
	StopSoundVolume = 0.42,
	StopSoundPlaybackSpeed = 0.92,
	StopOverlayFlashTransparency = 0.3,
	StopOverlayHoldSeconds = 0.9,
	StopOverlayFadeSeconds = 0.45,
	StopPulseSegmentCount = 28,
	StopPulseStartRadius = 12,
	StopPulseEndRadius = 68,
	StopPulseHeight = 0.45,
	StopPulseSeconds = 0.7,
	StopPulseColorRgb = { 255, 58, 48 },
	StopTextColorRgb = { 255, 244, 82 },
	FrozenIceColorRgb = { 145, 226, 255 },
	FrozenHighlightFillColorRgb = { 127, 225, 255 },
	FrozenHighlightOutlineColorRgb = { 235, 252, 255 },
	FrozenShardCount = 6,
}

return table.freeze(FeedbackTuning)
