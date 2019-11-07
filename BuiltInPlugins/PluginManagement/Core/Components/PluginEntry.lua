local Plugin = script.Parent.Parent.Parent
local Roact = require(Plugin.Libs.Roact)
local RoactRodux = require(Plugin.Libs.RoactRodux)
local Constants = require(Plugin.Core.Util.Constants)
local Urls = require(Plugin.Core.Util.Urls)
local UILibrary = require(Plugin.Libs.UILibrary)
local UpdateStatus = require(Plugin.Core.Util.UpdateStatus)

local StudioService = game:getService("StudioService")
local ContentProvider = game:getService("ContentProvider")
local GuiService = game:getService("GuiService")
local HttpService = game:getService("HttpService")

local ContextServices = require(Plugin.Libs.Framework.ContextServices)

local SetPluginEnabledState = require(Plugin.Core.Thunks.SetPluginEnabledState)
local UpdatePlugin = require(Plugin.Core.Thunks.UpdatePlugin)
local Button = UILibrary.Component.Button
local LoadingIndicator = UILibrary.Component.LoadingIndicator

local PluginEntry = Roact.Component:extend("PluginEntry")

function PluginEntry:init()
	self.state = {
		showSuccessMessage = false,
	}

	self.onPluginEnabled = function()
		local props = self.props
		props.onPluginSetEnabledState(props.data, true)
	end

	self.onPluginDisabled = function()
		local props = self.props
		self.props.onPluginSetEnabledState(props.data, false)
	end

	self.onShowMoreActivated = function(localization)
		-- Since we cannot access localization through props, it must be passed in.
		-- This eliminates any benefit of creating this instance function over inlining the function.
		-- This can be updated once Context2 is in place.
		return function()
			local plugin = self.props.plugin
			local assetId = self.props.data.assetId
			local menu = plugin:CreatePluginMenu("PluginEntryMenu")

			local detailsAction = menu:AddNewAction("Details", localization:getText("EntrySeeMore", "DetailsButton"))
			detailsAction.Triggered:connect(function()
				local baseUrl = ContentProvider.BaseUrl
				local targetUrl = string.format("%s/library/%s/asset", baseUrl, HttpService:urlEncode(assetId))
				GuiService:OpenBrowserWindow(targetUrl)
			end)

			menu:AddSeparator()

			local removeAction = menu:AddNewAction("Remove", localization:getText("EntrySeeMore", "RemoveButton"))
			removeAction.Triggered:connect(function()
				StudioService:UninstallPlugin(self.props.data.assetId)
				wait()
				self.props.onPluginUninstalled()
			end)

			menu:ShowAsync()
			menu:Destroy()
		end
	end

	self.updatePlugin = function()
		local props = self.props
		props.UpdatePlugin(props.data)
	end
end

function PluginEntry.getDerivedStateFromProps(nextProps, lastState)
	if nextProps.data.status == UpdateStatus.Success then
		return {
			showSuccessMessage = true,
		}
	end

	if not nextProps.isUpdated then
		return {
			showSuccessMessage = false,
		}
	end

	return nil
end

function PluginEntry:render()
	local props = self.props
	local state = self.state
	local data = props.data

	local localization = props.Localization
	local theme = props.Theme:get("Plugin")

	local layoutOrder = props.LayoutOrder

	local isUpdated = props.isUpdated
	local updateStatus = data.status

	local assetId = data.assetId
	local enabled = data.enabled

	local name = data.name or ""
	local description = data.description or ""
	local creator = data.creator or ""

	local thumbnailUrl = Urls.constructAssetThumbnailUrl(assetId)

	local showUpdateButton = not isUpdated and updateStatus ~= UpdateStatus.Updating
	local buttonPosition = UDim2.new(1,Constants.PLUGIN_HORIZONTAL_PADDING*-3 - Constants.PLUGIN_ENABLE_WIDTH
		- Constants.PLUGIN_CONTEXT_WIDTH,.5,0)

	return Roact.createElement("Frame", {
		Size = UDim2.new(1, Constants.SCROLLBAR_WIDTH_ADJUSTMENT, 0, Constants.PLUGIN_ENTRY_HEIGHT),
		BackgroundColor3 = theme.BackgroundColor,
		BorderSizePixel = 0,
		LayoutOrder = layoutOrder,
	}, {
		Padding = Roact.createElement("UIPadding", {
			PaddingTop = UDim.new(0, 12),
			PaddingBottom = UDim.new(0, 12),
		}),

		Thumbnail = Roact.createElement("ImageLabel", {
			Size = UDim2.new(0,Constants.THUMBNAIL_SIZE, 0, Constants.THUMBNAIL_SIZE),
			Position = UDim2.new(0,Constants.PLUGIN_HORIZONTAL_PADDING,0,Constants.PLUGIN_VERTICAL_PADDING),
			Image = thumbnailUrl,
			BackgroundTransparency = 1,
		}),

		Contents = Roact.createElement("Frame", {
			BackgroundTransparency = 1,
			Position = UDim2.new(0, Constants.THUMBNAIL_SIZE + Constants.PLUGIN_HORIZONTAL_PADDING * 2, 0, 0),
			Size = UDim2.new(0.5, -Constants.THUMBNAIL_SIZE - Constants.PLUGIN_HORIZONTAL_PADDING, 1, 0),
		}, {
			Layout = Roact.createElement("UIListLayout", {
				SortOrder = Enum.SortOrder.LayoutOrder,
				FillDirection = Enum.FillDirection.Vertical,
				Padding = UDim.new(0, 2),
			}),

			Name = Roact.createElement("TextLabel", {
				LayoutOrder = 0,
				TextWrapped = true,
				TextSize = 22,
				Size = UDim2.new(1, 0, 0, 20),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = name,
				TextColor3 = theme.TextColor,
				Font = Enum.Font.SourceSansSemibold,
			}),

			Creator = Roact.createElement("TextButton", {
				LayoutOrder = 1,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 0, 16),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				Text = creator,
				Font = Enum.Font.SourceSans,
				TextColor3 = theme.LinkColor,
				TextSize = 16,
				BorderSizePixel = 1,
				--TODO: make this clickable link if it's not Roblox
			}),

			Description = Roact.createElement("TextLabel", {
				LayoutOrder = 2,
				TextWrapped = true,
				Size = UDim2.new(1, 0, 1, -42 - Constants.PLUGIN_VERTICAL_PADDING * 2),
				BackgroundTransparency = 1,
				TextXAlignment = Enum.TextXAlignment.Left,
				TextYAlignment = Enum.TextYAlignment.Top,
				Text = description,
				TextColor3 = theme.TextColor,
				TextTruncate = Enum.TextTruncate.AtEnd,
				Font = Enum.Font.SourceSansLight,
				TextSize = 16,
			}),
		}),

		UpdateButton = showUpdateButton and Roact.createElement(Button, {
			AnchorPoint = Vector2.new(1, 0.5),
			Size = UDim2.new(0, Constants.HEADER_UPDATE_WIDTH, 0, Constants.HEADER_BUTTON_SIZE),
			Position = buttonPosition,
			Style = "Default",
			OnClick = self.updatePlugin,

			RenderContents = function()
				return {
					Label = Roact.createElement("TextLabel", {
						Size = UDim2.new(1, 0, 1, 0),
						Text = localization:getText("Entry", "UpdateButton"),
						TextColor3 = theme.TextColor,
						Font = Enum.Font.SourceSans,
						TextSize = 18,
						BackgroundTransparency = 1,
					}),

					DateLabel = updateStatus ~= UpdateStatus.Error and Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 14),
						Position = UDim2.new(0, 0, 1, 3),
						TextSize = 14,
						Font = Enum.Font.SourceSans,
						TextColor3 = theme.TextColor,
						TextTransparency = 0.6,
						Text = localization:getText("Entry", "LastUpdatedDate", {
							date = data.updated,
						}),
					}),

					ErrorLabel = updateStatus == UpdateStatus.Error and Roact.createElement("TextLabel", {
						BackgroundTransparency = 1,
						Size = UDim2.new(1, 0, 0, 14),
						Position = UDim2.new(0, 0, 1, 3),
						TextSize = 14,
						Font = Enum.Font.SourceSans,
						TextColor3 = theme.ErrorColor,
						Text = localization:getText("Entry", "UpdateError"),
					}),
				}
			end,
		}),

		ProgressIndicator = not isUpdated and updateStatus == UpdateStatus.Updating
			and Roact.createElement(LoadingIndicator, {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = buttonPosition,
		}),

		SuccessLabel = isUpdated and state.showSuccessMessage
			and Roact.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, 14),
			AnchorPoint = Vector2.new(1, 0.5),
			Position = buttonPosition,
			TextSize = 14,
			Font = Enum.Font.SourceSans,
			TextColor3 = theme.Green,
			TextXAlignment = Enum.TextXAlignment.Right,
			Text = localization:getText("Entry", "UpdateSuccess"),
		}),

		-- TODO: Refactor this into UILibrary ToggleButton
		EnableButton = not enabled and Roact.createElement("ImageButton", {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, Constants.PLUGIN_ENABLE_WIDTH, 0, 24),
			Position = UDim2.new(1,Constants.PLUGIN_HORIZONTAL_PADDING*-2 - Constants.PLUGIN_ENABLE_WIDTH
				- Constants.PLUGIN_CONTEXT_WIDTH,.5,0),
			Image = theme.Toggle.Off,
			BackgroundTransparency = 1,
			[Roact.Event.Activated] = self.onPluginEnabled,
		}),

		DisableButton = enabled and Roact.createElement("ImageButton", {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, Constants.PLUGIN_ENABLE_WIDTH, 0, 24),
			Position = UDim2.new(1,Constants.PLUGIN_HORIZONTAL_PADDING*-2 - Constants.PLUGIN_ENABLE_WIDTH
				- Constants.PLUGIN_CONTEXT_WIDTH,.5,0),
			Image = theme.Toggle.On,
			BackgroundTransparency = 1,

			[Roact.Event.Activated] = self.onPluginDisabled,
		}),

		ShowMoreButton = Roact.createElement(Button, {
			AnchorPoint = Vector2.new(0, 0.5),
			Size = UDim2.new(0, 28, 0, 28),
			Position = UDim2.new(1,Constants.PLUGIN_HORIZONTAL_PADDING*-1 - Constants.PLUGIN_CONTEXT_WIDTH,.5,0),
			Style = "Default",
			OnClick = self.onShowMoreActivated(localization),

			RenderContents = function()
				return {
					Dots = Roact.createElement("TextLabel", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Position = UDim2.new(0.5, 0, 0.5, -4),
						Size = UDim2.new(0, 16, 0, 16),

						Text = "...",
						TextColor3 = theme.TextColor,
						Font = Enum.Font.SourceSansBold,
						TextSize = 18,
						BackgroundTransparency = 1,
					})
				}
			end,
		}),
	})
end

ContextServices.mapToProps(PluginEntry, {
	Localization = ContextServices.Localization,
	Theme = ContextServices.Theme,
})

local function mapDispatchToProps(dispatch)
	return {
		onPluginSetEnabledState = function(plugin, enabled)
			dispatch(SetPluginEnabledState(plugin, enabled))
		end,

		UpdatePlugin = function(plugin)
			dispatch(UpdatePlugin(plugin))
		end,
	}
end

return RoactRodux.connect(nil, mapDispatchToProps)(PluginEntry)