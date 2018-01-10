---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

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

local function showFrameTooltip(self)
	self.Tooltip:Show();
end
local function hideFrameTooltip(self)
	self.Tooltip:Hide();
end

---GetTooltip
---@param frame Frame|ScriptObject
---@return Tooltip
function Tooltips:GetTooltip(frame)
	if not frame.Tooltip then
		frame.Tooltip = Ellyb.Tooltip(frame);
		frame:HookScript("OnEnter", showFrameTooltip)
		frame:HookScript("OnLeave", hideFrameTooltip)
	end

	return frame.Tooltip;
end