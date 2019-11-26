local Class = require "Libraries.middleclass"
local _private = require "Internals.PrivateStorage"

---@class Ellyb_Log
local Log = Class("Log")

function Log:initialize(level, ...)
	_private[self] = {}
	_private[self].date = time()
	_private[self].level = level
	_private[self].args = { ... }
end

function Log:GetText()
	return table.concat(_private[self].args, "\n")
end

function Log:GetLevel()
	return _private[self].level
end

function Log:GetTimestamp()
	return _private[self].date
end

return Log