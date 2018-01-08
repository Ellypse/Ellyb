local _, Ellyb = ...;

-- Lua imports
local assert = assert;

---@param Ellyb Ellyb @ Instance of the library
---@param env table @ Private environment
local function OnLoad(Ellyb, env)

	local LogsManager = {};
	Ellyb.LogsManager = LogsManager;

	---@type Logger[]
	local logs = {};

	---@param logger Logger
	function LogsManager:RegisterLogger(logger)
		local ID = logger:GetModuleName();
		assert(not logs[ID], "A Logger for " .. ID .. " has already been registered");
		logs[ID] = logger;
	end

	function LogsManager.show(ID)
		assert(logs[ID], "Cannot find Logger " .. ID);
		logs[ID]:Show();
	end

end

---@param Ellyb Ellyb @ Instance of the library
---@param env table @ Private environment
local function OnModulesLoaded(Ellyb, env)
	Ellyb.SlashCommand:RegisterCommand("logs", function(text)
		Ellyb.LogsManager.show(text);
	end,
	"Show logs for " .. Ellyb.addOnName);
end


Ellyb.ModulesManagement:RegisterNewModule("LogsManager", OnLoad, OnModulesLoaded);