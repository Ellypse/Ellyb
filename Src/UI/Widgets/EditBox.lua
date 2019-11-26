local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"

---@class Ellyb_EditBox: EditBox
local EditBox = Class("EditBox")
MixinWidget("EDITBOX", EditBox)

return EditBox