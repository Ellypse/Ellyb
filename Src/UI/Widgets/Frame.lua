local Class = require "Libraries.middleclass"

---@class Ellyb_Frame: Frame
local Frame = Class.classifyUIWidget("Frame", function()
	return CreateFrame("FRAME")
end)

return Frame