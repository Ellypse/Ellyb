local FrameSetters = require "Enums.WidgetSetters.Frame"
local Tables = require "Tools.Tables"

---@type Subject Hack for IntelliJ IDEA code completion
local t = ""

---@class CinematicModelSetters: FrameSetters
local CinematicModelSetters = {
	InitializeCamera = t,
	SetAnimOffset = t,
	SetCreatureData = t,
	SetFacingLeft = t,
	SetFadeTimes = t,
	SetHeightFactor = t,
	SetJumpInfo = t,
	SetPanDistance = t,
	SetSpellVisualKit = t,
	SetTargetDistance = t,
	StartPan = t,


	-- TODO: These are "Model" setters, should be extracted
	ReplaceIconTexture = t,
	SetCamera = t,
	SetFacing = t,
	SetFogColor = t,
	SetFogFar = t,
	SetFogNear = t,
	SetGlow = t,
	SetLight = t,
	SetModel = t,
	SetModelByFileID = t,
	SetModelScale = t,
	SetPosition = t,
	SetSequence = t,
	SetSequenceTime = t,
	SetAnimation = t,
	FreezeAnimation = t,
	SetUnit = t,
}

Tables.copy(CinematicModelSetters, FrameSetters)

return CinematicModelSetters