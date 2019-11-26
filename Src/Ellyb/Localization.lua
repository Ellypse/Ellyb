local Localization = require "Tools.Localization.Localization"
local Locales = require "Enums.Locales"

-- We are using Ellyb.loc here to store the locale table so we get code completion from the IDE
-- The table will be replaced by the complete Localization system, with metatable lookups for the localization keys
---@class loc : Ellyb_Localization
local loc  = {
	-- System
	MODIFIERS_CTRL = "Ctrl",
	MODIFIERS_ALT = "Alt",
	MODIFIERS_SHIFT = "Shift",
	MODIFIERS_MAC_CTRL = "Command",
	MODIFIERS_MAC_ALT = "Option",
	MODIFIERS_MAC_SHIFT = "Shift",
	CLICK = "Click",
	RIGHT_CLICK = "Right-Click",
	LEFT_CLICK = "Left-Click",
	MIDDLE_CLICK = "Middle-Click",
	DOUBLE_CLICK = "Double-Click",

	-- Popups
	COPY_POPUP_TEXT = [[
You can copy this text by using the %s keyboard shortcut.
]],
	TEXT_COPIED = "Text copied"
}

loc = Localization(loc)

loc:RegisterNewLocale(Locales.ENGLISH, "English", {})

loc:RegisterNewLocale(Locales.FRENCH, "Français", {
	-- System
	MODIFIERS_CTRL = "Contrôle",
	MODIFIERS_ALT = "Alt",
	MODIFIERS_SHIFT = "Maj",
	MODIFIERS_MAC_CTRL = "Commande",
	MODIFIERS_MAC_ALT = "Option",
	MODIFIERS_MAC_SHIFT = "Maj",
	CLICK = "Clic",
	RIGHT_CLICK = "Clic droit",
	LEFT_CLICK = "Clic gauche",
	MIDDLE_CLICK = "Clic milieu",
	DOUBLE_CLICK = "Double clic",

	-- Popups
	COPY_POPUP_TEXT = [[
Vous pouvez copier ce lien en utilisant le raccourci clavier %s.
]],
	TEXT_COPIED = "Texte copié"
})

loc:SetCurrentLocale(GetLocale(), true)

return loc
