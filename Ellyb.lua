local AddOnName = ...;

local VERSION_NUMBER = 1;
local DEBUG_MODE = true;
local instances = {};
local addonVersions = {};

---@class Ellyb
local Ellyb = setmetatable({}, {

	---@param self Ellyb
	__call = function(self, addOnName)
		self:GetInstance(addOnName);
	end

});

---Returns the version number of this instance of the library
---@return number versionNumber @ An integer representing the version number
function Ellyb:GetVersionNumber()
	return VERSION_NUMBER;
end

---Check if the debug mode of this instance of the library is enabled.
---The debug mode provides logs and run more assertions to help while working on the code.
---@return boolean debugModeIsEnabled @ Returns true if debug mode is enabled for this instance of the library
function Ellyb:IsDebugModeEnabled()
	return DEBUG_MODE;
end

---Set the debug mode of this instance of the library.
---The debug mode provides logs and run more assertions to help while working on the code.
---Disabling debug mode in production build will skip many assertions, meaning less overhead.
---@param enabled boolean @ The new status of the debug mode (default is false, disabled)
function Ellyb:SetDebugMode(enabled)
	DEBUG_MODE = enabled == true;
end

---Get the correct instance of the library corresponding to the add-on embedding the library.
---You can for example make sure you are using appropriate version of another add-on's Ellyb instance by getting their instance.
---Example: `local TRP3_Ellyb = Ellyb.GetInstance("totalRP3")`
---It also means you can use the file arguments from withing your add-on using this library to use the same Ellyb instance.
---Example: `local Ellyb = Ellyb.GetInstance(...)`
---@param addOnName string @ The name of the add-on using the library, as given to the Lua files by the game as an argument `local addOnName = ...`
---@return Ellyb Ellyb @ Instance of the library corresponding to that add-on.
function Ellyb:GetInstance(addOnName)
	if addonVersions[addOnName] then
		return instances[addonVersions[addOnName]];
	end
end

---Internal function necessary for versioning. Do not use.
---@param EllybInstance Ellyb @ Current instance of the library
function Ellyb:_Initialize(EllybInstance, addOnName)
	if not instances[EllybInstance:GetVersionNumber()] then
		instances[EllybInstance:GetVersionNumber()] = EllybInstance;
	end
	addonVersions[addOnName] = EllybInstance:GetVersionNumber();
end

---Internal function necessary for versioning. Do not use.
function Ellyb:_GetInstances()
	return instances;
end

---Internal function necessary for versioning. Do not use.
function Ellyb:_ImportInstances(EllybInstance)
	for k, v in pairs(EllybInstance:_GetInstances()) do
		instances[k] = v;
	end
end

-- If we are the first instance of the library
-- or something else than a valid Ellyb instance is using our spot
-- we register ourselves globally
if not _G.Ellyb or not _G.Ellyb.GetVersionNumber then
	_G.Ellyb = Ellyb;

-- If the globally declared instance of the library is older, we take over it
elseif _G.Ellyb:GetVersionNumber() < VERSION_NUMBER then
	-- Import all existing instances from the old one
	Ellyb:_ImportInstances(_G.Ellyb);
	_G.Ellyb = Ellyb;
end

-- Register this instance
_G.Ellyb:_Initialize(Ellyb, AddOnName);

function EllybTest()
	local lib = _G.Ellyb:GetInstance(AddOnName);

	local Logger = lib.Logger("test");

	lib.GameEvents.registerHandler("COMBAT_LOG_EVENT_UNFILTERED", function(...)
		Logger:Debug(...);
	end);
	Logger:Show();
end

