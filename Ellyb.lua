---@class Ellyb
local _, Ellyb = ...;

local CreateFromMixins = CreateFromMixins;

---Ellyb mixin, with fields that should be included with every instance of the library
---@type Ellyb
local EllybMixin = {};

EllybMixin.DEBUG_MODE = true;
EllybMixin.class = Ellyb.class;
EllybMixin.addOnName = UNKNOWN;

local instancesPerAddOns = {};

---Get a new instance of the library for the given add-on
---Will create a new instance if there isn't one yet, or return the existing instance if one was created previously.
---If no name is given, an anonymous instance will be created every time.
---@return Ellyb
---@param optional addOnName string @ The name of the add-on using the library.
function _G.Ellyb(addOnName)
	local newLibraryInstance;
	if addOnName then
		if not instancesPerAddOns[addOnName] then
			---@type Ellyb
			newLibraryInstance = CreateFromMixins(EllybMixin);
			newLibraryInstance.addOnName = addOnName;
			Ellyb.ModulesManagement:LoadModules(newLibraryInstance);
			instancesPerAddOns[addOnName] = newLibraryInstance;
		else
			newLibraryInstance = instancesPerAddOns[addOnName];
		end
	else
		newLibraryInstance = CreateFromMixins(EllybMixin);
		Ellyb.ModulesManagement:LoadModules(newLibraryInstance);
	end
	return newLibraryInstance;
end

function EllybTest()

	local lib = _G.Ellyb("Test");

	local Popups = lib.Popups;

	Popups:OpenURL("http://www.google.fr");
end

