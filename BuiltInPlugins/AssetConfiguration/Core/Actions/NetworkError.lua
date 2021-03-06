local Plugin = script.Parent.Parent.Parent

local Libs = Plugin.Libs
local Util = require(Libs.Framework.Util)
local Action = Util.Action

return Action(script.Name, function(response, networkErrorAction)

	-- if response is a string, wrap it in a table
	if type(response) == "string" then
		response = {
			responseBody = response
		}
	end

	return {
		response = response,
		networkErrorAction = networkErrorAction
	}
end)
