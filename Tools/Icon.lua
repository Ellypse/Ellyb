---@type Ellyb
local Ellyb = Ellyb(...);

if Ellyb.Icon then
	return
end

---@class Icon : Object
local Icon, _private = Ellyb.Class("Icon")

local ICONS_FILE_PATH = [[Interface\ICONS\]]
local ICON_STRING_SEQUENCE = [[|T%s:%s|t]]

function Icon:initialize(iconTexture)
	_private[self] = {}

	if type(iconTexture) == "number" then
		self:SetByID(iconTexture)
	else
		if iconTexture:lower():find(ICONS_FILE_PATH:lower()) then
			self:SetByFilePath(iconTexture)
		else
			self:SetByFilename(iconTexture)
		end
	end
end


---@param iconID number
function Icon:SetByID(iconID)
	assert(Ellyb.Assertions.isType(iconID, "number", "iconID"))

	_private[self].id = iconID
end

function Icon:SetByFilename(iconFilename)
	assert(Ellyb.Assertions.isType(iconFilename, "string", "iconFilename"))

	self:SetByFilePath(ICONS_FILE_PATH .. iconFilename)
end

function Icon:SetByFilePath(filePath)
	assert(Ellyb.Assertions.isType(filePath, "string", "filePath"))

	_private[self].filePath = filePath

	-- Fetch the texture ID
	self:SetByID(GetFileIDFromPath(self:GetFilePath()))
end

function Icon:GetFilePath()
	return _private[self].filePath
end

---@return string|nil
function Icon:GetFilename()
	local filePath = self:GetFilePath()
	if filePath then
		return filePath:match("^.+\\(.+)$")
	end
end

function Icon:GetID()
	return _private[self].id
end

function Icon:IsCustomAddOnTexture()
	return self:GetID() < 0
end

function Icon:GenerateString(iconSize)
	assert(Ellyb.Assertions.isType(iconSize, "number", "iconSize"))

	return ICON_STRING_SEQUENCE:format(self:GetID(), iconSize)
end

Ellyb.Icon = Icon