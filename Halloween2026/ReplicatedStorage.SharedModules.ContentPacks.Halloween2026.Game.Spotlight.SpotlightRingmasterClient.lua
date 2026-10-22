-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local load = require(ReplicatedStorage.Fsys).load
local AnimationManager = load("AnimationManager")
local AnimationUtil = load("AnimationUtil")
local v1 = require("./SpotlightAimClient")
local v2 = require("./SpotlightClientState")
local v3 = require("./SpotlightShared")
local t1 = {}

local function show_clubs(p1, p2) -- line: 30
    for v4, v5 in p1.clubs do
        local v6 = if p2[v4] then 0 else 1

        for _, v7 in v5 do
            v7.Transparency = v6
        end
    end
end

local function poof_club(p3, p4) -- line: 39
    -- upvalues: v2 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v8 = v2.play_vfx(p3, CONSTANTS.vfx_poof, p4, nil, nil, CONSTANTS.ringmaster_scale)

    if v8 then
        v2.play_layered_sound(CONSTANTS.sound_club_poof, v8)
    end
end

local function reveal(p5) -- line: 48
    if p5.revealed then
        return
    end

    p5.revealed = true

    for _, descendant in p5.rig:GetDescendants() do
        if descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 0
        end
    end
end

local function play(p6, p7) -- line: 61
    local playing = p6.playing

    if playing then
        playing:Stop()
    end

    local v9 = p6.tracks[p7]

    v9:Play()
    v9:AdjustSpeed(1)
    p6.playing = v9

    return v9
end

local function build_rig(p8, p9) -- line: 75
    -- upvalues: v2 (copy), v3 (copy), show_clubs (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p8.ringmaster
    local v10 = v3.get_resources()
    local v11 = v2.build_visual((v10:WaitForChild(CONSTANTS.ringmaster_rig_name)))

    v11:ScaleTo(CONSTANTS.ringmaster_scale)
    v11:PivotTo(p9.CFrame)
    ringmaster.facing = p9.CFrame

    for _, descendant in v11:GetDescendants() do
        if descendant:IsA("Bone") then
            ringmaster.bones[descendant.Name] = descendant
        elseif descendant:IsA("BasePart") then
            descendant.LocalTransparencyModifier = 1
        end
    end

    for v12, v13 in CONSTANTS.ringmaster_clubs do
        local t2 = {}

        for _, v14 in v13 do
            table.insert(t2, v11:FindFirstChild(v14) or error((("%* has no %*"):format(v11:GetFullName(), v14))))
        end

        ringmaster.clubs[v12] = t2
    end

    local v16 = v11:FindFirstChild(CONSTANTS.ringmaster_club_handle_name) or error((("%* has no %* to throw from"):format(v11:GetFullName(), CONSTANTS.ringmaster_club_handle_name)))

    ringmaster.club_offset = ringmaster.bones[CONSTANTS.ringmaster_held_club].WorldCFrame:ToObjectSpace(v16.CFrame)
    ringmaster.rig = v11
    show_clubs(ringmaster, {})
    v11.Parent = p8.visuals
    p8.maid:GiveTask(v11)

    return v11
end

local function throw_club(p10, p11) -- line: 113
    -- upvalues: Players (copy), v2 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p10.ringmaster
    local v17 = v3.get_resources():FindFirstChild(CONSTANTS.ringmaster_club_name) or error((("Resources has no %* for the ringmaster to throw"):format(CONSTANTS.ringmaster_club_name)))
    local v18 = v2.build_visual(v17)

    v18:ScaleTo(CONSTANTS.ringmaster_scale)

    local v19 = v18.PrimaryPart or error((("%* has no PrimaryPart"):format((v18:GetFullName()))))
    local v20 = v19:FindFirstChild(CONSTANTS.ringmaster_club_grip_name)

    assert(v20 and v20:IsA("Attachment"), (("%* needs a %*"):format(v18:GetFullName(), CONSTANTS.ringmaster_club_grip_name)))
    v18:PivotTo(ringmaster.bones[CONSTANTS.ringmaster_held_club].TransformedWorldCFrame * ringmaster.club_offset * v19.CFrame:ToObjectSpace(v18:GetPivot()))
    v18.Parent = p10.visuals

    local Attribute = p11:GetAttribute(CONSTANTS.ringmaster_throw_target_attribute)
    local v23 = Attribute or ringmaster.stage.Position
    local v24 = p11:FindFirstChild(CONSTANTS.obstacle_folder_name)
    local descendant

    if Attribute and v24 then
        for _, descendant2 in v24:GetDescendants() do
            if descendant2:IsA("BasePart") and (descendant2.Position - Attribute).Magnitude < 0.01 then
                descendant = descendant2
                break
            end
        end
    end

    local t3 = {
        p10.visuals
    }

    for _, player in Players:GetPlayers() do
        if player.Character then
            table.insert(t3, player.Character)
        end
    end

    local v25 = RaycastParams.new()

    v25.FilterType = Enum.RaycastFilterType.Exclude
    v25.FilterDescendantsInstances = t3
    v25.RespectCanCollide = true
    table.insert(ringmaster.thrown, {
        elapsed = 0,
        heading = Vector3.new(0, 0, 0),
        velocity = nil,
        landed = false,
        released = false,
        model = v18,
        grip = v18:GetPivot():ToObjectSpace(v20.WorldCFrame),
        from = v18:GetPivot().Position,
        to = v23,
        board = descendant,
        at = v23,
        params = v25
    })
end

local function on_summoned(p12, p13) -- line: 178
    -- upvalues: AnimationUtil (copy), v2 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p12.ringmaster

    AnimationUtil.model_transform_handler(ringmaster.rig, p13)

    local TransformedWorldCFramePosition = ringmaster.bones[CONSTANTS.ringmaster_held_club].TransformedWorldCFrame.Position
    local CONSTANTS2 = v3.CONSTANTS
    local v26 = v2.play_vfx(p12, CONSTANTS2.vfx_poof, TransformedWorldCFramePosition, nil, nil, CONSTANTS2.ringmaster_scale)

    if v26 then
        v2.play_layered_sound(CONSTANTS2.sound_club_poof, v26)
    end
end

local function on_released(p14, p15, p16) -- line: 186
    -- upvalues: AnimationUtil (copy), throw_club (copy)
    AnimationUtil.model_transform_handler(p14.ringmaster.rig, p16)
    throw_club(p14, p15)
end

local function load_animations(p17, p18, p19) -- line: 191
    -- upvalues: AnimationManager (copy), AnimationUtil (copy), v2 (copy), v3 (copy), throw_club (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p17.ringmaster
    local v27 = p19:FindFirstChildWhichIsA("Animator", true) or error((("%* has no Animator to play the ringmaster's animations"):format((p19:GetFullName()))))

    for v28, v29 in CONSTANTS.ringmaster_animations do
        local track = v27:LoadAnimation(AnimationManager.get_track(CONSTANTS.ringmaster_animation_prefix .. v28))

        track.Priority = Enum.AnimationPriority.Movement
        track.Looped = v29
        ringmaster.tracks[v28] = track
        p17.maid:GiveTask(track)
    end

    local ringmaster_transform_marker = CONSTANTS.ringmaster_transform_marker

    p17.maid:GiveTask(ringmaster.tracks.Summon:GetMarkerReachedSignal(ringmaster_transform_marker):Connect(function(p20) -- line: 207
        -- upvalues: p17 (copy), AnimationUtil (copy), v2 (copy), v3 (copy)
        local CONSTANTS = v3.CONSTANTS
        local ringmaster = p17.ringmaster

        AnimationUtil.model_transform_handler(ringmaster.rig, p20)

        local TransformedWorldCFramePosition = ringmaster.bones[CONSTANTS.ringmaster_held_club].TransformedWorldCFrame.Position
        local CONSTANTS2 = v3.CONSTANTS
        local v30 = v2.play_vfx(p17, CONSTANTS2.vfx_poof, TransformedWorldCFramePosition, nil, nil, CONSTANTS2.ringmaster_scale)

        if v30 then
            v2.play_layered_sound(CONSTANTS2.sound_club_poof, v30)
        end
    end))
    p17.maid:GiveTask(ringmaster.tracks.Throw:GetMarkerReachedSignal(ringmaster_transform_marker):Connect(function(p21) -- line: 210
        -- upvalues: p17 (copy), p18 (copy), AnimationUtil (copy), throw_club (copy)
        AnimationUtil.model_transform_handler(p17.ringmaster.rig, p21)
        throw_club(p17, p18)
    end))

    local v31 = v2.load_track(p17.maid, v27, CONSTANTS.ringmaster_react_animation)

    if not v31 then
        return
    end

    v31.Priority = Enum.AnimationPriority.Action
    v31.Looped = false
    ringmaster.reaction = v31
end

local function run_intro(p22) -- line: 222
    -- upvalues: v2 (copy), v3 (copy), show_clubs (copy), reveal (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p22.ringmaster
    local ringmaster_animation_lengths = CONSTANTS.ringmaster_animation_lengths
    local v32 = p22.entered_at or error("Spotlight's ringmaster intro ran before its player entered")
    local v33 = v32 + v3.get_ringmaster_entrance()
    local v34 = v33 + ringmaster_animation_lengths.Jump - CONSTANTS.ringmaster_jump_start

    task.wait((math.max(v33 - os.clock(), 0)))

    local v36 = v2.get_local_root()
    local facingPosition = ringmaster.facing.Position
    local v37 = if v36 then Vector3.new(v36.Position.X, facingPosition.Y, v36.Position.Z) else facingPosition

    if (v37 - facingPosition).Magnitude > 0.001 then
        local rig = ringmaster.rig

        ringmaster.facing = CFrame.lookAt(facingPosition, v37)
        rig:PivotTo(ringmaster.facing)
    end

    show_clubs(ringmaster, {})
    reveal(ringmaster)

    if os.clock() < v34 then
        v2.play_vfx(p22, CONSTANTS.vfx_poof, ringmaster.bones[CONSTANTS.ringmaster_torso_bone_name].TransformedWorldCFrame.Position, CONSTANTS.ringmaster_appear_poof_amount, nil, CONSTANTS.ringmaster_scale)

        local playing = ringmaster.playing

        if playing then
            playing:Stop()
        end

        local Jump = ringmaster.tracks.Jump

        Jump:Play()
        Jump:AdjustSpeed(1)
        ringmaster.playing = Jump
        Jump.TimePosition = CONSTANTS.ringmaster_jump_start + os.clock() - v33
        task.wait(v34 - os.clock())
    end

    local v38 = v32 + v3.get_ringmaster_trick_start()

    if os.clock() < v38 then
        local playing = ringmaster.playing

        if playing then
            playing:Stop()
        end

        local Summon = ringmaster.tracks.Summon

        Summon:Play()
        Summon:AdjustSpeed(1)
        ringmaster.playing = Summon
        Summon.TimePosition = os.clock() - v34
        task.wait(v38 - os.clock())
    end

    show_clubs(ringmaster, {
        [CONSTANTS.ringmaster_held_club] = true
    })

    local playing = ringmaster.playing

    if playing then
        playing:Stop()
    end

    local Trick2 = ringmaster.tracks.Trick2

    Trick2:Play()
    Trick2:AdjustSpeed(1)
    ringmaster.playing = Trick2
    Trick2.TimePosition = (os.clock() - v38) % ringmaster_animation_lengths.Trick2
end

local function stop_intro(p23) -- line: 269
    local intro = p23.intro

    if intro and coroutine.status(intro) == "suspended" then
        task.cancel(intro)
    end

    p23.intro = nil
end

local function enter_state(p24, p25) -- line: 277
    -- upvalues: v2 (copy), v3 (copy), show_clubs (copy), reveal (copy), run_intro (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p24.ringmaster
    local intro = ringmaster.intro

    if intro and coroutine.status(intro) == "suspended" then
        task.cancel(intro)
    end

    ringmaster.intro = nil

    if p25 == "intro" then
        ringmaster.intro = task.spawn(run_intro, p24)
    elseif p25 then
        local v39 = CONSTANTS.ringmaster_state_animations[p25] or error((("the ringmaster has no animation for its %* state"):format(p25)))

        reveal(ringmaster)
        show_clubs(ringmaster, if p25 == "summon" then {} else {
            [CONSTANTS.ringmaster_held_club] = true
        })

        local playing = ringmaster.playing

        if playing then
            playing:Stop()
        end

        local v40 = ringmaster.tracks[v39]

        v40:Play()
        v40:AdjustSpeed(1)
        ringmaster.playing = v40

        if p25 == "throw" then
            local rig = ringmaster.rig
            local v41 = rig.PrimaryPart or error((("%* has no PrimaryPart to wind up from"):format((rig:GetFullName()))))

            v2.play_layered_sound(CONSTANTS.sound_ringmaster_windup, v41)
        end
    end
end

local function turn(p26, p27, p28) -- line: 306
    -- upvalues: v3 (copy)
    local facingPosition = p26.facing.Position
    local v42 = Vector3.new(p27.X, facingPosition.Y, p27.Z)

    if not ((v42 - facingPosition).Magnitude < 0.001) then
        local v43 = CFrame.lookAt(facingPosition, v42)

        if not (v43.LookVector:Dot(p26.facing.LookVector) > 0.99999) then
            local rig = p26.rig

            p26.facing = p26.facing:Lerp(v43, (math.min(p28 * v3.CONSTANTS.ringmaster_turn_speed, 1)))
            rig:PivotTo(p26.facing)
        end
    end
end

local function get_arc(p29, p30) -- line: 323
    -- upvalues: v3 (copy)
    local ringmaster_club_arc_height = v3.CONSTANTS.ringmaster_club_arc_height

    return p29.from:Lerp(p29.to, p30) + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * math.sin(p30 * 3.141592653589793)), p29.to - p29.from + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * 3.141592653589793 * math.cos(p30 * 3.141592653589793))
end

local function pose_club(p31, p32, p33) -- line: 332
    -- upvalues: v3 (copy)
    local Unit = p33.Unit
    local Unit2 = Unit:Cross((Vector3.new(0, 1, 0))).Unit
    local v51 = Unit2:Cross(Unit)
    local v52 = p31.elapsed * 2 * 3.141592653589793 / v3.CONSTANTS.ringmaster_club_spin_period
    local v53 = Unit * math.cos(v52) + v51 * math.sin(v52)

    p31.model:PivotTo(CFrame.fromMatrix(p32, v53, Unit2) * p31.grip.Rotation:Inverse())
end

local function carry_on(p34, p35, p36) -- line: 343
    -- upvalues: v3 (copy), pose_club (copy)
    local CONSTANTS = v3.CONSTANTS
    local v54 = CONSTANTS.ringmaster_club_rest_lift * CONSTANTS.ringmaster_scale
    local velocity = p34.velocity

    if not velocity then
        local ringmaster_club_arc_height = v3.CONSTANTS.ringmaster_club_arc_height
        local _ = p34.from:Lerp(p34.to, 1) + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * 0.00000000000000012246467991473532)
        local v55 = p34.to - p34.from + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * 3.141592653589793 * -1)

        p34.heading = v55
        velocity = v55 / p35
    end

    local v56 = velocity - Vector3.new(0, 1, 0) * workspace.Gravity * p36
    local v57 = v56 * p36
    local v58 = workspace:Raycast(p34.at, v57, p34.params)

    if v58 then
        if v58.Normal.Y > 0.5 then
            p34.at = v58.Position + v58.Normal * v54
            p34.landed = true
        else
            p34.at = v58.Position + v58.Normal * v54
            v56 = Vector3.new(0, math.min(v56.Y, 0), 0)
        end
    else
        p34.at += v57
    end

    p34.velocity = v56
    pose_club(p34, p34.at, p34.heading)
end

local function is_shattered(p37) -- line: 372
    -- upvalues: v3 (copy)
    local board = p37.board

    return not board or not board:IsDescendantOf(workspace) or board:GetAttribute(v3.CONSTANTS.obstacle_knocked_down_attribute) == true
end

local function release(p38, p39) -- line: 380
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local velocity, heading = p38.velocity, p38.heading

    if not velocity then
        local ringmaster_club_arc_height = v3.CONSTANTS.ringmaster_club_arc_height
        local _ = p38.from:Lerp(p38.to, 1) + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * 0.00000000000000012246467991473532)

        heading = p38.to - p38.from + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * 3.141592653589793 * -1)
        velocity = heading / p39
    end

    for _, descendant in p38.model:GetDescendants() do
        if descendant:IsA("BasePart") then
            local v60 = PhysicalProperties.new(descendant.Material)

            descendant.CustomPhysicalProperties = PhysicalProperties.new(CONSTANTS.ringmaster_club_density, v60.Friction, v60.Elasticity, v60.FrictionWeight, v60.ElasticityWeight)
            descendant.CollisionGroup = CONSTANTS.ringmaster_club_collision_group
            descendant.CanCollide = true
            descendant.Anchored = false
        end
    end

    local PrimaryPart = p38.model.PrimaryPart

    PrimaryPart.AssemblyLinearVelocity = if p38.landed then Vector3.new(0, 0, 0) else velocity

    if p38.landed then
        PrimaryPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    else
        PrimaryPart.AssemblyAngularVelocity = heading.Unit:Cross((Vector3.new(0, 1, 0))).Unit * 2 * 3.141592653589793 / CONSTANTS.ringmaster_club_spin_period
    end

    p38.released = true
end

local function step_thrown(p40, p41) -- line: 416
    -- upvalues: v2 (copy), v3 (copy), pose_club (copy), carry_on (copy), release (copy)
    local CONSTANTS = v3.CONSTANTS
    local v61 = CONSTANTS.ringmaster_throw_duration - CONSTANTS.ringmaster_club_release
    local v62 = v61 + CONSTANTS.ringmaster_club_linger_duration
    local thrown = p40.ringmaster.thrown

    for i = #thrown, 1, -1 do
        local v63 = thrown[i]

        v63.elapsed += p41

        if v62 <= v63.elapsed then
            local PrimaryPart = v63.model.PrimaryPart

            if PrimaryPart then
                local PrimaryPartPosition = PrimaryPart.Position
                local CONSTANTS = v3.CONSTANTS
                local v64 = v2.play_vfx(p40, CONSTANTS.vfx_poof, PrimaryPartPosition, nil, nil, CONSTANTS.ringmaster_scale)

                if v64 then
                    v2.play_layered_sound(CONSTANTS.sound_club_poof, v64)
                end
            end

            v63.model:Destroy()
            table.remove(thrown, i)
        elseif not v63.released then
            if v63.elapsed < v61 then
                local v65 = v63.elapsed / v61
                local ringmaster_club_arc_height = v3.CONSTANTS.ringmaster_club_arc_height

                pose_club(v63, v63.from:Lerp(v63.to, v65) + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * math.sin(v65 * 3.141592653589793)), v63.to - v63.from + Vector3.new(0, 1, 0) * (ringmaster_club_arc_height * 3.141592653589793 * math.cos(v65 * 3.141592653589793)))
            else
                local board = v63.board

                if not board or not board:IsDescendantOf(workspace) or board:GetAttribute(v3.CONSTANTS.obstacle_knocked_down_attribute) == true then
                    release(v63, v61)
                elseif not v63.landed then
                    carry_on(v63, v61, p41)
                end
            end
        end
    end
end

local function step(p42, p43, p44, p45, p46) -- line: 446
    -- upvalues: v1 (copy), v3 (copy), enter_state (copy), turn (copy), step_thrown (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p42.ringmaster
    local Attribute = p43:GetAttribute(CONSTANTS.ringmaster_state_attribute)

    if Attribute == "aim" and os.clock() < p45 then
        Attribute = "intro"
    end

    if Attribute == ringmaster.state then
        ringmaster.state_for += p46
    else
        ringmaster.state = Attribute
        ringmaster.state_for = 0
        enter_state(p42, Attribute)
    end

    local playing = ringmaster.playing

    if playing and not playing.Looped and playing.Speed ~= 0 and (not playing.IsPlaying or playing.Length > 0 and playing.TimePosition >= playing.Length - p46) then
        local v73 = if Attribute then CONSTANTS.ringmaster_hold_animations[Attribute] else nil

        if v73 then
            local playing = ringmaster.playing

            if playing then
                playing:Stop()
            end

            local v74 = ringmaster.tracks[v73]

            v74:Play()
            v74:AdjustSpeed(1)
            ringmaster.playing = v74
        else
            playing:AdjustSpeed(0)
        end
    end

    local Attribute2 = p43:GetAttribute(CONSTANTS.ringmaster_throw_target_attribute)

    if Attribute2 and (Attribute == "aim" or Attribute == "throw") then
        turn(ringmaster, Attribute2, p46)
    end

    local v75 = Attribute == "aim" or Attribute == "throw" and ringmaster.state_for < CONSTANTS.ringmaster_club_release
    local step = v1.step
    local TransformedWorldCFramePosition = ringmaster.bones[CONSTANTS.ringmaster_held_club].TransformedWorldCFrame.Position

    if not v75 then
        Attribute2 = nil
    end

    step(p44, TransformedWorldCFramePosition, Attribute2, p46, os.clock())
    step_thrown(p42, p46)
end

function t1.connect_ringmaster(p47, p48, p49) -- line: 501
    -- upvalues: RunService (copy), v1 (copy), v3 (copy), build_rig (copy), load_animations (copy), step (copy)
    local CONSTANTS = v3.CONSTANTS
    local ringmaster = p47.ringmaster
    local v76 = p48:WaitForChild(CONSTANTS.scene_aim_point_folder_name):WaitForChild(CONSTANTS.scene_stage_centre_name)

    ringmaster.stage = v76

    local v77 = build_rig(p47, v76)
    local v78 = v1.build(p47)

    load_animations(p47, p48, v77)
    p47.maid:GiveTask(function() -- line: 517
        -- upvalues: ringmaster (copy)
        local intro = ringmaster.intro

        if intro and coroutine.status(intro) == "suspended" then
            task.cancel(intro)
        end

        ringmaster.intro = nil
    end)
    p47.maid:GiveTask(p48:GetAttributeChangedSignal(CONSTANTS.ringmaster_reacted_attribute):Connect(function() -- line: 522
        -- upvalues: ringmaster (copy)
        local reaction = ringmaster.reaction

        if reaction then
            reaction:Stop()
            reaction:Play()
        end
    end))
    p47.maid:GiveTask(RunService.PreRender:Connect(function(p50) -- line: 531
        -- upvalues: p47 (copy), p48 (copy), p49 (copy), v78 (copy), step (copy)
        local entered_at = p47.entered_at

        if entered_at then
            step(p47, p48, v78, entered_at + p49, p50)
        end
    end))
end

return table.freeze(t1)
