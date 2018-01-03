---@type Ellyb
local _, Ellyb = ...;

local format = string.format;
local insert = table.insert;
local tostring = tostring;
local pairs = pairs;
local time = time;

---@class Log : Object
local Log = Ellyb.class("Log");

function Log:initialize(level, ...)
	self.args = { ... };
	self.date = time();
	self.level = level;
end

function Log:GetText()
	local text = "";
	for _, arg in pairs(self.args) do
		text = text .. tostring(arg) .. " ";
	end
	return text;
end


---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb)

	---@class Logger : Object
	local Logger = Ellyb.class("Logger");
	Ellyb.Logger = Logger;

	local LogFrame = CreateFrame("FRAME", nil, UIParent, "Ellyb_LogsFrame");
	local Text = LogFrame.Scroll.Text;

	-- Sets a private table used to store private attributes
	local _private = setmetatable({}, { __mode = "k" });

	Logger.LEVELS = {
		DEBUG = "DEBUG",
		INFO = "INFO",
		WARNING = "WARNING",
		SEVERE = "SEVERE",
	}

	--- Constructor
	---@param moduleName string @ The name of the module initializing the Logger
	function Logger:initialize(moduleName)
		_private[self] = {};
		_private[self].moduleName = moduleName;
		_private[self].logs = {};
	end

	---@return string moduleName @ Returns the name of the Logger's module
	function Logger:GetModuleName()
		return _private[self].moduleName;
	end

	local LOG_HEADER_FORMAT = "[%s - %S]: ";
	function Logger:GetLogHeader(logLevel)
		return format(LOG_HEADER_FORMAT, Ellyb.ColorManager.ORANGE(self:GetModuleName()), logLevel);
	end

	function Logger:Log(level, ...)
		local log = Log(level, ...);
		insert(_private[self].logs, log);
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
		---@type Logs[]
		local logs = _private[self].logs;
		local text = "";
		for index, log in pairs(logs) do
			local logText = Ellyb.ColorManager.GREY(log:GetText());
			local logHeader = self:GetLogHeader(log.level);
			local lineNumber = format("[%03d]", index);
			text = text .. Ellyb.ColorManager.GREY("[" .. lineNumber .. "]") .. logHeader .. logText .. "\n";
		end
		Text:SetText(text);
		LogFrame:Show();
	end
end

Ellyb.ModulesManagement:RegisterNewModule("ColorManager", OnLoad);