---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- Lua imports
local pairs = pairs;
local insert = table.insert;

local GameTooltip = GameTooltip;

---@class Tooltip : Object
local Tooltip = Ellyb.Class("TooltipContent");
Ellyb.Tooltip = Tooltip;
-- Sets a private table used to store private attributes
local _private = setmetatable({}, { __mode = "k" });

function Tooltip:initialize(parent)
	_private[self] = {};
	_private[self].content = {};
	_private[self].tempContent = {};
	_private[self].parent = parent;
	_private[self].onShowCallbacks = {};
end

---@param customColor Color
function Tooltip:SetTitle(text, customColor)
	_private[self].title = text;
	_private[self].customTitleColor = customColor;
	return self;
end

function Tooltip:GetTitle()
	return _private[self].title;
end

function Tooltip:SetTitleColor(customColor)
	_private[self].customTitleColor = customColor;
	return self;
end

function Tooltip:GetTitleColor()
	local r, g, b, a = 1, 1, 1, 1;
	if _private[self].customTitleColor then
		r, g, b, a = _private[self].customTitleColor:GetRGBA();
	end
	return r, g, b, a;
end

---@param anchor string
function Tooltip:SetAnchor(anchor)
	_private[self].anchor = anchor;
	return self;
end

---@return string
function Tooltip:GetAnchor()
	return "ANCHOR_" .. (_private[self].anchor or "RIGHT");
end

---@param parent Frame
function Tooltip:SetParent(parent)
	_private[self].customParent = parent;
	return self;
end

---@return Frame
function Tooltip:GetParent()
	return _private[self].customParent or _private[self].parent;
end

function Tooltip:SetOffset(x, y)
	_private[self].x = x;
	_private[self].y = y;
	return self;
end

---@return number, number
function Tooltip:GetOffset()
	return _private[self].x or 0, _private[self].y or 0;
end

---@param customColor Color
function Tooltip:AddLine(text, customColor)
	insert(_private[self].content, {
		text = text,
		customColor = customColor,
	});
	return self;
end

function Tooltip:AddEmptyLine()
	insert(_private[self].content, {
		text = " ",
	});
	return self;
end

function Tooltip:AddTempLine(text, customColor)
	insert(_private[self].tempContent, {
		text = text,
		customColor = customColor,
	});
	return self;
end

function Tooltip:GetLines()
	return _private[self].content;
end

function Tooltip:GetTempLines()
	return _private[self].tempContent;
end

function Tooltip:ClearLines()
	_private[self].content = {};
	return self;
end

function Tooltip:ClearTempLines()
	_private[self].tempContent = {};
	return self;
end

function Tooltip:SetLines(lines)
	self:ClearLines();
	for _, line in pairs(lines) do
		self:AddLine(line.text, line.customColor)
	end
	return self;
end

---SetLine
---@param text string
---@param customColor Color
function Tooltip:SetLine(text, customColor)
	self:ClearLines();
	self:AddLine(text, customColor);
	return self;
end

---@param tooltipFrame GameTooltip
function Tooltip:SetCustomTooltipFrame(tooltipFrame)
	_private[self].tooltip = tooltipFrame;
	return self;
end

---@return GameTooltip
function Tooltip:GetTooltipFrame()
	return _private[self].tooltip or GameTooltip;
end

function Tooltip:OnShow(callback)
	insert(_private[self].onShowCallbacks, callback);
end

function Tooltip:Show()

	-- Call all the callbacks that have been registered of the OnShow event
	for _, callback in pairs(_private[self].onShowCallbacks) do
		-- If one of the callback returns false, it means the tooltip should not be shown, we stop right here
		if callback(self) == false then
			return
		end
	end

	-- Do not show the tooltip if no title was defined yet
	if not self:GetTitle() then
		return
	end

	local tooltip = self:GetTooltipFrame();
	tooltip:ClearLines();
	tooltip:SetOwner(self:GetParent(), self:GetAnchor(), self:GetOffset());
	tooltip:SetText(self:GetTitle(), self:GetTitleColor());

	-- Insert all the lines inside the tooltip
	for _, line in pairs(self:GetLines()) do
		local r, g, b;
		if line.customColor then
			r, g, b = line.customColor:GetRGBAAsBytes();
		end
		tooltip:AddLine(line.text, r, g, b, true);
	end

	-- Insert all the lines inside the tooltip
	for _, line in pairs(self:GetTempLines()) do
		local r, g, b;
		if line.customColor then
			r, g, b = line.customColor:GetRGBAAsBytes();
		end
		tooltip:AddLine(line.text, r, g, b, true);
	end

	tooltip:Show();
end

function Tooltip:Hide()
	self:GetTooltipFrame():Hide();
	self:ClearTempLines();
end