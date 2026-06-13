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
}
