---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Maths then
	return
end

-- Lua imports
local assert = assert;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

local Maths = {}

--- Increments a given value by the given increments up to a given max.
---@param value number @ A number value we want to increment
---@param increment number @ The increment used for the value
---@param max number @ The maximum for the value. If value + increment is higher than max, max will be used instead
---@return number @ The incremented value
function Maths.incrementValueUntilMax(value, increment, max)
	assert(isType(value, "number", "value"));
	assert(isType(increment, "number", "increment"));
	assert(isType(max, "number", "max"));

	if value + increment > max then
		return max;
	else
		return value + increment;
	end
end

---Wrap a value. If the value goes over the maximum it will start over to 1, if it is below 1 it will start from the max
---This is copied from a new function in BfA, but I can't wait so I'm making it mine :D
---@param value number @ The number to wrap
---@param max number @ The max value
function Maths.wrap(value, max)
	return (value - 1) % max + 1;
end

Ellyb.Maths = Maths