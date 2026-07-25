-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ToolDBHelper = require(ReplicatedStorage.ClientDB.ToolDBHelper)
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)

local function flower_specific_model_render(p1, p2) --[[ flower_specific_model_render | Line: 6 | Upvalues: BeesWagonFlowerHelper (copy) ]]
	for v1 in BeesWagonFlowerHelper.FLOWER_KINDS do
		if p2 ~= v1 then
			local v2 = p1:FindFirstChild(v1)

			if v2 then
				v2:Destroy()
			end
		end
	end
end

return {
	BeesWagon2026FlowersTool = {
		server_render = function(p1, p2, ...) --[[ server_render | Line: 19 | Upvalues: BeesWagonFlowerHelper (copy), flower_specific_model_render (copy) ]]
			flower_specific_model_render(p2, BeesWagonFlowerHelper.FLOWER_ITEM_KINDS_MAP[p1.kind])
		end,
		equipped = function(p1, p2) --[[ equipped | Line: 23 | Upvalues: ReplicatedStorage (copy) ]]
			p2.bees_wagon_2026_seed_highlights = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.SeedToolHighlights).new()
		end,
		unequipped = function(p1, p2) --[[ unequipped | Line: 28 ]]
			if not p2.bees_wagon_2026_seed_highlights then
				return
			end

			p2.bees_wagon_2026_seed_highlights:destroy()
			p2.bees_wagon_2026_seed_highlights = nil
		end,
		client_use = function(p1, p2, p3, p4, p5) --[[ client_use | Line: 34 | Upvalues: ReplicatedStorage (copy) ]]
			require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager).apps.GuideArrowApp:navigate_from_options({
				final_destination = "MainMap",
				custom_position_or_method = function(p1) --[[ custom_position_or_method | Line: 39 ]]
					if p1 then
						return p1.ThemeArea.ThemeRoot.Position
					end
				end
			})
		end
	},
	BeesWagon2026SeedsTool = {
		server_render = function(p1, p2, ...) --[[ server_render | Line: 47 | Upvalues: BeesWagonFlowerHelper (copy), flower_specific_model_render (copy) ]]
			flower_specific_model_render(p2, BeesWagonFlowerHelper.SEED_ITEM_KINDS_MAP[p1.kind])
		end,
		equipped = function(p1, p2) --[[ equipped | Line: 51 | Upvalues: ReplicatedStorage (copy) ]]
			p2.bees_wagon_2026_seed_highlights = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.SeedToolHighlights).new()
		end,
		unequipped = function(p1, p2) --[[ unequipped | Line: 56 ]]
			if not p2.bees_wagon_2026_seed_highlights then
				return
			end

			p2.bees_wagon_2026_seed_highlights:destroy()
			p2.bees_wagon_2026_seed_highlights = nil
		end,
		client_use = function(p1, p2, p3, p4, p5) --[[ client_use | Line: 62 | Upvalues: ReplicatedStorage (copy) ]]
			require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager).apps.HintApp:hint({
				text = "Find a patch of dirt to plant this!",
				length = 5.5,
				overridable = true,
				yields = false
			})
		end
	},
	BeesWagon2026HoneyToolOverride = {
		client_use = function(p1, p2, p3) --[[ client_use | Line: 74 | Upvalues: ToolDBHelper (copy), ReplicatedStorage (copy) ]]
			if ToolDBHelper.is_locked(p3.item_data, "You cannot feed your pet locked food!") then
				return
			end

			local BeeAdoption = require(ReplicatedStorage.ClientModules.Game.InteriorHelpers.BeeAdoption)
			local RoamingPetAdoptionClient = require(ReplicatedStorage.new.modules.InteriorHelpers.RoamingPetAdoptionClient)

			if BeeAdoption.is_in_interior() then
				return BeeAdoption.throw_honey(p3.tool.ModelHandle, p3.item_data.unique)
			end

			return RoamingPetAdoptionClient.throw_food_tool(p1, p3)
		end
	}
}