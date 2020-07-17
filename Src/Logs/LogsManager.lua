local LogsManager = {}

---@type Ellyb_Logger[]
local logs = {}

---@param logger Ellyb_Logger
function LogsManager:RegisterLogger(logger)
	local ID = logger:GetModuleName()
	-- assert(not logs[ID], "A Logger for " .. ID .. " has already been registered")
	logs[ID] = logger
end

function LogsManager.show(ID)
	assert(logs[ID], "Cannot find Logger " .. ID)
	logs[ID]:Show()
end

function LogsManager.list()
	print("Available Loggers:")
	for _, log in pairs(logs) do
		print(log:GetModuleName())
	end
end

return LogsManager