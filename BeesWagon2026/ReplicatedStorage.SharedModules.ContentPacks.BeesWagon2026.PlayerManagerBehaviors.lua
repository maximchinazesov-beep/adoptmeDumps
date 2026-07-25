-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local BeesWagonFlowerManager = require(script.Parent.Game.BeesWagonFlowerManager)
local BuriedTreasureManager = require(script.Parent.Game.BuriedTreasureManager)

require(script.Parent.Game.BeesWagonWagonNet)

return {
	load = function(p1, p2, p3, p4) --[[ load | Line: 8 | Upvalues: BuriedTreasureManager (copy), BeesWagonFlowerManager (copy), BeesWagonFlowerHelper (copy) ]]
		require(game:GetService("ServerScriptService").new.modules.Dailies.DailiesServer).try_to_add_daily(p1, "view_bee_pass")
		p2:set("buried_treasure_manager", (BuriedTreasureManager.new(p1, p3.stats.buried_treasure_manager)))
		p2:set(BeesWagonFlowerHelper.REPLICATION_KEY, (BeesWagonFlowerManager.new(p1, p3.stats.bees_wagon_2026_flower_manager)))
	end,
	save = function(p1, p2) --[[ save | Line: 26 | Upvalues: BeesWagonFlowerHelper (copy) ]]
		p2.stats.buried_treasure_manager = p1:get("buried_treasure_manager"):serialize_for_save()

		local v1 = p1:get(BeesWagonFlowerHelper.REPLICATION_KEY)

		if not v1 then
			return
		end

		p2.stats.bees_wagon_2026_flower_manager = v1:serialize_for_save()
	end
}