-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local v1 = require("./SpotlightCandycorn")

require("./SpotlightServerState")

local v2 = require("./SpotlightShared")
local t1 = {}

function t1.get_score(p1) -- line: 11
    -- upvalues: v2 (copy)
    return p1:GetAttribute(v2.CONSTANTS.candycorn_score_attribute) or 0
end

local function add_score(p2, p3) -- line: 15
    -- upvalues: v2 (copy), t1 (copy)
    p2:SetAttribute(v2.CONSTANTS.candycorn_score_attribute, t1.get_score(p2) + p3)
end

local function get_radius(p4) -- line: 19
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS

    return p4:GetAttribute(CONSTANTS.candycorn_radius_attribute) or CONSTANTS.candycorn_collect_radius
end

local function within_rate(p5, p6, p7) -- line: 25
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local v3 = p5.candycorn.rate[p6]

    if not v3 or p7 - v3.window >= 1 then
        p5.candycorn.rate[p6] = {
            count = 1,
            window = p7
        }
    else
        if v3.count >= CONSTANTS.candycorn_max_pickup_rate then
            return false
        end

        v3.count += 1
    end

    return true
end

function t1.on_reported(p8, p9, p10, p11) -- line: 43
    -- upvalues: v1 (copy), v2 (copy), t1 (copy), within_rate (copy)
    local CONSTANTS = v2.CONSTANTS
    local candycorn = p8.candycorn
    local v4 = candycorn.by_part[p10]
    local v5

    if v4 and not v4.collected[p9] then
        local Character = p9.Character

        v5 = Character and Character.PrimaryPart

        if v5 then
            local CONSTANTS2 = v2.CONSTANTS

            if not ((p9:GetAttribute(CONSTANTS2.candycorn_radius_attribute) or CONSTANTS2.candycorn_collect_radius) + CONSTANTS.candycorn_collect_tolerance < (v5.Position - p10.Position).Magnitude) and not (t1.get_score(p9) >= CONSTANTS.candycorn_max_per_round) and within_rate(p8, p9, p11) then
                v4.collected[p9] = true
                p10:SetAttribute(v1.get_collected_attribute(p9), true)
                candycorn.respawn_tail += 1
                candycorn.respawns[candycorn.respawn_tail] = {
                    spawner_data = v4,
                    player = p9,
                    at = p11
                }
                p9:SetAttribute(v2.CONSTANTS.candycorn_score_attribute, t1.get_score(p9) + 1)
            end
        end
    end
end

local function respawn_due(p12, p13) -- line: 76
    -- upvalues: v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local candycorn = p12.candycorn

    while candycorn.respawn_head <= candycorn.respawn_tail do
        local v6 = candycorn.respawns[candycorn.respawn_head]

        if p13 - v6.at < CONSTANTS.candycorn_respawn_duration then
            break
        end

        v6.spawner_data.collected[v6.player] = nil
        v6.spawner_data.spawner:SetAttribute(v1.get_collected_attribute(v6.player), nil)
        candycorn.respawns[candycorn.respawn_head] = nil
        candycorn.respawn_head += 1
    end
end

local function connect_spawner(p14, p15) -- line: 94
    p15.CanQuery = true
    p14.candycorn.by_part[p15] = {
        spawner = p15,
        collected = {}
    }
    p14.maid:GiveTask(p15.AncestryChanged:Connect(function() -- line: 99
        -- upvalues: p14 (copy), p15 (copy)
        if not p15:IsDescendantOf(workspace) then
            p14.candycorn.by_part[p15] = nil
        end
    end))
end

function t1.hit(p16, p17) -- line: 106
    -- upvalues: Players (copy), v2 (copy), t1 (copy)
    local CONSTANTS = v2.CONSTANTS

    for v7, v8 in p16 do
        local v9 = Players:GetPlayerFromCharacter(v7) or error((("Spotlight hit %*, which has no player"):format((v7:GetFullName()))))
        local v10 = t1.get_score(v9)
        local v13 = math.min(math.floor(v10 * CONSTANTS.steal_share) + CONSTANTS.steal_base, v10)
        local v14 = -v13

        v9:SetAttribute(v2.CONSTANTS.candycorn_score_attribute, t1.get_score(v9) + v14)
        v7:SetAttribute(CONSTANTS.spotlight_discovered_attribute, p17)
        v7:SetAttribute(CONSTANTS.spotlight_caught_by_attribute, v8)
        v7:SetAttribute(CONSTANTS.spotlight_stolen_attribute, v13)
        v7:SetAttribute(CONSTANTS.spotlight_caught_attribute, p17)
    end
end

function t1.publish_radius(p18, p19) -- line: 124
    -- upvalues: v2 (copy)
    p18:SetAttribute(v2.CONSTANTS.candycorn_radius_attribute, p19)
end

function t1.increase_collection_range(p20) -- line: 128
    -- upvalues: v2 (copy), t1 (copy)
    local publish_radius = t1.publish_radius
    local CONSTANTS = v2.CONSTANTS

    publish_radius(p20, (p20:GetAttribute(CONSTANTS.candycorn_radius_attribute) or CONSTANTS.candycorn_collect_radius) + v2.CONSTANTS.marker_range_bonus)
end

function t1.forget_player(p21, p22) -- line: 132
    p21.candycorn.rate[p22] = nil
end

function t1.drop(p23, p24, p25, p26) -- line: 136
    -- upvalues: Debris (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local Part = Instance.new("Part")

    Part.Name = CONSTANTS.cannon_drop_name
    Part.Size = CONSTANTS.candycorn_spawner_size
    Part.CFrame = CFrame.new(p25)
    Part.Anchored = true
    Part.CanCollide = false
    Part.Transparency = 1
    Part:SetAttribute(CONSTANTS.cannon_drop_aim_attribute, p26)
    Debris:AddItem(Part, CONSTANTS.candycorn_respawn_duration)
    p23.maid:GiveTask(Part)
    Part.Parent = p24
end

function t1.connect_candycorn_spawners(p27, p28) -- line: 154
    -- upvalues: RunService (copy), v1 (copy), respawn_due (copy), connect_spawner (copy)
    p27.maid:GiveTask(v1.connect_spawners(p28, function(p29) -- line: 155
        -- upvalues: p27 (copy), connect_spawner (copy)
        connect_spawner(p27, p29)
    end))
    p27.maid:GiveTask(RunService.Heartbeat:Connect(function() -- line: 159
        -- upvalues: p27 (copy), respawn_due (copy)
        respawn_due(p27, os.clock())
    end))
end

return table.freeze(t1)
