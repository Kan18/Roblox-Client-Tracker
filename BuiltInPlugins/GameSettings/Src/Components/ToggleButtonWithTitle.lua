--[[
	ToggleButtonWithTitle Displays a TitledFrame with ToggleButton

	Props:
		string Description: An optional secondary title to place above this section.
		string Title: The title to place to the left of this section.
		callback OnClick: The function that will be called when this button is clicked to turn on and off.

	Optional Props:
		boolean Disabled: Whether or not this button can be clicked.
		number LayoutOrder: The layout order of this component.
		boolean Selected: whether the button should be on or off.
]]

local Plugin = script.Parent.Parent.Parent
local Roact = require(Plugin.Roact)
local Cryo = require(Plugin.Cryo)

local Framework = Plugin.Framework
local ContextServices = require(Framework.ContextServices)
local TitledFrame = require(Framework.StudioUI.TitledFrame)
local ToggleButton = require(Framework.UI.ToggleButton)
local FitTextLabel = require(Framework.Util).FitFrame.FitTextLabel

local ToggleButtonWithTitle = Roact.PureComponent:extend("ToggleButtonWithTitle")

function ToggleButtonWithTitle:init()
	self.state = {
		descriptionWidth = 0,
	}

	self.descriptionRef = Roact.createRef()

	self.onResize = function()
		local descriptionWidthContainer = self.descriptionRef.current
		if not descriptionWidthContainer then
			return
		end

		self:setState({
			descriptionWidth = descriptionWidthContainer.AbsoluteSize.X
		})
	end
end

function ToggleButtonWithTitle:render()
	local props = self.props
	local theme = props.Theme:get("Plugin")

	local descriptionWidth = self.state.descriptionWidth

	local description = props.Description
	local disabled = props.Disabled
	local layoutOrder = props.LayoutOrder
	local selected = props.Selected
	local title = props.Title
	local onClick = props.OnClick

	return Roact.createElement(TitledFrame, {
		Title = title,
		LayoutOrder = layoutOrder,
	}, {
		ToggleButton = Roact.createElement(ToggleButton, {
			Disabled = disabled,
			Selected = selected,
			LayoutOrder = 1,
			OnClick = onClick,
			Size = theme.settingsPage.toggleButtonSize,
		}),

		Description = props.Description and Roact.createElement(FitTextLabel, Cryo.Dictionary.join(theme.fontStyle.Subtext, {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			TextTransparency = props.Disabled and 0.5 or 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			Text = description,
			TextWrapped = true,
			width = UDim.new(0, descriptionWidth),
		})),

		DescriptionWidth = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			LayoutOrder = 3,
			Size = UDim2.new(1,0,0,0),
			[Roact.Ref] = self.descriptionRef,
			[Roact.Change.AbsoluteSize] = self.onResize,
		}),
	})
end

ContextServices.mapToProps(ToggleButtonWithTitle, {
	Theme = ContextServices.Theme,
})

return ToggleButtonWithTitle
