local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"

---@class Thread : MiddleClass_Class
local Thread = Class("Thread")

--- Execute the given function inside the thread.
--- The given function should use `Thread:Yield()` to pause its execution
---@param func function
function Thread:Execute(func)
	private[self].thread = coroutine.create(func)
end

function Thread:GetStatus()
	return coroutine.status(private[self].thread)
end

function Thread:IsRunning()
	return self:GetStatus() == "running"
end

function Thread:IsSuspended()
	return self:GetStatus() == "suspended"
end

function Thread:HasFinished()
	return self:GetStatus() == "dead"
end

--- Pause the current thread execution
function Thread:Yield()
	coroutine.yield()
end

--- Resume the thread execution
function Thread:Resume()
	coroutine.resume(private[self].thread)
end

return Thread