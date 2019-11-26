local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local Popup = require "UI.Popups.Popup"
local loc = require "Ellyb.Localization"
local System = require "Tools.System"
local SingleLineEditBox = require "UI.EditBoxes.SingleLineEditBox"
local EditBoxes = require "UI.EditBoxes"
local Colors = require "Enums.Colors"
local Texture = require "Tools.Textures.Texture"

local checkMark = Texture("Interface/Scenarios/ScenarioIcon-Check")

---@class Ellyb_CopyTextPopup: Ellyb_Popup
local CopyTextPopup = Class("CopyTextPopup", Popup)

function CopyTextPopup:initialize()
	self.super.initialize(self)

	self:SetText(loc.COPY_POPUP_TEXT:format(System.SHORTCUTS.COPY, System.SHORTCUTS.PASTE))
	self:SetHeight(160)

	local textField = SingleLineEditBox()
	textField:SetParent(self)
	textField:SetPoint("TOP", self.text, "BOTTOM", 0, -10)
	textField:SetPoint("LEFT", self, "LEFT", 35, 0)
	textField:SetPoint("RIGHT", self, "RIGHT", -35, 0)
	private[self].textField = textField

	EditBoxes.selectAllTextOnFocus(textField)
	EditBoxes.makeReadOnly(textField)

	self:HookScript("OnShow", function()
		textField:SetFocus()
	end)

	textField:HookScript("OnKeyDown", function(_, key)
		if key == "C" and IsControlKeyDown() then
			self:Hide()
			UIErrorsFrame:AddMessage(checkMark:GenerateString(15, 15) .. " " .. loc.TEXT_COPIED, Colors.GREEN:GetRGB());
		end
	end)
end

function CopyTextPopup:SetCopyableText(text)
	private[self].textField:SetText(text)
end

return CopyTextPopup