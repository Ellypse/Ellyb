---@type Ellyb_Class
local Class = LibStub:GetLibrary("Ellyb_Class");

---@class Ellyb_Log
local Ellyb_Log, _private = Class("Ellyb_Log");

function Ellyb_Log:initialize()
	_private[self] = {};
end

function Ellyb_Log:SetLevel(level)
	_private[self].level = level;
end

