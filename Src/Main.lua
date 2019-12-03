local Button = require "UI.Widgets.Button"

local MyButton = Button()
MyButton:SetParent(UIParent)
MyButton:SetPoint("CENTER")
MyButton:SetSize(150, 30)
MyButton:SetText("Button")
MyButton:SetBackdropColor(0, 0, 0, 1)
MyButton:SetNormalFontObject("ChatFontNormal")

MyButton.rx.OnClick
	:map(GetTime)
	:bindTo(MyButton.rx.SetText)