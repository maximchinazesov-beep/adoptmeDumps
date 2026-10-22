-- https://lua.expert

require("./SpotlightServerState")

local v1 = require("./SpotlightShared")
local t1 = {}

local function build_buffer(p1, p2, p3, p4) -- line: 9
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local t2 = {}

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.CanQuery = true
            descendant.CanCollide = true
            descendant.Anchored = true
            table.insert(t2, descendant)
        end
    end

    table.sort(t2, function(p5, p6) -- line: 23
        -- upvalues: p2 (copy)
        local v2 = p5.Position - p2
        local v3 = p6.Position - p2

        return math.atan2(v2.Z, v2.X) < math.atan2(v3.Z, v3.X)
    end)

    local t3 = {}

    for v5, v6 in t2 do
        t3[v5] = {
            standing = true,
            board = v6,
            weight = CONSTANTS.obstacle_base_weight,
            buffer_index = p3,
            index = v5
        }
    end

    return {
        slots = t3,
        wraps = p4
    }
end

local function dampen_around(p7, p8) -- line: 44
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local v7 = p7.obstacles.buffers[p8.buffer_index]
    local v8 = #v7.slots

    for i = -CONSTANTS.obstacle_break_spread, CONSTANTS.obstacle_break_spread do
        local v9 = p8.index + i
        local v10, v11

        if v7.wraps then
            v10 = (v9 - 1) % v8 + 1
            v11 = false
        elseif v9 < 1 or v8 < v9 then
            v11 = true
        else
            v10 = v9
            v11 = false
        end

        if not v11 then
            v7.slots[v10].weight *= CONSTANTS.obstacle_break_falloff
        end
    end
end

function t1.connect_all_obstacles(p9, p10, p11) -- line: 63
    -- upvalues: v1 (copy), build_buffer (copy)
    local CONSTANTS = v1.CONSTANTS
    local v12 = p10:FindFirstChild(CONSTANTS.obstacle_ground_folder_name) or error((("%* has no %* to ring"):format(p10:GetFullName(), CONSTANTS.obstacle_ground_folder_name)))

    for _, child in p10:GetChildren() do
        local v13 = build_buffer(child, p11, #p9.obstacles.buffers + 1, child == v12)

        table.insert(p9.obstacles.buffers, v13)

        for _, v14 in v13.slots do
            p9.obstacles.slot_of[v14.board] = v14
        end
    end

    p9.obstacles.raycast_params.FilterDescendantsInstances = { p10 }
end

function t1.get_cover(p12, p13, p14) -- line: 81
    local v15 = workspace:Raycast(p13, p14 - p13, p12.obstacles.raycast_params)

    if v15 then
        return v15.Instance
    end

    return nil
end

function t1.choose_target(p15) -- line: 87
    local n1 = 0

    for _, v16 in p15.obstacles.buffers do
        for _, v18 in v16.slots do
            if v18.standing then
                n1 += v18.weight
            end
        end
    end

    if not (n1 <= 0) then
        local v19 = p15.random:NextNumber() * n1

        for _, v20 in p15.obstacles.buffers do
            local v21 = v19

            for _, v22 in v20.slots do
                if v22.standing then
                    v21 -= v22.weight

                    if v21 <= 0 then
                        return v22.board
                    end
                end

                v19 = v21
            end
        end
    end

    return nil
end

function t1.knock_down(p16, p17) -- line: 118
    -- upvalues: v1 (copy), dampen_around (copy)
    local v23 = if p17 then p16.obstacles.slot_of[p17] else nil

    if not (v23 and v23.standing) then
        return
    end

    v23.standing = false
    v23.board.CanQuery = false
    v23.board.CanCollide = false
    v23.board:SetAttribute(v1.CONSTANTS.obstacle_knocked_down_attribute, true)
    dampen_around(p16, v23)
end

return table.freeze(t1)
