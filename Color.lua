---@type Ellyb
local _, Ellyb = ...;

local format = string.format;
local uppercase = string.upper;

---@class Color : Object
local Color = Ellyb.class("Color");
Ellyb.Color = Color;
local _private = setmetatable({}, { __mode = "k" });

function Color:initialize(red, green, blue, alpha)
    _private[self] = {};
    if type(red) == "table" then
        local colorTable = red;
        red = colorTable.red or colorTable.r;
        green = colorTable.green or colorTable.g;
        blue = colorTable.blue or colorTable.b;
        alpha = colorTable.alpha or colorTable.a;
    elseif type(red) == "string" then
        local hexadecimalColorCode = red;
        red, green, blue, alpha = Ellyb.ColorManager.hexaToNumber(hexadecimalColorCode);
    end
    if red > 1 or green > 1 or blue > 1 or (alpha and alpha > 1) then
        red, green, blue, alpha = Ellyb.ColorManager.convertColorBytesToBits(red, green, blue, alpha);
    end
    _private[self].red = red;
    _private[self].green = green;
    _private[self].blue = blue;
    _private[self].alpha = alpha;
    _private[self].canBeMutated = true;
end

function Color:__tostring()
    return self:WrapTextInColorCode("#" .. self:GenerateHexColor());
end

function Color:__call(text)
    return self:WrapTextInColorCode(text);
end

---@param colorA Color
---@param colorB Color
function Color:IsEqualTo(colorB)
    local redA, greenA, blueA, alphaA = self:GetRGBA();
    local redB, greenB, blueB, alphaB = colorB:GetRGBA();
    return redA == redB
    and greenA == greenB
    and blueA == blueB
    and alphaA == alphaB;
end

function Color:GetRed()
    return _private[self].red;
end

function Color:GetGreen()
    return _private[self].green;
end

function Color:GetBlue()
    return _private[self].blue;
end

function Color:GetAlpha()
    return _private[self].alpha or 1;
end

function Color:GetRGB()
    return self:GetRed(), self:GetGreen(), self:GetBlue();
end

function Color:GetRGBA()
    return self:GetRed(), self:GetGreen(), self:GetBlue(), self:GetAlpha();
end

function Color:GetRGBAsBytes()
    return self:GetRed() * 255, self:GetGreen() * 255, self:GetBlue() * 255;
end

function Color:GetRGBAAsBytes()
    return self:GetRed() * 255, self:GetGreen() * 255, self:GetBlue() * 255, self:GetAlpha() * 255;
end

function Color:SetRed(red)
    if _private[self].canBeMutated then
        _private[self].red = red;
    end
end

function Color:SetGreen(green)
    if _private[self].canBeMutated then
        _private[self].green = green;
    end
end

function Color:SetBlue(blue)
    if _private[self].canBeMutated then
        _private[self].blue = blue;
    end
end

function Color:SetAlpha(alpha)
    if _private[self].canBeMutated then
        _private[self].alpha = alpha;
    end
end

function Color:SetRGBA(red, green, blue, alpha)
    self:SetRed(red);
    self:SetGreen(green);
    self:SetBlue(blue);
    self:SetAlpha(alpha);
end

---@return Color
function Color:Freeze()
    _private[self].canBeMutated = false;
    return self;
end

local HEXADECIMAL_COLOR_PATTERN = "%.2x%.2x%.2x%.2x"
function Color:GenerateHexColor()
    local red, green, blue, alpha = self:GetRGBAAsBytes();
    return uppercase(format(HEXADECIMAL_COLOR_PATTERN, alpha, red, green, blue));
end

local COLOR_CODE_PATTERN = "|c%s%s|r";
function Color:WrapTextInColorCode(text)
    return format(COLOR_CODE_PATTERN, self:GenerateHexColor(), text);
end