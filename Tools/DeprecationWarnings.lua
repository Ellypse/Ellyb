---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.DeprecationWarnings then
	return
end

local DeprecationWarnings = {};

local logger = Ellyb.Logger("Deprecation warnings");

local DEPRECATED_API_WARNING = [[DEPRECATED USAGE OF API %s.
Please use %s instead.
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

Ellyb.DeprecationWarnings = DeprecationWarnings;
