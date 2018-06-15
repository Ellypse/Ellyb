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

---@class EventsDispatcher : Object
--- Used for listening to NON game events and firing callbacks
local EventsDispatcher, _private = Ellyb.Class("EventsDispatcher") ;

function EventsDispatcher:initialize()
	_private[self] = {};

	_private[self].callbackRegistry = {};

	Logger:Info("Initialized new EventDispatcher")
end

function EventsDispatcher:RegisterCallback(event, callback)
	assert(isType(event, "string", "event"));

	if not _private[self].callbackRegistry[event] then
		_private[self].callbackRegistry[event] = {};
	end

	if callback ~= nil then
		assert(isType(callback, "function", "callback"));
		_private[self].callbackRegistry[event][callback] = true;
	end

	Logger:Info("Registered new callback for event", event)
end

function EventsDispatcher:UnregisterCallback(event, callback)
	assert(isType(event, "string", "event"));
	assert(isType(callback, "function", "callback"));
	if _private[self].callbackRegistry[event] then
		_private[self].callbackRegistry[event][callback] = nil;
	end

	Logger:Info("Unregistered new callback for event", event)
end

function EventsDispatcher:TriggerEvent(event, ...)
	assert(isType(event, "string", "event"));
	local registry = _private[self].callbackRegistry[event];
	if registry then
		for callback in pairs(registry) do
			callback(...);
		end
	end
	Logger:Info("Triggered event", event, ...)
end

Ellyb.EventsDispatcher = EventsDispatcher;