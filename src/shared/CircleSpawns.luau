export type SpawnSlot = {
	slotIndex: number,
	totalSlots: number,
	radius: number,
	x: number,
	y: number,
	z: number,
}

export type SpawnAssignment = {
	userId: number,
	slotIndex: number,
	totalSlots: number,
	radius: number,
	x: number,
	y: number,
	z: number,
}

local CircleSpawns = {}

local TAU = math.pi * 2

local function assertWholeNumber(value: number, name: string)
	assert(typeof(value) == "number" and value % 1 == 0, `{name} must be a whole number`)
end

local function assertRadius(radius: number)
	assert(typeof(radius) == "number" and radius > 0, "radius must be a positive number")
end

function CircleSpawns.calculateSlot(
	slotIndex: number,
	totalSlots: number,
	radius: number,
	y: number?
): SpawnSlot
	assertWholeNumber(slotIndex, "slotIndex")
	assertWholeNumber(totalSlots, "totalSlots")
	assert(totalSlots >= 1, "totalSlots must be at least 1")
	assert(slotIndex >= 1 and slotIndex <= totalSlots, "slotIndex must be within totalSlots")
	assertRadius(radius)

	local angle = ((slotIndex - 1) / totalSlots) * TAU

	return {
		slotIndex = slotIndex,
		totalSlots = totalSlots,
		radius = radius,
		x = math.sin(angle) * radius,
		y = y or 0,
		z = math.cos(angle) * radius,
	}
end

function CircleSpawns.calculateSlots(totalSlots: number, radius: number, y: number?): { SpawnSlot }
	assertWholeNumber(totalSlots, "totalSlots")
	assert(totalSlots >= 0, "totalSlots cannot be negative")
	assertRadius(radius)

	local slots = {}

	for slotIndex = 1, totalSlots do
		slots[slotIndex] = CircleSpawns.calculateSlot(slotIndex, totalSlots, radius, y)
	end

	return slots
end

function CircleSpawns.assignSlotsToUserIds(
	userIds: { number },
	radius: number,
	y: number?
): { SpawnAssignment }
	assertRadius(radius)

	local sortedUserIds = table.clone(userIds)

	for _, userId in sortedUserIds do
		assertWholeNumber(userId, "userId")
	end

	table.sort(sortedUserIds, function(leftUserId, rightUserId)
		return leftUserId < rightUserId
	end)

	local slots = CircleSpawns.calculateSlots(#sortedUserIds, radius, y)
	local assignments = {}

	for index, userId in sortedUserIds do
		local slot = slots[index]

		assignments[index] = {
			userId = userId,
			slotIndex = slot.slotIndex,
			totalSlots = slot.totalSlots,
			radius = slot.radius,
			x = slot.x,
			y = slot.y,
			z = slot.z,
		}
	end

	return assignments
end

return table.freeze(CircleSpawns)
