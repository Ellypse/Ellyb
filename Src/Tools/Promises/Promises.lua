local Promise = require "Tools.Promises.Promise"

--- Helpers to handle one or more promises
local Promises = {}

--- Create a new promise that will gather all promises
---@vararg Ellyb_Promise
---@return Ellyb_Promise
function Promises.all(...)
	local promises = { ... }
	local allPromise = Promise()

	-- This table will hold the values of each Promise resolution
	local promisesResolutionArgs = {}

	for _, promise in pairs(promises) do
		-- If any of the promise fail, the we reject the promise
		promise:Fail(function(...)
			allPromise:Reject(...)
		end)

		promise:Success(function(...)
			table.insert(promisesResolutionArgs, { ... })
			local allPromisesHaveBeenFulfilled = true
			for _, otherPromise in ipairs(promises) do
				if not otherPromise:HasBeenFulfilled() then
					allPromisesHaveBeenFulfilled = false
				end
			end

			if allPromisesHaveBeenFulfilled then
				-- If all promises have been resolved, we resolve the allPromise with the table of all the resolutions values
				allPromise:Resolve(promisesResolutionArgs)
			end
		end)
	end

	return allPromise
end

return Promises