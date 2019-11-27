local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"
local CreateBindings = require "Internals.Rx.CreateBindings"
local EditBoxScripts = require "Enums.WidgetsScripts.EditBox"
local EditBoxSetters = require "Enums.WidgetSetters.EditBox"

---@class Ellyb_EditBox: EditBox
---@field rx EditBoxScripts|EditBoxSetters|CustomBindings
local EditBox = Class("EditBox")
MixinWidget("EDITBOX", EditBox)

function EditBox:initialize()
	self.rx = CreateBindings(self, EditBoxScripts, EditBoxSetters)
end

return EditBox