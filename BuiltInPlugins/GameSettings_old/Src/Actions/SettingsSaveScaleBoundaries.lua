local Plugin = script.Parent.Parent.Parent
local Action = require(Plugin.Src.Actions.Action)

return Action(script.Name, function(avatarRules)
	return {
		rulesData = avatarRules
	}
end)