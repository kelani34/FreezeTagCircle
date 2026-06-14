local CallerSelection = {}

local function assertWholeNumber(value: number, name: string)
	assert(typeof(value) == "number" and value % 1 == 0, `{name} must be a whole number`)
end

local function getSortedUserIds(userIds: { number }): { number }
	local sortedUserIds = table.clone(userIds)

	for _, userId in sortedUserIds do
		assertWholeNumber(userId, "userId")
	end

	table.sort(sortedUserIds, function(leftUserId, rightUserId)
		return leftUserId < rightUserId
	end)

	return sortedUserIds
end

function CallerSelection.selectCallerUserId(userIds: { number }, roundNumber: number): number?
	assertWholeNumber(roundNumber, "roundNumber")
	assert(roundNumber >= 1, "roundNumber must be at least 1")

	local sortedUserIds = getSortedUserIds(userIds)

	if #sortedUserIds == 0 then
		return nil
	end

	local callerIndex = ((roundNumber - 1) % #sortedUserIds) + 1

	return sortedUserIds[callerIndex]
end

function CallerSelection.isUserIdActive(userIds: { number }, userId: number?): boolean
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

return table.freeze(CallerSelection)
