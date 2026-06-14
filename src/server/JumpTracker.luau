local JumpTracker = {}

export type FailureReason =
	"NotTagAttempt"
	| "MissingCalledPlayer"
	| "RequesterNotCalled"
	| "JumpLimitReached"

export type JumpState = {
	calledUserId: number?,
	jumpsUsed: number,
	jumpLimit: number,
	isTagAttempt: boolean,
}

export type JumpResult = {
	accepted: boolean,
	reason: FailureReason?,
	jumpsUsed: number,
	jumpsRemaining: number,
}

function JumpTracker.getRemainingJumps(jumpsUsed: number, jumpLimit: number): number
	return math.max(jumpLimit - jumpsUsed, 0)
end

function JumpTracker.recordJump(state: JumpState, requestingUserId: unknown): JumpResult
	local jumpsRemaining = JumpTracker.getRemainingJumps(state.jumpsUsed, state.jumpLimit)

	if not state.isTagAttempt then
		return {
			accepted = false,
			reason = "NotTagAttempt",
			jumpsUsed = state.jumpsUsed,
			jumpsRemaining = jumpsRemaining,
		}
	end

	if state.calledUserId == nil then
		return {
			accepted = false,
			reason = "MissingCalledPlayer",
			jumpsUsed = state.jumpsUsed,
			jumpsRemaining = jumpsRemaining,
		}
	end

	if requestingUserId ~= state.calledUserId then
		return {
			accepted = false,
			reason = "RequesterNotCalled",
			jumpsUsed = state.jumpsUsed,
			jumpsRemaining = jumpsRemaining,
		}
	end

	if jumpsRemaining <= 0 then
		return {
			accepted = false,
			reason = "JumpLimitReached",
			jumpsUsed = state.jumpsUsed,
			jumpsRemaining = 0,
		}
	end

	local nextJumpsUsed = state.jumpsUsed + 1

	return {
		accepted = true,
		reason = nil,
		jumpsUsed = nextJumpsUsed,
		jumpsRemaining = JumpTracker.getRemainingJumps(nextJumpsUsed, state.jumpLimit),
	}
end

return table.freeze(JumpTracker)
