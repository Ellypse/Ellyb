local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"
local CreateBindings = require "Internals.Rx.CreateBindings"
local CinematicModelScripts = require "Libraries.Ellyb.Src.Enums.WidgetsScripts.CinematicModelScripts"
local CinematicModelSetters = require "Libraries.Ellyb.Src.Enums.WidgetSetters.CinematicModelSetters"

---@class Ellyb_CinematicModel: CinematicModel
---@field rx CinematicModelScripts|CinematicModelSetters|CustomBindings
local CinematicModel = Class("Model")
MixinWidget("CinematicModel", CinematicModel)

function CinematicModel:initialize()
	self.rx = CreateBindings(self, CinematicModelScripts, CinematicModelSetters)
end

return CinematicModel