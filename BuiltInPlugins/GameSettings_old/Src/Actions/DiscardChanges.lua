-- Discards all user-made changes to settings.

local Plugin = script.Parent.Parent.Parent
local Action = require(Plugin.Src.Actions.Action)

return Action(script.Name, function()
	return {}
end)