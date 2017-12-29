---@type Ellyb
local _, Ellyb = ...;

-- WoW imports
local tonumber = tonumber;
local lenght = string.len;
local gsub = string.gsub;
local sub = string.sub;
local assert = assert;

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb)
	---@class ColorManager
	--- Used for Color related operations and managing a palette of predefined Colors
	local ColorManager = {};
	Ellyb.ColorManager = ColorManager;

	---Converts color bytes into bits, from a 0-255 range to 0-1 range.
	---@param red number @ Between 0 and 255
	---@param green number @ Between 0 and 255
	---@param blue number @ Between 0 and 255
	---@param optional alpha number @ Between 0 and 255
	---@return number, number, number, number
	function ColorManager.convertColorBytesToBits(red, green, blue, alpha)
		if alpha == nil then
			alpha = 255;
		end

		return red / 255, green / 255, blue / 255, alpha / 255;
	end

	--- Extracts RGB values (255 based) from an hexadecimal code
	---@param hexadecimalCode string @ An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`, `|cffbababa`)
	---@return number, number, number red, green, blue
	function ColorManager.hexaToNumber(hexadecimalCode)
		local red, green, blue, alpha;

		-- We make sure we remove possible prefixes
		hexadecimalCode = gsub(hexadecimalCode, "#", "");
		hexadecimalCode = gsub(hexadecimalCode, "|c", "");

		local hexadecimalCodeLength = lenght(hexadecimalCode);

		if hexadecimalCodeLength == 3 then
			-- #FFF
			local r = sub(hexadecimalCode, 1, 1);
			local g = sub(hexadecimalCode, 2, 2);
			local b = sub(hexadecimalCode, 3, 3);
			red = tonumber(r .. r, 16)
			green = tonumber(g .. g, 16)
			blue = tonumber(b .. b, 16)
		elseif hexadecimalCodeLength == 6 then
			-- #FAFAFA
			red = tonumber(sub(hexadecimalCode, 1, 2), 16)
			green = tonumber(sub(hexadecimalCode, 3, 4), 16)
			blue = tonumber(sub(hexadecimalCode, 5, 6), 16)
		elseif hexadecimalCodeLength == 8 then
			-- #ffbababa
			alpha = tonumber(sub(hexadecimalCode, 1, 2), 16)
			red = tonumber(sub(hexadecimalCode, 3, 4), 16)
			green = tonumber(sub(hexadecimalCode, 5, 6), 16)
			blue = tonumber(sub(hexadecimalCode, 7, 8), 16)
		end

		return self.convertColorBytesToBits(red, green, blue, alpha);
	end

	--- Get the associated Color for the given class.
	--- This function always creates a new Color that can be mutated (unlike the Color constants)
	--- It will fetch the color from the RAID_CLASS_COLORS global table and will reflect any changes made to the table.
	---@param class string @ A valid class ("HUNTER", "DEATHKNIGHT")
	---@return Color color @ The Color corresponding to the class
	function ColorManager.getClassColor(class)
		if RAID_CLASS_COLORS[class] then
			return Ellyb.Color(RAID_CLASS_COLORS[class]);
		end
	end

	--- Get the chat color associated to a specified channel in the settings
	--- It will fetch the color from the ChatTypeInfo global table and will reflect any changes made to the table.
	---@param channel string @ A chat channel ("WHISPER", "YELL", etc.)
	---@return Color chatColor
	function ColorManager.getChatColorForChannel(channel)
		assert(ChatTypeInfo[channel], "Trying to get chat color for an unknown channel type: " .. channel);
		return Ellyb.Color(ChatTypeInfo[channel]);
	end

end

---@param Ellyb Ellyb @ Instance of the library
local function OnModulesLoaded(Ellyb)

	---@type ColorManager
	local ColorManager = Ellyb.ColorManager;
	local Color = Ellyb.Color;

	-- We create a bunch of common Color constants to be quickly available everywhere
	-- The Colors are :Freeze()d so they can't be altered

	-- Common colors
	ColorManager.ORANGE = Color(255, 153, 0):Freeze();
	ColorManager.WHITE = Color(1, 1, 1):Freeze();
	ColorManager.YELLOW = Color(1, 0.75, 0):Freeze();
	ColorManager.CYAN = Color(0, 1, 1):Freeze();
	ColorManager.BLUE = Color(0, 0, 1):Freeze();
	ColorManager.GREEN = Color(0, 1, 0):Freeze();
	ColorManager.RED = Color(1, 0, 0):Freeze();
	ColorManager.PURPLE = Color(1, 0, 1):Freeze();
	ColorManager.BLACK = Color(0, 0, 0):Freeze();
	ColorManager.GREY = Color("#CCC"):Freeze();

	-- Classes colors
	ColorManager.HUNTER = Color(RAID_CLASS_COLORS.HUNTER):Freeze();
	ColorManager.WARLOCK = Color(RAID_CLASS_COLORS.WARLOCK):Freeze();
	ColorManager.PRIEST = Color(RAID_CLASS_COLORS.PRIEST):Freeze();
	ColorManager.PALADIN = Color(RAID_CLASS_COLORS.PALADIN):Freeze();
	ColorManager.MAGE = Color(RAID_CLASS_COLORS.MAGE):Freeze();
	ColorManager.ROGUE = Color(RAID_CLASS_COLORS.ROGUE):Freeze();
	ColorManager.DRUID = Color(RAID_CLASS_COLORS.DRUID):Freeze();
	ColorManager.SHAMAN = Color(RAID_CLASS_COLORS.SHAMAN):Freeze();
	ColorManager.WARRIOR = Color(RAID_CLASS_COLORS.WARRIOR):Freeze();
	ColorManager.DEATHKNIGHT = Color(RAID_CLASS_COLORS.DEATHKNIGHT):Freeze();
	ColorManager.MONK = Color(RAID_CLASS_COLORS.MONK):Freeze();
	ColorManager.DEMONHUNTER = Color(RAID_CLASS_COLORS.DEMONHUNTER):Freeze();

	-- Brand colors
	ColorManager.TWITTER = Color("#1da1f2"):Freeze();
	ColorManager.BATTLE_NET = Color(FRIENDS_BNET_NAME_COLOR):Freeze();

	-- Item colors
	-- ITEM QUALITY
	-- BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] is actually the POOR (grey) color.
	-- There is no common quality color in BAG_ITEM_QUALITY_COLORS. Bravo Blizzard 👏
	ColorManager.ITEM_POOR = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON]):Freeze();
	ColorManager.ITEM_COMMON = Color(0.95, 0.95, 0.95):Freeze();
	ColorManager.ITEM_UNCOMMON = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_UNCOMMON]):Freeze();
	ColorManager.ITEM_RARE = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_RARE]):Freeze();
	ColorManager.ITEM_EPIC = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_EPIC]):Freeze();
	ColorManager.ITEM_LEGENDARY = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_LEGENDARY]):Freeze();
	ColorManager.ITEM_ARTIFACT = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_ARTIFACT]):Freeze();
	ColorManager.ITEM_HEIRLOOM = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_HEIRLOOM]):Freeze();
	ColorManager.ITEM_WOW_TOKEN = Color(BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_WOW_TOKEN]):Freeze();

	-- FACTIONS
	ColorManager.ALLIANCE = Color(PLAYER_FACTION_COLORS[1]):Freeze();
	ColorManager.HORDE = Color(PLAYER_FACTION_COLORS[0]):Freeze(); -- Yup, this is a table with a 0 index. Blizzard ¯\_(ツ)_/¯

	-- POWERBAR COLORS
	ColorManager.POWER_MANA = Color(PowerBarColor["MANA"]):Freeze();
	ColorManager.POWER_RAGE = Color(PowerBarColor["RAGE"]):Freeze();
	ColorManager.POWER_FOCUS = Color(PowerBarColor["FOCUS"]):Freeze();
	ColorManager.POWER_ENERGY = Color(PowerBarColor["ENERGY"]):Freeze();
	ColorManager.POWER_COMBO_POINTS = Color(PowerBarColor["COMBO_POINTS"]):Freeze();
	ColorManager.POWER_RUNES = Color(PowerBarColor["RUNES"]):Freeze();
	ColorManager.POWER_RUNIC_POWER = Color(PowerBarColor["RUNIC_POWER"]):Freeze();
	ColorManager.POWER_SOUL_SHARDS = Color(PowerBarColor["SOUL_SHARDS"]):Freeze();
	ColorManager.POWER_LUNAR_POWER = Color(PowerBarColor["LUNAR_POWER"]):Freeze();
	ColorManager.POWER_HOLY_POWER = Color(PowerBarColor["HOLY_POWER"]):Freeze();
	ColorManager.POWER_MAELSTROM = Color(PowerBarColor["MAELSTROM"]):Freeze();
	ColorManager.POWER_INSANITY = Color(PowerBarColor["INSANITY"]):Freeze();
	ColorManager.POWER_CHI = Color(PowerBarColor["CHI"]):Freeze();
	ColorManager.POWER_ARCANE_CHARGES = Color(PowerBarColor["ARCANE_CHARGES"]):Freeze();
	ColorManager.POWER_FURY = Color(PowerBarColor["FURY"]):Freeze();
	ColorManager.POWER_PAIN = Color(PowerBarColor["PAIN"]):Freeze();
	ColorManager.POWER_AMMOSLOT = Color(PowerBarColor["AMMOSLOT"]):Freeze();
	ColorManager.POWER_FUEL = Color(PowerBarColor["FUEL"]):Freeze();
end

Ellyb.ModulesManagement:RegisterNewModule("ColorManager", OnLoad, OnModulesLoaded);