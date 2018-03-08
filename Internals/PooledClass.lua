---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.PooledClass then
	return
end

-- Lua imports
local next = next;

---@class PooledClass
--- The implementation is an idea from Meorawr.
--- A static pool of instances is maintained and used for reusability.
--- When instantiating a new PooledClass, we will look for existing instances that are available and reuse those.
--- The instance should be released when no longer used.
local PooledClass, _private = Ellyb.Class("PooledClass");

--- Allocation pool for reusable instances.
PooledClass.static.pool = setmetatable({}, { __mode = "k" });

--- Original allocator that we haven't hooked.
PooledClass.static.defaultAllocator = PooledClass.static.allocate;

--- Custom allocator that pools instances of this class for reuse.
function PooledClass.static:allocate()
	local item = next(self.pool);
	if not item then
		item = self.static:defaultAllocator();

	end

	self.pool[item] = nil;
	return item;
end

--- Releases the instance, placing it back in the allocation pool.
function PooledClass:ReleasePooledClass()
	self.static.pool[self] = true;
end

Ellyb.PooledClass = PooledClass;