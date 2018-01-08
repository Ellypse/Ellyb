---@type Ellyb
local _, Ellyb = ...;

local insert = table.insert;


---@class Tooltip : Object
local Tooltip = Ellyb.class("TooltipContent");
-- Sets a private table used to store private attributes
local _private = setmetatable({}, { __mode = "k" });

function Tooltip:initialize()
	_private[self] = {};
	_private[self].content = {};
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

function Tooltip:SetAnchor(anchor)
	_private[self].anchor = anchor;
end

function Tooltip:GetAnchor()
	return _private[self].anchor or "ANCHOR_RIGHT";
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

function Tooltip:Hide()
	GameTooltip:Hide();
end