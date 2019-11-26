local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"

---@class Ellyb_Frame: Frame
local Frame = Class("Frame")
MixinWidget("FRAME", Frame)

return Frame