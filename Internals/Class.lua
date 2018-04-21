---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Class then
	return
end

-- Lua imports
local setmetatable = setmetatable;

local PRIVATE_METATABLE = { __mode = "k" };

--- Create a new class
---@param name string @ The name of the class
---@param optional super string @ The name of a class to extend
---@return Object, table newClass, privateTable @ Returns the class newly created and a private table with a weak metatable
function Ellyb.Class(name, super)
	local newClass = Ellyb.middleclass.class(name, super);
	local classPrivateTable = setmetatable({}, PRIVATE_METATABLE);

	return newClass, classPrivateTable;
end