local Class = require "Libraries.middleclass"
local EditBox = require "UI.Widgets.EditBox"

---@class Ellyb_SingleLineEditBox: Ellyb_EditBox
local SingleLineEditBox = Class("EditBox", EditBox)

function SingleLineEditBox:initialize()
	self.super.initialize(self)

	self:SetHeight(32)

	local leftBorder = self:CreateTexture()
	leftBorder:SetTexture("Interface/ChatFrame/UI-ChatInputBorder-Left2")
	leftBorder:SetSize(32, 32)
	leftBorder:SetPoint("LEFT", self, "LEFT", -10, 0)

	local rightBorder = self:CreateTexture()
	rightBorder:SetTexture("Interface/ChatFrame/UI-ChatInputBorder-Right2")
	rightBorder:SetSize(32, 32)
	rightBorder:SetPoint("RIGHT", self, "RIGHT", 10, 0)

	local middle = self:CreateTexture()
	middle:SetTexture("Interface/ChatFrame/UI-ChatInputBorder-Mid2", true)
	middle:SetHorizTile(true)
	middle:SetHeight(32)
	middle:SetPoint("TOPLEFT", leftBorder, "TOPRIGHT")
	middle:SetPoint("TOPRIGHT", rightBorder, "TOPLEFT")

	self:SetFontObject("ChatFontNormal")
	self:SetAutoFocus(false)
	self:SetMultiLine(false)
end

return SingleLineEditBox