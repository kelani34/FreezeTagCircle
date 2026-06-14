local TargetSelection = require("../../src/server/TargetSelection")

local ACTIVE_USER_IDS = { 10, 20, 30 }
local CALLER_USER_ID = 10
local TARGET_USER_ID = 20

local function validate(overrides)
	local options = {
		isCallerChoosing = true,
		activeUserIds = ACTIVE_USER_IDS,
		callerUserId = CALLER_USER_ID,
		requestingUserId = CALLER_USER_ID,
		targetUserId = TARGET_USER_ID,
		currentTargetUserId = nil,
	}

	for key, value in overrides or {} do
		options[key] = value
	end

	return TargetSelection.validate(options)
end

return {
	{
		name = "accepts an active non-caller target from the caller",
		run = function(expect)
			local result = validate()

			expect.truthy(result.accepted)
			expect.equal(result.reason, nil)
			expect.equal(result.targetUserId, TARGET_USER_ID)
		end,
	},
	{
		name = "rejects selection outside CallerChoosing",
		run = function(expect)
			local result = validate({
				isCallerChoosing = false,
			})

			expect.falsy(result.accepted)
			expect.equal(result.reason, "NotCallerChoosing")
		end,
	},
	{
		name = "rejects missing callers",
		run = function(expect)
			local result = validate({
				callerUserId = "caller",
			})

			expect.falsy(result.accepted)
			expect.equal(result.reason, "MissingCaller")
		end,
	},
	{
		name = "rejects non-caller requests",
		run = function(expect)
			local result = validate({
				requestingUserId = 30,
			})

			expect.falsy(result.accepted)
			expect.equal(result.reason, "RequesterNotCaller")
		end,
	},
	{
		name = "rejects invalid target payloads",
		run = function(expect)
			local result = validate({
				targetUserId = "twenty",
			})

			expect.falsy(result.accepted)
			expect.equal(result.reason, "InvalidTarget")
		end,
	},
	{
		name = "rejects inactive targets",
		run = function(expect)
			local result = validate({
				targetUserId = 40,
			})

			expect.falsy(result.accepted)
			expect.equal(result.reason, "TargetNotActive")
		end,
	},
	{
		name = "rejects self-targeting",
		run = function(expect)
			local result = validate({
				targetUserId = CALLER_USER_ID,
			})

			expect.falsy(result.accepted)
			expect.equal(result.reason, "CallerCannotTargetSelf")
		end,
	},
	{
		name = "rejects repeated selections after a target is locked",
		run = function(expect)
			local result = validate({
				currentTargetUserId = TARGET_USER_ID,
			})

			expect.falsy(result.accepted)
			expect.equal(result.reason, "TargetAlreadySelected")
		end,
	},
}
