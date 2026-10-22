-- https://lua.expert

local v1 = require("./SpotlightShared")
local t1 = {}

function t1.get_frames(p1, p2) -- line: 10
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local v2 = p1:WaitForChild(CONSTANTS.rig_yaw_hinge_name)
    local v3 = p1:WaitForChild(CONSTANTS.rig_pitch_hinge_name)
    local Attachment0, Attachment1 = v2.Attachment0, v2.Attachment1
    local Attachment0_2 = v3.Attachment0

    return {
        yaw = p2 * Attachment0.WorldCFrame,
        pitch = Attachment1.WorldCFrame:ToObjectSpace(Attachment0_2.WorldCFrame)
    }
end

local function turn_toward(p3, p4, p5) -- line: 26
    local v6 = (p4.Y * p5.Z - p4.Z * p5.Y) / math.sqrt(p5.Y ^ 2 + p5.Z ^ 2)
    local v8 = math.sqrt(p3.Y ^ 2 + p3.Z ^ 2)

    return math.atan2(p3.Z, p3.Y) - math.atan2(p5.Z, p5.Y) + math.asin((math.clamp(v6 / v8, -1, 1)))
end

function t1.aim(p6, p7, p8) -- line: 33
    -- upvalues: v1 (copy), turn_toward (copy)
    local v13 = p6.yaw:PointToObjectSpace(p7)
    local v15 = if math.sqrt(v13.Y ^ 2 + v13.Z ^ 2) > v1.CONSTANTS.rig_yaw_dead_zone then turn_toward(v13, p6.pitch.Position, p6.pitch.LookVector) else p8
    local v16 = (p6.yaw * CFrame.Angles(v15, 0, 0) * p6.pitch):PointToObjectSpace(p7)
    local v18 = math.sqrt(v16.Y ^ 2 + v16.Z ^ 2)

    return v15, math.atan2(v16.Z, v16.Y) - -1.5707963267948966 + math.asin((math.clamp(0 / v18, -1, 1)))
end

function t1.get_beam(p9, p10, p11) -- line: 44
    return p9.yaw * CFrame.Angles(p10, 0, 0) * p9.pitch * CFrame.Angles(p11, 0, 0)
end

return table.freeze(t1)
