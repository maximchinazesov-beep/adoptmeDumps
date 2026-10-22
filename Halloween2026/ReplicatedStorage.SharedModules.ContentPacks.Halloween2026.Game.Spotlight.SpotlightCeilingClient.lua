-- https://lua.expert

local RunService = game:GetService("RunService")

require("./SpotlightClientState")

local v1 = require("./SpotlightShared")
local t1 = {}

local function place(p1, p2) -- line: 13
    for v2, v3 in p1 do
        v2.CFrame = CFrame.Angles(0, v3.sign * p2, 0) * v3.rest.Rotation + v3.rest.Position
    end
end

function t1.connect_rings(p3, p4, p5) -- line: 19
    -- upvalues: RunService (copy), v1 (copy), place (copy)
    local CONSTANTS = v1.CONSTANTS
    local v4 = CONSTANTS.scene_direction_signs[p5] or error((("unhandled scene direction %*"):format(p5)))
    local t2 = {
        [CONSTANTS.ceiling_orange_ring_name] = v4,
        [CONSTANTS.ceiling_yellow_ring_name] = -v4
    }
    local t3 = {}

    local function track(p6) -- line: 32
        -- upvalues: t2 (copy), t3 (copy)
        local v5 = t2[p6.Name]

        if v5 and p6:IsA("BasePart") then
            t3[p6] = {
                rest = p6.CFrame,
                sign = v5
            }
        end
    end

    for _, descendant in p4:GetDescendants() do
        local v6 = t2[descendant.Name]

        if v6 and descendant:IsA("BasePart") then
            t3[descendant] = {
                rest = descendant.CFrame,
                sign = v6
            }
        end
    end

    p3.maid:GiveTask(p4.DescendantAdded:Connect(track))
    p3.maid:GiveTask(p4.DescendantRemoving:Connect(function(p7) -- line: 44
        -- upvalues: t3 (copy)
        t3[p7] = nil
    end))
    p3.maid:GiveTask(RunService.PreRender:Connect(function() -- line: 48
        -- upvalues: CONSTANTS (copy), t3 (copy), place (copy)
        local ceiling_spin_period = CONSTANTS.ceiling_spin_period

        place(t3, 6.283185307179586 * (workspace:GetServerTimeNow() % ceiling_spin_period) / ceiling_spin_period)
    end))
    p3.maid:GiveTask(function() -- line: 53
        -- upvalues: t3 (copy), place (copy)
        place(t3, 0)
    end)
end

return table.freeze(t1)
