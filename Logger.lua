---@type Ellyb
local _, Ellyb = ...;

local format = string.format;
local insert = table.insert;
local tostring = tostring;
local pairs = pairs;

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb)

	---@class Logger : Object
	local Logger = Ellyb.class("Logger");
	Ellyb.Logger = Logger;

	-- Sets a private table used to store private attributes
	local _private = setmetatable({}, { __mode = "k" });

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

	local LOG_HEADER_FORMAT = "[%s]: ";
	function Logger:GetLogHeader()
		return format(LOG_HEADER_FORMAT, Ellyb.ColorManager.ORANGE(self:GetModuleName()));
	end

	function Logger:Log(...)
		local text = "";
		for _, arg in pairs({ ... }) do
			text = text .. tostring(arg) .. " ";
		end
		text = Ellyb.Logger.LOG_COLOR(text);
		text = self:GetLogHeader() .. text;
		insert(_private[self].logs, text);
	end

	local LogFrame = CreateFrame("FRAME", nil, UIParent, "Ellyb_LogsFrame");
	local Text = LogFrame.Scroll.Text;
	function Logger:Show()
		local text = "";
		for index, log in pairs(_private[self].logs) do
			local lineNumber = format("[%03d]", index);
			text = text .. Ellyb.ColorManager.GREY("[" .. lineNumber .. "]") .. log .. "\n";
		end
		Text:SetText(text);
		LogFrame:Show();
	end
end

Ellyb.ModulesManagement:RegisterNewModule("ColorManager", OnLoad);