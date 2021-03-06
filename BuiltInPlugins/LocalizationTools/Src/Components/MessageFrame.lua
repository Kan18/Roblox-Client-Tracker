--[[
	The message fram at the bottom of plugin window
]]

local Plugin = script.Parent.Parent.Parent
local Roact = require(Plugin.Packages.Roact)
local RoactRodux = require(Plugin.Packages.RoactRodux)
local ContextServices = require(Plugin.Packages.Framework.ContextServices)

local MessageFrame = Roact.PureComponent:extend("MessageFrame")

function MessageFrame:render()
	local props = self.props
	local theme = props.Theme:get("MessageFrame")
	local message = props.Message

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, 0, 0, theme.Height),
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.new(0, 0, 1, 0),
		BackgroundTransparency = 0,
		BackgroundColor3 = theme.BackgroundColor,
		BorderColor3 = theme.BorderColor,
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingLeft = UDim.new(0, theme.Padding),
		}),
		MessageTextLabel = Roact.createElement("TextLabel", {
			Size = UDim2.new(1, 0, 1, 0),
			BackgroundTransparency = 1,
			BorderSizePixel = 0,
			TextColor3 = theme.TextColor,
			Text = message,
			TextXAlignment = Enum.TextXAlignment.Left,
		})
	})
end

ContextServices.mapToProps(MessageFrame, {
	Theme = ContextServices.Theme,
})

local function mapStateToProps(state, _)
	return {
		Message = state.Message,
	}
end

return RoactRodux.connect(mapStateToProps)(MessageFrame)
