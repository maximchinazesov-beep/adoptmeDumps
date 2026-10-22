-- https://lua.expert

local v1 = require("./SpotlightShared")
local t1 = {
    get_seed = function(p1, p2) -- get_seed | line: 5
        return math.floor(p1 * 1000) + p2
    end,
    get_landings = function(p3, p4) -- get_landings | line: 9
        -- upvalues: v1 (copy)
        local CONSTANTS = v1.CONSTANTS
        local v3 = Random.new(p4)
        local t2 = {}

        for i = 1, CONSTANTS.cannon_volley_shot_count do
            t2[i] = p3 + Vector3.new(v3:NextNumber(-1, 1), 0, v3:NextNumber(-1, 1)) * CONSTANTS.cannon_volley_spread + Vector3.new(0, 1, 0) * CONSTANTS.cannon_landing_lift
        end

        return t2
    end
}

return table.freeze(t1)
