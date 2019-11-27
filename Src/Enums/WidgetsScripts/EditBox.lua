local FrameScripts = require "Enums.WidgetsScripts.Frame"
local Tables = require "Tools.Tables"

---@type Observable
local t = {}

---@class EditBoxScripts: FrameScripts
local EditBoxScripts = {
	OnArrowPressed = t,
	OnCharComposition = t,
	OnCursorChanged = t,
	OnEditFocusGained = t,
	OnEditFocusLost = t,
	OnEnterPressed = t,
	OnEscapePressed = t,
	OnInputLanguageChanged = t,
	OnSpacePressed = t,
	OnTabPressed = t,
	OnTextChanged = t,
	OnTextSet = t,
}


Tables.copy(EditBoxScripts, FrameScripts)

return EditBoxScripts