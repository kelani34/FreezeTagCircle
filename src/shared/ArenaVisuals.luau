export type ArenaMarker = {
	index: number,
	total: number,
	radius: number,
	x: number,
	y: number,
	z: number,
	angle: number,
}

export type ArenaSlot = {
	slotIndex: number,
	totalSlots: number,
	radius: number,
	x: number,
	y: number,
	z: number,
}

local ArenaVisuals = {}

ArenaVisuals.RingMarkerCount = 48
ArenaVisuals.PreviewSlotCount = 8
ArenaVisuals.RunMarkerCount = 8
ArenaVisuals.BoundaryRadiusOffset = 16
ArenaVisuals.RunMarkerRadiusOffset = 32
ArenaVisuals.MarkerHeight = 1.1
ArenaVisuals.SlotHeight = 0.65

local TAU = math.pi * 2

local function assertWholeNumber(value: number, name: string)
	assert(typeof(value) == "number" and value % 1 == 0, `{name} must be a whole number`)
end

local function assertRadius(radius: number)
	assert(typeof(radius) == "number" and radius > 0, "radius must be a positive number")
end

function ArenaVisuals.getBoundaryRadius(spawnRadius: number): number
	assertRadius(spawnRadius)

	return spawnRadius + ArenaVisuals.BoundaryRadiusOffset
end

function ArenaVisuals.getRunMarkerRadius(spawnRadius: number): number
	assertRadius(spawnRadius)

	return spawnRadius + ArenaVisuals.RunMarkerRadiusOffset
end

function ArenaVisuals.calculateMarkers(total: number, radius: number, y: number): { ArenaMarker }
	assertWholeNumber(total, "total")
	assert(total >= 1, "total must be at least 1")
	assertRadius(radius)

	local markers = {}

	for index = 1, total do
		local angle = ((index - 1) / total) * TAU

		markers[index] = {
			index = index,
			total = total,
			radius = radius,
			x = math.sin(angle) * radius,
			y = y,
			z = math.cos(angle) * radius,
			angle = angle,
		}
	end

	return markers
end

function ArenaVisuals.calculateRingMarkers(spawnRadius: number): { ArenaMarker }
	return ArenaVisuals.calculateMarkers(
		ArenaVisuals.RingMarkerCount,
		ArenaVisuals.getBoundaryRadius(spawnRadius),
		ArenaVisuals.MarkerHeight
	)
end

function ArenaVisuals.calculateRunMarkers(spawnRadius: number): { ArenaMarker }
	return ArenaVisuals.calculateMarkers(
		ArenaVisuals.RunMarkerCount,
		ArenaVisuals.getRunMarkerRadius(spawnRadius),
		ArenaVisuals.MarkerHeight
	)
end

function ArenaVisuals.calculatePreviewSlots(spawnRadius: number): { ArenaSlot }
	local markers = ArenaVisuals.calculateMarkers(
		ArenaVisuals.PreviewSlotCount,
		spawnRadius,
		ArenaVisuals.SlotHeight
	)
	local slots = {}

	for index, marker in markers do
		slots[index] = {
			slotIndex = marker.index,
			totalSlots = marker.total,
			radius = marker.radius,
			x = marker.x,
			y = marker.y,
			z = marker.z,
		}
	end

	return slots
end

return table.freeze(ArenaVisuals)
