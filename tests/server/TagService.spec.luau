local TagService = require("../../src/server/TagService")

local function baseOptions()
	return {
		isTagAttempt = true,
		isExpired = false,
		activeUserIds = { 100, 200 },
		frozenUserIds = { 200 },
		calledUserId = 100,
		requestingUserId = 100,
		targetUserId = 200,
		distance = 5,
		tagRadius = 6,
	}
end

return {
	{
		name = "accepts active frozen target inside tag radius",
		run = function(expect)
			local result = TagService.validate(baseOptions())

			expect.truthy(result.accepted)
			expect.equal(result.targetUserId, 200)
			expect.equal(result.distance, 5)
		end,
	},
	{
		name = "rejects attempts outside TagAttempt",
		run = function(expect)
			local options = baseOptions()
			options.isTagAttempt = false

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "NotTagAttempt")
		end,
	},
	{
		name = "rejects expired attempts",
		run = function(expect)
			local options = baseOptions()
			options.isExpired = true

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "TagAttemptExpired")
		end,
	},
	{
		name = "rejects requests from anyone except called player",
		run = function(expect)
			local options = baseOptions()
			options.requestingUserId = 200

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "RequesterNotCalled")
		end,
	},
	{
		name = "rejects inactive targets",
		run = function(expect)
			local options = baseOptions()
			options.targetUserId = 300

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "TargetNotActive")
		end,
	},
	{
		name = "rejects targets that are not frozen",
		run = function(expect)
			local options = baseOptions()
			options.frozenUserIds = {}

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "TargetNotFrozen")
		end,
	},
	{
		name = "rejects self tags",
		run = function(expect)
			local options = baseOptions()
			options.targetUserId = 100

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "CannotTagSelf")
		end,
	},
	{
		name = "rejects missing server distance",
		run = function(expect)
			local options = baseOptions()
			options.distance = nil

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "MissingDistance")
		end,
	},
	{
		name = "rejects targets outside tag radius",
		run = function(expect)
			local options = baseOptions()
			options.distance = 7

			local result = TagService.validate(options)

			expect.falsy(result.accepted)
			expect.equal(result.reason, "OutsideTagRadius")
		end,
	},
}
