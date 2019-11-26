---@param class MiddleClass
local function MixinWidget(frameType, class)
	local widgetMethods
	local metatable = {}

	metatable.__index = function(_, key)
		return class[key] or widgetMethods[key] or nil
	end

	class.static.allocate = function(self)
		local frame = CreateFrame(frameType)
		if not widgetMethods then
			widgetMethods = getmetatable(frame).__index;
		end
		frame.class = self
		setmetatable(frame, metatable)
		return frame
	end

	class.static.subclassed = function(self, subclass)
		subclass.static.allocate = function()
			local frame = CreateFrame(frameType)
			if not widgetMethods then
				widgetMethods = getmetatable(frame).__index;
			end
			frame.class = subclass
			setmetatable(frame, {
				__index = function(_, key)
					return subclass[key] or class[key] or widgetMethods[key] or nil
				end
			})
			return frame
		end
	end
end

return MixinWidget