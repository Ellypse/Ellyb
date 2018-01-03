---@class Ellyb
local _, Ellyb = ...;

local CreateFromMixins = CreateFromMixins;

---Ellyb mixin, with fields that should be included with every instance of the library
---@type Ellyb
local EllybMixin = {};

EllybMixin.DEBUG_MODE = true;
EllybMixin.class = Ellyb.class;

local instancesPerAddOns = {};

---Get a new instance of the library for the given add-on
---Will create a new instance if there isn't one yet, or return the existing instance if one was created previously.
---If no name is given, an anonymous instance will be created every time.
---@return Ellyb
---@param optional addonName string @ The name of the add-on using the library.
function _G.Ellyb(addonName)
	local newLibraryInstance;
	if addonName then
		if not instancesPerAddOns[addonName] then
			newLibraryInstance = CreateFromMixins(EllybMixin);
			Ellyb.ModulesManagement:LoadModules(newLibraryInstance);
			instancesPerAddOns[addonName] = newLibraryInstance;
		else
			newLibraryInstance = instancesPerAddOns[addonName];
		end
	else
		newLibraryInstance = CreateFromMixins(EllybMixin);
		Ellyb.ModulesManagement:LoadModules(newLibraryInstance);
	end
	return newLibraryInstance;
end

function EllybTest()

	local lib = _G.Ellyb("Test");

	local Logger = lib.Logger("Test");
	for i = 0, 100 do
		Logger:Log("This is a test", i, true, { r = 1 }, lib.ColorManager.TWITTER);
	end

	Logger:Show();
end

