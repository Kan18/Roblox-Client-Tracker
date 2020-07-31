--[[
	Handles the display of non-blocking Toast notifications
	for warnings or other short messages.
]]

local Plugin = script.Parent.Parent.Parent
local Rodux = require(Plugin.Rodux)
local Cryo = require(Plugin.Cryo)
local GetFFlagEnforceMaxAnimLength = require(Plugin.LuaFlags.GetFFlagEnforceMaxAnimLength)

local initialState = {
	QuantizeWarning = false,
	Saved = false,
	Loaded = false,
}

if GetFFlagEnforceMaxAnimLength() then
	initialState["ClippedWarning"] = false
end

return Rodux.createReducer(initialState, {
	SetNotification = function(state, action)
		assert(state[action.notification] ~= nil,
			"Notification " .. action.notification .. " does not exist in Notifications.")

		local newState = Cryo.Dictionary.join(state, {
			[action.notification] = action.value,
		})

		if action.notification == "Loaded" and action.value then
			newState.Saved = false
		end

		return newState
	end,
})