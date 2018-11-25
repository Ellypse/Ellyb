---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Assertions then
	return
end

---@class Assertions
--- Various assertion functions to check if variables are of a certain type, empty, nil etc.
--- These assertions will directly raise an error if the test is not met.
local Assertions = {};

--- Check if a variable is of the expected type ("number", "boolean", "string")
--- Can also check for Widget type ("Frame", "Button", "Texture")
---@param variable any Any kind of variable, to be tested for its type
---@param expectedType string Expected type of the variable
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isType(variable, expectedType, variableName)
	local variableType = type(variable)
	local isOfExpectedType = variableType == expectedType

	if not isOfExpectedType then
		-- Special check for frames. If a variable is a table, it could be a Frame.
		if variableType == "table" and type(variable.IsObjectType) == "function" then
			if not variable:IsObjectType(expectedType) then
				error(([[Invalid Widget type "%s" for variable "%s", expected a "%s".]]):format(variable:GetObjectType(), variableName, expectedType), 2)
			end
		else
			error(([[Invalid variable type "%s" for variable "%s", expected "%s".]]):format(variableType, variableName, expectedType), 2)
		end
	end
end

---Check if a variable is of one of the types expected ("number", "boolean", "string")
------Can also check for Widget types ("Frame", "Button", "Texture")
---@param variable any Any kind of variable, to be tested for its type
---@param expectedTypes string[] A list of expected types for the variable
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was of the expected type, or false with an error message if it wasn't.
function Assertions.isOfTypes(variable, expectedTypes, variableName)
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
		local expectedTypesString = table.concat(expectedTypes, ", ");
		if isUIObject then
			error(([[Invalid Widget type "%s" for variable "%s", expected one of {%s}.]]):format(variable:GetObjectType(), variableName, expectedTypesString), 2)
		else
			error(([[Invalid variable type "%s" for variable "%s", expected one of {%s}.]]):format(variableType, variableName, expectedTypesString), 2)
		end
	end
end

---Check if a variable is not nil
---@param variable any Any kind of variable, will be checked if it is nil
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was not nil, or false with an error message if it wasn't.
function Assertions.isNotNil(variable, variableName)
	if variable == nil then
		error(([[Unexpected nil variable "%s".]]):format(variableName), 2)
	end
end

---Check if a variable is empty
---@param variable any Any kind of variable that can be checked to be empty
---@param variableName string The name of the variable being tested, will be visible in the error message
---@return boolean, string Returns true if the variable was not empty, or false with an error message if it was.
function Assertions.isNotEmpty(variable, variableName)
	local variableType = type(variable);

	if variableType == "nil" then
		error(([[Variable "%s" cannot be empty.]]):format(variableName), 2)

	-- To check if a table is empty we can just try to get its next field
	elseif variableType == "table" and not next(variable) then
		error(([[Variable "%s" cannot be an empty table.]]):format(variableName), 2)

		-- A string is considered empty if it is equal to empty string ""
	elseif variableType == "string" then
		error(([[Variable "%s" cannot be an empty string.]]):format(variableName), 2)
	end
end

--- Check if a variable is an instance of a specified class, taking polymorphism into account, so inherited class will pass the test.
---@param variable MiddleClass_Class The object to test
---@param class MiddleClass_Class A direct reference to the expected class
---@param variableName string The name of the variable being tested, will be visible in the error message
function Assertions.isInstanceOf(variable, class, variableName)
	local variableType = type(variable);

	if variableType ~= "table" or not variable.IsInstanceOf or not variable.class then
		-- The variable is not a Class
		error(([[Invalid type "%s" for variable "%s", expected a "%s".]]):format(variableType, variableName, tostring(class)), 2)
	end

	-- Check if the variable is an instance of the given class (taking polymorphism into account)
	if not variable:IsInstanceOf(class) then
		-- The variable is an instance of a different class
		error(([[Invalid Class "%s" for variable "%s", expected "%s".]]):format(tostring(variable.class), variableName, tostring(class)), 2)
	end

end


--- Check if a variable value is one of the possible values.
---@param variable any Any kind of variable, will be checked if it's value is in the list of possible values
---@param possibleValues table A table of the possible values accepted
---@param variableName string The name of the variable being tested, will be visible in the error message
function Assertions.isOneOf(variable, possibleValues, variableName)
	for _, possibleValue in pairs(possibleValues) do
		if variable == possibleValue then
			return
		end
	end

	error(([[Unexpected variable value %s for variable "%s", expected to be one of {%s}.]]):format(tostring(variable), variableName, table.concat(possibleValues, ", ")), 2)
end

--- Check if a variable is a number between a maximum and a minimum
---@param variable number A number to check
---@param minimum number The minimum value for the number
---@param maximum number The maximum value for the number
---@param variableName string The name of the variable being tested, will be visible in the error message
function Assertions.numberIsBetween(variable, minimum, maximum, variableName)

	-- Variable has to be a number to do comparison
	if type(variable) ~= "number" then
		error(([[Invalid variable type "%s" for variable "%s", expected "number".]]):format(type(variable), variableName), 2)
	end

	if variable < minimum or variable > maximum then
		error(([[Invalid variable value "%s" for variable "%s". Expected the value to be between "%s" and "%s"]]):format(variable, variableName, minimum, maximum), 2)
	end

end

Ellyb.Assertions = Assertions;
