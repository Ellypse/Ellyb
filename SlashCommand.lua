local _, Ellyb = ...;

-- Lua imports
local format = string.format;
local uppercase = string.upper;
local lowercase = string.lower;
local strtrim = strtrim;
local assert = assert;
local pairs = pairs;
local unpack = unpack;
local remove = table.remove;
local strsplit = strsplit;
local print = print;
local _G = _G;

local SLASH_COMMAND_GLOBAL_FORMAT = "SLASH_%s1";

---@param Ellyb Ellyb @ Instance of the library
---@param env table @ Private environment
local function OnLoad(Ellyb, env)

	local SlashCommand = {};
	Ellyb.SlashCommand = SlashCommand;

	setfenv(1, env);

	local COMMANDS = {};

	local globalName = uppercase(strtrim(Ellyb.addOnName));
	local globalKey = format(SLASH_COMMAND_GLOBAL_FORMAT, globalName);
	local slashCommandName = "/" .. lowercase(strtrim(Ellyb.addOnName));
	_G[globalKey] = slashCommandName;

	function SlashCommand:RegisterCommand(command, handler, help)
		assert(Ellyb.Assertions.isType(command, "string", "command"));
		assert(Ellyb.Assertions.isType(handler, "function", "handler"));
		assert(not COMMANDS[command], "Already registered command " .. command);

		COMMANDS[command] = {
			handler = handler,
			helpLine = help,
		};
		Logger:Info("Registered new slash command " .. command .. ". " .. (help or ""));
	end

	function SlashCommand:UnregisterCommand(commandID)
		COMMANDS[commandID] = nil;
		Logger:Info("Unregistered slash command " .. commandID);
	end

	_G.SlashCmdList[globalName] = function(text, editbox)
		local args = { strsplit(" ", text) };
		local cmdID = args[1];
		remove(args, 1);

		if cmdID and COMMANDS[cmdID] and COMMANDS[cmdID].handler then
			Logger:Info("Running command " .. cmdID);
			COMMANDS[cmdID].handler(unpack(args));
		else
			if cmdID then
				Logger:Info("Command not found " .. cmdID);
			end

			-- Show command list
			print("List of slash commands for " .. Ellyb.addOnName);

			for command, commandInfo in pairs(COMMANDS) do
				local cmdText = Ellyb.ColorManager.GREEN(slashCommandName) .. " " .. Ellyb.ColorManager.ORANGE(cmdID);
				if commandInfo.helpLine then
					cmdText = cmdText .. Ellyb.ColorManager.GREY(commandInfo.helpLine);
				end
				print(cmdText);
			end
		end
	end

end

---@param Ellyb Ellyb @ Instance of the library
---@param env table @ Private environment
local function OnModulesLoaded(Ellyb, env)

	setfenv(1, env);

	Logger = Ellyb.Logger("SlashCommand");

end

Ellyb.ModulesManagement:RegisterNewModule("SlashCommand", OnLoad, OnModulesLoaded);