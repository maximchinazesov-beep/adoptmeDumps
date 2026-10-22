-- https://lua.expert

local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightScreenshake")
local v3 = require("./SpotlightShared")
local t1 = {}
local v4 = Color3.new(0, 0, 0)
local v5 = Color3.new(1, 1, 1)

local function build_teleporter(p1) -- line: 60
    -- upvalues: v3 (copy), v5 (copy)
    local CONSTANTS = v3.CONSTANTS
    local Color = p1.Color
    local v6 = p1:GetAttribute(CONSTANTS.teleporter_ring_color_attribute) or Color
    local v7 = p1:GetAttribute(CONSTANTS.teleporter_aura_tint_attribute) or Color
    local v8 = p1:GetAttribute(CONSTANTS.teleporter_particle_color_attribute) or Color
    local t2 = {}
    local t3 = {}
    local t4 = {}
    local t5 = {}

    for _, descendant in p1:GetDescendants() do
        if descendant:IsA("BasePart") then
            if descendant.Name == CONSTANTS.teleporter_ring_name then
                descendant.Color = v6
            elseif descendant.Name == CONSTANTS.teleporter_disc_name then
                descendant.Color = Color
            end

            if descendant.CanTouch then
                table.insert(t2, descendant)
            end

            if descendant.Material == Enum.Material.Neon then
                t3[descendant] = descendant.Color
            end
        elseif descendant:IsA("SurfaceAppearance") then
            descendant.EmissiveTint = v7

            local Parent = descendant.Parent

            if Parent and Parent:IsA("BasePart") then
                t4[Parent] = Parent.Transparency
            end
        elseif descendant:IsA("ParticleEmitter") then
            descendant.Color = ColorSequence.new(v8)
            table.insert(t5, descendant)
        end
    end

    p1.Transparency = 1

    local v9 = v7:Lerp(v5, CONSTANTS.teleporter_aura_whiten)

    return {
        pivot = p1.CFrame,
        touchable = t2,
        glows = t3,
        auras = t4,
        emitters = t5,
        aura = v9,
        sparkles = ColorSequence.new(v9, v5)
    }
end

local function set_brightness(p2, p3) -- line: 115
    -- upvalues: v4 (copy)
    for _, v10 in p2.ends do
        for v11, v12 in v10.glows do
            v11.Color = v4:Lerp(v12, p3)
        end

        for v13, v14 in v10.auras do
            v13.Transparency = 1 - (1 - v14) * p3
        end
    end
end

local function set_emitters_enabled(p4, p5) -- line: 127
    for _, v15 in p4.ends do
        for _, v16 in v15.emitters do
            v16.Enabled = p5
        end
    end
end

local function set_state(p6, p7) -- line: 135
    p6.state = p7
    p6.state_started_at = os.clock()
end

local function new_shake(p8, p9) -- line: 140
    -- upvalues: v2 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS

    return v2.new({
        amplitude = CONSTANTS.teleporter_shake_amplitude,
        frequency = CONSTANTS.teleporter_shake_frequency,
        time = p8,
        envelope = p9
    })
end

local function build_glow_part(p10) -- line: 151
    local Part = Instance.new("Part")

    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Parent = p10.visuals

    return Part
end

local function build_streak(p11, p12) -- line: 164
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local Part = Instance.new("Part")

    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Parent = p11.visuals

    local Attachment = Instance.new("Attachment")

    Attachment.Parent = Part

    local Attachment2 = Instance.new("Attachment")

    Attachment2.Parent = Part

    local Beam = Instance.new("Beam")

    Beam.Attachment0 = Attachment
    Beam.Attachment1 = Attachment2
    Beam.Color = ColorSequence.new(p12)
    Beam.Transparency = NumberSequence.new(CONSTANTS.teleporter_beam_tail_transparency, CONSTANTS.teleporter_beam_head_transparency)
    Beam.LightEmission = 1
    Beam.LightInfluence = 0
    Beam.FaceCamera = true
    Beam.Segments = 1
    Beam.Width0 = 0
    Beam.Width1 = CONSTANTS.teleporter_sphere_radius * 2 * CONSTANTS.teleporter_sphere_squeeze * CONSTANTS.teleporter_beam_width
    Beam.Enabled = false
    Beam.Parent = Part

    return {
        carrier = Part,
        tail = Attachment,
        head = Attachment2,
        beam = Beam
    }
end

local function build_glow(p13, p14, p15, p16) -- line: 194
    -- upvalues: v1 (copy), v3 (copy), build_streak (copy)
    local CONSTANTS = v3.CONSTANTS
    local aura = p14.aura
    local Part = Instance.new("Part")

    Part.Transparency = 1
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Parent = p13.visuals
    Part.Shape = Enum.PartType.Ball
    Part.Material = Enum.Material.ForceField
    Part.Color = aura

    local PointLight = Instance.new("PointLight")

    PointLight.Color = aura
    PointLight.Range = CONSTANTS.teleporter_sphere_light_range
    PointLight.Brightness = 0
    PointLight.Parent = Part

    local Highlight = Instance.new("Highlight")

    Highlight.Adornee = p15
    Highlight.DepthMode = Enum.HighlightDepthMode.Occluded
    Highlight.FillColor = aura
    Highlight.OutlineColor = aura
    Highlight.FillTransparency = 1
    Highlight.OutlineTransparency = 1
    Highlight.Parent = p13.visuals

    local v17 = v1.get_vfx_template(CONSTANTS.vfx_teleport_charge)
    local clone = if not (v17 and v17:IsA("ParticleEmitter")) then nil else v17:Clone()

    if clone then
        clone.Color = p14.sparkles
        clone.Rate = CONSTANTS.teleporter_charge_rate
        clone.Parent = Part
    end

    local Attachment = Instance.new("Attachment")
    local LinearVelocity = Instance.new("LinearVelocity")

    LinearVelocity.Attachment0 = Attachment
    LinearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Line
    LinearVelocity.LineDirection = Vector3.new(0, 1, 0)
    LinearVelocity.LineVelocity = 0
    LinearVelocity.MaxForce = 1e999
    LinearVelocity.Parent = Attachment
    Attachment.Parent = p16
    p13.maid:GiveTask(Attachment)

    return {
        departed_from = nil,
        departed_at = nil,
        landed = false,
        sphere = Part,
        light = PointLight,
        highlight = Highlight,
        charge = clone,
        streak = build_streak(p13, aura),
        lift = Attachment,
        rise = LinearVelocity,
        sparkles = p14.sparkles,
        lingers = if clone then clone.Lifetime.Max else 0,
        launched_at = os.clock()
    }
end

local function clear_glow(p17) -- line: 259
    local glow = p17.glow

    if not glow then
        return
    end

    if glow.lift then
        glow.lift:Destroy()
    end

    glow.sphere:Destroy()
    glow.highlight:Destroy()
    glow.streak.carrier:Destroy()
    p17.glow = nil
end

local function launch(p18, p19, p20) -- line: 274
    -- upvalues: SoundService (copy), v1 (copy), v2 (copy), v3 (copy), build_glow (copy)
    local CONSTANTS = v3.CONSTANTS
    local Character = v1.LOCAL_PLAYER.Character
    local v18, v19

    if Character then
        v18 = Character.PrimaryPart

        if v18 then
            local glow = p19.glow

            if glow then
                if glow.lift then
                    glow.lift:Destroy()
                end

                glow.sphere:Destroy()
                glow.highlight:Destroy()
                glow.streak.carrier:Destroy()
                p19.glow = nil
            end

            v19 = false
        else
            v19 = true
        end
    else
        v18 = Character
        v19 = true
    end

    if v19 then
        return
    end

    p19.glow = build_glow(p18, p20, Character, v18)
    p19.launch_from = p20

    local teleporter_hover_duration = CONSTANTS.teleporter_hover_duration
    local CONSTANTS2 = v3.CONSTANTS

    p19.shake = v2.new({
        envelope = "ramp_up",
        amplitude = CONSTANTS2.teleporter_shake_amplitude,
        frequency = CONSTANTS2.teleporter_shake_frequency,
        time = teleporter_hover_duration
    })
    v1.play_layered_sound(CONSTANTS.sound_teleporter_launch, SoundService)
    p19.state = "hovering"
    p19.state_started_at = os.clock()
end

local function begin_fade(p21) -- line: 293
    -- upvalues: v2 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS

    p21.launch_from = nil

    local teleporter_shake_dissipate_duration = CONSTANTS.teleporter_shake_dissipate_duration
    local CONSTANTS2 = v3.CONSTANTS

    p21.shake = v2.new({
        envelope = "decay",
        amplitude = CONSTANTS2.teleporter_shake_amplitude,
        frequency = CONSTANTS2.teleporter_shake_frequency,
        time = teleporter_shake_dissipate_duration
    })

    for _, v20 in p21.ends do
        for _, v21 in v20.emitters do
            v21.Enabled = false
        end
    end

    p21.state = "fading"
    p21.state_started_at = os.clock()
end

local function restore_camera(p22) -- line: 303
    local teleporters = p22.teleporters

    if teleporters.camera_base then
        workspace.CurrentCamera.CFrame = teleporters.camera_base
    end

    teleporters.camera_base = nil
end

local function start_glide(p23, p24) -- line: 312
    local teleporters = p23.teleporters

    if teleporters.camera_base then
        workspace.CurrentCamera.CFrame = teleporters.camera_base
    end

    teleporters.camera_base = nil

    local CurrentCamera = workspace.CurrentCamera

    CurrentCamera.CFrame = p24 * CurrentCamera.CFrame
    CurrentCamera.Focus = p24 * CurrentCamera.Focus
    p23.teleporters.glide = {
        undo = p24:Inverse(),
        started_at = os.clock()
    }
end

local function offset_camera(p25, p26) -- line: 322
    -- upvalues: v1 (copy), v2 (copy), v3 (copy)
    local teleporters = p25.teleporters
    local CurrentCamera = workspace.CurrentCamera
    local CFrame = CurrentCamera.CFrame
    local glide = teleporters.glide

    if glide then
        local v22 = v1.get_alpha(glide.started_at, os.clock(), v3.CONSTANTS.teleporter_transit_duration)

        if v22 < 1 then
            CurrentCamera.CFrame = (glide.undo * CFrame):Lerp(CFrame, v1.ease_in_out(v22))
            teleporters.camera_base = CFrame
        else
            teleporters.glide = nil
        end
    end

    for _, v23 in teleporters.pairs_list do
        local shake = v23.shake

        if shake then
            if v2.shake_camera(shake, p26) then
                teleporters.camera_base = CFrame
            else
                v23.shake = nil
            end
        end
    end
end

local function update_hovering(p27, p28, p29, p30) -- line: 357
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), start_glide (copy)
    local CONSTANTS = v3.CONSTANTS
    local Character = v1.LOCAL_PLAYER.Character
    local v24 = Character and Character.PrimaryPart
    local glow = p28.glow
    local v25 = glow and glow.lift

    if Character and v24 and glow and v25 then
        local v26 = v1.get_alpha(p28.state_started_at, p30, CONSTANTS.teleporter_hover_duration)

        glow.rise.LineVelocity = CONSTANTS.teleporter_hover_height / CONSTANTS.teleporter_hover_duration * 30 * v26 ^ 2 * (1 - v26) ^ 2

        if not (v26 < 1) then
            local v27 = (if p29 == p28.ends[1] then p28.ends[2] else p28.ends[1]).pivot * p29.pivot:Inverse()

            v25:Destroy()
            glow.lift = nil
            glow.departed_from = v24.Position
            glow.departed_at = p30
            glow.streak.head.WorldPosition = v24.Position
            glow.streak.tail.WorldPosition = v24.Position
            glow.streak.beam.Enabled = true

            if glow.charge then
                glow.charge.Rate = 0
            end

            v1.play_vfx(p27, CONSTANTS.vfx_teleport_burst, v24.Position, CONSTANTS.teleporter_departure_burst, glow.sparkles)
            Character:PivotTo(v27 * Character:GetPivot())
            start_glide(p27, v27)

            local CONSTANTS2 = v3.CONSTANTS

            p28.launch_from = nil

            local teleporter_shake_dissipate_duration = CONSTANTS2.teleporter_shake_dissipate_duration
            local CONSTANTS3 = v3.CONSTANTS

            p28.shake = v2.new({
                envelope = "decay",
                amplitude = CONSTANTS3.teleporter_shake_amplitude,
                frequency = CONSTANTS3.teleporter_shake_frequency,
                time = teleporter_shake_dissipate_duration
            })

            for _, v28 in p28.ends do
                for _, v29 in v28.emitters do
                    v29.Enabled = false
                end
            end

            p28.state = "fading"
            p28.state_started_at = os.clock()
        end
    else
        local glow = p28.glow

        if glow then
            if glow.lift then
                glow.lift:Destroy()
            end

            glow.sphere:Destroy()
            glow.highlight:Destroy()
            glow.streak.carrier:Destroy()
            p28.glow = nil
        end

        local CONSTANTS = v3.CONSTANTS

        p28.launch_from = nil

        local teleporter_shake_dissipate_duration = CONSTANTS.teleporter_shake_dissipate_duration
        local CONSTANTS2 = v3.CONSTANTS

        p28.shake = v2.new({
            envelope = "decay",
            amplitude = CONSTANTS2.teleporter_shake_amplitude,
            frequency = CONSTANTS2.teleporter_shake_frequency,
            time = teleporter_shake_dissipate_duration
        })

        for _, v30 in p28.ends do
            for _, v31 in v30.emitters do
                v31.Enabled = false
            end
        end

        p28.state = "fading"
        p28.state_started_at = os.clock()
    end
end

local function step_glow(p31, p32, p33, p34) -- line: 413
    -- upvalues: v1 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v32 = v1.get_local_root()

    if v32 then
        p33.sphere.CFrame = CFrame.new(v32.Position)
    end

    local spherePosition = p33.sphere.Position
    local teleporter_sphere_squeeze, teleporter_sphere_pop_duration = CONSTANTS.teleporter_sphere_squeeze, CONSTANTS.teleporter_sphere_pop_duration
    local departed_from, departed_at = p33.departed_from, p33.departed_at

    if departed_from and departed_at then
        local v33 = p34 - departed_at
        local v35 = math.min(v33 / CONSTANTS.teleporter_transit_duration, 1)

        if v35 < 1 then
            p33.streak.head.WorldPosition = departed_from:Lerp(spherePosition, v1.ease_out(v35))
            p33.streak.tail.WorldPosition = departed_from:Lerp(spherePosition, v1.ease_in_out(v35))
        elseif not p33.landed then
            p33.landed = true
            p33.streak.beam.Enabled = false
            v1.play_vfx(p31, CONSTANTS.vfx_teleport_burst, spherePosition, 1, p33.sparkles)
        end

        local v37 = math.clamp((v33 - CONSTANTS.teleporter_transit_duration) / teleporter_sphere_pop_duration, 0, 1)

        if not (v37 >= 1 and p33.lingers <= v33) then
            local v38 = 1 - v37
            local v39 = teleporter_sphere_squeeze * v1.ease_back(v38)

            p33.sphere.Size = Vector3.new(1, 1, 1) * CONSTANTS.teleporter_sphere_radius * 2 * v39
            p33.sphere.Transparency = 1 - (1 - CONSTANTS.teleporter_sphere_transparency) * v38
            p33.highlight.FillTransparency = 1 - (1 - CONSTANTS.teleporter_glow_fill_transparency) * v38
            p33.highlight.OutlineTransparency = 1 - (1 - CONSTANTS.teleporter_glow_outline_transparency) * v38
            p33.light.Brightness = CONSTANTS.teleporter_sphere_brightness * v38
        else
            local glow = p32.glow

            if glow then
                if glow.lift then
                    glow.lift:Destroy()
                end

                glow.sphere:Destroy()
                glow.highlight:Destroy()
                glow.streak.carrier:Destroy()
                p32.glow = nil
            end
        end
    else
        local v40 = p34 - p33.launched_at
        local v42 = math.clamp((v40 - teleporter_sphere_pop_duration) / (CONSTANTS.teleporter_hover_duration - teleporter_sphere_pop_duration), 0, 1)
        local v44 = math.min(v40 / teleporter_sphere_pop_duration, 1)
        local v45 = v1.ease_back(v44) * (1 - (1 - teleporter_sphere_squeeze) * v1.ease_in_out(v42))

        p33.sphere.Size = Vector3.new(1, 1, 1) * CONSTANTS.teleporter_sphere_radius * 2 * v45
        p33.sphere.Transparency = 1 - (1 - CONSTANTS.teleporter_sphere_transparency) * v44
        p33.highlight.FillTransparency = 1 - (1 - CONSTANTS.teleporter_glow_fill_transparency) * v44
        p33.highlight.OutlineTransparency = 1 - (1 - CONSTANTS.teleporter_glow_outline_transparency) * v44
        p33.light.Brightness = CONSTANTS.teleporter_sphere_brightness * v44
    end
end

local function update_pair(p35, p36, p37) -- line: 463
    -- upvalues: v1 (copy), v3 (copy), set_brightness (copy), update_hovering (copy)
    local CONSTANTS = v3.CONSTANTS
    local launch_from = p36.launch_from

    if p36.state == "hovering" and launch_from then
        update_hovering(p35, p36, launch_from, p37)

        return
    end

    if p36.state == "fading" then
        local v46 = v1.get_alpha(p36.state_started_at, p37, CONSTANTS.teleporter_fade_duration)

        set_brightness(p36, 1 - v46)

        if v46 >= 1 then
            p36.state = "recharging"
            p36.state_started_at = os.clock()
        end
    elseif p36.state == "recharging" then
        local v47 = v1.get_alpha(p36.state_started_at, p37, CONSTANTS.teleporter_recharge_duration)

        if v47 < 1 then
            set_brightness(p36, v47 * CONSTANTS.teleporter_recharge_peak)
        else
            set_brightness(p36, 1)

            for _, v48 in p36.ends do
                for _, v49 in v48.emitters do
                    v49.Enabled = true
                end
            end

            p36.state = "ready"
            p36.state_started_at = os.clock()
        end
    end
end

local function connect_pair(p38, p39, p40) -- line: 492
    -- upvalues: v1 (copy), build_teleporter (copy), launch (copy)
    local t7 = {
        state = "ready",
        state_started_at = 0,
        launch_from = nil,
        glow = nil,
        shake = nil,
        ends = {
            build_teleporter(p39),
            (build_teleporter(p40))
        }
    }

    table.insert(p38.teleporters.pairs_list, t7)

    for _, v50 in t7.ends do
        for _, v51 in v50.touchable do
            p38.maid:GiveTask(v51.Touched:Connect(function(p41) -- line: 506
                -- upvalues: p38 (copy), t7 (copy), v50 (copy), v1 (copy), launch (copy)
                if t7.state == "ready" and v1.is_local_character_part(p41) then
                    launch(p38, t7, v50)
                end
            end))
        end
    end
end

function t1.connect_all_teleporters(p42, p43) -- line: 515
    -- upvalues: RunService (copy), offset_camera (copy), step_glow (copy), update_pair (copy), connect_pair (copy)
    local t8 = {}

    for _, child in p43:GetChildren() do
        assert(child:IsA("BasePart"), (("%* must be a teleporter memento part"):format((child:GetFullName()))))

        local v53, v54 = child.Name:match("^(.+)([12])$")

        assert(v53, (("%* must be named with a shared base plus a 1 or 2 suffix"):format((child:GetFullName()))))

        local v56 = t8[v53] or {}

        t8[v53] = v56
        assert(not v56[v54], (("%* duplicates %*%*"):format(child:GetFullName(), v53, v54)))
        v56[v54] = child
    end

    for v59, v60 in t8 do
        connect_pair(p42, v60["1"] or error((("%* is missing %*1"):format(p43:GetFullName(), v59))), v60["2"] or error((("%* is missing %*2"):format(p43:GetFullName(), v59))))
    end

    p42.maid:GiveTask(RunService.Heartbeat:Connect(function() -- line: 538
        -- upvalues: p42 (copy), update_pair (copy)
        local elapsed = os.clock()

        for _, v63 in p42.teleporters.pairs_list do
            update_pair(p42, v63, elapsed)
        end
    end))
    p42.maid:GiveTask(RunService.PreRender:Connect(function() -- line: 546
        -- upvalues: p42 (copy), step_glow (copy)
        local elapsed = os.clock()

        for _, v64 in p42.teleporters.pairs_list do
            local glow = v64.glow

            if glow then
                step_glow(p42, v64, glow, elapsed)
            end
        end
    end))
    RunService:BindToRenderStep("SpotlightTeleporterCameraRestore", Enum.RenderPriority.Camera.Value - 1, function() -- line: 557
        -- upvalues: p42 (copy)
        local teleporters = p42.teleporters

        if teleporters.camera_base then
            workspace.CurrentCamera.CFrame = teleporters.camera_base
        end

        teleporters.camera_base = nil
    end)
    RunService:BindToRenderStep("SpotlightTeleporterCameraOffset", Enum.RenderPriority.Camera.Value + 1, function(p44) -- line: 560
        -- upvalues: p42 (copy), offset_camera (copy)
        offset_camera(p42, p44)
    end)
    p42.maid:GiveTask(function() -- line: 564
        -- upvalues: p42 (copy), RunService (copy)
        RunService:UnbindFromRenderStep("SpotlightTeleporterCameraRestore")
        RunService:UnbindFromRenderStep("SpotlightTeleporterCameraOffset")

        local teleporters = p42.teleporters

        if teleporters.camera_base then
            workspace.CurrentCamera.CFrame = teleporters.camera_base
        end

        teleporters.camera_base = nil
    end)
end

return table.freeze(t1)
