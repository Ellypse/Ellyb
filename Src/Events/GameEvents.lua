local Logger = require "Logs.Logger"
local Assertions = require "Tools.Assertions"
local EventsDispatcher = require "Events.EventsDispatcher"

-- Ellyb imports
local logger = Logger("GameEvents")

--- Used for listening to in-game events and firing callbacks
local GameEvents = {}

local EventFrame = CreateFrame("FRAME")

---Register a callback for a game event
---@param event string @ A game event to listen to
---@param callback function @ A callback that will be called when the event is fired with its arguments
function GameEvents.registerCallback(event, callback, handlerID)
	Assertions.isType(event, "string", "event")
	Assertions.isType(callback, "function", "callback")

	if not EventFrame:IsEventRegistered(event) then
		EventFrame:RegisterEvent(event)
		logger:Info(("Listening to new Game event %s."):format(tostring(event)))
	end

	return EventsDispatcher.registerCallback(event, callback, handlerID)
end

---Unregister a previously registered callback using the handler ID given at registration
---@param handlerID string @ The handler ID of a previsouly registered callback that we want to unregister
function GameEvents.unregisterCallback(handlerID)
	Assertions.isType(handlerID, "string", "handlerID")

	EventsDispatcher.unregisterCallback(handlerID)
end

local function dispatchEvent(self, event, ...)
	if EventsDispatcher.hasCallbacksForEvent(event) then
		EventsDispatcher.triggerEvent(event, ...)
	else
		self:UnregisterEvent(event)
		logger:Info(("Stopped listening to Game event %s, no more callbacks for this event"):format(tostring(event)))
	end
end

EventFrame:SetScript("OnEvent", dispatchEvent)

function GameEvents.triggerEvent(event, ...)
	Assertions.isType(event, "string", "event")
	dispatchEvent(EventFrame, event, ...)
end

return GameEvents