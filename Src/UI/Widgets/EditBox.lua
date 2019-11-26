local Class = require "Libraries.middleclass"
local MixinWidget = require "Internals.MixinWidget"

---@class Ellyb_EditBox: EditBox
local EditBox = Class("EditBox")
MixinWidget("EDITBOX", EditBox)

function EditBox:initialize(parent)
	self:SetParent(parent)
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
end

return EditBox