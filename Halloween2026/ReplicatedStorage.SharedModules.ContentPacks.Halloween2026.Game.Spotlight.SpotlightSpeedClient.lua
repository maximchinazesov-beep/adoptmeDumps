-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function destroy_effect(p1) -- line: 8
    local effect = p1.speed.effect

    if not effect then
        return
    end

    p1.speed.effect = nil

    for _, v3 in effect.made do
        v3:Destroy()
    end

    effect.carrier:Destroy()
end

local function measure_body(p2, p3) -- line: 22
    local v4 = Vector3.new(1, 1, 1) * 1e999
    local v5 = Vector3.new(-1, -1, -1, -0) * 1e999

    for _, child in p2:GetChildren() do
        if child:IsA("BasePart") then
            local Components, Components2, Components3, Components4, Components5, Components6, Components7, Components8, Components9, Components10, Components11, Components12 = p3.CFrame:ToObjectSpace(child.CFrame):GetComponents()
            local Size = child.Size
            local v6 = Vector3.new(Components, Components2, Components3)
            local v10 = Vector3.new(math.abs(Components4) * Size.X + math.abs(Components5) * Size.Y + math.abs(Components6) * Size.Z, math.abs(Components7) * Size.X + math.abs(Components8) * Size.Y + math.abs(Components9) * Size.Z, math.abs(Components10) * Size.X + math.abs(Components11) * Size.Y + math.abs(Components12) * Size.Z) / 2

            v4 = v4:Min(v6 - v10)
            v5 = v5:Max(v6 + v10)
        end
    end

    return CFrame.new((v4 + v5) / 2), v5 - v4
end

local function faded(p4, p5) -- line: 46
    local t2 = {}

    for _, v11 in p4.Keypoints do
        table.insert(t2, NumberSequenceKeypoint.new(v11.Time, 1 - (1 - v11.Value) * p5, v11.Envelope))
    end

    return NumberSequence.new(t2)
end

local function scaled(p6, p7) -- line: 55
    local t3 = {}

    for _, v13 in p6.Keypoints do
        table.insert(t3, NumberSequenceKeypoint.new(v13.Time, v13.Value * p7, v13.Envelope * p7))
    end

    return NumberSequence.new(t3)
end

local function build_effect(p8, p9, p10) -- line: 64
    -- upvalues: v1 (copy), v2 (copy), measure_body (copy)
    local CONSTANTS = v2.CONSTANTS
    local v16 = v1.get_vfx_template(CONSTANTS.vfx_candycorn_trail) or error((("Resources has no %* to dress the speed trail in"):format(CONSTANTS.vfx_candycorn_trail)))
    local v17 = v16:FindFirstChild(CONSTANTS.vfx_trail_ribbon_name) or error((("%* has no %*"):format(v16:GetFullName(), CONSTANTS.vfx_trail_ribbon_name)))
    local v18 = v16:FindFirstChild(CONSTANTS.vfx_trail_sparks_name) or error((("%* has no %*"):format(v16:GetFullName(), CONSTANTS.vfx_trail_sparks_name)))
    local v19 = ColorSequence.new({
        ColorSequenceKeypoint.new(0, CONSTANTS.speed_trail_core),
        ColorSequenceKeypoint.new(0.4, CONSTANTS.speed_trail_glow),
        ColorSequenceKeypoint.new(1, CONSTANTS.speed_trail_tail)
    })
    local t4 = {}
    local t5 = {}

    for _, v20 in CONSTANTS.speed_trail_limbs do
        local v21 = p9:FindFirstChild(v20)

        if v21 and v21:IsA("BasePart") then
            local v22 = math.min(v21.Size.X, v21.Size.Z) * CONSTANTS.speed_trail_width
            local t6 = {}

            for _, v23 in { -1, 1 } do
                local Attachment = Instance.new("Attachment")

                Attachment.Name = "SpotlightSpeedStreak"
                Attachment.Position = Vector3.new(v23 * v22 / 2, -v21.Size.Y / 2, 0)
                Attachment.Parent = v21
                table.insert(t6, Attachment)
                table.insert(t4, Attachment)
            end

            local clone = v17:Clone()

            clone.Name = "SpotlightSpeedStreak"
            clone.Attachment0 = t6[1]
            clone.Attachment1 = t6[2]
            clone.Color = v19
            clone.Enabled = false
            clone.Parent = v21
            table.insert(t5, clone)
            table.insert(t4, clone)
        end
    end

    local v26, v27 = measure_body(p9, p10)
    local Part = Instance.new("Part")

    Part.Name = "SpotlightSpeedSparks"
    Part.Size = v27
    Part.CFrame = p10.CFrame * v26
    Part.Transparency = 1
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true

    local WeldConstraint = Instance.new("WeldConstraint")

    WeldConstraint.Part0 = p10
    WeldConstraint.Part1 = Part
    WeldConstraint.Parent = Part

    local clone = v18:Clone()

    clone.Shape = Enum.ParticleEmitterShape.Box
    clone.ShapeStyle = Enum.ParticleEmitterShapeStyle.Volume
    clone.Color = v19
    clone.Rate = 0
    clone.Parent = Part
    Part.Parent = p8.visuals

    return {
        shown = 0,
        drawn = -1,
        lifetime = 0,
        root = p10,
        streaks = t5,
        sparks = clone,
        carrier = Part,
        made = t4,
        transparency = v17.Transparency,
        width = v17.WidthScale
    }
end

local function step_effect(p11, p12, p13, p14, p15) -- line: 155
    -- upvalues: v2 (copy), faded (copy), scaled (copy), build_effect (copy)
    local CONSTANTS = v2.CONSTANTS
    local effect = p11.speed.effect

    if not effect or effect.root ~= p13 then
        local effect2 = p11.speed.effect

        if effect2 then
            p11.speed.effect = nil

            for _, v28 in effect2.made do
                v28:Destroy()
            end

            effect2.carrier:Destroy()
        end

        effect = build_effect(p11, p12, p13)
        p11.speed.effect = effect
    end

    local v30 = math.max(p14 - CONSTANTS.movement_base_walk_speed, 0) * CONSTANTS.speed_trail_window
    local v31 = if CONSTANTS.speed_trail_min_length <= v30 then 1 else 0

    if v31 > 0 then
        effect.lifetime = v2.approach(effect.lifetime, v30 / p14, p15 * CONSTANTS.speed_trail_fade)
    end

    effect.shown = v2.approach(effect.shown, v31, p15 * CONSTANTS.speed_trail_fade)

    if effect.shown < CONSTANTS.speed_min_visible then
        effect.shown = 0
    end

    local v33 = math.abs(effect.shown - effect.drawn) > CONSTANTS.speed_min_visible

    if v33 then
        effect.drawn = effect.shown
    end

    for _, v34 in effect.streaks do
        v34.Enabled = effect.shown > 0
        v34.Lifetime = effect.lifetime

        if v33 then
            v34.Transparency = faded(effect.transparency, effect.shown)
            v34.WidthScale = scaled(effect.width, effect.shown)
        end
    end

    effect.sparks.Rate = CONSTANTS.speed_spark_rate * p11.speed.intensity
end

local function get_intensity(p16, p17) -- line: 200
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS

    if p16 <= 0 then
        return 0
    end

    local v35 = CONSTANTS.marker_speedup_bonus * CONSTANTS.speed_full_at_bonuses
    local v37 = math.clamp((p16 - CONSTANTS.movement_base_walk_speed) / v35, 0, 1)

    if v37 <= 0 then
        return 0
    end

    local speed_min_effort = CONSTANTS.speed_min_effort

    return v37 * math.clamp((p17 / p16 - speed_min_effort) / (1 - speed_min_effort), 0, 1)
end

local function end_shake(p18) -- line: 219
    local shake = p18.shake

    if shake then
        shake.elapsed = shake.time
        p18.shake = nil
    end
end

local function kick(p19) -- line: 227
    -- upvalues: v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local speed = p19.speed
    local shake = speed.shake

    if shake then
        shake.elapsed = shake.time
        speed.shake = nil
    end

    p19.speed.kick = 1

    local effect = p19.speed.effect

    if effect then
        effect.sparks:Emit(CONSTANTS.speed_spark_burst)
    end

    p19.speed.shake = v1.shake(p19, {
        envelope = "decay",
        amplitude = CONSTANTS.speed_kick_shake_amplitude,
        frequency = CONSTANTS.speed_kick_shake_frequency,
        time = CONSTANTS.speed_kick_duration
    })
end

local function set_fov(p20, p21) -- line: 245
    local CurrentCamera = workspace.CurrentCamera
    local speed = p20.speed

    if p21 ~= 0 or speed.gain ~= 0 then
        speed.gain = p21
        CurrentCamera.FieldOfView = speed.base_fov + p21
    else
        speed.base_fov = CurrentCamera.FieldOfView
    end
end

local function step(p22, p23) -- line: 257
    -- upvalues: v1 (copy), v2 (copy), step_effect (copy), kick (copy)
    local CONSTANTS = v2.CONSTANTS
    local speed = p22.speed
    local Character = v1.LOCAL_PLAYER.Character
    local v39, v40

    if Character then
        v39 = Character:FindFirstChildOfClass("Humanoid")
        v40 = Character.PrimaryPart
    else
        v40 = Character
        v39 = Character
    end

    local v41 = v1.get_chased_by() ~= nil
    local v42 = if v39 then v39.WalkSpeed else 0
    local walk_speed = speed.walk_speed

    if v41 then
        speed.kick = 0

        local shake = speed.shake

        if shake then
            shake.elapsed = shake.time
            speed.shake = nil
        end
    elseif walk_speed and walk_speed < v42 and CONSTANTS.movement_base_walk_speed <= walk_speed then
        kick(p22)
    end

    speed.walk_speed = v42

    local v43 = if not v40 or v41 then 0 else (v40.AssemblyLinearVelocity * Vector3.new(1, 0, 1)).Magnitude
    local CONSTANTS2 = v2.CONSTANTS
    local v44

    if v42 <= 0 then
        v44 = 0
    else
        local v45 = CONSTANTS2.marker_speedup_bonus * CONSTANTS2.speed_full_at_bonuses
        local v47 = math.clamp((v42 - CONSTANTS2.movement_base_walk_speed) / v45, 0, 1)

        if v47 <= 0 then
            v44 = 0
        else
            local speed_min_effort = CONSTANTS2.speed_min_effort

            v44 = v47 * math.clamp((v43 / v42 - speed_min_effort) / (1 - speed_min_effort), 0, 1)
        end
    end

    speed.intensity = v2.approach(speed.intensity, v44, p23 * CONSTANTS.speed_ramp)

    if speed.intensity < CONSTANTS.speed_min_visible then
        speed.intensity = 0
    end

    speed.kick = math.max(speed.kick - p23 / CONSTANTS.speed_kick_duration, 0)

    local v50 = CONSTANTS.speed_fov_gain * speed.intensity + CONSTANTS.speed_kick_fov * v1.ease_out(speed.kick)
    local CurrentCamera = workspace.CurrentCamera
    local speed2 = p22.speed

    if v50 ~= 0 or speed2.gain ~= 0 then
        speed2.gain = v50
        CurrentCamera.FieldOfView = speed2.base_fov + v50
    else
        speed2.base_fov = CurrentCamera.FieldOfView
    end

    if Character and v40 then
        step_effect(p22, Character, v40, if v41 then 0 else v42, p23)
    else
        local effect = p22.speed.effect

        if not effect then
            return
        end

        p22.speed.effect = nil

        for _, v52 in effect.made do
            v52:Destroy()
        end

        effect.carrier:Destroy()
    end
end

function t1.connect_speed(p24) -- line: 301
    -- upvalues: RunService (copy), step (copy)
    p24.maid:GiveTask(function() -- line: 302
        -- upvalues: p24 (copy)
        workspace.CurrentCamera.FieldOfView = p24.speed.base_fov

        local effect = p24.speed.effect

        if not effect then
            return
        end

        p24.speed.effect = nil

        for _, v53 in effect.made do
            v53:Destroy()
        end

        effect.carrier:Destroy()
    end)
    p24.maid:GiveTask(RunService.PreRender:Connect(function(p25) -- line: 307
        -- upvalues: p24 (copy), step (copy)
        if p24.cutscene.phase ~= "playing" then
            step(p24, p25)
        end
    end))
end

return table.freeze(t1)
