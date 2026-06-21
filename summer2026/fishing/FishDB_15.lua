-- https://lua.expert/
local v1 = require(game.ReplicatedStorage.new.modules.LegacyLoad)("CloudValues")
local t = {
	summer_2026_bronze_fish = "bronze_fish_entry",
	summer_2026_silver_fish = "silver_fish_entry",
	summer_2026_gold_fish = "gold_fish_entry",
	summer_2026_rainbow_fish = "rainbow_fish_entry",
	summer_2026_lake_monster = "lake_monster_entry"
}

return {
	item_kind_to_cloud_value_key = t,
	get = function(p1) --[[ get | Line: 31 | Upvalues: v1 (copy), t (copy) ]]
		return v1:getValue("fishing", t[p1])
	end,
	get_all = function() --[[ get_all | Line: 35 | Upvalues: t (copy), v1 (copy) ]]
		local t2 = {}

		for v12, v2 in t do
			t2[v12] = v1:getValue("fishing", v2)
		end

		return t2
	end
}