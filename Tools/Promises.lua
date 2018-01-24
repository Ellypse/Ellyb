---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- Lua imports
local pairs = pairs;

local Promises = {};
Ellyb.Promises = Promises;

---@param promises Promise[]
function Promises.all(promises)
	local allPromise = Ellyb.Promise();

	for _, promise in pairs(promises) do
		-- If any of the promise fail, the we reject the promise
		promise:Fail(function(...)
			allPromise:Reject(...);
		end)
	end

	return allPromise;
end