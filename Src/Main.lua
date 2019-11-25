local Colors = require "Tools.Color"
local Icon = require "Tools.Icon"
local DeprecationWarnings = require "UI.DeprecationWarnings"
local Strings = require "Tools.Strings.Strings"
local System = require "Tools.System"
local config = require "EllybConfiguration"

config.DEBUG_MODE = true

print(Colors.CreateFromHexa("#00ACEE"))
print(Icon("8XP_VulperaFlute"))

local newFunction = function() print("BfA") end

local deprecatedFunction = DeprecationWarnings.wrapFunction(newFunction, "deprecatedFunction", "newFunction")

deprecatedFunction()

print(Strings.clickInstruction(System:FormatKeyboardShortcut(System.MODIFIERS.CTRL, System.MODIFIERS.ALT, System.CLICKS.DOUBLE_CLICK), "Win the game"))
