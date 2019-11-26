local Assertions = require "Tools.Assertions"
local Colors = require "Enums.Colors"
local Logger = require "Logs.Logger"

-- Ellyb imports
local ORANGE, GREEN, GREY = Colors.ORANGE, Colors.GREEN, Colors.GREY;

local DeprecationWarnings = {}

local logger = Logger("Deprecation warnings");

--- Wraps an old API table so it throws deprecation warning when accessed.
--- It will indicate the name of the new API and map the method calls to the new API.
---@param newAPITable table Reference to the new API table
---@param oldAPIName string Name of the old API table
---@param newAPIName string Name of the new API table
---@param oldAPIReference table Reference to the old API table
---@return table
function DeprecationWarnings.wrapAPI(newAPITable, oldAPIName, newAPIName, oldAPIReference)
	Assertions.isType(newAPITable, "table", "newAPITable")
	Assertions.isType(oldAPIReference, "table", "oldAPIReference")
	Assertions.isType(oldAPIName, "string", "oldAPIName")
	Assertions.isType(newAPIName, "string", "newAPIName")

	return setmetatable(oldAPIReference or {}, {
		__index = function(_, key)
			logger:Warning(([[DEPRECATED USAGE OF API %s.
Please use %s instead.
Stack: %s]]):format(ORANGE(oldAPIName), GREEN(newAPIName), GREY(debugstack(2, 3, 0))));
			return newAPITable[key];
		end,
		__newindex = function(_, key, value)
			logger:Warning(([[DEPRECATED USAGE OF API %s.
Please use %s instead.
Stack: %s]]):format(ORANGE(oldAPIName), GREEN(newAPIName), GREY(debugstack(2, 3, 0))));
			newAPITable[key] = value;
		end
	})
end

--- Wraps an old function so it throws deprecation warning when used.
--- It will indicate the name of the new function and map the calls to the new function.
---@param newFunction function A reference to the new function that should be used
---@param oldFunctionName string The name of the old function that has been deprecated
---@param newFunctionName string Name of the new function that should be used instead
---@return function
function DeprecationWarnings.wrapFunction(newFunction, oldFunctionName, newFunctionName)
	Assertions.isType(newFunction, "function", "newFunction")
	Assertions.isType(oldFunctionName, "string", "oldFunctionName")
	Assertions.isType(newFunctionName, "string", "newFunctionName")

	return function(...)
		logger:Warning(([[DEPRECATED USAGE OF FUNCTION %s.
Please use %s instead.
Stack: %s]]):format(ORANGE(oldFunctionName), GREEN(newFunctionName), GREY(debugstack(2, 3, 0))));
		return newFunction(...);
	end
end

---@param customWarning string A custom deprecation warning that should be logged
function DeprecationWarnings.warn(customWarning)
	Assertions.isType(customWarning, "string", "customWarning")

	logger:Warning(([[%s
Stack: %s]]):format(customWarning, debugstack(2, 3, 0)));
end

return DeprecationWarnings
