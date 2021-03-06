--[[
	Definitions for special t-compatible checks for Framework lua objects.
	These functions can be used like any other t functions.
]]

local Framework = script.Parent.Parent.Parent
local StyleModifier = require(Framework.Util.StyleModifier)
local t = require(script.Parent.t)
local FrameworkTypes = {}

function FrameworkTypes.Component(value)
	local errMsg = "Component expected, got %s."
	if not t.table(value) or not t.callback(value.render) then
		return false, errMsg:format(type(value))
	end
	return true
end

function FrameworkTypes.ContextItem(value)
	local errMsg = "ContextItem expected, got %s."
	if not t.table(value) or not t.callback(value.createProvider) then
		return false, errMsg:format(type(value))
	end
	return true
end

function FrameworkTypes.Theme(value)
	local errMsg = "Theme expected, got %s."
	if not t.table(value) or not t.callback(value.getStyle) then
		return false, errMsg:format(type(value))
	end
	return true
end

function FrameworkTypes.Plugin(value)
	local errMsg = "Plugin expected, got %s."
	if not t.table(value) or not t.callback(value.get) then
		return false, errMsg:format(type(value))
	end
	return true
end

function FrameworkTypes.Mouse(value)
	local errMsg = "Mouse expected, got %s."
	if not t.table(value) or not t.callback(value.get) then
		return false, errMsg:format(type(value))
	end
	return true
end

function FrameworkTypes.Focus(value)
	local errMsg = "Focus expected, got %s."
	if not t.table(value) or not t.callback(value.getTarget) then
		return false, errMsg:format(type(value))
	end
	return true
end

function FrameworkTypes.Symbol(value)
	return t.userdata(value)
end

function FrameworkTypes.Signal(value)
	local errMsg = "Signal expected, got %s."
	if not t.table(value) or not t.table(value._listeners) then
		return false, errMsg:format(type(value))
	end
	return true
end

function FrameworkTypes.StyleModifier(value)
	local errMsg = "StyleModifier expected, got %s."
	for _, v in pairs(StyleModifier) do
		if value == v then
			return true
		end
	end
	return false, errMsg:format(type(value))
end

local stringOrTable = t.union(t.string, t.table)
function FrameworkTypes.Style(value)
	return stringOrTable(value)
end

local instanceOrTable = t.union(t.Instance, t.table)
function FrameworkTypes.Instance(value)
	return instanceOrTable(value)
end

return FrameworkTypes
