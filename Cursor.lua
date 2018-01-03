---@type Ellyb
local _, Ellyb = ...;

-- Lua imports
local assert = assert;

-- WoW imports
local GetCursorPosition = GetCursorPosition;
---@type Frame
local UIParent = UIParent;

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb)

	local Cursor = {};
	Ellyb.CursorManager = Cursor;

	local CursorFrame = CreateFrame("Frame", nil, UIParent);
	CursorFrame:SetHeight(1);
	CursorFrame:SetWidth(1);

	local Icon = CursorFrame:CreateTexture(nil, "ARTWORK");
	Icon:SetWidth(30);
	Icon:SetHeight(30);
	Icon:SetPoint("TOPLEFT", CursorFrame, "TOPLEFT", 33, 30);

	function CursorFrame:PlaceOnCursor()
		local scale = 1 / UIParent:GetEffectiveScale();
		local x, y = GetCursorPosition();
		self:SetPoint("CENTER", UIParent, "CENTER", x * scale, y * scale);
	end

	CursorFrame:SetScript("OnUpdate", CursorFrame.PlaceOnCursor);

	---Set the texture attached to the cursor
	---@param cursorTexture string|number @ A texture path or texture ID to display on the cursor
	function Cursor:SetCursor(cursorTexture)
		assert(Ellyb.Assertions.isOfTypes(cursorTexture, { "string", "number" }, "cursorTexture"));

		Icon:SetTexture(cursorTexture);
		CursorFrame:PlaceOnCursor();
		CursorFrame:Show();
	end

	---Hide the cursor texture
	function Cursor:ClearCursor()
		CursorFrame:Hide();
	end

end

Ellyb.ModulesManagement:RegisterNewModule("Cursor", OnLoad);