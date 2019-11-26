local Color = require "Tools.Colors.Color"
local ColorTools = require "Tools.Colors.ColorTools"
local Assertions = require "Tools.Assertions"

--- Used for Color related operations and managing a palette of predefined Colors
local ColorManager = {}

--- Create a new Color from RGBA values, between 0 and 1.
---@param red number The red value of the Color between 0 and 1
---@param green number The green value of the Color between 0 and 1
---@param blue number The blue value of the Color between 0 and 1
---@param alpha number The alpha value of the Color between 0 and 1
---@return Ellyb_Color color
---@overload fun(red:number, green:number, blue:number):Ellyb_Color
function ColorManager.createFromRGBA(red, green, blue, alpha)
	return Color(red, green, blue, alpha)
end

--- Create a new Color from RGBA values, between 0 and 255.
---@param red number The red value of the Color between 0 and 255
---@param green number The green value of the Color between 0 and 255
---@param blue number The blue value of the Color between 0 and 255
---@param alpha number The alpha value of the Color between 0 and 255, or 0 and 1 (see alphaIsNotBytes parameter)
---@param alphaIsNotBytes boolean Some usage (like color pickers) might want to set the alpha as opacity between 0 and 1. If set to true, alpha will be considered as a value between 0 and 1
---@overload fun(red:number, green:number, blue:number, alpha: number):Ellyb_Color
------@overload fun(red:number, green:number, blue:number):Ellyb_Color
function ColorManager.createFromRGBAAsBytes(red, green, blue, alpha, alphaIsNotBytes)
	Assertions.numberIsBetween(red, 0, 255, "red")
	Assertions.numberIsBetween(green, 0, 255, "green")
	Assertions.numberIsBetween(blue, 0, 255, "blue")

	if alpha then
		-- Alpha is optional, only test if we were given a value
		if not alphaIsNotBytes then
			Assertions.numberIsBetween(alpha, 0, 255, "alpha")
			alpha = alpha / 255
		end
	else
		-- Default the alpha sensibly.
		alpha = 1
	end

	-- Set the values
	return Color(red / 255, green / 255, blue / 255, alpha)
end

--- Create a new Color from an hexadecimal code
---@param hexadecimalColorCode string A valid hexadecimal code
---@return Ellyb_Color
function ColorManager.createFromHexa(hexadecimalColorCode)
	Assertions.isType(hexadecimalColorCode, "string", "hexadecimalColorCode")

	local red, green, blue, alpha = ColorTools.hexaToNumber(hexadecimalColorCode)
	return ColorManager.createFromRGBA(red, green, blue, alpha)
end

---@return Ellyb_Color
function ColorManager.createFromTable(table)
	Assertions.isType(table, "table", "table")

	return ColorManager.createFromRGBA(table.r, table.g, table.b, table.a)
end

--- Get the associated Color for the given class.
--- This function always creates a new Color that can be mutated (unlike the Color constants)
--- It will fetch the color from the RAID_CLASS_COLORS global table and will reflect any changes made to the table.
---@param class string A valid class ("HUNTER", "DEATHKNIGHT")
---@return Ellyb_Color color The Color corresponding to the class
function ColorManager.getClassColor(class)
	if RAID_CLASS_COLORS[class] then
		return Color:new(RAID_CLASS_COLORS[class])
	end
end

--- Get the chat color associated to a specified channel in the settings
--- It will fetch the color from the ChatTypeInfo global table and will reflect any changes made to the table.
---@param channel string A chat channel ("WHISPER", "YELL", etc.)
---@return Ellyb_Color chatColor
function ColorManager.getChatColorForChannel(channel)
	assert(ChatTypeInfo[channel], "Trying to get chat color for an unknown channel type: " .. channel)
	return Color:new(ChatTypeInfo[channel])
end

return ColorManager