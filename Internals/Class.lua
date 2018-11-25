---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Class then
	return
end

---@return table Private storage table, used to store private properties by indexing the table per instance of a class.
function Ellyb.getPrivateStorage()
	return AddOn_Lib_Middleclass.getPrivateStorage()
end

--- Create a new class
---@param name string The name of the class
---@param super string The name of a class to extend
---@overload fun(name:string):MiddleClass_Class, table
---@return MiddleClass_Class, table Returns the class newly created and a private table with a weak metatable
function Ellyb.Class(name, super)
	return AddOn_Lib_Middleclass(name, super), AddOn_Lib_Middleclass.getPrivateStorage()
end
