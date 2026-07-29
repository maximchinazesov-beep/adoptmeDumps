-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local CollectionService = game:GetService("CollectionService")
local AilmentEntry = require(ReplicatedStorage.new.modules.Ailments.AilmentEntry)
local SharedConstants = require(ReplicatedStorage.ClientDB.SharedConstants)
local Sift = require(ReplicatedStorage.SharedPackages.Sift)
local SpecialDistributionHelper = require(ReplicatedStorage.new.modules.Ailments.Helpers.SpecialDistributionHelper)
local t = {
	BabyBeingHeld = true,
	BabyOnShoulder = true,
	BabyOnStroller = true,
	PetBeingRidden = true,
	PetBeingFlown = true,
	SitInVehicle = true
}

local function is_near_snowman(p1) --[[ is_near_snowman | Line: 20 | Upvalues: t (copy), CollectionService (copy), Sift (copy), SharedConstants (copy) ]]
	local char = p1.char
	local v1 = if char then char:FindFirstChild("HumanoidRootPart") else nil

	if not v1 then
		return false
	end

	local state_manager = p1.state_manager

	if state_manager then
		for v2, v3 in state_manager:get_states() do
			if t[v3.entry.id] then
				return false
			end
		end
	end

	local v4 = CollectionService:GetTagged("SnowmanServer")
	local v5 = Vector3.new(1, 0, 1) * v1.Position

	return Sift.List.some(v4, function(p1) --[[ Line: 40 | Upvalues: v5 (copy), SharedConstants (ref) ]]
		return (v5 - Vector3.new(1, 0, 1) * p1:GetPivot().Position).Magnitude < SharedConstants.snowman_range
	end)
end

return SpecialDistributionHelper.wrap(AilmentEntry.new({
	kind = "snowman",
	category = "WEATHER",
	not_for_babies = true,
	rewards = {
		bucks = 12,
		xp = 100
	},
	create_description = function(p1) --[[ create_description | Line: 58 ]]
		return {
			name = "Build A Snowman",
			display_text = "Help your pet build a snowman!",
			image = "rbxassetid://107297909071421",
			large_image = "rbxassetid://95328586140303",
			speech_bubble = "I want to build a snowman!",
			cleared_text = "%s is entertained!"
		}
	end,
	create_action = function(p1) --[[ create_action | Line: 69 ]]
		local ClientActions = game.ReplicatedStorage.new.modules.Ailments.ClientActions
		local ActionChoice = require(ClientActions.ActionChoice)
		local InlineAction = require(ClientActions.InlineAction)
		local FurnitureNavigationAction = require(ClientActions.FurnitureNavigationAction)

		return ActionChoice.new({
			{
				text = "Go to the Nearest Snow Pile",
				action = InlineAction.new(function(p1) --[[ Line: 78 | Upvalues: FurnitureNavigationAction (copy) ]]
					return FurnitureNavigationAction.new({
						ailment_to_boost = "snowman"
					})
				end)
			}
		})
	end,
	create_server_components = function(p1, p2, p3) --[[ create_server_components | Line: 87 | Upvalues: SharedConstants (copy), is_near_snowman (copy) ]]
		local RateArea = require(game.ServerScriptService.new.modules.Ailments.ServerComponents.RateArea)

		return {
			rate_area_main = RateArea.new({
				destination_id = "MainMap",
				reset_on_clear = true,
				ailment_key = p3,
				total_time = SharedConstants.full_snowman_duration,
				is_in_area = is_near_snowman
			}),
			rate_area_neighborhood = RateArea.new({
				destination_id = "Neighborhood",
				reset_on_clear = true,
				ailment_key = p3,
				total_time = SharedConstants.full_snowman_duration,
				is_in_area = is_near_snowman
			})
		}
	end
}), function(p1) --[[ Line: 109 | Upvalues: ServerScriptService (copy) ]]
	return require(ServerScriptService.Modules.Core.DataM.DataM.DataM).get_server_constant("LiveOpsMapType") == "Snow"
end)