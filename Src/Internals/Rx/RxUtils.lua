local Rx = require "Libraries/RxLua/rx"

local RxUtils = {}

local subjectsCache = {}

---@param widgetScriptName string The script name that will generate the subject
---@param widget UIObject
---@return fun():Observable
function RxUtils.createSubjectFromWidgetScript(widgetScriptName, widget)
	return function()
		if not subjectsCache[widget] then
			subjectsCache[widget] = {}
		end
		if not subjectsCache[widget][widgetScriptName] then
			local subject = Rx.Subject.create()
			widget:HookScript(widgetScriptName, function(...)
				subject:onNext(...)
			end)
			subjectsCache[widget][widgetScriptName] = subject
		end
		return subjectsCache[widget][widgetScriptName]
	end
end

return RxUtils