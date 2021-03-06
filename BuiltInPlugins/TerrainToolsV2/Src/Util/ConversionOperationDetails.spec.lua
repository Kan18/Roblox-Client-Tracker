local ConversionOperationDetails = require(script.Parent.ConversionOperationDetails)

return function()
	describe("the module", function()
		it("should return a table", function()
			expect(ConversionOperationDetails).to.be.ok()
			expect(type(ConversionOperationDetails)).to.equal("table")
		end)
	end)

	describe("GetTargetShapes", function()
		it("should have an onStep callback", function()
			expect(type(ConversionOperationDetails.GetTargetShapes.onStep)).to.equal("function")
		end)
	end)

	describe("UpdateInstanceVisuals", function()
		it("should have an onStep callback", function()
			expect(type(ConversionOperationDetails.UpdateInstanceVisuals.onStep)).to.equal("function")
		end)
	end)

	describe("ConvertShapesToMaterial", function()
		it("should have an onStep callback", function()
			expect(type(ConversionOperationDetails.ConvertShapesToMaterial.onStep)).to.equal("function")
		end)
	end)

	describe("ConvertShapesToBiomes", function()
		it("should have an onStep callback", function()
			expect(type(ConversionOperationDetails.ConvertShapesToBiomes.onStep)).to.equal("function")
		end)
	end)
end
