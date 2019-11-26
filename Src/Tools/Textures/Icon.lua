local Class = require "Libraries.middleclass"
local Texture = require "Tools.Textures.Texture"

---@class Ellyb_Icon : Ellyb_Texture
local Icon = Class("Icon", Texture)

local ICONS_FILE_PATH = [[Interface\ICONS\]]

---@param icon string|number
---@param size number|nil
function Icon:initialize(icon, size)
	if type(icon) == "string" then
		if not icon:lower():find("interface") then
			icon = ICONS_FILE_PATH .. icon
		end
	end
	Texture.initialize(self, icon, size, size)
end

function Icon:SetTextureByIconName(iconName)
	if not iconName:lower():find(ICONS_FILE_PATH:lower()) then
		iconName = ICONS_FILE_PATH .. iconName
	end
	self:SetTextureByID(iconName)
end

return Icon