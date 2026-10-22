-- global halloween game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026
--remote добавления twig
local args = {
	{
		unique = "2_4e8695cc63c644cdbe8a118d7efe0688" -- id of twig item
	}
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("Halloween2026/JacobeanPigeonNestContributeTwig"):InvokeServer(unpack(args))

--code
-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.JacobeanPigeonNest.JacobeanPigeonNestClient
-- Took 0.48s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local ClientData = load("ClientData")
local GameplayFX = load("GameplayFX")
local InteractionsEngine = load("InteractionsEngine")
local InventoryDB = load("InventoryDB")
local v1 = load("new:NPCController")
local PetEntityHelper = load("PetEntityHelper")
local PetPerformanceName = load("PetPerformanceName")
local UIManager = load("UIManager")
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local JacobeanPigeonNestBillboard = require(script.Parent.JacobeanPigeonNestBillboard)
local JacobeanPigeonNestConstants = require(script.Parent.JacobeanPigeonNestConstants)
local JacobeanPigeonNestNet = require(script.Parent.JacobeanPigeonNestNet)
local STORE_KEY = JacobeanPigeonNestConstants.STORE_KEY
local twigs_to_complete = JacobeanPigeonNestConstants.twigs_to_complete
local v2 = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v4 = {}

local function get_state() -- line 33 | captures: ClientData, STORE_KEY
    return ClientData.get(STORE_KEY) or { twigs_contributed = 0 }
end

local function contributed_count() -- line 39 | captures: ClientData, STORE_KEY, twigs_to_complete
    local twigs_contributed = (ClientData.get(STORE_KEY) or { twigs_contributed = 0 }).twigs_contributed
    return (math.clamp(twigs_contributed, 0, twigs_to_complete))
end

local function get_owned_twig_unique() -- line 43 | captures: ClientData, JacobeanPigeonNestConstants
    local toys = ClientData.get("inventory").toys
    if toys then
        for v5, v6 in toys do
            if v6.kind == JacobeanPigeonNestConstants.TWIG_KIND then
                return v6.unique
            end
        end
    end
    return nil
end

local function hint(v7) -- line 56 | captures: UIManager
    UIManager.apps.HintApp:hint({
        overridable = true,
        yields = false,
        text = v7
    })
end

local function fly_twig_into_nest(v8, v9) -- line 66 | captures: Players, GameplayFX, TweenPromise, v3
    local Character = Players.LocalPlayer.Character
    Character = Character and (Character:FindFirstChild("RightHand") or Character:FindFirstChild("HumanoidRootPart"))
    if not (Character and Character:IsA("BasePart")) then
        return
    end
    local v10 = v8:Clone()
    v10.Transparency = 0
    v10.Anchored = true
    v10.CanCollide = false
    v10.CanTouch = false
    v10.CanQuery = false
    v10.CFrame = Character.CFrame
    v10.Parent = v9
    TweenPromise.new(v10, v3, { CFrame = v8.CFrame }):expect()
    v10:Destroy()
    GameplayFX.emit_poof(v8.Position, 8, 1)
end

local function place_pigeon(v11, v12, v13, v14, v15) -- line 88 | captures: GameplayFX, InventoryDB, v1, PetEntityHelper, PetPerformanceName, UIManager, JacobeanPigeonNestConstants
    local v16 = InventoryDB.pets[JacobeanPigeonNestConstants.PET_KIND]
    local v17 = v1.create_from_pet_kind_async(v16.kind)
    if v14[1] then
        v13:GiveTask(v17)
        local root = v17.entity.base.root
        local v18 = v11.CFrame * CFrame.new(0, v17.entity.base.humanoid.HipHeight + root.Size.Y / 2, 0)
        root.Anchored = true
        v17.model:PivotTo(v18)
        v17.model.Parent = v12
        PetEntityHelper.stage_performance(v17.entity, {
            name = PetPerformanceName.AnchorInPlace,
            options = { custom_cframe = v18 }
        })
        PetEntityHelper.stage_performance(v17.entity, {
            name = PetPerformanceName.AnimationProvider,
            options = { anim_name = v16.anims.sit }
        })
        UIManager.apps.PlayerNameApp:add_npc_id(v17.model, v16.name)
        if v15 then
            GameplayFX.emit_poof(v11.Position)
            UIManager.apps.SpeechBubbleApp:create(root, "Marvellous service!", {
                always_on_top = true,
                length = 3
            })
        end
    else
        v17:destroy()
    end
end

local function get_shop_interaction(v19) -- line 134 | captures: JacobeanPigeonNestConstants
    local v20 = ("pets:%*"):format(JacobeanPigeonNestConstants.PET_KIND)
    for v21, v22 in v19.interactions do
        if v22.tag == v20 then
            return v22
        end
    end
    return nil
end

function v4.setup(v23, v24, v25, v26) -- line 144 | captures: ClientData, GameplayFX, InteractionsEngine, UIManager, React, ReactRoblox, TweenPromise, JacobeanPigeonNestBillboard, JacobeanPigeonNestConstants, JacobeanPigeonNestNet, STORE_KEY, twigs_to_complete, v2, fly_twig_into_nest, place_pigeon
    local NestOrigin = v23.NestOrigin
    local Twig = v23.Twig
    local PigeonSpawn = v23.PigeonSpawn
    local InteractionPart = v23.InteractionPart
    local v27 = {}
    local v28 = {}
    local STAGE_COUNT = JacobeanPigeonNestConstants.STAGE_COUNT
    for v29 = 1, STAGE_COUNT do
        local v30 = v23.NestStages[("Nest%*"):format(v29)]
        v27[v29] = v30
        v28[v30] = v30.CanCollide
    end
    local v31 = { true }
    v26:GiveTask(function() -- line 160 | captures: v31
        v31[1] = false
    end)
    local v32 = ReactRoblox.createRoot(Instance.new("Folder"))
    v26:GiveTask(function() -- line 165 | captures: v32
        v32:unmount()
    end)
    local v33 = {}
    v26:GiveTask(function() -- line 170 | captures: v33
        for v34, v35 in v33 do
            v35:cancel()
        end
    end)

    local function set_stage_shown(v36, v37, v38) -- line 176 | captures: v28, v33, GameplayFX, TweenPromise, v2
        local function v39(v40, ...)
            table.insert(v40, ...)
        end

        v36.CanCollide = v37 and v28[v36]
        v36.CanTouch = v37
        v36.CanQuery = v37
        if v37 then
            if v38 and v36.Transparency > 0 then
                v39(v33, TweenPromise.new(v36, v2, { Transparency = 0 }))
                GameplayFX.emit_poof(v36.Position, 12, 1)
            else
                v36.Transparency = 0
            end
        else
            v36.Transparency = 1
        end
    end

    local v41 = ("pets:%*"):format(JacobeanPigeonNestConstants.PET_KIND)
    local v42 = false
    local v43
    for v44, v45 in v25.interactions do
        if v45.tag == v41 then
            v43 = v45
            v42 = true
            break
        end
    end
    if not v42 then
        v43 = nil
    end
    local v46
    local v47 = false
    local v48 = v43

    local function refresh() -- line 194 | captures: v46, v47, v24, v26, NestOrigin, Twig, PigeonSpawn, v27, v31, v32, set_stage_shown, v48, ClientData, React, ReactRoblox, JacobeanPigeonNestBillboard, JacobeanPigeonNestConstants, STORE_KEY, twigs_to_complete, place_pigeon
        local twigs_contributed = (ClientData.get(STORE_KEY) or { twigs_contributed = 0 }).twigs_contributed
        local v49 = math.clamp(twigs_contributed, 0, twigs_to_complete)
        local v50 = if v46 == nil then false else v46 < v49
        v46 = v49
        local v51 = if v49 == 0 then 0 else 1
        Twig.Transparency = v51
        local v52 = JacobeanPigeonNestConstants.stages_shown(v49)
        for v53, v54 in v27 do
            set_stage_shown(v54, v53 <= v52, v50)
        end
        v32:render(ReactRoblox.createPortal(React.createElement(JacobeanPigeonNestBillboard, {
            count = v49,
            goal = twigs_to_complete
        }), NestOrigin))
        if JacobeanPigeonNestConstants.is_complete(v49) then
            v48:unhide("JacobeanPigeonNestIncomplete")
        else
            v48:hide("JacobeanPigeonNestIncomplete")
        end
        if JacobeanPigeonNestConstants.is_complete(v49) and not v47 then
            v47 = true
            task.spawn(place_pigeon, PigeonSpawn, v24, v26, v31, v50)
        end
    end

    refresh()
    v26:GiveTask(ClientData.register_callback_plus_existing(STORE_KEY, refresh))
    local v55 = false
    local v56 = {
        part = InteractionPart,
        horizontal_dist = JacobeanPigeonNestConstants.INTERACTION_HORIZONTAL_DIST,
        text = function() -- text | line 235
            return "Place Twig"
        end,
        is_visible = function() -- is_visible | line 238 | captures: ClientData, JacobeanPigeonNestConstants, STORE_KEY, twigs_to_complete
            local is_complete = JacobeanPigeonNestConstants.is_complete
            local twigs_contributed = (ClientData.get(STORE_KEY) or { twigs_contributed = 0 }).twigs_contributed
            return not is_complete((math.clamp(twigs_contributed, 0, twigs_to_complete)))
        end
    }

    function v56.on_selected() -- line 241 | captures: v55, v24, Twig, ClientData, UIManager, JacobeanPigeonNestConstants, JacobeanPigeonNestNet, STORE_KEY, twigs_to_complete, fly_twig_into_nest
        if v55 then
            return
        end
        local is_complete = JacobeanPigeonNestConstants.is_complete
        local twigs_contributed = (ClientData.get(STORE_KEY) or { twigs_contributed = 0 }).twigs_contributed
        if is_complete((math.clamp(twigs_contributed, 0, twigs_to_complete))) then
            return
        end
        local toys = ClientData.get("inventory").toys
        local unique
        if toys then
            local v57 = false
            for v58, v59 in toys do
                if v59.kind == JacobeanPigeonNestConstants.TWIG_KIND then
                    unique = v59.unique
                    v57 = true
                    break
                end
            end
            if not v57 then
                unique = nil
            end
        end
        if unique then
            v55 = true
            local unique_2 = unique
            local v60, v61 = pcall(function() -- line 253 | captures: unique_2, v24, Twig, JacobeanPigeonNestNet, fly_twig_into_nest
                fly_twig_into_nest(Twig, v24)
                JacobeanPigeonNestNet.ContributeTwig:invoke_server_async({ unique = unique_2 })
            end)
            v55 = false
            if not v60 then
                error(v61)
            end
        else
            UIManager.apps.HintApp:hint({
                text = "You need a Twig to do that",
                overridable = true,
                yields = false
            })
        end
    end

    v26:GiveTask((InteractionsEngine:register(v56)))
end

function v4.render(v62, v63, v64) -- line 267 | captures: JacobeanPigeonNestConstants, v4
    v4.setup(v62[JacobeanPigeonNestConstants.NEST_FOLDER_NAME], v62, v63, v64)
end

return v4

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.JacobeanPigeonNest.JacobeanPigeonNestConstants
-- Took 0.31s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local v1 = {
    STORE_KEY = "halloween_2026_jacobean_pigeon_nest_manager",
    TWIG_KIND = "halloween_2026_twig",
    PET_KIND = "halloween_2026_jacobean_pigeon",
    PET_MODEL = "Halloween2026JacobeanPigeon",
    EVENT_NAME = "Halloween",
    twigs_to_complete = 8,
    STAGE_COUNT = 5,
    NEST_FOLDER_NAME = "Nest",
    INTERACTION_HORIZONTAL_DIST = 14
}

function v1.remaining_twigs(v2) -- line 18 | captures: v1
    local v3 = v1.twigs_to_complete - v2
    return (math.max(0, v3))
end

function v1.is_complete(v4) -- line 22 | captures: v1
    return v1.twigs_to_complete <= v4
end

function v1.stages_shown(v5) -- line 28 | captures: v1
    local twigs_to_complete = v1.twigs_to_complete
    local STAGE_COUNT = v1.STAGE_COUNT
    local v6 = math.clamp(v5, 0, twigs_to_complete)
    if v6 <= 0 then
        return 0
    end
    if v1.is_complete(v6) then
        return STAGE_COUNT
    end
    local v7 = (v6 - 1) * (STAGE_COUNT - 1) / (twigs_to_complete - 1)
    return math.floor(v7) + 1
end

return v1

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.JacobeanPigeonNest.JacobeanPigeonNestManager
-- Took 0.28s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local Class = require(ReplicatedStorage.SharedModules.Class)
local DataM = load("DataM")
local JacobeanPigeonNestConstants = require(script.Parent.JacobeanPigeonNestConstants)
local JacobeanPigeonNestManager = Class("JacobeanPigeonNestManager")

function JacobeanPigeonNestManager.__init(v1, v2, v3) -- line 11
    v1.player = v2
    v1.twigs_contributed = 0
    if v3 then
        local twigs_contributed = v3.twigs_contributed
        if typeof(twigs_contributed) == "number" then
            local twigs_contributed = v3.twigs_contributed
            local v4 = math.floor(twigs_contributed)
            v1.twigs_contributed = math.max(0, v4)
        end
    end
end

function JacobeanPigeonNestManager.serialize_for_save(v5) -- line 20
    return { twigs_contributed = v5.twigs_contributed }
end

function JacobeanPigeonNestManager.serialize_for_client_replication(v6) -- line 26
    return v6:serialize_for_save()
end

function JacobeanPigeonNestManager.mark_changed(v7) -- line 30
    if v7.store_slot then
        v7.store_slot:push_update()
    end
end

function JacobeanPigeonNestManager._get_inventory(v8) -- line 36 | captures: DataM
    return DataM.get_store(v8.player):get("inventory")
end

function JacobeanPigeonNestManager._is_in_range(v9) -- line 42 | captures: DataM
    local char_wrapper = DataM.get_store(v9.player):get("char_wrapper")
    if char_wrapper then
        local location = char_wrapper:get_property("location")
        if location == nil then
            return false
        end
        return location.destination_id == "HauntedHotel"
    end
    return false
end

function JacobeanPigeonNestManager.try_contribute_twig(v10, v11) -- line 56 | captures: JacobeanPigeonNestConstants
    if JacobeanPigeonNestConstants.is_complete(v10.twigs_contributed) then
        return {
            ok = false,
            reason = "nest_complete"
        }
    end
    if v10:_is_in_range() then
        local v12 = v10:_get_inventory():get_item(v11)
        if not (v12 and v12.kind == JacobeanPigeonNestConstants.TWIG_KIND) then
            return {
                ok = false,
                reason = "missing_item"
            }
        end
        v12:destroy()
        v10.twigs_contributed += 1
        v10:mark_changed()
        return {
            ok = true,
            twigs_contributed = v10.twigs_contributed
        }
    end
    return {
        ok = false,
        reason = "too_far"
    }
end

return JacobeanPigeonNestManager

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.JacobeanPigeonNest.JacobeanPigeonNestNetService
-- Took 0.28s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataM = require(ReplicatedStorage.Fsys).load("DataM")
local JacobeanPigeonNestNet = require(script.Parent.JacobeanPigeonNestNet)
local JacobeanPigeonNestConstants = require(script.Parent.JacobeanPigeonNestConstants)
local v1 = {}

local function get_manager(v2) -- line 10 | captures: DataM, JacobeanPigeonNestConstants
    local v3 = DataM.get_store(v2)
    return v3 and v3:get(JacobeanPigeonNestConstants.STORE_KEY)
end

function v1.start_server() -- line 15 | captures: DataM, JacobeanPigeonNestNet, JacobeanPigeonNestConstants
    JacobeanPigeonNestNet.ContributeTwig:on_server_invoke(function(v4, v5) -- line 16 | captures: DataM, JacobeanPigeonNestConstants
        local v6 = DataM.get_store(v4)
        local v7 = v6 and v6:get(JacobeanPigeonNestConstants.STORE_KEY)
        if v7 then
            return v7:try_contribute_twig(v5.unique)
        end
        return {
            ok = false,
            reason = "not_ready"
        }
    end)
end

return v1

