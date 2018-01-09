local _, Ellyb = ...;

-- Lua imports
local assert = assert;
local pairs = pairs;
local print = print;
local lower = string.lower;

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
		logs[lower(ID)] = logger;
	end

	function LogsManager.show(ID)
		assert(logs[ID], "Cannot find Logger " .. ID);
		logs[ID]:Show();
	end

	function LogsManager.list()
		print("Available Loggers:");
		for _, log in pairs(logs) do
			print(log:GetModuleName());
		end
	end

end

---@param Ellyb Ellyb @ Instance of the library
---@param env table @ Private environment
local function OnModulesLoaded(Ellyb, env)
	Ellyb.SlashCommand:RegisterCommand("logs", function(text)
		if text then
			Ellyb.LogsManager.show(lower(text));
		else
			Ellyb.LogsManager.list();
		end
	end,
	"Show logs for " .. Ellyb.addOnName);
end


Ellyb.ModulesManagement:RegisterNewModule("LogsManager", OnLoad, OnModulesLoaded);