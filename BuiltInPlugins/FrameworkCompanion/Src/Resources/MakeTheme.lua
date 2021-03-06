--[[
	Creates the theme for the plugin.
	Extends the default StudioFrameworkStyles, and also defines values specific
	to components created within this plugin and constant values shared across components.
]]

local Plugin = script.Parent.Parent.Parent

local ContextServices = require(Plugin.Packages.Framework).ContextServices
local Theme = ContextServices.Theme

local StudioUI = require(Plugin.Packages.Framework).StudioUI
local StudioFrameworkStyles = StudioUI.StudioFrameworkStyles

local Util = require(Plugin.Packages.Framework).Util
local StyleTable = Util.StyleTable
local Style = Util.Style
local StyleValue = Util.StyleValue

local function makeTheme()
	return Theme.new(function(theme, getColor)
		local studioFrameworkStyles = StudioFrameworkStyles.new(theme, getColor)

		local box = StyleTable.new("Box", function()
			local Item = Style.extend(studioFrameworkStyles.Box.Default, {
				Color = theme:GetColor("CategoryItem"),
			})

			return {
				__Item = Item,
			}
		end)

		local roundBox = StyleTable.new("RoundBox", function()
			local Default = Style.extend(studioFrameworkStyles.RoundBox.Default, {
				BorderTransparency = 1,
			})

			local Item = Style.extend(studioFrameworkStyles.RoundBox.Default, {
				Color = theme:GetColor("CategoryItem"),
				BorderTransparency = 1,
			})

			local Example = Style.extend(studioFrameworkStyles.RoundBox.Default, {
				Color = theme:GetColor("Mid"),
			})

			return {
				Default = Default,
				__Item = Item,
				__Example = Example,
			}
		end)

		local TypeTextColor = StyleValue.new("TypeTextColor", {
			Light = Color3.fromRGB(0, 116, 189),
			Dark = Color3.fromRGB(0, 162, 255),
		})

		local ScrollbarColor = StyleValue.new("ScrollbarColor", {
			Light = Color3.fromRGB(25, 25, 25),
			Dark = Color3.fromRGB(204, 204, 204),
		})

		return {
			Framework = StyleTable.extend(studioFrameworkStyles, {
				Box = box,
				RoundBox = roundBox,
			}),

			Scrollbar = {
				Thickness = 5,
				Transparency = 0.5,
				Color = ScrollbarColor:get(theme.Name),
				TopImage = "rbxasset://textures/StudioToolbox/ScrollBarTop.png",
				MidImage = "rbxasset://textures/StudioToolbox/ScrollBarMiddle.png",
				BottomImage = "rbxasset://textures/StudioToolbox/ScrollBarBottom.png",
			},

			Sizes = {
				Gutter = 200,
				Footer = 40,
				ButtonHeight = 30,
				ButtonWidth = 120,
				OuterPadding = 10,
				InnerPadding = 5,
			},

			Text = {
				Header = {
					Size = 20,
					Color = theme:GetColor("BrightText"),
				},
				Body = {
					Size = 16,
					Color = theme:GetColor("DimmedText"),
				},
				Button = {
					Size = 18,
					Color = theme:GetColor("MainText"),
					PrimaryColor = theme:GetColor("DialogMainButtonText"),
				},
				Type = {
					Size = 18,
					Color = TypeTextColor:get(theme.Name),
				},
			},
		}
	end)
end

return makeTheme
