local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local Assertions = require "Tools.Assertions"
local Colors = require "Enums.Colors"

---@class Ellyb_SlashCommand: MiddleClass
local SlashCommand = Class("SlashCommand")

---@param commandName string The name of the command. The user will input it after the slash token (`/token commandName`)
---@param handler fun(...:any):void A handler that will be executed when the user runs the command, with any additional arguments.
---@param helperText string A helper text that will be shown to the user to describe the command when listing all commands.
function SlashCommand:initialize(commandName, handler, helperText)
	Assertions.isType(handler, "function", "handler")
	Assertions.isType(helperText, "string", "helperText")
	commandName = commandName:lower()

	private[self].commandName = commandName
	private[self].handler = handler
	private[self].helperText = helperText
end

--- Provide a displayable description of the command, with its name and its helper text.
--- @return string
function SlashCommand:GetDescription()
	return Colors.ORANGE(private[self].commandName) .. " " .. Colors.GREY(private[self].helperText)
end

--- Execute the SlashCommand handler with the given arguments
function SlashCommand:Execute(...)
	private[self].handler(...)
end

---@return string
function SlashCommand:GetName()
	return private[self].commandName
end

return SlashCommand