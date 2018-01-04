---@type Ellyb
local _, Ellyb = ...;

-- Lua imports
local format = string.format;

-- WoW imports
local _G = _G;

local COPY_LINK = [[You can copy this link by using the %s keyboard shortcut and then paste the link inside your browser using the %s shortcut.]];

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb, env)

	setfenv(1, env);

	local Popups = {};
	Ellyb.Popups = Popups;

	---@type Frame
	local URLPopup = _G.Ellyb_StaticPopOpenUrl;

	function Popups:OpenURL(url, customText)
		URLPopup.Text:SetText(customText or format(COPY_LINK, Ellyb.ColorManager.ORANGE(copyShortcut), Ellyb.ColorManager.ORANGE(pasteShortcut)));
		URLPopup.Url:SetText(url);
		URLPopup.Button.Text:SetText("Okay");
		URLPopup:Show();
	end

end

---@param Ellyb Ellyb
local function OnModulesLoad(Ellyb, env)
	setfenv(1, env);

	Logger = Ellyb.Logger("Popups");

	copyShortcut = Ellyb.Strings.systemKeyboardShortcut("Ctrl", "C");
	pasteShortcut = Ellyb.Strings.systemKeyboardShortcut("Ctrl", "V");
end

Ellyb.ModulesManagement:RegisterNewModule("Popups", OnLoad, OnModulesLoad);