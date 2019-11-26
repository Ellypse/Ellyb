local Tooltip = require "UI.Tooltips.Tooltip"

local TooltipManager = {}

local function showFrameTooltip(self)
	self.Tooltip:Show()
end

local function hideFrameTooltip(self)
	self.Tooltip:Hide()
end

---@param frame Frame|ScriptObject
---@return Ellyb_Tooltip
function TooltipManager.getTooltip(frame)
	if not frame.Tooltip then
		frame.Tooltip = Tooltip(frame)
		frame:HookScript("OnEnter", showFrameTooltip)
		frame:HookScript("OnLeave", hideFrameTooltip)
	end

	return frame.Tooltip
end

return TooltipManager