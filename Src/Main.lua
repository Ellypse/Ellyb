local CopyTextPopup = require "UI.Popups.CopyTextPopup"

local popup = CopyTextPopup()
popup:SetCopyableText("http://twitter.com")

C_Timer.After(2, function()
	popup:Show()
end)

