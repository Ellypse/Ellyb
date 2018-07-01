---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Assertions then
	return
end

-- WoW imports
local type = type;
local format = string.format;
local next = next;
local pairs = pairs;
local concat = table.concat;
local tostring = tostring;

---@class Assertions
--- Various assertion functions to check if variables are of a certain type, empty, nil etc.
--- These assertions will check if the library is running in DEBUG_MODE and only execute the assertions then.
--- When not in DEBUG_MODE the assertions will be passed and will always return true, suppressing potential overhead
local Assertions = {};
Ellyb.Assertions = Assertions;

-- Error messages
local DEBUG_NIL_VARIABLE = [[Unexpected nil variable "%s".]];
local DEBUG_WRONG_VARIABLE_TYPE = [[Invalid variable type "%2$s" for variable "%1$s", expected "%3$s".]];
local DEBUG_WRONG_WIDGET_TYPE = [[Invalid Widget type "%2$s" for variable "%1$s", expected a "%3$s".]];
local DEBUG_WRONG_VARIABLE_TYPES = [[Invalid variable type "%2$s" for variable "%1$s", expected one of (%3$s).]];
local DEBUG_WRONG_WIDGET_TYPES = [[Invalid Widget type "%2$s" for variable "%1$s", expected one of (%3$s).]];
local DEBUG_EMPTY_VARIABLE = [[Variable "%s" cannot be empty.]];
local DEBUG_WRONG_CLASS = [[Invalid Class "%2$s" for variable "%1$s", expected "%3$s".]];
local DEBUG_UNEXPECTED_VALUE = [[Unexpected variable value %2$s for variable "%1$s", expected to be one of (%3$s).]];
local DEBUG_WRONG_VARIABLE_INTERVAL = [[Invalid variable value "%2$s" for variable "%1$s". Expected the value to be between "%3$s" and "%4$s"]];

---Check if a variable is of the expected type ("number", "boolean", "string")
---Can also check for Widget type ("Frame", "Button", "Texture")
---@param variable any @ Any kind of variable, to be tested for its type
---@param expectedType string @ Expected type of the variable
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isType, errorMessage @ Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isType(variable, expectedType, variableName)
	if not Ellyb:IsDebugModeEnabled() then
		return true
	end;
	local variableType = type(variable);
	local isOfExpectedType = variableType == expectedType;
	if not isOfExpectedType then
		-- Special check for frames. If a variable is a table, it could be a Frame.
		if variableType == "table" and type(variable.IsObjectType) == "function" then
			if variable:IsObjectType(expectedType) then
				return true;
			else
				return false, format(DEBUG_WRONG_WIDGET_TYPE, variableName, variableType, expectedType);
			end
		else
			return false, format(DEBUG_WRONG_VARIABLE_TYPE, variableName, variableType, expectedType);
		end
	else
		return true;
	end
end

---Check if a variable is of one of the types expected ("number", "boolean", "string")
------Can also check for Widget types ("Frame", "Button", "Texture")
---@param variable any @ Any kind of variable, to be tested for its type
---@param expectedTypes string[] @ A list of expected types for the variable
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isType, errorMessage @ Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isOfTypes(variable, expectedTypes, variableName)
	if not Ellyb:IsDebugModeEnabled() then
		return true
	end;
	local variableType = type(variable);
	local isOfExpectedType = false;
	local isUIObject = variableType == "table" and type(variable.IsObjectType) == "function";

	for _, expectedType in pairs(expectedTypes) do
		if isUIObject then
			if variable:IsObjectType(expectedType) then
				isOfExpectedType = true;
				break;
			end
		elseif variableType == expectedType then
			isOfExpectedType = true;
			break;
		end
	end

	if not isOfExpectedType then
		local expectedTypesString = concat(expectedTypes, "|");
		if isUIObject then
			return false, format(DEBUG_WRONG_WIDGET_TYPES, variableName, variableType, expectedTypesString);
		else
			return false, format(DEBUG_WRONG_VARIABLE_TYPES, variableName, variableType, expectedTypesString);
		end
	else
		return true;
	end
end

---Check if a variable is not nil
---@param variable any @ Any kind of variable, will be checked if it is nil
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isNotNil, errorMessage @ Returns true if the variable was not nil, or false with an error message if it wasn't.
function Assertions.isNotNil(variable, variableName)
	if not Ellyb:IsDebugModeEnabled() then
		return true
	end;
	local isVariableNil = variable == nil;
	if isVariableNil then
		return false, format(DEBUG_NIL_VARIABLE, variableName);
	else
		return true;
	end
end

---Check if a variable is empty
---@param variable any @ Any kind of variable that can be checked to be empty
---@param variableName string @ The name of the variable being tested, will be visible in the error message
---@return boolean, string isNotEmpty, errorMessage @ Returns true if the variable was not empty, or false with an error message if it was.
function Assertions.isNotEmpty(variable, variableName)
	if not Ellyb:IsDebugModeEnabled() then
		return true
	end;
	local variableType = type(variable);
	local isEmpty = false;

	if variableType == "nil" then
		isEmpty = true;
	elseif variableType == "table" then
		-- To check if a table is empty we can just try to get its next field
		isEmpty = not next(variable);
	elseif variableType == "string" then
		-- A string is considered empty if it is equal to empty string ""
		isEmpty = variable == "";
	end

	if isEmpty then
		return false, format(DEBUG_EMPTY_VARIABLE, variableName);
	else
		return true;
	end
end

--- Check if a variable is an instance of a specified class, taking polymorphism into account, so inherited class will pass the test.
---@param variable Object @ The object to test
---@param class string @ The name of the expected class as a string
---@param variableName string @ The name of the variable being tested, will be visible in the error message
function Assertions.isInstanceOf(variable, class, variableName)
	if not Ellyb:IsDebugModeEnabled() then
		return true
	end;
	local variableType = type(variable);

	if not variableType == "table" or not variable.isInstanceOf or not variable.class then
		-- The variable is not a Class
		return false, format(DEBUG_WRONG_CLASS, variableName, variableType, class);
	end

	-- Check if the variable is an instance of the given class (taking polymorphism into account)
	if not variable:isInstanceOf(class) then
		-- The variable is an instance of a different class
		return false, format(DEBUG_WRONG_CLASS, variableName, tostring(variable.class), class);
	end

	return true;
end


--- Check if a variable value is one of the possible values.
---@param variable any @ Any kind of variable, will be checked if it's value is in the list of possible values
---@param possibleValues table @ A table of the possible values accepted
---@param variableName string @ The name of the variable being tested, will be visible in the error message
function Assertions.isOneOf(variable, possibleValues, variableName)
	if not Ellyb:IsDebugModeEnabled() then
		return true
	end;
	for _, possibleValue in pairs(possibleValues) do
		if variable == possibleValue then
			return true;
		end
	end
	return false, format(DEBUG_UNEXPECTED_VALUE, variableName, tostring(variable), concat(possibleValues, "|"));
end

--- Check if a variable is a number between a maximum and a minimum
---@param variable number @ A number to check
---@param minimum number @ The minimum value for the number
---@param maximum number @ The maximum value for the number
---@param variableName string @ The name of the variable being tested, will be visible in the error message
function Assertions.numberIsBetween(variable, minimum, maximum, variableName)
	if not Ellyb:IsDebugModeEnabled() then
		return true
	end;
	local variableType = type(variable);

	-- Variable has to be a number to do comparison
	if variableType ~= "number" then
		return false, format(DEBUG_WRONG_VARIABLE_TYPE, variableName, variableType, "number");
	end

	if variable < minimum or variable > maximum then
		return false, format(DEBUG_WRONG_VARIABLE_INTERVAL, variableName, variable, minimum, maximum);
	end

	return true
end
