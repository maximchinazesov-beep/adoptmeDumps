-- https://lua.expert/
local CloudValues = require(game.ReplicatedStorage.ClientModules.CloudValues)
local FishDB = require(script.Parent.DB.FishDB)
local FishingRodDB = require(script.Parent.DB.FishingRodDB)

return {
	get_adjusted_bite_time = function(p1, p2, p3) --[[ get_adjusted_bite_time | Line: 7 | Upvalues: FishDB (copy), CloudValues (copy), FishingRodDB (copy) ]]
		local v1 = FishDB.get(p1)
		local v2 = CloudValues:getValue("fishing", "fishing_minimum_reaction_time_clamp")
		local v3 = CloudValues:getValue("fishing", "fishing_maximum_reaction_time_clamp")
		local v4 = CloudValues:getValue("fishing", "fishing_reaction_time_modifier_per_tier_delta")
		local v5 = CloudValues:getValue("fishing", "fishing_extra_bite_time_reduction")
		local v6 = if p2 then FishingRodDB[p2] else p2

		if not v1 then
			return v2
		end

		local bite_time = v1.bite_time

		if not p3 then
			bite_time = bite_time - v5
		end

		return math.clamp(bite_time + ((v6 and v6.tier or 0) - v1.tier) * v4, v2, v3)
	end
}