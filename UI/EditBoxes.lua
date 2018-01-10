---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

if Ellyb_EditBoxMixin and _G.Ellyb:GetVersionNumber() >= Ellyb:GetVersionNumber() then
	return;
end

---@class Ellyb_EditBoxMixin : EditBox
Ellyb_EditBoxMixin = {};

function Ellyb_EditBoxMixin:SetReadOnly(readOnly)
	if readOnly == nil then
		readOnly = true;
	end
	self:SetAttribute("readOnly", readOnly);
end

function Ellyb_EditBoxMixin:SetSelectTextOnFocus(selectTextOnFocus)
	if selectTextOnFocus == nil then
		selectTextOnFocus = true;
	end
	self:SetAttribute("selectTextOnFocus", selectTextOnFocus);
end

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