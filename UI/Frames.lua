---@type Ellyb
local Ellyb = Ellyb:GetInstance(...);

if Ellyb_MovableFrameMixin and _G.Ellyb:GetVersionNumber() >= Ellyb:GetVersionNumber() then
	return;
end

---@class Ellyb_MovableFrameMixin : Frame
Ellyb_MovableFrameMixin = {};

function Ellyb_MovableFrameMixin:OnLoad()
	self:RegisterForDrag("LeftButton");
end

function Ellyb_MovableFrameMixin:OnDragStart()
	self:StartMoving();
end

function Ellyb_MovableFrameMixin:OnDragStop()
	self:StopMovingOrSizing();
end