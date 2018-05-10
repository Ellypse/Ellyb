---@type Ellyb
local Ellyb = Ellyb(...);

-- Lua imports
local assert = assert;
local format = format;

-- We will remember if the locale is French or not, as French has some special cases we need to handle
-- local IS_FRENCH_LOCALE = _G.GetLocale() == "frFR";
local DEFAULT_LOCALE_CODE = "default";

---@class Localization
--- My own take on a localization system.
--- The main goal here was to achieve easy localization key completion in the code editor (loc.KEY)
local Localization, _private = Ellyb.Class("Localization");

Localization.DEFAULT_LOCALE_CODE = DEFAULT_LOCALE_CODE;

function Localization:initialize(defaultLocaleContent)
	_private[self] = {};

	_private[self].locales = {};
	self:RegisterNewLocale(DEFAULT_LOCALE_CODE, "Default", defaultLocaleContent);
	_private[self].currentLocaleCode = DEFAULT_LOCALE_CODE;
end

-- Flavour syntax: we can get the value for a key in the current locale using Localization.LOCALIZATION_KEY
function Localization:__index(localeKey)
	return self:GetText(localeKey);
end

-- Flavour syntax: we can add a value to the default locale using Localization.LOCALIZATION_KEY = "value"
function Localization:__newindex(key, value)
	if value then
		self:AddTextToDefaultLocale(key, value);
	end
end

function Localization:AddTextToDefaultLocale(key, value)
	self:GetLocale(DEFAULT_LOCALE_CODE):AddText(key, value);
end

-- We can also "call" the table itself with either the key as a string (.ie Localization("GEN_VERSION")
-- (this gives us backward compatibility with previous systems where we would call a function with keys as strings)
-- Or using the direct value of the locale (.ie Localization(Localization.GEN_VERSION)
-- (although this is less interesting)
--
-- We can even add more arguments to automatically apply a format (ie. Localization(Localization.GEN_VERSION, genVersion, genNumber))
function Localization:__call(localeKey, ...)
	local localeText = self:GetText(localeKey);

	-- If we were given more arguments, we want to format the value
	if #{ ... } > 0 then
		localeText = format(localeText, ...);
	end

	return localeText;
end

---Register a new locale into the localization system
---@param code string @ The code for the locale, must be one of the game's supported locale code
---@param name string @ The name of the locale, as could be displayed to the user
---@param optional content table<string, string> @ Content of the locale, a table with texts indexed with locale keys
---@return Locale locale
function Localization:RegisterNewLocale(code, name, content)
	assert(not _private[self].locales[code], format("A localization for %s has already been registered.", code));

	local locale = Ellyb.Locale(code, name, content);
	_private[self].locales[code] = locale;

	return _private[self].locales[code];
end

---getLocale
---@param code string
---@return Locale locale
function Localization:GetLocale(code)
	assert(_private[self].locales[code], format("Unknown locale %s.", code));

	return _private[self].locales[code];
end

---@param withoutDefaultLocale boolean @ Do not include the default localization in the result
---@return Locale[] locales @ The list of currently registered locales
function Localization:GetLocales(withoutDefaultLocale)
	local locales = {};

	for localeCode, locale in pairs(_private[self].locales) do
		if not (withoutDefaultLocale and  localeCode == DEFAULT_LOCALE_CODE) then
			locales[localeCode] = locale;
		end
	end

	return locales;
end

---@return Locale locale
function Localization:GetActiveLocale()
	return self:GetLocale(_private[self].currentLocaleCode);
end

---setCurrentLocale
---@param code string
---@param fallbackToDefault boolean @ If the specified locale doesn't exist, silently fail and fallback to default locale
function Localization:SetCurrentLocale(code, fallbackToDefault)
	if not fallbackToDefault then
		assert(_private[self].locales[code], format("Unknown locale %s.", code));
	end

	if _private[self].locales[code] then
		_private[self].currentLocaleCode = code;
	else
		self:SetCurrentLocale(self:GetDefaultLocale():GetCode(), false);
	end
end

---@return Locale defaultLocale
function Localization:GetDefaultLocale()
	return self:GetLocale(DEFAULT_LOCALE_CODE);
end

---@return string
function Localization:GetDefaultLocaleCode()
	return DEFAULT_LOCALE_CODE;
end

--- Check if the locale has a value for a localization key
---@return boolean doesExists
function Localization:KeyExists(localizationKey)
	return self:GetDefaultLocale():GetText(localizationKey) ~= nil;
end

--- Get the value of a localization key.
--- Will look for a localized value using the current localization, or a value in the default localization
--- or will just output the key as is if nothing was found.
---@param localizationKey string @ A localization key
function Localization:GetText(localizationKey)
	return self:GetActiveLocale():GetText(localizationKey) or -- Look in the currently active locale
		(self:GetLocale(DEFAULT_LOCALE_CODE) and self:GetLocale(DEFAULT_LOCALE_CODE):GetText(localizationKey)) or -- Look in the English locale from Curse
		self:GetDefaultLocale():GetText(localizationKey) or -- Look in the default locale
		localizationKey; -- As a last resort, to avoid nil strings, return the key itself
end

Ellyb.Localization = Localization;
