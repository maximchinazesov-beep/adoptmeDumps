-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local AilmentEntry = require(ReplicatedStorage.new.modules.Ailments.AilmentEntry)

return require(ReplicatedStorage.new.modules.Ailments.Helpers.SpecialDistributionHelper).wrap(AilmentEntry.new({
	kind = "diving_board",
	category = "WEATHER",
	not_for_babies = true,
	rewards = {
		bucks = 12,
		xp = 100
	},
	create_description = function(p1) --[[ create_description | Line: 17 ]]
		return {
			name = "Diving Board",
			display_text = "Bring your pet to a diving board!",
			image = "rbxassetid://124729460238898",
			large_image = "rbxassetid://77745978444291",
			speech_bubble = "I want to jump off a diving board! \240\159\143\138\226\128\141\226\153\130\239\184\143",
			cleared_text = "%s is all splashed out!"
		}
	end,
	create_action = function(p1) --[[ create_action | Line: 28 ]]
		local ClientActions = game.ReplicatedStorage.new.modules.Ailments.ClientActions
		local ActionChoice = require(ClientActions.ActionChoice)
		local InlineAction = require(ClientActions.InlineAction)
		local FurnitureNavigationAction = require(ClientActions.FurnitureNavigationAction)

		return ActionChoice.new({
			{
				text = "Go to the Nearest Diving Board",
				action = InlineAction.new(function(p1) --[[ Line: 37 | Upvalues: FurnitureNavigationAction (copy) ]]
					return FurnitureNavigationAction.new({
						ailment_to_boost = "diving_board"
					})
				end)
			}
		})
	end,
	create_server_components = function(p1, p2, p3) --[[ create_server_components | Line: 46 ]]
		return {}
	end
}), function(p1) --[[ Line: 50 ]]
	return require(game.ServerScriptService.Modules.Core.DataM.DataM.DataM).get_server_constant("LiveOpsMapType") == "Desert"
end)