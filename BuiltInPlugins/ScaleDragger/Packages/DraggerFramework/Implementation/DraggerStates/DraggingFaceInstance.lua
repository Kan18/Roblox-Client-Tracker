--[[
	When dragging over a Part, DraggingFaceInstance parents the instance onto
	the part and sets the instance's "Face" property to the closest Surface.
]]
local DraggerFramework = script.Parent.Parent.Parent

local DraggerStateType = require(DraggerFramework.Implementation.DraggerStateType)
local DragHelper = require(DraggerFramework.Utility.DragHelper)
local StandardCursor = require(DraggerFramework.Utility.StandardCursor)

local SURFACE_TO_FACE = {
	["TopSurface"] = "Top",
	["BottomSurface"] = "Bottom",
	["LeftSurface"] = "Left",
	["RightSurface"] = "Right",
	["FrontSurface"] = "Front",
	["BackSurface"] = "Back",
}

local DraggingFaceInstance = {}
DraggingFaceInstance.__index = DraggingFaceInstance

function DraggingFaceInstance.new(draggerToolModel, connectionToBreak)
	local self = setmetatable({
		_draggerToolModel = draggerToolModel,
		_connectionToBreak = connectionToBreak,
	}, DraggingFaceInstance)
	return self
end

function DraggingFaceInstance:enter()
end

function DraggingFaceInstance:leave()
	if self._connectionToBreak then
		self._connectionToBreak:Disconnect()
	end
end

function DraggingFaceInstance:render()
	self._draggerToolModel:setMouseCursor(StandardCursor.getClosedHand())
end

function DraggingFaceInstance:processSelectionChanged()
	self:_endDrag()
end

function DraggingFaceInstance:processMouseDown()
end

function DraggingFaceInstance:processViewChanged()
	local part, surface = DragHelper.getPartAndSurface({})
	local configurableFaces = self._draggerToolModel._derivedWorldState._instancesWithConfigurableFace

	if configurableFaces then
		for _, instance in pairs(configurableFaces) do
			if part then
				instance.Parent = part
			end
			if surface then
				instance.Face = SURFACE_TO_FACE[surface]
			end
		end
	end
end

function DraggingFaceInstance:processMouseUp()
	self:_endDrag()
end

function DraggingFaceInstance:processKeyDown(keyCode)
end

function DraggingFaceInstance:_endDrag()
	self._draggerToolModel:transitionToState({}, DraggerStateType.Ready)
end

return DraggingFaceInstance