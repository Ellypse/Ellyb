---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

local EditBoxes = {};

---@param editBox EditBox|ScriptObject
local function saveEditboxOriginalText(editBox)
	if editBox.readOnly then
		editBox.originalText = editBox:GetText();
	end
end

---@param editBox EditBox|ScriptObject
local function restoreOriginalText(editBox)
	if editBox.readOnly then
		editBox:SetText(editBox.originalText);
	end
end

---@param editBox EditBox|ScriptObject
function EditBoxes.makeReadOnly(editBox)

	editBox.readOnly = true;

	editBox:HookScript("OnShow", saveEditboxOriginalText);

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

Ellyb.EditBoxes = EditBoxes;