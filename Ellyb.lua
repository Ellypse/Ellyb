---@class Ellyb
local _, Ellyb = ...;

---@type Ellyb
local EllybMixin = {};

EllybMixin.DEBUG_MODE = true;
EllybMixin.class = Ellyb.class;

---@return Ellyb
function _G.Ellyb()
    local newLibraryInstance = CreateFromMixins(EllybMixin);
    Ellyb.ModulesManagement:LoadModules(newLibraryInstance);
    return newLibraryInstance;
end

function Ellyb:Test()

    local lib = _G.Ellyb();

    local Logger = lib.Logger("Test");
    for i = 0, 100 do
        Logger:Log("This is a test", i, true, { r = 1 }, lib.ColorManager.TWITTER);
    end

    Logger:Show();
end

