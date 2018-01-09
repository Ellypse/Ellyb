---@type Ellyb
local _, Ellyb = ...;

---@class Ellyb_TooltipedFrameMixin : Frame
Ellyb_TooltipedFrameMixin = {};

--- OnLoad is automatically called by the Frame's scripts
--- Initialize the frame's tooltip
function Ellyb_TooltipedFrameMixin:OnLoad()
	self.tooltip = Ellyb.Tooltip(self);
end

---@return Tooltip tooltip
function Ellyb_TooltipedFrameMixin:GetTooltip()
	return self.tooltip;
end

--- Function called before the tooltip is shown.
--- Can be used in frames that needs dynamic tooltips, so that the tooltip content is changed before the tooltip is shown
---@param tooltip Tooltip
---@return boolean tooltipShouldBeShown @ Returns true if the tooltip should be shown
function Ellyb_TooltipedFrameMixin:OnTooltipShow(tooltip)
	return true;
end

function Ellyb_TooltipedFrameMixin:OnEnter()
	self.tooltipIsShown = self:OnTooltipShow(self.tooltip);
	if self.tooltipIsShown then
		self.tooltip:Show();
	end
end

function Ellyb_TooltipedFrameMixin:OnLeave()
	if self.tooltipIsShown then
		self.tooltip:Hide();
	end
end