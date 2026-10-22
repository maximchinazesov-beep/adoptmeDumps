-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local load = require(ReplicatedStorage.Fsys).load
local CFrameAnimationUtil = load("CFrameAnimationUtil")
local Maid = load("Maid")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightPrefabs")
local v3 = require("./SpotlightShared")
local v4 = require("./SpotlightShatterTakes")
local t1 = {}
local t2 = {}

local function get_shatter(p1) -- line: 17
    -- upvalues: CFrameAnimationUtil (copy), v4 (copy), t2 (copy)
    local v5 = v4.boards[("%*.%*"):format(p1.Parent.Name, p1.Name)] or error((("%* has no shatter take"):format((p1:GetFullName()))))
    local v6 = t2[v5]

    if not v6 then
        v6 = CFrameAnimationUtil.import_animation(buffer.fromstring(v4.takes[v5]))
        t2[v5] = v6
    end

    return v6
end

local function build_prefab(p2, p3) -- line: 30
    -- upvalues: v2 (copy)
    local v7 = v2.clone(p3)

    for _, descendant in v7:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanQuery = false
        end
    end

    v7.Parent = p2.visuals

    local Transparency = p3.Transparency

    p3.Transparency = 1
    p2.maid:GiveTask(function() -- line: 44
        -- upvalues: p3 (copy), Transparency (copy)
        p3.Transparency = Transparency
    end)

    return v7
end

local function shake_nearby(p4, p5) -- line: 51
    -- upvalues: v1 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v8 = 1 - (workspace.CurrentCamera.CFrame.Position - p5).Magnitude / CONSTANTS.obstacle_shake_radius

    if not (v8 <= 0) then
        v1.shake(p4, {
            envelope = "decay",
            amplitude = CONSTANTS.obstacle_shake_amplitude * v8,
            frequency = CONSTANTS.obstacle_shake_frequency,
            time = CONSTANTS.obstacle_shake_duration
        })
    end
end

local function shatter(p6, p7, p8) -- line: 68
    -- upvalues: CFrameAnimationUtil (copy), v1 (copy), v3 (copy), get_shatter (copy), shake_nearby (copy)
    local CONSTANTS = v3.CONSTANTS
    local v9 = CFrameAnimationUtil.new_track(get_shatter(p7), p8)

    v9.playing = true
    CFrameAnimationUtil.apply_frame(v9, 0)
    table.insert(p6.obstacles.tracks, v9)
    v1.play_layered_sound(CONSTANTS.sound_obstacle_hit, p7)
    v1.play_vfx(p6, CONSTANTS.vfx_obstacle_shatter, p7.Position)
    shake_nearby(p6, p7.Position)
end

local function step_shatters(p9, p10, p11) -- line: 81
    -- upvalues: CFrameAnimationUtil (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local tracks = p9.obstacles.tracks
    local v10 = (workspace.CurrentCamera.CFrame.Position - p10) * Vector3.new(1, 0, 1)

    for i = #tracks, 1, -1 do
        local v11 = tracks[i]

        if (v11.origin.Position - p10):Dot(v10) < 0 then
            v11.stride = CONSTANTS.obstacle_shatter_far_stride
        else
            v11.stride = CONSTANTS.obstacle_shatter_stride
        end

        CFrameAnimationUtil.step_keyframes(v11, p11)

        if not v11.playing then
            for _, v12 in v11.parts do
                v12.CanCollide = false
            end

            tracks[i] = tracks[#tracks]
            tracks[#tracks] = nil
        end
    end
end

local function connect_board(p12, p13) -- line: 103
    -- upvalues: Maid (copy), v3 (copy), build_prefab (copy), shatter (copy)
    local CONSTANTS = v3.CONSTANTS

    if not p13:IsA("BasePart") then
        return
    end

    local v13 = build_prefab(p12, p13)
    local v14 = Maid.new()

    p12.maid:GiveTask(v14)

    local function changed() -- line: 114
        -- upvalues: p12 (copy), p13 (copy), CONSTANTS (copy), v13 (copy), v14 (copy), shatter (copy)
        if p13:GetAttribute(CONSTANTS.obstacle_knocked_down_attribute) == true then
            v14:DoCleaning()
            shatter(p12, p13, v13)
        end
    end

    v14:GiveTask(p13:GetAttributeChangedSignal(CONSTANTS.obstacle_knocked_down_attribute):Connect(changed))
    v14:GiveTask(p13.AncestryChanged:Connect(function() -- line: 122
        -- upvalues: p13 (copy), v13 (copy), v14 (copy)
        if not p13:IsDescendantOf(workspace) then
            v14:DoCleaning()
            v13:Destroy()
        end
    end))

    if p13:GetAttribute(CONSTANTS.obstacle_knocked_down_attribute) == true then
        v14:DoCleaning()
        shatter(p12, p13, v13)
    end
end

function t1.connect_all_obstacles(p14, p15, p16) -- line: 131
    -- upvalues: RunService (copy), step_shatters (copy), connect_board (copy)
    for _, descendant in p15:GetDescendants() do
        connect_board(p14, descendant)
    end

    p14.maid:GiveTask(p15.DescendantAdded:Connect(function(p17) -- line: 140
        -- upvalues: p14 (copy), connect_board (copy)
        connect_board(p14, p17)
    end))
    p14.maid:GiveTask(RunService.PostSimulation:Connect(function(p18) -- line: 144
        -- upvalues: p14 (copy), p16 (copy), step_shatters (copy)
        step_shatters(p14, p16, p18)
    end))
end

return table.freeze(t1)
