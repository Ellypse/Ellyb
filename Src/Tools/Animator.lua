local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local Easings = require "Libraries.easings"

---@class Animator : Object
local Animator = Class("Animator")

---@type Animator[]
local transitionators = {}

local AnimatorsFrame = CreateFrame("FRAME")

AnimatorsFrame:SetScript("OnUpdate", function()
	for _, transitionator in pairs(transitionators) do
		if transitionator:ShouldBeUpdated() then
			transitionator:Tick()
		end
	end
end)

function Animator:initialize()
	private[self] = {}

	private[self].value = 0
	private[self].shouldBeUpdated = false

	table.insert(transitionators, self)
end

function Animator:ShouldBeUpdated()
	return private[self].shouldBeUpdated
end

function Animator:Tick()
	local elapsed = GetTime() - private[self].timeStarted
	local currentValue = private[self].customEasing(elapsed, private[self].startValue, private[self].change, private[self].overTime, unpack(private[self].customEasingArgs))
	if elapsed >= private[self].overTime then
		private[self].shouldBeUpdated = false
		private[self].callback(private[self].endValue)
	else
		private[self].callback(currentValue)
	end
end

function Animator:RunValue(startValue, endValue, overTime, callback, customEasing, ...)
	if not endValue or endValue == startValue then
		return callback(startValue)
	end

	if not customEasing then
		customEasing = Easings.outQuad
	end

	private[self].startValue = startValue
	private[self].endValue = endValue
	private[self].change = endValue - startValue
	private[self].overTime = overTime
	private[self].callback = callback
	private[self].customEasing = customEasing
	private[self].customEasingArgs = { ...}

	private[self].value = startValue
	private[self].timeStarted = GetTime()
	private[self].shouldBeUpdated = true
end

return Animator