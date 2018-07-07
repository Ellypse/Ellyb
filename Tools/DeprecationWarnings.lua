---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.DeprecationWarnings then
	return
end

-- Lua imports
local setmetatable = setmetatable;
local debugstack = debugstack;

-- Ellyb imports
local ORANGE, GREEN, GREY = Ellyb.ColorManager.ORANGE, Ellyb.ColorManager.GREEN, Ellyb.ColorManager.GREY;

local DeprecationWarnings = {};

local logger = Ellyb.Logger("Deprecation warnings");

local DEPRECATED_API_WARNING = [[DEPRECATED USAGE OF API %s.
Please use %s instead.
Stack: %s]];
local DEPRECATED_FUNCTION_WARNING = [[DEPRECATED USAGE OF FUNCTION %s.
Please use %s instead.
Stack: %s]];
local DEPRECATED_CUSTOM_WARNING = [[%s
Stack: %s]];

function DeprecationWarnings.wrapAPI(newAPITable, oldAPIName, newAPIName, oldAPIReference)
	return setmetatable(oldAPIReference or {}, {
		__index = function(_, key)
			logger:Warning(DEPRECATED_API_WARNING:format(ORANGE(oldAPIName), GREEN(newAPIName), GREY(debugstack(2, 3, 0))));
			return newAPITable[key];
		end,
		__newindex = function(_, key, value)
			logger:Warning(DEPRECATED_API_WARNING:format(ORANGE(oldAPIName), GREEN(newAPIName), GREY(debugstack(2, 3, 0))));
			newAPITable[key] = value;
		end
	})
end

function DeprecationWarnings.wrapFunction(newFunction, oldFunctionName, newFunctionName)
	return function(...)
		logger:Warning(DEPRECATED_FUNCTION_WARNING:format(ORANGE(oldFunctionName), GREEN(newFunctionName), GREY(debugstack(2, 3, 0))));
		return newFunction(...);
	end
end

function DeprecationWarnings.warn(customWarning)
	logger:Warning(DEPRECATED_CUSTOM_WARNING:format(customWarning, debugstack(2, 3, 0)));
end

Ellyb.DeprecationWarnings = DeprecationWarnings;
