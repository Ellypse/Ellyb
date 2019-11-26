local Class = require "Libraries.middleclass"
local Button = require "UI.Widgets.Button"

---@class Ellyb_CloseButton: Ellyb_Button
local CloseButton = Class("CloseButton", Button)

function CloseButton:initialize()
	self.super.initialize(self)

	self:SetSize(32, 32)
	self:SetNormalTexture("Interface/Buttons/UI-Panel-MinimizeButton-Up")
	self:SetPushedTexture("Interface/Buttons/UI-Panel-MinimizeButton-Down")
	self:SetDisabledTexture("Interface/Buttons/UI-Panel-MinimizeButton-Disabled")
	self:SetHighlightTexture("Interface/Buttons/UI-Panel-MinimizeButton-Highlight", "ADD")
end

function CloseButton:OnClick()
	self:GetParent():Hide()
end

return CloseButton
