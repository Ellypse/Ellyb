local Color = require "Tools.Color"

--- Used for Color related operations and managing a palette of predefined Colors
local ColorManager = {};

--- Get the associated Color for the given class.
--- This function always creates a new Color that can be mutated (unlike the Color constants)
--- It will fetch the color from the RAID_CLASS_COLORS global table and will reflect any changes made to the table.
---@param class string A valid class ("HUNTER", "DEATHKNIGHT")
---@return Ellyb_Color color The Color corresponding to the class
function ColorManager.getClassColor(class)
	if RAID_CLASS_COLORS[class] then
		return Color:new(RAID_CLASS_COLORS[class]);
	end
end

--- Get the chat color associated to a specified channel in the settings
--- It will fetch the color from the ChatTypeInfo global table and will reflect any changes made to the table.
---@param channel string A chat channel ("WHISPER", "YELL", etc.)
---@return Ellyb_Color chatColor
function ColorManager.getChatColorForChannel(channel)
	assert(ChatTypeInfo[channel], "Trying to get chat color for an unknown channel type: " .. channel);
	return Color:new(ChatTypeInfo[channel]);
end

-- We create a bunch of common Color constants to be quickly available everywhere
-- The Colors are frozen so they cannot be altered

-- Common colors
ColorManager.RED = Color:new(1, 0, 0):Freeze();
ColorManager.ORANGE = Color:new(255, 153, 0):Freeze();
ColorManager.YELLOW = Color:new(1, 0.82, 0):Freeze();
ColorManager.GREEN = Color:new(0, 1, 0):Freeze();
ColorManager.CYAN = Color:new(0, 1, 1):Freeze();
ColorManager.BLUE = Color:new(0, 0, 1):Freeze();
ColorManager.PURPLE = Color:new(0.5, 0, 1):Freeze();
ColorManager.PINK = Color:new(1, 0, 1):Freeze();
ColorManager.WHITE = Color:new(1, 1, 1):Freeze();
ColorManager.GREY = Color:new("#CCC"):Freeze();
ColorManager.BLACK = Color:new(0, 0, 0):Freeze();

-- Classes colors
local Classes = require "Enums.Classes"
ColorManager.HUNTER = Color:new(RAID_CLASS_COLORS[Classes.HUNTER]):Freeze();
ColorManager.WARLOCK = Color:new(RAID_CLASS_COLORS[Classes.WARLOCK]):Freeze();
ColorManager.PRIEST = Color:new(RAID_CLASS_COLORS[Classes.PRIEST]):Freeze();
ColorManager.PALADIN = Color:new(RAID_CLASS_COLORS[Classes.PALADIN]):Freeze();
ColorManager.MAGE = Color:new(RAID_CLASS_COLORS[Classes.MAGE]):Freeze();
ColorManager.ROGUE = Color:new(RAID_CLASS_COLORS[Classes.ROGUE]):Freeze();
ColorManager.DRUID = Color:new(RAID_CLASS_COLORS[Classes.DRUID]):Freeze();
ColorManager.SHAMAN = Color:new(RAID_CLASS_COLORS[Classes.SHAMAN]):Freeze();
ColorManager.WARRIOR = Color:new(RAID_CLASS_COLORS[Classes.WARRIOR]):Freeze();
ColorManager.DEATHKNIGHT = Color:new(RAID_CLASS_COLORS[Classes.DEATHKNIGHT]):Freeze();
ColorManager.MONK = Color:new(RAID_CLASS_COLORS[Classes.MONK]):Freeze();
ColorManager.DEMONHUNTER = Color:new(RAID_CLASS_COLORS[Classes.DEMONHUNTER]):Freeze();

-- Brand colors
ColorManager.TWITTER = Color:new("#1da1f2"):Freeze();
ColorManager.BATTLE_NET = Color:new(FRIENDS_BNET_NAME_COLOR):Freeze();

-- Item colors
-- ITEM QUALITY
-- BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] is actually the POOR (grey) color.
-- There is no common quality color in BAG_ITEM_QUALITY_COLORS. Bravo Blizzard 👏
local ItemQualities = require "Enums.ItemQualities"
ColorManager.ITEM_POOR = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.COMMON]):Freeze();
ColorManager.ITEM_COMMON = Color:new(0.95, 0.95, 0.95):Freeze(); -- Common quality is a slightly faded white
ColorManager.ITEM_UNCOMMON = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.UNCOMMON]):Freeze();
ColorManager.ITEM_RARE = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.RARE]):Freeze();
ColorManager.ITEM_EPIC = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.EPIC]):Freeze();
ColorManager.ITEM_LEGENDARY = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.LEGENDARY]):Freeze();
ColorManager.ITEM_ARTIFACT = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.ARTIFACT]):Freeze();
ColorManager.ITEM_HEIRLOOM = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.HEIRLOOM]):Freeze();
ColorManager.ITEM_WOW_TOKEN = Color:new(BAG_ITEM_QUALITY_COLORS[ItemQualities.WOW_TOKEN]):Freeze();

-- FACTIONS
ColorManager.ALLIANCE = Color:new(PLAYER_FACTION_COLORS[1]):Freeze();
ColorManager.HORDE = Color:new(PLAYER_FACTION_COLORS[0]):Freeze(); -- Yup, this is a table with a 0 index. Blizzard ¯\_(ツ)_/¯

-- POWERBAR COLORS
ColorManager.POWER_MANA = Color:new(PowerBarColor["MANA"]):Freeze();
ColorManager.POWER_RAGE = Color:new(PowerBarColor["RAGE"]):Freeze();
ColorManager.POWER_FOCUS = Color:new(PowerBarColor["FOCUS"]):Freeze();
ColorManager.POWER_ENERGY = Color:new(PowerBarColor["ENERGY"]):Freeze();
ColorManager.POWER_COMBO_POINTS = Color:new(PowerBarColor["COMBO_POINTS"]):Freeze();
ColorManager.POWER_RUNES = Color:new(PowerBarColor["RUNES"]):Freeze();
ColorManager.POWER_RUNIC_POWER = Color:new(PowerBarColor["RUNIC_POWER"]):Freeze();
ColorManager.POWER_SOUL_SHARDS = Color:new(PowerBarColor["SOUL_SHARDS"]):Freeze();
ColorManager.POWER_LUNAR_POWER = Color:new(PowerBarColor["LUNAR_POWER"]):Freeze();
ColorManager.POWER_HOLY_POWER = Color:new(PowerBarColor["HOLY_POWER"]):Freeze();
ColorManager.POWER_MAELSTROM = Color:new(PowerBarColor["MAELSTROM"]):Freeze();
ColorManager.POWER_INSANITY = Color:new(PowerBarColor["INSANITY"]):Freeze();
ColorManager.POWER_CHI = Color:new(PowerBarColor["CHI"]):Freeze();
ColorManager.POWER_ARCANE_CHARGES = Color:new(PowerBarColor["ARCANE_CHARGES"]):Freeze();
ColorManager.POWER_FURY = Color:new(PowerBarColor["FURY"]):Freeze();
ColorManager.POWER_PAIN = Color:new(PowerBarColor["PAIN"]):Freeze();
ColorManager.POWER_AMMOSLOT = Color:new(PowerBarColor["AMMOSLOT"]):Freeze();
ColorManager.POWER_FUEL = Color:new(PowerBarColor["FUEL"]):Freeze();

-- OTHER GAME STUFF
ColorManager.CRAFTING_REAGENT = Color:new("#66bbff"):Freeze();

ColorManager.LINKS = {
	achievement = Color:new("#ffff00"):Freeze(),
	talent = Color:new("#4e96f7"):Freeze(),
	trade = Color:new("#ffd000"):Freeze(),
	enchant = Color:new("#ffd000"):Freeze(),
	instancelock = Color:new("#ff8000"):Freeze(),
	journal = Color:new("#66bbff"):Freeze(),
	battlePetAbil = Color:new("#4e96f7"):Freeze(),
	battlepet = Color:new("#ffd200"):Freeze(),
	garrmission = Color:new("#ffff00"):Freeze(),
	transmogillusion = Color:new("#ff80ff"):Freeze(),
	transmogappearance = Color:new("#ff80ff"):Freeze(),
	transmogset = Color:new("#ff80ff"):Freeze(),
}

return ColorManager