export type FailureReason =
	"NotCallerChoosing"
	| "MissingCaller"
	| "RequesterNotCaller"
	| "InvalidTarget"
	| "TargetNotActive"
	| "CallerCannotTargetSelf"
	| "TargetAlreadySelected"

export type ValidationOptions = {
	isCallerChoosing: boolean,
	activeUserIds: { number },
	callerUserId: number?,
	requestingUserId: unknown,
	targetUserId: unknown,
	currentTargetUserId: number?,
}

export type ValidationResult = {
	accepted: boolean,
	reason: FailureReason?,
	targetUserId: number?,
}

local TargetSelection = {}

local function isWholeNumber(value: unknown): boolean
	return typeof(value) == "number" and value % 1 == 0
end

local function isActiveUserId(activeUserIds: { number }, userId: number?): boolean
	if userId == nil then
		return false
	end

	for _, activeUserId in activeUserIds do
		if activeUserId == userId then
			return true
		end
	end

	return false
end

local function reject(reason: FailureReason): ValidationResult
	return {
		accepted = false,
		reason = reason,
		targetUserId = nil,
	}
end

function TargetSelection.validate(options: ValidationOptions): ValidationResult
	if not options.isCallerChoosing then
		return reject("NotCallerChoosing")
	end

	if not isWholeNumber(options.callerUserId) then
		return reject("MissingCaller")
	end

	local callerUserId = options.callerUserId :: number

	if not isActiveUserId(options.activeUserIds, callerUserId) then
		return reject("MissingCaller")
	end

	if options.requestingUserId ~= callerUserId then
		return reject("RequesterNotCaller")
	end

	if options.currentTargetUserId ~= nil then
		return reject("TargetAlreadySelected")
	end

	if not isWholeNumber(options.targetUserId) then
		return reject("InvalidTarget")
	end

	local targetUserId = options.targetUserId :: number

	if targetUserId == callerUserId then
		return reject("CallerCannotTargetSelf")
	end

	if not isActiveUserId(options.activeUserIds, targetUserId) then
		return reject("TargetNotActive")
	end

	return {
		accepted = true,
		reason = nil,
		targetUserId = targetUserId,
	}
end

return table.freeze(TargetSelection)
