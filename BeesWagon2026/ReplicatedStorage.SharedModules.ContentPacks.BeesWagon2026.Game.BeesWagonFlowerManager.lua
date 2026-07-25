-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local DataM = require(ServerScriptService.Modules.Core.DataM.DataM.DataM)
local v1 = require(ReplicatedStorage.Fsys).load("InventoryDB")
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local CycleTimestamp = require(ServerScriptService.Modules.Game.CycleTimestamp.CycleTimestamp)
local LiveOpsTime = require(ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local v2 = CycleTimestamp.new({
	intermission_length = 600,
	start_offset = 54000,
	fire_when_skipped = true
})
local t = {
	ClassName = "BeesWagonFlowerManager"
}

t.__index = t
function t.new(p1, p2) --[[ new | Line: 37 | Upvalues: BeesWagonFlowerHelper (copy), Maid (copy), v2 (copy), LiveOpsTime (copy), t (copy) ]]
	local v1 = if p2 then p2 else {}
	local v22 = v1.placed_flowers or {}

	if BeesWagonFlowerHelper.are_all_bouquets_complete(v22) then
		table.clear(v22)
	end

	local t2 = {
		player = p1,
		maid = Maid.new(),
		bouquets_handed_in = v1.bouquets_handed_in or 0
	}

	t2.planted_seeds = v1.planted_seeds or {}
	t2.placed_flowers = v22
	t2.current_cycle_identifier = v2:get_unique_identifier(LiveOpsTime.now())

	local v5 = setmetatable(t2, t)

	v5.maid:GiveTask(v2:get_new_cycle_began_signal():Connect(function(p1, p2) --[[ Line: 58 | Upvalues: v5 (copy) ]]
		v5.current_cycle_identifier = p2
		v5:mark_changed()
	end))

	return v5
end
function t.mark_changed(p1) --[[ mark_changed | Line: 66 | Upvalues: DataM (copy), BeesWagonFlowerHelper (copy) ]]
	local v1 = DataM.get_store(p1.player)

	if not v1 then
		return
	end

	v1:push_update(BeesWagonFlowerHelper.REPLICATION_KEY)
end
function t.serialize_for_save(p1) --[[ serialize_for_save | Line: 73 ]]
	return {
		bouquets_handed_in = p1.bouquets_handed_in,
		planted_seeds = p1.planted_seeds,
		placed_flowers = p1.placed_flowers
	}
end
function t.serialize_for_client_replication(p1) --[[ serialize_for_client_replication | Line: 81 ]]
	return {
		bouquets_handed_in = p1.bouquets_handed_in,
		planted_seeds = p1.planted_seeds,
		placed_flowers = p1.placed_flowers,
		current_cycle_identifier = p1.current_cycle_identifier
	}
end

local function is_valid_bouquet_index(p1) --[[ is_valid_bouquet_index | Line: 90 | Upvalues: BeesWagonFlowerHelper (copy) ]]
	if typeof(p1) ~= "string" then
		return false
	end

	local v1 = tonumber(p1)

	return if v1 == nil or (v1 ~= math.floor(v1) or not (v1 >= 1)) then false else v1 <= BeesWagonFlowerHelper.BOUQUET_COUNT
end

local function is_valid_spot_index(p1) --[[ is_valid_spot_index | Line: 99 | Upvalues: BeesWagonFlowerHelper (copy) ]]
	if typeof(p1) ~= "string" then
		return false
	end

	local v1 = tonumber(p1)

	return if v1 == nil or (v1 ~= math.floor(v1) or not (v1 >= 1)) then false else v1 <= BeesWagonFlowerHelper.PLANTING_SPOT_COUNT
end

function t.plant_seed(p1, p2, p3) --[[ plant_seed | Line: 108 | Upvalues: BeesWagonFlowerHelper (copy), DataM (copy), LiveOpsTime (copy) ]]
	local v1

	if typeof(p2) == "string" then
		local v2 = tonumber(p2)

		v1 = if v2 == nil or (v2 ~= math.floor(v2) or not (v2 >= 1)) then false elseif v2 <= BeesWagonFlowerHelper.PLANTING_SPOT_COUNT then true else false
	else
		v1 = false
	end

	if not v1 then
		return false
	end

	if p1.planted_seeds[p2] then
		return false
	end

	local v3 = DataM.get_store(p1.player)
	local v4 = if v3 then v3:get("inventory") else v3

	if not v4 then
		return false
	end

	local v5 = v4:get_item(p3)

	if not v5 then
		return false
	end

	local v6 = BeesWagonFlowerHelper.SEED_ITEM_KINDS_MAP[v5.kind]

	if v6 then
		v4:delete_item(v5)
		p1.planted_seeds[p2] = {
			flower_kind = v6,
			watered_at = LiveOpsTime.now()
		}
		p1:mark_changed()

		return true
	end

	return false
end
function t.pick_flower(p1, p2) --[[ pick_flower | Line: 132 | Upvalues: BeesWagonFlowerHelper (copy), LiveOpsTime (copy), DataM (copy), v1 (copy) ]]
	local v12

	if typeof(p2) == "string" then
		local v2 = tonumber(p2)

		v12 = if v2 == nil or (v2 ~= math.floor(v2) or not (v2 >= 1)) then false elseif v2 <= BeesWagonFlowerHelper.PLANTING_SPOT_COUNT then true else false
	else
		v12 = false
	end

	if not v12 then
		return false
	end

	local v3 = p1.planted_seeds[p2]

	if not v3 then
		return false
	end

	if not BeesWagonFlowerHelper.is_flower_ready(v3, LiveOpsTime.now()) then
		return false
	end

	local v4 = DataM.get_store(p1.player)
	local v5 = if v4 then v4:get("inventory") else v4
	local v6 = if v4 then v4:get("equip_manager") else v4

	if not (v5 and v6) then
		return false
	end

	local v8 = v1.toys[BeesWagonFlowerHelper.get_flower_item_kind(v3.flower_kind)]

	if not v8 then
		return false
	end

	local v9 = v5:add_item(v8)

	if v9 then
		v6:equip(v9)
		p1.planted_seeds[p2] = nil
		p1:mark_changed()

		return true
	end

	return false
end
function t.add_bouquet_flower(p1, p2) --[[ add_bouquet_flower | Line: 158 | Upvalues: BeesWagonFlowerHelper (copy), DataM (copy) ]]
	local v1

	if typeof(p2) == "string" then
		local v2 = tonumber(p2)

		v1 = if v2 == nil or (v2 ~= math.floor(v2) or not (v2 >= 1)) then false elseif v2 <= BeesWagonFlowerHelper.BOUQUET_COUNT then true else false
	else
		v1 = false
	end

	if not v1 then
		return false
	end

	local v3 = p1.placed_flowers[p2] or {}

	if #v3 >= BeesWagonFlowerHelper.FLOWERS_PER_BOUQUET then
		return false
	end

	local v4 = BeesWagonFlowerHelper.get_bouquet_requirements(p2, p1.player.UserId)
	local v5 = BeesWagonFlowerHelper.compute_remaining_requirements(v4, v3)
	local v6 = DataM.get_store(p1.player)
	local v7 = if v6 then v6:get("inventory") else v6

	if not v7 then
		return false
	end

	local v8 = nil
	local v9 = nil

	for v10, v11 in v4 do
		if v5[v11] then
			local v12 = v7:get_items_with_id((BeesWagonFlowerHelper.get_flower_item_kind(v11)))

			if #v12 > 0 then
				v9 = v12[1]
				v8 = v11

				break
			end
		end
	end

	if not v8 then
		return false
	end

	v7:delete_item(v9)
	table.insert(v3, v8)
	p1.placed_flowers[p2] = v3
	p1:mark_changed()

	if not (#v3 >= BeesWagonFlowerHelper.FLOWERS_PER_BOUQUET) then
		return true
	end

	p1:_complete_bouquet()

	return true
end
function t._complete_bouquet(p1) --[[ _complete_bouquet | Line: 198 | Upvalues: BeesWagonFlowerHelper (copy), DataM (copy) ]]
	p1.bouquets_handed_in = p1.bouquets_handed_in + 1

	local v1 = BeesWagonFlowerHelper.are_all_bouquets_complete(p1.placed_flowers)
	local v2 = DataM.get_store(p1.player)
	local v3 = if v2 then v2:get("battle_pass_manager") else v2
	local v4 = if v3 then v3:get(BeesWagonFlowerHelper.BATTLE_PASS_KIND) else v3

	if v4 then
		local BOUQUET_XP_REWARD = BeesWagonFlowerHelper.BOUQUET_XP_REWARD

		if v1 then
			BOUQUET_XP_REWARD = BOUQUET_XP_REWARD + BeesWagonFlowerHelper.ALL_BOUQUETS_COMPLETED_XP_REWARD
		end

		v4:gain_xp(BOUQUET_XP_REWARD)
	end

	if v1 then
		table.clear(p1.placed_flowers)
	end

	p1:mark_changed()
end
function t.destroy(p1) --[[ destroy | Line: 221 ]]
	p1.maid:Destroy()
end

return t