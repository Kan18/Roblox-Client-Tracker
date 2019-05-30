local Localization = require(script.Parent.Localization)

local Library = script.Parent.Parent
local Signal = require(Library.Utils.Signal)

local TestLocalizationChangedSignal = Signal.new()

-- helpers
local function createTranslatorForStrings(stringTable)
	return {
		GetTranslator = function(stringResourceTableSelf, localeId)
			local translator = {
				FormatByKey = function(translatorSelf, key, args)
					if not args then
						args = {}
					end

					-- it's okay that this is unsafe,
					-- errors thrown here will be caught by the localization object
					local str = stringTable[localeId][key]
					return string.format(str, unpack(args))
				end,
			}

			return translator
		end
	}
end
local function createTestStringResourceTable()
	-- make a fake set of test strings
	local testStrings = {
		["en-us"] = {
			["Studio.UILibrary.Spec.greeting_formal"] = "Hello",
			["Studio.UILibrary.Spec.greeting_informal"] = "Sup %s, I haven't seen you in %d days",
			["Studio.UILibrary.Spec.greeting_surprise"] = "No one expects the Spanish Inquisition!",
		},
	}
	-- return an object that pretends to be a string resource table
	return createTranslatorForStrings(testStrings)
end
local function createTestTranslationResourceTable()
	-- make a fake set of test strings
	local testStrings = {
		["es-es"] = {
			["Studio.UILibrary.Spec.greeting_formal"] = "Hola",
			["Studio.UILibrary.Spec.greeting_informal"] = "¿Qué pasa %s? No te he visto en %d días",
			--greeting_surprise is intentionally missing for testing purposes
		}
	}
	-- return an object that pretends to be a string resource table
	return createTranslatorForStrings(testStrings)
end


return function()
	-- since Localization connects to system signals, it's important to clean up after the test
	describe("Localization", function()
		it("should construct with the correct inputs", function()
			local localization = Localization.new({
				stringResourceTable = createTestStringResourceTable(),
				translationResourceTable = createTestTranslationResourceTable(),
				pluginName = "UILibrary",
			})
			expect(localization).to.be.ok()

			localization:destroy()
		end)

		it("should error if it is missing any props", function()
			expect(function()
				Localization.new()
			end).to.throw()

			expect(function()
				Localization.new({})
			end).to.throw()

			expect(function()
				Localization.new({ stringResourceTable = createTestStringResourceTable() })
			end).to.throw()

			expect(function()
				Localization.new({ translationResourceTable = createTestTranslationResourceTable() })
			end).to.throw()

			expect(function()
				Localization.new({ pluginName = "UILibrary" })
			end).to.throw()
		end)

		it("should return localized strings when given keys to look up", function()
			local localization = Localization.new({
				stringResourceTable = createTestStringResourceTable(),
				translationResourceTable = createTestTranslationResourceTable(),
				pluginName = "UILibrary",
				overrideLocaleId = "en-us",
				overrideLocaleChangedSignal = TestLocalizationChangedSignal
			})

			local greeting = localization:getText("Spec", "greeting_formal")
			expect(greeting).to.equal("Hello")

			localization:destroy()
		end)

		it("should return a formatted string when args are provided", function()
			local localization = Localization.new({
				stringResourceTable = createTestStringResourceTable(),
				translationResourceTable = createTestTranslationResourceTable(),
				pluginName = "UILibrary",
				overrideLocaleId = "en-us",
				overrideLocaleChangedSignal = TestLocalizationChangedSignal
			})

			local greeting = localization:getText("Spec", "greeting_informal", "Builderman", 2)
			expect(greeting).to.equal("Sup Builderman, I haven't seen you in 2 days")

			localization:destroy()
		end)

		it("should return the English text of a string if a translation is missing in the resourceTable", function()
			local localization = Localization.new({
				stringResourceTable = createTestStringResourceTable(),
				translationResourceTable = createTestTranslationResourceTable(),
				pluginName = "UILibrary",
				overrideLocaleId = "es-es",
				overrideLocaleChangedSignal = TestLocalizationChangedSignal
			})

			local normal = localization:getText("Spec", "greeting_formal")
			expect(normal).to.equal("Hola")

			local informal = localization:getText("Spec", "greeting_informal", "John Doe", 100)
			expect(informal).to.equal("¿Qué pasa John Doe? No te he visto en 100 días")

			local surprise = localization:getText("Spec", "greeting_surprise")
			expect(surprise).to.equal("No one expects the Spanish Inquisition!")

			localization:destroy()
		end)

		it("should return the key if the string does not exist in the resourceTable at all", function()
			local localization = Localization.new({
				stringResourceTable = createTestStringResourceTable(),
				translationResourceTable = createTestTranslationResourceTable(),
				pluginName = "UILibrary",
				overrideLocaleId = "en-us",
				overrideLocaleChangedSignal = TestLocalizationChangedSignal
			})

			local greeting = localization:getText("Spec", "greeting_serious")
			expect(greeting).to.equal("Studio.UILibrary.Spec.greeting_serious")

			localization:destroy()
		end)

		it("should update its strings if the localization changes", function()
			local changeSignal = Signal.new()
			local currentLocale = "en-us"
			local function getLocale()
				return currentLocale
			end

			local localization = Localization.new({
				stringResourceTable = createTestStringResourceTable(),
				translationResourceTable = createTestTranslationResourceTable(),
				pluginName = "UILibrary",
				getLocale = getLocale,
				overrideLocaleChangedSignal = changeSignal
			})

			local greeting = localization:getText("Spec", "greeting_formal")
			expect(greeting).to.equal("Hello")

			-- trigger a locale change
			currentLocale = "es-es"
			changeSignal:fire()

			greeting = localization:getText("Spec", "greeting_formal")
			expect(greeting).to.equal("Hola")


			localization:destroy()
		end)

		it("should remove the observer to the localization changed signal when it is destroyed", function()
			local changeSignal = Signal.new()
			local currentLocale = "en-us"
			local callCount = 0
			local function getLocale()
				callCount = callCount + 1
				return currentLocale
			end

			local localization = Localization.new({
				stringResourceTable = createTestStringResourceTable(),
				translationResourceTable = createTestTranslationResourceTable(),
				pluginName = "UILibrary",
				getLocale = getLocale,
				overrideLocaleChangedSignal = changeSignal
			})

			expect(callCount).to.equal(1)

			local greeting = localization:getText("Spec", "greeting_formal")
			expect(greeting).to.equal("Hello")

			-- trigger a locale change
			currentLocale = "es-es"
			changeSignal:fire()

			greeting = localization:getText("Spec", "greeting_formal")
			expect(greeting).to.equal("Hola")
			expect(callCount).to.equal(2)

			-- destroy the connection and trigger another change
			localization:destroy()
			currentLocale = "en-us"
			changeSignal:fire()

			greeting = localization:getText("Spec", "greeting_formal")
			expect(greeting).to.equal("Hola")
			expect(callCount).to.equal(2)
		end)
	end)


	describe("Localization.mock()", function()
		it("should always return a string, even without the actual resourceTable", function()
			local mock = Localization.mock()

			-- expect it to return someting, if not the real string
			-- something like : <localeId>|<namespace>.<pluginName>.<scope>.<key>:[list of args]
			local strA = mock:getText("Anything", "greeting_formal")
			expect(strA).to.equal("en-us|TEST.MOCK_LOCALIZATION.Anything.greeting_formal:[]")

			local strB = mock:getText("Anything", "greeting_informal", "Jane Doe", 1)
			expect(strB).to.equal("en-us|TEST.MOCK_LOCALIZATION.Anything.greeting_informal:[Jane Doe,1]")

			mock:destroy()
		end)

		it("should allow for an external signal to fake locale changes", function()
			local testSignal = Signal.new()
			local mockLocalization = Localization.mock(testSignal)

			local callCount = 0
			local mockToken = mockLocalization.localeChanged:connect(function()
				callCount = callCount + 1
			end)

			testSignal:fire()
			expect(callCount).to.equal(1)

			mockToken:disconnect()
			mockLocalization:destroy()
		end)
	end)
end