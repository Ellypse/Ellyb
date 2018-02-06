---@type Ellyb
local Ellyb = Ellyb(...);

-- Lua imports
local assert = assert;
local pairs = pairs;
local insert = table.insert;
local format = format;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;
local isOneOf = Ellyb.Assertions.isOneOf;

---@class Localization
--- My own take on a localization system.
--- The main goal here was to achieve easy localization key completion in the code editor (loc.KEY)
local Localization = {};
setmetatable(Localization, {

-- Flavour syntax: we can get the value for a key in the current locale using Localization.LOCALIZATION_KEY
	__index = function(_, localeKey)
		return Localization.getText(localeKey);
	end,

	-- We can also "call" the table itself with either the key as a string (.ie Localization("GEN_VERSION")
	-- (this gives us backward compatibility with previous systems where we would call a function with keys as strings)
	-- Or using the direct value of the locale (.ie Localization(Localization.GEN_VERSION)
	-- (although this is less interesting)
	--
	-- We can even add more arguments to automatically apply a format (ie. Localization(Localization.GEN_VERSION, genVersion, genNumber))
	__call = function(table, localeKey, ...)
		local localeText = Localization.getText(localeKey);

		-- If we were given more arguments, we want to format the value
		if #{ ... } > 0 then
			localeText = format(localeText, ...);
		end

		return localeText;
	end
})


-- We will remember if the locale is French or not, as French has some special cases we need to handle
local IS_FRENCH_LOCALE = GetLocale() == "frFR";
local DEFAULT_LOCALE_CODE = "enUS";

local VALID_LOCALE_CODES = {};

for localeKey, _ in pairs(LanguageRegions) do
	insert(VALID_LOCALE_CODES, localeKey);
end

local locales = {};
local currentLocaleCode = DEFAULT_LOCALE_CODE;

function Localization.getValidLocaleCodes()
	return VALID_LOCALE_CODES;
end

---Set the default locale to use as a fallback for unlocalized strings
---@param localeCode string @ The locale code that will be considered as the default locale
function Localization.setDefaultLocaleCode(localeCode)
	assert(isType(localeCode, "string", "localeCode"));
	assert(isOneOf(localeCode, Localization.getValidLocaleCodes(), "localeCode"));

	DEFAULT_LOCALE_CODE = localeCode;
end

---Register a new locale into the localization system
---@param code string @ The code for the locale, must be one of the game's supported locale code
---@param name string @ The name of the locale, as could be displayed to the user
---@param optional content table<string, string> @ Content of the locale, a table with texts indexed with locale keys
---@return Locale locale
function Localization.registerNewLocale(code, name, content)
	assert(not locales[code], format("A localization for %s has already been registered.", code));

	local locale = Ellyb.Locale(code, name, content);
	locales[code] = locale;

	return locales[code];
end

---getLocale
---@param code string
---@return Locale locale
function Localization.getLocale(code)
	assert(locales[code], format("Unknown locale %s.", code));

	return locales[code];
end

---@return Locale locale
function Localization.getActiveLocale()
	return Localization.getLocale(currentLocaleCode);
end

---setCurrentLocale
---@param code string
function Localization.setCurrentLocale(code)
	assert(locales[code], format("Unknown locale %s.", code));

	currentLocaleCode = code;
end

---@return Locale defaultLocale
function Localization.getDefaultLocale()
	return Localization.getLocale(DEFAULT_LOCALE_CODE);
end

--- Check if the locale has a value for a localization key
---@return boolean doesExists
function Localization.KeyExists(localizationKey)
	return Localization.getDefaultLocale():GetText(localizationKey) ~= nil;
end

--- Get the value of a localization key.
--- Will look for a localized value using the current localization, or a value in the default localization
--- or will just output the key as is if nothing was found.
---@param localizationKey string @ A localization key
function Localization.getText(localizationKey)
	return Localization.getActiveLocale():GetText(localizationKey) or Localization:getDefaultLocale():GetText(localizationKey) or localizationKey;
end

Ellyb.Localization = Localization;