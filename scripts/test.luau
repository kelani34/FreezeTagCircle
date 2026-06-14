local specs = {
	{ name = "CallerSelection", load = require("../tests/shared/CallerSelection.spec") },
	{ name = "CircleSpawns", load = require("../tests/shared/CircleSpawns.spec") },
	{ name = "GameStates", load = require("../tests/shared/GameStates.spec") },
	{ name = "Remotes", load = require("../tests/shared/Remotes.spec") },
	{ name = "Tuning", load = require("../tests/shared/Tuning.spec") },
}

local totalCount = 0
local failedCount = 0

local expect = {}

function expect.equal(actual: unknown, expected: unknown, message: string?)
	if actual ~= expected then
		error(message or `Expected {tostring(expected)}, got {tostring(actual)}`, 2)
	end
end

function expect.near(actual: number, expected: number, epsilon: number?, message: string?)
	local allowedDelta = epsilon or 0.0001

	if math.abs(actual - expected) > allowedDelta then
		error(message or `Expected {tostring(actual)} to be near {tostring(expected)}`, 2)
	end
end

function expect.truthy(value: unknown, message: string?)
	if not value then
		error(message or "Expected value to be truthy", 2)
	end
end

function expect.falsy(value: unknown, message: string?)
	if value then
		error(message or "Expected value to be falsy", 2)
	end
end

function expect.errors(callback: () -> (), message: string?)
	local ok = pcall(callback)

	if ok then
		error(message or "Expected callback to error", 2)
	end
end

function expect.sequence(actual: { unknown }, expected: { unknown }, message: string?)
	expect.equal(#actual, #expected, message or "Sequence lengths differ")

	for index, expectedValue in expected do
		expect.equal(actual[index], expectedValue, message or `Sequence mismatch at index {index}`)
	end
end

for _, spec in specs do
	for _, testCase in spec.load do
		totalCount += 1

		local ok, err = pcall(testCase.run, expect)

		if ok then
			print(`PASS {spec.name}: {testCase.name}`)
		else
			failedCount += 1
			warn(`FAIL {spec.name}: {testCase.name}`)
			warn(err)
		end
	end
end

if failedCount > 0 then
	error(`{failedCount} of {totalCount} tests failed`)
end

print(`All {totalCount} tests passed`)
