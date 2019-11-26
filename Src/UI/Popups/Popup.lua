local Class = require "Libraries.middleclass"
local Frame = require "UI.Widgets.Frame"
local Colors = require "Enums.Colors"

---@class Ellyb_Popup: Ellyb_Frame
local Popup = Class("Popup", Frame)

function Popup:initialize()

	self.color = Colors.BLACK

	self:SetParent(UIParent)
	self:SetPoint("CENTER", 0, UIParent:GetHeight() / 4)
	self:SetSize(360, 160)
	self:SetBackdrop({
		bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
		edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
		tile = true,
		tileEdge = true,
		tileSize = 32,
		edgeSize = 32,
		insets = { left = 11, right = 12, top = 12, bottom = 11 }
	})
end

return Popup