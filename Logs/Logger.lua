local addOnName = ...;
---@type Ellyb
local Ellyb = Ellyb(addOnName);

if Ellyb.Logger then
	return
end

-- Lua imports
local format = string.format;
local insert = table.insert;
local pairs = pairs;
local date = date;

-- Ellyb imports
local Log = Ellyb.Log;

---@class Logger : Object
local Logger, _private = Ellyb.Class("Logger");
Ellyb.Logger = Logger;

local LogFrame = CreateFrame("FRAME", nil, UIParent, "Ellyb_LogsFrame");
local Text = LogFrame.Scroll.Text;

Logger.LEVELS = {
	DEBUG = "DEBUG",
	INFO = "INFO",
	WARNING = "WARNING",
	SEVERE = "SEVERE",
}

---@return Color
local function getColorForLevel(level)
	if level == Logger.LEVELS.SEVERE then
		return Ellyb.ColorManager.RED;
	elseif level == Logger.LEVELS.WARNING then
		return Ellyb.ColorManager.ORANGE;
	elseif level == Logger.LEVELS.DEBUG then
		return Ellyb.ColorManager.CYAN;
	else
		return Ellyb.ColorManager.WHITE;
	end
end

--- Constructor
---@param moduleName string @ The name of the module initializing the Logger
function Logger:initialize(moduleName)
	_private[self] = {};
	_private[self].moduleName = moduleName;
	_private[self].logs = {};

	Ellyb.LogsManager:RegisterLogger(self);
	self:Info("Logger " .. moduleName .. " initialized.");
end

---@return string moduleName @ Returns the name of the Logger's module
function Logger:GetModuleName()
	return _private[self].moduleName;
end

local LOG_HEADER_FORMAT = "[%s - %s]: ";
function Logger:GetLogHeader(logLevel)
	local color = getColorForLevel(logLevel);
	return format(LOG_HEADER_FORMAT, Ellyb.ColorManager.ORANGE(self:GetModuleName()), color(logLevel));
end

function Logger:Log(level, ...)
	local log = Log(level, ...);
	insert(_private[self].logs, log);

	if LogFrame:IsShown() then
		self:Show();
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

function Logger:Show()
	---@type Log[]
	local logs = _private[self].logs;
	local text = "";
	for index, log in pairs(logs) do
		local logText = Ellyb.ColorManager.GREY(log:GetText());
		local logHeader = self:GetLogHeader(log:GetLevel());
		local timestamp = format("[%s]", date("%X", log:GetTimestamp()));
		text = text .. Ellyb.ColorManager.GREY(timestamp) .. logHeader .. logText .. "\n";
	end
	Text:SetText(text);
	LogFrame:Show();
end