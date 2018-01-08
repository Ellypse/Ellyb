---@type Ellyb
local _, Ellyb = ...;

local insert = table.insert;

---@type GameTooltip
local GameTooltip = GameTooltip;

---@class Tooltip : Object
local Tooltip = Ellyb.class("TooltipContent");
-- Sets a private table used to store private attributes
local _private = setmetatable({}, { __mode = "k" });

function Tooltip:initialize()
	_private[self] = {};
	_private[self].content = {};
end

---@param customColor Color
function Tooltip:SetTitle(text, customColor)
	_private[self].title = text;
	_private[self].customTitleColor = customColor;
end

function Tooltip:SetTitleColor(customColor)
	_private[self].customTitleColor = customColor;
end

function Tooltip:GetTitle()
	return _private[self].title.text;
end

function Tooltip:GetTitleColor()
	return _private[self].customTitleColor or Ellyb.ColorManager.WHITE;
end

function Tooltip:SetAnchor(anchor)
	_private[self].anchor = anchor;
end

function Tooltip:GetAnchor()
	return _private[self].anchor or "ANCHOR_RIGHT";
end

---@param customColor Color
function Tooltip:AddLine(text, customColor)
	insert(_private[self].content, {
		text = text,
		customColor = customColor,
	})
end

function Tooltip:GetLines()
	return _private[self].content;
end

function Tooltip:ClearLines()
	_private[self].content = {};
end

function Tooltip:SetLines(lines)
	self:ClearLines();
	for _, line in pairs(lines) do
		self:AddLine(line.text, line.customColor)
	end
end

function Tooltip:Hide()
	GameTooltip:Hide();
end

function Tooltip:Show()
	if not self.tooltipContent:GetTitle() then
		return false;
	end
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(self, self.tooltipContent.GetAnchor());
	GameTooltip:SetText(self.tooltipContent:GetTitle(), self.tooltipContent:GetTitleColor());
	for _, line in pairs(self.tooltipContent:GetLines()) do
		GameTooltip:AddLine(line.text, (line.customColor and line.customColor:GetRGBA()));
	end
	GameTooltip:Show();
	return true;
end

---@class Ellyb_TooltipedFrameMixin : Frame
Ellyb_TooltipedFrameMixin = {};

function Ellyb_TooltipedFrameMixin:OnLoad()
	self.tooltip = Tooltip();
end

function Ellyb_TooltipedFrameMixin:GetTooltip()
	return self.tooltip;
end

--- Function called before the tooltip is shown.
--- Can be used in frames that needs dynamic tooltips, so that the tooltip content is changed before the tooltip is shown
---@param tooltip Tooltip
function Ellyb_TooltipedFrameMixin:OnTooltipShow(tooltip)

end

function Ellyb_TooltipedFrameMixin:OnEnter()
	if self.tooltip then
		self:OnTooltipShow(self.tooltip);
		self.tooltipIsShown = self.tooltip:Show();
	end
end

function Ellyb_TooltipedFrameMixin:OnLeave()
	if self.tooltipIsShown then
		self.tooltip:Hide();
	end
end