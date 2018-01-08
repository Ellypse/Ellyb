---@type Ellyb
local _, Ellyb = ...;

---@class Ellyb_EditBoxMixin : EditBox
Ellyb_EditBoxMixin = {};

function Ellyb_EditBoxMixin:OnEditFocusGained()
	if self:GetAttribute("selectTextOnFocus") then
		self:HighlightText();
	end
end

function Ellyb_EditBoxMixin:OnEscapePressed()
	self:ClearFocus();
end

function Ellyb_EditBoxMixin:OnShow()
	if self:GetAttribute("readOnly") then
		self.originalText = self:GetText();
	end
end

function Ellyb_EditBoxMixin:OnTextChanged(userInput)
	if userInput and self:GetAttribute("readOnly") then
		self:SetText(self.originalText);
		self:OnEditFocusGained();
	end
end