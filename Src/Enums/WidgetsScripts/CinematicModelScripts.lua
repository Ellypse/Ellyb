local FrameScripts = require "Enums.WidgetsScripts.Frame"
local Tables = require "Tools.Tables"

---@type Observable
local t = ""

---@class CinematicModelScripts: FrameScripts
local CinematicModelScripts = {}
CinematicModelScripts.OnModelLoaded = t

Tables.copy(CinematicModelScripts, FrameScripts)

return CinematicModelScripts