-- https://lua.expert

local t1 = {}
local v1 = Random.new()

local function get_noise(p1, p2, p3) -- line: 19
    return (math.clamp(math.noise(p1 * p2, p3) * 2, -1, 1))
end

function t1.new(p4) -- line: 23
    -- upvalues: v1 (copy)
    return {
        elapsed = 0,
        amplitude = p4.amplitude,
        frequency = p4.frequency,
        time = p4.time,
        envelope = p4.envelope,
        offsets = Vector3.new(v1:NextNumber(), v1:NextNumber(), v1:NextNumber()) * 10000
    }
end

function t1.shake_camera(p5, p6) -- line: 34
    if p5.elapsed >= p5.time then
        return false
    end

    p5.elapsed = math.min(p5.elapsed + p6, p5.time)

    local v6 = p5.elapsed / p5.time
    local amplitude = p5.amplitude

    if p5.envelope == "decay" then
        v6 = 1 - v6
    end

    local v7 = amplitude * v6
    local offsets = p5.offsets
    local CurrentCamera = workspace.CurrentCamera
    local _CFrame = CurrentCamera.CFrame
    local Angles = CFrame.Angles
    local elapsed, frequency = p5.elapsed, p5.frequency
    local X = offsets.X
    local v9 = math.clamp(math.noise(elapsed * frequency, X) * 2, -1, 1) * v7
    local elapsed2, frequency2 = p5.elapsed, p5.frequency
    local Y = offsets.Y
    local v11 = math.clamp(math.noise(elapsed2 * frequency2, Y) * 2, -1, 1) * v7
    local elapsed3, frequency3 = p5.elapsed, p5.frequency
    local Z = offsets.Z

    CurrentCamera.CFrame = _CFrame * Angles(v9, v11, math.clamp(math.noise(elapsed3 * frequency3, Z) * 2, -1, 1) * v7)

    return true
end

return table.freeze(t1)
