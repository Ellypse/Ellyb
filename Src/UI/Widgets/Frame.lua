local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"
local CreateBindings = require "Internals.Rx.CreateBindings"
local FrameScripts = require "Enums.WidgetsScripts.Frame"
local FrameSetters = require "Enums.WidgetSetters.Frame"

---@class Ellyb_Frame: Frame
---@field rx FrameScripts|FrameSetters|CustomBindings
local Frame = Class("Frame")
MixinWidget("FRAME", Frame)

function Frame:initialize()
	self.rx = CreateBindings(self, FrameScripts, FrameSetters)
end

return Frame