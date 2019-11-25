local Configuration = require "Configuration.Configuration"
local addOnName = ...

local config = Configuration(addOnName .. "_EllybConfig")

config.DEBUG_MODE = false

return config