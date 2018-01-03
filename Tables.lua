---@type Ellyb
local _, Ellyb = ...;

-- WoW imports
local tinsert = table.insert;
local tremove = table.remove;
local type = type;
local tostring = tostring;
local pairs = pairs;
local wipe = wipe;
local next = next;
local format = string.format;
local assert = assert;
local setmetatable = setmetatable;
local _G = _G;

---@param Ellyb Ellyb @ Instance of the library
---@param env table @ Private environment
local function OnLoad(Ellyb, env)

	local Tables = {};
	Ellyb.Tables = Tables;

	setfenv(1, env);

	local DEBUG_DUMP_LEVEL_SIZE = "Level %s size: %s elements";
	local VALUE_TYPE_FORMAT = "< %s >";

	---@param value any @ A value of any type
	---@return string valueType @ Returns a formatted string of the type of a value
	local function dumpType(value)
		return DUMPCOLOR4:WrapTextInColorCode(format(VALUE_TYPE_FORMAT, type(value)));
	end

	---@param value any @ A value of any type
	---@return string value @ Returns a formatted string of the value and its type
	local function dumpValue(value)
		return DUMPCOLOR3:WrapTextInColorCode(tostring(value)) .. " " .. dumpType(value);
	end

	---@param key string @ A table key
	---@return string key @ Returns a formatted string of the key
	local function dumpKey(key)
		return DUMPCOLOR2:WrapTextInColorCode(key);
	end

	---@param table table @ The table we want to print
	---@param level number @ The current recursivity level, used for indentation
	---@param optional withCount boolean @ Indicates if we want the count information in the dump
	local function tableDump(table, level, withCount)
		local i = 0;
		local dumpIndent = "";

		for indent = 1, level, 1 do
			dumpIndent = dumpIndent .. "    ";
		end

		if type(table) == "table" then
			for key, value in pairs(table) do
				if type(value) == "table" then
					Logger:Debug(dumpIndent .. dumpKey(key) .. " = " .. OPENING_TABLE);
					tableDump(value, level + 1);
					Logger:Debug(dumpIndent .. CLOSING_TABLE);
				elseif type(value) == "function" then
					Logger:Debug(dumpIndent .. dumpKey(key) .. " = " .. dumpType(value));
				else
					Logger:Debug(dumpIndent .. dumpKey(key) .. " = " .. dumpValue(value));
				end
				i = i + 1;
			end
		end

		if withCount then
			Logger:Debug(dumpIndent .. DUMPCOLOR1:WrapTextInColorCode(format(DEBUG_DUMP_LEVEL_SIZE, level, i)));
		end
	end

	--- Print all table content (resursively)
	--- Debug purpose
	--- Better than /dump as it prints one message per line (avoid chat show limit)
	---@param table table @ The table we want to print
	---@param optional withCount boolean @ Indicates if we want the count information in the dump (defaults to false)
	function Tables.dump(table, withCount)
		Logger:Debug(DUMPCOLOR1:WrapTextInColorCode("Dump: " .. tostring(table)));
		if table then
			tableDump(table, 1, withCount);
		end
		Logger:Show();
	end

	---Make use of WoW's shiny new table inspector window to inspect a table programatically
	---@param table table @ The table we want to inspect in WoW's table inspector
	function Tables.inspect(table)
		_G.UIParentLoadAddOn("Blizzard_DebugTools");
		_G.DisplayTableInspectorWindow(table);
	end

	--- Recursively copy all content from a table to another one.
	--- Argument "destination" must be a non nil table reference.
	---@param destination table @ The table that will receive the new content
	---@param source table @ The table that contains the thing we want to put in the destination
	function Tables.copy(destination, source)
		assert(Ellyb.Assertions.isType(destination, "table", "destination"));
		assert(Ellyb.Assertions.isType(source, "table", "source"));

		for k, v in pairs(source) do
			if (type(v) == "table") then
				destination[k] = {};
				Tables.copy(destination[k], v);
			else
				destination[k] = v;
			end
		end
	end

	--- Return the table size.
	--- Less effective than #table but works for hash table as well (#hashtable don't).
	---@param table table
	---@param number tableSize @ The size of the table
	function Tables.size(table)
		assert(Ellyb.Assertions.isType(table, "table", "table"));
		-- We try to use #table first
		local tableSize = #table;
		if tableSize == 0 then
			-- And iterate over it if it didn't work
			for _, _ in pairs(table) do
				tableSize = tableSize + 1;
			end
		end
		return tableSize;
	end

	--- Remove an object from table
	--- Object is search with == operator.
	---@param table table @ The table in which we should remove the object
	---@param object any @ The object that should be removed
	---@return boolean hasBeenRemoved @ Return true if the object is found
	function Tables.remove(table, object)
		assert(Ellyb.Assertions.isType(table, "table", "table"));
		assert(Ellyb.Assertions.isNotNil(object, "object"));

		for index, value in pairs(table) do
			if value == object then
				tremove(table, index);
				return true;
			end
		end
		return false;
	end

	---Returns a new table that contains the keys of the given table
	---@param table table
	---@return table tableKeys @ A new table that contains the keys of the given table
	function Tables.keys(table)
		assert(Ellyb.Assertions.isType(table, "table", "table"));
		local keys = {};
		for key, _ in pairs(table) do
			tinsert(keys, key);
		end
		return keys;
	end

	---Check if a table is empty
	---@param table table @ A table to check
	---@return boolean isEmpty @ Returns true if the table is empty
	function Tables.isEmpty(table)
		assert(Ellyb.Assertions.isType(table, "table", "table"));
		local isEmpty = not next(table);
		return isEmpty;
	end

	-- Create a weak tables pool.
	local TABLE_POOL = setmetatable( {}, { __mode = "k" } );

	--- Return an already created table, or a new one if the pool is empty
	--- It is super important to release the table once you are finished using it!
	---@return table
	function Tables.getTempTable()
		local t = next(TABLE_POOL);
		if t then
			TABLE_POOL[t] = nil;
			return wipe(t);
		end
		return {};
	end

	--- Release a temp table.
	---@param table table
	function Tables.releaseTempTable(table)
		assert(Ellyb.Assertions.isType(table, "table", "table"));
		TABLE_POOL[table] = true;
	end

end

---@param Ellyb Ellyb @ Instance of the library
local function OnModulesLoaded(Ellyb, env)

	setfenv(1, env);

	Logger = Ellyb.Logger("Tables");

	DUMPCOLOR1 = Ellyb.Color("ffaa00");
	DUMPCOLOR2 = Ellyb.Color("00ff00");
	DUMPCOLOR3 = Ellyb.Color("ffff00");
	DUMPCOLOR4 = Ellyb.Color("ff9900");

	OPENING_TABLE = DUMPCOLOR3:WrapTextInColorCode("{");
	CLOSING_TABLE = DUMPCOLOR3:WrapTextInColorCode("}");
end

Ellyb.ModulesManagement:RegisterNewModule("Tables", OnLoad, OnModulesLoaded);