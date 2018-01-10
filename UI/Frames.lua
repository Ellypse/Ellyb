---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

local Frames = {};

---@param frame Frame|ScriptObject
function Frames.makeMovable(frame)
	frame:RegisterForDrag("LeftButton");

	frame:HookScript("OnDragStart", frame.StartMoving);
	frame:HookScript("OnDragStop", frame.StopMovingOrSizing);
end

Ellyb.Frames = Frames;