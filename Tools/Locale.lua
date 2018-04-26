---@type Ellyb
local Ellyb = Ellyb(...);

-- Lua imports
local assert = assert;
local pairs = pairs;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

---@class Locale
local Locale, _private = Ellyb.Class("Locale");

---Constructor
---@param code string @ The code for the locale, must be one of the game's supported locale code
---@param name string @ The name of the locale, as could be displayed to the user
---@param optional content table<string, string> @ Content of the locale, a table with texts indexed with locale keys
function Locale:initialize(code, name, content)
	assert(isType(code, "string", "code"));
	assert(isType(name, "string", "name"));

	_private[self] = {};

	_private[self].code = code;
	_private[self].name = name;
	_private[self].content = {};

	-- If the content of the locale was passed to the constructor, we add the content to the locale
	if content then
		self:AddTexts(content);
	end
end

-- Flavour syntax: we can add new values to the locale by adding them directly to the object Locale.LOCALIZATION_KEY = "value
function Locale:__newindex(key, value)
	self:AddText(key, value);
end

-- Flavour syntax: we can get the value for a key in the locale using Locale.LOCALIZATION_KEY
function Locale:__index(localeKey)
	return self:GetText(localeKey);
end

---@return string localeCode
function Locale:GetCode()
	return _private[self].code;
end

---@return string localeName
function Locale:GetName()
	return _private[self].name;
end

---Get the localization value for this locale corresponding to the given localization key
---@param localizationKey string
---@return string text
function Locale:GetText(localizationKey)
	assert(isType(localizationKey,"string", "localizationKey"));

	return _private[self].content[localizationKey];
end

---Add a new localization value to the locale
---@param localizationKey string
---@param value string
function Locale:AddText(localizationKey, value)
	assert(isType(localizationKey, "string", "localizationKey"));
	assert(isType(value, "string", "value"));

	_private[self].content[localizationKey] = value;
end

--- Add a table of localization texts to the locale
---@param localeTexts table<string, string>
function Locale:AddTexts(localeTexts)
	assert(isType(localeTexts, "table", "localeTexts"));

	for localizationKey, value in pairs(localeTexts) do
		self:AddText(localizationKey, value);
	end
end

--- Check if the locale has a value for a localization key
---@return boolean doesExists
function Locale:LocalizationKeyExists(localizationKey)
	return self:GetText(localizationKey) ~= nil;
end

Ellyb.Locale = Locale;
