-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local load = require(ReplicatedStorage.Fsys).load
local BulkMoveToBatch = load("BulkMoveToBatch")
local DownloadClient = load("DownloadClient")
local Music = load("Music")
local UIManager = load("UIManager")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightFlashClient")
local v3 = require("./SpotlightShared")
local t1 = {}
local v4 = BulkMoveToBatch.new()
local v5

local function get_claimed_at() -- line: 47
    -- upvalues: v1 (copy), v3 (copy)
    return (v1.LOCAL_PLAYER:GetAttribute(v3.CONSTANTS.marker_claimed_attribute))
end

local function set_presence(p1, p2, p3) -- line: 51
    -- upvalues: v3 (copy)
    p1.scale = p2
    p1.opacity = p3
    p1.model:ScaleTo((math.max(p2, v3.CONSTANTS.visual_min_scale)))

    if p1.key then
        p1.key:ScaleTo((math.max(p2, v3.CONSTANTS.visual_min_scale)))
    end

    for v6, v7 in p1.parts do
        v6.Transparency = 1 - (1 - v7) * p3
    end
end

local function build_part(p4) -- line: 64
    -- upvalues: v1 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local v8 = v3.get_resources():FindFirstChild(p4) or error((("no marker part %*"):format(p4)))
    local v9 = v1.build_visual(v8)
    local v10 = v9:FindFirstChild(CONSTANTS.marker_primary_name)

    assert(v10 and v10:IsA("BasePart"), (("%* needs a %* part"):format(p4, CONSTANTS.marker_primary_name)))
    v9.PrimaryPart = v10

    return v9
end

local function stop_tweens(p5) -- line: 77
    for _, v13 in p5.tweens do
        v13:Cancel()
    end

    table.clear(p5.tweens)
end

local function play_tween(p6, p7, p8) -- line: 85
    -- upvalues: TweenService (copy)
    local v14 = TweenService:Create(p6.token_part, p7, p8)

    v14:Play()
    table.insert(p6.tweens, v14)
end

local function begin_retreat(p9, p10, p11) -- line: 91
    for _, v15 in p10.tweens do
        v15:Cancel()
    end

    table.clear(p10.tweens)
    p10.retreat = p11
    p10.retreat_for = 0
    p10.retreat_scale = p10.scale
    p10.retreat_opacity = p10.opacity
    p9.markers.version += 1

    for _, v16 in p10.emitters do
        v16.Enabled = false
    end
end

local function destroy_visual(p12, p13) -- line: 104
    local v17 = p12.markers.visuals[p13]

    if not v17 then
        return
    end

    for _, v18 in v17.tweens do
        v18:Cancel()
    end

    table.clear(v17.tweens)
    v17.model:Destroy()

    if v17.key then
        v17.key:Destroy()
    end

    p12.markers.visuals[p13] = nil
    p12.markers.version += 1
end

local function show(p14, p15, p16, p17) -- line: 117
    -- upvalues: SoundService (copy), v1 (copy), v3 (copy), v5 (ref), set_presence (copy), build_part (copy)
    local CONSTANTS = v3.CONSTANTS
    local v19 = p14.markers.visuals[p15]

    if v19 then
        for _, v20 in v19.tweens do
            v20:Cancel()
        end

        table.clear(v19.tweens)
        v19.model:Destroy()

        if v19.key then
            v19.key:Destroy()
        end

        p14.markers.visuals[p15] = nil
        p14.markers.version += 1
    end

    local v21 = build_part(CONSTANTS.marker_ring_name)
    local v22 = build_part(CONSTANTS.marker_token_names[p16])

    v22.Parent = v21

    local Pivot = v21:GetPivot()

    v21:PivotTo(Pivot + (p15.Position - Pivot.Position))
    v21.Parent = p14.visuals

    local Attribute = v1.LOCAL_PLAYER:GetAttribute(CONSTANTS.crypt_key_at_attribute)
    local v23 = if not (Attribute and (p15.Position - Attribute).Magnitude <= CONSTANTS.marker_claim_radius) then nil else v1.build_visual(v5)

    if v23 then
        v23:PivotTo(CFrame.new(p15.Position) * v23:GetPivot().Rotation)
        v23.Parent = p14.visuals
    end

    local t2 = {}
    local t3 = {}

    for _, v24 in { v21, v23 } do
        for _, descendant in v24:GetDescendants() do
            if descendant:IsA("BasePart") then
                t2[descendant] = descendant.Transparency
            elseif descendant:IsA("ParticleEmitter") then
                table.insert(t3, descendant)
            end
        end
    end

    local PrimaryPart = v22.PrimaryPart

    for _, descendant in v22:GetDescendants() do
        assert(descendant == PrimaryPart or not descendant:IsA("BasePart"), (("%* must be a single part to spin on a tween"):format(CONSTANTS.marker_token_names[p16])))
    end

    local t4 = {
        age = 0,
        settled = false,
        scale = 0,
        opacity = 0,
        retreat = nil,
        retreat_for = 0,
        retreat_scale = 0,
        retreat_opacity = 0,
        anchor = p15,
        kind = p16,
        shown_at = p17,
        model = v21,
        parts = t2,
        emitters = t3,
        token = v22,
        token_part = PrimaryPart,
        token_rotation = v22:GetPivot().Rotation,
        key = v23,
        key_rotation = if v23 then v23:GetPivot().Rotation else CFrame.identity,
        tweens = {}
    }

    set_presence(t4, 0, 0)
    p14.markers.visuals[p15] = t4
    p14.markers.version += 1

    if p14.markers.announced_at ~= p17 then
        p14.markers.announced_at = p17
        v1.play_layered_sound(CONSTANTS.sound_marker_appear, SoundService)
    end
end

local function claim(p18, p19) -- line: 200
    -- upvalues: SoundService (copy), Music (copy), v1 (copy), v2 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local kind

    for _, v27 in p18.markers.visuals do
        if v27.retreat ~= "pop" and v27.shown_at == p19 then
            for _, v28 in v27.tweens do
                v28:Cancel()
            end

            table.clear(v27.tweens)
            v27.retreat = "pop"
            v27.retreat_for = 0
            v27.retreat_scale = v27.scale
            v27.retreat_opacity = v27.opacity
            p18.markers.version += 1

            for _, v29 in v27.emitters do
                v29.Enabled = false
            end

            kind = v27.kind
            v1.play_vfx(p18, CONSTANTS.vfx_marker_activated, v27.anchor.Position)
        end
    end

    if not kind then
        return
    end

    v1.play_layered_sound(CONSTANTS.sound_marker_kind_activated[kind], SoundService)
    p18.markers.claimed += 1
    Music.adjust_global_playback_speed(1 + p18.markers.claimed * CONSTANTS.music_powerup_speedup)
    v2.play(p18, CONSTANTS.marker_flash_duration)
    v1.shake(p18, {
        envelope = "decay",
        amplitude = CONSTANTS.marker_shake_amplitude,
        frequency = CONSTANTS.marker_shake_frequency,
        time = CONSTANTS.marker_shake_duration
    })

    if not p18.markers.hinted[kind] then
        p18.markers.hinted[kind] = true
        v1.show_hint(CONSTANTS.hint_powerup_kind[kind])
    end
end

local function step_retreat(p20, p21, p22) -- line: 234
    -- upvalues: v1 (copy), v3 (copy), set_presence (copy)
    local CONSTANTS = v3.CONSTANTS

    p21.retreat_for += p22

    local v30 = p21.retreat == "pop"
    local v31 = if v30 then CONSTANTS.marker_pop_duration else CONSTANTS.marker_fade_duration
    local v32 = v1.get_alpha(0, p21.retreat_for, v31)
    local v33 = if v30 then 1 + (CONSTANTS.marker_pop_scale - 1) * v1.ease_out(v32) else v1.ease_back(1 - v32)

    set_presence(p21, p21.retreat_scale * v33, p21.retreat_opacity * (1 - v32))

    if not (v32 >= 1) then
        return
    end

    local anchor = p21.anchor
    local v34 = p20.markers.visuals[anchor]

    if not v34 then
        return
    end

    for _, v35 in v34.tweens do
        v35:Cancel()
    end

    table.clear(v34.tweens)
    v34.model:Destroy()

    if v34.key then
        v34.key:Destroy()
    end

    p20.markers.visuals[anchor] = nil
    p20.markers.version += 1
end

local function start_idle(p23) -- line: 254
    -- upvalues: TweenService (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local token_part = p23.token_part
    local v36 = TweenInfo.new(CONSTANTS.marker_token_bob_period / 2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
    local t5 = {
        Position = token_part.Position + Vector3.new(0, 1, 0) * CONSTANTS.marker_token_bob_height * 2
    }
    local v37 = TweenService:Create(p23.token_part, v36, t5)

    v37:Play()
    table.insert(p23.tweens, v37)

    local v38 = TweenInfo.new(CONSTANTS.marker_token_spin_period, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
    local t6 = {
        Orientation = token_part.Orientation + Vector3.new(0, 360, 0)
    }
    local v39 = TweenService:Create(p23.token_part, v38, t6)

    v39:Play()
    table.insert(p23.tweens, v39)
end

local function step_arrival(p24, p25) -- line: 276
    -- upvalues: v1 (copy), v3 (copy), v4 (copy), set_presence (copy), start_idle (copy)
    local CONSTANTS = v3.CONSTANTS
    local marker_fade_duration = CONSTANTS.marker_fade_duration

    p24.age = math.min(p24.age + p25, marker_fade_duration)

    local v41 = p24.age / marker_fade_duration

    set_presence(p24, v1.ease_back(v41), (math.min(v41 * 2, 1)))

    local v46 = -CONSTANTS.marker_token_bob_height * math.cos((p24.age - marker_fade_duration) * 2 * 3.141592653589793 / CONSTANTS.marker_token_bob_period)
    local v47 = (CONSTANTS.marker_token_height + v46) * v41
    local v48 = p24.age * 2 * 3.141592653589793 / CONSTANTS.marker_token_spin_period
    local v49 = CFrame.new(p24.anchor.Position + Vector3.new(0, 1, 0) * v47) * CFrame.Angles(0, v48, 0) * p24.token_rotation * p24.token:GetPivot():ToObjectSpace(p24.token_part.CFrame)

    if v41 < 1 then
        v4:add_part(p24.token_part, v49)
    else
        p24.settled = true
        p24.token_part.CFrame = v49
        start_idle(p24)
    end
end

local function place_key(p26) -- line: 306
    -- upvalues: v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local key = p26.key

    if key then
        key:PivotTo((p26.token:GetPivot() * p26.token_rotation:Inverse() + Vector3.new(0, 1, 0) * (CONSTANTS.crypt_key_height * math.max(p26.scale, CONSTANTS.visual_min_scale))) * p26.key_rotation)
    end
end

local function anchor_changed(p27, p28) -- line: 320
    -- upvalues: v1 (copy), v3 (copy), show (copy)
    local CONSTANTS = v3.CONSTANTS
    local Attribute = p28:GetAttribute(CONSTANTS.marker_kind_attribute)
    local Attribute2 = p28:GetAttribute(CONSTANTS.marker_shown_attribute)
    local v51 = p27.markers.visuals[p28]

    if Attribute and Attribute2 then
        if (not v51 or v51.shown_at ~= Attribute2) and Attribute2 ~= v1.LOCAL_PLAYER:GetAttribute(v3.CONSTANTS.marker_claimed_attribute) then
            show(p27, p28, Attribute, Attribute2)
        end
    else
        if not v51 or v51.retreat then
            return
        end

        for _, v52 in v51.tweens do
            v52:Cancel()
        end

        table.clear(v51.tweens)
        v51.retreat = "fizzle"
        v51.retreat_for = 0
        v51.retreat_scale = v51.scale
        v51.retreat_opacity = v51.opacity
        p27.markers.version += 1

        for _, v53 in v51.emitters do
            v53.Enabled = false
        end
    end
end

function t1.connect_all_markers(p29, p30) -- line: 339
    -- upvalues: RunService (copy), DownloadClient (copy), UIManager (copy), v1 (copy), v3 (copy), v4 (copy), v5 (ref), claim (copy), step_retreat (copy), step_arrival (copy), place_key (copy), anchor_changed (copy)
    local CONSTANTS = v3.CONSTANTS

    if not v5 then
        local v54 = DownloadClient.promise_download_copy("Holdables", "Halloween2026RustyKey"):expect()

        v54.RightMount:Destroy()
        v54.WorldPivot = v54:GetBoundingBox()
        v5 = v54
    end

    local function connect(p31) -- line: 349
        -- upvalues: p29 (copy), CONSTANTS (copy), anchor_changed (copy)
        if not p31:IsA("BasePart") then
            return
        end

        p31.Transparency = 1

        local function changed() -- line: 356
            -- upvalues: p31 (copy), p29 (copy), anchor_changed (copy)
            anchor_changed(p29, p31)
        end

        p29.maid:GiveTask(p31:GetAttributeChangedSignal(CONSTANTS.marker_kind_attribute):Connect(changed))
        p29.maid:GiveTask(p31:GetAttributeChangedSignal(CONSTANTS.marker_shown_attribute):Connect(changed))
        anchor_changed(p29, p31)
    end

    for _, descendant in p30:GetDescendants() do
        connect(descendant)
    end

    p29.maid:GiveTask(p30.DescendantAdded:Connect(connect))
    p29.maid:GiveTask(v1.LOCAL_PLAYER:GetAttributeChangedSignal(CONSTANTS.crypt_key_claimed_attribute):Connect(function() -- line: 374
        -- upvalues: p29 (copy), CONSTANTS (copy), UIManager (copy), v1 (copy)
        if v1.LOCAL_PLAYER:GetAttribute(CONSTANTS.crypt_key_claimed_attribute) then
            p29.maid:GiveTask(task.spawn(function() -- line: 380
                -- upvalues: CONSTANTS (copy), UIManager (copy), v1 (copy)
                while UIManager.apps.HintApp:is_displaying_hint() do
                    task.wait(0.1)
                end

                v1.show_hint(CONSTANTS.hint_crypt_key, true)
            end))
        end
    end))
    p29.maid:GiveTask(v1.LOCAL_PLAYER:GetAttributeChangedSignal(CONSTANTS.marker_claimed_attribute):Connect(function() -- line: 393
        -- upvalues: p29 (copy), v1 (copy), v3 (copy), claim (copy)
        local Attribute = v1.LOCAL_PLAYER:GetAttribute(v3.CONSTANTS.marker_claimed_attribute)

        if Attribute then
            claim(p29, Attribute)
        end
    end))

    local v55 = v3.get_marker_uptime() - CONSTANTS.marker_fade_duration

    p29.maid:GiveTask(RunService.Heartbeat:Connect(function(p32) -- line: 403
        -- upvalues: p29 (copy), v55 (copy), v4 (copy), step_retreat (copy), step_arrival (copy), place_key (copy)
        local ServerTimeNow = workspace:GetServerTimeNow()
        local v56 = false

        for _, v57 in p29.markers.visuals do
            if not v57.retreat and v57.shown_at + v55 <= ServerTimeNow then
                for _, v58 in v57.tweens do
                    v58:Cancel()
                end

                table.clear(v57.tweens)
                v57.retreat = "fizzle"
                v57.retreat_for = 0
                v57.retreat_scale = v57.scale
                v57.retreat_opacity = v57.opacity
                p29.markers.version += 1

                for _, v59 in v57.emitters do
                    v59.Enabled = false
                end
            end

            if v57.retreat then
                step_retreat(p29, v57, p32)
            elseif not v57.settled then
                v56 = true
                step_arrival(v57, p32)
            end
        end

        if v56 then
            v4:execute(Enum.BulkMoveMode.FireCFrameChanged)
        end

        for _, v60 in p29.markers.visuals do
            place_key(v60)
        end
    end))
    p29.maid:GiveTask(function() -- line: 429
        -- upvalues: p29 (copy), v4 (copy)
        v4:destroy()

        for _, v61 in p29.markers.visuals do
            for _, v62 in v61.tweens do
                v62:Cancel()
            end

            table.clear(v61.tweens)
        end
    end)
end

return table.freeze(t1)
