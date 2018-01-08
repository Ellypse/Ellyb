---@type Ellyb
local _, Ellyb = ...;

-- Lua imports
local tConcat = table.concat;
local pairs = pairs;

-- WoW imports
local IsMacClient = IsMacClient();
local IsTestBuild = IsTestBuild();
local IsTrialAccount = IsTrialAccount();

---@param Ellyb Ellyb @ Instance of the library
---@param env table @ Private environment
local function OnLoad(Ellyb, env)

	local System = {};
	Ellyb.System = System;

	---@return boolean isMac @ Returns true if the client is running on a Mac
	function System:IsMac()
		return IsMacClient;
	end

	function System:IsTestBuild()
		return IsTestBuild;
	end

	function System:IsTrialAccount()
		return IsTrialAccount;
	end

	local SHORTCUT_SEPARATOR = System.isMac() and "-" or " + ";

	System.MODIFIERS = {
		CTRL = "Ctrl",
		ALT = "Alt",
		SHIFT = "Shift",
	}

	local MAC_SHORT_EQUIVALENCE = {
		[System.MODIFIERS.CTRL] = "Command",
		[System.MODIFIERS.ALT] = "Option",
		[System.MODIFIERS.SHIFT] = "Shift",
	}

	--- Format a keyboard shortcut with the appropriate separators according to the user operating system
	---@param ... string[]
	---@return string keyboardShortcut
	function System:FormatKeyboardShortcut(...)
		local shortcutComponents = { ... };

		return tConcat(shortcutComponents, SHORTCUT_SEPARATOR);
	end

	--- Format a keyboard shortcut with the appropriate separators according to the user operating system
	--- Will also convert Ctrl into Command and Alt into Option for Mac users.
	---@param ... string[]
	---@return string keyboardShortcut
	function System:FormatSystemKeyboardShortcut(...)
		local shortcutComponents = { ... };

		if self:IsMacClient() then
			-- Replace shortcut components
			for index, component in pairs(shortcutComponents) do
				if MAC_SHORT_EQUIVALENCE[component] then
					shortcutComponents[index] = MAC_SHORT_EQUIVALENCE[component];
				end
			end
		end

		return tConcat(shortcutComponents, SHORTCUT_SEPARATOR);
	end

	System.SHORTCUTS = {
		COPY = System:FormatSystemKeyboardShortcut(System.MODIFIERS.CTRL, "C"),
		PASTE = System:FormatSystemKeyboardShortcut(System.MODIFIERS.CTRL, "V"),
	}

	System.CLICKS = {
		CLICK = "Click",
		RIGHT_CLICK = "Right-Click",
		LEFT_CLICK = "Left-Click",
		MIDDLE_CLICK = "Middle-Click",
	}
end

Ellyb.ModulesManagement:RegisterNewModule("System", OnLoad);