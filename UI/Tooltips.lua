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

function Ellyb_TooltipedFrameMixin:OnEnter()
	self.tooltip:Show();
end

function Ellyb_TooltipedFrameMixin:OnLeave()
	self.tooltip:Hide();
end

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb)

	local Tooltips = {};
	Ellyb.Tooltips = Tooltips;

	Tooltips.ANCHORS = {
		--- Align the top right of the tooltip with the bottom left of the owner
		BOTTOMLEFT= "ANCHOR_BOTTOMLEFT",
		--- Toolip follows the mouse cursor
		CURSOR= "ANCHOR_CURSOR",
		--- Align the bottom right of the tooltip with the top left of the owner
		LEFT= "ANCHOR_LEFT",
		--- Tooltip appears in the default position
		NONE= "ANCHOR_NONE",
		--- Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)
		PRESERVE= "ANCHOR_PRESERVE",
		--- Align the bottom left of the tooltip with the top right of the owner
		RIGHT= "ANCHOR_RIGHT",
		--- Align the bottom left of the tooltip with the top left of the owner
		TOPLEFT= "ANCHOR_TOPLEFT",
		--- Align the bottom right of the tooltip with the top right of the owner
		TOPRIGHT= "ANCHOR_TOPRIGHT",
	}
end

Ellyb.ModulesManagement:RegisterNewModule("Tooltips", OnLoad);