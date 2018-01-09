---@type Ellyb
local _, Ellyb = ...;

-- Lua imports
local pairs = pairs;
local insert = table.insert;

local GameTooltip = GameTooltip;

---@class Tooltip : Object
local Tooltip = Ellyb.class("TooltipContent");
Ellyb.Tooltip = Tooltip;
-- Sets a private table used to store private attributes
local _private = setmetatable({}, { __mode = "k" });

function Tooltip:initialize(parent)
	_private[self] = {};
	_private[self].content = {};
	_private[self].parent = parent;
end

---@param customColor Color
function Tooltip:SetTitle(text, customColor)
	_private[self].title = text;
	_private[self].customTitleColor = customColor;
end

function Tooltip:SetTitleColor(customColor)
	_private[self].customTitleColor = customColor;
end

function Tooltip:GetTitle()
	return _private[self].title.text;
end

function Tooltip:GetTitleColor()
	return _private[self].customTitleColor or Ellyb.ColorManager.WHITE;
end

---@param anchor string
function Tooltip:SetAnchor(anchor)
	_private[self].anchor = anchor;
end

---@return string
function Tooltip:GetAnchor()
	return _private[self].anchor or "ANCHOR_RIGHT";
end

---@param parent Frame
function Tooltip:SetParent(parent)
	_private[self].customParent = parent;
end

---@return Frame
function Tooltip:GetParent()
	return _private[self].customParent or _private[self].parent;
end

function Tooltip:SetOffset(x, y)
	_private[self].customParent.x = x;
	_private[self].customParent.y = y;
end

---@return number, number
function Tooltip:GetOffset()
	return _private[self].customParent.x or 0, _private[self].customParent.y or 0;
end

---@param customColor Color
function Tooltip:AddLine(text, customColor)
	insert(_private[self].content, {
		text = text,
		customColor = customColor,
	})
end

function Tooltip:GetLines()
	return _private[self].content;
end

function Tooltip:ClearLines()
	_private[self].content = {};
end

function Tooltip:SetLines(lines)
	self:ClearLines();
	for _, line in pairs(lines) do
		self:AddLine(line.text, line.customColor)
	end
end

function Tooltip:Show()
	GameTooltip:ClearLines();
	GameTooltip:SetOwner(self:GetParent(), self:GetAnchor(), self:GetOffset());
	GameTooltip:SetText(self:GetTitle(), self:GetTitleColor():GetRGBA());
	for _, line in pairs(self:GetLines()) do
		GameTooltip:AddLine(line.text, line.customColor:GetRGB(), true);
	end
	GameTooltip:Show();
end

function Tooltip:Hide()
	GameTooltip:Hide();
end