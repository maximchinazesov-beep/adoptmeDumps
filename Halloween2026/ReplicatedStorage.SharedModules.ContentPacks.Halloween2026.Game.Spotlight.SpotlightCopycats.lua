-- https://lua.expert

local v1 = require("./SpotlightRigs")
local v2 = require("./SpotlightShared")
local t1 = {
    get_stack = function(p1) -- get_stack | line: 21
        -- upvalues: v2 (copy)
        local CONSTANTS = v2.CONSTANTS
        local v3 = v2.get_resources()
        local v4 = (p1:WaitForChild(CONSTANTS.copycat_shaft_name, CONSTANTS.resource_wait_timeout) or error((("%* has no %* to hang copycats from"):format(p1:GetFullName(), CONSTANTS.copycat_shaft_name)))):WaitForChild(CONSTANTS.copycat_pole_name):WaitForChild(CONSTANTS.copycat_pole_bottom_name).WorldCFrame
        local spotlight_activation_times = CONSTANTS.spotlight_activation_times
        local v5 = table.create(#spotlight_activation_times)

        for i = #spotlight_activation_times, 1, -1 do
            local v6 = if i ~= 1 or CONSTANTS.bottom_spotlight_uses_side_model then CONSTANTS.copycat_side_name else CONSTANTS.copycat_bottom_name
            local v7 = v3:WaitForChild(v6, CONSTANTS.resource_wait_timeout) or error((("%* has no %* to stack"):format(v3:GetFullName(), v6)))
            local v8 = v7:WaitForChild(CONSTANTS.copycat_pole_name)
            local v9 = v8:WaitForChild(CONSTANTS.copycat_pole_top_name)
            local v10 = v8:WaitForChild(CONSTANTS.copycat_pole_bottom_name)
            local v11 = v4 * v9.WorldCFrame:Inverse()

            v5[i] = {
                template = v7,
                offset = v11,
                activates_at = spotlight_activation_times[i]
            }
            v4 = v11 * v10.WorldCFrame
        end

        return v5
    end,
    get_opening = function(p2) -- get_opening | line: 52
        local n1 = 1

        for v12, v13 in p2 do
            if v13.activates_at > p2[n1].activates_at then
                n1 = v12
            end
        end

        return n1
    end,
    get_rest = function(p3, p4) -- get_rest | line: 63
        -- upvalues: v1 (copy), v2 (copy)
        local CONSTANTS = v2.CONSTANTS
        local v14 = p3[p4]
        local v15 = v1.get_frames(v14.template, v14.offset)
        local v16 = (p4 - 1) * 2 * 3.141592653589793 / #p3
        local v17 = if p4 == 1 then 0 else CONSTANTS.copycat_min_tilt
        local v20 = Vector3.new(math.cos(v16), 0, -math.sin(v16)) * CONSTANTS.spotlight_radius
        local v21 = v1.aim(v15, v15.yaw.Position + v20, 0)
        local v22 = v1.get_beam(v15, v21, v17 - 1.5707963267948966)

        return {
            frames = v15,
            angle = v16,
            min_tilt = v17,
            yaw = v21,
            beam = v22,
            target = v22.Position + v22.LookVector * CONSTANTS.spotlight_start_drop
        }
    end
}

return table.freeze(t1)
