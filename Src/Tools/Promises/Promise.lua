local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local PooledObjectMixin = require "Internals.PooledObjectMixin"
local PromisesStatus = require "Tools.Promises.PromisesStatus"

---@class Promise : MiddleClass_Class
local Promise= Class("Promise")
Promise:include(PooledObjectMixin)

function Promise:initialize()
	private[self].status = PromisesStatus.PENDING

	private[self].onSuccessCallbacks = {}
	private[self].onFailCallbacks = {}
	private[self].onAlwaysCallbacks = {}
end

---@return number One of PromisesStatus
function Promise:GetStatus()
	return private[self].status
end

---@return boolean True if the Promise has ben fulfilled
function Promise:HasBeenFulfilled()
	return self:GetStatus() == PromisesStatus.FULFILLED
end

function Promise:Then(onSuccess, onFail, always)
	table.insert(private[self].onSuccessCallbacks, onSuccess)
	table.insert(private[self].onFailCallbacks, onFail)
	table.insert(private[self].onAlwaysCallbacks, always)

	if self:GetStatus() == PromisesStatus.FULFILLED then
		onSuccess(unpack(private[self].resolutionArgs))
	end

	if onFail and self:GetStatus() == PromisesStatus.REJECTED then
		onFail(unpack(private[self].resolutionArgs))
	end

	if always and (self:GetStatus() == PromisesStatus.REJECTED or self:GetStatus() == PromisesStatus.FULFILLED) then
		always(unpack(private[self].resolutionArgs))
	end

	return self
end

function Promise:Success(callback)
	table.insert(private[self].onSuccessCallbacks, callback)

	if self:GetStatus() == PromisesStatus.FULFILLED then
		callback(unpack(private[self].resolutionArgs))
	end

	return self
end

function Promise:Fail(callback)
	table.insert(private[self].onFailCallbacks, callback)

	if self:GetStatus() == PromisesStatus.REJECTED then
		callback(unpack(private[self].resolutionArgs))
	end

	return self
end

function Promise:Always(callback)
	table.insert(private[self].onAlwaysCallbacks, callback)

	if self:GetStatus() == PromisesStatus.REJECTED or self:GetStatus() == PromisesStatus.FULFILLED then
		callback(unpack(private[self].resolutionArgs))
	end

	return self
end

function Promise:Resolve(...)
	private[self].status = PromisesStatus.FULFILLED
	private[self].resolutionArgs = { ...}

	for _, callback in ipairs(private[self].onSuccessCallbacks) do
		callback(...)
	end

	for _, callback in ipairs(private[self].onAlwaysCallbacks) do
		callback(...)
	end

	return self
end

function Promise:Reject(...)
	if self:GetStatus() == PromisesStatus.REJECTED then
		return error("Trying to resolve a Promise that has already been rejected.")
	elseif self:GetStatus() == PromisesStatus.FULFILLED then
		return error("Trying to reject a Promise that has already been resolved.")
	end

	private[self].status = PromisesStatus.REJECTED

	for _, callback in ipairs(private[self].onFailCallbacks) do
		callback(...)
	end

	for _, callback in ipairs(private[self].onAlwaysCallbacks) do
		callback(...)
	end

	return self
end

return Promise
