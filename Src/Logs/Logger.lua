local Class = require "Libraries.middleclass"
local _private = require "Internals.PrivateStorage"
local ColorManager = require "Tools.ColorManager"
local Log = require "Logs.Log"
local config = require "EllybConfiguration"

---@class Logger : MiddleClass
local Logger = Class("Logger");

Logger.LEVELS = {
	DEBUG = "DEBUG",
	INFO = "INFO",
	WARNING = "WARNING",
	SEVERE = "SEVERE",
}

---@return Ellyb_Color
local function getColorForLevel(level)
	if level == Logger.LEVELS.SEVERE then
		return ColorManager.RED;
	elseif level == Logger.LEVELS.WARNING then
		return ColorManager.ORANGE;
	elseif level == Logger.LEVELS.DEBUG then
		return ColorManager.CYAN;
	else
		return ColorManager.WHITE;
	end
end

--- Constructor
---@param moduleName string @ The name of the module initializing the Logger
function Logger:initialize(moduleName)
	_private[self] = {};
	_private[self].moduleName = moduleName;

	local LogsManager = require "Logs.LogsManager"
	LogsManager:RegisterLogger(self);
	self:Info("Logger " .. moduleName .. " initialized.");
end

---@return string moduleName @ Returns the name of the Logger's module
function Logger:GetModuleName()
	return _private[self].moduleName;
end

local LOG_HEADER_FORMAT = "[%s - %s]: ";
function Logger:GetLogHeader(logLevel)
	local color = getColorForLevel(logLevel);
	return format(LOG_HEADER_FORMAT, ColorManager.ORANGE(self:GetModuleName()), color(logLevel));
end

function Logger:Log(level, ...)
	if not config.DEBUG_MODE then
		return;
	end

	local ChatFrame;
	for i = 0, NUM_CHAT_WINDOWS do
		if GetChatWindowInfo(i) == "Logs" then
			ChatFrame = _G["ChatFrame"..i]
		end
	end

	local log = Log(level, ...);
	local logText = log:GetText();
	local logHeader = self:GetLogHeader(log:GetLevel());
	local timestamp = format("[%s]", date("%X", log:GetTimestamp()));
	local message = ColorManager.GREY(timestamp) .. logHeader .. logText;
	if ChatFrame and log:GetLevel() ~= self.LEVELS.WARNING and log:GetLevel() ~= self.LEVELS.SEVERE then
		ChatFrame:AddMessage(message)
	else
		print(message)
	end
end

function Logger:Debug(...)
	self:Log(self.LEVELS.DEBUG, ...);
end

function Logger:Info(...)
	self:Log(self.LEVELS.INFO, ...);
end

function Logger:Warning(...)
	self:Log(self.LEVELS.WARNING, ...);
end

function Logger:Severe(...)
	self:Log(self.LEVELS.SEVERE, ...);
end

return Logger
