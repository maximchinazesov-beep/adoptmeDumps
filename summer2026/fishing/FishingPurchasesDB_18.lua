-- https://lua.expert/
local v1 = require(game.ReplicatedStorage.new.modules.LegacyLoad)("CloudValues")
local t = {
	summer_2026_bronze_fishing_rod = "bronze_rod_cost",
	summer_2026_monster_fishing_bait = "monster_fishing_bait_cost",
	summer_2026_rainbow_trout = "rainbow_trout_cost",
	summer_2026_fishing_hook_chew_toy = "fishing_hook_chew_toy_cost",
	summer_2026_fishing_tackle_hat = "fishing_tackle_hat_cost"
}

return {
	get = function(p1) --[[ get | Line: 26 | Upvalues: v1 (copy), t (copy) ]]
		return v1:getValue("fishing", t[p1])
	end,
	get_all = function() --[[ get_all | Line: 30 | Upvalues: t (copy), v1 (copy) ]]
		local t2 = {}

		for v12, v2 in t do
			t2[v12] = v1:getValue("fishing", v2)
		end

		return t2
	end
}