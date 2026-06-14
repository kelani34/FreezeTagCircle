export type PromptSnapshot = {
	state: string,
	activePlayerCount: number?,
	minimumPlayers: number?,
	callerUserId: number?,
	calledUserId: number?,
	jumpsRemaining: number?,
	jumpLimit: number?,
	taggedUserId: number?,
	tagSucceeded: boolean?,
}

export type RoundPrompt = {
	title: string,
	body: string,
	detail: string,
}

local RoundPrompts = {}

local function getNeededPlayers(snapshot: PromptSnapshot): number
	local activePlayerCount = snapshot.activePlayerCount or 0
	local minimumPlayers = snapshot.minimumPlayers or 2

	return math.max(minimumPlayers - activePlayerCount, 0)
end

local function getUserLabel(userId: number?): string
	if userId == nil then
		return "another player"
	end

	return `Player {userId}`
end

function RoundPrompts.getPrompt(snapshot: PromptSnapshot, localUserId: number?): RoundPrompt
	if snapshot.state == "WaitingForPlayers" then
		local neededPlayers = getNeededPlayers(snapshot)

		return {
			title = "Waiting for players",
			body = if neededPlayers > 0
				then `Need {neededPlayers} more player(s) to start.`
				else "Round is ready to start.",
			detail = "Stay nearby. The next round will begin from the circle.",
		}
	end

	if snapshot.state == "Setup" then
		return {
			title = "Find your spot",
			body = "Players are being placed around the circle.",
			detail = "Face the center and get ready.",
		}
	end

	if snapshot.state == "CallerChoosing" then
		if localUserId ~= nil and snapshot.callerUserId == localUserId then
			return {
				title = "You are the caller",
				body = "Pick another player to send to the center.",
				detail = "Choose quickly so everyone can run.",
			}
		end

		return {
			title = "Caller is choosing",
			body = `{getUserLabel(snapshot.callerUserId)} is picking a target.`,
			detail = "Listen for your name.",
		}
	end

	if snapshot.state == "RunAway" then
		if localUserId ~= nil and snapshot.calledUserId == localUserId then
			return {
				title = "Run to the center",
				body = "Reach the center circle to shout STOP.",
				detail = "Everyone else is running away.",
			}
		end

		return {
			title = "Run away",
			body = `{getUserLabel(snapshot.calledUserId)} is heading to the center.`,
			detail = "Make distance before STOP.",
		}
	end

	if snapshot.state == "StopFrozen" then
		if localUserId ~= nil and snapshot.calledUserId == localUserId then
			return {
				title = "STOP",
				body = "Everyone is frozen. Get ready to jump.",
				detail = `You have {snapshot.jumpLimit or 3} jumps.`,
			}
		end

		return {
			title = "STOP",
			body = "Freeze where you are.",
			detail = "The called player is about to jump.",
		}
	end

	if snapshot.state == "TagAttempt" then
		if localUserId ~= nil and snapshot.calledUserId == localUserId then
			return {
				title = "Tag someone",
				body = "Use your jumps to reach a frozen player.",
				detail = `{snapshot.jumpsRemaining or 0} jump(s) left.`,
			}
		end

		return {
			title = "Stay frozen",
			body = `{getUserLabel(snapshot.calledUserId)} is trying to tag someone.`,
			detail = "Hold still until the round resolves.",
		}
	end

	if snapshot.state == "Resolve" then
		if snapshot.tagSucceeded and snapshot.taggedUserId ~= nil then
			return {
				title = "Tagged",
				body = `{getUserLabel(snapshot.taggedUserId)} was tagged.`,
				detail = "Next round is coming up.",
			}
		end

		return {
			title = "Round over",
			body = "No tag was recorded.",
			detail = "Resetting for the next round.",
		}
	end

	if snapshot.state == "Reset" then
		return {
			title = "Resetting",
			body = "The arena is getting ready again.",
			detail = "Stay in the game for the next round.",
		}
	end

	return {
		title = "FreezeTagCircle",
		body = "Waiting for round information.",
		detail = "Stay ready.",
	}
end

return table.freeze(RoundPrompts)
