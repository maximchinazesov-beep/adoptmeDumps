-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightCandycornServer")
local v2 = require("./SpotlightCannons")
local v3 = require("./SpotlightNet")

require("./SpotlightServerState")

local v4 = require("./SpotlightShared")
local t1 = {}

local function get_nearest(p1, p2) -- line: 13
    local v5
    local n1 = 1e999

    for v6, v7 in p1.cannons.cannons do
        local Magnitude = ((p2 - v7.Position) * Vector3.new(1, 0, 1)).Magnitude

        if Magnitude < n1 then
            n1 = Magnitude
            v5 = v6
        end
    end

    return v5 or error("Spotlight has no cannons to share its targets between")
end

function t1.connect_cannons(p3, p4, p5, p6) -- line: 25
    -- upvalues: RunService (copy), v1 (copy), v4 (copy), get_nearest (copy)
    local CONSTANTS = v4.CONSTANTS

    for i = 1, CONSTANTS.cannon_count do
        local v8 = ("%*%*"):format(CONSTANTS.cannon_name_prefix, i)
        local v9 = p4:FindFirstChild(v8)

        assert(v9 and v9:IsA("BasePart"), (("%* needs a %* part"):format(p4:GetFullName(), v8)))
        p3.cannons.cannons[i] = v9
    end

    for v12 in p3.cannons.cannons do
        p3.cannons.spots[v12] = {}
    end

    for _, child in p5:GetChildren() do
        if child:IsA("BasePart") and child.Name ~= CONSTANTS.cannon_drop_name then
            table.insert(p3.cannons.spots[get_nearest(p3, child.Position)], child.Position)
        end
    end

    for v14, v15 in p3.cannons.spots do
        assert(#v15 > 0, (("%*%* has no candy corn spawners nearest it to stream at"):format(CONSTANTS.cannon_name_prefix, v14)))
    end

    for _, descendant in p6:GetDescendants() do
        if descendant:IsA("BasePart") then
            p3.cannons.markers[descendant] = get_nearest(p3, descendant.Position)
        end
    end

    p3.maid:GiveTask(RunService.Heartbeat:Connect(function() -- line: 59
        -- upvalues: p3 (copy), p5 (copy), v1 (copy)
        local elapsed = os.clock()
        local drops = p3.cannons.drops

        for i = #drops, 1, -1 do
            local v18 = drops[i]

            if v18.at <= elapsed then
                table.remove(drops, i)
                v1.drop(p3, p5, v18.position, v18.aim)
            end
        end
    end))
end

function t1.fire(p7, p8) -- line: 73
    -- upvalues: v2 (copy), v4 (copy)
    local CONSTANTS = v4.CONSTANTS
    local elapsed = os.clock()
    local t2 = {}

    for _, v19 in p8 do
        local v20 = p7.cannons.markers[v19] or error((("%* isn't a marker spawn any cannon covers"):format((v19:GetFullName()))))

        t2[v20] = t2[v20] or v19.Position
    end

    for v21, v22 in p7.cannons.cannons do
        local v23 = t2[v21]

        if v23 then
            local v24 = elapsed + CONSTANTS.cannon_aim_lead + (v21 - 1) * CONSTANTS.cannon_volley_stagger

            for v25, v26 in v2.get_landings(v23, v2.get_seed(v24, v21)) do
                table.insert(p7.cannons.drops, {
                    position = v26,
                    aim = v23,
                    at = v24 + CONSTANTS.cannon_volley_flight_duration + (v25 - 1) * CONSTANTS.cannon_volley_shot_interval
                })
            end

            task.delay(v24 - elapsed - CONSTANTS.cannon_aim_lead, function() -- line: 103
                -- upvalues: CONSTANTS (copy), v23 (copy), v22 (copy)
                v22:SetAttribute(CONSTANTS.cannon_fire_target_attribute, v23)
            end)
            task.delay(v24 - elapsed, function() -- line: 106
                -- upvalues: CONSTANTS (copy), v24 (copy), v22 (copy)
                v22:SetAttribute(CONSTANTS.cannon_fired_attribute, v24)
            end)
        end
    end

    return CONSTANTS.cannon_aim_lead + (#p7.cannons.cannons - 1) * CONSTANTS.cannon_volley_stagger + (CONSTANTS.cannon_volley_shot_count - 1) * CONSTANTS.cannon_volley_shot_interval
end

local function scatter(p9, p10, p11) -- line: 116
    return p10 + Vector3.new(p9.random:NextNumber(-p11, p11), 0, p9.random:NextNumber(-p11, p11))
end

local function add_group(p12, p13, p14, p15) -- line: 120
    -- upvalues: v4 (copy)
    local CONSTANTS = v4.CONSTANTS
    local cannon_stream_spread = CONSTANTS.cannon_stream_spread
    local v32 = p15 + Vector3.new(p12.random:NextNumber(-cannon_stream_spread, cannon_stream_spread), 0, p12.random:NextNumber(-cannon_stream_spread, cannon_stream_spread))

    table.insert(p13, v32)
    table.insert(p14, p15)

    for _ = 2, p12.random:NextInteger(CONSTANTS.cannon_stream_min_candycorn, CONSTANTS.cannon_stream_max_candycorn) do
        local cannon_stream_cluster_spread = CONSTANTS.cannon_stream_cluster_spread

        table.insert(p13, v32 + Vector3.new(p12.random:NextNumber(-cannon_stream_cluster_spread, cannon_stream_cluster_spread), 0, p12.random:NextNumber(-cannon_stream_cluster_spread, cannon_stream_cluster_spread)))
        table.insert(p14, p15)
    end
end

local function get_side_spots(p16, p17, p18, p19) -- line: 133
    -- upvalues: v4 (copy)
    local CONSTANTS = v4.CONSTANTS
    local Unit = ((p18[p19] - p17) * Vector3.new(1, 0, 1)).Unit
    local t4 = {
        {},
        {}
    }

    for v36, v37 in p18 do
        local Unit2 = ((v37 - p17) * Vector3.new(1, 0, 1)).Unit
        local v39 = math.atan2(Unit:Cross(Unit2).Y, (Unit:Dot(Unit2)))
        local v40 = v37 - p18[p19]
        local v41 = (v40 * Vector3.new(1, 0, 1)).Magnitude <= CONSTANTS.cannon_stream_fan_reach and math.abs(v40.Y) <= CONSTANTS.cannon_stream_fan_rise

        if v36 ~= p19 and v41 and math.abs(v39) <= CONSTANTS.cannon_stream_fan_angle then
            table.insert(t4[if v39 < 0 then 1 else 2], v37)
        end
    end

    local t5 = {}

    for _, v43 in t4 do
        if #v43 > 0 then
            table.insert(t5, v43[p16.random:NextInteger(1, #v43)])
        end
    end

    return t5
end

function t1.stream(p20, p21) -- line: 166
    -- upvalues: v3 (copy), v4 (copy), add_group (copy), get_side_spots (copy)
    local CONSTANTS = v4.CONSTANTS
    local v45 = CONSTANTS.cannon_aim_lead + CONSTANTS.cannon_stream_flight_duration
    local v46 = os.clock() + p21
    local n2 = 0

    while os.clock() < v46 do
        n2 = n2 % #p20.cannons.cannons + 1

        local v47 = p20.cannons.spots[n2]
        local v48 = p20.random:NextInteger(1, #v47)
        local t6 = {}
        local t7 = {}

        add_group(p20, t6, t7, v47[v48])

        for _, v49 in get_side_spots(p20, p20.cannons.cannons[n2].Position, v47, v48) do
            add_group(p20, t6, t7, v49)
        end

        local v50 = workspace:GetServerTimeNow() + CONSTANTS.cannon_aim_lead

        v3.cannon_stream:fire_clients(p20.listeners, {
            cannon = n2,
            landings = t6,
            fires_at = v50,
            lands_at = v50 + CONSTANTS.cannon_stream_flight_duration
        })

        for v51, v52 in t6 do
            table.insert(p20.cannons.drops, {
                position = v52,
                aim = t7[v51],
                at = os.clock() + v45
            })
        end

        task.wait(CONSTANTS.cannon_stream_interval)
    end
end

return table.freeze(t1)
