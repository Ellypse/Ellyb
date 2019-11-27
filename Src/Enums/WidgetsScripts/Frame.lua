local ScriptObjectScripts = require "Enums.WidgetsScripts.ScriptObject"
local Tables = require "Tools.Tables"

---@type Observable Hack for IntelliJ IDEA code completion
local t = ""

---@class FrameScripts: ScriptObjectScripts
local FrameScripts = {
	--- Run when a frame attribute is changed.
	OnAttributeChanged = t,

	--- Called whenever a character is typed by the user while the frame is focused.
	---@param text string The character that was typed
	OnChar = t,

	--- Run when the frame is disabled
	OnDisable = t,

	--- Run when the mouse is dragged starting in the frame. In order for a drag action to begin, the mouse button must be pressed down within the frame and moved more than several (~10) pixels in any direction without being released.
	OnDragStart = t,

	--- Run when the mouse button is released after a drag started in the frame
	OnDragStop = t,

	--- Run when the frame is enabled
	OnEnable = t,

	--- The OnEnter handler is called when the user mouse pointer enters the frame.
	--- A typical use for this event is to pop up a help tooltip, or a menu with option choices (for instance on a minimap button). The opposite of OnEnter is OnLeave. If you decide to show something in OnEnter you should hide it again in the OnLeave event handler.
	---@param motion boolean true, if the mouse pointer has been moved; false, if the mouse pointer was not moved (e.g. frame:Show() and the mouse pointer is over the frame)
	OnEnter = t,

	--- Run whenever an event fires for which the frame is registered.
	OnEvent = t,

	--- The OnHide event is called when a shown frame is about to be hidden or when a hidden frame is about to become visible on screen. Hiding / Showing a frame that is already hidden / visible does not invoke the OnHide event.
	OnHide = t,

	--- Run when the mouse clicks a hyperlink on the FontInstance object.
	OnHyperlinkClick = t,

	--- Run when the mouse moves over a hyperlink on the FontInstance object.
	OnHyperlinkEnter = t,

	--- Run when the mouse moves away from a hyperlink on the FontInstance object
	OnHyperlinkLeave = t,

	--- The OnKeyDown handler is called when the user first hits a key and this frame is registered for keyboard events with Frame:EnableKeyboard. See also OnKeyUp.
	--- It should also be noted that the frameStrata has to be at least DIALOG or higher for this to work.
	---@param key string Returned as a string representing the key that was pressed. For example, "W" or "A" or "S" or "D" (main keyboard keys) or "UP" or "LEFT" or "DOWN" or "RIGHT" (arrow keys) or "DELETE" or other extended keys or "SHIFT" or other modifier keys.
	OnKeyDown = t,

	--- The OnKeyUp handler is called when the user releases a key and this frame is registered for keyboard events with Frame:EnableKeyboard. See also OnKeyDown.
	--- It should also be noted that the frameStrata has to be at least DIALOG or higher for this to work.
	---@param key string returned as a string representing the key that was released. For example, "W" or "A" or "S" or "D" (main keyboard keys) or "UP" or "LEFT" or "DOWN" or "RIGHT" (arrow keys) or "DELETE" or other extended keys or "SHIFT" or other modifier keys.
	OnKeyUp = t,

	--- The OnLeave handler is called when the user mouse pointer leaves the frame.
	--- A typical use for this event is to hide information which was popped up in the OnEnter handler of a frame. In combination with its opposite event handler OnEnter it can be used for instance to implement help tooltips for frames or frame widgets.
	OnLeave = t,

	--- Invoked when mouse button is pressed on the widget.
	---@param button string The mouse button pressed. Can be any of the following: LeftButton, RightButton, MiddleButton, Button4, Button5
	OnMouseDown = t,

	--- Run when the mouse button is released following a mouse down action in the frame.
	---@param button string The mouse button pressed. Can be any of the following: LeftButton, RightButton, MiddleButton, Button4, Button5
	OnMouseUp = t,

	--- Called when mousewheel is spun while the mouse pointer is over the frame. If a frame does not have an OnMouseWheel handler, the event is passed on to underlying frames.
	---@param delta number Number indicating the direction the wheel is spinning 1 for spinning up -1 for spinning down (i.e. you will want to use (-delta) for offsetting the position in a list view)
	OnMouseWheel = t,

	--- Called whenever the user has released the cursor over the frame while dragging something.
	OnReceiveDrag = t,

	--- The OnShow event is called when a hidden frame is about to become visible on screen. Showing a frame that is already visible does not invoke the Onshow() event.
	OnShow = t,

	--- Run when a frame's size changes.
	OnSizeChanged = t,
}

Tables.copy(FrameScripts, ScriptObjectScripts)

return FrameScripts