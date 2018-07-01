---@type Ellyb
local Ellyb = Ellyb(...);

-- IDE shortcut to go to module
local _ = Ellyb.Assertions;

Ellyb.Documentation:AddDocumentationTable("Ellyb.Assertions", {
	Name = "Ellyb.Assertions",
	Type = "System",
	Namespace = "Ellyb.Assertions",

	Functions = {
		{
			Name = "isType",
			Type = "Function",
			Documentation = { [[Check if a variable is of the expected type ("number", "boolean", "string")
Can also check for Widget type ("Frame", "Button", "Texture")]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "expectedType", Type = "string", Documentation = { "Expected type of the variable" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

			Returns = {
				{ Name = "isType", Type = "boolean", Nilable = false, Documentation = { "Returns true if the variable was of the expected type, or false." } },
				{ Name = "errorMessage", Type = "string", Nilable = true, Documentation = { "Error message if the variable wasn't of the right type." } },
			},
		},
		{
			Name = "isOfTypes",
			Type = "Function",
			Documentation = { [[Check if a variable is of one of the types expected ("number", "boolean", "string")
Can also check for Widget types ("Frame", "Button", "Texture")]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "expectedTypes", Type = "table", Documentation = { "A list of expected types for the variable" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

			Returns = {
				{ Name = "isType", Type = "boolean", Nilable = false, Documentation = { "Returns true if the variable was of the expected type, or false." } },
				{ Name = "errorMessage", Type = "string", Nilable = true, Documentation = { "Error message if the variable wasn't of the right type." } },
			},
		},
		{
			Name = "isNotNil",
			Type = "Function",
			Documentation = { [[Check if a variable is not nil]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

			Returns = {
				{ Name = "isNotNil", Type = "boolean", Nilable = false, Documentation = { "true if the variable was not nil, or false." } },
				{ Name = "errorMessage", Type = "string", Nilable = true, Documentation = { "Error message if the variable was nil." } },
			},
		},
		{
			Name = "isNotEmpty",
			Type = "Function",
			Documentation = { [[Check if a variable is not empty]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

			Returns = {
				{ Name = "isNotEmpty", Type = "boolean", Nilable = false, Documentation = { "true if the variable was not empty, or false." } },
				{ Name = "errorMessage", Type = "string", Nilable = true, Documentation = { "Error message if the variable was empty." } },
			},
		},
		{
			Name = "isInstanceOf",
			Type = "Function",
			Documentation = { [[Check if a variable is an instance of a specified class, taking polymorphism into account, so inherited class will pass the test.]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its type" } },
				{ Name = "class", Type = "string", Documentation = { "The name of the expected class as a string" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

			Returns = {
				{ Name = "isInstance", Type = "boolean", Nilable = false, Documentation = { "true if the variable was an instance of the given class, or false." } },
				{ Name = "errorMessage", Type = "string", Nilable = true, Documentation = { "Error message if the variable was not an instance of the given class." } },
			},
		},
		{
			Name = "isOneOf",
			Type = "Function",
			Documentation = { [[Check if a variable value is one of the possible values.]] },

			Arguments = {
				{ Name = "variable", Type = "any", Documentation = { "Any kind of variable, to be tested for its content" } },
				{ Name = "possibleValues", Type = "table", Documentation = { "A table of the possible values accepted" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

			Returns = {
				{ Name = "isValid", Type = "boolean", Nilable = false, Documentation = { "true if the variable was one of the given values, or false." } },
				{ Name = "errorMessage", Type = "string", Nilable = true, Documentation = { "Error message if the variable was not one of the given values." } },
			},
		},
		{
			Name = "numberIsBetween",
			Type = "Function",
			Documentation = { [[Check if a variable is a number between a maximum and a minimum.]] },

			Arguments = {
				{ Name = "variable", Type = "number", Documentation = { "A number to check" } },
				{ Name = "minimum", Type = "number", Documentation = { "The minimum value for the number" } },
				{ Name = "maximum", Type = "number", Documentation = { "The maximum value for the number" } },
				{ Name = "variableName", Type = "string", Documentation = { "The name of the variable being tested, will be visible in the error message" } },
			},

			Returns = {
				{ Name = "isValid", Type = "boolean", Nilable = false, Documentation = { "true if the variable was a number between the boundaries, or false." } },
				{ Name = "errorMessage", Type = "string", Nilable = true, Documentation = { "Error message if the variable was not between the boundaries or was not a number." } },
			},
		},
	},
});
