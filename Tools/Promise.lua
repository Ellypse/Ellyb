---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- Lua imports
local insert = table.insert;
local pairs = pairs;
local error = error;

---@class Promise : Object
local Promise, _private = Ellyb.Class("Promise");
Promise:include(Ellyb.PooledObjectMixin);

function Promise:initialize()
	_private[self] = {};
	_private[self].status = Ellyb.Promises.STATUS.PENDING;

	_private[self].onSuccessCallbacks = {};
	_private[self].onFailCallbacks = {};
	_private[self].onAlwaysCallbacks = {};
end

---@return number promiseStatus @ One of Ellyb.Promises.STATUS
function Promise:GetStatus()
	return _private[self].status;
end

---@return boolean hasBeenFulfilled @ True if the Promise has ben fulfilled
function Promise:HasBeenFulfilled()
	return self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED;
end

function Promise:Then(onSuccess, onFail, always)
	insert(_private[self].onSuccessCallbacks, onSuccess);
	insert(_private[self].onFailCallbacks, onFail);
	insert(_private[self].onAlwaysCallbacks, always);

	if self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		onSuccess(unpack(_private[self].resolutionArgs));
	end

	if onFail and self:GetStatus() == Ellyb.Promises.STATUS.REJECTED then
		onFail(unpack(_private[self].resolutionArgs));
	end

	if always and (self:GetStatus() == Ellyb.Promises.STATUS.REJECTED or self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED) then
		always(unpack(_private[self].resolutionArgs));
	end

	return self;
end

function Promise:Success(callback)
	insert(_private[self].onSuccessCallbacks, callback);

	if self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		callback(unpack(_private[self].resolutionArgs));
	end

	return self;
end

function Promise:Fail(callback)
	insert(_private[self].onFailCallbacks, callback);

	if self:GetStatus() == Ellyb.Promises.STATUS.REJECTED then
		callback(unpack(_private[self].resolutionArgs));
	end

	return self;
end

function Promise:Always(callback)
	insert(_private[self].onAlwaysCallbacks, callback);

	if self:GetStatus() == Ellyb.Promises.STATUS.REJECTED or self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		callback(unpack(_private[self].resolutionArgs));
	end

	return self;
end

function Promise:Resolve(...)
	if self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		-- Promise has already been resolved, ignore new resolution
		-- TODO Log? Warn? Something?
		return
	elseif self:GetStatus() == Ellyb.Promises.STATUS.REJECTED then
		return error("Trying to resolve a Promise that has already been rejected.");
	end

	_private[self].status = Ellyb.Promises.STATUS.FULFILLED;
	_private[self].resolutionArgs = {...};

	for _, callback in pairs(_private[self].onSuccessCallbacks) do
		callback(...);
	end

	for _, callback in pairs(_private[self].onAlwaysCallbacks) do
		callback(...);
	end

	return self;
end

function Promise:Reject(...)
	if self:GetStatus() == Ellyb.Promises.STATUS.REJECTED then
		-- Promise has already been rejected, ignore new resolution
		-- TODO Log? Warn? Something?
		return
	elseif self:GetStatus() == Ellyb.Promises.STATUS.FULFILLED then
		return error("Trying to reject a Promise that has already been resolved.");
	end

	_private[self].status = Ellyb.Promises.STATUS.REJECTED;

	for _, callback in pairs(_private[self].onFailCallbacks) do
		callback(...);
	end

	for _, callback in pairs(_private[self].onAlwaysCallbacks) do
		callback(...);
	end

	return self;
end

Ellyb.Promise = Promise;