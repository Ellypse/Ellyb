local FrameSetters = require "Enums.WidgetSetters.Frame"
local Tables = require "Tools.Tables"

---@type Subject
local t = {}

---@class ButtonSetters: FrameSetters
local ButtonSetters = {
	SetMotionScriptsWhileDisabled = t,
	SetText = t,
	SetHighlightFontObject = t,
	SetHighlightTexture = t,
	SetEnabled = t,
	SetPushedTextOffset = t,
	SetDisabledTexture = t,
	SetText = t,
	SetFormattedText = t,
	SetDisabledFontObject = t,
	SetButtonState = t,
	SetFontString = t,
	SetNormalFontObject = t,
	SetNormalTexture = t,
	SetPushedTexture = t,
}

Tables.copy(ButtonSetters, FrameSetters)

return ButtonSetters