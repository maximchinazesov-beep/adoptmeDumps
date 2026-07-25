-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local KindDB = require(ReplicatedStorage.ClientDB.Inventory.KindDB)
local DataM = require(ServerScriptService.Modules.Core.DataM.DataM.DataM)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local t = {
	ClassName = "BuriedTreasureManager"
}

t.__index = t

local t2 = {
	bones_handed_in = 0,
	pages_handed_in = 0
}

function t.new(p1, p2) --[[ new | Line: 29 | Upvalues: t2 (copy), t (copy), Promise (copy), DataM (copy), KindDB (copy) ]]
	local v1 = if p2 then p2 else t2
	local v3 = setmetatable({
		player = p1,
		bones_handed_in = v1.bones_handed_in or 0,
		pages_handed_in = v1.pages_handed_in or 0
	}, t)

	Promise.defer(function() --[[ Line: 39 | Upvalues: DataM (ref), v3 (copy) ]]
		local v1 = DataM.get_store(v3.player)

		if not v1 then
			return
		end

		local v2 = v1:get("purchase_limit_manager")

		if v2 then
			v2:remove_entries_with_context("summer_2026_irish_setter")
		end
	end)

	local v4 = DataM.get_store(v3.player)
	local v5 = if v4 then v4:get("inventory") else v4

	if v5 then
		for i = 1, v3.pages_handed_in do
			v3.pages_handed_in = v3.pages_handed_in - 1
			v5:add_item(KindDB.summer_2026_campfire_page)
		end
	end

	return v3
end
function t.serialize_for_save(p1) --[[ serialize_for_save | Line: 62 ]]
	return {
		bones_handed_in = p1.bones_handed_in
	}
end
function t.serialize_for_client_replication(p1) --[[ serialize_for_client_replication | Line: 68 ]]
	return {
		bones_handed_in = p1.bones_handed_in
	}
end
function t.mark_changed(p1) --[[ mark_changed | Line: 74 | Upvalues: DataM (copy) ]]
	DataM.get_store(p1.player):push_update("buried_treasure_manager")
end

return t