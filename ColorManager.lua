---@type Ellyb
local _, Ellyb = ...;

local tonumber = tonumber;
local lenght = string.len;
local gsub = string.gsub;

local Color = Ellyb.Color;

local ColorManager = {};
Ellyb.ColorManager = ColorManager;

---Convert color bytes into bits, from a 0-255 range to 0-1 range.
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

--- Extract RGB values (255 based) from an hexadecimal code
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
        local r = hexadecimalCode:sub(1, 1);
        local g = hexadecimalCode:sub(2, 2);
        local b = hexadecimalCode:sub(3, 3);
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

    return ColorManager.convertColorBytesToBits(red, green, blue, alpha);
end

---@param class string
---@return Color
function ColorManager.getClassColor(class)
    if RAID_CLASS_COLORS[class] then
        return Ellyb.Color(RAID_CLASS_COLORS[class]);
    end
end

ColorManager.ORANGE = Color(255, 153, 0):Freeze();
ColorManager.WHITE = Color(1, 1, 1):Freeze();
ColorManager.YELLOW = Color(1, 0.75, 0):Freeze();
ColorManager.CYAN = Color(0, 1, 1):Freeze();
ColorManager.BLUE = Color(0, 0, 1):Freeze();
ColorManager.GREEN = Color(0, 1, 0):Freeze();
ColorManager.RED = Color(1, 0, 0):Freeze();
ColorManager.PURPLE = Color(1, 0, 1):Freeze();
ColorManager.BLACK = Color(0, 0, 0):Freeze();
ColorManager.GREY = Color(0.6, 0.6, 0.6):Freeze();

ColorManager.TWITTER = Color("#1da1f2"):Freeze();