-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local v1 = require("./SpotlightShared")
local t1 = {
    get_static_map_name = function(p1) -- get_static_map_name | line: 7
        -- upvalues: v1 (copy)
        return p1 .. v1.CONSTANTS.scene_static_map_suffix
    end,
    get_player_spawn = function(p2) -- get_player_spawn | line: 13
        -- upvalues: v1 (copy)
        local CONSTANTS = v1.CONSTANTS

        return (p2:FindFirstChild(CONSTANTS.spawn_name) or error((("%* has no %* to enter at"):format(p2:GetFullName(), CONSTANTS.spawn_name)))).CFrame
    end,
    get_join_zone = function(p3) -- get_join_zone | line: 22
        -- upvalues: ReplicatedStorage (copy), v1 (copy)
        local CONSTANTS = v1.CONSTANTS
        local v2 = p3:FindFirstChild(CONSTANTS.join_zone_name)

        if v2 then
            return v2
        end

        local v3 = p3:FindFirstChild(CONSTANTS.join_zone_marker_name) or error((("%* has no %* to stand the join zone on"):format(p3:GetFullName(), CONSTANTS.join_zone_marker_name)))
        local clone = ReplicatedStorage[CONSTANTS.resource_folder_name][CONSTANTS.join_zone_resource_name]:Clone()

        clone.Name = CONSTANTS.join_zone_name
        clone:PivotTo(v3.CFrame)
        clone.Parent = p3

        return clone
    end
}

return table.freeze(t1)
