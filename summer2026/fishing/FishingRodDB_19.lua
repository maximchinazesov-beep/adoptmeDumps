-- https://lua.expert/
local v1 = require(game.ReplicatedStorage.new.modules.LegacyLoad)("CloudValues")

return {
	summer_2026_bronze_fishing_rod = {
		tier = 1
	},
	summer_2026_silver_fishing_rod = {
		tier = 2,
		unlock_fish_count = v1:getValue("fishing", "silver_rod_upgrade_cost")
	},
	summer_2026_gold_fishing_rod = {
		tier = 3,
		unlock_fish_count = v1:getValue("fishing", "gold_rod_upgrade_cost")
	}
}