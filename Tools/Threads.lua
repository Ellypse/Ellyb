---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- Lua imports
local coroutine = coroutine;
local pairs = pairs;
local newTicker = C_Timer.NewTicker;

local Threads = {};
Ellyb.Threads = Threads;

local DEFAULT_TICKER = 0.5;

C_Timer.NewTicker(0.5, function()
	for index, thread in pairs(threads) do
		if coroutine.status(thread) ~= "dead" then
			coroutine.resume(thread)
		else
			threads[index] = nil;
		end
	end
end)

---run
---@param func function
---@param optional ticks number
function Threads.run(func, ticks)
	local promise = Ellyb.Promise();
	local thread = Ellyb.Thread;

	thread:Execute(function()
		func(thread);
	end)

	local ticker;
	ticker = newTicker(ticks or DEFAULT_TICKER, function()
		if thread:HasFinished() then
			ticker:Cancel();
			promise:Resolve();
		elseif thread:IsSuspended() then
			thread:Resume();
		end
	end)

	return promise;
end