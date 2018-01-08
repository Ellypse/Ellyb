---@type Ellyb
local _, Ellyb = ...;

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