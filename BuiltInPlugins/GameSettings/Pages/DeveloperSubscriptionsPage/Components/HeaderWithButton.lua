--[[
	Header shown at the top of a page, but with a button on the right margin

	Props:
		string Title = The text to display for this header
		bool Active = Whether or not this button can be clicked.
		string ButtonText = The text to display in this Button.
		function OnClicked = The function that will be called when this button is clicked.
		variant Value = Data that can be accessed from the OnClicked callback.
		table Style = {
			ButtonColor,
			ButtonColor_Hover,
			ButtonColor_Disabled,
			TextColor,
			TextColor_Disabled,
			BorderColor,
		}
]]

local Plugin = script.Parent.Parent.Parent
local Roact = require(Plugin.Roact)
local Cryo = require(Plugin.Cryo)
local UILibrary = require(Plugin.UILibrary)
local DEPRECATED_Constants = require(Plugin.Src.Util.DEPRECATED_Constants)
local withTheme = require(Plugin.Src.Consumers.withTheme)

local RoundTextButton = UILibrary.Component.RoundTextButton

local function HeaderWithButton(props)
	local title = props.Title
	local active = props.Active
	local buttonText = props.ButtonText
	local onClicked = props.OnClicked
	local value = props.Value
	local style = props.Style

	return withTheme(function(theme)
		return Roact.createElement("TextLabel", Cryo.Dictionary.join(theme.fontStyle.Title, {
			Size = UDim2.new(1, 0, 0, DEPRECATED_Constants.HEADER_HEIGHT),
			Text = title,
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Bottom,
			LayoutOrder = props.LayoutOrder or 1,
		}), {
			Padding = Roact.createElement("UIPadding", {
				PaddingRight = UDim.new(0, 12)
			}),

			Layout = Roact.createElement("UIListLayout", {
				HorizontalAlignment = Enum.HorizontalAlignment.Right,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
			}),

			Button = Roact.createElement(RoundTextButton, Cryo.Dictionary.join(theme.fontStyle.Normal, {
				Active = active,
				Name = buttonText,
				OnClicked = onClicked,
				Value = value,
				Style = style,
			})),
		})
	end)
end

return HeaderWithButton