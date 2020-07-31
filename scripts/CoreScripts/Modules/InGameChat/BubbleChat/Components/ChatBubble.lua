local CorePackages = game:GetService("CorePackages")
local TextService = game:GetService("TextService")

local Otter = require(CorePackages.Packages.Otter)
local Roact = require(CorePackages.Packages.Roact)
local t = require(CorePackages.Packages.t)
local ChatSettings = require(script.Parent.Parent.ChatSettings)
local Constants = require(script.Parent.Parent.Constants)
local Types = require(script.Parent.Parent.Types)
local Themes = require(script.Parent.Parent.Themes)

local SPRING_CONFIG = {
	dampingRatio = 1,
	frequency = 2,
}

local ChatBubble = Roact.Component:extend("ChatBubble")

ChatBubble.validateProps = t.strictInterface({
	message = Types.IMessage,

	onFadeOut = t.optional(t.callback),
	timeout = t.optional(t.number),
	maxWidth = t.optional(t.number),
	LayoutOrder = t.optional(t.number),
	isMostRecent = t.optional(t.boolean),
	theme = t.optional(t.string),
	TextSize = t.optional(t.number),
	Font = t.optional(t.enum(Enum.Font)),
})

ChatBubble.defaultProps = {
	theme = "Light",
	timeout = ChatSettings.BubbleDuration,
	TextSize = 16,
	Font = Enum.Font.Gotham,
	maxWidth = 300,
	isMostRecent = true,
}

function ChatBubble:init(initialProps)
	self.state = {
		isVisible = true,
	}

	self.width, self.updateWidth = Roact.createBinding(0)
	self.widthMotor = Otter.createSingleMotor(0)
	self.widthMotor:onStep(self.updateWidth)

	self.height, self.updateHeight = Roact.createBinding(0)
	self.heightMotor = Otter.createSingleMotor(0)
	self.heightMotor:onStep(self.updateHeight)

	self.transparency, self.updateTransparency = Roact.createBinding(1)
	self.transparencyMotor = Otter.createSingleMotor(1)
	self.transparencyMotor:onStep(self.updateTransparency)

	self.size = Roact.joinBindings({ self.width, self.height }):map(function(sizes)
		return UDim2.fromOffset(sizes[1], sizes[2])
	end)
end

function ChatBubble:getTextBounds()
	local padding = Vector2.new(Constants.UI_PADDING * 4, Constants.UI_PADDING * 2)

	local bounds = TextService:GetTextSize(
		self.props.message.text,
		self.props.TextSize,
		self.props.Font,
		Vector2.new(self.props.maxWidth, 10000)
	)

	return bounds + padding
end

function ChatBubble:render()
	if not self.state.isVisible then
		return nil
	end

	local bounds = self:getTextBounds()

	return Roact.createElement("Frame", {
		LayoutOrder = self.props.LayoutOrder,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = self.size,
		Position = UDim2.fromScale(1, 0.5),
		Transparency = 1,
	}, {
		Layout = Roact.createElement("UIListLayout", {
			SortOrder = Enum.SortOrder.LayoutOrder,
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
		}),

		Frame = Roact.createElement("Frame", {
			LayoutOrder = 1,
			BackgroundColor3 = Themes.BackgroundColor[self.props.theme],
			AnchorPoint = Vector2.new(0.5, 0),
			Size = UDim2.fromScale(1, 1),
			BorderSizePixel = 0,
			Position = UDim2.new(0.5, 0, 0, 0),
			BackgroundTransparency = self.transparency,
			ClipsDescendants = true,
		}, {
			UICorner = Roact.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12),
			}),

			Text = Roact.createElement("TextLabel", {
				Text = self.props.message.text,
				Size = UDim2.new(0, bounds.X, 0, bounds.Y),
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				BackgroundTransparency = 1,
				Font = Enum.Font.GothamSemibold,
				TextColor3 = Themes.FontColor[self.props.theme],
				TextSize = self.props.TextSize,
				TextTransparency = self.transparency,
				TextWrapped = true,
			}, {
				Padding = Roact.createElement("UIPadding", {
					PaddingTop = UDim.new(0, Constants.UI_PADDING),
					PaddingRight = UDim.new(0, Constants.UI_PADDING),
					PaddingBottom = UDim.new(0, Constants.UI_PADDING),
					PaddingLeft = UDim.new(0, Constants.UI_PADDING),
				})
			})
		}),

		Carat = self.props.isMostRecent and Roact.createElement("ImageLabel", {
			LayoutOrder = 2,
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(9, 6),
			Image = "rbxasset://textures/ui/InGameChat/Caret.png",
			ImageColor3 = Themes.BackgroundColor[self.props.theme],
			ImageTransparency = self.transparency,
		}),
	})
end

function ChatBubble:didMount()
	self.isMounted = true
	local bounds = self:getTextBounds()
	local timeout = self.props.timeout - (os.time() - self.props.message.timestamp)

	-- Check to see if lifetime of chat bubble expired
	if timeout <= 0 then
		if self.props.onFadeOut then
			self.props.onFadeOut()
		end
		return
	end

	if os.time() - self.props.message.timestamp == 0 then -- Transition for a recently messaged bubble
		self.updateWidth(bounds.X)
		self.heightMotor:setGoal(Otter.spring(bounds.Y, SPRING_CONFIG))
	else -- Transition between distant bubble and chat bubbles
		self.heightMotor:setGoal(Otter.spring(bounds.Y, SPRING_CONFIG))
		self.widthMotor:setGoal(Otter.spring(bounds.X, SPRING_CONFIG))
	end

	self.transparencyMotor:setGoal(Otter.spring(Constants.BUBBLE_BASE_TRANSPARENCY, SPRING_CONFIG))

	coroutine.wrap(function()
		wait(timeout)
		if self.isMounted then
			self.transparencyMotor:onComplete(function()
				if self.props.onFadeOut then
					self.props.onFadeOut()
				end
			end)
			self.transparencyMotor:setGoal(Otter.spring(1, SPRING_CONFIG))
		end
	end)()
end

function ChatBubble:willUnmount()
	self.isMounted = false
	self.transparencyMotor:destroy()
	self.heightMotor:destroy()
	self.widthMotor:destroy()
end

return ChatBubble
