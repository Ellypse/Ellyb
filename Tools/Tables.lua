---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

-- WoW imports
local tinsert = table.insert;
local tremove = table.remove;
local type = type;
local pairs = pairs;
local wipe = wipe;
local next = next;
local assert = assert;
local setmetatable = setmetatable;

local Tables = {};
Ellyb.Tables = Tables;

-- Ellyb imports
local isType = Ellyb.Assertions.isType;
local isNotNil = Ellyb.Assertions.isNotNil;

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
	assert(isType(destination, "table", "destination"));
	assert(isType(source, "table", "source"));

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
	assert(isType(table, "table", "table"));
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
	assert(isType(table, "table", "table"));
	assert(isNotNil(object, "object"));

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
	assert(isType(table, "table", "table"));
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
	assert(isType(table, "table", "table"));
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
	assert(isType(table, "table", "table"));
	TABLE_POOL[table] = true;
end