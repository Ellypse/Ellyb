local ColorTools = {}

---Converts color bytes into bits, from a 0-255 range to 0-1 range.
---@param red number Between 0 and 255
---@param green number Between 0 and 255
---@param blue number Between 0 and 255
---@param alpha number Between 0 and 255
---@return number, number, number, number
---@overload fun(red:number, green:number, blue:number):number, number, number, number
function ColorTools.convertColorBytesToBits(red, green, blue, alpha)
	if alpha == nil then
		alpha = 255
	end

	return red / 255, green / 255, blue / 255, alpha / 255
end

--- Extracts RGB values (255 based) from an hexadecimal code
---@param hexadecimalCode string An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`, `|cffbababa`)
---@return number, number, number red, green, blue
function ColorTools.hexaToNumber(hexadecimalCode)
	local red, green, blue, alpha

	-- We make sure we remove possible prefixes
	hexadecimalCode = hexadecimalCode:gsub("#", "")
	hexadecimalCode = hexadecimalCode:gsub("|c", "")

	local hexadecimalCodeLength = hexadecimalCode:len()

	if hexadecimalCodeLength == 3 then
		-- #FFF
		local r = hexadecimalCode:sub(1, 1)
		local g = hexadecimalCode:sub(2, 2)
		local b = hexadecimalCode:sub(3, 3)
		red = tonumber(r .. r, 16)
		green = tonumber(g .. g, 16)
		blue = tonumber(b .. b, 16)
	elseif hexadecimalCodeLength == 6 then
		-- #FAFAFA
		red = tonumber(hexadecimalCode:sub(1, 2), 16)
		green = tonumber(hexadecimalCode:sub(3, 4), 16)
		blue = tonumber(hexadecimalCode:sub(5, 6), 16)
	elseif hexadecimalCodeLength == 8 then
		-- #ffbababa
		alpha = tonumber(hexadecimalCode:sub(1, 2), 16)
		red = tonumber(hexadecimalCode:sub(3, 4), 16)
		green = tonumber(hexadecimalCode:sub(5, 6), 16)
		blue = tonumber(hexadecimalCode:sub(7, 8), 16)
	end

	return ColorTools.convertColorBytesToBits(red, green, blue, alpha)
end

--- Compares two colors based on their HSL values (first comparing H, then comparing S, then comparing L)
---@param color1 Ellyb_Color @ A color
---@param color2 Ellyb_Color @ The color to compare
---@return boolean isLesser @ true if color1 is "lesser" than color2
function ColorTools.compareHSL(color1, color2)
	local h1, s1, l1 = color1:GetHSL()
	local h2, s2, l2 = color2:GetHSL()

	if (h1 == h2) then
		if (s1 == s2) then
			return (l1 < l2)
		end
		return (s1 < s2)
	end
	return (h1 < h2)
end

---
--- Function to test if a color is correctly readable on a dark background.
--- We will calculate the luminance of the text color
--- using known values that take into account how the human eye perceive color
--- and then compute the contrast ratio.
--- The contrast ratio should be higher than 50%.
--- @external [](http://www.whydomath.org/node/wavlets/imagebasics.html)
---
--- @param color Ellyb_Color The text color to test
--- @return boolean True if the text will be readable
function ColorTools.isTextColorReadableOnADarkBackground(color)
	return ((
		0.299 * color:GetRed() +
			0.587 * color:GetGreen() +
			0.114 * color:GetBlue()
	)) >= 0.5
end

return ColorTools