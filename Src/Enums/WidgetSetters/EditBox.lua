local FrameSetters = require "Enums.WidgetSetters.Frame"
local Tables = require "Tools.Tables"

---@type Subject
local t = {}

---@class EditBoxSetters: FrameSetters
local EditBoxSetters = {
	SetBlinkSpeed = t,
	SetMaxBytes = t,
	SetNumeric = t,
	SetAltArrowKeyMode = t,
	SetMaxLetters = t,
	SetCountInvisibleLetters = t,
	SetHyperlinksEnabled = t,
	SetPassword = t,
	SetText = t,
	SetEnabled = t,
	SetIndentedWordWrap = t,
	SetTextInsets = t,
	SetAutoFocus = t,
	SetFocus = t,
	SetNumber = t,
	SetCursorPosition = t,
	SetHistoryLines = t,
	SetMultiLine = t,
}

Tables.copy(EditBoxSetters, FrameSetters)

return EditBoxSetters