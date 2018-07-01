---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.DeprecationWarnings then
	return
end

-- Lua imports
local setmetatable = setmetatable;
local debugstack = debugstack;

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

function DeprecationWarnings.wrapAPI(newAPITable, oldAPIName, newAPIName)
	return setmetatable({}, {
		__index = function(t, key)
			logger:Warning(DEPRECATED_API_WARNING:format(oldAPIName, newAPIName, debugstack(2, 3, 0)));
			return newAPITable[key];
		end,
		__newindex = function(t, key, value)
			logger:Warning(DEPRECATED_API_WARNING:format(oldAPIName, newAPIName, debugstack(2, 3, 0)));
			newAPITable[key] = value;
		end
	})
end

function DeprecationWarnings.wrapFunction(newFunction, oldFunctionName, newFunctionName)
	return function(...)
		logger:Warning(DEPRECATED_FUNCTION_WARNING:format(oldFunctionName, newFunctionName, debugstack(2, 3, 0)));
		return newFunction(...);
	end
end

function DeprecationWarnings.warn(customWarning)
	logger:Warning(DEPRECATED_CUSTOM_WARNING:format(customWarning, debugstack(2, 3, 0)));
end

Ellyb.DeprecationWarnings = DeprecationWarnings;
