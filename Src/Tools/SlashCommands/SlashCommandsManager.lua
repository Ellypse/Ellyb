local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local Logger = require "Logs.Logger"
local Colors = require "Enums.Colors"
local Assertions = require "Tools.Assertions"
local SlashCommand = require "Tools.SlashCommands.SlashCommand"

--- Create a SlashCommandManager to handle receiving chat slash commands from the user.
---
--- ## Example:
--- ```Lua
--- local mySlashCommandManager = SlashCommandManager("MyAddon", "MyAddon", "MA")
--- local toggleDebug = SlashCommand("debug", function(enable)
---   config.DEBUG_MODE = enable == "true"
--- end, 'Pass "true" to enable debug mode, "false" to disable it.')
--- mySlashCommandManager:Register(toggleDebug)
--- ```
---
---@class Ellyb_SlashCommandsManager: MiddleClass
local SlashCommandsManager = Class("SlashCommandsManager")

local SLASH_COMMAND_GLOBAL_FORMAT = "SLASH_%s1"

---@param name string
---@vararg string A list of command tokens that can be used to call the SlashCommandManger. At least 1 is required.
function SlashCommandsManager:initialize(name, ...)
	Assertions.isType(name, "string", "name")
	local commandTokens = { ... }
	Assertions.hasAtLeast(1, commandTokens, "commandToken")
	local mainCommandToken = commandTokens[1] -- The first command token is the one that will be used for the help message

	private[self].name = name
	private[self].commandTokens = commandTokens
	private[self].commands = {}
	private[self].logger = Logger("/" .. name)

	local function commandCallback(arguments)
		local args = { strsplit(" ", arguments) }
		local commandName = args[1]
		table.remove(args, 1)

		if commandName then
			commandName = commandName:lower()
			if private[self].commands[commandName] then
				---@type Ellyb_SlashCommand
				local command = private[self].commands[commandName]
				private[self].logger:Info("Running command " .. command:GetName(), unpack(args))
				command:Execute(unpack(args))
				return
			else
				print("Command not found " .. commandName)
			end
		end

		-- Show command list
		print("List of slash commands for available for " .. Colors.ORANGE(name) .. ":\n")

		for command, commandInfo in pairs(private[self].commands) do
			local cmdText = Colors.ORANGE("/" .. mainCommandToken .. " " .. command)
			if commandInfo.helperText then
				cmdText = cmdText .. " " .. Colors.GREY(commandInfo.helperText)
			end
			print(cmdText)
		end
	end

	for _, commandToken in pairs(commandTokens) do
		commandToken = strtrim(commandToken)
		local globalName = commandToken:upper()
		local globalKey = format(SLASH_COMMAND_GLOBAL_FORMAT, globalName)
		local slashCommandName = "/" .. commandToken:lower()
		_G[globalKey] = slashCommandName
		_G.SlashCmdList[globalName] = commandCallback
	end
end

---@param command Ellyb_SlashCommand
function SlashCommandsManager:Register(command)
	Assertions.isInstanceOf(command, SlashCommand, "command")
	assert(not private[self].commands[command:GetName()], ([[Command "%s" has already been registered on "%s".]]):format(command:GetName(), private[self].name))

	private[self].commands[command:GetName()] = command
	private[self].logger:Info(Colors.GREEN("Registered") .. " new slash command: " .. command:GetDescription())
end

function SlashCommandsManager:Unregister(command)
	Assertions.isInstanceOf(command, SlashCommand, "command")
	private[self].commands[command:GetName()] = nil
	private[self].logger:Info(Colors.RED("Unregistered") .." slash command " .. Colors.ORANGE(command:GetName()))
end

return SlashCommandsManager