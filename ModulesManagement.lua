---@type Ellyb_PrivateAPI
local _, Ellyb_PrivateAPI = ...;

--- Modules Management
--- Handles the registration of the libraries modules
local ModulesManagement = {};
Ellyb_PrivateAPI.ModulesManagement = ModulesManagement;

local format = string.format;
local pairs = pairs;
local assert = assert;

local modules = {};
local onModulesLoadedCallbacks = {};

local MODULE_ALREADY_EXISTS_ERROR_MESSAGE = "A module named %s has already been registered. There cannot be two modules with the same name.";
---RegisterNewModule
---@param moduleName string @ The name of the module
---@param moduleDeclaration function @ A function to load the module
---@param optional onModulesLoaded function @ A callback that will be executed when all the modules have been loaded
function ModulesManagement:RegisterNewModule(moduleName, moduleDeclaration, onModulesLoaded)
	assert(not modules[moduleName], format(MODULE_ALREADY_EXISTS_ERROR_MESSAGE, moduleName));

	modules[moduleName] = moduleDeclaration;

	if onModulesLoaded then
		onModulesLoadedCallbacks[moduleName] = onModulesLoaded;
	end
end

--- Load a new instance of the registered modules into an instance of the library passed.
---@param libraryInstance Ellyb_PrivateAPI @ An instance of the Ellyb library
function ModulesManagement:LoadModules(libraryInstance)
	-- Create a private environment shared by both the moduleDeclaration and onModulesLoadedCallback
	-- So that onModulesLoadedCallbacks can instantiate variables in moduleDeclaration
	local privateEnvironments = {};

	for moduleName, moduleDeclaration in pairs(modules) do
		privateEnvironments[moduleName] = {};
		moduleDeclaration(libraryInstance, privateEnvironments[moduleName]);
	end

	for moduleName, onModulesLoadedCallback in pairs(onModulesLoadedCallbacks) do
		onModulesLoadedCallback(libraryInstance, privateEnvironments[moduleName]);
	end
end