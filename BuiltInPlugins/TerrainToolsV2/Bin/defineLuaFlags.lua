-- Lua flag definitions should go in this file so that they can be used by both main and runTests
-- If the flags are defined in main, then it's possible for the tests run first
-- And then error when trying to use flags that aren't yet defined

game:DefineFastFlag("TerrainOpenCloseMetrics", false)
game:DefineFastFlag("TerrainToolsUseDevFramework", false)
game:DefineFastFlag("TerrainToolsReplaceTool", false)
game:DefineFastFlag("TerrainEnableErrorReporting", false)
game:DefineFastFlag("TerrainToolsReplaceSrcTogglesOff", false)

local function handleFlagDependencies(flag, requiredFlags)
	if not game:GetFastFlag(flag) then
		return
	end

	for _, requiredFlag in ipairs(requiredFlags) do
		assert(game:GetFastFlag(requiredFlag),
			("FFlag%s requires FFlag%s to be on"):format(flag, requiredFlag))
	end
end

-- Need to explicitly return something from a module
-- Else you get an error "Module code did not return exactly one value"
return nil
