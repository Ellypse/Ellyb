local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"

---@class Ellyb_CloseButton: Button
local CloseButton = Class("CloseButton")
MixinWidget("BUTTON", CloseButton)

function CloseButton:initialize(parent)
	self:SetParent(parent)
	self:SetSize(32, 32)
	self:SetNormalTexture("Interface/Buttons/UI-Panel-MinimizeButton-Up")
	self:SetPushedTexture("Interface/Buttons/UI-Panel-MinimizeButton-Down")
	self:SetDisabledTexture("Interface/Buttons/UI-Panel-MinimizeButton-Disabled")
	self:SetHighlightTexture("Interface/Buttons/UI-Panel-MinimizeButton-Highlight", "ADD")

	self:HookScript("OnClick", function()
		parent:Hide()
	end)
end

return CloseButton
