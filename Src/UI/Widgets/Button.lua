local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"

---@class Ellyb_Button: Button
local Button = Class("Button")
MixinWidget("BUTTON", Button)

function Button:initialize()
	self:HookScript("OnClick", function()
		self:OnClick()
	end)
end

function Button:OnClick() end

return Button