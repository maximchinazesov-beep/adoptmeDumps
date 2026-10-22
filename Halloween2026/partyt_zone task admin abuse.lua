-- Script Path: game:GetService("ReplicatedStorage").ClientModules.Game.ToolWrapper
-- Took 0.36s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local load = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
local BackpackLockTracker = load("BackpackLockTracker")
local RouterClient = load("RouterClient")
local InventoryDB = load("InventoryDB")
local ToolDB = load("ToolDB")
local Class = load("Class")
local AnimationManager = load("AnimationManager")
local ClientData = load("ClientData")
local ItemHider = load("ItemHider")
local Debug = load("Debug")
local ScriptUtil = load("ScriptUtil")
local Signal = load("Signal")
local v1 = load("package:Sift")
local v2 = load("Debug").create_log()
local v3 = { "Tele" }
local ToolWrapper = Class("ToolWrapper")

local function is_on_tool_blacklist(v4) -- line 23 | captures: v3
    return table.find(v3, v4.Name) ~= nil
end

local function get_tool(v5, v6) -- line 27 | captures: ScriptUtil, v3
    for v7, v8 in pairs(game.Players.LocalPlayer.Backpack:GetChildren()) do
        if table.find(v3, v8.Name) == nil and v8:WaitForChild("unique", 10) and v8.unique.Value == v6.unique then
            return v8
        end
    end
    local v9 = ScriptUtil.create_continue({ timeout = 60 })
    local v10 = game.Players.LocalPlayer.Backpack.ChildAdded:connect(function(v11) -- line 36 | captures: v6, v9, v3
        if table.find(v3, v11.Name) == nil and v11:WaitForChild("unique").Value == v6.unique then
            wait()
            v9.continue(v11)
        end
    end)
    local v12 = v9.yield()
    v10:Disconnect()
    return v12
end

local function preload_animations_async(v13) -- line 50 | captures: AnimationManager, v1
    local v14 = v1.List.map(v13, function(v15) -- line 51 | captures: AnimationManager
        return AnimationManager.get_track(v15)
    end)
    game:GetService("ContentProvider"):PreloadAsync(v14)
end

function ToolWrapper.__init(v16, v17, v18, v19) -- line 58 | captures: InventoryDB, ToolDB, AnimationManager, Debug, Signal, v1, v2, get_tool
    v16.item_data = v17
    v16.tool_use_start_callback = v18
    v16.tool_use_end_callback = v19
    v16.entry = InventoryDB[v17.category][v17.id]
    v16.tool_entry = ToolDB[v16.entry.tool] or {}
    v16.unequipped_signal = Signal.new()
    if game.Players.LocalPlayer.Character == nil or game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") == nil then
        return
    end
    local v20
    if v16.entry.category == "pets" then
    elseif v16.entry.anims and v16.entry.anims.hold then
        v20 = v16.entry.anims.hold
    elseif v16.entry.category == "pet_accessories" then
        v20 = "SandwichHold"
    end
    task.spawn(function() -- line 83 | captures: v20, v16, AnimationManager
        if not v20 or v16.destroyed then
            return
        end
        local v21 = AnimationManager.get_track(v20)
        local Animator = game.Players.LocalPlayer.Character.Humanoid:WaitForChild("Animator")
        if v16.destroyed then
            return
        end
        v16.track = Animator:LoadAnimation(v21)
        v16.track:Play()
        if v16.destroyed then
            v16.track:Stop()
        end
    end)
    task.spawn(function() -- line 99 | captures: v16, v17, Debug, v2, get_tool
        v16.tool = get_tool(v16.entry, v17)
        v2("Found tool", v16.tool)
        if not (v16.tool ~= nil) or v16.destroyed then
            return
        end
        v2("Attempting to equip")
        game.Players.LocalPlayer.Character.Humanoid:EquipTool(v16.tool)
        if v16.tool_entry.equipped then
            Debug.pcall_warn_error(function() -- line 113 | captures: v16
                v16.tool_entry.equipped(v16.entry, v16)
            end)
        end
    end)
    task.spawn(function() -- line 119 | captures: v16, AnimationManager, v1
        if not v16.entry.anims then
            return
        end
        local v22 = {}
        for v23, v24 in pairs(v16.entry.anims) do
            if typeof(v24) == "string" then
                table.insert(v22, v24)
            end
        end
        local v25 = v1.List.map(v22, function(v26) -- line 51 | captures: AnimationManager
            return AnimationManager.get_track(v26)
        end)
        game:GetService("ContentProvider"):PreloadAsync(v25)
    end)
end

function ToolWrapper.get_uses_left(v27) -- line 134 | captures: ClientData
    local v28 = ((ClientData.get("inventory") or {})[v27.item_data.category] or {})[v27.item_data.unique]
    if v28 == nil then
        return 0
    end
    return v28.properties.uses_left or v27.entry.uses or 1
end

function ToolWrapper.get_unique(v29) -- line 146
    return v29.item_data.unique
end

function ToolWrapper.get_updated_item_data(v30) -- line 150 | captures: ClientData
    return ((ClientData.get("inventory") or {})[v30.item_data.category] or {})[v30.item_data.unique]
end

function ToolWrapper.use(v31, v32) -- line 158 | captures: load, BackpackLockTracker, RouterClient, ItemHider, Debug, Signal
    if v31.in_use then
        if v31.entry.tool_use_properties and v31.entry.tool_use_properties.allow_cancellation_partway_through_use and v31.early_cancellation_signal then
            v31.early_cancellation_signal:fire()
        end
    elseif not load("ObbyM").is_in_obby() then
        local UIManager = load("UIManager")
        if not (UIManager.is_visible("AvatarEditorApp") or UIManager.is_visible("MannequinPurchaseApp")) and not UIManager.is_visible("TradeApp") and not UIManager.is_visible("PlayerSpectateApp") then
            if ItemHider.is_item_useable(v31.entry) then
                local v33 = v31:get_uses_left()
                if v33 <= 0 then
                    if v31.tool_entry.on_no_uses_left then
                        v31.tool_entry.on_no_uses_left(v31.entry, v31)
                    end
                elseif not (BackpackLockTracker.is_locked(v31.item_data) and v31.item_data.category == "gifts") then
                    local client_use_cooldown = v31.tool_entry.client_use_cooldown
                    if client_use_cooldown and v31.last_use_time and os.clock() - v31.last_use_time < client_use_cooldown then
                        return
                    end
                    v31.last_use_time = os.clock()
                    v31.in_use = true
                    v31.early_cancellation_signal = Signal.new()
                    if v31.tool_use_start_callback then
                        v31.tool_use_start_callback()
                    end
                    local v34

                    local function server_use_end(v35) -- line 217 | captures: v34, v31, RouterClient
                        if v34 then
                            return
                        end
                        v34 = true
                        if v31.tool_entry.wait_for_server_use then
                            return RouterClient.get("ToolAPI/ServerUseTool"):InvokeServer(v31.item_data.unique, "END", v35)
                        end
                        task.spawn(function() -- line 226 | captures: v35, v31, RouterClient
                            RouterClient.get("ToolAPI/ServerUseTool"):InvokeServer(v31.item_data.unique, "END", v35)
                        end)
                        return true
                    end

                    local function server_use_start() -- line 236 | captures: v31, RouterClient
                        if v31.tool_entry.wait_for_server_use then
                            return RouterClient.get("ToolAPI/ServerUseTool"):InvokeServer(v31.item_data.unique, "START")
                        end
                        task.spawn(function() -- line 240 | captures: v31, RouterClient
                            RouterClient.get("ToolAPI/ServerUseTool"):InvokeServer(v31.item_data.unique, "START")
                        end)
                    end

                    server_use_start()
                    local v36
                    if v31.tool_entry.client_use then
                        local v37
                        local v38 = Debug.pcall_warn_error(function() -- line 253 | captures: v36, v37, v31, v32, v33, server_use_end
                            v37, v36 = v31.tool_entry.client_use(v31.entry, server_use_end, v31, v33, v32, v31.early_cancellation_signal, v31.unequipped_signal)
                        end)
                        local v39
                        if v37 == false then
                            v31.in_use = false
                            if v31.tool_use_end_callback then
                                v31.tool_use_end_callback()
                            end
                            v39 = false
                        elseif v38 then
                            v39 = true
                        else
                            v31.in_use = false
                            if v31.tool_use_end_callback then
                                v31.tool_use_end_callback()
                            end
                            v39 = false
                        end
                        if not v39 then
                            return
                        end
                    end
                    local v40 = v31:get_updated_item_data()
                    local v41 = UIManager.apps.BackpackApp:client_predict_item_uses_left(v40)
                    task.spawn(function() -- line 272 | captures: v36, server_use_end, v41
                        if not server_use_end(v36) then
                            v41()
                        end
                    end)
                    if v31.early_cancellation_signal then
                        v31.early_cancellation_signal:destroy()
                        v31.early_cancellation_signal = nil
                    end
                    v31.in_use = false
                    if v31.tool_use_end_callback then
                        v31.tool_use_end_callback()
                    end
                else
                    UIManager.apps.HintApp:hint({
                        text = "You cannot open locked gifts!",
                        overridable = true,
                        length = 2.5,
                        yields = false
                    })
                end
            else
                UIManager.apps.DialogApp:dialog({
                    text = "This item is currently disabled.",
                    button = "Okay"
                })
            end
        end
    end
end

function ToolWrapper.is_equipped(v42) -- line 290
    return not v42.destroyed
end

function ToolWrapper.destroy(v43) -- line 294 | captures: Debug
    if v43.destroyed then
        return
    end
    v43.destroyed = true
    if v43.track then
        v43.track:Stop()
    end
    if v43.tool_entry.unequipped then
        Debug.pcall_warn_error(function() -- line 304 | captures: v43
            v43.tool_entry.unequipped(v43.entry, v43)
        end)
    end
    v43.unequipped_signal:fire()
    v43.unequipped_signal:destroy()
    if v43.item_data.category ~= "strollers" and v43.tool and v43.tool.Parent then
        v43.tool.Parent = game.Players.LocalPlayer.Backpack
    end
end

return ToolWrapper
