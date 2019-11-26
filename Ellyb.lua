local package = {}
local preload, loaded = {}, {
  string = string,
  debug = debug,
  package = package,
  _G = _G,
  io = io,
  os = os,
  table = table,
  math = math,
  coroutine = coroutine,
}
package.preload, package.loaded = preload, loaded

local addonName, addonTable = ...
local function require( mod )
  if not loaded[ mod ] then
    local f = preload[ mod ]
    if f == nil then
      f = preload[ mod:gsub("%.", "/") ]
    end
    if f == nil then
      error( "module '"..mod..[[' not found:
       no field package.preload[']]..mod.."']", 1 )
    end
    local v = f( addonName, addonTable )
    if v ~= nil then
      loaded[ mod ] = v
    elseif loaded[ mod ] == nil then
      loaded[ mod ] = true
    end
  end
  return loaded[ mod ]
end

local function injectRequire(loadedString)
  setfenv(loadedString, setmetatable({ require = require }, {__index = _G;}))
  return loadedString
end
do

package.preload[ "Configuration/Configuration" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local Assertions = require \"Tools.Assertions\"\r\
\r\
---@class Ellyb_Configuration\r\
local Configuration = Class(\"Configuration\")\r\
\r\
local UNKNOWN_CONFIGURATION_KEY = [[Unknown configuration key %s.]];\r\
local CONFIGURATION_KEY_ALREADY_EXISTS = [[Configuration key %s has already been registered.]];\r\
\r\
---Constructor\r\
---@param savedVariablesName string @ The saved variable name, used to access the table from _G\r\
function Configuration:initialize(savedVariablesName)\r\
\9Assertions.isType(savedVariablesName, \"string\", \"savedVariablesName\");\r\
\r\
\9private[self] = {};\r\
\9private[self].savedVariablesName = savedVariablesName;\r\
\9private[self].configCallbackRegistry = CreateFromMixins(CallbackRegistryBaseMixin);\r\
\9private[self].configCallbackRegistry:OnLoad();\r\
\9private[self].defaultValues = {};\r\
\r\
\9-- Initialize the saved variables global table if it has never been initialized before\r\
\9if not _G[savedVariablesName] then\r\
\9\9_G[savedVariablesName] = {};\r\
\9end\r\
end\r\
\r\
--- Shortcut to declare a new configuration key by trying to add a new value to the Configuration object.\r\
function Configuration:__newindex(key, value)\r\
\9if self:IsConfigurationKeyRegistered(key) then\r\
\9\9self:SetValue(key, value)\r\
\9else\r\
\9\9self:RegisterConfigKey(key, value)\r\
\9end\r\
end\r\
\r\
--- Shortcut to read a configuration value by trying to read an unknown key from the Configuration object.\r\
function Configuration:__index(key)\r\
\9return self:GetValue(key)\r\
end\r\
\r\
--- Register a new configuration key with its default value\r\
---@param configurationKey string @ A new configuration key\r\
---@param defaultValue any @ The default value for this new configuration key\r\
function Configuration:RegisterConfigKey(configurationKey, defaultValue)\r\
\9Assertions.isType(configurationKey, \"string\", \"configurationKey\");\r\
\9assert(not self:IsConfigurationKeyRegistered(configurationKey), format(CONFIGURATION_KEY_ALREADY_EXISTS, configurationKey));\r\
\r\
\9private[self].defaultValues[configurationKey] = defaultValue;\r\
\r\
\9if self:GetValue(configurationKey) == nil then\r\
\9\9self:SetValue(configurationKey, defaultValue);\r\
\9end\r\
end\r\
\r\
---IsConfigurationKeyRegistered\r\
---@param configurationKey string @ A valid configuration key\r\
---@return boolean isRegistered @ True if the configuration has already been registered\r\
function Configuration:IsConfigurationKeyRegistered(configurationKey)\r\
\9Assertions.isType(configurationKey, \"string\", \"configurationKey\");\r\
\9return private[self].defaultValues[configurationKey] ~= nil;\r\
end\r\
\r\
--- Get the value of a configuration key\r\
---@param configurationKey string @ A valid configuration key, previously registered\r\
function Configuration:GetValue(configurationKey)\r\
\9return _G[private[self].savedVariablesName][configurationKey];\r\
end\r\
\r\
--- Set the value of a configuration key\r\
---@param configurationKey string @ A valid configuration key that has previously been registered\r\
---@param value any @ The new value for the configuration key\r\
function Configuration:SetValue(configurationKey, value)\r\
\9Assertions.isType(configurationKey, \"string\", \"configurationKey\");\r\
\9assert(self:IsConfigurationKeyRegistered(configurationKey), format(UNKNOWN_CONFIGURATION_KEY, configurationKey));\r\
\r\
\9local savedVariables = _G[private[self].savedVariablesName];\r\
\9if savedVariables[configurationKey] ~= value then\r\
\9\9savedVariables[configurationKey] = value;\r\
\9\9private[self].configCallbackRegistry:TriggerEvent(configurationKey, value);\r\
\9end\r\
end\r\
\r\
--- Reset the value of a configuration key to its default value\r\
---@param configurationKey string @ A valid configuration key that has previously been registered\r\
function Configuration:ResetValue(configurationKey)\r\
\9Assertions.isType(configurationKey, \"string\", \"configurationKey\");\r\
\9assert(self:IsConfigurationKeyRegistered(configurationKey), format(UNKNOWN_CONFIGURATION_KEY, configurationKey));\r\
\r\
\9self:SetValue(configurationKey, private[self].defaultValues[configurationKey]);\r\
end\r\
\r\
---OnChange\r\
---@param key string|string[] @ A configuration key or a list of configuration keys to listen for change\r\
---@param callback function @ A callback that will be called when the value of the given key changes.\r\
function Configuration:OnChange(key, callback)\r\
\9if type(key) == \"table\" then\r\
\9\9for _, k in pairs(key) do\r\
\9\9\9self:OnChange(k, callback);\r\
\9\9end\r\
\9else\r\
\9\9private[self].configCallbackRegistry:RegisterCallback(key, callback);\r\
\9end\r\
end\r\
\r\
return Configuration\r\
"
, '@'.."./Configuration/Configuration.lua" ) ) )

package.preload[ "Ellyb/Configuration" ] = injectRequire(assert( (loadstring or load)(
"local Configuration = require \"Configuration.Configuration\"\r\
local addOnName = ...\r\
\r\
local config = Configuration(addOnName .. \"_EllybConfig\")\r\
\r\
config.DEBUG_MODE = false\r\
\r\
return config"
, '@'.."./Ellyb/Configuration.lua" ) ) )

package.preload[ "Ellyb/Localization" ] = injectRequire(assert( (loadstring or load)(
"local Localization = require \"Tools.Localization.Localization\"\r\
local Locales = require \"Enums.Locales\"\r\
\r\
-- We are using Ellyb.loc here to store the locale table so we get code completion from the IDE\r\
-- The table will be replaced by the complete Localization system, with metatable lookups for the localization keys\r\
---@class loc : Ellyb_Localization\r\
local loc  = {\r\
\9-- System\r\
\9MODIFIERS_CTRL = \"Ctrl\",\r\
\9MODIFIERS_ALT = \"Alt\",\r\
\9MODIFIERS_SHIFT = \"Shift\",\r\
\9MODIFIERS_MAC_CTRL = \"Command\",\r\
\9MODIFIERS_MAC_ALT = \"Option\",\r\
\9MODIFIERS_MAC_SHIFT = \"Shift\",\r\
\9CLICK = \"Click\",\r\
\9RIGHT_CLICK = \"Right-Click\",\r\
\9LEFT_CLICK = \"Left-Click\",\r\
\9MIDDLE_CLICK = \"Middle-Click\",\r\
\9DOUBLE_CLICK = \"Double-Click\",\r\
\r\
\9-- Popups\r\
\9COPY_URL_POPUP_TEXT = [[\r\
You can copy this link by using the %s keyboard shortcut and then paste the link inside your browser using the %s shortcut.\r\
]],\r\
\r\
\9-- Patreon supporters\r\
\9---@language HTML\r\
\9PATREON_SUPPORTERS = [[This is add-on is being maintained and updated thanks to the help of <a href=\"ellypse_patreon\">|cfff96854Ellype's Patreon supporters|r</a>:\r\
\r\
%s\r\
]],\r\
};\r\
\r\
loc = Localization(loc);\r\
\r\
loc:RegisterNewLocale(Locales.ENGLISH, \"English\", {});\r\
\r\
loc:RegisterNewLocale(Locales.FRENCH, \"Français\", {\r\
\9-- System\r\
\9MODIFIERS_CTRL = \"Contrôle\",\r\
\9MODIFIERS_ALT = \"Alt\",\r\
\9MODIFIERS_SHIFT = \"Maj\",\r\
\9MODIFIERS_MAC_CTRL = \"Commande\",\r\
\9MODIFIERS_MAC_ALT = \"Option\",\r\
\9MODIFIERS_MAC_SHIFT = \"Maj\",\r\
\9CLICK = \"Clic\",\r\
\9RIGHT_CLICK = \"Clic droit\",\r\
\9LEFT_CLICK = \"Clic gauche\",\r\
\9MIDDLE_CLICK = \"Clic milieu\",\r\
\9DOUBLE_CLICK = \"Double clic\",\r\
\r\
\9-- Popups\r\
\9COPY_URL_POPUP_TEXT = [[\r\
Vous pouvez copier ce lien en utilisant le raccourci clavier %s pour ensuite le coller dans votre navigateur web avec le raccourci clavier %s.\r\
]],\r\
\r\
\9-- Patreon supporters\r\
\9---@language HTML\r\
\9PATREON_SUPPORTERS = [[Cet add-on est maintenu et mis-à-jour grâce au soutien des <a href=\"ellypse_patreon\">|cfff96854supporters du Patreon de Ellypse|r</a>:\r\
\r\
%s\r\
]],\r\
})\r\
\r\
loc:SetCurrentLocale(GetLocale(), true);\r\
\r\
return loc\r\
"
, '@'.."./Ellyb/Localization.lua" ) ) )

package.preload[ "Enums/Classes" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9HUNTER = \"HUNTER\",\r\
\9WARLOCK = \"WARLOCK\",\r\
\9PRIEST = \"PRIEST\",\r\
\9PALADIN = \"PALADIN\",\r\
\9MAGE = \"MAGE\",\r\
\9ROGUE = \"ROGUE\",\r\
\9DRUID = \"DRUID\",\r\
\9SHAMAN = \"SHAMAN\",\r\
\9WARRIOR = \"WARRIOR\",\r\
\9DEATHKNIGHT = \"DEATHKNIGHT\",\r\
\9MONK = \"MONK\",\r\
\9DEMONHUNTER = \"DEMONHUNTER\",\r\
}"
, '@'.."./Enums/Classes.lua" ) ) )

package.preload[ "Enums/Colors" ] = injectRequire(assert( (loadstring or load)(
"local ColorManager = require \"Tools.Colors.ColorManager\"\r\
local Classes = require \"Enums.Classes\"\r\
local ItemQualities = require \"Enums.ItemQualities\"\r\
\r\
-- We create a bunch of common Color constants to be quickly available everywhere\r\
-- The Colors are frozen so they cannot be altered\r\
\r\
return {\r\
\9-- Common colors\r\
\9RED = ColorManager.createFromRGBA(1, 0, 0):Freeze(),\r\
\9ORANGE = ColorManager.createFromRGBAAsBytes(255, 153, 0):Freeze(),\r\
\9YELLOW = ColorManager.createFromRGBA(1, 0.82, 0):Freeze(),\r\
\9GREEN = ColorManager.createFromRGBA(0, 1, 0):Freeze(),\r\
\9CYAN = ColorManager.createFromRGBA(0, 1, 1):Freeze(),\r\
\9BLUE = ColorManager.createFromRGBA(0, 0, 1):Freeze(),\r\
\9PURPLE = ColorManager.createFromRGBA(0.5, 0, 1):Freeze(),\r\
\9PINK = ColorManager.createFromRGBA(1, 0, 1):Freeze(),\r\
\9WHITE = ColorManager.createFromRGBA(1, 1, 1):Freeze(),\r\
\9GREY = ColorManager.createFromHexa(\"#CCC\"):Freeze(),\r\
\9BLACK = ColorManager.createFromRGBA(0, 0, 0):Freeze(),\r\
\r\
\9-- Classes colors\r\
\9HUNTER = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.HUNTER):GetRGBA()):Freeze(),\r\
\9WARLOCK = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.WARLOCK):GetRGBA()):Freeze(),\r\
\9PRIEST = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.PRIEST):GetRGBA()):Freeze(),\r\
\9PALADIN = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.PALADIN):GetRGBA()):Freeze(),\r\
\9MAGE = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.MAGE):GetRGBA()):Freeze(),\r\
\9ROGUE = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.ROGUE):GetRGBA()):Freeze(),\r\
\9DRUID = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.DRUID):GetRGBA()):Freeze(),\r\
\9SHAMAN = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.SHAMAN):GetRGBA()):Freeze(),\r\
\9WARRIOR = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.WARRIOR):GetRGBA()):Freeze(),\r\
\9DEATHKNIGHT = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.DEATHKNIGHT):GetRGBA()):Freeze(),\r\
\9MONK = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.MONK):GetRGBA()):Freeze(),\r\
\9DEMONHUNTER = ColorManager.createFromRGBA(C_ClassColor.GetClassColor(Classes.DEMONHUNTER):GetRGBA()):Freeze(),\r\
\r\
\9-- Brand colors\r\
\9TWITTER = ColorManager.createFromHexa(\"#1da1f2\"):Freeze(),\r\
\9BATTLE_NET = ColorManager.createFromTable(FRIENDS_BNET_NAME_COLOR):Freeze(),\r\
\r\
\9-- Item colors\r\
\9-- ITEM QUALITY\r\
\9-- BAG_ITEM_QUALITY_COLORS[LE_ITEM_QUALITY_COMMON] is actually the POOR (grey) color.\r\
\9-- There is no common quality color in BAG_ITEM_QUALITY_COLORS. Bravo Blizzard 👏\r\
\r\
\9ITEM_POOR = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.COMMON]):Freeze(),\r\
\9ITEM_COMMON = ColorManager.createFromRGBA(0.95, 0.95, 0.95):Freeze(), -- Common quality is a slightly faded white\r\
\9ITEM_UNCOMMON = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.UNCOMMON]):Freeze(),\r\
\9ITEM_RARE = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.RARE]):Freeze(),\r\
\9ITEM_EPIC = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.EPIC]):Freeze(),\r\
\9ITEM_LEGENDARY = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.LEGENDARY]):Freeze(),\r\
\9ITEM_ARTIFACT = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.ARTIFACT]):Freeze(),\r\
\9ITEM_HEIRLOOM = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.HEIRLOOM]):Freeze(),\r\
\9ITEM_WOW_TOKEN = ColorManager.createFromTable(BAG_ITEM_QUALITY_COLORS[ItemQualities.WOW_TOKEN]):Freeze(),\r\
\r\
\9-- FACTIONS\r\
\9ALLIANCE = ColorManager.createFromTable(PLAYER_FACTION_COLORS[1]):Freeze(),\r\
\9HORDE = ColorManager.createFromTable(PLAYER_FACTION_COLORS[0]):Freeze(), -- Yup, this is a table with a 0 index. Blizzard ¯\\_(ツ)_/¯\r\
\r\
\9-- POWERBAR COLORS\r\
\9POWER_MANA = ColorManager.createFromTable(PowerBarColor[\"MANA\"]):Freeze(),\r\
\9POWER_RAGE = ColorManager.createFromTable(PowerBarColor[\"RAGE\"]):Freeze(),\r\
\9POWER_FOCUS = ColorManager.createFromTable(PowerBarColor[\"FOCUS\"]):Freeze(),\r\
\9POWER_ENERGY = ColorManager.createFromTable(PowerBarColor[\"ENERGY\"]):Freeze(),\r\
\9POWER_COMBO_POINTS = ColorManager.createFromTable(PowerBarColor[\"COMBO_POINTS\"]):Freeze(),\r\
\9POWER_RUNES = ColorManager.createFromTable(PowerBarColor[\"RUNES\"]):Freeze(),\r\
\9POWER_RUNIC_POWER = ColorManager.createFromTable(PowerBarColor[\"RUNIC_POWER\"]):Freeze(),\r\
\9POWER_SOUL_SHARDS = ColorManager.createFromTable(PowerBarColor[\"SOUL_SHARDS\"]):Freeze(),\r\
\9POWER_LUNAR_POWER = ColorManager.createFromTable(PowerBarColor[\"LUNAR_POWER\"]):Freeze(),\r\
\9POWER_HOLY_POWER = ColorManager.createFromTable(PowerBarColor[\"HOLY_POWER\"]):Freeze(),\r\
\9POWER_MAELSTROM = ColorManager.createFromTable(PowerBarColor[\"MAELSTROM\"]):Freeze(),\r\
\9POWER_INSANITY = ColorManager.createFromTable(PowerBarColor[\"INSANITY\"]):Freeze(),\r\
\9POWER_CHI = ColorManager.createFromTable(PowerBarColor[\"CHI\"]):Freeze(),\r\
\9POWER_ARCANE_CHARGES = ColorManager.createFromTable(PowerBarColor[\"ARCANE_CHARGES\"]):Freeze(),\r\
\9POWER_FURY = ColorManager.createFromTable(PowerBarColor[\"FURY\"]):Freeze(),\r\
\9POWER_PAIN = ColorManager.createFromTable(PowerBarColor[\"PAIN\"]):Freeze(),\r\
\9POWER_AMMOSLOT = ColorManager.createFromTable(PowerBarColor[\"AMMOSLOT\"]):Freeze(),\r\
\9POWER_FUEL = ColorManager.createFromTable(PowerBarColor[\"FUEL\"]):Freeze(),\r\
\r\
\9-- OTHER GAME STUFF\r\
\9CRAFTING_REAGENT = ColorManager.createFromHexa(\"#66bbff\"):Freeze(),\r\
\r\
\9LINKS = {\r\
\9\9achievement = ColorManager.createFromHexa(\"#ffff00\"):Freeze(),\r\
\9\9talent = ColorManager.createFromHexa(\"#4e96f7\"):Freeze(),\r\
\9\9trade = ColorManager.createFromHexa(\"#ffd000\"):Freeze(),\r\
\9\9enchant = ColorManager.createFromHexa(\"#ffd000\"):Freeze(),\r\
\9\9instancelock = ColorManager.createFromHexa(\"#ff8000\"):Freeze(),\r\
\9\9journal = ColorManager.createFromHexa(\"#66bbff\"):Freeze(),\r\
\9\9battlePetAbil = ColorManager.createFromHexa(\"#4e96f7\"):Freeze(),\r\
\9\9battlepet = ColorManager.createFromHexa(\"#ffd200\"):Freeze(),\r\
\9\9garrmission = ColorManager.createFromHexa(\"#ffff00\"):Freeze(),\r\
\9\9transmogillusion = ColorManager.createFromHexa(\"#ff80ff\"):Freeze(),\r\
\9\9transmogappearance = ColorManager.createFromHexa(\"#ff80ff\"):Freeze(),\r\
\9\9transmogset = ColorManager.createFromHexa(\"#ff80ff\"):Freeze(),\r\
\9}\r\
}"
, '@'.."./Enums/Colors.lua" ) ) )

package.preload[ "Enums/GameClientTypes" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9RETAIL = WOW_PROJECT_MAINLINE,\r\
\9CLASSIC = WOW_PROJECT_CLASSIC\r\
}"
, '@'.."./Enums/GameClientTypes.lua" ) ) )

package.preload[ "Enums/ItemQualities" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9POOR = LE_ITEM_QUALITY_POOR,\r\
\9COMMON = LE_ITEM_QUALITY_COMMON,\r\
\9UNCOMMON = LE_ITEM_QUALITY_UNCOMMON,\r\
\9RARE = LE_ITEM_QUALITY_RARE,\r\
\9EPIC = LE_ITEM_QUALITY_EPIC,\r\
\9LEGENDARY = LE_ITEM_QUALITY_LEGENDARY,\r\
\9ARTIFACT = LE_ITEM_QUALITY_ARTIFACT,\r\
\9HEIRLOOM = LE_ITEM_QUALITY_HEIRLOOM,\r\
\9WOW_TOKEN = LE_ITEM_QUALITY_WOW_TOKEN,\r\
}"
, '@'.."./Enums/ItemQualities.lua" ) ) )

package.preload[ "Enums/Locales" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9FRENCH = \"frFR\",\r\
\9ENGLISH = \"enUS\",\r\
}"
, '@'.."./Enums/Locales.lua" ) ) )

package.preload[ "Enums/SpecialCharacters" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9NON_BREAKING_SPACE = \" \"\r\
}"
, '@'.."./Enums/SpecialCharacters.lua" ) ) )

package.preload[ "Enums/UiEscapeSequences" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9CLOSE = \"|r\",\r\
\9COLOR = \"|c%.2x%.2x%.2x%.2x\",\r\
\9TEXTURE = \"|T%s:%s:%s|t\",\r\
\9TEXTURE_WITH_COORDINATES = \"|T%s:%d:%d:0:0:%d:%d:%d:%d:%d:%d|\"\r\
}"
, '@'.."./Enums/UiEscapeSequences.lua" ) ) )

package.preload[ "Events/EventsDispatcher" ] = injectRequire(assert( (loadstring or load)(
"local Logger = require \"Logs.Logger\"\r\
local Assertions = require \"Tools.Assertions\"\r\
local Strings = require \"Tools.Strings.Strings\"\r\
local Tables = require \"Tools.Tables\"\r\
\r\
local logger = Logger(\"Events\")\r\
\r\
local EventsDispatcher = {}\r\
\r\
local LOG_EVENT_REGISTERED = [[Registered new callback for event \"%s\" with handler ID \"%s\".]]\r\
local LOG_EVENT_UNREGISTERED = [[Registered event callback with handler ID \"%s\" for event \"%s\".]]\r\
\r\
local callbackRegistry = {}\r\
\r\
--- Register a callback that we want to be called when the given event is fired.\r\
---@param event string The event we want to listen to\r\
---@param callback function A callback that will be called when the event is fired. Will receive the arguments passed when firing the event.\r\
---@param handlerID string An optional handler ID to re-use, for cases where we register a callback for more than one event\r\
---@return string Handler ID, either the one that was given or a generated one\r\
---@overload fun(event:string, callback: function):string\r\
function EventsDispatcher.registerCallback(event, callback, handlerID)\r\
\9Assertions.isType(event, \"string\", \"event\")\r\
\9Assertions.isType(callback, \"function\", \"callback\")\r\
\r\
\9if not callbackRegistry[event] then\r\
\9\9callbackRegistry[event] = {}\r\
\9end\r\
\r\
\9if handlerID ~= nil then\r\
\9\9Assertions.isType(handlerID, \"string\", \"handlerID\")\r\
\9else\r\
\9\9handlerID = Strings.generateUniqueID(callbackRegistry[event])\r\
\9end\r\
\9callbackRegistry[event][handlerID] = callback\r\
\r\
\9logger:Info(LOG_EVENT_REGISTERED:format(event, handlerID))\r\
\r\
\9return handlerID\r\
end\r\
\r\
--- Unregister a callback using its generated handler ID.\r\
--- If the callback was registered with that ID to more than one event, all events registered with this ID will be unregistered.\r\
---@param handlerID string The handler ID for the callback we want to unregister.\r\
function EventsDispatcher.unregisterCallback(handlerID)\r\
\9Assertions.isType(handlerID, \"string\", \"handlerID\")\r\
\r\
\9for eventName, eventRegistry in pairs(callbackRegistry) do\r\
\9\9if eventRegistry[handlerID] then\r\
\9\9\9eventRegistry[handlerID] = nil\r\
\9\9\9logger:Info(LOG_EVENT_UNREGISTERED:format(handlerID, eventName))\r\
\9\9end\r\
\9end\r\
end\r\
\r\
--- Fire the given event with the given passed arguments. All callbacks will receive these arguments.\r\
---@param event string The event we want to fire\r\
---@vararg any Any argument we want to pass to the event's registered callback\r\
function EventsDispatcher.triggerEvent(event, ...)\r\
\9Assertions.isType(event, \"string\", \"event\")\r\
\9local registry = callbackRegistry[event]\r\
\9if registry then\r\
\9\9for _, callback in pairs(registry) do\r\
\9\9\9xpcall(callback, CallErrorHandler, ...)\r\
\9\9end\r\
\9end\r\
end\r\
\r\
--- Check if this EventsDispatcher has at least one callback registered for a given event\r\
---@param event string The event we want to check\r\
---@return boolean True if this EventsDispatcher has a callback registered for the given event\r\
function EventsDispatcher.hasCallbacksForEvent(event)\r\
\9Assertions.isType(event, \"string\", \"event\")\r\
\9return not Tables.isEmpty(callbackRegistry[event] or {})\r\
end\r\
\r\
return EventsDispatcher"
, '@'.."./Events/EventsDispatcher.lua" ) ) )

package.preload[ "Events/GameEvents" ] = injectRequire(assert( (loadstring or load)(
"local Logger = require \"Logs.Logger\"\r\
local Assertions = require \"Tools.Assertions\"\r\
local EventsDispatcher = require \"Events.EventsDispatcher\"\r\
\r\
-- Ellyb imports\r\
local logger = Logger(\"GameEvents\")\r\
\r\
--- Used for listening to in-game events and firing callbacks\r\
local GameEvents = {}\r\
\r\
local EventFrame = CreateFrame(\"FRAME\")\r\
\r\
---Register a callback for a game event\r\
---@param event string @ A game event to listen to\r\
---@param callback function @ A callback that will be called when the event is fired with its arguments\r\
function GameEvents.registerCallback(event, callback, handlerID)\r\
\9Assertions.isType(event, \"string\", \"event\")\r\
\9Assertions.isType(callback, \"function\", \"callback\")\r\
\r\
\9if not EventFrame:IsEventRegistered(event) then\r\
\9\9EventFrame:RegisterEvent(event)\r\
\9\9logger:Info((\"Listening to new Game event %s.\"):format(tostring(event)))\r\
\9end\r\
\r\
\9return EventsDispatcher.registerCallback(event, callback, handlerID)\r\
end\r\
\r\
---Unregister a previously registered callback using the handler ID given at registration\r\
---@param handlerID string @ The handler ID of a previsouly registered callback that we want to unregister\r\
function GameEvents.unregisterCallback(handlerID)\r\
\9Assertions.isType(handlerID, \"string\", \"handlerID\")\r\
\r\
\9EventsDispatcher.unregisterCallback(handlerID)\r\
end\r\
\r\
local function dispatchEvent(self, event, ...)\r\
\9if EventsDispatcher.hasCallbacksForEvent(event) then\r\
\9\9EventsDispatcher.triggerEvent(event, ...)\r\
\9else\r\
\9\9self:UnregisterEvent(event)\r\
\9\9logger:Info((\"Stopped listening to Game event %s, no more callbacks for this event\"):format(tostring(event)))\r\
\9end\r\
end\r\
\r\
EventFrame:SetScript(\"OnEvent\", dispatchEvent)\r\
\r\
function GameEvents.triggerEvent(event, ...)\r\
\9Assertions.isType(event, \"string\", \"event\")\r\
\9dispatchEvent(EventFrame, event, ...)\r\
end\r\
\r\
return GameEvents"
, '@'.."./Events/GameEvents.lua" ) ) )

package.preload[ "Internals/PooledObjectMixin" ] = injectRequire(assert( (loadstring or load)(
"-- Unique and private symbol that is used as the index on a class' static table to reference the original allocator.\r\
local ALLOCATOR_KEY = newproxy(false)\r\
\r\
-- Table mapping class references to a sub-table containing the pooled instances of that class.\r\
local instances = setmetatable({}, { __mode = \"k\" })\r\
\r\
--- Allocates a given class, returning either a previously-allocated instance present in the pool\r\
--- or a newly-allocated one using the allocator function it had at the time of mixin inclusion.\r\
local function pooledAllocator(class)\r\
\9-- Grab the appropriate pool for this class in the instances table or create one.\r\
\9-- This means each class (and subclass!) gets its own pool.\r\
\9local pool = instances[class]\r\
\9if not pool then\r\
\9\9pool = setmetatable({}, { __mode = \"k\" })\r\
\9\9instances[class] = pool\r\
\9end\r\
\r\
\9-- Grab the next free instance from the pool or call the original allocator to make one.\r\
\9local instance = next(pool)\r\
\9if not instance then\r\
\9\9instance = class[ALLOCATOR_KEY](class)\r\
\9end\r\
\r\
\9pool[instance] = nil\r\
\9return instance\r\
end\r\
\r\
--- @class PooledObjectMixin\r\
--- Mixin that, when applied to a class, allows it to allocate instances from a reusable pool.\r\
--- Instances can be returned to the pool via an attached method.\r\
---\r\
--- The pool for each class is distinct, even if you inherit a class that includes this mixin.\r\
--- When an instance is retrieved from the pool it is subject to normal class initialization procedures,\r\
--- including the call of the initialize() method.\r\
local PooledObjectMixin = {}\r\
\r\
--- Releases the instance back into the pool. The instance should not be used after this call.\r\
function PooledObjectMixin:ReleasePooledObject()\r\
\9-- This should be safe; even though the instances table is weakly-keyed\r\
\9-- the instance itself has a reference to the class.\r\
\9instances[self.class][self] = true\r\
end\r\
\r\
--- Hook invoked whenever a class includes this mixin.\r\
--- Records the original allocator on a class and replaces it with our pooled allocator.\r\
---@param class MiddleClass_Class\r\
function PooledObjectMixin:included(class)\r\
\9-- Get the original allocator for the class and hide it on the class.\r\
\9local allocator = class.static.allocate\r\
\9class.static[ALLOCATOR_KEY] = allocator\r\
\r\
\9class.static.allocate = pooledAllocator\r\
end\r\
\r\
return PooledObjectMixin\r\
"
, '@'.."./Internals/PooledObjectMixin.lua" ) ) )

package.preload[ "Internals/PrivateStorage" ] = injectRequire(assert( (loadstring or load)(
"--- Private storage table, used to store private properties by indexing the table per instance of a class.\r\
--- The table has weak indexes which means it will not prevent the objects from being garbage collected.\r\
--- Example:\r\
--- > `local private = require \"Internals.PrivateStorage\"`\r\
--- > `local myClassInstance = MyClass()`\r\
--- > `private[myClassInstance].privateProperty = someValue`\r\
---@type table\r\
local privateStorage = setmetatable({},{\r\
\9__index = function(store, instance) -- Remove need to initialize the private table for each instance, we lazy instantiate it\r\
\9\9store[instance] = {}\r\
\9\9return store[instance]\r\
\9end,\r\
\9__mode = \"k\", -- Weak table keys: allow stored instances to be garbage collected\r\
\9__metatable = \"You are not allowed to access the metatable of this private storage\",\r\
})\r\
\r\
return privateStorage"
, '@'.."./Internals/PrivateStorage.lua" ) ) )

package.preload[ "Libraries/easings" ] = injectRequire(assert( (loadstring or load)(
"--\r\
-- Adapted from\r\
-- Tweener's easing functions (Penner's Easing Equations)\r\
-- and http://code.google.com/p/tweener/ (jstweener javascript version)\r\
--\r\
\r\
--[[\r\
Disclaimer for Robert Penner's Easing Equations license:\r\
\r\
TERMS OF USE - EASING EQUATIONS\r\
\r\
Open source under the BSD License.\r\
\r\
Copyright © 2001 Robert Penner\r\
All rights reserved.\r\
\r\
Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:\r\
\r\
    * Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.\r\
    * Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.\r\
    * Neither the name of the author nor the names of contributors may be used to endorse or promote products derived from this software without specific prior written permission.\r\
\r\
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS \"AS IS\" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.\r\
]]\r\
\r\
-- For all easing functions:\r\
-- t = elapsed time\r\
-- b = begin\r\
-- c = change == ending - beginning\r\
-- d = duration (total time)\r\
\r\
local pow = math.pow\r\
local sin = math.sin\r\
local cos = math.cos\r\
local pi = math.pi\r\
local sqrt = math.sqrt\r\
local abs = math.abs\r\
local asin = math.asin\r\
\r\
local function linear(t, b, c, d)\r\
\9return c * t / d + b\r\
end\r\
\r\
local function inQuad(t, b, c, d)\r\
\9t = t / d\r\
\9return c * pow(t, 2) + b\r\
end\r\
\r\
local function outQuad(t, b, c, d)\r\
\9t = t / d\r\
\9return -c * t * (t - 2) + b\r\
end\r\
\r\
local function inOutQuad(t, b, c, d)\r\
\9t = t / d * 2\r\
\9if t < 1 then\r\
\9\9return c / 2 * pow(t, 2) + b\r\
\9else\r\
\9\9return -c / 2 * ((t - 1) * (t - 3) - 1) + b\r\
\9end\r\
end\r\
\r\
local function outInQuad(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outQuad(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inQuad((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
local function inCubic (t, b, c, d)\r\
\9t = t / d\r\
\9return c * pow(t, 3) + b\r\
end\r\
\r\
local function outCubic(t, b, c, d)\r\
\9t = t / d - 1\r\
\9return c * (pow(t, 3) + 1) + b\r\
end\r\
\r\
local function inOutCubic(t, b, c, d)\r\
\9t = t / d * 2\r\
\9if t < 1 then\r\
\9\9return c / 2 * t * t * t + b\r\
\9else\r\
\9\9t = t - 2\r\
\9\9return c / 2 * (t * t * t + 2) + b\r\
\9end\r\
end\r\
\r\
local function outInCubic(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outCubic(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inCubic((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
local function inQuart(t, b, c, d)\r\
\9t = t / d\r\
\9return c * pow(t, 4) + b\r\
end\r\
\r\
local function outQuart(t, b, c, d)\r\
\9t = t / d - 1\r\
\9return -c * (pow(t, 4) - 1) + b\r\
end\r\
\r\
local function inOutQuart(t, b, c, d)\r\
\9t = t / d * 2\r\
\9if t < 1 then\r\
\9\9return c / 2 * pow(t, 4) + b\r\
\9else\r\
\9\9t = t - 2\r\
\9\9return -c / 2 * (pow(t, 4) - 2) + b\r\
\9end\r\
end\r\
\r\
local function outInQuart(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outQuart(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inQuart((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
local function inQuint(t, b, c, d)\r\
\9t = t / d\r\
\9return c * pow(t, 5) + b\r\
end\r\
\r\
local function outQuint(t, b, c, d)\r\
\9t = t / d - 1\r\
\9return c * (pow(t, 5) + 1) + b\r\
end\r\
\r\
local function inOutQuint(t, b, c, d)\r\
\9t = t / d * 2\r\
\9if t < 1 then\r\
\9\9return c / 2 * pow(t, 5) + b\r\
\9else\r\
\9\9t = t - 2\r\
\9\9return c / 2 * (pow(t, 5) + 2) + b\r\
\9end\r\
end\r\
\r\
local function outInQuint(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outQuint(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inQuint((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
local function inSine(t, b, c, d)\r\
\9return -c * cos(t / d * (pi / 2)) + c + b\r\
end\r\
\r\
local function outSine(t, b, c, d)\r\
\9return c * sin(t / d * (pi / 2)) + b\r\
end\r\
\r\
local function inOutSine(t, b, c, d)\r\
\9return -c / 2 * (cos(pi * t / d) - 1) + b\r\
end\r\
\r\
local function outInSine(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outSine(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inSine((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
local function inExpo(t, b, c, d)\r\
\9if t == 0 then\r\
\9\9return b\r\
\9else\r\
\9\9return c * pow(2, 10 * (t / d - 1)) + b - c * 0.001\r\
\9end\r\
end\r\
\r\
local function outExpo(t, b, c, d)\r\
\9if t == d then\r\
\9\9return b + c\r\
\9else\r\
\9\9return c * 1.001 * (-pow(2, -10 * t / d) + 1) + b\r\
\9end\r\
end\r\
\r\
local function inOutExpo(t, b, c, d)\r\
\9if t == 0 then\r\
\9\9return b\r\
\9end\r\
\9if t == d then\r\
\9\9return b + c\r\
\9end\r\
\9t = t / d * 2\r\
\9if t < 1 then\r\
\9\9return c / 2 * pow(2, 10 * (t - 1)) + b - c * 0.0005\r\
\9else\r\
\9\9t = t - 1\r\
\9\9return c / 2 * 1.0005 * (-pow(2, -10 * t) + 2) + b\r\
\9end\r\
end\r\
\r\
local function outInExpo(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outExpo(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inExpo((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
local function inCirc(t, b, c, d)\r\
\9t = t / d\r\
\9return (-c * (sqrt(1 - pow(t, 2)) - 1) + b)\r\
end\r\
\r\
local function outCirc(t, b, c, d)\r\
\9t = t / d - 1\r\
\9return (c * sqrt(1 - pow(t, 2)) + b)\r\
end\r\
\r\
local function inOutCirc(t, b, c, d)\r\
\9t = t / d * 2\r\
\9if t < 1 then\r\
\9\9return -c / 2 * (sqrt(1 - t * t) - 1) + b\r\
\9else\r\
\9\9t = t - 2\r\
\9\9return c / 2 * (sqrt(1 - t * t) + 1) + b\r\
\9end\r\
end\r\
\r\
local function outInCirc(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outCirc(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inCirc((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
local function inElastic(t, b, c, d, a, p)\r\
\9if t == 0 then\r\
\9\9return b\r\
\9end\r\
\r\
\9t = t / d\r\
\r\
\9if t == 1 then\r\
\9\9return b + c\r\
\9end\r\
\r\
\9if not p then\r\
\9\9p = d * 0.3\r\
\9end\r\
\r\
\9local s\r\
\r\
\9if not a or a < abs(c) then\r\
\9\9a = c\r\
\9\9s = p / 4\r\
\9else\r\
\9\9s = p / (2 * pi) * asin(c / a)\r\
\9end\r\
\r\
\9t = t - 1\r\
\r\
\9return -(a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b\r\
end\r\
\r\
-- a: amplitud\r\
-- p: period\r\
local function outElastic(t, b, c, d, a, p)\r\
\9if t == 0 then\r\
\9\9return b\r\
\9end\r\
\r\
\9t = t / d\r\
\r\
\9if t == 1 then\r\
\9\9return b + c\r\
\9end\r\
\r\
\9if not p then\r\
\9\9p = d * 0.3\r\
\9end\r\
\r\
\9local s\r\
\r\
\9if not a or a < abs(c) then\r\
\9\9a = c\r\
\9\9s = p / 4\r\
\9else\r\
\9\9s = p / (2 * pi) * asin(c / a)\r\
\9end\r\
\r\
\9return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) + c + b\r\
end\r\
\r\
-- p = period\r\
-- a = amplitud\r\
local function inOutElastic(t, b, c, d, a, p)\r\
\9if t == 0 then\r\
\9\9return b\r\
\9end\r\
\r\
\9t = t / d * 2\r\
\r\
\9if t == 2 then\r\
\9\9return b + c\r\
\9end\r\
\r\
\9if not p then\r\
\9\9p = d * (0.3 * 1.5)\r\
\9end\r\
\9if not a then\r\
\9\9a = 0\r\
\9end\r\
\r\
\9local s\r\
\r\
\9if not a or a < abs(c) then\r\
\9\9a = c\r\
\9\9s = p / 4\r\
\9else\r\
\9\9s = p / (2 * pi) * asin(c / a)\r\
\9end\r\
\r\
\9if t < 1 then\r\
\9\9t = t - 1\r\
\9\9return -0.5 * (a * pow(2, 10 * t) * sin((t * d - s) * (2 * pi) / p)) + b\r\
\9else\r\
\9\9t = t - 1\r\
\9\9return a * pow(2, -10 * t) * sin((t * d - s) * (2 * pi) / p) * 0.5 + c + b\r\
\9end\r\
end\r\
\r\
-- a: amplitud\r\
-- p: period\r\
local function outInElastic(t, b, c, d, a, p)\r\
\9if t < d / 2 then\r\
\9\9return outElastic(t * 2, b, c / 2, d, a, p)\r\
\9else\r\
\9\9return inElastic((t * 2) - d, b + c / 2, c / 2, d, a, p)\r\
\9end\r\
end\r\
\r\
local function inBack(t, b, c, d, s)\r\
\9if not s then\r\
\9\9s = 1.70158\r\
\9end\r\
\9t = t / d\r\
\9return c * t * t * ((s + 1) * t - s) + b\r\
end\r\
\r\
local function outBack(t, b, c, d, s)\r\
\9if not s then\r\
\9\9s = 1.70158\r\
\9end\r\
\9t = t / d - 1\r\
\9return c * (t * t * ((s + 1) * t + s) + 1) + b\r\
end\r\
\r\
local function inOutBack(t, b, c, d, s)\r\
\9if not s then\r\
\9\9s = 1.70158\r\
\9end\r\
\9s = s * 1.525\r\
\9t = t / d * 2\r\
\9if t < 1 then\r\
\9\9return c / 2 * (t * t * ((s + 1) * t - s)) + b\r\
\9else\r\
\9\9t = t - 2\r\
\9\9return c / 2 * (t * t * ((s + 1) * t + s) + 2) + b\r\
\9end\r\
end\r\
\r\
local function outInBack(t, b, c, d, s)\r\
\9if t < d / 2 then\r\
\9\9return outBack(t * 2, b, c / 2, d, s)\r\
\9else\r\
\9\9return inBack((t * 2) - d, b + c / 2, c / 2, d, s)\r\
\9end\r\
end\r\
\r\
local function outBounce(t, b, c, d)\r\
\9t = t / d\r\
\9if t < 1 / 2.75 then\r\
\9\9return c * (7.5625 * t * t) + b\r\
\9elseif t < 2 / 2.75 then\r\
\9\9t = t - (1.5 / 2.75)\r\
\9\9return c * (7.5625 * t * t + 0.75) + b\r\
\9elseif t < 2.5 / 2.75 then\r\
\9\9t = t - (2.25 / 2.75)\r\
\9\9return c * (7.5625 * t * t + 0.9375) + b\r\
\9else\r\
\9\9t = t - (2.625 / 2.75)\r\
\9\9return c * (7.5625 * t * t + 0.984375) + b\r\
\9end\r\
end\r\
\r\
local function inBounce(t, b, c, d)\r\
\9return c - outBounce(d - t, 0, c, d) + b\r\
end\r\
\r\
local function inOutBounce(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return inBounce(t * 2, 0, c, d) * 0.5 + b\r\
\9else\r\
\9\9return outBounce(t * 2 - d, 0, c, d) * 0.5 + c * .5 + b\r\
\9end\r\
end\r\
\r\
local function outInBounce(t, b, c, d)\r\
\9if t < d / 2 then\r\
\9\9return outBounce(t * 2, b, c / 2, d)\r\
\9else\r\
\9\9return inBounce((t * 2) - d, b + c / 2, c / 2, d)\r\
\9end\r\
end\r\
\r\
return {\r\
\9linear = linear,\r\
\9inQuad = inQuad,\r\
\9outQuad = outQuad,\r\
\9inOutQuad = inOutQuad,\r\
\9outInQuad = outInQuad,\r\
\9inCubic = inCubic,\r\
\9outCubic = outCubic,\r\
\9inOutCubic = inOutCubic,\r\
\9outInCubic = outInCubic,\r\
\9inQuart = inQuart,\r\
\9outQuart = outQuart,\r\
\9inOutQuart = inOutQuart,\r\
\9outInQuart = outInQuart,\r\
\9inQuint = inQuint,\r\
\9outQuint = outQuint,\r\
\9inOutQuint = inOutQuint,\r\
\9outInQuint = outInQuint,\r\
\9inSine = inSine,\r\
\9outSine = outSine,\r\
\9inOutSine = inOutSine,\r\
\9outInSine = outInSine,\r\
\9inExpo = inExpo,\r\
\9outExpo = outExpo,\r\
\9inOutExpo = inOutExpo,\r\
\9outInExpo = outInExpo,\r\
\9inCirc = inCirc,\r\
\9outCirc = outCirc,\r\
\9inOutCirc = inOutCirc,\r\
\9outInCirc = outInCirc,\r\
\9inElastic = inElastic,\r\
\9outElastic = outElastic,\r\
\9inOutElastic = inOutElastic,\r\
\9outInElastic = outInElastic,\r\
\9inBack = inBack,\r\
\9outBack = outBack,\r\
\9inOutBack = inOutBack,\r\
\9outInBack = outInBack,\r\
\9inBounce = inBounce,\r\
\9outBounce = outBounce,\r\
\9inOutBounce = inOutBounce,\r\
\9outInBounce = outInBounce,\r\
}"
, '@'.."./Libraries/easings.lua" ) ) )

package.preload[ "Libraries/middleclass" ] = injectRequire(assert( (loadstring or load)(
"local middleclass = {\r\
  _VERSION     = 'middleclass v4.1.1',\r\
  _DESCRIPTION = 'Object Orientation for Lua',\r\
  _URL         = 'https://github.com/kikito/middleclass',\r\
  _LICENSE     = [[\r\
    MIT LICENSE\r\
\r\
    Copyright (c) 2011 Enrique García Cota\r\
\r\
    Permission is hereby granted, free of charge, to any person obtaining a\r\
    copy of this software and associated documentation files (the\r\
    \"Software\"), to deal in the Software without restriction, including\r\
    without limitation the rights to use, copy, modify, merge, publish,\r\
    distribute, sublicense, and/or sell copies of the Software, and to\r\
    permit persons to whom the Software is furnished to do so, subject to\r\
    the following conditions:\r\
\r\
    The above copyright notice and this permission notice shall be included\r\
    in all copies or substantial portions of the Software.\r\
\r\
    THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS\r\
    OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF\r\
    MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.\r\
    IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY\r\
    CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,\r\
    TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE\r\
    SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.\r\
  ]]\r\
}\r\
\r\
local function _createIndexWrapper(aClass, f)\r\
  if f == nil then\r\
    return aClass.__instanceDict\r\
  else\r\
    return function(self, name)\r\
      local value = aClass.__instanceDict[name]\r\
\r\
      if value ~= nil then\r\
        return value\r\
      elseif type(f) == \"function\" then\r\
        return (f(self, name))\r\
      else\r\
        return f[name]\r\
      end\r\
    end\r\
  end\r\
end\r\
\r\
local function _propagateInstanceMethod(aClass, name, f)\r\
  f = name == \"__index\" and _createIndexWrapper(aClass, f) or f\r\
  aClass.__instanceDict[name] = f\r\
\r\
  for subclass in pairs(aClass.subclasses) do\r\
    if rawget(subclass.__declaredMethods, name) == nil then\r\
      _propagateInstanceMethod(subclass, name, f)\r\
    end\r\
  end\r\
end\r\
\r\
local function _declareInstanceMethod(aClass, name, f)\r\
  aClass.__declaredMethods[name] = f\r\
\r\
  if f == nil and aClass.super then\r\
    f = aClass.super.__instanceDict[name]\r\
  end\r\
\r\
  _propagateInstanceMethod(aClass, name, f)\r\
end\r\
\r\
local function _tostring(self) return \"class \" .. self.name end\r\
local function _call(self, ...) return self:new(...) end\r\
\r\
local function _createClass(name, super)\r\
  local dict = {}\r\
  dict.__index = dict\r\
\r\
  local aClass = { name = name, super = super, static = {},\r\
                   __instanceDict = dict, __declaredMethods = {},\r\
                   subclasses = setmetatable({}, {__mode='k'})  }\r\
\r\
  if super then\r\
    setmetatable(aClass.static, {\r\
      __index = function(_,k)\r\
        local result = rawget(dict,k)\r\
        if result == nil then\r\
          return super.static[k]\r\
        end\r\
        return result\r\
      end\r\
    })\r\
  else\r\
    setmetatable(aClass.static, { __index = function(_,k) return rawget(dict,k) end })\r\
  end\r\
\r\
  setmetatable(aClass, { __index = aClass.static, __tostring = _tostring,\r\
                         __call = _call, __newindex = _declareInstanceMethod })\r\
\r\
  return aClass\r\
end\r\
\r\
local function _includeMixin(aClass, mixin)\r\
  assert(type(mixin) == 'table', \"mixin must be a table\")\r\
\r\
  for name,method in pairs(mixin) do\r\
    if name ~= \"included\" and name ~= \"static\" then aClass[name] = method end\r\
  end\r\
\r\
  for name,method in pairs(mixin.static or {}) do\r\
    aClass.static[name] = method\r\
  end\r\
\r\
  if type(mixin.included)==\"function\" then mixin:included(aClass) end\r\
  return aClass\r\
end\r\
\r\
---@class MiddleClass\r\
local DefaultMixin = {\r\
  __tostring   = function(self) return \"instance of \" .. tostring(self.class) end,\r\
\r\
  initialize   = function(self, ...) end,\r\
\r\
  isInstanceOf = function(self, aClass)\r\
    return type(aClass) == 'table'\r\
       and type(self) == 'table'\r\
       and (self.class == aClass\r\
            or type(self.class) == 'table'\r\
            and type(self.class.isSubclassOf) == 'function'\r\
            and self.class:isSubclassOf(aClass))\r\
  end,\r\
\r\
  static = {\r\
    allocate = function(self)\r\
      assert(type(self) == 'table', \"Make sure that you are using 'Class:allocate' instead of 'Class.allocate'\")\r\
      return setmetatable({ class = self }, self.__instanceDict)\r\
    end,\r\
\r\
    new = function(self, ...)\r\
      assert(type(self) == 'table', \"Make sure that you are using 'Class:new' instead of 'Class.new'\")\r\
      local instance = self:allocate()\r\
      instance:initialize(...)\r\
      return instance\r\
    end,\r\
\r\
    subclass = function(self, name)\r\
      assert(type(self) == 'table', \"Make sure that you are using 'Class:subclass' instead of 'Class.subclass'\")\r\
      assert(type(name) == \"string\", \"You must provide a name(string) for your class\")\r\
\r\
      local subclass = _createClass(name, self)\r\
\r\
      for methodName, f in pairs(self.__instanceDict) do\r\
        _propagateInstanceMethod(subclass, methodName, f)\r\
      end\r\
      subclass.initialize = function(instance, ...) return self.initialize(instance, ...) end\r\
\r\
      self.subclasses[subclass] = true\r\
      self:subclassed(subclass)\r\
\r\
      return subclass\r\
    end,\r\
\r\
    subclassed = function(self, other) end,\r\
\r\
    isSubclassOf = function(self, other)\r\
      return type(other)      == 'table' and\r\
             type(self.super) == 'table' and\r\
             ( self.super == other or self.super:isSubclassOf(other) )\r\
    end,\r\
\r\
    include = function(self, ...)\r\
      assert(type(self) == 'table', \"Make sure you that you are using 'Class:include' instead of 'Class.include'\")\r\
      for _,mixin in ipairs({...}) do _includeMixin(self, mixin) end\r\
      return self\r\
    end\r\
  }\r\
}\r\
\r\
function middleclass.class(name, super)\r\
  assert(type(name) == 'string', \"A name (string) is needed for the new class\")\r\
  return super and super:subclass(name) or _includeMixin(_createClass(name), DefaultMixin)\r\
end\r\
\r\
setmetatable(middleclass, { __call = function(_, ...) return middleclass.class(...) end })\r\
\r\
return middleclass\r\
"
, '@'.."./Libraries/middleclass.lua" ) ) )

package.preload[ "Logs/Log" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local _private = require \"Internals.PrivateStorage\"\r\
\r\
---@class Ellyb_Log\r\
local Log = Class(\"Log\")\r\
\r\
function Log:initialize(level, ...)\r\
\9_private[self] = {}\r\
\9_private[self].date = time()\r\
\9_private[self].level = level\r\
\9_private[self].args = { ... }\r\
end\r\
\r\
function Log:GetText()\r\
\9return table.concat(_private[self].args, \"\\n\")\r\
end\r\
\r\
function Log:GetLevel()\r\
\9return _private[self].level\r\
end\r\
\r\
function Log:GetTimestamp()\r\
\9return _private[self].date\r\
end\r\
\r\
return Log"
, '@'.."./Logs/Log.lua" ) ) )

package.preload[ "Logs/Logger" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local _private = require \"Internals.PrivateStorage\"\r\
local Colors = require \"Enums.Colors\"\r\
local Log = require \"Logs.Log\"\r\
local config = require \"Ellyb.Configuration\"\r\
\r\
---@class Ellyb_Logger : MiddleClass\r\
local Logger = Class(\"Logger\")\r\
\r\
Logger.LEVELS = {\r\
\9DEBUG = \"DEBUG\",\r\
\9INFO = \"INFO\",\r\
\9WARNING = \"WARNING\",\r\
\9SEVERE = \"SEVERE\",\r\
}\r\
\r\
---@return Ellyb_Color\r\
local function getColorForLevel(level)\r\
\9if level == Logger.LEVELS.SEVERE then\r\
\9\9return Colors.RED\r\
\9elseif level == Logger.LEVELS.WARNING then\r\
\9\9return Colors.ORANGE\r\
\9elseif level == Logger.LEVELS.DEBUG then\r\
\9\9return Colors.CYAN\r\
\9else\r\
\9\9return Colors.WHITE\r\
\9end\r\
end\r\
\r\
--- Constructor\r\
---@param moduleName string @ The name of the module initializing the Logger\r\
function Logger:initialize(moduleName)\r\
\9_private[self] = {}\r\
\9_private[self].moduleName = moduleName\r\
\r\
\9local LogsManager = require \"Logs.LogsManager\"\r\
\9LogsManager:RegisterLogger(self)\r\
\9self:Info(\"Logger \" .. moduleName .. \" initialized.\")\r\
end\r\
\r\
---@return string moduleName @ Returns the name of the Logger's module\r\
function Logger:GetModuleName()\r\
\9return _private[self].moduleName\r\
end\r\
\r\
local LOG_HEADER_FORMAT = \"[%s - %s]: \"\r\
function Logger:GetLogHeader(logLevel)\r\
\9local color = getColorForLevel(logLevel)\r\
\9return format(LOG_HEADER_FORMAT, Colors.ORANGE(self:GetModuleName()), color(logLevel))\r\
end\r\
\r\
function Logger:Log(level, ...)\r\
\9if not config.DEBUG_MODE then\r\
\9\9return\r\
\9end\r\
\r\
\9local ChatFrame\r\
\9for i = 0, NUM_CHAT_WINDOWS do\r\
\9\9if GetChatWindowInfo(i) == \"Logs\" then\r\
\9\9\9ChatFrame = _G[\"ChatFrame\"..i]\r\
\9\9end\r\
\9end\r\
\r\
\9local log = Log(level, ...)\r\
\9local logText = log:GetText()\r\
\9local logHeader = self:GetLogHeader(log:GetLevel())\r\
\9local timestamp = format(\"[%s]\", date(\"%X\", log:GetTimestamp()))\r\
\9local message = Colors.GREY(timestamp) .. logHeader .. logText\r\
\9if ChatFrame and log:GetLevel() ~= self.LEVELS.WARNING and log:GetLevel() ~= self.LEVELS.SEVERE then\r\
\9\9ChatFrame:AddMessage(message)\r\
\9else\r\
\9\9print(message)\r\
\9end\r\
end\r\
\r\
function Logger:Debug(...)\r\
\9self:Log(self.LEVELS.DEBUG, ...)\r\
end\r\
\r\
function Logger:Info(...)\r\
\9self:Log(self.LEVELS.INFO, ...)\r\
end\r\
\r\
function Logger:Warning(...)\r\
\9self:Log(self.LEVELS.WARNING, ...)\r\
end\r\
\r\
function Logger:Severe(...)\r\
\9self:Log(self.LEVELS.SEVERE, ...)\r\
end\r\
\r\
return Logger\r\
"
, '@'.."./Logs/Logger.lua" ) ) )

package.preload[ "Logs/LogsManager" ] = injectRequire(assert( (loadstring or load)(
"local LogsManager = {}\r\
\r\
---@type Ellyb_Logger[]\r\
local logs = {}\r\
\r\
---@param logger Ellyb_Logger\r\
function LogsManager:RegisterLogger(logger)\r\
\9local ID = logger:GetModuleName()\r\
\9assert(not logs[ID], \"A Logger for \" .. ID .. \" has already been registered\")\r\
\9logs[ID] = logger\r\
end\r\
\r\
function LogsManager.show(ID)\r\
\9assert(logs[ID], \"Cannot find Logger \" .. ID)\r\
\9logs[ID]:Show()\r\
end\r\
\r\
function LogsManager.list()\r\
\9print(\"Available Loggers:\")\r\
\9for _, log in pairs(logs) do\r\
\9\9print(log:GetModuleName())\r\
\9end\r\
end\r\
\r\
return LogsManager"
, '@'.."./Logs/LogsManager.lua" ) ) )

package.preload[ "Main" ] = injectRequire(assert( (loadstring or load)(
"local ColorManager = require \"Tools.Colors.ColorManager\"\r\
local Icon = require \"Tools.Textures.Icon\"\r\
local DeprecationWarnings = require \"UI.DeprecationWarnings\"\r\
local Strings = require \"Tools.Strings.Strings\"\r\
local System = require \"Tools.System\"\r\
local config = require \"Ellyb.Configuration\"\r\
local Unit = require \"Tools.Unit\"\r\
\r\
config.DEBUG_MODE = true\r\
\r\
print(ColorManager.createFromHexa(\"#00ACEE\"))\r\
local icon = Icon(\"8XP_VulperaFlute\")\r\
print(icon)\r\
\r\
local Cursor = require \"UI.Cursor\"\r\
Cursor.setIcon(icon, -20, 20)\r\
\r\
local newFunction = function() print(\"BfA\") end\r\
\r\
local deprecatedFunction = DeprecationWarnings.wrapFunction(newFunction, \"deprecatedFunction\", \"newFunction\")\r\
\r\
deprecatedFunction()\r\
\r\
print(Strings.clickInstruction(System:FormatKeyboardShortcut(System.MODIFIERS.CTRL, System.MODIFIERS.ALT, System.CLICKS.DOUBLE_CLICK), \"Win the game\"))\r\
\r\
print(Strings.formatBytes(1234567890))\r\
\r\
print(Strings.interpolate([[I love %b$s at least %a$s thousands]], {\r\
\9a = \"3\",\r\
\9b = \"Elza\"\r\
}))\r\
\r\
local player = Unit(\"player\")\r\
print(player:IsAttackable())\r\
\r\
local SlashCommandManager = require \"Tools.SlashCommands.SlashCommandsManager\"\r\
local SlashCommand = require \"Tools.SlashCommands.SlashCommand\"\r\
\r\
local test = SlashCommandManager(\"Ellyb\", \"Ellyb\", \"EB\")\r\
local toggleDebug = SlashCommand(\"debug\", function(enable)\r\
\9config.DEBUG_MODE = enable == \"true\"\r\
end, 'Pass \"true\" to enable debug mode, \"false\" to disable it.')\r\
\r\
test:Register(toggleDebug)\r\
\r\
local GameEvents = require \"Events.GameEvents\"\r\
local Promise = require \"Tools.Promises.Promise\"\r\
local Promises = require \"Tools.Promises.Promises\"\r\
\r\
local enterWorld = Promise()\r\
\r\
enterWorld:Success(function()\r\
\9print(\"Player entered world\")\r\
end)\r\
\r\
local unitFaction = Promise()\r\
\r\
unitFaction:Success(function()\r\
\9print(\"Unit has faction\")\r\
end)\r\
\r\
local all = Promises.all(enterWorld, unitFaction)\r\
\r\
all:Success(function()\r\
\9print(\"Everything is ready\")\r\
end)\r\
\r\
GameEvents.registerCallback(\"PLAYER_ENTERING_WORLD\", function()\r\
\9enterWorld:Resolve()\r\
end)\r\
\r\
GameEvents.registerCallback(\"UNIT_FACTION\", function()\r\
\9unitFaction:Resolve()\r\
end)\r\
\r\
local Threads = require \"Tools.Threads.Threads\"\r\
\r\
Threads.run(function(yield)\r\
\9for i = 0, 5 do\r\
\9\9print(i, GetTimePreciseSec())\r\
\9\9yield()\r\
\9end\r\
\9return\r\
end)\r\
\r\
Threads.run(function(yield)\r\
\9for i = 0, 5 do\r\
\9\9print(i, GetTimePreciseSec())\r\
\9\9yield()\r\
\9end\r\
\9return\r\
end)\r\
\r\
local Animator = require \"Tools.Animator\"\r\
\r\
local sampleAnimator = Animator()\r\
\r\
sampleAnimator:RunValue(0, 1, 2, print)\r\
\r\
local TooltipManager = require \"UI.Tooltips.TooltipManager\"\r\
\r\
enterWorld:Success(function()\r\
\9TooltipManager.getTooltip(PlayerFrame)\r\
\9\9\9\9  :SetTitle(\"CustomTooltip\")\r\
\9:AddLine(\"Custom tooltip made with Ellyb\")\r\
\r\
end )"
, '@'.."./Main.lua" ) ) )

package.preload[ "Tools/Animator" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local Easings = require \"Libraries.easings\"\r\
\r\
---@class Animator : Object\r\
local Animator = Class(\"Animator\")\r\
\r\
---@type Animator[]\r\
local transitionators = {}\r\
\r\
local AnimatorsFrame = CreateFrame(\"FRAME\")\r\
\r\
AnimatorsFrame:SetScript(\"OnUpdate\", function()\r\
\9for _, transitionator in pairs(transitionators) do\r\
\9\9if transitionator:ShouldBeUpdated() then\r\
\9\9\9transitionator:Tick()\r\
\9\9end\r\
\9end\r\
end)\r\
\r\
function Animator:initialize()\r\
\9private[self] = {}\r\
\r\
\9private[self].value = 0\r\
\9private[self].shouldBeUpdated = false\r\
\r\
\9table.insert(transitionators, self)\r\
end\r\
\r\
function Animator:ShouldBeUpdated()\r\
\9return private[self].shouldBeUpdated\r\
end\r\
\r\
function Animator:Tick()\r\
\9local elapsed = GetTime() - private[self].timeStarted\r\
\9local currentValue = private[self].customEasing(elapsed, private[self].startValue, private[self].change, private[self].overTime, unpack(private[self].customEasingArgs))\r\
\9if elapsed >= private[self].overTime then\r\
\9\9private[self].shouldBeUpdated = false\r\
\9\9private[self].callback(private[self].endValue)\r\
\9else\r\
\9\9private[self].callback(currentValue)\r\
\9end\r\
end\r\
\r\
function Animator:RunValue(startValue, endValue, overTime, callback, customEasing, ...)\r\
\9if not endValue or endValue == startValue then\r\
\9\9return callback(startValue)\r\
\9end\r\
\r\
\9if not customEasing then\r\
\9\9customEasing = Easings.outQuad\r\
\9end\r\
\r\
\9private[self].startValue = startValue\r\
\9private[self].endValue = endValue\r\
\9private[self].change = endValue - startValue\r\
\9private[self].overTime = overTime\r\
\9private[self].callback = callback\r\
\9private[self].customEasing = customEasing\r\
\9private[self].customEasingArgs = { ...}\r\
\r\
\9private[self].value = startValue\r\
\9private[self].timeStarted = GetTime()\r\
\9private[self].shouldBeUpdated = true\r\
end\r\
\r\
return Animator"
, '@'.."./Tools/Animator.lua" ) ) )

package.preload[ "Tools/Assertions" ] = injectRequire(assert( (loadstring or load)(
"--- Various assertion functions to check if variables are of a certain type, empty, nil etc.\r\
--- These assertions will directly raise an error if the test is not met.\r\
local Assertions = {}\r\
\r\
--{{{ Helpers\r\
\r\
--- Throws an error in the parent's scope\r\
---@param message string\r\
local function throw(message)\r\
\9error(message, 3)\r\
end\r\
\r\
---@param variable UIObject\r\
local function isUIObject(variable)\r\
\9return type(variable) == \"table\" and type(variable.GetObjectType) == \"function\"\r\
end\r\
\r\
---@param variable MiddleClass\r\
local function isAClass(variable)\r\
\9return type(variable) == \"table\" and type(variable.isInstanceOf) == \"function\"\r\
end\r\
\r\
---@param t table\r\
---@return string\r\
local function list(t)\r\
\9return table.concat(t, \", \")\r\
end\r\
\r\
--}}}\r\
\r\
--- Check if a variable is of the expected type (\"number\", \"boolean\", \"string\")\r\
--- Can also check for Widget type (\"Frame\", \"Button\", \"Texture\")\r\
---@param variable any|UIObject Any kind of variable, to be tested for its type\r\
---@param expectedType string Expected type of the variable\r\
---@param variableName string The name of the variable being tested, will be visible in the error message\r\
---@return boolean, string Returns true if the variable was of the expected type, or false with an error message if it wasn't.\r\
function Assertions.isType(variable, expectedType, variableName)\r\
\9if isUIObject(variable) then\r\
\9\9if not variable:IsObjectType(expectedType) then\r\
\9\9\9throw(([[Invalid Widget type \"%s\" for variable \"%s\", expected a \"%s\".]]):format(variable:GetObjectType(), variableName, expectedType))\r\
\9\9end\r\
\9elseif type(variable) ~= expectedType then\r\
\9\9throw(([[Invalid variable type \"%s\" for variable \"%s\", expected \"%s\".]]):format(type(variable), variableName, expectedType))\r\
\9end\r\
\9return true\r\
end\r\
\r\
---Check if a variable is of one of the types expected (\"number\", \"boolean\", \"string\")\r\
------Can also check for Widget types (\"Frame\", \"Button\", \"Texture\")\r\
---@param variable any|UIObject Any kind of variable, to be tested for its type\r\
---@param expectedTypes string[] A list of expected types for the variable\r\
---@param variableName string The name of the variable being tested, will be visible in the error message\r\
---@return boolean, string Returns true if the variable was of the expected type, or false with an error message if it wasn't.\r\
function Assertions.isOfTypes(variable, expectedTypes, variableName)\r\
\9if isUIObject(variable) and not tContains(expectedTypes, variable:GetObjectType()) then\r\
\9\9throw(([[Invalid Widget type \"%s\" for variable \"%s\", expected one of {%s}.]]):format(variable:GetObjectType(), variableName, list(expectedTypes)))\r\
\9end\r\
\9if not tContains(expectedTypes, type(variable)) then\r\
\9\9throw(([[Invalid variable type \"%s\" for variable \"%s\", expected one of {%s}.]]):format(type(variable), variableName, list(expectedTypes)))\r\
\9end\r\
\9return true\r\
end\r\
\r\
---Check if a variable is not nil\r\
---@param variable any Any kind of variable, will be checked if it is nil\r\
---@param variableName string The name of the variable being tested, will be visible in the error message\r\
---@return boolean, string Returns true if the variable was not nil, or false with an error message if it wasn't.\r\
function Assertions.isNotNil(variable, variableName)\r\
\9if variable == nil then\r\
\9\9throw(([[Unexpected nil variable \"%s\".]]):format(variableName))\r\
\9end\r\
\9return true\r\
end\r\
\r\
---Check if a variable is empty\r\
---@param variable any Any kind of variable that can be checked to be empty\r\
---@param variableName string The name of the variable being tested, will be visible in the error message\r\
---@return boolean, string Returns true if the variable was not empty, or false with an error message if it was.\r\
function Assertions.isNotEmpty(variable, variableName)\r\
\9if variable == nil then\r\
\9\9throw(([[Variable \"%s\" cannot be empty.]]):format(variableName))\r\
\9end\r\
\9-- To check if a table is empty we can just try to get its next field\r\
\9if type(variable) == \"table\" and not next(variable) then\r\
\9\9throw(([[Variable \"%s\" cannot be an empty table.]]):format(variableName))\r\
\9end\r\
\r\
\9-- A string is considered empty if it is equal to empty string \"\"\r\
\9if type(variable) == \"string\" and variable == \"\" then\r\
\9\9throw(([[Variable \"%s\" cannot be an empty string.]]):format(variableName))\r\
\9end\r\
\9return true\r\
end\r\
\r\
--- Check if a variable is an instance of a specified class, taking polymorphism into account, so inherited class will pass the test.\r\
---@generic T:MiddleClass\r\
---@param variable T The object to test\r\
---@param class MiddleClass A direct reference to the expected class\r\
---@param variableName string The name of the variable being tested, will be visible in the error message\r\
function Assertions.isInstanceOf(variable, class, variableName)\r\
\9if not isAClass(variable) then\r\
\9\9throw(([[Invalid type \"%s\" for variable \"%s\", expected a \"%s\".]]):format(type(variable), variableName, tostring(class)))\r\
\9end\r\
\9if not variable:isInstanceOf(class) then\r\
\9\9throw(([[Invalid Class \"%s\" for variable \"%s\", expected \"%s\".]]):format(tostring(variable.class), variableName, tostring(class)))\r\
\9end\r\
\9return true\r\
end\r\
\r\
\r\
--- Check if a variable value is one of the possible values.\r\
---@param variable any Any kind of variable, will be checked if it's value is in the list of possible values\r\
---@param possibleValues table A table of the possible values accepted\r\
---@param variableName string The name of the variable being tested, will be visible in the error message\r\
function Assertions.isOneOf(variable, possibleValues, variableName)\r\
\9if not tContains(possibleValues, variable) then\r\
\9\9throw(([[Unexpected variable value %s for variable \"%s\", expected to be one of {%s}.]]):format(tostring(variable), variableName, list(possibleValues)))\r\
\9end\r\
\9return true\r\
end\r\
\r\
--- Check if a variable is a number between a maximum and a minimum\r\
---@param variable number A number to check\r\
---@param minimum number The minimum value for the number\r\
---@param maximum number The maximum value for the number\r\
---@param variableName string The name of the variable being tested, will be visible in the error message\r\
function Assertions.numberIsBetween(variable, minimum, maximum, variableName)\r\
\r\
\9-- Variable has to be a number to do comparison\r\
\9if type(variable) ~= \"number\" then\r\
\9\9throw(([[Invalid variable type \"%s\" for variable \"%s\", expected \"number\".]]):format(type(variable), variableName))\r\
\9end\r\
\r\
\9if variable < minimum or variable > maximum then\r\
\9\9throw(([[Invalid variable value \"%s\" for variable \"%s\". Expected the value to be between \"%s\" and \"%s\"]]):format(variable, variableName, minimum, maximum))\r\
\9end\r\
\r\
\9return true\r\
end\r\
\r\
function Assertions.hasAtLeast(numberOfVarArgs, varArgTable, varArgName)\r\
\9Assertions.isType(numberOfVarArgs, \"number\", \"numberOfVarArgs\")\r\
\9Assertions.isType(varArgTable, \"table\", \"varArgTable\")\r\
\r\
\9if #varArgTable < numberOfVarArgs then\r\
\9\9throw(([[At least %d %s is required, %d provided.]]):format(numberOfVarArgs, varArgName, #varArgTable))\r\
\9end\r\
\r\
\9return true\r\
end\r\
\r\
return Assertions\r\
"
, '@'.."./Tools/Assertions.lua" ) ) )

package.preload[ "Tools/Colors/Color" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local Assertions = require \"Tools.Assertions\"\r\
local ColorTools = require \"Tools.Colors.ColorTools\"\r\
local Maths = require \"Tools.Maths\"\r\
local UiEscapeSequences = require \"Enums.UiEscapeSequences\"\r\
\r\
---@class Ellyb_Color : Object\r\
--- A Color object with various methods used to handle color, color text, etc.\r\
local Color = Class(\"Color\");\r\
\r\
---Constructor\r\
---@param red number\r\
---@param green number\r\
---@param blue number\r\
---@param alpha number\r\
function Color:initialize(red, green, blue, alpha)\r\
\9private[self].canBeMutated = true;\r\
\9-- If the alpha isn't given we should probably be sensible and default it.\r\
\9alpha = alpha or 1;\r\
\r\
\9self:SetRed(red);\r\
\9self:SetGreen(green);\r\
\9self:SetBlue(blue);\r\
\9self:SetAlpha(alpha);\r\
\r\
end\r\
\r\
\r\
--- Allows read only access to RGBA properties as table fields\r\
---@param key string The key we want to access\r\
function Color:__index(key)\r\
\9if key == \"r\" or key == \"red\" then\r\
\9\9return self:GetRed()\r\
\9elseif key == \"g\" or key == \"green\" then\r\
\9\9return self:GetGreen()\r\
\9elseif key == \"b\" or key == \"blue\" then\r\
\9\9return self:GetBlue()\r\
\9elseif key == \"a\" or key == \"alpha\" then\r\
\9\9return self:GetAlpha()\r\
\9end\r\
end\r\
\r\
---@return string color A string representation of the color (#FFBABABA)\r\
function Color:__tostring()\r\
\9return self:WrapTextInColorCode(\"#\" .. self:GenerateHexadecimalColor());\r\
end\r\
\r\
---@param text string A text to color\r\
---@return string A shortcut to self:WrapTextInColorCode(text) to easily color text by calling the Color itself\r\
function Color:__call(text)\r\
\9return self:WrapTextInColorCode(text);\r\
end\r\
\r\
function Color:__eq(colorB)\r\
\9local redA, greenA, blueA, alphaA = self:GetRGBA();\r\
\9local redB, greenB, blueB, alphaB = colorB:GetRGBA();\r\
\9return redA == redB\r\
\9\9and greenA == greenB\r\
\9\9and blueA == blueB\r\
\9\9and alphaA == alphaB;\r\
end\r\
\r\
---@return number The red value of the Color between 0 and 1\r\
function Color:GetRed()\r\
\9return private[self].red;\r\
end\r\
\r\
---@return number The green value of the Color between 0 and 1\r\
function Color:GetGreen()\r\
\9return private[self].green;\r\
end\r\
\r\
---@return number The blue value of the Color between 0 and 1\r\
function Color:GetBlue()\r\
\9return private[self].blue;\r\
end\r\
\r\
---@return number The alpha value of the Color (defaults to 1)\r\
function Color:GetAlpha()\r\
\9return private[self].alpha or 1;\r\
end\r\
\r\
---@return number, number, number The red, green and blue values of the Color between 0 and 1\r\
function Color:GetRGB()\r\
\9return self:GetRed(), self:GetGreen(), self:GetBlue();\r\
end\r\
\r\
---@return number, number, number, number The red, green, blue and alpha values of the Color between 0 and 1\r\
function Color:GetRGBA()\r\
\9return self:GetRed(), self:GetGreen(), self:GetBlue(), self:GetAlpha();\r\
end\r\
\r\
---@return number, number, number The red, green and blue values of the Color on a between 0 and 255\r\
function Color:GetRGBAsBytes()\r\
\9return self:GetRed() * 255, self:GetGreen() * 255, self:GetBlue() * 255;\r\
end\r\
\r\
---@return number, number, number, number The red, green, blue and alpha values of the Color between 0 and 255\r\
function Color:GetRGBAAsBytes()\r\
\9return self:GetRed() * 255, self:GetGreen() * 255, self:GetBlue() * 255, self:GetAlpha() * 255;\r\
end\r\
\r\
---@return number, number, number The hue, saturation and lightness values of the Color (hue between 0 and 360, saturation/lightness between 0 and 1)\r\
function Color:GetHSL()\r\
\9local h, s, l, cmax, cmin;\r\
\9local r, g, b = self:GetRGB();\r\
\9cmax = math.max(r, g, b);\r\
\9cmin = math.min(r, g, b);\r\
\r\
\9if (cmin == cmax) then\r\
\9\9h = 0;\r\
\9elseif (cmax == r) then\r\
\9\9h = 60 * math.fmod((g - b)/(cmax - cmin), 6);\r\
\9elseif (cmax == g) then\r\
\9\9h = 60 * ((b - r)/(cmax - cmin) + 2);\r\
\9else\r\
\9\9h = 60 * ((r - g)/(cmax - cmin) + 4);\r\
\9end\r\
\r\
\9if (h < 0) then\r\
\9\9h = h + 360;\r\
\9end\r\
\r\
\9l = (cmax + cmin)/2;\r\
\r\
\9if (cmin == cmax) then\r\
\9\9s = 0;\r\
\9else\r\
\9\9s = (cmax - cmin)/(1 - math.abs(2*l - 1));\r\
\9end\r\
\r\
\9return h, s, l;\r\
end\r\
\r\
--- Set the red value of the color.\r\
--- If the color was :Freeze() it will silently fail.\r\
---@param red number A number between 0 and 1 for the red value\r\
function Color:SetRed(red)\r\
\9if private[self].canBeMutated then\r\
\9\9Assertions.numberIsBetween(red, 0, 1, \"red\")\r\
\9\9private[self].red = red;\r\
\9end\r\
end\r\
\r\
--- Set the green value of the color.\r\
--- If the color was :Freeze() it will silently fail.\r\
---@param green number A number between 0 and 1 for the green value\r\
function Color:SetGreen(green)\r\
\9if private[self].canBeMutated then\r\
\9\9Assertions.numberIsBetween(green, 0, 1, \"green\");\r\
\9\9private[self].green = green;\r\
\9end\r\
end\r\
\r\
--- Set the blue value of the color.\r\
--- If the color was :Freeze() it will silently fail.\r\
---@param blue number A number between 0 and 1 for the blue value\r\
function Color:SetBlue(blue)\r\
\9if private[self].canBeMutated then\r\
\9\9Assertions.numberIsBetween(blue, 0, 1, \"blue\");\r\
\9\9private[self].blue = blue;\r\
\9end\r\
end\r\
\r\
--- Set the alpha value of the color.\r\
--- If the color was :Freeze() it will silently fail.\r\
---@param alpha number A number between 0 and 1 for the alpha value\r\
function Color:SetAlpha(alpha)\r\
\9if private[self].canBeMutated then\r\
\9\9Assertions.numberIsBetween(alpha, 0, 1, \"alpha\");\r\
\9\9private[self].alpha = alpha;\r\
\9end\r\
end\r\
\r\
--- Set the red, green, blue and alpha values of the color.\r\
--- If the color was :Freeze() it will silently fail.\r\
---@param red number A number between 0 and 1 for the red value\r\
---@param green number A number between 0 and 1 for the green value\r\
---@param blue number A number between 0 and 1 for the blue value\r\
---@param alpha number A number between 0 and 1 for the alpha value\r\
function Color:SetRGBA(red, green, blue, alpha)\r\
\9self:SetRed(red);\r\
\9self:SetGreen(green);\r\
\9self:SetBlue(blue);\r\
\9self:SetAlpha(alpha);\r\
end\r\
\r\
--- Get the color values as an { r, g, b } table\r\
---@return {r: number, g: number, b: number}\r\
function Color:GetRGBTable()\r\
\9return {\r\
\9\9r = self:GetRed(),\r\
\9\9g = self:GetGreen(),\r\
\9\9b = self:GetBlue(),\r\
\9};\r\
end\r\
\r\
--- Get the color values as an { r, g, b, a } table\r\
---@return {r: number, g: number, b: number, a: number}\r\
function Color:GetRGBATable()\r\
\9return {\r\
\9\9r = self:GetRed(),\r\
\9\9g = self:GetGreen(),\r\
\9\9b = self:GetBlue(),\r\
\9\9a = self:GetAlpha(),\r\
\9}\r\
end\r\
\r\
--- Freezes a Color so that it cannot be mutated\r\
--- Used for Color constants in the ColorManager\r\
---\r\
--- Example:\r\
--- `local white = Color(\"#FFFFFF\"):Freeze();`\r\
---@return Ellyb_Color Returns itself, so it can be used during the instantiation\r\
function Color:Freeze()\r\
\9private[self].canBeMutated = false\r\
\9return self;\r\
end\r\
\r\
--- Create a duplicate version of the color that can be altered safely\r\
--- @return Ellyb_Color A duplicate of this color\r\
function Color:Clone()\r\
\9return Color.CreateFromRGBA(self:GetRGBA());\r\
end\r\
\r\
---@param doNotIncludeAlpha boolean Set to true if the color code should not have the alpha\r\
---@return string Generate an hexadecimal representation of the code (`FFAABBCC`);\r\
---@overload fun():string\r\
function Color:GenerateHexadecimalColor(doNotIncludeAlpha)\r\
\9local red, green, blue, alpha = self:GetRGBAAsBytes();\r\
\9if doNotIncludeAlpha then\r\
\9\9return UiEscapeSequences.COLOR:sub(7):format(red, green, blue):upper();\r\
\9else\r\
\9\9return UiEscapeSequences.COLOR:sub(3):format(alpha, red, green, blue):upper();\r\
\9end\r\
end\r\
\r\
--- Compatibility with Blizzard stuff\r\
---@param doNotIncludeAlpha boolean Set to true if the color code should not have the alpha\r\
---@return string HexadecimalColor Generate an hexadecimal representation of the code (`FFAABBCC`);\r\
---@overload fun():string\r\
function Color:GenerateHexColor(doNotIncludeAlpha)\r\
\9return self:GenerateHexadecimalColor(doNotIncludeAlpha);\r\
end\r\
\r\
---@return string Returns the start code of the UI escape sequence to color text\r\
function Color:GetColorCodeStartSequence()\r\
\9return UiEscapeSequences.COLOR:sub(1,2) .. self:GenerateHexadecimalColor()\r\
end\r\
\r\
--- Wrap a given text between the UI escape sequenced necessary to get the text colored in the current Color\r\
---@param text string The text to be colored\r\
---@return string coloredText A colored representation of the given text\r\
function Color:WrapTextInColorCode(text)\r\
\9return self:GetColorCodeStartSequence() .. tostring(text) .. UiEscapeSequences.CLOSE;\r\
end\r\
\r\
--- Applies a color to a FontString UI widget\r\
---@param fontString FontString\r\
function Color:SetTextColor(fontString)\r\
\9Assertions.isType(fontString, \"FontString\", \"fontString\");\r\
\9fontString:SetTextColor(self:GetRGBA());\r\
end\r\
\r\
--- Lighten up a color that is too dark until it is properly readable on a dark background.\r\
function Color:LightenColorUntilItIsReadableOnDarkBackgrounds()\r\
\9-- If the color is too dark to be displayed in the tooltip, we will ligthen it up a notch\r\
\9while not ColorTools.isTextColorReadableOnADarkBackground(self) do\r\
\9\9self:SetRed(Maths.incrementValueUntilMax(self:GetRed(), 0.01, 1));\r\
\9\9self:SetGreen(Maths.incrementValueUntilMax(self:GetGreen(), 0.01, 1));\r\
\9\9self:SetBlue(Maths.incrementValueUntilMax(self:GetBlue(), 0.01, 1));\r\
\9end\r\
end\r\
\r\
return Color\r\
"
, '@'.."./Tools/Colors/Color.lua" ) ) )

package.preload[ "Tools/Colors/ColorManager" ] = injectRequire(assert( (loadstring or load)(
"local Color = require \"Tools.Colors.Color\"\r\
local ColorTools = require \"Tools.Colors.ColorTools\"\r\
local Assertions = require \"Tools.Assertions\"\r\
\r\
--- Used for Color related operations and managing a palette of predefined Colors\r\
local ColorManager = {}\r\
\r\
--- Create a new Color from RGBA values, between 0 and 1.\r\
---@param red number The red value of the Color between 0 and 1\r\
---@param green number The green value of the Color between 0 and 1\r\
---@param blue number The blue value of the Color between 0 and 1\r\
---@param alpha number The alpha value of the Color between 0 and 1\r\
---@return Ellyb_Color color\r\
---@overload fun(red:number, green:number, blue:number):Ellyb_Color\r\
function ColorManager.createFromRGBA(red, green, blue, alpha)\r\
\9return Color(red, green, blue, alpha)\r\
end\r\
\r\
--- Create a new Color from RGBA values, between 0 and 255.\r\
---@param red number The red value of the Color between 0 and 255\r\
---@param green number The green value of the Color between 0 and 255\r\
---@param blue number The blue value of the Color between 0 and 255\r\
---@param alpha number The alpha value of the Color between 0 and 255, or 0 and 1 (see alphaIsNotBytes parameter)\r\
---@param alphaIsNotBytes boolean Some usage (like color pickers) might want to set the alpha as opacity between 0 and 1. If set to true, alpha will be considered as a value between 0 and 1\r\
---@overload fun(red:number, green:number, blue:number, alpha: number):Ellyb_Color\r\
------@overload fun(red:number, green:number, blue:number):Ellyb_Color\r\
function ColorManager.createFromRGBAAsBytes(red, green, blue, alpha, alphaIsNotBytes)\r\
\9Assertions.numberIsBetween(red, 0, 255, \"red\")\r\
\9Assertions.numberIsBetween(green, 0, 255, \"green\")\r\
\9Assertions.numberIsBetween(blue, 0, 255, \"blue\")\r\
\r\
\9if alpha then\r\
\9\9-- Alpha is optional, only test if we were given a value\r\
\9\9if not alphaIsNotBytes then\r\
\9\9\9Assertions.numberIsBetween(alpha, 0, 255, \"alpha\")\r\
\9\9\9alpha = alpha / 255\r\
\9\9end\r\
\9else\r\
\9\9-- Default the alpha sensibly.\r\
\9\9alpha = 1\r\
\9end\r\
\r\
\9-- Set the values\r\
\9return Color(red / 255, green / 255, blue / 255, alpha)\r\
end\r\
\r\
--- Create a new Color from an hexadecimal code\r\
---@param hexadecimalColorCode string A valid hexadecimal code\r\
---@return Ellyb_Color\r\
function ColorManager.createFromHexa(hexadecimalColorCode)\r\
\9Assertions.isType(hexadecimalColorCode, \"string\", \"hexadecimalColorCode\")\r\
\r\
\9local red, green, blue, alpha = ColorTools.hexaToNumber(hexadecimalColorCode)\r\
\9return ColorManager.createFromRGBA(red, green, blue, alpha)\r\
end\r\
\r\
function ColorManager.createFromTable(table)\r\
\9Assertions.isType(table, \"table\", \"table\")\r\
\r\
\9return ColorManager.createFromRGBA(table.r, table.g, table.b, table.a)\r\
end\r\
\r\
--- Get the associated Color for the given class.\r\
--- This function always creates a new Color that can be mutated (unlike the Color constants)\r\
--- It will fetch the color from the RAID_CLASS_COLORS global table and will reflect any changes made to the table.\r\
---@param class string A valid class (\"HUNTER\", \"DEATHKNIGHT\")\r\
---@return Ellyb_Color color The Color corresponding to the class\r\
function ColorManager.getClassColor(class)\r\
\9if RAID_CLASS_COLORS[class] then\r\
\9\9return Color:new(RAID_CLASS_COLORS[class])\r\
\9end\r\
end\r\
\r\
--- Get the chat color associated to a specified channel in the settings\r\
--- It will fetch the color from the ChatTypeInfo global table and will reflect any changes made to the table.\r\
---@param channel string A chat channel (\"WHISPER\", \"YELL\", etc.)\r\
---@return Ellyb_Color chatColor\r\
function ColorManager.getChatColorForChannel(channel)\r\
\9assert(ChatTypeInfo[channel], \"Trying to get chat color for an unknown channel type: \" .. channel)\r\
\9return Color:new(ChatTypeInfo[channel])\r\
end\r\
\r\
return ColorManager"
, '@'.."./Tools/Colors/ColorManager.lua" ) ) )

package.preload[ "Tools/Colors/ColorTools" ] = injectRequire(assert( (loadstring or load)(
"local ColorTools = {}\r\
\r\
---Converts color bytes into bits, from a 0-255 range to 0-1 range.\r\
---@param red number Between 0 and 255\r\
---@param green number Between 0 and 255\r\
---@param blue number Between 0 and 255\r\
---@param alpha number Between 0 and 255\r\
---@return number, number, number, number\r\
---@overload fun(red:number, green:number, blue:number):number, number, number, number\r\
function ColorTools.convertColorBytesToBits(red, green, blue, alpha)\r\
\9if alpha == nil then\r\
\9\9alpha = 255;\r\
\9end\r\
\r\
\9return red / 255, green / 255, blue / 255, alpha / 255;\r\
end\r\
\r\
--- Extracts RGB values (255 based) from an hexadecimal code\r\
---@param hexadecimalCode string An hexadecimal code corresponding to a color (example: `FFF`, `FAFAFA`, `#ffbababa`, `|cffbababa`)\r\
---@return number, number, number red, green, blue\r\
function ColorTools.hexaToNumber(hexadecimalCode)\r\
\9local red, green, blue, alpha;\r\
\r\
\9-- We make sure we remove possible prefixes\r\
\9hexadecimalCode = hexadecimalCode:gsub(\"#\", \"\");\r\
\9hexadecimalCode = hexadecimalCode:gsub(\"|c\", \"\");\r\
\r\
\9local hexadecimalCodeLength = hexadecimalCode:len();\r\
\r\
\9if hexadecimalCodeLength == 3 then\r\
\9\9-- #FFF\r\
\9\9local r = hexadecimalCode:sub(1, 1);\r\
\9\9local g = hexadecimalCode:sub(2, 2);\r\
\9\9local b = hexadecimalCode:sub(3, 3);\r\
\9\9red = tonumber(r .. r, 16)\r\
\9\9green = tonumber(g .. g, 16)\r\
\9\9blue = tonumber(b .. b, 16)\r\
\9elseif hexadecimalCodeLength == 6 then\r\
\9\9-- #FAFAFA\r\
\9\9red = tonumber(hexadecimalCode:sub(1, 2), 16)\r\
\9\9green = tonumber(hexadecimalCode:sub(3, 4), 16)\r\
\9\9blue = tonumber(hexadecimalCode:sub(5, 6), 16)\r\
\9elseif hexadecimalCodeLength == 8 then\r\
\9\9-- #ffbababa\r\
\9\9alpha = tonumber(hexadecimalCode:sub(1, 2), 16)\r\
\9\9red = tonumber(hexadecimalCode:sub(3, 4), 16)\r\
\9\9green = tonumber(hexadecimalCode:sub(5, 6), 16)\r\
\9\9blue = tonumber(hexadecimalCode:sub(7, 8), 16)\r\
\9end\r\
\r\
\9return ColorTools.convertColorBytesToBits(red, green, blue, alpha);\r\
end\r\
\r\
--- Compares two colors based on their HSL values (first comparing H, then comparing S, then comparing L)\r\
---@param color1 Ellyb_Color @ A color\r\
---@param color2 Ellyb_Color @ The color to compare\r\
---@return boolean isLesser @ true if color1 is \"lesser\" than color2\r\
function ColorTools.compareHSL(color1, color2)\r\
\9local h1, s1, l1 = color1:GetHSL();\r\
\9local h2, s2, l2 = color2:GetHSL();\r\
\r\
\9if (h1 == h2) then\r\
\9\9if (s1 == s2) then\r\
\9\9\9return (l1 < l2)\r\
\9\9end\r\
\9\9return (s1 < s2)\r\
\9end\r\
\9return (h1 < h2)\r\
end\r\
\r\
---\r\
--- Function to test if a color is correctly readable on a dark background.\r\
--- We will calculate the luminance of the text color\r\
--- using known values that take into account how the human eye perceive color\r\
--- and then compute the contrast ratio.\r\
--- The contrast ratio should be higher than 50%.\r\
--- @external [](http://www.whydomath.org/node/wavlets/imagebasics.html)\r\
---\r\
--- @param color Ellyb_Color The text color to test\r\
--- @return boolean True if the text will be readable\r\
function ColorTools.isTextColorReadableOnADarkBackground(color)\r\
\9return ((\r\
\9\0090.299 * color:GetRed() +\r\
\9\9\0090.587 * color:GetGreen() +\r\
\9\9\0090.114 * color:GetBlue()\r\
\9)) >= 0.5;\r\
end\r\
\r\
return ColorTools"
, '@'.."./Tools/Colors/ColorTools.lua" ) ) )

package.preload[ "Tools/Functions" ] = injectRequire(assert( (loadstring or load)(
"local Functions = {};\r\
\r\
--- Binds a given function to a value, returning a closure will call the\r\
--- original function with the given value as the first argument, and\r\
--- all arguments to the closure after it.\r\
---\r\
--- This is super useful for cases where you want to invoke an object method\r\
--- but are being asked for a naked callback.\r\
---\r\
--- @param fn function The function to wrap.\r\
--- @param value any The value to be supplied to fn as the first argument.\r\
function Functions.bind(fn, value)\r\
\9return function(...) return fn(value, ...); end\r\
end\r\
\r\
return Functions\r\
"
, '@'.."./Tools/Functions.lua" ) ) )

package.preload[ "Tools/Localization/Locale" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local Assertions = require \"Tools.Assertions\"\r\
\r\
---@class Ellyb_Locale\r\
local Locale = Class(\"Locale\");\r\
\r\
---Constructor\r\
---@param code string The code for the locale, must be one of the game's supported locale code\r\
---@param name string The name of the locale, as could be displayed to the user\r\
---@param content table<string, string> Content of the locale, a table with texts indexed with locale keys\r\
function Locale:initialize(code, name, content)\r\
\9Assertions.isType(code, \"string\", \"code\");\r\
\9Assertions.isType(name, \"string\", \"name\");\r\
\r\
\9private[self].code = code;\r\
\9private[self].name = name;\r\
\9private[self].content = {};\r\
\r\
\9-- If the content of the locale was passed to the constructor, we add the content to the locale\r\
\9if content then\r\
\9\9self:AddTexts(content);\r\
\9end\r\
end\r\
\r\
-- Flavour syntax: we can add new values to the locale by adding them directly to the object Locale.LOCALIZATION_KEY = \"value\r\
function Locale:__newindex(key, value)\r\
\9self:AddText(key, value);\r\
end\r\
\r\
-- Flavour syntax: we can get the value for a key in the locale using Locale.LOCALIZATION_KEY\r\
function Locale:__index(localeKey)\r\
\9return self:GetText(localeKey);\r\
end\r\
\r\
---@return string\r\
function Locale:GetCode()\r\
\9return private[self].code;\r\
end\r\
\r\
---@return string\r\
function Locale:GetName()\r\
\9return private[self].name;\r\
end\r\
\r\
---Get the localization value for this locale corresponding to the given localization key\r\
---@param localizationKey string\r\
---@return string\r\
function Locale:GetText(localizationKey)\r\
\9Assertions.isType(localizationKey,\"string\", \"localizationKey\");\r\
\r\
\9return private[self].content[localizationKey];\r\
end\r\
\r\
---Add a new localization value to the locale\r\
---@param localizationKey string\r\
---@param value string\r\
function Locale:AddText(localizationKey, value)\r\
\9Assertions.isType(localizationKey, \"string\", \"localizationKey\");\r\
\9Assertions.isType(value, \"string\", \"value\");\r\
\r\
\9private[self].content[localizationKey] = value;\r\
end\r\
\r\
--- Add a table of localization texts to the locale\r\
---@param localeTexts table<string, string>\r\
function Locale:AddTexts(localeTexts)\r\
\9Assertions.isType(localeTexts, \"table\", \"localeTexts\");\r\
\r\
\9for localizationKey, value in pairs(localeTexts) do\r\
\9\9self:AddText(localizationKey, value);\r\
\9end\r\
end\r\
\r\
--- Check if the locale has a value for a localization key\r\
---@return boolean\r\
function Locale:LocalizationKeyExists(localizationKey)\r\
\9return self:GetText(localizationKey) ~= nil;\r\
end\r\
\r\
return Locale\r\
"
, '@'.."./Tools/Localization/Locale.lua" ) ) )

package.preload[ "Tools/Localization/Localization" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local Assertions = require \"Tools.Assertions\"\r\
local Locale = require \"Tools.Localization.Locale\"\r\
\r\
local DEFAULT_LOCALE_CODE = \"default\";\r\
\r\
---@class Ellyb_Localization\r\
--- My own take on a localization system.\r\
--- The main goal here was to achieve easy localization key completion in the code editor (loc.KEY)\r\
local Localization = Class(\"Localization\");\r\
\r\
Localization.DEFAULT_LOCALE_CODE = DEFAULT_LOCALE_CODE;\r\
\r\
function Localization:initialize(defaultLocaleContent)\r\
\9private[self].locales = {};\r\
\9self:RegisterNewLocale(DEFAULT_LOCALE_CODE, \"Default\", defaultLocaleContent);\r\
\9private[self].currentLocaleCode = DEFAULT_LOCALE_CODE;\r\
end\r\
\r\
-- Flavour syntax: we can get the value for a key in the current locale using Localization.LOCALIZATION_KEY\r\
function Localization:__index(localeKey)\r\
\9return self:GetText(localeKey);\r\
end\r\
\r\
-- Flavour syntax: we can add a value to the default locale using Localization.LOCALIZATION_KEY = \"value\"\r\
function Localization:__newindex(key, value)\r\
\9if value then\r\
\9\9self:AddTextToDefaultLocale(key, value);\r\
\9end\r\
end\r\
\r\
function Localization:AddTextToDefaultLocale(key, value)\r\
\9self:GetLocale(DEFAULT_LOCALE_CODE):AddText(key, value);\r\
end\r\
\r\
--- We can also \"call\" the table itself with either the key as a string (.ie Localization(\"GEN_VERSION\")\r\
--- (this gives us backward compatibility with previous systems where we would call a function with keys as strings)\r\
--- Or using the direct value of the locale (.ie Localization(Localization.GEN_VERSION)\r\
--- (although this is less interesting)\r\
---\r\
--- We can even add more arguments to automatically apply a format (ie. Localization(Localization.GEN_VERSION, genVersion, genNumber))\r\
function Localization:__call(localeKey, ...)\r\
\9local localeText = self:GetText(localeKey);\r\
\r\
\9-- If we were given more arguments, we want to format the value\r\
\9if #{ ... } > 0 then\r\
\9\9localeText = localeText:format(...);\r\
\9end\r\
\r\
\9return localeText;\r\
end\r\
\r\
---Register a new locale into the localization system\r\
---@param code string The code for the locale, must be one of the game's supported locale code\r\
---@param name string The name of the locale, as could be displayed to the user\r\
---@param content table<string, string> Content of the locale, a table with texts indexed with locale keys\r\
---@return Ellyb_Locale locale\r\
---@overload fun(code:string, name:string):Ellyb_Locale\r\
function Localization:RegisterNewLocale(code, name, content)\r\
\9Assertions.isType(code, \"string\", \"code\")\r\
\9Assertions.isType(name, \"string\", \"name\")\r\
\9assert(not private[self].locales[code], (\"A localization for %s has already been registered.\"):format(code));\r\
\r\
\9local locale = Locale(code, name, content);\r\
\9private[self].locales[code] = locale;\r\
\r\
\9return private[self].locales[code];\r\
end\r\
\r\
---getLocale\r\
---@param code string\r\
---@return Ellyb_Locale locale\r\
function Localization:GetLocale(code)\r\
\9Assertions.isType(code, \"string\", \"code\")\r\
\9assert(private[self].locales[code], (\"Unknown locale %s.\"):format(code));\r\
\r\
\9return private[self].locales[code];\r\
end\r\
\r\
---@param withoutDefaultLocale boolean Do not include the default localization in the result\r\
---@return Ellyb_Locale[] The list of currently registered locales\r\
function Localization:GetLocales(withoutDefaultLocale)\r\
\9local locales = {};\r\
\r\
\9for localeCode, locale in pairs(private[self].locales) do\r\
\9\9if not (withoutDefaultLocale and  localeCode == DEFAULT_LOCALE_CODE) then\r\
\9\9\9locales[localeCode] = locale;\r\
\9\9end\r\
\9end\r\
\r\
\9return locales;\r\
end\r\
\r\
---@return Ellyb_Locale\r\
function Localization:GetActiveLocale()\r\
\9return self:GetLocale(private[self].currentLocaleCode);\r\
end\r\
\r\
---@param code string\r\
---@param fallbackToDefault boolean If the specified locale doesn't exist, silently fail and fallback to default locale\r\
function Localization:SetCurrentLocale(code, fallbackToDefault)\r\
\9Assertions.isType(code, \"string\", \"code\");\r\
\9if not fallbackToDefault then\r\
\9\9assert(private[self].locales[code], format(\"Unknown locale %s.\", code));\r\
\9end\r\
\r\
\9if private[self].locales[code] then\r\
\9\9private[self].currentLocaleCode = code;\r\
\9else\r\
\9\9self:SetCurrentLocale(self:GetDefaultLocale():GetCode(), false);\r\
\9end\r\
end\r\
\r\
---@return Ellyb_Locale\r\
function Localization:GetDefaultLocale()\r\
\9return self:GetLocale(DEFAULT_LOCALE_CODE);\r\
end\r\
\r\
---@return string\r\
function Localization:GetDefaultLocaleCode()\r\
\9return DEFAULT_LOCALE_CODE;\r\
end\r\
\r\
--- Check if the locale has a value for a localization key\r\
---@param localizationKey string\r\
---@return boolean\r\
function Localization:KeyExists(localizationKey)\r\
\9Assertions.isType(localizationKey, \"string\", \"localizationKey\");\r\
\9return self:GetDefaultLocale():GetText(localizationKey) ~= nil;\r\
end\r\
\r\
--- Get the value of a localization key.\r\
--- Will look for a localized value using the current localization, or a value in the default localization\r\
--- or will just output the key as is if nothing was found.\r\
---@param localizationKey string A localization key\r\
function Localization:GetText(localizationKey)\r\
\9return self:GetActiveLocale():GetText(localizationKey) or -- Look in the currently active locale\r\
\9\9(self:GetLocale(DEFAULT_LOCALE_CODE) and self:GetLocale(DEFAULT_LOCALE_CODE):GetText(localizationKey)) or -- Look in the English locale from Curse\r\
\9\9self:GetDefaultLocale():GetText(localizationKey) or -- Look in the default locale\r\
\9\9localizationKey; -- As a last resort, to avoid nil strings, return the key itself\r\
end\r\
\r\
return Localization"
, '@'.."./Tools/Localization/Localization.lua" ) ) )

package.preload[ "Tools/Maths" ] = injectRequire(assert( (loadstring or load)(
"local Assertions = require \"Tools.Assertions\"\r\
\r\
local Maths = {}\r\
\r\
--- Increments a given value by the given increments up to a given max.\r\
---@param value number A number value we want to increment\r\
---@param increment number The increment used for the value\r\
---@param max number The maximum for the value. If value + increment is higher than max, max will be used instead\r\
---@return number The incremented value\r\
function Maths.incrementValueUntilMax(value, increment, max)\r\
\9Assertions.isType(value, \"number\", \"value\");\r\
\9Assertions.isType(increment, \"number\", \"increment\");\r\
\9Assertions.isType(max, \"number\", \"max\");\r\
\r\
\9if value + increment > max then\r\
\9\9return max;\r\
\9else\r\
\9\9return value + increment;\r\
\9end\r\
end\r\
\r\
---Wrap a value. If the value goes over the maximum it will start over to 1, if it is below 1 it will start from the max\r\
---This is copied from a new function in BfA, but I can't wait so I'm making it mine :D\r\
---@param value number The number to wrap\r\
---@param max number The max value\r\
function Maths.wrap(value, max)\r\
\9return (value - 1) % max + 1;\r\
end\r\
\r\
--- Round the given number to the given decimal\r\
---@param value number\r\
---@param decimals number Optional, defaults to 0 decimals\r\
---@return number\r\
---@overload fun(value:number):number\r\
function Maths.round(value, decimals)\r\
\9local mult = 10 ^ (decimals or 0)\r\
\9return math.floor(value * mult) / mult;\r\
end\r\
\r\
return Maths"
, '@'.."./Tools/Maths.lua" ) ) )

package.preload[ "Tools/Promises/Promise" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local PooledObjectMixin = require \"Internals.PooledObjectMixin\"\r\
local PromisesStatus = require \"Tools.Promises.PromisesStatus\"\r\
\r\
---@class Promise : MiddleClass_Class\r\
local Promise= Class(\"Promise\")\r\
Promise:include(PooledObjectMixin)\r\
\r\
function Promise:initialize()\r\
\9private[self].status = PromisesStatus.PENDING\r\
\r\
\9private[self].onSuccessCallbacks = {}\r\
\9private[self].onFailCallbacks = {}\r\
\9private[self].onAlwaysCallbacks = {}\r\
end\r\
\r\
---@return number One of PromisesStatus\r\
function Promise:GetStatus()\r\
\9return private[self].status\r\
end\r\
\r\
---@return boolean True if the Promise has ben fulfilled\r\
function Promise:HasBeenFulfilled()\r\
\9return self:GetStatus() == PromisesStatus.FULFILLED\r\
end\r\
\r\
function Promise:Then(onSuccess, onFail, always)\r\
\9table.insert(private[self].onSuccessCallbacks, onSuccess)\r\
\9table.insert(private[self].onFailCallbacks, onFail)\r\
\9table.insert(private[self].onAlwaysCallbacks, always)\r\
\r\
\9if self:GetStatus() == PromisesStatus.FULFILLED then\r\
\9\9onSuccess(unpack(private[self].resolutionArgs))\r\
\9end\r\
\r\
\9if onFail and self:GetStatus() == PromisesStatus.REJECTED then\r\
\9\9onFail(unpack(private[self].resolutionArgs))\r\
\9end\r\
\r\
\9if always and (self:GetStatus() == PromisesStatus.REJECTED or self:GetStatus() == PromisesStatus.FULFILLED) then\r\
\9\9always(unpack(private[self].resolutionArgs))\r\
\9end\r\
\r\
\9return self\r\
end\r\
\r\
function Promise:Success(callback)\r\
\9table.insert(private[self].onSuccessCallbacks, callback)\r\
\r\
\9if self:GetStatus() == PromisesStatus.FULFILLED then\r\
\9\9callback(unpack(private[self].resolutionArgs))\r\
\9end\r\
\r\
\9return self\r\
end\r\
\r\
function Promise:Fail(callback)\r\
\9table.insert(private[self].onFailCallbacks, callback)\r\
\r\
\9if self:GetStatus() == PromisesStatus.REJECTED then\r\
\9\9callback(unpack(private[self].resolutionArgs))\r\
\9end\r\
\r\
\9return self\r\
end\r\
\r\
function Promise:Always(callback)\r\
\9table.insert(private[self].onAlwaysCallbacks, callback)\r\
\r\
\9if self:GetStatus() == PromisesStatus.REJECTED or self:GetStatus() == PromisesStatus.FULFILLED then\r\
\9\9callback(unpack(private[self].resolutionArgs))\r\
\9end\r\
\r\
\9return self\r\
end\r\
\r\
function Promise:Resolve(...)\r\
\9private[self].status = PromisesStatus.FULFILLED\r\
\9private[self].resolutionArgs = { ...}\r\
\r\
\9for _, callback in ipairs(private[self].onSuccessCallbacks) do\r\
\9\9callback(...)\r\
\9end\r\
\r\
\9for _, callback in ipairs(private[self].onAlwaysCallbacks) do\r\
\9\9callback(...)\r\
\9end\r\
\r\
\9return self\r\
end\r\
\r\
function Promise:Reject(...)\r\
\9if self:GetStatus() == PromisesStatus.REJECTED then\r\
\9\9return error(\"Trying to resolve a Promise that has already been rejected.\")\r\
\9elseif self:GetStatus() == PromisesStatus.FULFILLED then\r\
\9\9return error(\"Trying to reject a Promise that has already been resolved.\")\r\
\9end\r\
\r\
\9private[self].status = PromisesStatus.REJECTED\r\
\r\
\9for _, callback in ipairs(private[self].onFailCallbacks) do\r\
\9\9callback(...)\r\
\9end\r\
\r\
\9for _, callback in ipairs(private[self].onAlwaysCallbacks) do\r\
\9\9callback(...)\r\
\9end\r\
\r\
\9return self\r\
end\r\
\r\
return Promise\r\
"
, '@'.."./Tools/Promises/Promise.lua" ) ) )

package.preload[ "Tools/Promises/Promises" ] = injectRequire(assert( (loadstring or load)(
"local Promise = require \"Tools.Promises.Promise\"\r\
\r\
--- Helpers to handle one or more promises\r\
local Promises = {}\r\
\r\
--- Create a new promise that will gather all promises\r\
---@vararg Promise\r\
---@return Promise\r\
function Promises.all(...)\r\
\9local promises = { ... }\r\
\9local allPromise = Promise()\r\
\r\
\9-- This table will hold the values of each Promise resolution\r\
\9local promisesResolutionArgs = {}\r\
\r\
\9for _, promise in pairs(promises) do\r\
\9\9-- If any of the promise fail, the we reject the promise\r\
\9\9promise:Fail(function(...)\r\
\9\9\9allPromise:Reject(...)\r\
\9\9end)\r\
\r\
\9\9promise:Success(function(...)\r\
\9\9\9table.insert(promisesResolutionArgs, { ... })\r\
\9\9\9local allPromisesHaveBeenFulfilled = true\r\
\9\9\9for _, otherPromise in ipairs(promises) do\r\
\9\9\9\9if not otherPromise:HasBeenFulfilled() then\r\
\9\9\9\9\9allPromisesHaveBeenFulfilled = false\r\
\9\9\9\9end\r\
\9\9\9end\r\
\r\
\9\9\9if allPromisesHaveBeenFulfilled then\r\
\9\9\9\9-- If all promises have been resolved, we resolve the allPromise with the table of all the resolutions values\r\
\9\9\9\9allPromise:Resolve(promisesResolutionArgs)\r\
\9\9\9end\r\
\9\9end)\r\
\9end\r\
\r\
\9return allPromise\r\
end\r\
\r\
return Promises"
, '@'.."./Tools/Promises/Promises.lua" ) ) )

package.preload[ "Tools/Promises/PromisesStatus" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9PENDING = 0, -- The promise hasn't been resolved or rejected yet\r\
\9FULFILLED = 1, -- The promise has been resolved\r\
\9REJECTED = -1, -- The promise has been rejected\r\
}"
, '@'.."./Tools/Promises/PromisesStatus.lua" ) ) )

package.preload[ "Tools/SlashCommands/SlashCommand" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local Assertions = require \"Tools.Assertions\"\r\
local Colors = require \"Enums.Colors\"\r\
\r\
---@class Ellyb_SlashCommand: MiddleClass\r\
local SlashCommand = Class(\"SlashCommand\")\r\
\r\
---@param commandName string The name of the command. The user will input it after the slash token (`/token commandName`)\r\
---@param handler fun(...:any):void A handler that will be executed when the user runs the command, with any additional arguments.\r\
---@param helperText string A helper text that will be shown to the user to describe the command when listing all commands.\r\
function SlashCommand:initialize(commandName, handler, helperText)\r\
\9Assertions.isType(handler, \"function\", \"handler\")\r\
\9Assertions.isType(helperText, \"string\", \"helperText\")\r\
\9commandName = commandName:lower()\r\
\r\
\9private[self].commandName = commandName\r\
\9private[self].handler = handler\r\
\9private[self].helperText = helperText\r\
end\r\
\r\
--- Provide a displayable description of the command, with its name and its helper text.\r\
--- @return string\r\
function SlashCommand:GetDescription()\r\
\9return Colors.ORANGE(private[self].commandName) .. \" \" .. Colors.GREY(private[self].helperText)\r\
end\r\
\r\
--- Execute the SlashCommand handler with the given arguments\r\
function SlashCommand:Execute(...)\r\
\9private[self].handler(...)\r\
end\r\
\r\
---@return string\r\
function SlashCommand:GetName()\r\
\9return private[self].commandName\r\
end\r\
\r\
return SlashCommand"
, '@'.."./Tools/SlashCommands/SlashCommand.lua" ) ) )

package.preload[ "Tools/SlashCommands/SlashCommandsManager" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local Logger = require \"Logs.Logger\"\r\
local Colors = require \"Enums.Colors\"\r\
local Assertions = require \"Tools.Assertions\"\r\
local SlashCommand = require \"Tools.SlashCommands.SlashCommand\"\r\
\r\
--- Create a SlashCommandManager to handle receiving chat slash commands from the user.\r\
---\r\
--- ## Example:\r\
--- ```Lua\r\
--- local mySlashCommandManager = SlashCommandManager(\"MyAddon\", \"MyAddon\", \"MA\")\r\
--- local toggleDebug = SlashCommand(\"debug\", function(enable)\r\
---   config.DEBUG_MODE = enable == \"true\"\r\
--- end, 'Pass \"true\" to enable debug mode, \"false\" to disable it.')\r\
--- mySlashCommandManager:Register(toggleDebug)\r\
--- ```\r\
---\r\
---@class Ellyb_SlashCommandsManager: MiddleClass\r\
local SlashCommandsManager = Class(\"SlashCommandsManager\")\r\
\r\
local SLASH_COMMAND_GLOBAL_FORMAT = \"SLASH_%s1\"\r\
\r\
---@param name string\r\
---@vararg string A list of command tokens that can be used to call the SlashCommandManger. At least 1 is required.\r\
function SlashCommandsManager:initialize(name, ...)\r\
\9Assertions.isType(name, \"string\", \"name\")\r\
\9local commandTokens = { ... }\r\
\9Assertions.hasAtLeast(1, commandTokens, \"commandToken\")\r\
\9local mainCommandToken = commandTokens[1] -- The first command token is the one that will be used for the help message\r\
\r\
\9private[self].name = name\r\
\9private[self].commandTokens = commandTokens\r\
\9private[self].commands = {}\r\
\9private[self].logger = Logger(\"/\" .. name)\r\
\r\
\9local function commandCallback(arguments)\r\
\9\9local args = { strsplit(\" \", arguments) }\r\
\9\9local commandName = args[1]\r\
\9\9table.remove(args, 1)\r\
\r\
\9\9if commandName then\r\
\9\9\9commandName = commandName:lower()\r\
\9\9\9if private[self].commands[commandName] then\r\
\9\9\9\9---@type Ellyb_SlashCommand\r\
\9\9\9\9local command = private[self].commands[commandName]\r\
\9\9\9\9private[self].logger:Info(\"Running command \" .. command:GetName(), unpack(args))\r\
\9\9\9\9command:Execute(unpack(args))\r\
\9\9\9\9return\r\
\9\9\9else\r\
\9\9\9\9print(\"Command not found \" .. commandName)\r\
\9\9\9end\r\
\9\9end\r\
\r\
\9\9-- Show command list\r\
\9\9print(\"List of slash commands for available for \" .. Colors.ORANGE(name) .. \":\\n\")\r\
\r\
\9\9for command, commandInfo in pairs(private[self].commands) do\r\
\9\9\9local cmdText = Colors.ORANGE(\"/\" .. mainCommandToken .. \" \" .. command)\r\
\9\9\9if commandInfo.helperText then\r\
\9\9\9\9cmdText = cmdText .. \" \" .. Colors.GREY(commandInfo.helperText)\r\
\9\9\9end\r\
\9\9\9print(cmdText)\r\
\9\9end\r\
\9end\r\
\r\
\9for _, commandToken in pairs(commandTokens) do\r\
\9\9commandToken = strtrim(commandToken)\r\
\9\9local globalName = commandToken:upper()\r\
\9\9local globalKey = format(SLASH_COMMAND_GLOBAL_FORMAT, globalName)\r\
\9\9local slashCommandName = \"/\" .. commandToken:lower()\r\
\9\9_G[globalKey] = slashCommandName\r\
\9\9_G.SlashCmdList[globalName] = commandCallback\r\
\9end\r\
end\r\
\r\
---@param command Ellyb_SlashCommand\r\
function SlashCommandsManager:Register(command)\r\
\9Assertions.isInstanceOf(command, SlashCommand, \"command\")\r\
\9assert(not private[self].commands[command:GetName()], ([[Command \"%s\" has already been registered on \"%s\".]]):format(command:GetName(), private[self].name))\r\
\r\
\9private[self].commands[command:GetName()] = command\r\
\9private[self].logger:Info(Colors.GREEN(\"Registered\") .. \" new slash command: \" .. command:GetDescription())\r\
end\r\
\r\
function SlashCommandsManager:Unregister(command)\r\
\9Assertions.isInstanceOf(command, SlashCommand, \"command\")\r\
\9private[self].commands[command:GetName()] = nil\r\
\9private[self].logger:Info(Colors.RED(\"Unregistered\") ..\" slash command \" .. Colors.ORANGE(command:GetName()))\r\
end\r\
\r\
return SlashCommandsManager"
, '@'.."./Tools/SlashCommands/SlashCommandsManager.lua" ) ) )

package.preload[ "Tools/Strings/Interpolate" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local Functions = require \"Tools.Functions\"\r\
local PooledObjectMixin = require \"Internals.PooledObjectMixin\"\r\
\r\
--- Cache used by the Interpolator class that takes a format specifier without its preceeding \"%\" and gives it one.\r\
--- This cache exists because we treat the replacement as a hot loop, and string concatenation is not very performant.\r\
---@type string[]\r\
local replacementCache = setmetatable({}, {\r\
\9__mode = \"k\",\r\
\9__index = function(self, specifier)\r\
\9\9self[specifier] = \"%\" .. specifier\r\
\9\9return self[specifier]\r\
\9end,\r\
})\r\
\r\
--- Class that manages the replacement of named references in a format string.\r\
--- It exists purely because we don't necessarily want to allocate a garbage\r\
--- closure each time String.interpolate() is called.\r\
---\r\
--- This class should be treated as an implementation detail and not exported.\r\
local Interpolator = Class(\"Interpolator\")\r\
Interpolator:include(PooledObjectMixin);\r\
\r\
function Interpolator:initialize()\r\
\9-- Ensure the replacements and offset are reset on each re-init.\r\
\9self.replacements = nil\r\
\9self.offset = 1\r\
\r\
\9-- We'll need a closure to forward the actual replacement to our method. This should be cached across each init.\r\
\9self.onReplacement = self.onReplacement or Functions.bind(self.Replace, self)\r\
end\r\
\r\
--- Formats the given format string against the given table of replacements.\r\
--- @param formatString string The template string to format.\r\
--- @param replacements string Table of replacements to make.\r\
--- @return string\r\
function Interpolator:Format(formatString, replacements)\r\
\9-- Store the replacements and reset the offset, if present.\r\
\9self.replacements = replacements\r\
\9self.offset = 1\r\
\r\
\9-- This monstrosity below is a foul and arcane incantation that basically\r\
\9-- matches the subset of C's printf that Lua actually implements, as\r\
\9-- well as providing support for Blizzard's positional extension syntax.\r\
\9--\r\
\9-- If you're going to change this, please consult these references:\r\
\9--   - http://www.cplusplus.com/reference/cstdio/printf/\r\
\9--   - http://pgl.yoyo.org/luai/i/string.format\r\
\9local MATCH_STRING = \"(%%((%d?)[%w_]*)$?([-+ #0]-%d*%.?%d*[diuoxXfFeEgGcsq]))\"\r\
\9return formatString:gsub(MATCH_STRING, self.onReplacement)\r\
end\r\
\r\
--- Internal handler invoked by string.gsub when it finds a specifier match.\r\
---@param full string\r\
---@param key string\r\
---@param keyFirstChar string\r\
---@param specifier string\r\
function Interpolator:Replace(full, key, keyFirstChar, specifier)\r\
\9-- Try converting the key to a number if anything.\r\
\9key = tonumber(key) or key\r\
\r\
\9-- No key? Standard replacement. Increment our internal offset with it.\r\
\9if not key or key == \"\" then\r\
\9\9local offset = self.offset\r\
\9\9local output = full:format(self.replacements[offset])\r\
\r\
\9\9self.offset = offset + 1\r\
\9\9return output\r\
\9end\r\
\r\
\9-- Our documentation claims we only support Lua identifiers as keys, or fully numeric ones.\r\
\9-- If the first character is numeric but the full key isn't,\r\
\9-- then you're being mean by giving us something that isn't actually a Lua identifier.\r\
\9if tonumber(keyFirstChar) and not tonumber(key) then\r\
\9\9return\r\
\9end\r\
\r\
\9-- Keyed/named replacement. The one catch here is specifier lacks the preceeding \"%\",\r\
\9-- and we can't use the full match because it has the key. Good thing we made that cache table, right?\r\
\9return replacementCache[specifier]:format(self.replacements[key])\r\
end\r\
\r\
return Interpolator"
, '@'.."./Tools/Strings/Interpolate.lua" ) ) )

package.preload[ "Tools/Strings/Strings" ] = injectRequire(assert( (loadstring or load)(
"local Assertions = require \"Tools.Assertions\"\r\
local Colors = require \"Enums.Colors\"\r\
local Locales = require \"Enums.Locales\"\r\
local SpecialCharacters = require \"Enums.SpecialCharacters\"\r\
local Maths = require \"Tools.Maths\"\r\
\r\
local Strings = {};\r\
\r\
-- Only used for French related stuff, it's okay if non-latin characters are not here\r\
-- Note: We have a list of lowercase and uppercase letters here, because string.lower doesn't\r\
-- like accentuated uppercase letters at all, so we can't have just lowercase letters and apply a string.lower.\r\
local VOWELS = { \"a\", \"e\", \"i\", \"o\", \"u\", \"y\", \"A\"; \"E\", \"I\", \"O\", \"U\", \"Y\", \"À\", \"Â\", \"Ä\", \"Æ\", \"È\", \"É\", \"Ê\", \"Ë\", \"Î\", \"Ï\", \"Ô\", \"Œ\", \"Ù\", \"Û\", \"Ü\", \"Ÿ\", \"à\", \"â\", \"ä\", \"æ\", \"è\", \"é\", \"ê\", \"ë\", \"î\", \"ï\", \"ô\", \"œ\", \"ù\", \"û\", \"ü\", \"ÿ\" };\r\
VOWELS = tInvert(VOWELS); -- Invert the table so it is easier to check if something is a vowel\r\
\r\
---@param letter string A single letter as a string (can be uppercase or lowercase)\r\
---@return boolean  True if the letter is a vowel\r\
function Strings.isAVowel(letter)\r\
\9Assertions.isType(letter, \"string\", \"letter\");\r\
\9return VOWELS[letter] ~= nil;\r\
end\r\
\r\
---@param text string\r\
---@return string The first letter in the string that was passed\r\
function Strings.getFirstLetter(text)\r\
\9Assertions.isType(text, \"string\", \"text\");\r\
\9return text:sub(1, 1);\r\
end\r\
\r\
-- Build a list of characters that can be used to generate IDs\r\
local ID_CHARS = {};\r\
for i = 48, 57 do\r\
\9table.insert(ID_CHARS, string.char(i));\r\
end\r\
for i = 65, 90 do\r\
\9table.insert(ID_CHARS, string.char(i));\r\
end\r\
for i = 97, 122 do\r\
\9table.insert(ID_CHARS, string.char(i));\r\
end\r\
local sID_CHARS = #ID_CHARS;\r\
\r\
--- Generate a pseudo-unique random ID.\r\
--- If you encounter a collision, you really should playing lottery\r\
---@return string ID @ Generated ID\r\
function Strings.generateID()\r\
\9local ID = date(\"%m%d%H%M%S\");\r\
\9for _ = 1, 5 do\r\
\9\9ID = ID .. ID_CHARS[random(1, sID_CHARS)];\r\
\9end\r\
\9return ID;\r\
end\r\
\r\
--- A secure way to check if a String matches a pattern.\r\
--- This is useful when using user-given pattern, as malformed pattern would produce lua error.\r\
---@param stringToCheck string The string in which we will search for the pattern\r\
---@param pattern string Lua matching pattern\r\
---@return number The index at which the string was found\r\
function Strings.safeMatch(stringToCheck, pattern)\r\
\9local ok, result = pcall(string.find, string.lower(stringToCheck), string.lower(pattern));\r\
\9if not ok then\r\
\9\9return false; -- Syntax error.\r\
\9end\r\
\9-- string.find should return a number if the string matches the pattern\r\
\9return string.find(tostring(result), \"%d\");\r\
end\r\
\r\
--- Search if the string has the pattern in error-safe way.\r\
--- Useful if the pattern his user written.\r\
---@param text string The string to test\r\
---@param pattern string The pattern to match\r\
---@return boolean Returns true if the pattern was matched in the given text\r\
function Strings.safeFind(text, pattern)\r\
\9local trace = { pcall(string.find, text, pattern) };\r\
\9if trace[1] then\r\
\9\9return type(trace[2]) == \"number\";\r\
\9end\r\
\9return false; -- Pattern error\r\
end\r\
\r\
--- Generate a pseudo-random unique ID while checking a table for possible collisions.\r\
---@param table table A table where indexes are IDs generated via Strings.generateID\r\
---@return string ID An ID that is not already used inside this table\r\
function Strings.generateUniqueID(table)\r\
\9local ID = Strings.generateID();\r\
\9while table[ID] ~= nil do\r\
\9\9ID = Strings.generateID();\r\
\9end\r\
\9return ID;\r\
end\r\
\r\
--- Generate a unique name by checking in a table indexed by names if a given exists and iterate to find a suitable non-taken name\r\
---@param table table A table indexed by names\r\
---@param name string The name we want to use\r\
---@param customSuffixPattern string A custom pattern to use when inserting a sequential number (for example, \":1\")\r\
---@return string The final name that can be used, if the given name was taken, (n) will be appended,\r\
---@overload fun(table:table, name:string):string\r\
---For example if \"My name\" is already taken and \"My name (1)\" is already taken, will return \"My name (2)\"\r\
function Strings.generateUniqueName(table, name, customSuffixPattern)\r\
\9local suffix = customSuffixPattern or \"(%s)\"\r\
\9local originalName = name;\r\
\9local tries = 1;\r\
\9while table[name] ~= nil do\r\
\9\9name = originalName .. \" \" .. suffix:format(tries);\r\
\9\9tries = tries + 1;\r\
\9end\r\
\9return name;\r\
end\r\
\r\
--- Check if a text is an empty string and returns nil instead\r\
---@param text string @ The string to check\r\
---@return string|nil text @ Returns nil if the given text was empty\r\
function Strings.emptyToNil(text)\r\
\9if text and #text > 0 then\r\
\9\9return text;\r\
\9end\r\
\9return nil;\r\
end\r\
\r\
--- Assure that the given string will not be nil\r\
---@param text string|nil @ A string that could be nil\r\
---@return string text @ Always return a string, empty string if the given text was nil\r\
function Strings.nilToEmpty(text)\r\
\9return text or \"\";\r\
end\r\
\r\
local SANITIZATION_PATTERNS = {\r\
\9[\"|c%x%x%x%x%x%x%x%x\"] = \"\", -- color start\r\
\9[\"|r\"] = \"\", -- color end\r\
\9[\"|H.-|h(.-)|h\"] = \"%1\", -- links\r\
\9[\"|T.-|t\"] = \"\", -- textures\r\
\9[\"|A.-|a\"] = \"\", -- atlases\r\
}\r\
\r\
---Sanitize a given text, removing potentially harmful escape sequences that could have been added by a end user (to display huge icons in their tooltips, for example).\r\
---@param text string @ A text that should be sanitized\r\
---@return string sanitizedText @ The sanitized version of the given text\r\
function Strings.sanitize(text)\r\
\9if not text then\r\
\9\9return\r\
\9end\r\
\9for k, v in pairs(SANITIZATION_PATTERNS) do\r\
\9\9text = text:gsub(k, v);\r\
\9end\r\
\9return text;\r\
end\r\
\r\
---Crop a string of text if it is longer than the given size, and append … to indicate that the text has been cropped by default.\r\
---@param text string The string of text that will be cropped\r\
---@param size number The number of characters at which the text will be cropped.\r\
---@param appendEllipsisAtTheEnd boolean Indicates if ellipsis (…) should be appended at the end of the text when cropped (defaults to true)\r\
---@return string croppedText @ The cropped version of the text if it was longer than the given size, or the untouched version if the text was shorter.\r\
---@overload fun(text:string, size:number):string\r\
function Strings.crop(text, size, appendEllipsisAtTheEnd)\r\
\9if not text then\r\
\9\9return\r\
\9end\r\
\r\
\9Assertions.isType(size, \"number\", \"size\");\r\
\9assert(size > 0, \"Size has to be a positive number.\");\r\
\r\
\9if appendEllipsisAtTheEnd == nil then\r\
\9\9appendEllipsisAtTheEnd = true;\r\
\9end\r\
\r\
\9text = strtrim(text or \"\");\r\
\9if text:len() > size then\r\
\9\9text = text:sub(1, size);\r\
\9\9if appendEllipsisAtTheEnd then\r\
\9\9\9text = text .. \"…\";\r\
\9\9end\r\
\9end\r\
\9return text\r\
end\r\
\r\
--- Format click instructions\r\
---@param click string\r\
---@param text string\r\
---@return string\r\
function Strings.clickInstruction(click, text)\r\
\9return Colors.YELLOW(\"[\" .. click .. \"]\") .. \": \" .. Colors.WHITE(text);\r\
end\r\
\r\
local BYTES_MULTIPLES = { \"byte\", \"bytes\", \"KB\", \"MB\", \"GB\", \"TB\", \"PB\", \"EB\", \"ZB\", \"YB\" };\r\
if GetLocale() == Locales.FRENCH then\r\
\9-- French locales use the term \"octet\" instead of \"byte\" https://en.wikipedia.org/wiki/Octet_(computing)\r\
\9BYTES_MULTIPLES = { \"octet\", \"octets\", \"Ko\", \"Mo\", \"Go\", \"To\", \"Po\", \"Eo\", \"Zo\", \"Yo\" };\r\
end\r\
--- Format a size in bytes into a human readable size string.\r\
---@param bytes number A numeric value representing a size in bytes.\r\
---@return string A string representation of the size (example: `\"8 bytes\"`, `\"23GB\"`)\r\
function Strings.formatBytes(bytes)\r\
\9Assertions.isType(bytes, \"number\", \"bytes\");\r\
\r\
\9if bytes < 2 then\r\
\9\9return bytes .. SpecialCharacters.NON_BREAKING_SPACE .. BYTES_MULTIPLES[1];\r\
\9end\r\
\r\
\9local i = tonumber(math.floor(math.log(bytes) / math.log(1024)));\r\
\r\
\9return Maths.round(bytes / math.pow(1024, i), 2) .. SpecialCharacters.NON_BREAKING_SPACE .. BYTES_MULTIPLES[i + 2];\r\
end\r\
\r\
--- Split a string into a table using a given separator\r\
--- Taken from http://lua-users.org/wiki/SplitJoin\r\
---@param text string @ The string of text to split\r\
---@param separator string @ A separator\r\
---@return string[] textContent @ A table of strings\r\
function Strings.split(text, separator)\r\
\9Assertions.isType(text, \"string\", \"text\");\r\
\9Assertions.isType(separator, \"string\", \"separator\");\r\
\r\
\9local t = {}\r\
\9local fpat = \"(.-)\" .. separator\r\
\9local last_end = 1\r\
\9local s, e, cap = text:find(fpat, 1)\r\
\9while s do\r\
\9\9if s ~= 1 or cap ~= \"\" then\r\
\9\9\9table.insert(t, cap)\r\
\9\9end\r\
\9\9last_end = e + 1\r\
\9\9s, e, cap = text:find(fpat, last_end)\r\
\9end\r\
\9if last_end <= #text then\r\
\9\9cap = text:sub(last_end)\r\
\9\9table.insert(t, cap)\r\
\9end\r\
\9return t\r\
end\r\
\r\
--- Formats the given format string against the given table of replacements.\r\
---\r\
---  The format string can contain standard format specifiers as well as WoW\r\
---  ones (\"%s\", \"%1$s\") as well as named replacements in the similar form\r\
---  of \"%KEY_NAME$s\".\r\
---\r\
---  If the key segment of the specifier can be converted to a number, it\r\
---  will be. The key can otherwise only contain characters that would form a\r\
---  valid Lua identifier.\r\
---\r\
---  Positional replacements (%s) are looked up in the array part of the table\r\
---  and, for each match, an offset incremented. That is to say, the behavior\r\
---  between this and string.format() is be identical.\r\
---\r\
---  @param formatString string The template string to format.\r\
---  @param replacements string[] Table of replacements to make.\r\
function Strings.interpolate(formatString, replacements)\r\
\9local Interpolator = require \"Tools.Strings.Interpolate\"\r\
\9local replacer = Interpolator()\r\
\9local formatted = replacer:Format(formatString, replacements)\r\
\9replacer:ReleasePooledObject()\r\
\9return formatted\r\
end\r\
\r\
return Strings"
, '@'.."./Tools/Strings/Strings.lua" ) ) )

package.preload[ "Tools/System" ] = injectRequire(assert( (loadstring or load)(
"local GameClients = require \"Enums.GameClientTypes\"\r\
local loc = require \"Ellyb.Localization\"\r\
\r\
local System = {};\r\
\r\
---@return boolean isMac @ Returns true if the client is running on a Mac\r\
function System:IsMac()\r\
\9return IsMacClient();\r\
end\r\
\r\
function System:IsTestBuild()\r\
\9return IsTestBuild();\r\
end\r\
\r\
function System:IsTrialAccount()\r\
\9return IsTrialAccount();\r\
end\r\
\r\
function System:IsClassic()\r\
\9return WOW_PROJECT_ID == GameClients.CLASSIC;\r\
end\r\
\r\
function System:IsRetail()\r\
\9return WOW_PROJECT_ID == GameClients.RETAIL;\r\
end\r\
\r\
local SHORTCUT_SEPARATOR = System:IsMac() and \"-\" or \" + \";\r\
\r\
System.MODIFIERS = {\r\
\9CTRL = loc.MODIFIERS_CTRL,\r\
\9ALT = loc.MODIFIERS_ALT,\r\
\9SHIFT = loc.MODIFIERS_SHIFT,\r\
}\r\
\r\
local MAC_SHORT_EQUIVALENCE = {\r\
\9[System.MODIFIERS.CTRL] = loc.MODIFIERS_MAC_CTRL,\r\
\9[System.MODIFIERS.ALT] = loc.MODIFIERS_MAC_ALT,\r\
\9[System.MODIFIERS.SHIFT] = loc.MODIFIERS_MAC_SHIFT,\r\
}\r\
\r\
--- Format a keyboard shortcut with the appropriate separators according to the user operating system\r\
---@vararg string\r\
---@return string\r\
function System:FormatKeyboardShortcut(...)\r\
\9local shortcutComponents = { ... };\r\
\r\
\9return table.concat(shortcutComponents, SHORTCUT_SEPARATOR);\r\
end\r\
\r\
--- Format a keyboard shortcut with the appropriate separators according to the user operating system\r\
--- Will also convert Ctrl into Command and Alt into Option for Mac users.\r\
---@vararg string\r\
---@return string\r\
function System:FormatSystemKeyboardShortcut(...)\r\
\9local shortcutComponents = { ... };\r\
\r\
\9if IsMacClient() then\r\
\9\9-- Replace shortcut components\r\
\9\9for index, component in pairs(shortcutComponents) do\r\
\9\9\9if MAC_SHORT_EQUIVALENCE[component] then\r\
\9\9\9\9shortcutComponents[index] = MAC_SHORT_EQUIVALENCE[component];\r\
\9\9\9end\r\
\9\9end\r\
\9end\r\
\r\
\9return table.concat(shortcutComponents, SHORTCUT_SEPARATOR);\r\
end\r\
\r\
System.SHORTCUTS = {\r\
\9COPY = System:FormatSystemKeyboardShortcut(System.MODIFIERS.CTRL, \"C\"),\r\
\9PASTE = System:FormatSystemKeyboardShortcut(System.MODIFIERS.CTRL, \"V\"),\r\
};\r\
\r\
System.CLICKS = {\r\
\9CLICK = loc.CLICK ,\r\
\9RIGHT_CLICK = loc.RIGHT_CLICK,\r\
\9LEFT_CLICK = loc.LEFT_CLICK,\r\
\9MIDDLE_CLICK = loc.MIDDLE_CLICK,\r\
\9DOUBLE_CLICK = loc.DOUBLE_CLICK,\r\
};\r\
\r\
return System"
, '@'.."./Tools/System.lua" ) ) )

package.preload[ "Tools/Tables" ] = injectRequire(assert( (loadstring or load)(
"local Assertions = require \"Tools.Assertions\"\r\
\r\
-- WoW imports\r\
local tinsert = table.insert;\r\
local tremove = table.remove;\r\
\r\
local Tables = {};\r\
\r\
---Make use of WoW's shiny new table inspector window to inspect a table programatically\r\
---@param table table @ The table we want to inspect in WoW's table inspector\r\
function Tables.inspect(table)\r\
\9_G.UIParentLoadAddOn(\"Blizzard_DebugTools\");\r\
\9_G.DisplayTableInspectorWindow(table);\r\
end\r\
\r\
--- Recursively copy all content from a table to another one.\r\
--- Argument \"destination\" must be a non nil table reference.\r\
---@param destination table The table that will receive the new content\r\
---@param source table The table that contains the thing we want to put in the destination\r\
---@overload fun(source:table)\r\
function Tables.copy(destination, source)\r\
\9Assertions.isType(destination, \"table\", \"destination\");\r\
\r\
\9-- If we are only given one table, the that table is the source a new table is the destination\r\
\9if not source then\r\
\9\9source = destination;\r\
\9\9destination = {};\r\
\9else\r\
\9\9Assertions.isType(source, \"table\", \"source\");\r\
\9end\r\
\r\
\9for k, v in pairs(source) do\r\
\9\9if (type(v) == \"table\") then\r\
\9\9\9destination[k] = {};\r\
\9\9\9Tables.copy(destination[k], v);\r\
\9\9else\r\
\9\9\9destination[k] = v;\r\
\9\9end\r\
\9end\r\
\r\
\9return destination;\r\
end\r\
\r\
--- Return the table size.\r\
--- Less effective than #table but works for hash table as well (#hashtable don't).\r\
---@param table table\r\
---@return number The size of the table\r\
function Tables.size(table)\r\
\9Assertions.isType(table, \"table\", \"table\");\r\
\9-- We try to use #table first\r\
\9local tableSize = #table;\r\
\9if tableSize == 0 then\r\
\9\9-- And iterate over it if it didn't work\r\
\9\9for _, _ in pairs(table) do\r\
\9\9\9tableSize = tableSize + 1;\r\
\9\9end\r\
\9end\r\
\9return tableSize;\r\
end\r\
\r\
--- Remove an object from table\r\
--- Object is search with == operator.\r\
---@param table table The table in which we should remove the object\r\
---@param object any The object that should be removed\r\
---@return boolean Return true if the object is found\r\
function Tables.remove(table, object)\r\
\9Assertions.isType(table, \"table\", \"table\");\r\
\9Assertions.isNotNil(object, \"object\");\r\
\r\
\9for index, value in pairs(table) do\r\
\9\9if value == object then\r\
\9\9\9tremove(table, index);\r\
\9\9\9return true;\r\
\9\9end\r\
\9end\r\
\9return false;\r\
end\r\
\r\
---Returns a new table that contains the keys of the given table\r\
---@param table table\r\
---@return table A new table that contains the keys of the given table\r\
function Tables.keys(table)\r\
\9Assertions.isType(table, \"table\", \"table\");\r\
\9local keys = {};\r\
\9for key, _ in pairs(table) do\r\
\9\9tinsert(keys, key);\r\
\9end\r\
\9return keys;\r\
end\r\
\r\
---Check if a table is empty\r\
---@param table table @ A table to check\r\
---@return boolean isEmpty @ Returns true if the table is empty\r\
function Tables.isEmpty(table)\r\
\9Assertions.isType(table, \"table\", \"table\");\r\
\9return not next(table);\r\
end\r\
\r\
-- Create a weak tables pool.\r\
local TABLE_POOL = setmetatable( {}, { __mode = \"k\" } );\r\
\r\
--- Return an already created table, or a new one if the pool is empty\r\
--- It is super important to release the table once you are finished using it!\r\
---@return table\r\
function Tables.getTempTable()\r\
\9local t = next(TABLE_POOL);\r\
\9if t then\r\
\9\9TABLE_POOL[t] = nil;\r\
\9\9return wipe(t);\r\
\9end\r\
\9return {};\r\
end\r\
\r\
--- Release a temp table.\r\
---@param table\r\
function Tables.releaseTempTable(table)\r\
\9Assertions.isType(table, \"table\", \"table\");\r\
\9TABLE_POOL[table] = true;\r\
end\r\
\r\
-- The %q format will automatically quote and escape some special characters (thanks Itarater for the tip)\r\
local VALUE_TO_STRING = \"[%q]=%q,\"\r\
-- We do not escape the string representation of a table (it was already escaped before!)\r\
local TABLE_VALUE_TO_STRING = \"[%q]=%s,\"\r\
\r\
--- Return a string representation of the table in Lua syntax, suitable for a loadstring()\r\
---@param table table @ A valid table\r\
---@return string stringTable @ A string representation of the table in Lua syntax\r\
function Tables.toString(table)\r\
\9Assertions.isType(table, \"table\", \"table\");\r\
\r\
\9local t = \"{\";\r\
\9for key, value in pairs(table) do\r\
\9\9if type(value) == \"table\" then\r\
\9\9\9t = t .. format(TABLE_VALUE_TO_STRING, key, Tables.toString(value));\r\
\9\9else\r\
\9\9\9t = t .. format(VALUE_TO_STRING, key, value);\r\
\9\9end\r\
\9end\r\
\9t = t .. \"}\";\r\
\r\
\9return t;\r\
end\r\
\r\
return Tables\r\
"
, '@'.."./Tools/Tables.lua" ) ) )

package.preload[ "Tools/Textures/Icon" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local Texture = require \"Tools.Textures.Texture\"\r\
\r\
---@class Icon : Ellyb_Texture\r\
local Icon = Class(\"Icon\", Texture);\r\
\r\
local ICONS_FILE_PATH = [[Interface\\ICONS\\]]\r\
\r\
---@param icon string|number\r\
---@param size number|nil\r\
function Icon:initialize(icon, size)\r\
\9if type(icon) == \"string\" then\r\
\9\9if not icon:lower():find(\"interface\") then\r\
\9\9\9icon = ICONS_FILE_PATH .. icon;\r\
\9\9end\r\
\9end\r\
\9Texture.initialize(self, icon, size, size);\r\
end\r\
\r\
function Icon:SetTextureByIconName(iconName)\r\
\9if not iconName:lower():find(ICONS_FILE_PATH:lower()) then\r\
\9\9iconName = ICONS_FILE_PATH .. iconName;\r\
\9end\r\
\9self:SetTextureByID(iconName)\r\
end\r\
\r\
return Icon"
, '@'.."./Tools/Textures/Icon.lua" ) ) )

package.preload[ "Tools/Textures/Texture" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local UiEscapeSequences = require \"Enums.UiEscapeSequences\"\r\
\r\
--- This class in an abstraction to help handle World of Warcraft textures, especially when dealing with both texture IDs and file path.\r\
--- @class Ellyb_Texture: MiddleClass\r\
local Texture = Class(\"Texture\")\r\
\r\
---@private\r\
---@param source string|number\r\
---@param width number|nil\r\
---@param height number|nil\r\
function Texture:initialize(source, width, height)\r\
\9local typeOfSource = type(source);\r\
\r\
\9if typeOfSource == \"number\" then\r\
\9\9self:SetTextureByID(source);\r\
\9elseif typeOfSource == \"string\" then\r\
\9\9self:SetTextureFromFilePath(source);\r\
\9end\r\
\r\
\9-- If width and height were given we set them now\r\
\9if width ~= nil then\r\
\9\9self:SetWidth(width);\r\
\9end\r\
\9if height ~= nil then\r\
\9\9self:SetHeight(height);\r\
\9end\r\
end\r\
\r\
--{{{ File resource\r\
\r\
---@param fileID number @ The file ID you want to use for this texture.\r\
function Texture:SetTextureByID(fileID)\r\
\9private[self].fileID = fileID;\r\
end\r\
\r\
---@return number fileID @ A file ID that can be used to access this texture.\r\
function Texture:GetFileID()\r\
\9return private[self].fileID;\r\
end\r\
\r\
--- Set the texture using a file path. A file ID will be automatically resolved and used later.\r\
---@param filePath string @ The file path you want to use for this texture\r\
function Texture:SetTextureFromFilePath(filePath)\r\
\9private[self].filePath = filePath;\r\
\9if GetFileIDFromPath then\r\
\9\9self:SetTextureByID(GetFileIDFromPath(filePath));\r\
\9end\r\
end\r\
\r\
--- Get the file path that was used to create this texture.\r\
--- Since there is no way to get a path from a file ID\r\
---@return string|nil filePath @ The file path if the texture was created with one, otherwise nil if we don't have the information\r\
function Texture:GetFilePath()\r\
\9return private[self].filePath;\r\
end\r\
\r\
function Texture:GetFileName()\r\
\9return self:GetFilePath() and self:GetFilePath():match(\"^.+\\\\(.+)$\")\r\
end\r\
\r\
--- Check if this texture is using custom assets.\r\
--- Custom assets provided by add-ons will have a negative file ID. It is temporary and will change for every session.\r\
---@return boolean isUsingCustomAssets @ True if the texture is custom asset, false if it comes from the game's default files.\r\
function Texture:IsUsingCustomAssets()\r\
\9return self:GetFileID() < 0;\r\
end\r\
\r\
function Texture:GetResource()\r\
\9return self:GetFileID() or self:GetFilePath();\r\
end\r\
\r\
--}}}\r\
\r\
--{{{ UI Widget usage\r\
\r\
--- Apply the texture to a Texture UI widget\r\
---@param texture Texture\r\
function Texture:Apply(texture)\r\
\9texture:SetTexture(self:GetResource());\r\
\r\
\9if self:GetWidth() then\r\
\9\9texture:SetWidth(self:GetWidth());\r\
\9end\r\
\r\
\9if self:GetHeight() then\r\
\9\9texture:SetHeight(self:GetHeight());\r\
\9end\r\
end\r\
\r\
--}}}\r\
\r\
--{{{ Size manipulation\r\
\r\
function Texture:SetWidth(width)\r\
\9private[self].width = width;\r\
end\r\
\r\
---@return number\r\
function Texture:GetWidth()\r\
\9return private[self].width;\r\
end\r\
\r\
function Texture:SetHeight(height)\r\
\9private[self].height = height;\r\
end\r\
\r\
---@return number\r\
function Texture:GetHeight()\r\
\9return private[self].height;\r\
end\r\
\r\
--}}}\r\
\r\
--{{{ String representation\r\
\r\
---@return string texture @ Generate a string version of the texture using the width and height defined or 50px as a default value\r\
function Texture:__tostring()\r\
\9return self:GenerateString(self:GetWidth(), self:GetHeight());\r\
end\r\
\r\
local DEFAULT_TEXTURE_SIZE = 25;\r\
\r\
--- Generate a UI escape sequence string used to display the icon inside a text.\r\
---@param width number|nil @ The width of the icon, by default will be 50px.\r\
---@param height number|nil @ The height of the icon. If no height is provided but a width was defined the width will be used, otherwise the default value will be 50px\r\
---@return string texture\r\
function Texture:GenerateString(width, height)\r\
\9width = width or self:GetWidth() or DEFAULT_TEXTURE_SIZE;\r\
\9height = height or width;\r\
\9if self.coordinates then\r\
\r\
\9\9-- This is directly borrowed from Blizzard's code. Dark voodoo maths\r\
\9\9local atlasWidth = width / (self.coordinates.txRight - self.coordinates.txLeft);\r\
\9\9local atlasHeight = height / (self.coordinates.txBottom - self.coordinates.txTop);\r\
\r\
\9\9local pxLeft = atlasWidth * self.coordinates.txLeft;\r\
\9\9local pxRight = atlasWidth * self.coordinates.txRight;\r\
\9\9local pxTop = atlasHeight * self.coordinates.txTop;\r\
\9\9local pxBottom = atlasHeight * self.coordinates.txBottom;\r\
\r\
\9\9return UiEscapeSequences.TEXTURE_WITH_COORDINATES:format(self:GetResource(), width, height, atlasWidth, atlasHeight, pxLeft, pxRight, pxTop, pxBottom);\r\
\9else\r\
\9\9return UiEscapeSequences.TEXTURE:format(self:GetResource(), width, height);\r\
\9end\r\
end\r\
\r\
function Texture.CreateFromAtlas(atlasName)\r\
\9local filename, width, height, txLeft, txRight, txTop, txBottom = GetAtlasInfo(atlasName);\r\
\9local texture = Texture(filename);\r\
\9texture:SetCoordinates(width, height, txLeft, txRight, txTop, txBottom)\r\
\9return texture;\r\
end\r\
\r\
--}}}\r\
\r\
function Texture:SetCoordinates(width, height, txLeft, txRight, txTop, txBottom)\r\
\9self.coordinates = {\r\
\9\9width = width,\r\
\9\9height = height,\r\
\9\9txLeft = txLeft,\r\
\9\9txRight = txRight,\r\
\9\9txTop = txTop,\r\
\9\9txBottom = txBottom\r\
\9}\r\
end\r\
\r\
return Texture"
, '@'.."./Tools/Textures/Texture.lua" ) ) )

package.preload[ "Tools/Threads/Thread" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
\r\
---@class Thread : MiddleClass_Class\r\
local Thread = Class(\"Thread\")\r\
\r\
--- Execute the given function inside the thread.\r\
--- The given function should use `Thread:Yield()` to pause its execution\r\
---@param func function\r\
function Thread:Execute(func)\r\
\9private[self].thread = coroutine.create(func)\r\
end\r\
\r\
function Thread:GetStatus()\r\
\9return coroutine.status(private[self].thread)\r\
end\r\
\r\
function Thread:IsRunning()\r\
\9return self:GetStatus() == \"running\"\r\
end\r\
\r\
function Thread:IsSuspended()\r\
\9return self:GetStatus() == \"suspended\"\r\
end\r\
\r\
function Thread:HasFinished()\r\
\9return self:GetStatus() == \"dead\"\r\
end\r\
\r\
--- Pause the current thread execution\r\
function Thread:Yield()\r\
\9coroutine.yield()\r\
end\r\
\r\
--- Resume the thread execution\r\
function Thread:Resume()\r\
\9coroutine.resume(private[self].thread)\r\
end\r\
\r\
return Thread"
, '@'.."./Tools/Threads/Thread.lua" ) ) )

package.preload[ "Tools/Threads/Threads" ] = injectRequire(assert( (loadstring or load)(
"local Thread = require \"Tools.Threads.Thread\"\r\
\r\
local Threads = {}\r\
\r\
local DEFAULT_TICKER = 0.025\r\
---@type Thread[]\r\
local threads = {}\r\
local ThreadsFrame = CreateFrame(\"FRAME\")\r\
\r\
---Execute the given function in a separate thread using coroutines.\r\
---The function will receive a Thread and should call Thread:Yield() to pause its execution.\r\
---The thread will automatically resume 0.025 seconds after being paused.\r\
---@param func fun(yield: fun():void):void\r\
function Threads.run(func)\r\
\9local thread = Thread()\r\
\9table.insert(threads, thread)\r\
\9ThreadsFrame:RegisterOnUpdate()\r\
\9thread:Execute(function()\r\
\9\9func(function() thread:Yield() end)\r\
\9end)\r\
end\r\
\r\
--- Check if the time interval has reached a new tick\r\
---@return boolean True if a new interval was reached\r\
function ThreadsFrame:CheckInterval()\r\
\9self.elapsed = (self.elapsed or 0) + GetTimePreciseSec()\r\
\9if self.elapsed > DEFAULT_TICKER then\r\
\9\9self.elapsed = 0\r\
\9\9return true\r\
\9end\r\
\9return false\r\
end\r\
\r\
--- OnUpdate script to resume all threads when a new tick interval has been reached\r\
function ThreadsFrame:OnUpdate()\r\
\9-- Check if we have reached a new interval tick\r\
\9if self:CheckInterval() then\r\
\9\9-- Go through all current thread\r\
\9\9for index, thread in pairs(threads) do\r\
\r\
\9\9\9if thread:HasFinished() then\r\
\9\9\9\9-- If this thread has finished, remove it from the list\r\
\9\9\9\9threads[index] = nil\r\
\9\9\9elseif thread:IsSuspended() then\r\
\9\9\9\9-- If the thread was suspended we resume it\r\
\9\9\9\9thread:Resume()\r\
\9\9\9end\r\
\9\9end\r\
\9\9-- Unregister the OnUpdate script if we have no active thread\r\
\9\9self:UnregisterOnUpdateIfNoMoreThreads()\r\
\9end\r\
end\r\
\r\
--- Check if there are no more threads left and unregister the OnUpdate script then, to preserve performances\r\
function ThreadsFrame:UnregisterOnUpdateIfNoMoreThreads()\r\
\9if #threads < 1 then\r\
\9\9self:SetScript(\"OnUpdate\", nil)\r\
\9end\r\
end\r\
\r\
--- Register the OnUpdate script, if it wasn't already registered before\r\
function ThreadsFrame:RegisterOnUpdate()\r\
\9if not self:GetScript(\"OnUpdate\") then\r\
\9\9self:SetScript(\"OnUpdate\", self.OnUpdate)\r\
\9end\r\
end\r\
\r\
return Threads"
, '@'.."./Tools/Threads/Threads.lua" ) ) )

package.preload[ "Tools/Unit" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
local System = require \"Tools.System\"\r\
\r\
---@class Ellyb_Unit : MiddleClass\r\
local Unit = Class(\"Unit\")\r\
\r\
---Constructor\r\
---@param unitID string @ A unit ID (\"player\", \"mouseover\", \"target\", \"PlayerName-ServerName\")\r\
function Unit:initialize(unitID)\r\
\9private[self] = {}\r\
\9private[self].rawUnitID = unitID\r\
end\r\
\r\
---@return string GUID @ Return the GUID of the ID\r\
function Unit:GetGUID()\r\
\9return UnitGUID(private[self].rawUnitID) or UNKNOWNOBJECT\r\
end\r\
\r\
---@return string unitType @ The type of the unit, extracted from its GUID (\"Player\", \"Creature\", \"Pet\", \"Vehicle\", etc.)\r\
function Unit:GetType()\r\
\9local GUID = self:GetGUID()\r\
\9local unitType = strsplit(\"-\", GUID)\r\
\9return unitType\r\
end\r\
\r\
function Unit:GetNPCID()\r\
\9local _, _, _, _, _, npcID = strsplit(\"-\", self:GetGUID())\r\
\9return npcID\r\
end\r\
\r\
---@return string unitID @ Returns the unit ID in the format PlayerName-ServerName\r\
function Unit:GetUnitID()\r\
\9local playerName, realm = UnitFullName(private[self].rawUnitID)\r\
\9if not playerName or playerName:len() == 0 or playerName == UNKNOWNOBJECT then\r\
\9\9return nil\r\
\9end\r\
\9if not realm then\r\
\9\9local _, playerRealmName = UnitFullName(\"player\")\r\
\9\9realm = playerRealmName\r\
\9end\r\
\9if not realm then\r\
\9\9return playerName\r\
\9else\r\
\9\9return playerName .. \"-\" .. realm\r\
\9end\r\
end\r\
\r\
---@return boolean unitIsPlayer @ Returns true if the unit is a player, false if it is an NPC\r\
function Unit:IsPlayer()\r\
\9return UnitIsPlayer(private[self].rawUnitID)\r\
end\r\
\r\
--- Check if the unit exists (useful for mouseover or target unit)\r\
---@return boolean unitExists @ Returns true if the unit exists\r\
function Unit:Exists()\r\
\9return UnitExists(private[self].rawUnitID)\r\
end\r\
\r\
--- Check if the player can attack the unit\r\
---@return boolean unitIsAttackable @ Returns true if the player can attack the unit\r\
function Unit:IsAttackable()\r\
\9return UnitCanAttack(\"player\", private[self].rawUnitID)\r\
end\r\
\r\
--- Check if the unit can be mounted (has a multi seated mount, is in the same group/raid, has seats available, etc.)\r\
--- Will always return false on Classic client, as no unit are mountable in patch 1.13\r\
--- @return boolean Returns true if the unit can be mounted\r\
function Unit:IsMountable()\r\
\9if System:IsClassic() then\r\
\9\9return false\r\
\9end\r\
\9return UnitVehicleSeatCount(private[self].rawUnitID) and UnitVehicleSeatCount(private[self].rawUnitID) > 0 and (UnitInParty(private[self].rawUnitID) or UnitInRaid(private[self].rawUnitID))\r\
end\r\
\r\
return Unit"
, '@'.."./Tools/Unit.lua" ) ) )

package.preload[ "UI/Cursor" ] = injectRequire(assert( (loadstring or load)(
"local Logger = require \"Logs.Logger\"\r\
local Unit = require \"Tools.Unit\"\r\
local Assertions = require \"Tools.Assertions\"\r\
local Texture = require \"Tools.Textures.Texture\"\r\
\r\
--region Ellyb imports\r\
local logger = Logger(\"Cursor\")\r\
local Mouseover = Unit(\"mouseover\")\r\
local Target = Unit(\"target\")\r\
--endregion\r\
\r\
local Cursor = {}\r\
\r\
---@type Frame\r\
local CursorFrame = CreateFrame(\"Frame\", nil, UIParent)\r\
CursorFrame:SetSize(1, 1)\r\
CursorFrame:SetPoint(\"CENTER\")\r\
CursorFrame:Hide()\r\
\r\
local Icon = CursorFrame:CreateTexture()\r\
Icon:SetTexture([[Interface\\Cursor\\WorkOrders]])\r\
Icon:SetSize(30, 30)\r\
Icon:SetPoint(\"TOPLEFT\", 45, -15)\r\
\r\
local DEFAULT_ANCHOR_X, DEFAULT_ANCHOR_Y = 33, -3\r\
local shouldHideOnUnitChanged = false\r\
\r\
function CursorFrame:PlaceOnCursor()\r\
\9local scale = 1 / UIParent:GetEffectiveScale()\r\
\9local x, y = GetCursorPosition()\r\
\9self:SetPoint(\"CENTER\", UIParent, \"BOTTOMLEFT\", x * scale, y * scale)\r\
\9self.unit = Mouseover:GetUnitID()\r\
end\r\
\r\
CursorFrame:SetScript(\"OnUpdate\", function(self)\r\
\9local cursorUnit\r\
\9if Mouseover:Exists() then\r\
\9\9cursorUnit = Mouseover:GetUnitID()\r\
\9end\r\
\9if shouldHideOnUnitChanged and self.unitID and (not cursorUnit or cursorUnit ~= self.unitID) then\r\
\9\9self:Hide()\r\
\9\9shouldHideOnUnitChanged = false\r\
\9else\r\
\9\9self:PlaceOnCursor()\r\
\9end\r\
\9self.unitID = cursorUnit\r\
end)\r\
\r\
---Set the icon texture attached to the cursor\r\
---@param cursorTexture Ellyb_Texture A texture path or texture ID to display on the cursor\r\
---@param x number A custom horizontal offset for the icon (default is 33)\r\
---@param y number A custom vertical offset for the icon (default is -3)\r\
function Cursor.setIcon(cursorTexture, x, y)\r\
\9Assertions.isInstanceOf(cursorTexture, Texture, \"cursorTexture\")\r\
\r\
\9Icon:SetTexture(cursorTexture:GetFileID())\r\
\9Icon:SetPoint(\"TOPLEFT\", x or DEFAULT_ANCHOR_X, y or DEFAULT_ANCHOR_Y)\r\
\9CursorFrame:PlaceOnCursor()\r\
\9CursorFrame:Show()\r\
end\r\
\r\
function Cursor.hideOnUnitChanged()\r\
\9shouldHideOnUnitChanged = true\r\
end\r\
\r\
---Hide the cursor texture\r\
function Cursor.clearIcon()\r\
\9CursorFrame.unitID = nil\r\
\9CursorFrame:Hide()\r\
end\r\
\r\
local onUnitRightClickedCallbacks = {}\r\
\r\
---Register a new callback that will be called every time a unit is right-clicked\r\
---The system will check if the right-click is a drag or an actual click\r\
---and that the unit hasn't changed mid-click.\r\
---@param callback function @ A callback that will be called when a unit is right clicked\r\
function Cursor.onUnitRightClicked(callback)\r\
\9table.insert(onUnitRightClickedCallbacks, callback)\r\
end\r\
\r\
local clickTimestamp\r\
local clickUnitID\r\
\r\
-- Hook function called on right-click start on player\r\
hooksecurefunc(\"TurnOrActionStart\", function()\r\
\9CursorFrame.actionStarted = true\r\
\9clickUnitID = CursorFrame.unitID\r\
\9clickTimestamp = time()\r\
end)\r\
\r\
-- Hook function called when right-click is released\r\
hooksecurefunc(\"TurnOrActionStop\", function()\r\
\9CursorFrame.actionStarted = false\r\
\9if not clickTimestamp or not clickUnitID then\r\
\9\9return\r\
\9end\r\
\r\
\9-- If the right-click is maintained longer than 1 second, consider it a drag and not a click, ignore it\r\
\9if time() - clickTimestamp < 1 then\r\
\9\9-- Check that the user wasn't actually moving (very fast) the camera and the cursor still is on the targeted unit\r\
\9\9if Target:GetUnitID() == clickUnitID then\r\
\9\9\9logger:Info(\"Unit right clicked\", clickUnitID)\r\
\9\9\9for _, callback in pairs(onUnitRightClickedCallbacks) do\r\
\9\9\9\9callback(clickUnitID)\r\
\9\9\9end\r\
\9\9end\r\
\9end\r\
\r\
\9clickUnitID = nil\r\
\9clickTimestamp = nil\r\
end)\r\
\r\
return Cursor\r\
"
, '@'.."./UI/Cursor.lua" ) ) )

package.preload[ "UI/DeprecationWarnings" ] = injectRequire(assert( (loadstring or load)(
"local Assertions = require \"Tools.Assertions\"\r\
local Colors = require \"Enums.Colors\"\r\
local Logger = require \"Logs.Logger\"\r\
\r\
-- Ellyb imports\r\
local ORANGE, GREEN, GREY = Colors.ORANGE, Colors.GREEN, Colors.GREY;\r\
\r\
local DeprecationWarnings = {}\r\
\r\
local logger = Logger(\"Deprecation warnings\");\r\
\r\
--- Wraps an old API table so it throws deprecation warning when accessed.\r\
--- It will indicate the name of the new API and map the method calls to the new API.\r\
---@param newAPITable table Reference to the new API table\r\
---@param oldAPIName string Name of the old API table\r\
---@param newAPIName string Name of the new API table\r\
---@param oldAPIReference table Reference to the old API table\r\
---@return table\r\
function DeprecationWarnings.wrapAPI(newAPITable, oldAPIName, newAPIName, oldAPIReference)\r\
\9Assertions.isType(newAPITable, \"table\", \"newAPITable\")\r\
\9Assertions.isType(oldAPIReference, \"table\", \"oldAPIReference\")\r\
\9Assertions.isType(oldAPIName, \"string\", \"oldAPIName\")\r\
\9Assertions.isType(newAPIName, \"string\", \"newAPIName\")\r\
\r\
\9return setmetatable(oldAPIReference or {}, {\r\
\9\9__index = function(_, key)\r\
\9\9\9logger:Warning(([[DEPRECATED USAGE OF API %s.\r\
Please use %s instead.\r\
Stack: %s]]):format(ORANGE(oldAPIName), GREEN(newAPIName), GREY(debugstack(2, 3, 0))));\r\
\9\9\9return newAPITable[key];\r\
\9\9end,\r\
\9\9__newindex = function(_, key, value)\r\
\9\9\9logger:Warning(([[DEPRECATED USAGE OF API %s.\r\
Please use %s instead.\r\
Stack: %s]]):format(ORANGE(oldAPIName), GREEN(newAPIName), GREY(debugstack(2, 3, 0))));\r\
\9\9\9newAPITable[key] = value;\r\
\9\9end\r\
\9})\r\
end\r\
\r\
--- Wraps an old function so it throws deprecation warning when used.\r\
--- It will indicate the name of the new function and map the calls to the new function.\r\
---@param newFunction function A reference to the new function that should be used\r\
---@param oldFunctionName string The name of the old function that has been deprecated\r\
---@param newFunctionName string Name of the new function that should be used instead\r\
---@return function\r\
function DeprecationWarnings.wrapFunction(newFunction, oldFunctionName, newFunctionName)\r\
\9Assertions.isType(newFunction, \"function\", \"newFunction\")\r\
\9Assertions.isType(oldFunctionName, \"string\", \"oldFunctionName\")\r\
\9Assertions.isType(newFunctionName, \"string\", \"newFunctionName\")\r\
\r\
\9return function(...)\r\
\9\9logger:Warning(([[DEPRECATED USAGE OF FUNCTION %s.\r\
Please use %s instead.\r\
Stack: %s]]):format(ORANGE(oldFunctionName), GREEN(newFunctionName), GREY(debugstack(2, 3, 0))));\r\
\9\9return newFunction(...);\r\
\9end\r\
end\r\
\r\
---@param customWarning string A custom deprecation warning that should be logged\r\
function DeprecationWarnings.warn(customWarning)\r\
\9Assertions.isType(customWarning, \"string\", \"customWarning\")\r\
\r\
\9logger:Warning(([[%s\r\
Stack: %s]]):format(customWarning, debugstack(2, 3, 0)));\r\
end\r\
\r\
return DeprecationWarnings\r\
"
, '@'.."./UI/DeprecationWarnings.lua" ) ) )

package.preload[ "UI/EditBoxes" ] = injectRequire(assert( (loadstring or load)(
"local Maths = require \"Tools.Maths\"\r\
\r\
local EditBoxes = {}\r\
\r\
--{{{ Read only EditBoxes\r\
local readOnlyEditBoxes = {}\r\
\r\
---@param editBox EditBox|ScriptObject\r\
local function saveEditBoxOriginalText(editBox)\r\
\9if readOnlyEditBoxes[editBox] then\r\
\9\9editBox.originalText = editBox:GetText()\r\
\9end\r\
end\r\
\r\
---@param editBox EditBox|ScriptObject\r\
local function restoreOriginalText(editBox, userInput)\r\
\9if userInput and readOnlyEditBoxes[editBox] then\r\
\9\9editBox:SetText(editBox.originalText)\r\
\9end\r\
end\r\
\r\
---@param editBox EditBox|ScriptObject\r\
function EditBoxes.makeReadOnly(editBox)\r\
\9readOnlyEditBoxes[editBox] = true\r\
\r\
\9editBox:HookScript(\"OnShow\", saveEditBoxOriginalText)\r\
\9editBox:HookScript(\"OnTextChanged\", restoreOriginalText)\r\
end\r\
--}}}\r\
\r\
---@param editBox EditBox|ScriptObject\r\
function EditBoxes.selectAllTextOnFocus(editBox)\r\
\9editBox:HookScript(\"OnEditFocusGained\", editBox.HighlightText)\r\
end\r\
\r\
---@param editBox EditBox|ScriptObject\r\
function EditBoxes.looseFocusOnEscape(editBox)\r\
\9editBox:HookScript(\"OnEscapePressed\", editBox.ClearFocus)\r\
end\r\
\r\
--- Mixin for edit boxes that will handle serialized data.\r\
--- This mixin takes care of escaping and un-escaping the text that is set and get.\r\
---@type EditBox|ScriptObject\r\
EditBoxes.SerializedDataEditBoxMixin = {}\r\
\r\
---@type EditBox\r\
local EditBox = CreateFrame(\"EditBox\")\r\
EditBox:Hide()\r\
\r\
function EditBoxes.SerializedDataEditBoxMixin:GetText()\r\
\9return EditBox.GetText(self):gsub(\"||\", \"|\")\r\
end\r\
\r\
function EditBoxes.SerializedDataEditBoxMixin:SetText(text)\r\
\9return EditBox.SetText(self, text:gsub(\"|\", \"||\"))\r\
end\r\
\r\
---Setup keyboard navigation using the tab key inside a list of EditBoxes.\r\
---Pressing tab will jump to the next EditBox in the list, and shift-tab will go back to the previous one.\r\
---@vararg EditBox A list of EditBoxes\r\
function EditBoxes.setupTabKeyNavigation(...)\r\
\9local editBoxes = { ... }\r\
\9for index, editbox in ipairs(editBoxes) do\r\
\9\9editbox:HookScript(\"OnTabPressed\", function()\r\
\9\9\9local nextEditBoxIndex = index + (IsShiftKeyDown() and -1 or 1)\r\
\9\9\9Maths.wrap(nextEditBoxIndex, #editBoxes)\r\
\9\9\9editBoxes[nextEditBoxIndex]:SetFocus()\r\
\9\9end)\r\
\9end\r\
end\r\
\r\
return EditBoxes\r\
"
, '@'.."./UI/EditBoxes.lua" ) ) )

package.preload[ "UI/Frames" ] = injectRequire(assert( (loadstring or load)(
"local Assertions = require \"Tools.Assertions\"\r\
\r\
local Frames = {};\r\
\r\
---Make a frame movable. The frame's position is not saved.\r\
---@param frame Frame|ScriptObject\r\
---@param validatePositionOnDragStop boolean\r\
function Frames.makeMovable(frame, validatePositionOnDragStop)\r\
\9Assertions.isType(frame, \"Frame\", \"frame\");\r\
\9frame:RegisterForDrag(\"LeftButton\");\r\
\9frame:EnableMouse(true);\r\
\9frame:SetMovable(true);\r\
\r\
\9frame:HookScript(\"OnDragStart\", frame.StartMoving);\r\
\9frame:HookScript(\"OnDragStop\", frame.StopMovingOrSizing);\r\
\r\
\9if validatePositionOnDragStop then\r\
\9\9frame:HookScript(\"OnDragStop\", function()\r\
\9\9\9ValidateFramePosition(frame);\r\
\9\9end)\r\
\9end\r\
end\r\
\r\
--{{{ Mousewheel scroll on frame set slider value\r\
---@type table<Frame, Slider>\r\
local slidingFrames = {};\r\
\r\
---@param self Frame\r\
---@param delta number\r\
local function setSliderValueOnMouseScroll(self, delta)\r\
\9local slider = slidingFrames[self];\r\
\9if not slidingFrames[self] then\r\
\9\9return\r\
\9end\r\
\9if slider:IsEnabled() then\r\
\9\9local mini, maxi = slider:GetMinMaxValues();\r\
\9\9if delta == 1 and slider:GetValue() > mini then\r\
\9\9\9slider:SetValue(slider:GetValue() - 1);\r\
\9\9elseif delta == -1 and slider:GetValue() < maxi then\r\
\9\9\9slider:SetValue(slider:GetValue() + 1);\r\
\9\9end\r\
\9end\r\
end\r\
\r\
---Make scrolling with the mouse wheel on the given frame change the given slider value\r\
---@param frame Frame @ The frame that will receive the scroll wheel event\r\
---@param slider Slider @ The slider that should see its value changed\r\
function Frames.handleMouseWheelScroll(frame, slider)\r\
\9Assertions.isType(frame, \"Frame\", frame);\r\
\9Assertions.isType(slider, \"Slider\", slider);\r\
\r\
\9slidingFrames[frame] = slider\r\
\9frame:SetScript(\"OnMouseWheel\", setSliderValueOnMouseScroll);\r\
\9frame:EnableMouseWheel(1);\r\
end\r\
--}}}\r\
\r\
return Frames\r\
"
, '@'.."./UI/Frames.lua" ) ) )

package.preload[ "UI/Tooltips/Tooltip" ] = injectRequire(assert( (loadstring or load)(
"local Class = require \"Libraries.middleclass\"\r\
local private = require \"Internals.PrivateStorage\"\r\
\r\
local GameTooltip = GameTooltip\r\
\r\
---@class Ellyb_Tooltip : MiddleClass\r\
local Tooltip = Class(\"TooltipContent\")\r\
\r\
---@param parent Frame\r\
function Tooltip:initialize(parent)\r\
\9private[self].content = {}\r\
\9private[self].tempContent = {}\r\
\9private[self].parent = parent\r\
\9private[self].onShowCallbacks = {}\r\
end\r\
\r\
---@param text string\r\
---@param customColor Ellyb_Color\r\
function Tooltip:SetTitle(text, customColor)\r\
\9private[self].title = text\r\
\9private[self].customTitleColor = customColor\r\
\9return self\r\
end\r\
\r\
function Tooltip:GetTitle()\r\
\9return private[self].title\r\
end\r\
\r\
function Tooltip:SetTitleColor(customColor)\r\
\9private[self].customTitleColor = customColor\r\
\9return self\r\
end\r\
\r\
function Tooltip:GetTitleColor()\r\
\9if private[self].customTitleColor then\r\
\9\9return private[self].customTitleColor:GetRGBA()\r\
\9else\r\
\9\9return 1, 1, 1, 1\r\
\9end\r\
end\r\
\r\
---@param anchor string\r\
function Tooltip:SetAnchor(anchor)\r\
\9private[self].anchor = anchor\r\
\9return self\r\
end\r\
\r\
---@return string\r\
function Tooltip:GetAnchor()\r\
\9return \"ANCHOR_\" .. (private[self].anchor or \"RIGHT\")\r\
end\r\
\r\
---@param parent Frame\r\
function Tooltip:SetParent(parent)\r\
\9private[self].customParent = parent\r\
\9return self\r\
end\r\
\r\
---@return Frame\r\
function Tooltip:GetParent()\r\
\9return private[self].customParent or private[self].parent\r\
end\r\
\r\
function Tooltip:SetOffset(x, y)\r\
\9private[self].x = x\r\
\9private[self].y = y\r\
\9return self\r\
end\r\
\r\
---@return number, number\r\
function Tooltip:GetOffset()\r\
\9return private[self].x or 0, private[self].y or 0\r\
end\r\
\r\
---@param customColor Ellyb_Color\r\
function Tooltip:AddLine(text, customColor)\r\
\9table.insert(private[self].content, {\r\
\9\9text = text,\r\
\9\9customColor = customColor,\r\
\9})\r\
\9return self\r\
end\r\
\r\
function Tooltip:AddEmptyLine()\r\
\9table.insert(private[self].content, {\r\
\9\9text = \" \",\r\
\9})\r\
\9return self\r\
end\r\
\r\
function Tooltip:AddTempLine(text, customColor)\r\
\9table.insert(private[self].tempContent, {\r\
\9\9text = text,\r\
\9\9customColor = customColor,\r\
\9})\r\
\9return self\r\
end\r\
\r\
function Tooltip:GetLines()\r\
\9return private[self].content\r\
end\r\
\r\
function Tooltip:GetTempLines()\r\
\9return private[self].tempContent\r\
end\r\
\r\
function Tooltip:ClearLines()\r\
\9private[self].content = {}\r\
\9return self\r\
end\r\
\r\
function Tooltip:ClearTempLines()\r\
\9private[self].tempContent = {}\r\
\9return self\r\
end\r\
\r\
function Tooltip:SetLines(lines)\r\
\9self:ClearLines()\r\
\9for _, line in pairs(lines) do\r\
\9\9self:AddLine(line.text, line.customColor)\r\
\9end\r\
\9return self\r\
end\r\
\r\
---SetLine\r\
---@param text string\r\
---@param customColor Ellyb_Color\r\
function Tooltip:SetLine(text, customColor)\r\
\9self:ClearLines()\r\
\9self:AddLine(text, customColor)\r\
\9return self\r\
end\r\
\r\
---@param tooltipFrame GameTooltip\r\
function Tooltip:SetCustomTooltipFrame(tooltipFrame)\r\
\9private[self].tooltip = tooltipFrame\r\
\9return self\r\
end\r\
\r\
---@return GameTooltip\r\
function Tooltip:GetTooltipFrame()\r\
\9return private[self].tooltip or GameTooltip\r\
end\r\
\r\
function Tooltip:OnShow(callback)\r\
\9table.insert(private[self].onShowCallbacks, callback)\r\
end\r\
\r\
function Tooltip:Show()\r\
\r\
\9-- Call all the callbacks that have been registered of the OnShow event\r\
\9for _, callback in pairs(private[self].onShowCallbacks) do\r\
\9\9-- If one of the callback returns false, it means the tooltip should not be shown, we stop right here\r\
\9\9if callback(self) == false then\r\
\9\9\9return\r\
\9\9end\r\
\9end\r\
\r\
\9-- Do not show the tooltip if no title was defined yet\r\
\9if not self:GetTitle() then\r\
\9\9return\r\
\9end\r\
\r\
\9local tooltip = self:GetTooltipFrame()\r\
\9tooltip:ClearLines()\r\
\9tooltip:SetOwner(self:GetParent(), self:GetAnchor(), self:GetOffset())\r\
\9tooltip:SetText(self:GetTitle(), self:GetTitleColor())\r\
\r\
\9-- Insert all the lines inside the tooltip\r\
\9for _, line in pairs(self:GetLines()) do\r\
\9\9local r, g, b\r\
\9\9if line.customColor then\r\
\9\9\9r, g, b = line.customColor:GetRGBAAsBytes()\r\
\9\9end\r\
\9\9tooltip:AddLine(line.text, r, g, b, true)\r\
\9end\r\
\r\
\9-- Insert all the lines inside the tooltip\r\
\9for _, line in pairs(self:GetTempLines()) do\r\
\9\9local r, g, b\r\
\9\9if line.customColor then\r\
\9\9\9r, g, b = line.customColor:GetRGBAAsBytes()\r\
\9\9end\r\
\9\9tooltip:AddLine(line.text, r, g, b, true)\r\
\9end\r\
\r\
\9tooltip:Show()\r\
end\r\
\r\
function Tooltip:Hide()\r\
\9self:GetTooltipFrame():Hide()\r\
\9self:ClearTempLines()\r\
end\r\
\r\
return Tooltip"
, '@'.."./UI/Tooltips/Tooltip.lua" ) ) )

package.preload[ "UI/Tooltips/TooltipAnchors" ] = injectRequire(assert( (loadstring or load)(
"return {\r\
\9--- Align the top right of the tooltip with the bottom left of the owner\r\
\9BOTTOMLEFT = \"BOTTOMLEFT\",\r\
\9--- Align the top left of the tooltip with the bottom right of the owner\r\
\9BOTTOMRIGHT = \"BOTTOMRIGHT\",\r\
\9--- Toolip follows the mouse cursor\r\
\9CURSOR = \"CURSOR\",\r\
\9--- Align the bottom right of the tooltip with the top left of the owner\r\
\9LEFT = \"LEFT\",\r\
\9--- Tooltip appears in the default position\r\
\9NONE = \"NONE\",\r\
\9--- Tooltip's position is saved between sessions (useful if the tooltip is made user-movable)\r\
\9PRESERVE = \"PRESERVE\",\r\
\9--- Align the bottom left of the tooltip with the top right of the owner\r\
\9RIGHT = \"RIGHT\",\r\
\9--- Align the top of the tooltip with the bottom of the owner\r\
\9BOTTOM  = \"BOTTOM\",\r\
\9--- Align to bottom of the tooltip with the top of the owner\r\
\9TOP = \"TOP\",\r\
\9--- Align the bottom left of the tooltip with the top left of the owner\r\
\9TOPLEFT = \"TOPLEFT\",\r\
\9--- Align the bottom right of the tooltip with the top right of the owner\r\
\9TOPRIGHT = \"TOPRIGHT\",\r\
}"
, '@'.."./UI/Tooltips/TooltipAnchors.lua" ) ) )

package.preload[ "UI/Tooltips/TooltipManager" ] = injectRequire(assert( (loadstring or load)(
"local Tooltip = require \"UI.Tooltips.Tooltip\"\r\
\r\
local TooltipManager = {}\r\
\r\
local function showFrameTooltip(self)\r\
\9self.Tooltip:Show()\r\
end\r\
\r\
local function hideFrameTooltip(self)\r\
\9self.Tooltip:Hide()\r\
end\r\
\r\
---@param frame Frame|ScriptObject\r\
---@return Ellyb_Tooltip\r\
function TooltipManager.getTooltip(frame)\r\
\9if not frame.Tooltip then\r\
\9\9frame.Tooltip = Tooltip(frame)\r\
\9\9frame:HookScript(\"OnEnter\", showFrameTooltip)\r\
\9\9frame:HookScript(\"OnLeave\", hideFrameTooltip)\r\
\9end\r\
\r\
\9return frame.Tooltip\r\
end\r\
\r\
return TooltipManager"
, '@'.."./UI/Tooltips/TooltipManager.lua" ) ) )

end

injectRequire(assert( (loadstring or load)(
"local ColorManager = require \"Tools.Colors.ColorManager\"\r\
local Icon = require \"Tools.Textures.Icon\"\r\
local DeprecationWarnings = require \"UI.DeprecationWarnings\"\r\
local Strings = require \"Tools.Strings.Strings\"\r\
local System = require \"Tools.System\"\r\
local config = require \"Ellyb.Configuration\"\r\
local Unit = require \"Tools.Unit\"\r\
\r\
config.DEBUG_MODE = true\r\
\r\
print(ColorManager.createFromHexa(\"#00ACEE\"))\r\
local icon = Icon(\"8XP_VulperaFlute\")\r\
print(icon)\r\
\r\
local Cursor = require \"UI.Cursor\"\r\
Cursor.setIcon(icon, -20, 20)\r\
\r\
local newFunction = function() print(\"BfA\") end\r\
\r\
local deprecatedFunction = DeprecationWarnings.wrapFunction(newFunction, \"deprecatedFunction\", \"newFunction\")\r\
\r\
deprecatedFunction()\r\
\r\
print(Strings.clickInstruction(System:FormatKeyboardShortcut(System.MODIFIERS.CTRL, System.MODIFIERS.ALT, System.CLICKS.DOUBLE_CLICK), \"Win the game\"))\r\
\r\
print(Strings.formatBytes(1234567890))\r\
\r\
print(Strings.interpolate([[I love %b$s at least %a$s thousands]], {\r\
\9a = \"3\",\r\
\9b = \"Elza\"\r\
}))\r\
\r\
local player = Unit(\"player\")\r\
print(player:IsAttackable())\r\
\r\
local SlashCommandManager = require \"Tools.SlashCommands.SlashCommandsManager\"\r\
local SlashCommand = require \"Tools.SlashCommands.SlashCommand\"\r\
\r\
local test = SlashCommandManager(\"Ellyb\", \"Ellyb\", \"EB\")\r\
local toggleDebug = SlashCommand(\"debug\", function(enable)\r\
\9config.DEBUG_MODE = enable == \"true\"\r\
end, 'Pass \"true\" to enable debug mode, \"false\" to disable it.')\r\
\r\
test:Register(toggleDebug)\r\
\r\
local GameEvents = require \"Events.GameEvents\"\r\
local Promise = require \"Tools.Promises.Promise\"\r\
local Promises = require \"Tools.Promises.Promises\"\r\
\r\
local enterWorld = Promise()\r\
\r\
enterWorld:Success(function()\r\
\9print(\"Player entered world\")\r\
end)\r\
\r\
local unitFaction = Promise()\r\
\r\
unitFaction:Success(function()\r\
\9print(\"Unit has faction\")\r\
end)\r\
\r\
local all = Promises.all(enterWorld, unitFaction)\r\
\r\
all:Success(function()\r\
\9print(\"Everything is ready\")\r\
end)\r\
\r\
GameEvents.registerCallback(\"PLAYER_ENTERING_WORLD\", function()\r\
\9enterWorld:Resolve()\r\
end)\r\
\r\
GameEvents.registerCallback(\"UNIT_FACTION\", function()\r\
\9unitFaction:Resolve()\r\
end)\r\
\r\
local Threads = require \"Tools.Threads.Threads\"\r\
\r\
Threads.run(function(yield)\r\
\9for i = 0, 5 do\r\
\9\9print(i, GetTimePreciseSec())\r\
\9\9yield()\r\
\9end\r\
\9return\r\
end)\r\
\r\
Threads.run(function(yield)\r\
\9for i = 0, 5 do\r\
\9\9print(i, GetTimePreciseSec())\r\
\9\9yield()\r\
\9end\r\
\9return\r\
end)\r\
\r\
local Animator = require \"Tools.Animator\"\r\
\r\
local sampleAnimator = Animator()\r\
\r\
sampleAnimator:RunValue(0, 1, 2, print)\r\
\r\
local TooltipManager = require \"UI.Tooltips.TooltipManager\"\r\
\r\
enterWorld:Success(function()\r\
\9TooltipManager.getTooltip(PlayerFrame)\r\
\9\9\9\9  :SetTitle(\"CustomTooltip\")\r\
\9:AddLine(\"Custom tooltip made with Ellyb\")\r\
\r\
end )"
, '@'.."Main.lua" ) ) )( ... )

