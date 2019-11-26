local ColorManager = require "Tools.Colors.ColorManager"
local Classes = require "Enums.Classes"
local ItemQualities = require "Enums.ItemQualities"

-- We create a bunch of common Color constants to be quickly available everywhere
-- The Colors are frozen so they cannot be altered

return {
	-- Common colors
	RED = ColorManager.createFromRGBA(1, 0, 0):Freeze(),
	ORANGE = ColorManager.createFromRGBAAsBytes(255, 153, 0):Freeze(),
	YELLOW = ColorManager.createFromRGBA(1, 0.82, 0):Freeze(),
	GREEN = ColorManager.createFromRGBA(0, 1, 0):Freeze(),
	CYAN = ColorManager.createFromRGBA(0, 1, 1):Freeze(),
	BLUE = ColorManager.createFromRGBA(0, 0, 1):Freeze(),
	PURPLE = ColorManager.createFromRGBA(0.5, 0, 1):Freeze(),
	PINK = ColorManager.createFromRGBA(1, 0, 1):Freeze(),
	WHITE = ColorManager.createFromRGBA(1, 1, 1):Freeze(),
	GREY = ColorManager.createFromHexa("#CCC"):Freeze(),
	BLACK = ColorManager.createFromRGBA(0, 0, 0):Freeze(),

	-- Classes colors
	HUNTER = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.HUNTER):GetRGBA()):Freeze(),
	WARLOCK = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.WARLOCK):GetRGBA()):Freeze(),
	PRIEST = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.PRIEST):GetRGBA()):Freeze(),
	PALADIN = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.PALADIN):GetRGBA()):Freeze(),
	MAGE = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.MAGE):GetRGBA()):Freeze(),
	ROGUE = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.ROGUE):GetRGBA()):Freeze(),
	DRUID = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.DRUID):GetRGBA()):Freeze(),
	SHAMAN = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.SHAMAN):GetRGBA()):Freeze(),
	WARRIOR = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.WARRIOR):GetRGBA()):Freeze(),
	DEATHKNIGHT = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.DEATHKNIGHT):GetRGBA()):Freeze(),
	MONK = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.MONK):GetRGBA()):Freeze(),
	DEMONHUNTER = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.DEMONHUNTER):GetRGBA()):Freeze(),

	-- Brand colors
	TWITTER = ColorManager.createFromHexa("#1da1f2"):Freeze(),
	BATTLE_NET = ColorManager.createFromTable(FRIENDS_BNET_NAME_COLOR):Freeze(),

	-- Item colors
	-- ITEM QUALITY
	-- BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] is actually the POOR (grey) color.
	-- There is no common quality color in BAG_ITEM_QUALITY_COLORS. Bravo Blizzard 👏

	ITEM_POOR = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.COMMON]):Freeze(),
	ITEM_COMMON = ColorManager.createFromRGBA(0.95, 0.95, 0.95):Freeze(), -- Common quality is a slightly faded white
	ITEM_UNCOMMON = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.UNCOMMON]):Freeze(),
	ITEM_RARE = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.RARE]):Freeze(),
	ITEM_EPIC = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.EPIC]):Freeze(),
	ITEM_LEGENDARY = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.LEGENDARY]):Freeze(),
	ITEM_ARTIFACT = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.ARTIFACT]):Freeze(),
	ITEM_HEIRLOOM = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.HEIRLOOM]):Freeze(),
	ITEM_WOW_TOKEN = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.WOW_TOKEN]):Freeze(),

	-- FACTIONS
	ALLIANCE = ColorManager.createFromTable(PLAYER_FACTION_COLORS[1]):Freeze(),
	HORDE = ColorManager.createFromTable(PLAYER_FACTION_COLORS[0]):Freeze(), -- Yup, this is a table with a 0 index. Blizzard ¯\_(ツ)_/¯

	-- POWERBAR COLORS
	POWER_MANA = ColorManager.createFromTable(PowerBarColor["MANA"]):Freeze(),
	POWER_RAGE = ColorManager.createFromTable(PowerBarColor["RAGE"]):Freeze(),
	POWER_FOCUS = ColorManager.createFromTable(PowerBarColor["FOCUS"]):Freeze(),
	POWER_ENERGY = ColorManager.createFromTable(PowerBarColor["ENERGY"]):Freeze(),
	POWER_COMBO_POINTS = ColorManager.createFromTable(PowerBarColor["COMBO_POINTS"]):Freeze(),
	POWER_RUNES = ColorManager.createFromTable(PowerBarColor["RUNES"]):Freeze(),
	POWER_RUNIC_POWER = ColorManager.createFromTable(PowerBarColor["RUNIC_POWER"]):Freeze(),
	POWER_SOUL_SHARDS = ColorManager.createFromTable(PowerBarColor["SOUL_SHARDS"]):Freeze(),
	POWER_LUNAR_POWER = ColorManager.createFromTable(PowerBarColor["LUNAR_POWER"]):Freeze(),
	POWER_HOLY_POWER = ColorManager.createFromTable(PowerBarColor["HOLY_POWER"]):Freeze(),
	POWER_MAELSTROM = ColorManager.createFromTable(PowerBarColor["MAELSTROM"]):Freeze(),
	POWER_INSANITY = ColorManager.createFromTable(PowerBarColor["INSANITY"]):Freeze(),
	POWER_CHI = ColorManager.createFromTable(PowerBarColor["CHI"]):Freeze(),
	POWER_ARCANE_CHARGES = ColorManager.createFromTable(PowerBarColor["ARCANE_CHARGES"]):Freeze(),
	POWER_FURY = ColorManager.createFromTable(PowerBarColor["FURY"]):Freeze(),
	POWER_PAIN = ColorManager.createFromTable(PowerBarColor["PAIN"]):Freeze(),
	POWER_AMMOSLOT = ColorManager.createFromTable(PowerBarColor["AMMOSLOT"]):Freeze(),
	POWER_FUEL = ColorManager.createFromTable(PowerBarColor["FUEL"]):Freeze(),

	-- OTHER GAME STUFF
	CRAFTING_REAGENT = ColorManager.createFromHexa("#66bbff"):Freeze(),

	LINKS = {
		achievement = ColorManager.createFromHexa("#ffff00"):Freeze(),
		talent = ColorManager.createFromHexa("#4e96f7"):Freeze(),
		trade = ColorManager.createFromHexa("#ffd000"):Freeze(),
		enchant = ColorManager.createFromHexa("#ffd000"):Freeze(),
		instancelock = ColorManager.createFromHexa("#ff8000"):Freeze(),
		journal = ColorManager.createFromHexa("#66bbff"):Freeze(),
		battlePetAbil = ColorManager.createFromHexa("#4e96f7"):Freeze(),
		battlepet = ColorManager.createFromHexa("#ffd200"):Freeze(),
		garrmission = ColorManager.createFromHexa("#ffff00"):Freeze(),
		transmogillusion = ColorManager.createFromHexa("#ff80ff"):Freeze(),
		transmogappearance = ColorManager.createFromHexa("#ff80ff"):Freeze(),
		transmogset = ColorManager.createFromHexa("#ff80ff"):Freeze(),
	}
}