local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local Rx = require "Libraries/RxLua/rx"
local Tables = require "Tools.Tables"
local ScriptObjectScripts = require "Enums.WidgetsScripts.ScriptObject"
local Visibility = require "Enums.Visibility"

---@class CustomBindings
local customBindings = {
	visibility = Rx.Subject.create()
}

---@generic T
---@generic U
---@param self UIObject
---@param validScripts T
---@param validSetters U
---@return CustomBindings|T|U
local function CreateBindings(self, validScripts, validSetters)
	private[self].subjectsCache = {}

	local rx = setmetatable(customBindings, {
		--- This __index metatable method will allow for lazy creation of the subject when something
		--- is trying to access a key named after a valid script of this widget
		__index = function(rx, key)

			-- Scripts observables
			if tContains(rx.__validScripts, key) then
				-- Create a new subject
				local subject = Rx.Subject.create()
				-- Hook the script to pass its values to the onNext of the subject
				self:HookScript(key, function(...)
					subject:onNext(...)
				end)
				-- Set the property on the object, so it's accessible directly
				-- and this lazy loader doesn't get called again for this script.
				rawset(rx, key, subject)
				return subject

			-- Setters bindings
			elseif tContains(rx.__validSetters, key) then
				local method = self[key]
				if not method or not type(method) == "function" then
					return false
				end
				-- Create subject out of widget script name
				local subject = Rx.Subject.create()
				-- Subscribe to the subject and call the method with the values
				subject:subscribe(function(...)
					method(self, ...)
				end)
				rawset(rx, key, subject)
				return subject
			end
			return false
		end
	})

	rx.__validScripts = Tables.copy(Tables.keys(ScriptObjectScripts), Tables.keys(validScripts))
	rx.__validSetters = Tables.keys(validSetters)

	-- Custom visibility
	rx.visibility:subscribe(function(visibility)
		if visibility == Visibility.VISIBLE and self.Hide then
			self:Hide()
		elseif visibility == Visibility.HIDDEN and self.Show then
			self:Show()
		end
	end)

	return rx
end

return CreateBindings