local Class = require "Libraries.middleclass"
local private = require "Internals.PrivateStorage"
local System = require "Tools.System"

---@class Ellyb_Unit : MiddleClass
local Unit = Class("Unit")

---Constructor
---@param unitID string @ A unit ID ("player", "mouseover", "target", "PlayerName-ServerName")
function Unit:initialize(unitID)
	private[self] = {}
	private[self].rawUnitID = unitID
end

---@return string GUID @ Return the GUID of the ID
function Unit:GetGUID()
	return UnitGUID(private[self].rawUnitID) or UNKNOWNOBJECT
end

---@return string unitType @ The type of the unit, extracted from its GUID ("Player", "Creature", "Pet", "Vehicle", etc.)
function Unit:GetType()
	local GUID = self:GetGUID()
	local unitType = strsplit("-", GUID)
	return unitType
end

function Unit:GetNPCID()
	local _, _, _, _, _, npcID = strsplit("-", self:GetGUID())
	return npcID
end

---@return string unitID @ Returns the unit ID in the format PlayerName-ServerName
function Unit:GetUnitID()
	local playerName, realm = UnitFullName(private[self].rawUnitID)
	if not playerName or playerName:len() == 0 or playerName == UNKNOWNOBJECT then
		return nil
	end
	if not realm then
		local _, playerRealmName = UnitFullName("player")
		realm = playerRealmName
	end
	if not realm then
		return playerName
	else
		return playerName .. "-" .. realm
	end
end

---@return boolean unitIsPlayer @ Returns true if the unit is a player, false if it is an NPC
function Unit:IsPlayer()
	return UnitIsPlayer(private[self].rawUnitID)
end

--- Check if the unit exists (useful for mouseover or target unit)
---@return boolean unitExists @ Returns true if the unit exists
function Unit:Exists()
	return UnitExists(private[self].rawUnitID)
end

--- Check if the player can attack the unit
---@return boolean unitIsAttackable @ Returns true if the player can attack the unit
function Unit:IsAttackable()
	return UnitCanAttack("player", private[self].rawUnitID)
end

--- Check if the unit can be mounted (has a multi seated mount, is in the same group/raid, has seats available, etc.)
--- Will always return false on Classic client, as no unit are mountable in patch 1.13
--- @return boolean Returns true if the unit can be mounted
function Unit:IsMountable()
	if System:IsClassic() then
		return false
	end
	return UnitVehicleSeatCount(private[self].rawUnitID) and UnitVehicleSeatCount(private[self].rawUnitID) > 0 and (UnitInParty(private[self].rawUnitID) or UnitInRaid(private[self].rawUnitID))
end

return Unit