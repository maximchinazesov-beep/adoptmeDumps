-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function get_facing(p1, p2) -- line: 15
    return (math.atan2(p2.Z - p1.Z, p2.X - p1.X))
end

local function get_assigned(p3, p4, p5) -- line: 19
    -- upvalues: v2 (copy)
    local illuminators = p3.illuminators
    local v5 = illuminators.assigned[p5]

    if v5 then
        return v5
    end

    local t2 = {}

    for v6, v7 in illuminators.illuminators do
        t2[v6] = v7.facing
    end

    local t3 = {}
    local t4 = {}

    for _, child in p5:GetChildren() do
        if child:IsA("BasePart") then
            table.insert(t3, child)

            local Position = child.Position

            table.insert(t4, (math.atan2(Position.Z - p4.Z, Position.X - p4.X)))
        end
    end

    local t5 = {}
    local v11 = v2.pair_by_angle(t2, t4, v2.CONSTANTS.illuminator_reach_angle)

    for v12, v13 in v11 do
        t5[t3[v13]] = v12
    end

    if #t3 > 0 and next(v11) == nil then
        warn((("[Spotlight] - No illuminator can reach every marker in %* without crossing beams"):format((p5:GetFullName()))))
    end

    illuminators.assigned[p5] = t5

    return t5
end

local function get_lit(p6, p7) -- line: 59
    -- upvalues: get_assigned (copy)
    local illuminators = p6.illuminators

    if illuminators.version == p6.markers.version then
        return illuminators.lit
    end

    local t6 = {}

    for v14, v15 in p6.markers.visuals do
        local Parent = v14.Parent
        local v16 = Parent and get_assigned(p6, p7, Parent)[v14]

        if v16 and not v15.retreat then
            t6[v16] = v14
        end
    end

    illuminators.lit = t6
    illuminators.version = p6.markers.version

    return t6
end

local function step(p8, p9, p10) -- line: 80
    -- upvalues: v1 (copy), v2 (copy), get_lit (copy)
    local CONSTANTS = v2.CONSTANTS
    local v17 = v1.get_fizzle(p8.power.rack)
    local v18 = get_lit(p8, p9)

    for v19, v20 in p8.illuminators.illuminators do
        local v21 = v18[v19]

        v1.turn_rig(v20.rig, if v21 then v21.Position else p9, CONSTANTS.illuminator_turn_speed, p10, v17)

        local v22 = if v21 then 1 else CONSTANTS.illuminator_idle_output

        v20.output = v2.approach(v20.output, v22, p10 * CONSTANTS.illuminator_turn_speed)
        v1.set_lamp(v20.lamp, 0, v17 * v20.output, 0)
    end
end

function t1.connect_all_illuminators(p11, p12, p13) -- line: 104
    -- upvalues: RunService (copy), v1 (copy), v2 (copy), step (copy)
    local CONSTANTS = v2.CONSTANTS

    for i = 1, CONSTANTS.illuminator_count do
        local v23 = p12:WaitForChild((("%*%*"):format(CONSTANTS.illuminator_name_prefix, i)))
        local v24 = v1.get_rig(p11, v23)

        v24.aim = p13

        local illuminators = p11.illuminators.illuminators
        local t7 = {
            rig = v24,
            lamp = v1.get_lamp(p11, v23, false),
            output = CONSTANTS.illuminator_idle_output
        }
        local basePosition = v24.base.Position

        t7.facing = math.atan2(basePosition.Z - p13.Z, basePosition.X - p13.X)
        illuminators[i] = t7
    end

    p11.maid:GiveTask(RunService.PreRender:Connect(function(p14) -- line: 125
        -- upvalues: p11 (copy), p13 (copy), step (copy)
        step(p11, p13, p14)
    end))
end

return table.freeze(t1)
