-- https://lua.expert

local v1 = require("./SpotlightShared")
local t1 = {
    get_stage_centre = function(p1) -- get_stage_centre | line: 5
        -- upvalues: v1 (copy)
        local CONSTANTS = v1.CONSTANTS

        return p1:WaitForChild(CONSTANTS.scene_aim_point_folder_name):WaitForChild(CONSTANTS.scene_stage_centre_name).Position
    end
}

return table.freeze(t1)
