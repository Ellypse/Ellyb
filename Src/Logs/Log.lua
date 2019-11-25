local Class = require "Libraries.middleclass"
local _private = require "Internals.PrivateStorage"
local Strings = require "Tools.Strings.Strings"

---@class Log
local Log = Class("Log");

function Log:initialize(level, ...)
	_private[self] = {};
	_private[self].date = time();
	_private[self].level = level;
	_private[self].args = { ... };
end

function Log:GetText()
	return Strings.convertTableToString(_private[self].args);
end

function Log:GetLevel()
	return _private[self].level;
end

function Log:GetTimestamp()
	return _private[self].date;
end

return Log