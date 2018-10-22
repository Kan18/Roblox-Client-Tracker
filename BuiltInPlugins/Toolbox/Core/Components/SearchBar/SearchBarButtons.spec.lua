return function()
	local Plugin = script.Parent.Parent.Parent.Parent

	local CorePackages = game:GetService("CorePackages")
	local Roact = require(CorePackages.Roact)

	local MockWrapper = require(Plugin.Core.Util.MockWrapper)

	local SearchBarButtons = require(Plugin.Core.Components.SearchBar.SearchBarButtons)

	it("should create and destroy without errors", function()
		local element = Roact.createElement(MockWrapper, {}, {
			SearchBarButtons = Roact.createElement(SearchBarButtons)
		})
		local instance = Roact.mount(element)
		Roact.unmount(instance)
	end)
end