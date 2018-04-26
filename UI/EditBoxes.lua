---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.EditBoxes then
	return
end

-- Lua imports
local pairs = pairs;

-- WoW imports
local IsShiftKeyDown = IsShiftKeyDown;

local EditBoxes = {};

local readOnlyEditBoxes = {};

local EditBox = CreateFrame("EditBox");
EditBox:Hide();

---@param editBox EditBox|ScriptObject
local function saveEditBoxOriginalText(editBox)
	if readOnlyEditBoxes[editBox] then
		editBox.originalText = editBox:GetText();
	end
end

---@param editBox EditBox|ScriptObject
local function restoreOriginalText(editBox, userInput)
	if userInput and readOnlyEditBoxes[editBox] then
		editBox:SetText(editBox.originalText);
	end
end

---@param editBox EditBox|ScriptObject
function EditBoxes.makeReadOnly(editBox)

	readOnlyEditBoxes[editBox] = true;

	editBox:HookScript("OnShow", saveEditBoxOriginalText);

	editBox:HookScript("OnTextChanged", restoreOriginalText);
end


---@param editBox EditBox|ScriptObject
function EditBoxes.selectAllTextOnFocus(editBox)
	editBox:HookScript("OnEditFocusGained", editBox.HighlightText);
end

---@param editBox EditBox|ScriptObject
function EditBoxes.looseFocusOnEscape(editBox)
	editBox:HookScript("OnEscapePressed", editBox.ClearFocus);
end

--- Mixin for edit boxes that will handle serialized data.
--- This mixin takes care of escaping and un-escaping the text that is set and get.
---@type EditBox|ScriptObject
EditBoxes.SerializedDataEditBoxMixin = {};

function EditBoxes.SerializedDataEditBoxMixin:GetText()
	return EditBox.GetText(self):gsub("||", "|");
end

function EditBoxes.SerializedDataEditBoxMixin:SetText(text)
	return EditBox.SetText(self, text:gsub("|", "||"));
end

---Setup keyboard navigation using the tab key inside a list of EditBoxes.
---Pressing tab will jump to the next EditBox in the list, and shift-tab will go back to the previous one.
---@param ... EditBox[] @ A list of EditBoxes
function EditBoxes.setupTabKeyNavigation(...)
	local editBoxes = { ... };
	local maxBound = #editBoxes;
	local minBound = 1;
	for index, editbox in pairs(editBoxes) do
		editbox:HookScript("OnTabPressed", function()
			local cursor = index
			if IsShiftKeyDown() then
				if cursor == minBound then
					cursor = maxBound
				else
					cursor = cursor - 1
				end
			else
				if cursor == maxBound then
					cursor = minBound
				else
					cursor = cursor + 1
				end
			end
			editBoxes[cursor]:SetFocus();
		end)
	end
end

Ellyb.EditBoxes = EditBoxes;
