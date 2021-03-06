local Framework = script.Parent.Parent.Parent

local UI = require(Framework.UI)
local Decoration = UI.Decoration

local Util = require(Framework.Util)
local Style = Util.Style
local StyleModifier = Util.StyleModifier

local Common = require(Framework.StudioUI.StudioFrameworkStyles.Common)

local UIFolderData = require(Framework.UI.UIFolderData)
local RoundBox = require(UIFolderData.RoundBox.style)

local FFlagDevFrameworkTextInputContainer = game:GetFastFlag("DevFrameworkTextInputContainer")

return function(theme, getColor)
	local common = Common(theme, getColor)
	local roundBox = RoundBox(theme, getColor)

	local function buttonStyle(image, hoverImage)
		return Style.new({
			Foreground = Decoration.Image,
			ForegroundStyle = {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.new(0.5, 0, 0.5, 0),
				Color = Color3.fromRGB(184, 184, 184),
				Image = image,
				Size = UDim2.new(0.6, 0, 0.6, 0),
				ScaleType = Enum.ScaleType.Fit
			},
			[StyleModifier.Hover] = {
				ForegroundStyle = {
					Image = hoverImage,
					Color = FFlagDevFrameworkTextInputContainer and theme:GetColor("DialogMainButton") or Color3.fromRGB(0, 162, 255)
				},
			},
		})
	end

	local Default = Style.extend(common.MainText, common.Border, {
		BackgroundColor = common.Background.Color,
		BackgroundStyle = roundBox.Default,
		Padding = FFlagDevFrameworkTextInputContainer and {
			Top = 5,
			Left = 10,
			Bottom = 5,
			Right = 10
		} or {
			Top = 0,
			Left = 10,
			Bottom = 0,
			Right = 10
		},
		[StyleModifier.Hover] = {
			BackgroundStyle = Style.extend(roundBox.Default, common.BorderHover)
		},
		Buttons = {
			Clear = buttonStyle("rbxasset://textures/StudioSharedUI/clear.png", "rbxasset://textures/StudioSharedUI/clear-hover.png"),
			Search = buttonStyle("rbxasset://textures/StudioSharedUI/search.png"),
		},
	})

	return {
		Default = Default,
	}
end
