local GameStates = require("../../src/shared/GameStates")

return {
	{
		name = "defaults to waiting for players",
		run = function(expect)
			expect.equal(GameStates.DefaultRoundState, GameStates.RoundStates.WaitingForPlayers)
		end,
	},
	{
		name = "keeps the canonical round order",
		run = function(expect)
			expect.sequence(GameStates.OrderedRoundStates, {
				GameStates.RoundStates.WaitingForPlayers,
				GameStates.RoundStates.Setup,
				GameStates.RoundStates.CallerChoosing,
				GameStates.RoundStates.RunAway,
				GameStates.RoundStates.StopFrozen,
				GameStates.RoundStates.TagAttempt,
				GameStates.RoundStates.Resolve,
				GameStates.RoundStates.Reset,
			})
		end,
	},
	{
		name = "validates known and unknown round states",
		run = function(expect)
			expect.truthy(GameStates.isRoundState("RunAway"))
			expect.falsy(GameStates.isRoundState("Lobby"))
			expect.falsy(GameStates.isRoundState(123))
		end,
	},
	{
		name = "returns the next round state",
		run = function(expect)
			expect.equal(
				GameStates.getNextRoundState(GameStates.RoundStates.WaitingForPlayers),
				GameStates.RoundStates.Setup
			)
			expect.equal(GameStates.getNextRoundState(GameStates.RoundStates.Reset), nil)
		end,
	},
	{
		name = "chooses post-reset setup when enough players remain",
		run = function(expect)
			for _ = 1, 3 do
				expect.equal(GameStates.getPostResetState(2, 2), GameStates.RoundStates.Setup)
			end
		end,
	},
	{
		name = "chooses post-reset waiting when too few players remain",
		run = function(expect)
			expect.equal(
				GameStates.getPostResetState(1, 2),
				GameStates.RoundStates.WaitingForPlayers
			)
		end,
	},
	{
		name = "rejects invalid post-reset counts",
		run = function(expect)
			expect.errors(function()
				GameStates.getPostResetState(-1, 2)
			end)

			expect.errors(function()
				GameStates.getPostResetState(2, 0)
			end)
		end,
	},
	{
		name = "falls back to waiting from every active state below minimum players",
		run = function(expect)
			for _, state in GameStates.OrderedRoundStates do
				local shouldFallback = GameStates.shouldFallbackToWaiting(state, 1, 2)

				if state == GameStates.RoundStates.WaitingForPlayers then
					expect.falsy(shouldFallback)
				else
					expect.truthy(shouldFallback)
				end
			end
		end,
	},
	{
		name = "does not fall back when enough players remain",
		run = function(expect)
			for _, state in GameStates.OrderedRoundStates do
				expect.falsy(GameStates.shouldFallbackToWaiting(state, 2, 2))
			end
		end,
	},
}
