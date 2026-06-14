local ArenaVisualService = require(script:WaitForChild("ArenaVisualService"))
local RoundDriverService = require(script:WaitForChild("RoundDriverService"))
local RoundReplicationService = require(script:WaitForChild("RoundReplicationService"))
local RoundService = require(script:WaitForChild("RoundService"))

RoundService.start()
ArenaVisualService.start()
RoundReplicationService.start()
RoundDriverService.start()
