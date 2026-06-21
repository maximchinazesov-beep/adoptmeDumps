-- https://lua.expert/
require(script.Parent.FishingTypes)

local gt = require(game.ReplicatedStorage.SharedPackages.gt)
local NetEvent = require(game.ReplicatedStorage.new.modules.Net.NetEvent)

require(game.ReplicatedStorage.SharedModules.Signal)

local v1 = NetEvent.new({
	request = gt.none(),
	rate = {
		mode = "SlidingWindow",
		seconds = 1,
		limit = 1
	}
})
local v2 = NetEvent.new({
	request = gt.table({
		item_kind = gt.string({
			bytes = "[0, 100]"
		}),
		quantity = gt.number({
			integer = true,
			range = "[1, 99]"
		})
	}),
	rate = {
		mode = "SlidingWindow",
		seconds = 1,
		limit = 1
	}
})
local v3 = NetEvent.new({
	request = gt.table({
		hotspot_kind = gt.string({
			bytes = "[0, 100]",
			unicode = true
		}),
		fish_unique = gt.string({
			bytes = "[0, 100]",
			unicode = true
		})
	}),
	rate = {
		mode = "SlidingWindow",
		seconds = 1,
		limit = 3
	}
})
local v4 = NetEvent.new({
	request = gt.table({
		hotspot_kind = gt.string({
			bytes = "[0, 100]",
			unicode = true
		}),
		fish_unique = gt.string({
			bytes = "[0, 100]",
			unicode = true
		})
	}),
	rate = {
		mode = "SlidingWindow",
		seconds = 1,
		limit = 3
	}
})

NetEvent.new({
	request = gt.table({
		hotspots = gt.any(),
		depleted_fish = gt.any()
	}),
	rate = {
		mode = "Infinite"
	}
})

return {
	start_server = function() --[[ start_server | Line: 45 | Upvalues: v3 (copy), v4 (copy), v1 (copy), v2 (copy) ]]
		local DataM = require(game.ServerScriptService.Modules.Core.DataM.DataM.DataM)

		v3:on_server_event(function(p1, p2) --[[ Line: 48 | Upvalues: DataM (copy) ]]
			local v1 = DataM.get(p1, "fishing_manager")

			if not v1 then
				return
			end

			local v2, v3 = v1:catch_fish(p2.hotspot_kind, p2.fish_unique)

			if v2 then
				return
			end

			warn(v3)
		end)
		v4:on_server_event(function(p1, p2) --[[ Line: 60 | Upvalues: DataM (copy) ]]
			local v1 = DataM.get(p1, "fishing_manager")

			if not v1 then
				return
			end

			local v2, v3 = v1:deplete_fish(p2.hotspot_kind, p2.fish_unique)

			if v2 then
				return
			end

			warn(v3)
		end)
		v1:on_server_event(function(p1) --[[ Line: 72 | Upvalues: DataM (copy) ]]
			local v1 = DataM.get(p1, "fishing_manager")

			if not v1 then
				return
			end

			local v2, v3 = v1:upgrade_fishing_rod()

			if v2 then
				return
			end

			warn(v3)
		end)
		v2:on_server_event(function(p1, p2) --[[ Line: 84 | Upvalues: DataM (copy) ]]
			local v1 = DataM.get(p1, "fishing_manager")

			if not v1 then
				return
			end

			local v2, v3 = v1:purchase_item(p2.item_kind, p2.quantity)

			if v2 then
				return
			end

			warn(v3)
		end)
	end,
	catch_fish = function(p1, p2) --[[ catch_fish | Line: 97 | Upvalues: v3 (copy) ]]
		v3:fire_server({
			hotspot_kind = p1,
			fish_unique = p2
		})
	end,
	deplete_fish = function(p1, p2) --[[ deplete_fish | Line: 104 | Upvalues: v4 (copy) ]]
		v4:fire_server({
			hotspot_kind = p1,
			fish_unique = p2
		})
	end,
	upgrade_fishing_rod = function() --[[ upgrade_fishing_rod | Line: 111 | Upvalues: v1 (copy) ]]
		v1:fire_server()
	end,
	purchase_item = function(p1, p2) --[[ purchase_item | Line: 115 | Upvalues: v2 (copy) ]]
		v2:fire_server({
			item_kind = p1,
			quantity = p2
		})
	end
}