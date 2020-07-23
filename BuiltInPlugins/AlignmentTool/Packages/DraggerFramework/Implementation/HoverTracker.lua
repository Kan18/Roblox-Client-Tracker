
local Workspace = game:GetService("Workspace")
local StudioService = game:GetService("StudioService")

local DraggerFramework = script.Parent.Parent
local SelectionHelper = require(DraggerFramework.Utility.SelectionHelper)
local SelectionWrapper = require(DraggerFramework.Utility.SelectionWrapper)

local getFFlagDraggerRefactor = require(DraggerFramework.Flags.getFFlagDraggerRefactor)

if getFFlagDraggerRefactor() then
	StudioService = nil
end

local HoverTracker = {}
HoverTracker.__index = HoverTracker

function HoverTracker.new(toolImplementation, onHoverExternallyChangedFunction)
	return setmetatable({
		_toolImplementation = toolImplementation,
		_hoverHandleId = nil,
		_hoverInstance = nil,
		_onHoverChanged = onHoverExternallyChangedFunction,
	}, HoverTracker)
end

function HoverTracker:update(derivedWorldState, draggerContext)
	local oldHoverSelectable = self._hoverSelectable

	-- Hover parts in the workspace
	local hit, distanceToHover, at
	if getFFlagDraggerRefactor() then
		hit, distanceToHover, at = self:_getMouseTarget(draggerContext)
		self._hoverInstance = hit
		self._hoverSelectable = SelectionHelper.getSelectable(hit, draggerContext:isAltKeyDown())
	else
		hit, distanceToHover, at = SelectionHelper.getMouseTarget(SelectionWrapper:Get())
		self._hoverInstance = hit
		self._hoverSelectable = SelectionHelper.getSelectable(hit)
	end
	self._hoverPosition = at
	self._hoverHandleId = nil
	self._hoverDistance = distanceToHover

	-- Possibly hover a handle instead if we have a handle closer that the part
	local mouseRay
	if getFFlagDraggerRefactor() then
		mouseRay = draggerContext:getMouseRay()
	else
		mouseRay = SelectionHelper.getMouseRay()
	end
	local hoverHandleId, hoverHandleDistance = self:_getHitHandle(mouseRay)
	if hoverHandleId then
		if not self._hoverSelectable or hoverHandleDistance < distanceToHover then
			self._hoverHandleId = hoverHandleId
			self._hoverDistance = hoverHandleDistance
			self._hoverPosition = nil
		end
	end

	-- If you're hovering a handle, you're trying to start a drag, so
	-- we don't want the additional visual clutter of any hoverInstance
	-- related information getting in the way in that case.
	if getFFlagDraggerRefactor() then
		if self._hoverHandleId then
			draggerContext:setHoverInstance(nil)
		else
			draggerContext:setHoverInstance(self._hoverInstance)
		end
	else
		if self._hoverHandleId then
			StudioService.HoverInstance = nil
		else
			StudioService.HoverInstance = self._hoverInstance
		end
	end

	if self._onHoverChanged and self._hoverSelectable ~= oldHoverSelectable then
		self:_disconnectSignals()
		local thisHoverSelectable = self._hoverSelectable
		if thisHoverSelectable then
			self._hoverInstanceEscapedConnection =
				thisHoverSelectable.AncestryChanged:Connect(function(child, newParent)
					-- Waiting on the parent changing here is done to give
					-- the engine a chance to update the physics state.
					-- Engine physics state updates happen on hierarchy
					-- changed events too, so they may not have happened
					-- yet when this event is fired.
					-- If we wait for the associated parent property changed
					-- signal to fire, then we can be sure the physics state
					-- updates have already ocurred.
					child:GetPropertyChangedSignal("Parent"):Wait()
					self._onHoverChanged()
				end)
			self._hoverInstanceContentsChangedConnection =
				thisHoverSelectable.DescendantRemoving:Connect(function(descendant)
					-- Ignore other junk like temporary movement welds being
					-- removed from the hover selectable.
					-- For example if we end the drag over one of the
					-- dragged parts this would otherwise pick up the temp
					-- movement weld being removed from under it.
					if descendant:IsA("BasePart") or descendant:IsA("Attachment") then
						descendant:GetPropertyChangedSignal("Parent"):Wait()
						self._onHoverChanged()
					end
				end)
		end
	end
end

function HoverTracker:_disconnectSignals()
	if self._hoverInstanceEscapedConnection then
		self._hoverInstanceEscapedConnection:Disconnect()
		self._hoverInstanceEscapedConnection = nil
	end
	if self._hoverInstanceContentsChangedConnection then
		self._hoverInstanceContentsChangedConnection:Disconnect()
		self._hoverInstanceContentsChangedConnection = nil
	end
end

function HoverTracker:clearHover(draggerContext)
	self:_disconnectSignals()
	self._hoverInstance = nil
	self._hoverSelectable = nil
	self._hoverPosition = nil
	self._hoverHandleId = nil
	self._hoverDistance = nil
	if getFFlagDraggerRefactor() then
		draggerContext:setHoverInstance(nil)
	else
		StudioService.HoverInstance = nil
	end
end

--[[
	Returns: The Id of the hovered handle, the distance to that handle
]]
function HoverTracker:getHoverHandleId()
	return self._hoverHandleId, self._hoverDistance
end

--[[
	Returns: The hovered instance, and the world position of the hit on it
]]
function HoverTracker:getHoverInstance()
	return self._hoverInstance, self._hoverPosition
end

function HoverTracker:getHoverSelectable()
	return self._hoverSelectable
end

function HoverTracker:_getHitHandle(mouseRay)
	if self._toolImplementation and self._toolImplementation.hitTest then
		return self._toolImplementation:hitTest(mouseRay)
	else
		return nil
	end
end

function HoverTracker:_getMouseTarget(draggerContext)
	assert(getFFlagDraggerRefactor())
	local mouseRay = draggerContext:getMouseRay()
	local hitObject, hitPosition = Workspace:FindPartOnRay(mouseRay)

	-- Selection favoring: If there is a selected object and a non-selected
	-- object almost exactly coincident underneath the mouse, then we should
	-- favor the selected one, even if due to floating point error the non
	-- selected one comes out slightly closer.
	-- Without this case, if you duplicate objects and try to drag them, you
	-- may end up dragging only one of the objects because you clicked on the
	-- old non-selected copy, as opposed to the selected one you meant to.
	if hitObject then
		local selectedObjects = draggerContext:getSelectionWrapper():Get()
		local hitSelectedObject, hitSelectedPosition
			= Workspace:FindPartOnRayWithWhitelist(mouseRay, selectedObjects)
		if hitSelectedObject and hitSelectedPosition:FuzzyEq(hitPosition) then
			hitObject = hitSelectedObject
			hitPosition = hitSelectedPosition
		end
	end

	local hitDistance = (mouseRay.Origin - hitPosition).Magnitude

	local hitResult = draggerContext:gizmoRaycast(
		mouseRay.Origin, mouseRay.Direction, RaycastParams.new())
	if hitResult and
		(draggerContext:shouldDrawConstraintsOnTop() or (hitResult.Distance < hitDistance)) then
		hitPosition = hitResult.Position
		hitDistance = hitResult.Distance
		hitObject = hitResult.Instance
	end
	return hitObject, hitDistance, hitPosition
end

return HoverTracker