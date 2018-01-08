---@type Ellyb
local _, Ellyb = ...;

---@type GameTooltip
local GameTooltip = GameTooltip;

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