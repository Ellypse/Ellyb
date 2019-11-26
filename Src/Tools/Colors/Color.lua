local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local Assertions = require "Tools.Assertions"
local ColorTools = require "Tools.Colors.ColorTools"
local Maths = require "Tools.Maths"
local UiEscapeSequences = require "Enums.UiEscapeSequences"

---@class Ellyb_Color : Object
--- A Color object with various methods used to handle color, color text, etc.
local Color = Class("Color")

---Constructor
---@param red number
---@param green number
---@param blue number
---@param alpha number
function Color:initialize(red, green, blue, alpha)
	private[self].canBeMutated = true
	-- If the alpha isn't given we should probably be sensible and default it.
	alpha = alpha or 1

	self:SetRed(red)
	self:SetGreen(green)
	self:SetBlue(blue)
	self:SetAlpha(alpha)

end


--- Allows read only access to RGBA properties as table fields
---@param key string The key we want to access
function Color:__index(key)
	if key == "r" or key == "red" then
		return self:GetRed()
	elseif key == "g" or key == "green" then
		return self:GetGreen()
	elseif key == "b" or key == "blue" then
		return self:GetBlue()
	elseif key == "a" or key == "alpha" then
		return self:GetAlpha()
	end
end

---@return string color A string representation of the color (#FFBABABA)
function Color:__tostring()
	return self:WrapTextInColorCode("#" .. self:GenerateHexadecimalColor())
end

---@param text string A text to color
---@return string A shortcut to self:WrapTextInColorCode(text) to easily color text by calling the Color itself
function Color:__call(text)
	return self:WrapTextInColorCode(text)
end

function Color:__eq(colorB)
	local redA, greenA, blueA, alphaA = self:GetRGBA()
	local redB, greenB, blueB, alphaB = colorB:GetRGBA()
	return redA == redB
		and greenA == greenB
		and blueA == blueB
		and alphaA == alphaB
end

---@return number The red value of the Color between 0 and 1
function Color:GetRed()
	return private[self].red
end

---@return number The green value of the Color between 0 and 1
function Color:GetGreen()
	return private[self].green
end

---@return number The blue value of the Color between 0 and 1
function Color:GetBlue()
	return private[self].blue
end

---@return number The alpha value of the Color (defaults to 1)
function Color:GetAlpha()
	return private[self].alpha or 1
end

---@return number, number, number The red, green and blue values of the Color between 0 and 1
function Color:GetRGB()
	return self:GetRed(), self:GetGreen(), self:GetBlue()
end

---@return number, number, number, number The red, green, blue and alpha values of the Color between 0 and 1
function Color:GetRGBA()
	return self:GetRed(), self:GetGreen(), self:GetBlue(), self:GetAlpha()
end

---@return number, number, number The red, green and blue values of the Color on a between 0 and 255
function Color:GetRGBAsBytes()
	return self:GetRed() * 255, self:GetGreen() * 255, self:GetBlue() * 255
end

---@return number, number, number, number The red, green, blue and alpha values of the Color between 0 and 255
function Color:GetRGBAAsBytes()
	return self:GetRed() * 255, self:GetGreen() * 255, self:GetBlue() * 255, self:GetAlpha() * 255
end

---@return number, number, number The hue, saturation and lightness values of the Color (hue between 0 and 360, saturation/lightness between 0 and 1)
function Color:GetHSL()
	local h, s, l, cmax, cmin
	local r, g, b = self:GetRGB()
	cmax = math.max(r, g, b)
	cmin = math.min(r, g, b)

	if (cmin == cmax) then
		h = 0
	elseif (cmax == r) then
		h = 60 * math.fmod((g - b)/(cmax - cmin), 6)
	elseif (cmax == g) then
		h = 60 * ((b - r)/(cmax - cmin) + 2)
	else
		h = 60 * ((r - g)/(cmax - cmin) + 4)
	end

	if (h < 0) then
		h = h + 360
	end

	l = (cmax + cmin)/2

	if (cmin == cmax) then
		s = 0
	else
		s = (cmax - cmin)/(1 - math.abs(2*l - 1))
	end

	return h, s, l
end

--- Set the red value of the color.
--- If the color was :Freeze() it will silently fail.
---@param red number A number between 0 and 1 for the red value
function Color:SetRed(red)
	if private[self].canBeMutated then
		Assertions.numberIsBetween(red, 0, 1, "red")
		private[self].red = red
	end
end

--- Set the green value of the color.
--- If the color was :Freeze() it will silently fail.
---@param green number A number between 0 and 1 for the green value
function Color:SetGreen(green)
	if private[self].canBeMutated then
		Assertions.numberIsBetween(green, 0, 1, "green")
		private[self].green = green
	end
end

--- Set the blue value of the color.
--- If the color was :Freeze() it will silently fail.
---@param blue number A number between 0 and 1 for the blue value
function Color:SetBlue(blue)
	if private[self].canBeMutated then
		Assertions.numberIsBetween(blue, 0, 1, "blue")
		private[self].blue = blue
	end
end

--- Set the alpha value of the color.
--- If the color was :Freeze() it will silently fail.
---@param alpha number A number between 0 and 1 for the alpha value
function Color:SetAlpha(alpha)
	if private[self].canBeMutated then
		Assertions.numberIsBetween(alpha, 0, 1, "alpha")
		private[self].alpha = alpha
	end
end

--- Set the red, green, blue and alpha values of the color.
--- If the color was :Freeze() it will silently fail.
---@param red number A number between 0 and 1 for the red value
---@param green number A number between 0 and 1 for the green value
---@param blue number A number between 0 and 1 for the blue value
---@param alpha number A number between 0 and 1 for the alpha value
function Color:SetRGBA(red, green, blue, alpha)
	self:SetRed(red)
	self:SetGreen(green)
	self:SetBlue(blue)
	self:SetAlpha(alpha)
end

--- Get the color values as an { r, g, b } table
---@return {r: number, g: number, b: number}
function Color:GetRGBTable()
	return {
		r = self:GetRed(),
		g = self:GetGreen(),
		b = self:GetBlue(),
	}
end

--- Get the color values as an { r, g, b, a } table
---@return {r: number, g: number, b: number, a: number}
function Color:GetRGBATable()
	return {
		r = self:GetRed(),
		g = self:GetGreen(),
		b = self:GetBlue(),
		a = self:GetAlpha(),
	}
end

--- Freezes a Color so that it cannot be mutated
--- Used for Color constants in the ColorManager
---
--- Example:
--- `local white = Color("#FFFFFF"):Freeze()`
---@return Ellyb_Color Returns itself, so it can be used during the instantiation
function Color:Freeze()
	private[self].canBeMutated = false
	return self
end

--- Create a duplicate version of the color that can be altered safely
--- @return Ellyb_Color A duplicate of this color
function Color:Clone()
	return Color.CreateFromRGBA(self:GetRGBA())
end

---@param doNotIncludeAlpha boolean Set to true if the color code should not have the alpha
---@return string Generate an hexadecimal representation of the code (`FFAABBCC`)
---@overload fun():string
function Color:GenerateHexadecimalColor(doNotIncludeAlpha)
	local red, green, blue, alpha = self:GetRGBAAsBytes()
	if doNotIncludeAlpha then
		return UiEscapeSequences.COLOR:sub(7):format(red, green, blue):upper()
	else
		return UiEscapeSequences.COLOR:sub(3):format(alpha, red, green, blue):upper()
	end
end

--- Compatibility with Blizzard stuff
---@param doNotIncludeAlpha boolean Set to true if the color code should not have the alpha
---@return string HexadecimalColor Generate an hexadecimal representation of the code (`FFAABBCC`)
---@overload fun():string
function Color:GenerateHexColor(doNotIncludeAlpha)
	return self:GenerateHexadecimalColor(doNotIncludeAlpha)
end

---@return string Returns the start code of the UI escape sequence to color text
function Color:GetColorCodeStartSequence()
	return UiEscapeSequences.COLOR:sub(1,2) .. self:GenerateHexadecimalColor()
end

--- Wrap a given text between the UI escape sequenced necessary to get the text colored in the current Color
---@param text string The text to be colored
---@return string coloredText A colored representation of the given text
function Color:WrapTextInColorCode(text)
	return self:GetColorCodeStartSequence() .. tostring(text) .. UiEscapeSequences.CLOSE
end

--- Applies a color to a FontString UI widget
---@param fontString FontString
function Color:SetTextColor(fontString)
	Assertions.isType(fontString, "FontString", "fontString")
	fontString:SetTextColor(self:GetRGBA())
end

--- Lighten up a color that is too dark until it is properly readable on a dark background.
function Color:LightenColorUntilItIsReadableOnDarkBackgrounds()
	-- If the color is too dark to be displayed in the tooltip, we will ligthen it up a notch
	while not ColorTools.isTextColorReadableOnADarkBackground(self) do
		self:SetRed(Maths.incrementValueUntilMax(self:GetRed(), 0.01, 1))
		self:SetGreen(Maths.incrementValueUntilMax(self:GetGreen(), 0.01, 1))
		self:SetBlue(Maths.incrementValueUntilMax(self:GetBlue(), 0.01, 1))
	end
end

return Color
