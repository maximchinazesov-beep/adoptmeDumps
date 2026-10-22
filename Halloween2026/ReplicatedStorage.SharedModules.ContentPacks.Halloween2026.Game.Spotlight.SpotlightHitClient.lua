-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function blink(p1, p2, p3) -- line: 8
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local blinking = p1.hit.blinking
    local v3 = blinking[p2]

    if v3 then
        v3.hit_at = p3
    else
        local Highlight = Instance.new("Highlight")

        Highlight.FillColor = CONSTANTS.hit_blink_color
        Highlight.FillTransparency = CONSTANTS.hit_blink_transparency
        Highlight.OutlineTransparency = 1
        Highlight.Parent = p2
        blinking[p2] = {
            highlight = Highlight,
            hit_at = p3
        }
    end
end

local function pop(p4, p5) -- line: 27
    -- upvalues: v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local v4 = p5.PrimaryPart or error((("%* was hit without a PrimaryPart"):format((p5:GetFullName()))))
    local v6 = math.sqrt(2 * workspace.Gravity * CONSTANTS.hit_pop_height)

    v4.AssemblyLinearVelocity = v4.AssemblyLinearVelocity * Vector3.new(1, 0, 1) + Vector3.new(0, 1, 0) * v6
    v1.shake(p4, {
        envelope = "decay",
        amplitude = CONSTANTS.hit_shake_amplitude,
        frequency = CONSTANTS.hit_shake_frequency,
        time = CONSTANTS.hit_shake_duration
    })
end

local function step(p6, p7) -- line: 42
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local blinking = p6.hit.blinking
    local hit_blink_period = CONSTANTS.hit_blink_period

    for v7, v8 in blinking do
        local v9 = p7 - v8.hit_at

        if CONSTANTS.hit_invincibility_duration <= v9 then
            v8.highlight:Destroy()
            blinking[v7] = nil
        else
            v8.highlight.Enabled = v9 % hit_blink_period < hit_blink_period / 2
        end
    end
end

function t1.connect_hits(p8) -- line: 58
    -- upvalues: RunService (copy), v1 (copy), v2 (copy), blink (copy), pop (copy), step (copy)
    local CONSTANTS = v2.CONSTANTS

    v1.connect_characters(p8, function(p9, p10, p11) -- line: 61
        -- upvalues: p8 (copy), CONSTANTS (copy), v1 (copy), blink (copy), pop (copy)
        p11:GiveTask(p10:GetAttributeChangedSignal(CONSTANTS.spotlight_caught_attribute):Connect(function() -- line: 62
            -- upvalues: p9 (copy), p10 (copy), p8 (copy), CONSTANTS (copy), v1 (copy), blink (copy), pop (copy)
            if p10:GetAttribute(CONSTANTS.spotlight_caught_attribute) ~= nil then
                blink(p8, p10, os.clock())

                if p9 == v1.LOCAL_PLAYER then
                    pop(p8, p10)
                end
            end
        end))
    end)
    p8.maid:GiveTask(RunService.PreRender:Connect(function() -- line: 75
        -- upvalues: p8 (copy), step (copy)
        if next(p8.hit.blinking) ~= nil then
            step(p8, os.clock())
        end
    end))
    p8.maid:GiveTask(function() -- line: 81
        -- upvalues: p8 (copy)
        for _, v10 in p8.hit.blinking do
            v10.highlight:Destroy()
        end
    end)
end

return table.freeze(t1)
