---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

---@class Thread : Object
local Thread, _private = Ellyb.Class("Thread");

function Thread:initialize()
	_private[self] = {};
end

function Thread:Execute(func)
	_private[self].thread = coroutine.create(func);
end

function Thread:GetStatus()
	return coroutine.status(_private[self].thread);
end

function Thread:IsRunning()
	return self:GetStatus() == "running";
end

function Thread:IsSuspended()
	return self:GetStatus() == "suspended";
end

function Thread:HasFinished()
	return self:GetStatus() == "dead";
end

function Thread:Yield()
	coroutine.yield();
end

function Thread:Resume()
	coroutine.resume(_private[self].thread);
end

Ellyb.Thread = Thread;