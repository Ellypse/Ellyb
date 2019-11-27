local FrameScripts = require "Enums.WidgetsScripts.Frame"
local Tables = require "Tools.Tables"

---@type Observable
local t = ""

---@class ButtonScripts: FrameScripts
local ButtonScripts = {}
ButtonScripts.OnClick = t
ButtonScripts.OnDoubleClick = t
ButtonScripts.PostClick = t
ButtonScripts.PreClick = t

Tables.copy(ButtonScripts, FrameScripts)

return ButtonScripts