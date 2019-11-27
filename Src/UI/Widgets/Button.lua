local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"
local CreateBindings = require "Internals.Rx.CreateBindings"
local ButtonScripts = require "Enums.WidgetsScripts.Button"
local ButtonSetters = require "Enums.WidgetSetters.Button"

---@class Ellyb_Button: Button
---@field rx ButtonScripts|ButtonSetters|CustomBindings
local Button = Class("Button")
MixinWidget("BUTTON", Button)

function Button:initialize()
	self.rx = CreateBindings(self, ButtonScripts, ButtonSetters)
end

return Button