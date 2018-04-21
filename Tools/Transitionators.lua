---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Transitionator then
	return
end

---@class Transitionator : Object
local Transitionator, _p = Ellyb.Class("Transitionator");

---@type Transitionator[]
local transitionators = {};

local TransitionatorsFrame = CreateFrame("FRAME");
TransitionatorsFrame:Show();

TransitionatorsFrame:SetScript("OnUpdate", function()
	for _, transitionator in pairs(transitionators) do
		if transitionator:ShouldBeUpdated() then
			transitionator:Tick();
		end
	end
end)

function Transitionator:initialize()
	_p[self] = {};

	_p[self].value = 0;
	_p[self].shouldBeUpdated = false;

	table.insert(transitionators, self);
end

function Transitionator:ShouldBeUpdated()
	return _p[self].shouldBeUpdated;
end

function Transitionator:Tick()
	local elapsed = GetTime() - _p[self].timeStarted;
	local currentValue = Ellyb.Easings.outQuad(elapsed, _p[self].startValue, _p[self].change, _p[self].overTime);
	if elapsed >= _p[self].overTime then
		_p[self].shouldBeUpdated = true;
	else
		_p[self].callback(currentValue);
	end
end

function Transitionator:RunValue(startValue, endValue, overTime, callback)
	if not endValue or endValue == startValue then
		return callback(startValue);
	end

	_p[self].startValue = startValue;
	_p[self].endValue = endValue;
	_p[self].change = endValue - startValue;
	_p[self].overTime = overTime;
	_p[self].callback = callback;

	_p[self].value = startValue;
	_p[self].timeStarted = GetTime();
	_p[self].shouldBeUpdated = true;
end

Ellyb.Transitionator = Transitionator;