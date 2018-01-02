---@type Ellyb
local _, Ellyb = ...;

-- WoW imports
local type = type;
local format = string.format;
local next = next;
local pairs = pairs;

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb)

	---@class Assertions
	--- Various assertion functions to check if variables are of a certain type, empty, nil etc.
	--- These assertions will check if the library is running in DEBUG_MODE and only execute the assertions then.
	--- When not in DEBUG_MODE the assertions will be passed and will always return true, suppressing potential overhead
	local Assertions = {};
	Ellyb.Assertions = Assertions;

	-- Error messages
	local DEBUG_NIL_VARIABLE = [[Unexpected nil variable "%s".]];
	local DEBUG_WRONG_VARIABLE_TYPE = [[Invalid variable type "%2$s" for variable "%1$s", expected "%3$s".]];
	local DEBUG_WRONG_VARIABLE_TYPES = [[Invalid variable type "%2$s" for variable "%1$s", expected one of (%3$s).]];
	local DEBUG_EMPTY_VARIABLE = [[Variable "%s" cannot be empty.]];

	---Check if a variable is of the expected type ("number", "boolean", "string")
	---Can also check for Widget type ("Frame", "Button", "Texture")
	---@param variable any @ Any kind of variable, to be tested for its type
	---@param expectedType string @ Expected type of the variable
	---@param variableName string @ The name of the variable being tested, will be visible in the error message
	---@return boolean, string isType, errorMessage @ Returns true if the variable was of the expected type, or false with an error message if it wasn't.
	function Assertions.isType(variable, expectedType, variableName)
		if not Ellyb.DEBUG_MODE then
			return true
		end;
		local variableType = type(variable);
		local isOfExpectedType = variableType == expectedType;
		if not isOfExpectedType then
			-- Special check for frames. If a variable is a table, it could be a Frame.
			-- TODO Make it so the error message is different and give the Widget's type instead of variable type
			if variableType == "table" and type(variable.IsObjectType) == "function" and variable:IsObjectType(expectedType) then
				return true;
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
		if not Ellyb.DEBUG_MODE then
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
			local expectedTypesString = "";
			for _, expectedType in pairs(expectedTypes) do
				if expectedTypesString ~= "" then
					expectedTypesString = expectedTypesString .. "|";
				end
				expectedTypesString = expectedTypesString .. expectedType;
			end
			-- TODO Make it so the error message is different and give the Widget's type instead of variable type
			return false, format(DEBUG_WRONG_VARIABLE_TYPES, variableName, variableType, expectedTypesString);
		else
			return true;
		end
	end

	---Check if a variable is not nil
	---@param variable any @ Any kind of variable, will be checked if it is nil
	---@param variableName string @ The name of the variable being tested, will be visible in the error message
	---@return boolean, string isNotNil, errorMessage @ Returns true if the variable was not nil, or false with an error message if it wasn't.
	function Assertions.isNotNil(variable, variableName)
		if not Ellyb.DEBUG_MODE then
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
		if not Ellyb.DEBUG_MODE then
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

end

Ellyb.ModulesManagement:RegisterNewModule("Assertions", OnLoad);