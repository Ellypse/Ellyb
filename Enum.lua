---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Enum then
	return
end

local Enum = {};
Ellyb.Enum = Enum;

Enum.CHARS = {
	NON_BREAKING_SPACE = " "
}

Enum.LOCALES = {
	FRENCH = "frFR",
	ENGLISH = "enUS",
}
