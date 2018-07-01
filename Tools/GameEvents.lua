---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.GameEvents then
	return
end

-- WoW imports
local assert = assert;
local tostring = tostring;
local format = string.format;
local CreateFrame = CreateFrame;

-- Ellyb imports
local Logger = Ellyb.Logger("GameEvents");

---@class GameEvents
--- Used for listening to in-game events and firing callbacks
local GameEvents = {};

local eventsDispatcher = Ellyb.EventsDispatcher();

local REGISTERED_EVENT = "Listening to new Game event %s.";
local UNREGISTERED_EVENT = "Stopped listening to Game event %s, no more callbacks for this event.";

local EventFrame = CreateFrame("FRAME");

---Register a callback for a game event
---@param event string @ A game event to listen to
---@param callback func @ A callback that will be called when the event is fired with its arguments
function GameEvents.registerCallback(event, callback, handlerID)
	assert(Ellyb.Assertions.isType(event, "string", "event"));
	assert(Ellyb.Assertions.isType(callback, "function", "callback"));

	if not EventFrame:IsEventRegistered(event) then
		EventFrame:RegisterEvent(event);
		Logger:Info(format(REGISTERED_EVENT, tostring(event)))
	end

	return eventsDispatcher:RegisterCallback(event, callback, handlerID);
end

---Unregister a previously registered callback using the handler ID given at registration
---@param handlerID string @ The handler ID of a previsouly registered callback that we want to unregister
function GameEvents.unregisterCallback(handlerID)
	assert(Ellyb.Assertions.isType(handlerID, "string", "handlerID"));

	eventsDispatcher:UnregisterCallback(handlerID);
end

local function dispatchEvent(self, event, ...)
	if eventsDispatcher:HasCallbacksForEvent(event) then
		eventsDispatcher:TriggerEvent(event, ...);
	else
		self:UnregisterEvent(event);
		Logger:Info(format(UNREGISTERED_EVENT, tostring(event)));
	end
end

EventFrame:SetScript("OnEvent", dispatchEvent);

function GameEvents.triggerEvent(event, ...)
	assert(Ellyb.Assertions.isType(event, "string", "event"));
	dispatchEvent(EventFrame, event, ...)
end


Ellyb.GameEvents = GameEvents;
