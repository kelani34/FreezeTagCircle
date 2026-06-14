local CenterZone = {}

local function assertNumber(value: number, name: string)
	assert(typeof(value) == "number", `{name} must be a number`)
end

function CenterZone.getHorizontalDistance(x: number, z: number): number
	assertNumber(x, "x")
	assertNumber(z, "z")

	return math.sqrt((x * x) + (z * z))
end

function CenterZone.isWithinRadius(x: number, z: number, radius: number): boolean
	assertNumber(radius, "radius")
	assert(radius >= 0, "radius cannot be negative")

	return CenterZone.getHorizontalDistance(x, z) <= radius
end

return table.freeze(CenterZone)
