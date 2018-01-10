---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- Lua imports
local pairs = pairs;
local tostring = tostring;
local tConcat = table.concat;
local assert = assert;
local string = string;
local random = math.random;
local date = date;
local tinsert = table.insert;
local pcall = pcall;
local strtrim = strtrim;
local gsub = string.gsub;
local type = type;
local insert = table.insert;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;

---@class Strings
local Strings = {};
Ellyb.Strings = Strings;

---@param table table @ A table of element
---@param optional customSeparator string @ A custom separator to use to when concatenating the table (default is " ").
---@return string
function Strings.convertTableToString(table, customSeparator)
	assert(isType(table, "table", "table"));
	-- If the table is empty we will just return empty string
	if Ellyb.Tables.size(table) < 1 then
		return ""
	end
	-- If no custom separator was indicated we use " " as default
	if not customSeparator then
		customSeparator = " ";
	end
	-- Create a table of string values
	local toStringedMessages = {};
	for _, v in pairs(table) do
		insert(toStringedMessages, tostring(v));
	end
	-- Concat the table of string values with the separator
	return tConcat(toStringedMessages, customSeparator);
end

-- Only used for French related stuff, it's okay if non-latin characters are not here
-- Note: We have a list of lowercase and uppercase letters here, because string.lower doesn't
-- like accentuated uppercase letters at all, so we can't have just lowercase letters and apply a string.lower.
local VOWELS = { "a", "e", "i", "o", "u", "y", "A"; "E", "I", "O", "U", "Y", "À", "Â", "Ä", "Æ", "È", "É", "Ê", "Ë", "Î", "Ï", "Ô", "Œ", "Ù", "Û", "Ü", "Ÿ", "à", "â", "ä", "æ", "è", "é", "ê", "ë", "î", "ï", "ô", "œ", "ù", "û", "ü", "ÿ" };
VOWELS = tInvert(VOWELS); -- Invert the table so it is easier to check if something is a vowel

---@param letter string @ A single letter as a string (can be uppercase or lowercase)
---@return boolean isAVowel @ True if the letter is a vowel
function Strings.isAVowel(letter)
	assert(isType(letter, "string", "letter"));
	return VOWELS[letter] ~= nil;
end

---@param text string
---@return string letter @ The first letter in the string that was passed
function Strings.getFirstLetter(text)
	assert(isType(text, "string", "text"));
	return string.sub(text, 1, 1);
end

-- Build a list of characters that can be used to generate IDs
local ID_CHARS = {};
for i = 48, 57 do
	tinsert(ID_CHARS, string.char(i));
end
for i = 65, 90 do
	tinsert(ID_CHARS, string.char(i));
end
for i = 97, 122 do
	tinsert(ID_CHARS, string.char(i));
end
local sID_CHARS = #ID_CHARS;

---    Generate a pseudo-unique random ID.
--- If you encounter a collision, you really should playing lottery
---    ID's have a id_length characters length
---@return string ID @ Generated ID
function Strings.generateID()
	local ID = date("%m%d%H%M%S");
	for i = 1, 5 do
		ID = ID .. ID_CHARS[random(1, sID_CHARS)];
	end
	return ID;
end

--- A secure way to check if a String matches a pattern.
--- This is useful when using user-given pattern, as malformed pattern would produce lua error.
---@param stringToCheck string @ The string in which we will search for the pattern
---@param pattern string @ Lua matching pattern
---@return number foundIndex @ The index at which the string was found
function Strings.safeMatch(stringToCheck, pattern)
	local ok, result = pcall(string.find, string.lower(stringToCheck), string.lower(pattern));
	if not ok then
		return false; -- Syntax error.
	end
	-- string.find should return a number if the string matches the pattern
	return string.find(tostring(result), "%d");
end

--- Search if the string has the pattern in error-safe way.
--- Useful if the pattern his user written.
---@param text string @ The string to test
---@param pattern string @ The pattern to match
---@return boolean|nil matched @ Returns true if the pattern was matched in the given text
function Strings.safeFind(text, pattern)
	local trace = { pcall(string.find, text, pattern) };
	if trace[1] then
		return type(trace[2]) == "number";
	end
	return nil; -- Pattern error
end

--- Generate a pseudo-unique random ID while checking a table for possible collisions.
---@param table table @ A table where indexes are IDs generated via Strings.generateID
---@return string ID @ An ID that is not already used inside this table
function Strings.generateUniqueID(table)
	local ID = Strings.generateID();
	while table[ID] ~= nil do
		ID = Strings.generateID();
	end
	return ID;
end

--- Check if a text is an empty string and returns nil instead
---@param text string @ The string to check
---@return string|nil text @ Returns nil if the given text was empty
function Strings.emptyToNil(text)
	if text and #text > 0 then
		return text;
	end
	return nil;
end

--- Assure that the given string will not be nil
---@param text string|nil @ A string that could be nil
---@return string text @ Always return a string, empty string if the given text was nil
function Strings.nilToEmpty(text)
	return text or "";
end

local SANITIZATION_PATTERNS = {
	["|c%x%x%x%x%x%x%x%x"] = "", -- color start
	["|r"] = "", -- color end
	["|H.-|h(.-)|h"] = "%1", -- links
	["|T.-|t"] = "", -- textures
}

---Sanitize a given text, removing potentially harmful escape sequences that could have been added by a end user (to display huge icons in their tooltips, for example).
---@param text string @ A text that should be sanitized
---@return string sanitizedText @ The sanitized version of the given text
function Strings.sanitize(text)
	if not text then
		return
	end
	for k, v in pairs(SANITIZATION_PATTERNS) do
		text = gsub(text, k, v);
	end
	return text;
end

---Crop a string of text if it is longer than the given size, and append … to indicate that the text has been cropped by default.
---@param text string @ The string of text that will be cropped
---@param size number @ The number of characters at which the text will be cropped.
---@param optional appendEllipsisAtTheEnd boolean @ Indicates if ellipsis (…) should be appended at the end of the text when cropped (defaults to true)
---@return string croppedText @ The cropped version of the text if it was longer than the given size, or the untouched version if the text was shorter.
function Strings.crop(text, size, appendEllipsisAtTheEnd)
	if not text then
		return
	end

	assert(isType(size, "number", "size"));
	assert(size > 0, "Size has to be a positive number.");

	if appendEllipsisAtTheEnd == nil then
		appendEllipsisAtTheEnd = true;
	end

	text = strtrim(text or "");
	if text:len() > size then
		text = text:sub(1, size);
		if appendEllipsisAtTheEnd then
			text = text .. "…";
		end
	end
	return text
end

function Strings.clickInstruction(click, text)
	return Ellyb.ColorManager.ORANGE(click) .. ": " .. text;
end