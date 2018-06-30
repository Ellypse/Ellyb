---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Events then
	return
end

-- Lua imports
local pairs = pairs;
local assert = assert;

-- Ellyb imports
local Logger = Ellyb.Logger("Events");
local isType = Ellyb.Assertions.isType;
local generateUniqueID = Ellyb.Strings.generateUniqueID;

---@class EventsDispatcher : Object
--- Used for listening to NON game events and firing callbacks
local EventsDispatcher, _private = Ellyb.Class("EventsDispatcher");

local LOG_EVENT_REGISTERED = [[Registered new callback for event "%s" with handler ID "%s".]];
local LOG_EVENT_UNREGISTERED = [[Registered event callback with handler ID "%s" for event "%s".]];
local LOG_EVENT_FIRED_CALLBACK_FOR_EVENT = [[Fired event callback with handler ID "%s" for event "%s".
Parameters:]];

function EventsDispatcher:initialize()
	_private[self] = {};

	_private[self].callbackRegistry = {};

	Logger:Info("Initialized new EventDispatcher")
end

function EventsDispatcher:RegisterCallback(event, callback, handlerID)
	assert(isType(callback, "function", "callback"));

	if not _private[self].callbackRegistry[event] then
		_private[self].callbackRegistry[event] = {};
	end

	if handlerID ~= nil then
		assert(isType(handlerID, "string", "handlerID"));
	else
		handlerID = generateUniqueID(_private[self].callbackRegistry[event]);
	end
	_private[self].callbackRegistry[event][handlerID] = callback;

	Logger:Info(LOG_EVENT_REGISTERED:format(event, handlerID));

	return handlerID;
end

function EventsDispatcher:UnregisterCallback(handlerID)
	assert(isType(handlerID, "string", "handlerID"));

	for eventName, eventRegistry in pairs(_private[self].callbackRegistry) do
		if eventRegistry[handlerID] then
			eventRegistry[handlerID] = nil;
			Logger:Info(LOG_EVENT_UNREGISTERED:format(handlerID, eventName));
		end
	end
end

function EventsDispatcher:TriggerEvent(event, ...)
	local registry = _private[self].callbackRegistry[event];
	if registry then
		for handlerID, callback in pairs(registry) do
			callback(...);
			Logger:Info(LOG_EVENT_FIRED_CALLBACK_FOR_EVENT:format(handlerID, event), ...);
		end
	end
end

function EventsDispatcher:HasCallbacksForEvent(event)
	return not Ellyb.Tables.isEmpty(_private[self].callbackRegistry[event] or {});
end

Ellyb.EventsDispatcher = EventsDispatcher;
