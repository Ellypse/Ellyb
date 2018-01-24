---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- Lua imports
local insert = table.insert;
local pairs = pairs;

---@class Promise : Object
local Promise, _private = Ellyb.Class("Promise");

function Promise:initialize()
	_private[self] = {};
	_private[self].status = 0;

	_private[self].onSuccessCallbacks = {};
	_private[self].onFailCallbacks = {};
	_private[self].onAlwaysCallbacks = {};
end

function Promise:Then(onSuccess, onFail, always)
	insert(_private[self].onSuccessCallbacks, onSuccess);
	insert(_private[self].onFailCallbacks, onFail);
	insert(_private[self].onAlwaysCallbacks, always);
end

function Promise:Success(callback)
	insert(_private[self].onSuccessCallbacks, callback);
end

function Promise:Fail(callback)
	insert(_private[self].onFailCallbacks, callback);
end

function Promise:Always(callback)
	insert(_private[self].onAlwaysCallbacks, callback);
end

function Promise:Resolve(...)
	if _private[self].status ~= 0 then
		error()
	end
	for _, callback in pairs(_private[self].onSuccessCallbacks) do
		callback(...);
	end
	for _, callback in pairs(_private[self].onAlwaysCallbacks) do
		callback(...);
	end
end

function Promise:Reject(...)
	for _, callback in pairs(_private[self].onFailCallbacks) do
		callback(...);
	end
	for _, callback in pairs(_private[self].onAlwaysCallbacks) do
		callback(...);
	end
end

Ellyb.Promise = Promise;