local Plugin = script.Parent.Parent.Parent
local Roact = require(Plugin.Roact)
local RoactStudioWidgets = Plugin.RoactStudioWidgets
local withLocalization = require(Plugin.Src.Consumers.withLocalization)

local ContextServices = require(Plugin.Framework.ContextServices)

local ConstantFonts = require(Plugin.Src.Util.ConstantFonts)
local StateInterfaceTheme = require(Plugin.Src.Util.StateInterfaceTheme)

local TitledFrame = require(RoactStudioWidgets.TitledFrame)

local TitleBar = Roact.Component:extend("ComponentTitleBar")

local FFlagStudioConvertGameSettingsToDevFramework = game:GetFastFlag("StudioConvertGameSettingsToDevFramework")

local calculateTextSize = nil

function TitleBar:render()
	local textSize = calculateTextSize(self.props.Text, ConstantFonts.TitleText.Size, ConstantFonts.TitleText.Type)

	local props = self.props
	local localization = props.Localization

	if FFlagStudioConvertGameSettingsToDevFramework then
		local children = {}
		if self.props.IsPlayerChoiceTitleStyle then
			children.PlayerChoiceLabel = Roact.createElement("TextLabel", {
				BackgroundTransparency = 1,
				BorderSizePixel = 0,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				TextColor3 = StateInterfaceTheme.getRadioButtonTextColor(self.props),
				Font = Enum.Font.SourceSans,
				TextSize = 22,
				Text = localization:getText("General", "AvatarOverridePrompt"),
			})
		end

		return Roact.createElement(TitledFrame, {
			Title = self.props.Text,
			MaxHeight = textSize.Y,
			LayoutOrder = self.props.LayoutOrder or 1,
			Font = ConstantFonts.TitleText.Type
		}, children)
	else
		return withLocalization(function(localized)
			local children = {}
			if self.props.IsPlayerChoiceTitleStyle then
				children.PlayerChoiceLabel = Roact.createElement("TextLabel", {
					BackgroundTransparency = 1,
					BorderSizePixel = 0,
					TextXAlignment = Enum.TextXAlignment.Left,
					TextYAlignment = Enum.TextYAlignment.Top,
					TextColor3 = StateInterfaceTheme.getRadioButtonTextColor(self.props),
					Font = Enum.Font.SourceSans,
					TextSize = 22,
					Text = localized.Morpher.AvatarOverrides.Prompt,
				})
			end

			return Roact.createElement(TitledFrame, {
				Title = self.props.Text,
				MaxHeight = textSize.Y,
				LayoutOrder = self.props.LayoutOrder or 1,
				Font = ConstantFonts.TitleText.Type
			}, children)
		end)
	end
end

if FFlagStudioConvertGameSettingsToDevFramework then
	ContextServices.mapToProps(TitleBar, {
		Localization = ContextServices.Localization,
	})
end

calculateTextSize = function(text, textSize, font)
	local hugeFrameSizeNoTextWrapping = Vector2.new(5000, 5000)
	return game:GetService('TextService'):GetTextSize(text, textSize, font, hugeFrameSizeNoTextWrapping)
end

return TitleBar