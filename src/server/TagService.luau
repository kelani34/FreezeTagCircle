export type FailureReason =
	"NotTagAttempt"
	| "TagAttemptExpired"
	| "MissingCalledPlayer"
	| "RequesterNotCalled"
	| "InvalidTarget"
	| "TargetNotActive"
	| "TargetNotFrozen"
	| "CannotTagSelf"
	| "MissingDistance"
	| "OutsideTagRadius"

export type ValidationOptions = {
	isTagAttempt: boolean,
	isExpired: boolean,
	activeUserIds: { number },
	frozenUserIds: { number },
	calledUserId: number?,
	requestingUserId: unknown,
	targetUserId: unknown,
	distance: number?,
	tagRadius: number,
}

export type ValidationResult = {
	accepted: boolean,
	reason: FailureReason?,
	targetUserId: number?,
	distance: number?,
}

local TagService = {}

local function isWholeNumber(value: unknown): boolean
	return typeof(value) == "number" and value % 1 == 0
end

local function isUserIdIn(userIds: { number }, userId: number?): boolean
	if userId == nil then
		return false
	end

	for _, activeUserId in userIds do
		if activeUserId == userId then
			return true
		end
	end

	return false
end

local function reject(
	reason: FailureReason,
	distance: number?,
	targetUserId: number?
): ValidationResult
	return {
		accepted = false,
		reason = reason,
		targetUserId = targetUserId,
		distance = distance,
	}
end

function TagService.validate(options: ValidationOptions): ValidationResult
	if not options.isTagAttempt then
		return reject("NotTagAttempt", options.distance, nil)
	end

	if options.isExpired then
		return reject("TagAttemptExpired", options.distance, nil)
	end

	if not isWholeNumber(options.calledUserId) then
		return reject("MissingCalledPlayer", options.distance, nil)
	end

	local calledUserId = options.calledUserId :: number

	if not isUserIdIn(options.activeUserIds, calledUserId) then
		return reject("MissingCalledPlayer", options.distance, nil)
	end

	if options.requestingUserId ~= calledUserId then
		return reject("RequesterNotCalled", options.distance, nil)
	end

	if not isWholeNumber(options.targetUserId) then
		return reject("InvalidTarget", options.distance, nil)
	end

	local targetUserId = options.targetUserId :: number

	if targetUserId == calledUserId then
		return reject("CannotTagSelf", options.distance, targetUserId)
	end

	if not isUserIdIn(options.activeUserIds, targetUserId) then
		return reject("TargetNotActive", options.distance, targetUserId)
	end

	if not isUserIdIn(options.frozenUserIds, targetUserId) then
		return reject("TargetNotFrozen", options.distance, targetUserId)
	end

	if options.distance == nil then
		return reject("MissingDistance", nil, targetUserId)
	end

	if options.distance > options.tagRadius then
		return reject("OutsideTagRadius", options.distance, targetUserId)
	end

	return {
		accepted = true,
		reason = nil,
		targetUserId = targetUserId,
		distance = options.distance,
	}
end

return table.freeze(TagService)
