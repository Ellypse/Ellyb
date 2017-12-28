---@class Ellyb
local _, Ellyb = ...;


---@return Ellyb
function _G.Ellyb()
   return CreateFromMixins(Ellyb);
end

do
    local format = string.format;
    ---@class Logger : Object
    local Logger = Ellyb.class("Logger");
    local _private = setmetatable({}, { __mode = "k" });

    function Logger:initialize(moduleName)
        _private[self] = {};
        _private[self].moduleName = moduleName;
        _private[self].logs = {};
    end

    function Logger:GetModuleName()
        return _private[self].moduleName;
    end

    local LOG_HEADER_FORMAT = "[%s]:"
    function Logger:GetLogHeader()
        return format(LOG_HEADER_FORMAT, Ellyb.ColorManager.ORANGE(self:GetModuleName()));
    end

    function Logger:Log(...)
        local text = self:GetLogHeader() .. " ";
        for _, arg in pairs({...}) do
            text = text .. tostring(arg) .. " ";
        end
        table.insert(_private[self].logs, text);
    end

    local LogFrame = Ellyb_LogsFrame;
    local Text = Ellyb_LogsFrame.Scroll.Text;
    function Logger:Show()
        local text = "";
        for index, log in pairs(_private[self].logs) do
            local lineNumber = format("%03d", index);
            text = text .. Ellyb.ColorManager.GREY("[" .. lineNumber .. "]").. log .. "\n";
        end
        Text:SetText(text);
        LogFrame:Show();
    end

    Ellyb.Logger = Logger;
end

function Ellyb:Test()
    local Logger = self.Logger("Tests");
    for i = 0, 100 do
        Logger:Log("This is a test", i, true, { r = 1 }, self.ColorManager.TWITTER);
    end

    Logger:Show();
end

