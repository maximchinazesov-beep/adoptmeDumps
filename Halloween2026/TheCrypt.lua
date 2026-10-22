-- crypt типо граница хуй знает

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptClient
-- Took 0.3s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local ClientData = load("ClientData")
local ClientToolManager = load("ClientToolManager")
local CryptNet = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptNet)
local CryptConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptConstants)
local v1 = {}

function v1.has_key() -- line 12 | captures: ClientData, CryptConstants
    local inventory = ClientData.get("inventory")
    local v2 = inventory and inventory.toys
    if v2 then
        for v3, v4 in v2 do
            if v4.kind == CryptConstants.KEY_ITEM_KIND then
                return true
            end
        end
    end
    return false
end

function v1.is_key_equipped() -- line 26 | captures: ClientToolManager, CryptConstants
    return ClientToolManager.is_kind_equipped({
        category = "toys",
        kind = CryptConstants.KEY_ITEM_KIND
    })
end

function v1.register_state_changed(v5) -- line 33 | captures: ClientData, CryptConstants
    return ClientData.register_callback_plus_existing(CryptConstants.STORE_KEY, function(v6, v7) -- line 34 | captures: v5
        v5(v7)
    end)
end

function v1.unlock_padlock_async(v8, v9) -- line 39 | captures: CryptNet
    return CryptNet.UnlockPadlock:invoke_server_async({
        floor_index = v8,
        padlock_index = v9
    })
end

function v1.claim_tomb_spider_async() -- line 46 | captures: CryptNet
    return CryptNet.ClaimTombSpider:invoke_server_async()
end

return v1

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptConstants
-- Took 0.29s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local v1 = {
    STORE_KEY = "halloween_2026_crypt_manager",
    DESTINATION_ID = "TheCrypt",
    KEY_ITEM_KIND = "halloween_2026_rusty_key",
    KEY_TOOL_NAME = "Halloween2026RustyKey",
    TOMB_SPIDER_KIND = "halloween_2026_tomb_spider",
    FLOORS = {
        {
            coffins = 4,
            level_text = "LOWER LEVEL I"
        },
        {
            template = "Crypt_2026_Floor01",
            coffins = 4,
            level_text = "LOWER LEVEL II"
        },
        {
            template = "Crypt_2026_Floor02",
            coffins = 6,
            level_text = "LOWER LEVEL III"
        },
        {
            template = "Crypt_2026_Floor03",
            coffins = 8,
            level_text = "LOWER LEVEL IV"
        },
        {
            template = "FinalRoom",
            coffins = 0,
            is_final = true
        }
    }
}

v1.FLOOR_COUNT = #v1.FLOORS
v1.GENERATED_FOLDER_NAME = "Generated"
v1.BLOCKED_SPAWN_ATTRIBUTE = "blocked"
v1.PADLOCK_OPENED_EVENT = "halloween_2026_crypt_padlock_opened"
v1.CURRENCY_RESOURCE_ITEM_TYPE = "Halloween2026Crypt"
v1.CURRENCY_RESOURCE_ID = "coffin_reward"
v1.REWARD_GRANT_DELAY = 3
return v1

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptManager
-- Took 0.35s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ContentPackAssetsServer = require(ServerScriptService.new.modules.ContentPacks.ContentPackAssetsServer)
local load = require(ReplicatedStorage.Fsys).load
local AltCurrencyData = load("AltCurrencyData")
local Class = require(ReplicatedStorage.SharedModules.Class)
local DataM = load("DataM")
local NotificationManager = load("NotificationManager")
local InventoryDB = require(ReplicatedStorage.ClientDB.Inventory.InventoryDB)
local CryptConstants = require(script.Parent.CryptConstants)
local CryptLayout = require(script.Parent.CryptLayout)
local CryptManager = Class("CryptManager")

local function sanitize_counts(v1) -- line 17
    local v2 = {}
    if typeof(v1) == "table" then
        for v3, v4 in v1 do
            if typeof(v3) == "string" and typeof(v4) == "number" then
                v2[v3] = v4
            end
        end
    end
    return v2
end

function CryptManager.__init(v5, v6, v7) -- line 29 | captures: CryptLayout, sanitize_counts
    v5.player = v6
    v5.reward_counts = sanitize_counts(v7 and v7.reward_counts)
    if v7 and v7.floors then
        v5.seed = v7.seed
        v5.opened = CryptLayout.opened_set(v7.opened)
        v5.floors = v7.floors
    else
        v5.seed = CryptLayout.new_seed()
        v5.opened = {}
        v5.floors = {}
        task.defer(function() -- line 44 | captures: v5
            v5:reset_run()
        end)
    end
end

function CryptManager.serialize_for_save(v8) -- line 50 | captures: CryptLayout
    return {
        seed = v8.seed,
        opened = CryptLayout.opened_list(v8.opened),
        floors = v8.floors,
        reward_counts = table.clone(v8.reward_counts)
    }
end

function CryptManager.serialize_for_client_replication(v9) -- line 59
    return v9:serialize_for_save()
end

function CryptManager._roll_floor(v10, v11, v12, v13, v14) -- line 64 | captures: ContentPackAssetsServer, CryptConstants, CryptLayout
    local v15 = ContentPackAssetsServer.get_asset("Interiors", CryptConstants.DESTINATION_ID)
    return CryptLayout.roll_floor(v14, v15.StartRoom, CryptLayout.projected_counts(v10.reward_counts, v12, v13), Random.new(v11 + v14))
end

function CryptManager.mark_changed(v16) -- line 74
    if v16.store_slot then
        v16.store_slot:push_update()
    end
end

function CryptManager.reset_run(v17) -- line 80 | captures: CryptLayout
    local v18 = CryptLayout.new_seed()
    local v19 = v17:_roll_floor(v18, {}, {}, 1)
    v17.seed = v18
    v17.opened = {}
    v17.floors = { v19 }
    v17:mark_changed()
end

function CryptManager._get_inventory(v20) -- line 89 | captures: DataM
    return DataM.get_store(v20.player):get("inventory")
end

function CryptManager._get_deferred_rewards(v21) -- line 93 | captures: DataM
    return DataM.get_store(v21.player):get("deferred_rewards_manager")
end

function CryptManager._get_equip_manager(v22) -- line 97 | captures: DataM
    return DataM.get_store(v22.player):get("equip_manager")
end

function CryptManager._get_equipped_key(v23) -- line 101 | captures: CryptConstants
    for v24, v25 in v23:_get_inventory():get_items_with_kind(CryptConstants.KEY_ITEM_KIND) do
        if v25:get_equipped_tool() then
            return v25
        end
    end
    return nil
end

function CryptManager._is_in_crypt(v26) -- line 112 | captures: DataM, CryptConstants
    local char_wrapper = DataM.get_store(v26.player):get("char_wrapper")
    if char_wrapper then
        local location = char_wrapper:get_property("location")
        if location == nil then
            return false
        end
        return location.destination_id == CryptConstants.DESTINATION_ID
    end
    return false
end

function CryptManager._grant_reward(v27, v28) -- line 122 | captures: AltCurrencyData, InventoryDB, CryptConstants
    local v29 = v27:_get_deferred_rewards()
    if v28.category == "currency" then
        local v30 = if v28.kind == "bucks" then "money" else AltCurrencyData.name
        v29:register_currency(v30, v28.amount, CryptConstants.CURRENCY_RESOURCE_ID, CryptConstants.CURRENCY_RESOURCE_ITEM_TYPE, CryptConstants.REWARD_GRANT_DELAY)
    else
        local v31 = v27:_get_inventory()
        local v32 = InventoryDB[v28.category][v28.kind]
        local v33 = v28.count or 1
        for v34 = 1, v33 do
            v29:register_item(v31:add_item(v32).unique_id, CryptConstants.REWARD_GRANT_DELAY)
        end
    end
end

function CryptManager.try_unlock_padlock(v35, v36, v37) -- line 147 | captures: NotificationManager, CryptConstants, CryptLayout
    if v35:_is_in_crypt() then
        local v38, v39 = CryptLayout.can_unlock(v35.floors, v35.opened, v36, v37)
        if v38 then
            local v40 = v35:_get_equipped_key()
            if v40 then
                local v41 = CryptLayout.floor_contents(v35.floors[v36])[v37]
                local v42 = v41.type == "ladder"
                local v43, v44
                if v42 then
                    v43 = v35:_roll_floor(v35.seed, v35.floors, v35.opened, v36 + 1)
                else
                    v44 = CryptLayout.is_grantable(v41.reward)
                end
                if not v42 and v44 or v42 then
                    if not v42 then
                        v43 = nil
                    end
                    v40:destroy()
                    local v45 = v35:_get_inventory():get_items_with_kind(CryptConstants.KEY_ITEM_KIND)
                    if v45[1] then
                        v35:_get_equip_manager():equip(v45[1])
                    end
                    v35.opened[CryptLayout.padlock_key(v36, v37)] = true
                    if v43 then
                        v35.floors[v36 + 1] = v43
                    else
                        v35:_grant_reward(v41.reward)
                        v35.reward_counts[v41.reward_id] = (v35.reward_counts[v41.reward_id] or 0) + CryptLayout.grant_size(v41.reward)
                    end
                    v35:mark_changed()
                    NotificationManager.indicate_event({
                        name = CryptConstants.PADLOCK_OPENED_EVENT,
                        player = v35.player,
                        options = {
                            floor_index = v36,
                            padlock_index = v37,
                            reward_id = v41.reward_id
                        }
                    })
                    return {
                        ok = true,
                        reward_id = v41.reward_id
                    }
                end
                return {
                    ok = false,
                    reason = "reward_unavailable"
                }
            end
            return {
                ok = false,
                reason = "no_key_equipped"
            }
        end
        return {
            ok = false,
            reason = v39
        }
    end
    return {
        ok = false,
        reason = "too_far"
    }
end

function CryptManager.try_claim_tomb_spider(v46) -- line 210 | captures: InventoryDB, CryptConstants, CryptLayout
    if v46:_is_in_crypt() then
        if CryptLayout.is_floor_reached(v46.floors, v46.opened, CryptConstants.FLOOR_COUNT) then
            v46:reset_run()
            local v47 = v46:_get_inventory():add_item(InventoryDB.pets[CryptConstants.TOMB_SPIDER_KIND])
            pcall(function() -- line 224 | captures: v46, v47
                v46:_get_equip_manager():equip(v47)
            end)
            return { ok = true }
        end
        return {
            ok = false,
            reason = "not_reached"
        }
    end
    return {
        ok = false,
        reason = "too_far"
    }
end

return CryptManager

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptNetService
-- Took 0.3s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataM = require(ReplicatedStorage.Fsys).load("DataM")
local CryptNet = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptNet)
local CryptConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptConstants)
local v1 = {}

local function get_manager(v2) -- line 11 | captures: DataM, CryptConstants
    local v3 = DataM.get_store(v2)
    return v3 and v3:get(CryptConstants.STORE_KEY)
end

function v1.start_server() -- line 16 | captures: DataM, CryptNet, CryptConstants
    CryptNet.UnlockPadlock:on_server_invoke(function(v4, v5) -- line 17 | captures: DataM, CryptConstants
        local v6 = DataM.get_store(v4)
        local v7 = v6 and v6:get(CryptConstants.STORE_KEY)
        if v7 then
            return v7:try_unlock_padlock(v5.floor_index, v5.padlock_index)
        end
        return {
            ok = false,
            reason = "not_ready"
        }
    end)
    CryptNet.ClaimTombSpider:on_server_invoke(function(v8) -- line 25 | captures: DataM, CryptConstants
        local v9 = DataM.get_store(v8)
        local v10 = v9 and v9:get(CryptConstants.STORE_KEY)
        if v10 then
            return v10:try_claim_tomb_spider()
        end
        return {
            ok = false,
            reason = "not_ready"
        }
    end)
end

return v1

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptRewardSign
-- Took 0.33s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CryptConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptConstants)
local CryptLayout = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.TheCrypt.CryptLayout)
local FormatHelper = require(ReplicatedStorage.SharedModules.FormatHelper)
local v1 = {}

local function clear_cloned_rows(v2) -- line 9
    for v3, v4 in v2:GetChildren() do
        if v4:IsA("GuiObject") and v4.Name ~= "RewardTemplate" then
            v4:Destroy()
        end
    end
end

local function fill_row(v5, v6, v7, v8) -- line 17 | captures: FormatHelper
    v5.Name = tostring(v6)
    v5.LayoutOrder = v6
    v5.Visible = true
    local Icon = v5.Icon
    Icon.Image = v7.reward.image
    if v8 then
        Icon.ImageColor3 = Color3.fromRGB(90, 90, 90)
        Icon.ImageTransparency = 0.35
    else
        Icon.ImageColor3 = Color3.new(1, 1, 1)
        Icon.ImageTransparency = 0
    end
    local Amount = v5.Amount
    Amount.Visible = v7.amount ~= nil
    if not v7.amount then
        return
    end
    Amount.Text = FormatHelper.add_number_commas(v7.amount)
    if v8 then
        Amount.TextColor3 = Color3.fromRGB(90, 90, 90)
        Amount.TextTransparency = 0.35
    else
        Amount.TextColor3 = Color3.new(1, 1, 1)
        Amount.TextTransparency = 0
    end
end

function v1.render(v9, v10, v11, v12) -- line 47 | captures: CryptConstants, CryptLayout, clear_cloned_rows, fill_row
    local SurfaceGui = v9.SurfaceGui
    SurfaceGui.Enabled = true
    SurfaceGui.LevelNumber.Text = CryptConstants.FLOORS[v10].level_text
    local Frame = SurfaceGui.Frame
    local RewardTemplate = Frame.RewardTemplate
    RewardTemplate.Visible = false
    clear_cloned_rows(Frame)
    for v13, v14 in v11 do
        if v14.type ~= "ladder" then
            local v15 = RewardTemplate:Clone()
            fill_row(v15, v13, v14, v12[CryptLayout.padlock_key(v10, v13)] == true)
            v15.Parent = Frame
        end
    end
end

return v1

-- remote открытия гроба
local args = {
	{
		padlock_index = 1,
		floor_index = 1
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/UnlockPadlock"):InvokeServer(unpack(args))

local args = {
	{
		padlock_index = 2,
		floor_index = 1
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/UnlockPadlock"):InvokeServer(unpack(args))

local args = {
	{
		padlock_index = 3,
		floor_index = 1
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/UnlockPadlock"):InvokeServer(unpack(args))

local args = {
	{
		padlock_index = 4, -- id padlock 
		floor_index = 1 -- id floor
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/UnlockPadlock"):InvokeServer(unpack(args))


local args = {
	{
		padlock_index = 1,
		floor_index = 2 -- тут этаж
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/UnlockPadlock"):InvokeServer(unpack(args))

local args = {
	{
		padlock_index = 5,
		floor_index = 3 -- этаж
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/UnlockPadlock"):InvokeServer(unpack(args))

local args = {
	{
		padlock_index = 1,
		floor_index = 4
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/UnlockPadlock"):InvokeServer(unpack(args))


game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/ClaimTombSpider"):InvokeServer() -- лутаем награду


-- id предмета halloween_2026_rusty_key
