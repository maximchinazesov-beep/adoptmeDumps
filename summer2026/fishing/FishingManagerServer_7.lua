-- https://lua.expert/
local HttpService = game:GetService("HttpService")
local ServerScriptService = game:GetService("ServerScriptService")
local AdminAbuse = require(game.ReplicatedStorage.new.modules.AdminAbuse)
local AdminAbuseSummerLaunch = require(script.Parent.Parent.Game.AdminAbuseSummerLaunch)
local AltCurrencyData = require(game.ReplicatedStorage.SharedModules.SharedDB.AltCurrencyData)
local CloudValues = require(game.ServerScriptService.Modules.Game.CloudValues)
local DailiesServer = require(game.ServerScriptService.new.modules.Dailies.DailiesServer)
local DataM = require(game.ServerScriptService.Modules.Core.DataM.DataM.DataM)
local FishDB = require(script.Parent.DB.FishDB)
local FishHotspotsDB = require(script.Parent.DB.FishHotspotsDB)
local FishingPurchasesDB = require(script.Parent.DB.FishingPurchasesDB)
local FishingRodDB = require(script.Parent.DB.FishingRodDB)

require(script.Parent.FishingTypes)

local CycleTimestamp = require(ServerScriptService.Modules.Game.CycleTimestamp.CycleTimestamp)
local KindDB = require(game.ReplicatedStorage.ClientDB.Inventory.KindDB)
local Maid = require(game.ReplicatedStorage.SharedModules.Maid)
local LiveOpsTime = require(game.ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local Sift = require(game.ReplicatedStorage.SharedPackages.Sift)
local Stash = require(game.ServerScriptService.ServerPackages.Stash)
local NotificationManager = require(game.ServerScriptService.Modules.Game.NotificationManager)
local WeightedRandom = require(game.ReplicatedStorage.new.modules.Utilities.WeightedRandom)
local v1 = CycleTimestamp.new({
	intermission_length = 600,
	fire_when_skipped = true
})
local t = {}

t.__index = t
t.FISHING_CYCLE = v1

local t2 = { "summer_2026_bronze_fishing_rod", "summer_2026_silver_fishing_rod", "summer_2026_gold_fishing_rod" }

local function remove_owned_fishing_rods(p1) --[[ remove_owned_fishing_rods | Line: 57 | Upvalues: t2 (copy) ]]
	for v1, v2 in t2 do
		for v3, v4 in p1:on_committed():get_item_uuids_of_kind(v2) do
			p1:on_committed():remove_item(v3)
		end
	end
end

local function get_item_grant_context(p1) --[[ get_item_grant_context | Line: 65 | Upvalues: DataM (copy) ]]
	local v1 = DataM.get(p1, "inventory_manager")
	local v2 = DataM.get(p1, "equip_manager")
	local v3 = DataM.get(p1, "inventory")
	local v4 = DataM.get(p1, "currency_manager")

	if v1 and (v2 and (v3 and v4)) then
		return true, v1, v2, v3, v4
	end

	return false
end

local function grant_item(p1, p2, p3, p4, p5) --[[ grant_item | Line: 76 | Upvalues: KindDB (copy), FishingRodDB (copy), remove_owned_fishing_rods (copy) ]]
	local v1 = KindDB[p4]

	if not v1 then
		return false, ("item %* doesn\'t have an InventoryDB entry"):format(p4)
	end

	if FishingRodDB[p4] then
		remove_owned_fishing_rods(p1)
	end

	local v2 = p1:on_committed()
	local t = {
		category = v1.category,
		kind = p4
	}

	t.properties = if p5 then p5 else {}

	local v4 = p3:get_item((v2:add_item(t)))

	if not v4 then
		return true
	end

	p2:equip(v4)

	return true
end

local function validate_fish(p1, p2) --[[ validate_fish | Line: 106 | Upvalues: FishHotspotsDB (copy) ]]
	return if typeof(p1) == "string" and FishHotspotsDB.by_kind[p1] ~= nil then type(p2) == "string" else false
end

function t.spawn_fish(p1, p2, p3, p4) --[[ spawn_fish | Line: 112 | Upvalues: FishDB (copy), FishHotspotsDB (copy) ]]
	local t = {}

	for v1, v2 in FishDB.get(p2).hotspot_categories do
		for v3, v4 in FishHotspotsDB.by_category[v2] do
			table.insert(t, v4)
		end
	end

	p1.hotspots[t[p4:NextInteger(1, #t)]][p3] = p2
end
function t.refresh_hotspots_cycle(p1, p2) --[[ refresh_hotspots_cycle | Line: 125 | Upvalues: FishHotspotsDB (copy), FishDB (copy), CloudValues (copy), WeightedRandom (copy), HttpService (copy) ]]
	if p2 <= p1.current_cycle_identifier then
		return
	end

	p1.current_cycle_identifier = p2
	p1.previous_depleted_fish = p1.depleted_fish
	p1.previous_hotspots = p1.hotspots
	p1.depleted_fish = {}
	p1.hotspots = {}

	for v1, v2 in FishHotspotsDB.by_kind do
		p1.hotspots[v1] = {}
	end

	local v3 = Random.new(p2)
	local v4 = v3:NextInteger(1, 9007199254740991)
	local t = {}
	local t2 = {}

	for v5, v6 in FishDB.get_all() do
		if v6.population_min then
			for i = 1, v6.population_min do
				table.insert(t, v5)
			end
		end

		t2[v5] = v6.appearance_weight
	end

	local t3 = {}

	for j = 1, CloudValues:getValue("fishing", "fish_per_day") do
		local v7 = t[j]

		if not v7 then
			v7 = WeightedRandom.get_value(t2, v4 - j)
		end

		local v9 = FishDB.get(v7)

		t3[v7] = (t3[v7] or 0) + 1

		if v9.population_max and t3[v7] == v9.population_max then
			t2[v7] = nil
		end

		p1:spawn_fish(v7, HttpService:GenerateGUID(false), v3)
	end

	for v10, v11 in p1.starter_fish do
		p1.hotspots.lake1[v10] = v11
	end

	p1:mark_changed()
end
function t.new(p1, p2) --[[ new | Line: 180 | Upvalues: Sift (copy), Maid (copy), t (copy), CloudValues (copy), HttpService (copy), AdminAbuseSummerLaunch (copy), v1 (copy), LiveOpsTime (copy), DailiesServer (copy), AdminAbuse (copy) ]]
	local v3 = setmetatable(Sift.Dictionary.merge({
		player = p1,
		maid = Maid.new(),
		hotspots = {}
	}, {
		current_cycle_identifier = -1,
		upgrade_fish_caught = 0,
		depleted_fish = {},
		bought_unique_items = {}
	}, p2), t)

	if not v3.starter_fish then
		v3.starter_fish = {}

		for i = 1, CloudValues:getValue("fishing", "starter_fish") do
			v3.starter_fish[HttpService:GenerateGUID(false)] = "summer_2026_bronze_fish"
		end
	end

	v3.maid:GiveTask(AdminAbuseSummerLaunch.delay_until_launch():andThen(function() --[[ Line: 200 | Upvalues: v3 (copy), v1 (ref), LiveOpsTime (ref), DailiesServer (ref), p1 (copy), AdminAbuse (ref) ]]
		v3:refresh_hotspots_cycle(v1:get_unique_identifier(LiveOpsTime.now()))
		v3.maid:GiveTask(v1:get_new_cycle_began_signal():Connect(function(p1, p2) --[[ Line: 202 | Upvalues: v3 (ref) ]]
			v3:refresh_hotspots_cycle(p2)
		end))
		v3:sync_rod_upgrade_properties()

		local v12

		if v3:get_highest_owned_fishing_rod_tier() == 0 then
			DailiesServer.try_to_add_daily(p1, "claimable_bronze_fishing_rod")
		end

		v12 = function(p1) --[[ handle_admin_abuse_force_spawn | Line: 211 | Upvalues: v3 (ref) ]]
			if not p1 then
				return
			end

			if p1.cycle_identifier ~= v3.current_cycle_identifier then
				return
			end

			local v1 = Random.new(p1.cycle_identifier)
			local spawn_unique = p1.spawn_unique

			for i = 1, p1.amount do
				v3:spawn_fish(p1.fish_kind, ("AA-%*-%*"):format(i, spawn_unique), v1)
			end

			v3:mark_changed()
		end
		v12(AdminAbuse.get_value("fishing_force_spawn"))
		v3.maid:GiveTask(AdminAbuse.get_changed_signal("fishing_force_spawn"):Connect(v12))
	end))

	return v3
end
function t.get_highest_owned_fishing_rod_tier(p1) --[[ get_highest_owned_fishing_rod_tier | Line: 237 | Upvalues: FishingRodDB (copy) ]]
	local v1 = 0

	for v2, v3 in p1.bought_unique_items do
		local v4 = FishingRodDB[v2]

		if v4 and v1 < v4.tier then
			v1 = v4.tier
		end
	end

	return v1
end
function t.get_rod_upgrade_properties(p1) --[[ get_rod_upgrade_properties | Line: 250 | Upvalues: t2 (copy), FishingRodDB (copy) ]]
	local v1 = t2[p1:get_highest_owned_fishing_rod_tier() + 1]

	return {
		fishing_upgrade_caught = p1.upgrade_fish_caught,
		fishing_upgrade_required = v1 and FishingRodDB[v1] and FishingRodDB[v1].unlock_fish_count or 0,
		fishing_upgrade_next_rod_kind = v1
	}
end
function t.sync_rod_upgrade_properties(p1) --[[ sync_rod_upgrade_properties | Line: 262 | Upvalues: DataM (copy), t2 (copy) ]]
	local v1 = DataM.get(p1.player, "inventory_manager")

	if not v1 then
		return
	end

	local v2 = p1:get_rod_upgrade_properties()

	for v3, v4 in t2 do
		for v5, v6 in v1:on_committed():get_item_uuids_of_kind(v4) do
			for v7, v8 in v2 do
				v1:on_committed():set_property(v5, v7, v8)
			end

			return
		end
	end
end
function t.purchase_item(p1, p2, p3) --[[ purchase_item | Line: 279 | Upvalues: AdminAbuseSummerLaunch (copy), FishingPurchasesDB (copy), get_item_grant_context (copy), KindDB (copy), AltCurrencyData (copy), Sift (copy), FishingRodDB (copy), grant_item (copy), NotificationManager (copy), Stash (copy) ]]
	if not AdminAbuseSummerLaunch.is_launch_unlocked() then
		return false, "Event hasn\'t started yet"
	end

	local v1 = FishingPurchasesDB.get(p2)

	if not v1 then
		return false, ("%* doesn\'t have a cost in FishingPurchasesDB"):format(p2)
	end

	if v1.unique_item and p1.bought_unique_items[p2] then
		return false, ("%* is unique and has already been bought"):format(p2)
	end

	if v1.unique_item and p3 > 1 then
		return false, ("%* is unique and you cannot buy more than 1 copy"):format(p2)
	end

	local v2, v3, v4, v5, v6 = get_item_grant_context(p1.player)

	if not v2 then
		return false, "player_managers don\'t exist"
	end

	if not KindDB[p2] then
		return false, ("item %* doesn\'t have an InventoryDB entry"):format(p2)
	end

	local sum = 0
	local t = {}

	for v7, v8 in v1.cost do
		local v9 = v8.amount * p3

		if AltCurrencyData.enabled and v7 == AltCurrencyData.name then
			sum = sum + v9

			if v6:get(AltCurrencyData.name) < sum then
				return false, ("Not enough %* to pay the cost"):format(AltCurrencyData.name)
			end

			continue
		end

		local t2 = {}

		for v10, v11 in v3:on_committed():get_item_uuids_of_kind(v7) do
			table.insert(t2, v10)

			if #t2 == v9 then
				t = Sift.Array.concat(t, t2)

				break
			end
		end

		if #t2 < v9 then
			return false, ("Not enough %* to pay the cost (%*/%*)"):format(v7, #t2, v9)
		end
	end

	for i = 1, p3 do
		local v14, v15 = grant_item(v3, v4, v5, p2, if FishingRodDB[p2] then p1:get_rod_upgrade_properties() else nil)

		if not v14 then
			return false, v15
		end
	end

	if sum > 0 then
		v6:modify(AltCurrencyData.name, -sum)
	end

	for v16, v17 in t do
		v3:on_committed():remove_item(v17)
	end

	if v1.unique_item then
		p1.bought_unique_items[p2] = true

		if FishingRodDB[p2] then
			p1:sync_rod_upgrade_properties()
		end

		p1:mark_changed()
	end

	NotificationManager.indicate_event({
		name = "fishing_purchase_made",
		player = p1.player,
		options = {
			kind = p2
		}
	})
	Stash:log("fishing_purchase_made", {
		user_id = p1.player.UserId,
		item_kind = p2
	})

	return true
end
function t.upgrade_fishing_rod(p1) --[[ upgrade_fishing_rod | Line: 372 | Upvalues: AdminAbuseSummerLaunch (copy), t2 (copy), FishingRodDB (copy), get_item_grant_context (copy), grant_item (copy), NotificationManager (copy), Stash (copy) ]]
	if not AdminAbuseSummerLaunch.is_launch_unlocked() then
		return false, "Event hasn\'t started yet"
	end

	local v1 = p1:get_highest_owned_fishing_rod_tier()

	if v1 == 0 then
		return false, "Bronze Fishing Rod must be claimed first"
	end

	local v2 = t2[v1 + 1]
	local v3 = if v2 then FishingRodDB[v2] and FishingRodDB[v2].unlock_fish_count else v2

	if not v3 then
		return false, "No next rod"
	end

	if p1.bought_unique_items[v2] then
		return false, "Already claimed"
	end

	if p1.upgrade_fish_caught < v3 then
		return false, "Not enough fish caught"
	end

	local v4, v5, v6, v7, _ = get_item_grant_context(p1.player)

	if not v4 then
		return false, "player managers don\'t exist"
	end

	local v8, v9 = grant_item(v5, v6, v7, v2, p1:get_rod_upgrade_properties())

	if v8 then
		p1.upgrade_fish_caught = 0
		p1.bought_unique_items[v2] = true
		p1:sync_rod_upgrade_properties()
		p1:mark_changed()
		NotificationManager.indicate_event({
			name = "fishing_purchase_made",
			player = p1.player,
			options = {
				kind = v2
			}
		})
		Stash:log("fishing_rod_obtained", {
			user_id = p1.player.UserId,
			item_kind = v2
		})

		return true
	end

	return false, v9
end
function t.catch_fish(p1, p2, p3) --[[ catch_fish | Line: 431 | Upvalues: AdminAbuseSummerLaunch (copy), FishHotspotsDB (copy), DataM (copy), FishDB (copy), KindDB (copy), NotificationManager (copy), Stash (copy) ]]
	if not AdminAbuseSummerLaunch.is_launch_unlocked() then
		return false, "Event hasn\'t started yet"
	end

	if not (if typeof(p2) == "string" and FishHotspotsDB.by_kind[p2] ~= nil then if type(p3) == "string" then true else false else false) then
		return false, "Invalid arguments"
	end

	if p1.depleted_fish[p3] then
		return false, "fish already depleted"
	end

	local v2 = DataM.get(p1.player, "inventory_manager")

	if not v2 then
		return false, "inventory_manager doesn\'t exist"
	end

	local v3 = DataM.get(p1.player, "equip_manager")

	if not v3 then
		return false, "equip_manager doesn\'t exist"
	end

	local v4 = DataM.get(p1.player, "inventory")

	if not v4 then
		return false, "legacy_inventory doesn\'t exist"
	end

	local v5 = p1.hotspots[p2][p3]
	local v6

	if v5 or not (p1.previous_hotspots and p1.previous_depleted_fish) then
		v6 = false
	else
		v5 = p1.previous_hotspots[p2][p3]

		if p1.previous_depleted_fish[p3] then
			return false, "fish already depleted (previous cycle)"
		end

		v6 = true
	end

	if not v5 then
		return false, "fish is nil at that hotspot and fish_unique"
	end

	local v7 = FishDB.get(v5)

	if not v7 then
		return false, "fish has no entry in FishDB"
	end

	local v8 = next(v2:on_committed():get_item_uuids_of_kind(v7.bait))

	if not v8 then
		return false, "No fishing bait exists"
	end

	local v9 = KindDB[v5]

	if not v9 then
		return false, ("fish %* doesn\'t have an InventoryDB entry"):format(v5)
	end

	v2:on_committed():remove_item(v8)

	local v10 = v2:on_committed():add_item({
		category = v9.category,
		kind = v5,
		properties = {}
	})

	if v9.category == "pets" then
		local v11 = v4:get_item(v10)

		if v11 then
			v3:equip(v11)
		end
	end

	if v6 then
		p1.previous_hotspots = nil
		p1.previous_depleted_fish = nil
	else
		p1.depleted_fish[p3] = true
	end

	if p1.starter_fish[p3] then
		p1.starter_fish[p3] = nil
	end

	p1.upgrade_fish_caught = p1.upgrade_fish_caught + 1
	p1:sync_rod_upgrade_properties()
	p1:mark_changed()
	NotificationManager.indicate_event({
		name = "fish_caught",
		player = p1.player,
		options = {
			kind = v5
		}
	})
	Stash:log("fishing_fish_caught", {
		user_id = p1.player.UserId,
		item_kind = v5,
		item_unique = v10
	})

	return true
end
function t.deplete_fish(p1, p2, p3) --[[ deplete_fish | Line: 537 | Upvalues: AdminAbuseSummerLaunch (copy), FishHotspotsDB (copy) ]]
	if not AdminAbuseSummerLaunch.is_launch_unlocked() then
		return false, "Event hasn\'t started yet"
	end

	if not (if typeof(p2) == "string" and FishHotspotsDB.by_kind[p2] ~= nil then if type(p3) == "string" then true else false else false) then
		return false, "Invalid arguments"
	end

	local v2 = p1.hotspots[p2][p3]
	local v3

	if v2 or not p1.previous_hotspots then
		v3 = false
	else
		v2 = p1.previous_hotspots[p2][p3]
		v3 = true
	end

	if not v2 then
		return false, "fish is nil at that hotspot and fish_unique"
	end

	if v3 then
		p1.previous_hotspots = nil
		p1.previous_depleted_fish = nil
	else
		p1.depleted_fish[p3] = true
	end

	p1:mark_changed()

	return true
end
function t.mark_changed(p1) --[[ mark_changed | Line: 570 | Upvalues: DataM (copy) ]]
	local v1 = DataM.get_store(p1.player)

	if v1 and not v1.destroyed then
		v1:push_update("fishing_manager")
	end
end
function t.serialize_for_save(p1) --[[ serialize_for_save | Line: 579 ]]
	return {
		depleted_fish = p1.depleted_fish,
		starter_fish = p1.starter_fish,
		bought_unique_items = p1.bought_unique_items,
		upgrade_fish_caught = p1.upgrade_fish_caught,
		current_cycle_identifier = p1.current_cycle_identifier
	}
end
function t.serialize_for_client_replication(p1) --[[ serialize_for_client_replication | Line: 590 | Upvalues: LiveOpsTime (copy) ]]
	return {
		hotspots = p1.hotspots,
		depleted_fish = p1.depleted_fish,
		is_daytime = LiveOpsTime.get_is_day(),
		bought_unique_items = p1.bought_unique_items,
		upgrade_fish_caught = p1.upgrade_fish_caught
	}
end
function t.destroy(p1) --[[ destroy | Line: 600 ]]
	p1.maid:DoCleaning()
end

return t