local ColorManager = require "Tools.Colors.ColorManager"
local Icon = require "Tools.Textures.Icon"
local DeprecationWarnings = require "UI.DeprecationWarnings"
local Strings = require "Tools.Strings.Strings"
local System = require "Tools.System"
local config = require "Ellyb.Configuration"
local Unit = require "Tools.Unit"

config.DEBUG_MODE = true

print(ColorManager.createFromHexa("#00ACEE"))
local icon = Icon("8XP_VulperaFlute")
print(icon)

local Cursor = require "UI.Cursor"
Cursor.setIcon(icon, -20, 20)

local newFunction = function() print("BfA") end

local deprecatedFunction = DeprecationWarnings.wrapFunction(newFunction, "deprecatedFunction", "newFunction")

deprecatedFunction()

print(Strings.clickInstruction(System:FormatKeyboardShortcut(System.MODIFIERS.CTRL, System.MODIFIERS.ALT, System.CLICKS.DOUBLE_CLICK), "Win the game"))

print(Strings.formatBytes(1234567890))

print(Strings.interpolate([[I love %b$s at least %a$s thousands]], {
	a = "3",
	b = "Elza"
}))

local player = Unit("player")
print(player:IsAttackable())

local SlashCommandManager = require "Tools.SlashCommands.SlashCommandsManager"
local SlashCommand = require "Tools.SlashCommands.SlashCommand"

local test = SlashCommandManager("Ellyb", "Ellyb", "EB")
local toggleDebug = SlashCommand("debug", function(enable)
	config.DEBUG_MODE = enable == "true"
end, 'Pass "true" to enable debug mode, "false" to disable it.')

test:Register(toggleDebug)

local GameEvents = require "Events.GameEvents"
local Promise = require "Tools.Promises.Promise"
local Promises = require "Tools.Promises.Promises"

local enterWorld = Promise()

enterWorld:Success(function()
	print("Player entered world")
end)

local unitFaction = Promise()

unitFaction:Success(function()
	print("Unit has faction")
end)

local all = Promises.all(enterWorld, unitFaction)

all:Success(function()
	print("Everything is ready")
end)

GameEvents.registerCallback("PLAYER_ENTERING_WORLD", function()
	enterWorld:Resolve()
end)

GameEvents.registerCallback("UNIT_FACTION", function()
	unitFaction:Resolve()
end)

local Threads = require "Tools.Threads.Threads"

Threads.run(function(yield)
	for i = 0, 5 do
		print(i, GetTimePreciseSec())
		yield()
	end
	return
end)

Threads.run(function(yield)
	for i = 0, 5 do
		print(i, GetTimePreciseSec())
		yield()
	end
	return
end)

local Animator = require "Tools.Animator"

local sampleAnimator = Animator()

sampleAnimator:RunValue(0, 1, 2, print)

local TooltipManager = require "UI.Tooltips.TooltipManager"

enterWorld:Success(function()
	TooltipManager.getTooltip(PlayerFrame)
				  :SetTitle("CustomTooltip")
	:AddLine("Custom tooltip made with Ellyb")

end )