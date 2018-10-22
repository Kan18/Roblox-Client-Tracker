--[[
	Footer shown at the bottom of the Game Settings widget.
	Contains the Save and Cancel buttons.

	Props:
		bool SaveActive = Whether or not saving is currently allowed.
			This will enable the Save button if true.
]]

local FOOTER_GRADIENT_SIZE = 10
local FOOTER_GRADIENT_TRANSPARENCY = 0.9
local GRADIENT_IMAGE = "rbxasset://textures/gradient.png"
local GRADIENT_RECT_SIZE = Vector2.new(512, 256)

local Plugin = script.Parent.Parent.Parent
local Roact = require(Plugin.Roact)
local RoactRodux = require(Plugin.RoactRodux)
local Promise = require(Plugin.Promise)

local withTheme = require(Plugin.Src.Consumers.withTheme)
local Constants = require(Plugin.Src.Util.Constants)
local isEmpty = require(Plugin.Src.Util.isEmpty)
local getSettingsImpl = require(Plugin.Src.Consumers.getSettingsImpl)

local ButtonBar = require(Plugin.Src.Components.ButtonBar)

local SaveChanges = require(Plugin.Src.Thunks.SaveChanges)
local CurrentStatus = require(Plugin.Src.Util.CurrentStatus)

local Footer = Roact.PureComponent:extend("Footer")

function Footer:render()
	return withTheme(function(theme)
		local interface = getSettingsImpl(self)
		local saveActive = self.props.SaveActive
		local cancelActive = self.props.CancelActive

		return Roact.createElement("Frame", {
			BackgroundColor3 = theme.backgroundColor,
			BorderSizePixel = 0,
			Size = UDim2.new(1, 0, 0, Constants.FOOTER_HEIGHT),
			AnchorPoint = Vector2.new(0, 1),
			Position = UDim2.new(0, 0, 1, 0),
			ZIndex = 2,
		}, {
			Gradient = Roact.createElement("ImageLabel", {
				Size = UDim2.new(1, 0, 0, FOOTER_GRADIENT_SIZE),
				AnchorPoint = Vector2.new(0, 1),
				Image = GRADIENT_IMAGE,
				ImageRectSize = GRADIENT_RECT_SIZE,
				BorderSizePixel = 0,
				BackgroundTransparency = 1,
				ImageColor3 = theme.footer.gradient,
				ImageTransparency = FOOTER_GRADIENT_TRANSPARENCY,
				ZIndex = 1,
			}),

			SaveSettings = Roact.createElement(ButtonBar, {
				Buttons = {
					{Name = "Cancel", Active = cancelActive, Value = false},
					{Name = "Save", Default = true, Active = saveActive, Value = true},
				},
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				ButtonClicked = function(userPressedSave)
					self.props.ButtonClicked(userPressedSave, interface):await()
					self.props.OnClose(userPressedSave)
				end,
			}),
		})
	end)
end

Footer = RoactRodux.connect(
	function(state, props)
		if not state then return end
		return {
			SaveActive = not isEmpty(state.Settings.Changed)
				and state.Status == CurrentStatus.Open
				and isEmpty(state.Settings.Errors),
			CancelActive = state.Status == CurrentStatus.Open
		}
	end,
	function(dispatch)
		return {
			ButtonClicked = function(userPressedSave, interface)
				if userPressedSave then
					return dispatch(SaveChanges(interface))
				else
					return Promise.resolve()
				end
			end,
		}
	end
)(Footer)

return Footer