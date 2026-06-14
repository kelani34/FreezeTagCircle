local RoundDriverService = require(script.Parent.RoundDriverService)
local RoundReplicationService = require(script.Parent.RoundReplicationService)
local RoundService = require(script.Parent.RoundService)

RoundService.start()
RoundReplicationService.start()
RoundDriverService.start()
