local CorePackages = game:GetService("CorePackages")

local Cryo = require(CorePackages.Packages.Cryo)
local Roact = require(CorePackages.Packages.Roact)
local RoactRodux = require(CorePackages.Packages.RoactRodux)
local t = require(CorePackages.Packages.t)
local RemoveMessage = require(script.Parent.Parent.Actions.RemoveMessage)
local ChatBubble = require(script.Parent.ChatBubble)
local Types = require(script.Parent.Parent.Types)

local BubbleChatList = Roact.Component:extend("BubbleChatList")

BubbleChatList.validateProps = t.strictInterface({
	userId = t.string,
	isVisible = t.optional(t.boolean),
	theme = t.optional(t.string),

	-- RoactRodux
	chatSettings = t.table,
	removeMessage = t.callback,
	messages = t.map(t.string, Types.IMessage),
	messageIds = t.array(t.string),
})

BubbleChatList.defaultProps = {
	theme = "Light", -- themes are currently not fully supported
}

function BubbleChatList:getLastMessages(numElements)
	local endIndex = #self.props.messageIds
	-- Need to add 1, because if endIndex = 10, and numElements = 3, this will
	-- give the indices 7, 8, 9, 10. We only want 8, 9, and 10.
	local startIndex = endIndex - numElements + 1
	return Cryo.List.getRange(self.props.messageIds, startIndex, endIndex)
end

function BubbleChatList:render()
	local chatSettings = self.props.chatSettings
	local children = {}
	local messageIds = self:getLastMessages(chatSettings.MaxBubbles)

	children.Layout = Roact.createElement("UIListLayout", {
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Bottom,
		Padding = UDim.new(0, 8),
	})

	-- This padding pushes up the UI a bit so the first message's
	-- caret shows up.
	children.CaretPadding = Roact.createElement("UIPadding", {
		PaddingBottom = UDim.new(0, 8),
	})

	for index, messageId in ipairs(messageIds) do
		local message = self.props.messages[messageId]

		-- Ignore the message if it's expired
		if os.time() - message.timestamp > chatSettings.BubbleDuration then
			continue
		end

		children["Bubble" .. message.id] = Roact.createElement(ChatBubble, {
			LayoutOrder = index,
			message = message,
			isMostRecent = index == #messageIds,
			theme = self.props.theme,
			timeout = chatSettings.BubbleDuration,
			onFadeOut = function()
				self.props.removeMessage(message)
			end
		})
	end

	return Roact.createElement("Frame", {
		Visible = self.props.isVisible,
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
	}, children)
end

local function mapStateToProps(state, props)
	return {
		chatSettings = state.chatSettings,
		messages = state.messages,
		messageIds = state.userMessages[props.userId] or {},
	}
end

local function mapDispatchToProps(dispatch)
	return {
		removeMessage = function(message)
			dispatch(RemoveMessage(message))
		end
	}
end

return RoactRodux.connect(mapStateToProps, mapDispatchToProps)(BubbleChatList)
