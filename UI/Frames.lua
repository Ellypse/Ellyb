---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- Lua imports
local assert = assert;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

local Frames = {};

---Make a frame movable. The frame's position is not saved.
---@param frame Frame|ScriptObject
function Frames.makeMovable(frame)
	assert(isType(frame, "Frame", "frame"));
	frame:RegisterForDrag("LeftButton");

	frame:HookScript("OnDragStart", frame.StartMoving);
	frame:HookScript("OnDragStop", frame.StopMovingOrSizing);
end

---@param self Frame
---@param delta number
local function setSliderValueOnMouseScroll(self, delta)
	if not self._slider then
		return
	end
	if self._slider :IsEnabled() then
		local mini, maxi = self._slider:GetMinMaxValues();
		if delta == 1 and self._slider:GetValue() > mini then
			self._slider:SetValue(self._slider:GetValue() - 1);
		elseif delta == -1 and self._slider:GetValue() < maxi then
			self._slider:SetValue(self._slider:GetValue() + 1);
		end
	end
end

---Make scrolling with the mouse wheel on the given frame change the given slider value
---@param frame Frame @ The frame that will receive the scroll wheel event
---@param slider Slider @ The slider that should see its value changed
function Frames.handleMouseWheelScroll(frame, slider)
	assert(isType(frame, "Frame", frame));
	assert(isType(slider, "Slider", slider));

	frame._slider = slider;
	frame:SetScript("OnMouseWheel", setSliderValueOnMouseScroll);
	frame:EnableMouseWheel(1);
end

Ellyb.Frames = Frames;