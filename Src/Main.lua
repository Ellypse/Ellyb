function tContains (tab, val)
	for _, value in ipairs(tab) do
		if value == val then
			return true
		end
	end

	return false
end

function _G.CreateFrame()
	return setmetatable({
		SetText = function(self, text) self.__text = text end,
		GetText = function(self) return self.__text end,
		HookScript = function() end
	}, {})
end

local Button = require "UI.Widgets.Button"
local Rx = require "Libraries.RxLua.rx"
local button= Button()



local buttonText = Rx.Subject.create()

buttonText
	:map(function(arg)
		return "Received: " .. tostring(arg)
	end)
	:bindTo(button.rx.SetText)

buttonText(1)
print(button:GetText())
buttonText("Hello")
print(button:GetText())

local i = 0
button.rx.OnClick
	:map(function()
		i = i + 1
		return "Button Clicked " .. i .. " times"
	end)
	:bindTo(button.rx.SetText)

button.rx.OnClick()
print(button:GetText())
button.rx.OnClick()
button.rx.OnClick()
button.rx.OnClick()
button.rx.OnClick()
print(button:GetText())
buttonText("I'm done now")
print(button:GetText())

local EditBox = require "UI.Widgets.EditBox"
local textField = EditBox()

textField:SetText("")
textField.rx.OnChar
	:map(function(char)
		return textField:GetText() .. char
	end)
	:debug()
	:bindTo(textField.rx.SetText)

textField.rx.OnChar("E")
textField.rx.OnChar("l")
textField.rx.OnChar("s")
textField.rx.OnChar("a")
print(textField:GetText())

