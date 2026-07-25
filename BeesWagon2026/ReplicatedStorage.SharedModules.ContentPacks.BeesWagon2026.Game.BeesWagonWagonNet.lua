-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local NetEvent = require(ReplicatedStorage.new.modules.Net.NetEvent)
local gt = require(ReplicatedStorage.SharedPackages.gt)
local t = {
	RequestPlantSeed = NetEvent.new({
		request = gt.table({
			spot_index = gt.string(),
			seed_item_unique = gt.string()
		}),
		rate = {
			mode = "SlidingWindow",
			seconds = 10,
			limit = 5
		}
	}),
	RequestPickFlower = NetEvent.new({
		request = gt.string(),
		rate = {
			mode = "SlidingWindow",
			seconds = 10,
			limit = 5
		}
	}),
	RequestAddBouquetFlower = NetEvent.new({
		request = gt.string(),
		rate = {
			mode = "SlidingWindow",
			seconds = 1,
			limit = 12
		}
	})
}

if RunService:IsServer() then
	local ServerScriptService = game:GetService("ServerScriptService")
	local DataM = require(ServerScriptService.Modules.Core.DataM.DataM.DataM)

	local function get_flower_manager(p1) --[[ get_flower_manager | Line: 30 | Upvalues: DataM (copy), BeesWagonFlowerHelper (copy) ]]
		local v1 = DataM.get_store(p1)

		return if v1 then v1:get(BeesWagonFlowerHelper.REPLICATION_KEY) else v1
	end

	t.RequestPlantSeed:on_server_event(function(p1, p2) --[[ Line: 35 | Upvalues: DataM (copy), BeesWagonFlowerHelper (copy) ]]
		local v1 = DataM.get_store(p1)
		local v2 = v1 and v1:get(BeesWagonFlowerHelper.REPLICATION_KEY)

		if v2 then
			v2:plant_seed(p2.spot_index, p2.seed_item_unique)
		end
	end)
	t.RequestPickFlower:on_server_event(function(p1, p2) --[[ Line: 41 | Upvalues: DataM (copy), BeesWagonFlowerHelper (copy) ]]
		local v1 = DataM.get_store(p1)
		local v2 = v1 and v1:get(BeesWagonFlowerHelper.REPLICATION_KEY)

		if v2 then
			v2:pick_flower(p2)
		end
	end)
	t.RequestAddBouquetFlower:on_server_event(function(p1, p2) --[[ Line: 47 | Upvalues: DataM (copy), BeesWagonFlowerHelper (copy) ]]
		local v1 = DataM.get_store(p1)
		local v2 = v1 and v1:get(BeesWagonFlowerHelper.REPLICATION_KEY)

		if v2 then
			v2:add_bouquet_flower(p2)
		end
	end)
end

return t