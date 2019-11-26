local GameClients = require "Enums.GameClientTypes"
local loc = require "Ellyb.Localization"

local System = {}

---@return boolean isMac @ Returns true if the client is running on a Mac
function System.isMac()
	return IsMacClient()
end

function System.isTestBuild()
	return IsTestBuild()
end

function System.isTrialAccount()
	return IsTrialAccount()
end

function System.isClassic()
	return WOW_PROJECT_ID == GameClients.CLASSIC
end

function System.isRetail()
	return WOW_PROJECT_ID == GameClients.RETAIL
end

local SHORTCUT_SEPARATOR = System.isMac() and "-" or " + "

System.MODIFIERS = {
	CTRL = loc.MODIFIERS_CTRL,
	ALT = loc.MODIFIERS_ALT,
	SHIFT = loc.MODIFIERS_SHIFT,
}

local MAC_SHORT_EQUIVALENCE = {
	[System.MODIFIERS.CTRL] = loc.MODIFIERS_MAC_CTRL,
	[System.MODIFIERS.ALT] = loc.MODIFIERS_MAC_ALT,
	[System.MODIFIERS.SHIFT] = loc.MODIFIERS_MAC_SHIFT,
}

--- Format a keyboard shortcut with the appropriate separators according to the user operating system
---@vararg string
---@return string
function System.formatKeyboardShortcut(...)
	local shortcutComponents = { ... }

	return table.concat(shortcutComponents, SHORTCUT_SEPARATOR)
end

--- Format a keyboard shortcut with the appropriate separators according to the user operating system
--- Will also convert Ctrl into Command and Alt into Option for Mac users.
---@vararg string
---@return string
function System.formatSystemKeyboardShortcut(...)
	local shortcutComponents = { ... }

	if IsMacClient() then
		-- Replace shortcut components
		for index, component in pairs(shortcutComponents) do
			if MAC_SHORT_EQUIVALENCE[component] then
				shortcutComponents[index] = MAC_SHORT_EQUIVALENCE[component]
			end
		end
	end

	return table.concat(shortcutComponents, SHORTCUT_SEPARATOR)
end

System.SHORTCUTS = {
	COPY = System.formatSystemKeyboardShortcut(System.MODIFIERS.CTRL, "C"),
	PASTE = System.formatSystemKeyboardShortcut(System.MODIFIERS.CTRL, "V"),
}

System.CLICKS = {
	CLICK = loc.CLICK ,
	RIGHT_CLICK = loc.RIGHT_CLICK,
	LEFT_CLICK = loc.LEFT_CLICK,
	MIDDLE_CLICK = loc.MIDDLE_CLICK,
	DOUBLE_CLICK = loc.DOUBLE_CLICK,
}

return System