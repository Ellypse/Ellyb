---@type Ellyb
local _, Ellyb = ...;

-- Lua imports
local format = string.format;

-- WoW imports
local _G = _G;

local COPY_LINK = [[
You can copy this link by using the %s keyboard shortcut and then paste the link inside your browser using the %s shortcut.
]];

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb, env)

	setfenv(1, env);

	local Popups = {};
	Ellyb.Popups = Popups;

	---@type Frame
	local URLPopup = _G.Ellyb_StaticPopOpenUrl;
	URLPopup.Button.Text:SetText(_G.OKAY);

	--- Open a popup with an autofocused text field to let the user copy the URL
	---@param url string @ The URL we want to let the user copy
	---@param customText string @ A custom text to display, instead of the default hint to copy the URL
	---@param customShortcutInstructions string @ A custom text for the copy and paste shortcut instructions.
	function Popups:OpenURL(url, customText, customShortcutInstructions)
		local popupText = customText or "";
		if not customShortcutInstructions then
			customShortcutInstructions = COPY_LINK;
		end
		popupText = popupText .. format(customShortcutInstructions, Ellyb.System.SHORTCUTS.COPY, Ellyb.System.SHORTCUTS.PASTE);
		URLPopup.Text:SetText(popupText);
		URLPopup.Url:SetText(url);
		URLPopup:Show();
	end

end

---@param Ellyb Ellyb
local function OnModulesLoad(Ellyb, env)
	setfenv(1, env);

	Logger = Ellyb.Logger("Popups");
end

Ellyb.ModulesManagement:RegisterNewModule("Popups", OnLoad, OnModulesLoad);