-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AilmentEntry = require(ReplicatedStorage.new.modules.Ailments.AilmentEntry)

return require(ReplicatedStorage.new.modules.Ailments.Helpers.SpecialDistributionHelper).wrap(AilmentEntry.new({
	kind = "leaf_pile",
	category = "WEATHER",
	not_for_babies = true,
	rewards = {
		bucks = 12,
		xp = 100
	},
	create_description = function(p1) --[[ create_description | Line: 17 ]]
		return {
			name = "Leaf Pile",
			display_text = "Bring your pet to a pile of leaves!",
			image = "rbxassetid://104619318438142",
			large_image = "rbxassetid://128092739848409",
			speech_bubble = "I want to play in a pile of leaves! \240\159\141\130",
			cleared_text = "%s is all tired out!"
		}
	end,
	create_action = function(p1) --[[ create_action | Line: 28 ]]
		local ClientActions = game.ReplicatedStorage.new.modules.Ailments.ClientActions
		local ActionChoice = require(ClientActions.ActionChoice)
		local InlineAction = require(ClientActions.InlineAction)
		local FurnitureNavigationAction = require(ClientActions.FurnitureNavigationAction)

		return ActionChoice.new({
			{
				text = "Go to the Nearest Leaf Pile",
				action = InlineAction.new(function(p1) --[[ Line: 37 | Upvalues: FurnitureNavigationAction (copy) ]]
					return FurnitureNavigationAction.new({
						ailment_to_boost = "leaf_pile"
					})
				end)
			}
		})
	end,
	create_server_components = function(p1, p2, p3) --[[ create_server_components | Line: 46 ]]
		return {}
	end
}), function(p1) --[[ Line: 50 ]]
	return require(game.ServerScriptService.Modules.Core.DataM.DataM.DataM).get_server_constant("LiveOpsMapType") == "Fall"
end)