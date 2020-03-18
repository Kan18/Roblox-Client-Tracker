local Plugin = script.Parent.Parent.Parent
local Rodux = require(Plugin.Packages.Rodux)

local Screen = require(script.parent.Screen)

local Screens = require(Plugin.Src.Util.Screens)

local SetScreen = require(Plugin.Src.Actions.SetScreen)
local SetToPreviousScreen = require(Plugin.Src.Actions.SetToPreviousScreen)
local SetToNextScreen = require(Plugin.Src.Actions.SetToNextScreen)

local testImmutability = require(Plugin.Src.TestHelpers.testImmutability)

return function()
	it("should return a table with the correct members", function()
		local state = Screen(nil, {})

		expect(typeof(state)).to.equal("table")
		expect(state.currentScreen).to.be.ok()
		expect(state.previousScreens).to.be.ok()
		expect(state.nextScreens).to.be.ok()
	end)

	describe("SetScreen action", function()
		it("should validate its inputs", function()
			expect(function()
				SetScreen(nil)
			end).to.throw()

			expect(function()
				SetScreen({ key = "value", })
			end).to.throw()

			expect(function()
				SetScreen("some screen")
			end).to.throw()
		end)

		it("should preserve immutability", function()
			local immutabilityPreserved = testImmutability(Screen, SetScreen(Screens.MAIN))
			expect(immutabilityPreserved).to.equal(true)
		end)

		it("should set screen", function()
			local r = Rodux.Store.new(Screen)
			local state = r:getState()
			expect(state.currentScreen).to.equal(Screens.MAIN)
			expect(#state.previousScreens).to.equal(0)
			expect(#state.nextScreens).to.equal(0)

			for k,v in pairs(Screens) do
				state = Screen(state, SetScreen(v))
				expect(state.currentScreen).to.equal(v)
			end
		end)
	end)

	describe("SetPreviousScreenAction", function()
		it("should have one previous screen from setting screen", function()
			local r = Rodux.Store.new(Screen)
			local state = r:getState()
			state = Screen(state, SetScreen(Screens.IMAGES))
			expect(#state.previousScreens).to.equal(1)
			expect(state.previousScreens[1]).to.equal(Screens.MAIN)
		end)

		it("should set previous screen", function()
			local r = Rodux.Store.new(Screen)
			local state = r:getState()
			state = Screen(state, SetScreen(Screens.IMAGES))
			state = Screen(state, SetToPreviousScreen())
			expect(state.currentScreen).to.equal(Screens.MAIN)
			expect(#state.nextScreens).to.equal(1)
			expect(state.nextScreens[1]).to.equal(Screens.IMAGES)
			expect(#state.previousScreens).to.equal(0)
		end)

		it("should set previous screens", function()
			local r = Rodux.Store.new(Screen)
			local state = r:getState()
			state = Screen(state, SetScreen(Screens.IMAGES))
			state = Screen(state, SetScreen(Screens.MESHES))
			state = Screen(state, SetToPreviousScreen())
			state = Screen(state, SetToPreviousScreen())

			expect(state.currentScreen).to.equal(Screens.MAIN)
			expect(#state.nextScreens).to.equal(2)
			expect(state.nextScreens[1]).to.equal(Screens.MESHES)
			expect(state.nextScreens[2]).to.equal(Screens.IMAGES)
			expect(#state.previousScreens).to.equal(0)
		end)
	end)

	describe("SetNextScreenAction", function()
		it("should be clear after setting screen", function()
			local r = Rodux.Store.new(Screen)
			local state = r:getState()
			state = Screen(state, SetScreen(Screens.IMAGES))
			state = Screen(state, SetToPreviousScreen())
			state = Screen(state, SetScreen(Screens.MESHES))
			expect(state.currentScreen).to.equal(Screens.MESHES)
			expect(#state.previousScreens).to.equal(1)
			expect(state.previousScreens[1]).to.equal(Screens.MAIN)
			expect(#state.nextScreens).to.equal(0)
		end)

		it("should set next screen", function()
			local r = Rodux.Store.new(Screen)
			local state = r:getState()
			state = Screen(state, SetScreen(Screens.IMAGES))
			state = Screen(state, SetToPreviousScreen())
			state = Screen(state, SetToNextScreen())
			expect(state.currentScreen).to.equal(Screens.IMAGES)
			expect(#state.previousScreens).to.equal(1)
			expect(state.previousScreens[1]).to.equal(Screens.MAIN)
			expect(#state.nextScreens).to.equal(0)
		end)

		it("should set next screens", function()
			local r = Rodux.Store.new(Screen)
			local state = r:getState()
			state = Screen(state, SetScreen(Screens.IMAGES))
			state = Screen(state, SetScreen(Screens.MESHES))
			state = Screen(state, SetToPreviousScreen())
			state = Screen(state, SetToPreviousScreen())
			state = Screen(state, SetToNextScreen())
			state = Screen(state, SetToNextScreen())

			expect(state.currentScreen).to.equal(Screens.MESHES)
			expect(#state.previousScreens).to.equal(2)
			expect(state.previousScreens[1]).to.equal(Screens.MAIN)
			expect(state.previousScreens[2]).to.equal(Screens.IMAGES)
			expect(#state.nextScreens).to.equal(0)
		end)
	end)
end