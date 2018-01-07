---@type Ellyb
local _, Ellyb = ...;

-- WoW imports
local assert = assert;
local pairs = pairs;
local tostring = tostring;
local format = string.format;
local CreateFrame = CreateFrame;

---@param Ellyb Ellyb @ Instance of the library
local function OnLoad(Ellyb, env)

	---@class GameEvents
	--- Used for listening to in-game events and firing callbacks
	local GameEvents = {};
	Ellyb.GameEvents = GameEvents;

	local REGISTERED_EVENTS = {};

	local REGISTERED_CALLBACK = "Registered a new event callback for event %s with id %s.";
	local UNREGISTERED_CALLBACK = "Unregistered an event callback for event %s with id %s.";
	local EVENT_HANDLER_NOT_FOUND = "handlerID not found %s.";
	local REGISTERED_EVENT = "Listening to new event %s.";
	local UNREGISTERED_EVENT = "Stopped listening to event %s, no more callbacks for this event.";

	local EventFrame = CreateFrame("FRAME");

	setfenv(1, env);

	---Register a callback for a game event
	---@param event string @ A game event to listen to
	---@param callback func @ A callback that will be called when the event is fired with its arguments
	function GameEvents.registerHandler(event, callback)
		assert(Ellyb.Assertions.isType(event, "string", "event"));
		assert(Ellyb.Assertions.isType(callback, "function", "callback"));

		if not REGISTERED_EVENTS[event] then
			REGISTERED_EVENTS[event] = {};
			EventFrame:RegisterEvent(event);
			Logger:Log(format(REGISTERED_EVENT, tostring(event)))
		end

		local handlerID = Ellyb.Strings.generateUniqueID(REGISTERED_EVENTS);
		REGISTERED_EVENTS[event][handlerID] = callback;

		Logger:Log(format(REGISTERED_CALLBACK, tostring(event), handlerID));

		return handlerID;
	end

	---Unregister a previously registered callback using the handler ID given at registration
	---@param handlerID string @ The handler ID of a previsouly registered callback that we want to unregister
	function GameEvents.unregisterHandler(handlerID)
		assert(Ellyb.Assertions.isType(handlerID, "string", "handlerID"));

		-- Look for the handler ID through all the events
		for event, eventTab in pairs(REGISTERED_EVENTS) do
			if eventTab[handlerID] then
				eventTab[handlerID] = nil;

				-- If this specific event no longer has any callback, we can remove it and unregister it
				if Ellyb.Tables.size(eventTab) == 0 then
					REGISTERED_EVENTS[event] = nil;
					EventFrame:UnregisterEvent(event);
					Logger:Log(format(UNREGISTERED_EVENT, tostring(event)));
				end

				Logger:Log(format(UNREGISTERED_CALLBACK, tostring(event), handlerID));

				return;
			end
		end
		Logger:Warning(format(EVENT_HANDLER_NOT_FOUND, handlerID));
	end

	local function eventDispatcher(self, event, ...)
		-- Callbacks
		if REGISTERED_EVENTS[event] then
			local temp = Ellyb.Tables.getTempTable();

			-- We use a separate structure as the callback could change REGISTERED_EVENTS[event]
			Ellyb.Tables.copy(temp, REGISTERED_EVENTS[event])
			for _, callback in pairs(temp) do
				callback(...);
			end

			Ellyb.Tables.releaseTempTable(temp);
		else
			self:UnregisterEvent(event);
			Logger:Log(format(UNREGISTERED_EVENT, tostring(event)));
		end
	end

	EventFrame:SetScript("OnEvent", eventDispatcher);

	function GameEvents.fireEvent(event, ...)
		eventDispatcher(EventFrame, event, ...)
	end

end

---@param Ellyb Ellyb @ Instance of the library
local function OnModulesLoaded(Ellyb, env)

	setfenv(1, env);

	Logger = Ellyb.Logger("GameEvents");
end

Ellyb.ModulesManagement:RegisterNewModule("GameEvents", OnLoad, OnModulesLoaded);