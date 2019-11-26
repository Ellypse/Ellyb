--- Private storage table, used to store private properties by indexing the table per instance of a class.
--- The table has weak indexes which means it will not prevent the objects from being garbage collected.
--- Example:
--- > `local private = require "Internals.PrivateStorage"`
--- > `local myClassInstance = MyClass()`
--- > `private[myClassInstance].privateProperty = someValue`
---@type table
local privateStorage = setmetatable({},{
	__index = function(store, instance) -- Remove need to initialize the private table for each instance, we lazy instantiate it
		store[instance] = {}
		return store[instance]
	end,
	__mode = "k", -- Weak table keys: allow stored instances to be garbage collected
	__metatable = "You are not allowed to access the metatable of this private storage",
})

return privateStorage