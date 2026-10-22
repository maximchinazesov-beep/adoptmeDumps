-- https://lua.expert

local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local load = require(ReplicatedStorage.Fsys).load
local Maid = load("Maid")
local SoundPlayer = load("SoundPlayer")
local UIManager = load("UIManager")

require("./SpotlightCandycornPivoter")

local v1 = require("./SpotlightRigs")
local v2 = require("./SpotlightScreenshake")
local v3 = require("./SpotlightShared")
local t1 = {}
local v4 = Color3.new(0, 0, 0)

t1.LOCAL_PLAYER = Players.LocalPlayer

function t1.new_session() -- line: 241
    -- upvalues: Maid (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v5 = Maid.new()
    local Folder = Instance.new("Folder")

    Folder.Name = CONSTANTS.visual_folder_name
    Folder.Parent = workspace
    v5:GiveTask(Folder)

    return {
        setup_phase = "setup",
        is_ready = false,
        entered_at = nil,
        has_started = false,
        players_changed = nil,
        maid = v5,
        visuals = Folder,
        shakes = {},
        arena = { Folder },
        on_started = {},
        get_players = function() -- get_players | line: 260
            return {}
        end,
        on_beam = {},
        report_collected = function() -- report_collected | line: 265
        end,
        beam_colors = {},
        billboards = {
            popping = {}
        },
        candycorn = {
            collect_streak = 0,
            streak_decay_at = 0,
            sound_ready_at = 0,
            sound_variant = 0,
            pivoter = nil,
            by_spawner = {},
            active = {}
        },
        cannons = {
            shots = {},
            cannons = {}
        },
        cutscene = {
            path = nil,
            phase = "waiting",
            fov = CONSTANTS.camera_default_fov
        },
        dash = {
            phase = "ready",
            ends_at = 0
        },
        flash = {
            started_at = nil,
            fade = 0,
            targeted = 0,
            chased_by = 1,
            shown = 0,
            bands = {}
        },
        hit = {
            blinking = {}
        },
        illuminators = {
            version = 0,
            illuminators = {},
            lit = {},
            assigned = {}
        },
        markers = {
            version = 0,
            announced_at = nil,
            claimed = 0,
            visuals = {},
            hinted = {}
        },
        obstacles = {
            tracks = {}
        },
        power = {
            rack = {
                on = true,
                level = 1
            }
        },
        reveal_bars = {
            by_character = {}
        },
        ringmaster = {
            stage = nil,
            rig = nil,
            revealed = false,
            playing = nil,
            reaction = nil,
            intro = nil,
            state = nil,
            state_for = 0,
            bones = {},
            clubs = {},
            club_offset = CFrame.identity,
            facing = CFrame.identity,
            tracks = {},
            thrown = {}
        },
        speed = {
            intensity = 0,
            kick = 0,
            walk_speed = nil,
            gain = 0,
            effect = nil,
            shake = nil,
            base_fov = CONSTANTS.camera_default_fov
        },
        stolen = {
            has_been_spotted = false,
            pieces = {},
            mouths = {}
        },
        teleporters = {
            glide = nil,
            camera_base = nil,
            pairs_list = {}
        }
    }
end

function t1.when_started(p1, p2) -- line: 320
    if p1.has_started then
        p2()
    else
        table.insert(p1.on_started, p2)
    end
end

function t1.start(p3) -- line: 328
    assert(not p3.has_started, "Spotlight's round started twice")
    p3.has_started = true

    for _, v7 in p3.on_started do
        task.spawn(v7)
    end

    table.clear(p3.on_started)
end

function t1.wait_for_head(p4) -- line: 339
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS

    return (p4:WaitForChild(CONSTANTS.rig_head_name):WaitForChild(CONSTANTS.rig_head_name))
end

function t1.get_local_root() -- line: 347
    -- upvalues: t1 (copy)
    local Character = t1.LOCAL_PLAYER.Character

    return Character and Character.PrimaryPart
end

function t1.is_local_character_part(p5) -- line: 353
    -- upvalues: t1 (copy)
    local Character = t1.LOCAL_PLAYER.Character

    if Character == nil then
        return false
    end

    return (p5:IsDescendantOf(Character))
end

function t1.get_vfx_template(p6) -- line: 359
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS

    return (v3.get_resources():FindFirstChild(CONSTANTS.vfx_folder_name) or error((("Resources has no %* folder"):format(CONSTANTS.vfx_folder_name)))):FindFirstChild(p6)
end

local function build_carrier(p7, p8) -- line: 368
    local Part = Instance.new("Part")

    Part.Name = p7
    Part.Size = Vector3.new(1, 1, 1)

    if typeof(p8) == "CFrame" then
        Part.CFrame = p8
    else
        Part.CFrame = CFrame.new(p8)
    end

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1

    return Part
end

local function scale_emitter(p9, p10) -- line: 382
    local t2 = {}

    for _, v8 in p9.Size.Keypoints do
        table.insert(t2, NumberSequenceKeypoint.new(v8.Time, v8.Value * p10, v8.Envelope * p10))
    end

    p9.Size = NumberSequence.new(t2)
    p9.Speed = NumberRange.new(p9.Speed.Min * p10, p9.Speed.Max * p10)
    p9.Acceleration *= p10
end

function t1.play_vfx(p11, p12, p13, p14, p15, p16) -- line: 393
    -- upvalues: Debris (copy), v3 (copy), t1 (copy), scale_emitter (copy)
    local CONSTANTS = v3.CONSTANTS
    local v11 = t1.get_vfx_template(p12)

    if not v11 then
        return nil
    end

    local Part = Instance.new("Part")

    Part.Name = p12
    Part.Size = Vector3.new(1, 1, 1)

    if typeof(p13) == "CFrame" then
        Part.CFrame = p13
    else
        Part.CFrame = CFrame.new(p13)
    end

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1

    if p16 then
        Part.Size *= p16
    end

    local clone = v11:Clone()
    local v12 = if clone:IsA("ParticleEmitter") then { clone } else clone:GetChildren()

    for _, v13 in v12 do
        v13.Parent = Part
    end

    Part.Parent = p11.visuals

    local n1 = 0

    for _, v14 in v12 do
        if v14:IsA("ParticleEmitter") then
            if p15 then
                v14.Color = p15
            end

            if p16 then
                scale_emitter(v14, p16)
            end

            v14:Emit((math.round((v14:GetAttribute("EmitCount") or CONSTANTS.vfx_default_emit_count) * (p14 or 1))))
            n1 = math.max(n1, v14.Lifetime.Max)
        end
    end

    Debris:AddItem(Part, n1 + CONSTANTS.vfx_lifetime_margin)

    return Part
end

function t1.attach_trail(p17, p18, p19) -- line: 443
    -- upvalues: Debris (copy), v3 (copy), t1 (copy)
    local v16 = t1.get_vfx_template(p18)

    if not v16 then
        return nil
    end

    local Part = Instance.new("Part")

    Part.Name = p18
    Part.Size = Vector3.new(1, 1, 1)

    if typeof(p19) == "CFrame" then
        Part.CFrame = p19
    else
        Part.CFrame = CFrame.new(p19)
    end

    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.Transparency = 1

    for _, child in v16:Clone():GetChildren() do
        child.Parent = Part
    end

    Part.Parent = p17.visuals
    Debris:AddItem(Part, v3.CONSTANTS.vfx_trail_max_lifetime)

    return Part
end

function t1.release_trail(p20) -- line: 460
    -- upvalues: Debris (copy), v3 (copy)
    local n2 = 0

    for _, child in p20:GetChildren() do
        if child:IsA("ParticleEmitter") then
            child.Enabled = false
            n2 = math.max(n2, child.Lifetime.Max)
        elseif child:IsA("Trail") then
            n2 = math.max(n2, child.Lifetime)
        end
    end

    Debris:AddItem(p20, n2 + v3.CONSTANTS.vfx_lifetime_margin)
end

function t1.show_hint(p21, p22) -- line: 474
    -- upvalues: UIManager (copy), v3 (copy)
    UIManager.apps.HintApp:hint({
        yields = false,
        text = p21,
        length = v3.CONSTANTS.hint_duration,
        overridable = not p22
    })
end

function t1.play_layered_sound(p23, p24) -- line: 483
    -- upvalues: SoundPlayer (copy)
    local v17 = SoundPlayer.FX.folder

    for match in p23:gmatch("[^/]+") do
        if v17 then
            v17 = v17:FindFirstChild(match)
        else
            v17 = nil
        end
    end

    local t3 = {}

    if not v17 then
        warn((("[SoundPlayer] - Unable to find layered sound '%*'"):format(p23)))

        return t3
    end

    local t4 = {}

    for _, child in v17:GetChildren() do
        if child:IsA("Sound") then
            assert(not t4[child.Name], (("%* has two layers named %*, so SoundPlayer can only play one"):format(p23, child.Name)))
            t4[child.Name] = true
            table.insert(t3, SoundPlayer.FX:play(("%*/%*"):format(p23, child.Name), p24))
        end
    end

    return t3
end

local function connect_players(p25, p26) -- line: 507
    -- upvalues: Maid (copy)
    local t5 = {}

    local function refresh() -- line: 510
        -- upvalues: p25 (copy), p26 (copy), t5 (copy), Maid (copy)
        local t6 = {}

        for _, v21 in p25.get_players() do
            t6[v21] = true

            if not t5[v21] then
                local v22 = Maid.new()

                t5[v21] = v22
                p26(v21, v22)
            end
        end

        for v23, v24 in t5 do
            if not t6[v23] then
                t5[v23] = nil
                v24:Destroy()
            end
        end
    end

    local v25 = p25.players_changed or error("Spotlight connected characters before the session's players")

    p25.maid:GiveTask(v25:Connect(refresh))
    p25.maid:GiveTask(function() -- line: 534
        -- upvalues: t5 (copy)
        for _, v26 in t5 do
            v26:Destroy()
        end
    end)
    refresh()
end

function t1.connect_characters(p27, p28) -- line: 543
    -- upvalues: Maid (copy), connect_players (copy)
    connect_players(p27, function(p29, p30) -- line: 544
        -- upvalues: p28 (copy), Maid (copy)
        local v27 = Maid.new()

        p30:GiveTask(v27)

        local function attach(p31) -- line: 548
            -- upvalues: p29 (copy), v27 (copy), p28 (copy)
            v27:DoCleaning()

            if p31 then
                p28(p29, p31, v27)
            end
        end

        p30:GiveTask(p29.CharacterAdded:Connect(attach))
        p30:GiveTask(p29.CharacterRemoving:Connect(function() -- line: 557
            -- upvalues: v27 (copy)
            v27:DoCleaning()
        end))

        local Character = p29.Character

        v27:DoCleaning()

        if Character then
            p28(p29, Character, v27)
        end
    end)
end

function t1.build_head_billboard(p32, p33, p34, p35) -- line: 565
    -- upvalues: v3 (copy)
    local v28 = p32:FindFirstChild("Head") or p32.PrimaryPart

    if not (v28 and v28:IsA("BasePart")) then
        return nil
    end

    local BillboardGui = Instance.new("BillboardGui")

    BillboardGui.Name = p33
    BillboardGui.Adornee = v28
    BillboardGui.Size = p34
    BillboardGui.StudsOffsetWorldSpace = p35
    BillboardGui.MaxDistance = v3.CONSTANTS.billboard_max_distance
    BillboardGui.LightInfluence = 0
    BillboardGui.Enabled = false
    BillboardGui.Parent = v28

    return BillboardGui
end

function t1.load_track(p36, p37, p38) -- line: 589
    if not p37 or p38 == "" then
        return nil
    end

    local Animation = Instance.new("Animation")

    Animation.AnimationId = p38

    local track = p37:LoadAnimation(Animation)

    p36:GiveTask(track)

    return track
end

function t1.get_pivoter(p39) -- line: 603
    return p39.candycorn.pivoter or error("Spotlight moved candy corn before connecting its spawners")
end

function t1.build_visual(p40) -- line: 607
    local clone = p40:Clone()

    for _, descendant in clone:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.Anchored = true
            descendant.CanCollide = false
            descendant.CanQuery = false
            descendant.CanTouch = false
        end
    end

    return clone
end

function t1.get_part_offsets(p41) -- line: 622
    local Pivot = p41:GetPivot()
    local t7 = {}

    for _, descendant in p41:GetDescendants() do
        if descendant:IsA("BasePart") then
            t7[descendant] = Pivot:ToObjectSpace(descendant.CFrame)
        end
    end

    return t7
end

function t1.get_alpha(p42, p43, p44) -- line: 635
    return (math.clamp((p43 - p42) / p44, 0, 1))
end

function t1.ease_out(p45) -- line: 639
    return 1 - (1 - p45) ^ 3
end

function t1.ease_in_out(p46) -- line: 643
    if p46 < 0.5 then
        return p46 ^ 3 * 4
    end

    return 1 - (p46 * -2 + 2) ^ 3 / 2
end

function t1.ease_back(p47) -- line: 651
    -- upvalues: v3 (copy)
    local ease_back_overshoot = v3.CONSTANTS.ease_back_overshoot

    return 1 + (ease_back_overshoot + 1) * (p47 - 1) ^ 3 + ease_back_overshoot * (p47 - 1) ^ 2
end

function t1.get_lamp(p48, p49, p50) -- line: 657
    -- upvalues: v3 (copy), t1 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v30 = p49:FindFirstChild(CONSTANTS.rig_cone_name, true) or error((("%* has no %* cone to light"):format(p49:GetFullName(), CONSTANTS.rig_cone_name)))
    local t8 = {}
    local t9 = {}

    for _, descendant in p49:GetDescendants() do
        if descendant:IsA("Light") then
            table.insert(t8, {
                light = descendant,
                color = descendant.Color,
                brightness = descendant.Brightness,
                angle = if descendant:IsA("SpotLight") then descendant.Angle else nil
            })
        elseif p50 and descendant:IsA("BasePart") and descendant.Material == Enum.Material.Neon and descendant ~= v30 then
            t9[descendant] = descendant.Color
        end
    end

    local t11 = {
        shown_tint = -1,
        shown_output = -1,
        shown_narrow = -1,
        lights = t8,
        glows = t9,
        cone = v30,
        color = v30.Color,
        transparency = v30.Transparency,
        width = v30.Size
    }

    p48.maid:GiveTask(function() -- line: 696
        -- upvalues: t11 (copy), t1 (copy)
        t1.set_lamp(t11, 0, 1, 0)
    end)

    return t11
end

function t1.shake(p51, p52) -- line: 703
    -- upvalues: v2 (copy)
    local v31 = v2.new(p52)

    table.insert(p51.shakes, v31)

    return v31
end

function t1.connect_shakes(p53) -- line: 710
    -- upvalues: RunService (copy), v2 (copy)
    p53.maid:GiveTask(RunService.PreRender:Connect(function(p54) -- line: 711
        -- upvalues: p53 (copy), v2 (copy)
        local shakes = p53.shakes

        for i = #shakes, 1, -1 do
            if not v2.shake_camera(shakes[i], p54) then
                table.remove(shakes, i)
            end
        end
    end))
end

function t1.get_chased_by() -- line: 721
    -- upvalues: v3 (copy), t1 (copy)
    local Character = t1.LOCAL_PLAYER.Character

    if Character then
        return (Character:GetAttribute(v3.CONSTANTS.spotlight_targeted_attribute))
    end

    return nil
end

function t1.set_lamp(p55, p56, p57, p58) -- line: 729
    -- upvalues: v3 (copy), v4 (copy)
    local CONSTANTS = v3.CONSTANTS
    local spotlight_lamp_steps = CONSTANTS.spotlight_lamp_steps
    local v33 = math.round(p56 * spotlight_lamp_steps) / spotlight_lamp_steps
    local v35 = math.round(p57 * spotlight_lamp_steps) / spotlight_lamp_steps
    local v37 = math.round(p58 * spotlight_lamp_steps) / spotlight_lamp_steps
    local v38 = v33 ~= p55.shown_tint
    local v39 = v35 ~= p55.shown_output
    local v40 = v37 ~= p55.shown_narrow

    p55.shown_tint = v33
    p55.shown_output = v35
    p55.shown_narrow = v37

    if v39 then
        for v41, v42 in p55.glows do
            v41.Color = v4:Lerp(v42, v35)
        end
    end

    local spotlight_hunt_color = CONSTANTS.spotlight_hunt_color
    local v43 = v3.get_narrow(v37)

    for _, v44 in p55.lights do
        local light = v44.light

        if v38 then
            light.Color = v44.color:Lerp(spotlight_hunt_color, v33)
        end

        if v39 then
            light.Brightness = v44.brightness * v35
        end

        local angle = v44.angle

        if v40 and angle then
            light.Angle = angle * v43
        end
    end

    local cone = p55.cone

    if v38 then
        cone.Color = p55.color:Lerp(spotlight_hunt_color, v33)
    end

    if v39 then
        cone.Transparency = 1 - (1 - p55.transparency) * v35
    end

    if not v40 then
        return
    end

    cone.Size = Vector3.new(p55.width.X * v43, p55.width.Y, p55.width.Z * v43)
end

function t1.get_rig(p59, p60) -- line: 786
    -- upvalues: v1 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v47 = p60:WaitForChild(CONSTANTS.rig_yaw_hinge_name)
    local v48 = p60:WaitForChild(CONSTANTS.rig_pitch_hinge_name)
    local t12 = {
        yaw = v47,
        pitch = v48,
        frames = v1.get_frames(p60, CFrame.identity),
        held_yaw = math.rad(v47.TargetAngle),
        held_pitch = math.rad(v48.TargetAngle)
    }
    local Attachment0Parent = v47.Attachment0.Parent
    local v49 = Attachment0Parent:WaitForChild(v3.CONSTANTS.motor_sound_name)

    v49.Looped = true
    v49.Volume = 0
    v49:Play()
    p59.maid:GiveTask(function() -- line: 806
        -- upvalues: v49 (copy)
        v49:Stop()
    end)

    return {
        aim = nil,
        aimed = nil,
        joints = t12,
        base = Attachment0Parent,
        motor = {
            speed = 0,
            load = 0,
            shown_volume = 0,
            sound = v49,
            shown_pitch = v49.PlaybackSpeed
        }
    }
end

local function get_turn(p61, p62) -- line: 819
    return (math.abs((p62 - p61 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793))
end

local function aim_rig(p63, p64) -- line: 823
    -- upvalues: v1 (copy)
    local joints = p63.joints
    local held_yaw, held_pitch = joints.held_yaw, joints.held_pitch
    local v51, v52 = v1.aim(joints.frames, p64, held_yaw)

    if v51 ~= held_yaw then
        joints.held_yaw = v51
        joints.yaw.TargetAngle = math.deg(v51)
    end

    if v52 ~= held_pitch then
        joints.held_pitch = v52
        joints.pitch.TargetAngle = math.deg(v52)
    end

    return math.abs((v51 - held_yaw + 3.141592653589793) % 6.283185307179586 - 3.141592653589793) + math.abs((v52 - held_pitch + 3.141592653589793) % 6.283185307179586 - 3.141592653589793)
end

local function drive_motor(p65, p66, p67, p68) -- line: 842
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local speed = p65.speed

    p65.speed = v3.approach(p65.speed, p66 / p67, p67 / CONSTANTS.motor_spool_duration)

    local v57 = math.abs(p65.speed - speed) / p67

    p65.load = v3.approach(p65.load, v57, p67 / CONSTANTS.motor_load_smoothing)

    local v59 = math.min(p65.speed / CONSTANTS.motor_top_speed, 1)
    local v61 = math.min(p65.load / CONSTANTS.motor_stall_load, 1)
    local v62 = v59 * (1 - CONSTANTS.motor_slip * v61)
    local motor_sound_step = CONSTANTS.motor_sound_step
    local v63 = CONSTANTS.motor_idle_pitch + (CONSTANTS.motor_top_pitch - CONSTANTS.motor_idle_pitch) * v62
    local v64 = (CONSTANTS.motor_speed_volume * v59 + CONSTANTS.motor_load_volume * v61) * p68
    local v66 = math.round(v63 / motor_sound_step) * motor_sound_step
    local v68 = math.round(v64 / motor_sound_step) * motor_sound_step

    if v66 ~= p65.shown_pitch then
        p65.shown_pitch = v66
        p65.sound.PlaybackSpeed = v66
    end

    if v68 ~= p65.shown_volume then
        p65.shown_volume = v68
        p65.sound.Volume = v68
    end
end

function t1.turn_rig(p69, p70, p71, p72, p73) -- line: 872
    -- upvalues: v3 (copy), aim_rig (copy), drive_motor (copy)
    local v69

    if p70 then
        local aim = p69.aim
        local v70 = if aim then aim + (p70 - aim) * math.min(p72 * p71, 1) else p70

        if (p70 - v70).Magnitude <= v3.CONSTANTS.rig_aim_snap then
            v70 = p70
        end

        p69.aim = v70

        if v70 == p69.aimed then
            v69 = 0
        else
            p69.aimed = v70
            v69 = aim_rig(p69, v70)
        end
    else
        v69 = 0
    end

    drive_motor(p69.motor, v69, p72, p73)
end

function t1.get_hunt_pulse(p74) -- line: 892
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v74 = math.sin(p74 * CONSTANTS.spotlight_hunt_pulse_rate * 2 * 3.141592653589793) * 0.5 + 0.5

    return CONSTANTS.spotlight_hunt_pulse_floor + (1 - CONSTANTS.spotlight_hunt_pulse_floor) * v74
end

function t1.charge(p75, p76) -- line: 900
    -- upvalues: v3 (copy)
    if p75.on then
        p75.level = math.min(p75.level + p76 / v3.CONSTANTS.spotlight_fizzle_duration, 1)
    end
end

function t1.get_fizzle(p77) -- line: 906
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local level = p77.level

    if level <= 0 or level >= 1 then
        return level
    end

    return level * (1 - math.abs((math.sin(os.clock() * CONSTANTS.spotlight_fizzle_flicker_frequency))) * CONSTANTS.spotlight_fizzle_flicker_depth)
end

return table.freeze(t1)
