local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local Popup = require "UI.Popups.Popup"
local loc = require "Ellyb.Localization"
local System = require "Tools.System"
local EditBox = require "UI.Widgets.EditBox"
local EditBoxes = require "UI.EditBoxes"

---@class Ellyb_CopyTextPopup: Ellyb_Popup
local CopyTextPopup = Class("CopyTextPopup", Popup)

function CopyTextPopup:initialize()
	self.super.initialize(self)
	self:SetText(loc.COPY_URL_POPUP_TEXT:format(System.SHORTCUTS.COPY, System.SHORTCUTS.PASTE))
	self:SetHeight(160)

	local textField = EditBox(self)
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
		end
	end)
end

function CopyTextPopup:SetCopyableText(text)
	private[self].textField:SetText(text)
end

return CopyTextPopup