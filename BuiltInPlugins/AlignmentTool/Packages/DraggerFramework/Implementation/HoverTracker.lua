
local StudioService = game:GetService("StudioService")

local Framework = script.Parent.Parent
local SelectionHelper = require(Framework.Utility.SelectionHelper)
local SelectionWrapper = require(Framework.Utility.SelectionWrapper)

local getFFlagLuaDraggerHandleScale = require(Framework.Flags.getFFlagLuaDraggerHandleScale)
local getFFlagRetainHoverPart = require(Framework.Flags.getFFlagRetainHoverPart)
local getFFlagStudioServiceHoverInstance = require(Framework.Flags.getFFlagStudioServiceHoverInstance)

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

function HoverTracker:update(derivedWorldState)
    local oldHoverSelectable = self._hoverSelectable

    -- Hover parts in the workspace
	local hit, distanceToHover, at = SelectionHelper.getMouseTarget(SelectionWrapper:Get())
    self._hoverInstance = hit
    self._hoverSelectable = SelectionHelper.getSelectable(hit)
    self._hoverPosition = at
    self._hoverHandleId = nil
    self._hoverDistance = distanceToHover

    -- Possibly hover a handle instead if we have a handle closer that the part
    local mouseRay = SelectionHelper.getMouseRay()
    local hoverHandleId, hoverHandleDistance
    if getFFlagLuaDraggerHandleScale() then
        hoverHandleId, hoverHandleDistance = self:_getHitHandle(mouseRay)
    else
        hoverHandleId, hoverHandleDistance =
            self:_getHitHandle(mouseRay, derivedWorldState:getHandleScale())
    end
	if hoverHandleId then
		if not self._hoverSelectable or hoverHandleDistance < distanceToHover then
			self._hoverHandleId = hoverHandleId
            self._hoverDistance = hoverHandleDistance
            if not getFFlagRetainHoverPart() then
                self._hoverInstance = nil
                self._hoverSelectable = nil
            end
            self._hoverPosition = nil
		end
    end

    if getFFlagStudioServiceHoverInstance() then
        if getFFlagRetainHoverPart() then
            -- If you're hovering a handle, you're trying to start a drag, so
            -- we don't want the additional visual clutter of any hoverInstance
            -- related information getting in the way in that case.
            if self._hoverHandleId then
                StudioService.HoverInstance = nil
            else
                StudioService.HoverInstance = self._hoverInstance
            end
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

function HoverTracker:clearHover()
    self:_disconnectSignals()
    self._hoverInstance = nil
    self._hoverSelectable = nil
    self._hoverPosition = nil
    self._hoverHandleId = nil
    self._hoverDistance = nil
    if getFFlagStudioServiceHoverInstance() then
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

if getFFlagLuaDraggerHandleScale() then
    function HoverTracker:_getHitHandle(mouseRay)
        if self._toolImplementation and self._toolImplementation.hitTest then
            return self._toolImplementation:hitTest(mouseRay)
        else
            return nil
        end
    end
else
    function HoverTracker:_getHitHandle(mouseRay, handleScale)
        if self._toolImplementation and self._toolImplementation.hitTest then
            return self._toolImplementation:hitTest(mouseRay, handleScale)
        else
            return nil
        end
    end
end

return HoverTracker