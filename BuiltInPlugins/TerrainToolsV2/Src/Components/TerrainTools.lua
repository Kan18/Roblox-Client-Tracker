local Plugin = script.Parent.Parent.Parent

local Framework = Plugin.Packages.Framework
local Roact = require(Plugin.Packages.Roact)

local ContextServices = require(Framework.ContextServices)

local StudioUI = require(Framework.StudioUI)
local DockWidget = StudioUI.DockWidget
local PluginToolbar = StudioUI.PluginToolbar
local PluginButton = StudioUI.PluginButton

local EDITOR_META_NAME = "Editor"
local TOOLBAR_NAME = "TerrainToolsLuaToolbarName"

local MIN_WIDGET_SIZE = Vector2.new(270, 256)
local INITIAL_WIDGET_SIZE = Vector2.new(300, 600)

local TerrainTools = Roact.PureComponent:extend("TerrainTools")

function TerrainTools:init()
	self.state = {
		enabled = true,
	}

	self.toggleEnabled = function()
		self:setState(function(state)
			return {
				enabled = not state.enabled,
			}
		end)
	end

	self.onClose = function()
		self:setState({
			enabled = false,
		})
	end

	self.onRestore = function(enabled)
		self:setState({
			enabled = enabled,
		})
	end

	self.onFocused = function()
		self.props.pluginActivationController:restoreSelectedTool()
	end

	self.renderButtons = function(toolbar)
		local enabled = self.state.enabled

		return {
			Toggle = Roact.createElement(PluginButton, {
				Toolbar = toolbar,
				Active = enabled,

				Title = EDITOR_META_NAME,
				Tooltip = self.props.localization:get():getText("Main", "PluginButtonEditorTooltip"),
				Icon = "rbxasset://textures/TerrainTools/icon_terrain_big.png",

				OnClick = self.toggleEnabled,
			})
		}
	end
end

function TerrainTools:didUpdate(prevProps, prevState)
	-- Widget open/close analytics
	if prevState.enabled ~= self.state.enabled then
		self.props.analytics:report("toggleWidget")
		self.props.analytics:report(self.state.enabled and "openWidget" or "closeWidget")
	end

	-- Pause the tool when hiding the dock widget
	if prevState.enabled ~= self.state.enabled and not self.state.enabled then
		self.props.pluginActivationController:pauseActivatedTool()
	end
end

function TerrainTools:render()
	local enabled = self.state.enabled

	local plugin = self.props.plugin
	local mouse = self.props.mouse
	local store = self.props.store

	local theme = self.props.theme
	local localization = self.props.localization
	local analytics = self.props.analytics

	local terrain = self.props.terrain

	local pluginActivationController = self.props.pluginActivationController
	local terrainImporter = self.props.terrainImporter
	local terrainGeneration = self.props.terrainGeneration
	local seaLevel = self.props.seaLevel
	local partConverter = self.props.partConverter

	return ContextServices.provide({
		plugin,
		mouse,
		store,
		theme,
		localization,
		analytics,
		terrain,
		pluginActivationController,
		terrainImporter,
		terrainGeneration,
		seaLevel,
		-- partConverter will be nil if FFlagTerrainToolsConvertPartTool is false
		partConverter,
	}, {
		Toolbar = Roact.createElement(PluginToolbar, {
			Title = TOOLBAR_NAME,
			RenderButtons = self.renderButtons,
		}),

		TerrainTools = Roact.createElement(DockWidget, {
			Title = localization:get():getText("Main", "Title"),
			Enabled = enabled,

			ZIndexBehavior = Enum.ZIndexBehavior.Global,
			InitialDockState = Enum.InitialDockState.Left,
			Size = INITIAL_WIDGET_SIZE,
			MinSize = MIN_WIDGET_SIZE,

			OnClose = self.onClose,

			ShouldRestore = true,
			OnWidgetRestored = self.onRestore,
			OnWidgetFocused = self.onFocused,
		}, enabled and {
			-- TODO: DEVTOOLS-4270 port the components to dev framework
		} or nil),
	})
end

return TerrainTools
