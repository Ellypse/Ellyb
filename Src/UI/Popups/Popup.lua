local Class = require "Libraries.middleclass"
local Frame = require "UI.Widgets.Frame"
local CloseButton = require "UI.Buttons.CloseButton"

---@class Ellyb_Popup: Frame
local Popup = Class("Popup", Frame)

function Popup:initialize()
	self:Hide()
	self:SetParent(UIParent)
	self:SetPoint("CENTER", UIParent, "CENTER")
	self:SetSize(360, 80)
	self:SetBackdrop({
		bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		tile = true,
		tileEdge = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 }
	})


	self.text = self:CreateFontString(nil, nil, "GameFontHighlight")
	self.text:SetPoint("TOP", self, "TOP", 0, -40)
	self.text:SetPoint("LEFT", self, "LEFT", 35, 0)
	self.text:SetPoint("RIGHT", self, "RIGHT", -35, 0)
	self.text:SetText("Sample text")

	local closeButton = CloseButton(self)
	closeButton:SetParent(self)
	closeButton:SetPoint("TOPRIGHT", self, "TOPRIGHT", -3, -3)
end

function Popup:SetText(text)
	self.text:SetText(text)
end

return Popup