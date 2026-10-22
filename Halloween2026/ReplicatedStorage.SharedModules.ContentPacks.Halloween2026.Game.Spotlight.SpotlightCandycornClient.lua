-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local load = require(ReplicatedStorage.Fsys).load
local BulkMoveToBatch = load("BulkMoveToBatch")
local SoundPlayer = load("SoundPlayer")
local v1 = require("./SpotlightCandycorn")
local v2 = require("./SpotlightCandycornPivoter")
local v3 = require("./SpotlightClientState")
local v4 = require("./SpotlightShared")
local t1 = {}
local v5 = v1.get_collected_attribute(v3.LOCAL_PLAYER)
local v6 = BulkMoveToBatch.new()

local function set_state(p1, p2, p3) -- line: 42
    p1.state = p2
    p1.state_started_at = p3
end

local function can_collect(p4) -- line: 47
    return p4.state == "idle"
end

local function set_size(p5, p6) -- line: 51
    p5.mesh.Scale = p5.full_scale * p6
    p5.mesh.Offset = p5.full_offset * p6 + p5.rise * (p6 - 1)
end

local function pose(p7, p8, p9) -- line: 56
    -- upvalues: v6 (copy)
    p7.mesh.Scale = p7.full_scale * p8
    p7.mesh.Offset = p7.full_offset * p8 + p7.rise * (p8 - 1)
    v6:add_part(p7.handle, p9 * p7.handle_offset)
end

local function stop_idling(p10, p11) -- line: 61
    -- upvalues: v2 (copy), v3 (copy)
    if p11.slot ~= 0 then
        v2.remove(v3.get_pivoter(p10), p11.slot)
        p11.slot = 0
    end
end

local function release_trail(p12) -- line: 68
    -- upvalues: v3 (copy)
    local trail = p12.trail

    if trail then
        p12.trail = nil
        v3.release_trail(trail)
    end
end

local function respawn(p13, p14, p15) -- line: 76
    -- upvalues: v2 (copy), v3 (copy), v4 (copy)
    local CONSTANTS = v4.CONSTANTS

    assert(p14.slot == 0, (("%* respawned while it was still idling"):format((p14.spawner:GetFullName()))))
    p14.confirm_at = nil

    local trail = p14.trail

    if trail then
        p14.trail = nil
        v3.release_trail(trail)
    end

    p14.slot = v2.add(v3.get_pivoter(p13), p14, p14.handle, p14.rest, p14.anchor, p15)
    p14.visual.Parent = p14.spawner
    v3.play_vfx(p13, CONSTANTS.vfx_candycorn_appear, p14.spawner.Position)
    p14.state = "idle"
    p14.state_started_at = p15
end

local function hide(p16, p17, p18) -- line: 98
    -- upvalues: v2 (copy), v3 (copy)
    if p17.slot ~= 0 then
        v2.remove(v3.get_pivoter(p16), p17.slot)
        p17.slot = 0
    end

    local trail = p17.trail

    if trail then
        p17.trail = nil
        v3.release_trail(trail)
    end

    p17.visual.Parent = nil
    p17.state = "collected"
    p17.state_started_at = p18
end

local function advance_streak(p19, p20) -- line: 105
    -- upvalues: v4 (copy)
    local CONSTANTS = v4.CONSTANTS

    p19.collect_streak = math.min((if p20 < p19.streak_decay_at then p19.collect_streak else math.max(0, p19.collect_streak - (p20 - p19.streak_decay_at))) + 1 / CONSTANTS.candycorn_streak_steps, 1)
    p19.streak_decay_at = p20 + CONSTANTS.candycorn_streak_grace

    return p19.collect_streak
end

local function play_collect_sound(p21, p22, p23) -- line: 118
    -- upvalues: SoundPlayer (copy), v4 (copy)
    local CONSTANTS = v4.CONSTANTS

    if p23 < p21.sound_ready_at then
        return
    end

    p21.sound_ready_at = p23 + CONSTANTS.candycorn_sound_debounce
    p21.sound_variant = p21.sound_variant % CONSTANTS.sound_candycorn_collect_count + 1
    SoundPlayer.FX:play(("%*/CandyCorn%*"):format(CONSTANTS.sound_candycorn_collect, p21.sound_variant), p22)
end

local function collect(p24, p25, p26) -- line: 130
    -- upvalues: SoundPlayer (copy), v2 (copy), v3 (copy), v4 (copy)
    local CONSTANTS = v4.CONSTANTS

    if p25.slot ~= 0 then
        v2.remove(v3.get_pivoter(p24), p25.slot)
        p25.slot = 0
    end

    p25.collect_from_size = p25.mesh.Scale.X / p25.full_scale.X
    p25.collect_from_cframe = p25.visual:GetPivot()
    p25.confirm_at = p26 + CONSTANTS.candycorn_confirm_timeout

    local candycorn = p24.candycorn
    local CONSTANTS2 = v4.CONSTANTS

    candycorn.collect_streak = math.min((if p26 < candycorn.streak_decay_at then candycorn.collect_streak else math.max(0, candycorn.collect_streak - (p26 - candycorn.streak_decay_at))) + 1 / CONSTANTS2.candycorn_streak_steps, 1)
    candycorn.streak_decay_at = p26 + CONSTANTS2.candycorn_streak_grace

    local collect_streak = candycorn.collect_streak
    local candycorn2 = p24.candycorn
    local spawner = p25.spawner
    local CONSTANTS3 = v4.CONSTANTS

    if not (p26 < candycorn2.sound_ready_at) then
        candycorn2.sound_ready_at = p26 + CONSTANTS3.candycorn_sound_debounce
        candycorn2.sound_variant = candycorn2.sound_variant % CONSTANTS3.sound_candycorn_collect_count + 1
        SoundPlayer.FX:play(("%*/CandyCorn%*"):format(CONSTANTS3.sound_candycorn_collect, candycorn2.sound_variant), spawner)
    end

    p25.collect_boost = 1 + collect_streak * CONSTANTS.candycorn_streak_boost
    p25.trail = v3.attach_trail(p24, CONSTANTS.vfx_candycorn_trail, p25.collect_from_cframe.Position)
    v3.play_vfx(p24, CONSTANTS.vfx_candycorn_collect, p25.collect_from_cframe.Position, p25.collect_boost)
    p25.state = "collecting"
    p25.state_started_at = p26
    p24.candycorn.active[p25] = true
    p24.report_collected(p25.spawner)
end

local function step_collecting(p27, p28, p29, p30) -- line: 171
    -- upvalues: v2 (copy), v3 (copy), v4 (copy), v6 (copy)
    local CONSTANTS = v4.CONSTANTS
    local v15 = v3.get_alpha(p28.state_started_at, p30, CONSTANTS.candycorn_collect_duration)
    local collect_boost = p28.collect_boost

    p29 = p29 or p28.collect_from_cframe.Position

    if v15 >= 1 then
        if p28.trail then
            v6:add_part(p28.trail, CFrame.new(p29))
        end

        if p28.slot ~= 0 then
            v2.remove(v3.get_pivoter(p27), p28.slot)
            p28.slot = 0
        end

        local trail = p28.trail

        if trail then
            p28.trail = nil
            v3.release_trail(trail)
        end

        p28.visual.Parent = nil
        p28.state = "collected"
        p28.state_started_at = p30
        v3.play_vfx(p27, CONSTANTS.vfx_candycorn_collect, p29, collect_boost * CONSTANTS.candycorn_landing_sparkle)
    else
        local collect_from_cframe = p28.collect_from_cframe
        local candycorn_collect_pop = CONSTANTS.candycorn_collect_pop

        if v15 < candycorn_collect_pop then
            local v18 = math.sin(v15 / candycorn_collect_pop * 3.141592653589793) * (CONSTANTS.candycorn_collect_pop_scale - 1) * collect_boost
            local v19 = p28.collect_from_size * (1 + v18)

            p28.mesh.Scale = p28.full_scale * v19
            p28.mesh.Offset = p28.full_offset * v19 + p28.rise * (v19 - 1)
            v6:add_part(p28.handle, collect_from_cframe * p28.handle_offset)
        else
            local v20 = (v15 - candycorn_collect_pop) / (1 - candycorn_collect_pop)
            local v23 = Vector3.new(0, 1, 0) * CONSTANTS.candycorn_collect_arc * math.sin(v20 * 3.141592653589793)
            local v24 = collect_from_cframe.Position:Lerp(p29, v3.ease_in_out(v20)) + v23
            local v25 = CFrame.fromOrientation(0, v20 * CONSTANTS.candycorn_collect_spin, 0)
            local v26 = 1 - v20 ^ 2

            if p28.trail then
                v6:add_part(p28.trail, CFrame.new(v24))
            end

            local v27 = p28.collect_from_size * v26
            local v28 = CFrame.new(v24) * collect_from_cframe.Rotation * v25

            p28.mesh.Scale = p28.full_scale * v27
            p28.mesh.Offset = p28.full_offset * v27 + p28.rise * (v27 - 1)
            v6:add_part(p28.handle, v28 * p28.handle_offset)
        end
    end
end

local function step(p31, p32, p33, p34) -- line: 220
    -- upvalues: respawn (copy), step_collecting (copy)
    local confirm_at = p32.confirm_at

    if confirm_at and confirm_at <= p34 then
        respawn(p31, p32, p34)
    end

    if p32.state == "collecting" then
        step_collecting(p31, p32, p33, p34)
    end

    if p32.state ~= "collecting" and not p32.confirm_at then
        p31.candycorn.active[p32] = nil
    end
end

local function connect_spawner(p35, p36, p37) -- line: 235
    -- upvalues: v2 (copy), v3 (copy), v4 (copy), v5 (copy), respawn (copy)
    local CONSTANTS = v4.CONSTANTS
    local elapsed = os.clock()

    p36.Transparency = 1

    local v29 = v3.build_visual(p37)
    local v30 = v29.PrimaryPart or error((("%* has no PrimaryPart to move"):format((p37:GetFullName()))))
    local v31 = v30:FindFirstChildWhichIsA("SpecialMesh") or error((("%* has no SpecialMesh to scale"):format((v30:GetFullName()))))
    local Pivot = v29:GetPivot()
    local v32 = Pivot:ToObjectSpace(v30.CFrame)
    local t2 = {
        slot = 0,
        state = "collected",
        confirm_at = nil,
        collect_from_size = 1,
        collect_boost = 1,
        trail = nil,
        spawner = p36,
        visual = v29,
        handle = v30,
        mesh = v31,
        full_scale = v31.Scale,
        full_offset = v31.Offset,
        rise = -v30.CFrame:PointToObjectSpace(Pivot.Position),
        handle_offset = v32,
        rest = p36.CFrame * v32,
        anchor = p36:GetAttribute(CONSTANTS.cannon_drop_aim_attribute) or p36.Position,
        state_started_at = elapsed,
        collect_from_cframe = Pivot
    }

    p35.maid:GiveTask(v29)

    if p36:GetAttribute(v5) == true then
        if t2.slot ~= 0 then
            v2.remove(v3.get_pivoter(p35), t2.slot)
            t2.slot = 0
        end

        local trail = t2.trail

        if trail then
            t2.trail = nil
            v3.release_trail(trail)
        end

        t2.visual.Parent = nil
        t2.state = "collected"
        t2.state_started_at = elapsed
    else
        respawn(p35, t2, elapsed)
    end

    p35.candycorn.by_spawner[p36] = t2
    p35.maid:GiveTask(p36.AncestryChanged:Connect(function() -- line: 279
        -- upvalues: p35 (copy), p36 (copy), v29 (copy), t2 (copy), v2 (copy), v3 (copy)
        if p36:IsDescendantOf(workspace) then
            return
        end

        if t2.slot ~= 0 then
            v2.remove(v3.get_pivoter(p35), t2.slot)
            t2.slot = 0
        end

        local trail = t2.trail

        if trail then
            t2.trail = nil
            v3.release_trail(trail)
        end

        v29:Destroy()
        p35.candycorn.by_spawner[p36] = nil
        p35.candycorn.active[t2] = nil
    end))
    p35.maid:GiveTask(p36:GetAttributeChangedSignal(v5):Connect(function() -- line: 289
        -- upvalues: p35 (copy), p36 (copy), t2 (copy), v2 (copy), v3 (copy), v5 (copy), respawn (copy)
        local elapsed = os.clock()

        if p36:GetAttribute(v5) == true then
            t2.confirm_at = nil

            if t2.state == "idle" then
                if t2.slot ~= 0 then
                    v2.remove(v3.get_pivoter(p35), t2.slot)
                    t2.slot = 0
                end

                local trail = t2.trail

                if trail then
                    t2.trail = nil
                    v3.release_trail(trail)
                end

                t2.visual.Parent = nil
                t2.state = "collected"
                t2.state_started_at = elapsed
            end
        elseif t2.state ~= "idle" then
            respawn(p35, t2, elapsed)
        end
    end))
end

local function poll_collection(p38, p39) -- line: 304
    -- upvalues: v3 (copy), v4 (copy), collect (copy)
    local CONSTANTS = v4.CONSTANTS
    local v33 = v3.get_local_root()
    local Attribute = v3.LOCAL_PLAYER:GetAttribute(CONSTANTS.candycorn_radius_attribute)

    if v33 and Attribute then
        local elapsed = os.clock()

        for _, v34 in workspace:GetPartBoundsInRadius(v33.Position, Attribute, p39) do
            local v35 = p38.candycorn.by_spawner[v34]

            if v35 and v35.state == "idle" then
                collect(p38, v35, elapsed)
            end
        end
    end
end

function t1.connect_candycorn_spawners(p40, p41, p42, p43) -- line: 324
    -- upvalues: RunService (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v6 (copy), set_size (copy), step (copy), connect_spawner (copy), poll_collection (copy)
    local CONSTANTS = v4.CONSTANTS
    local v36 = p42.PrimaryPart or error((("%* has no PrimaryPart to move"):format((p42:GetFullName()))))
    local v37 = v2.new(p43, p41:GetChildren(), v36.Size.Magnitude / 2, set_size)

    p40.candycorn.pivoter = v37
    p40.maid:GiveTask(v1.connect_spawners(p41, function(p44) -- line: 336
        -- upvalues: p40 (copy), p42 (copy), connect_spawner (copy)
        connect_spawner(p40, p44, p42)
    end))

    local v38 = OverlapParams.new()

    v38.FilterType = Enum.RaycastFilterType.Include
    v38.FilterDescendantsInstances = { p41 }

    local n1 = 0

    p40.maid:GiveTask(RunService.Heartbeat:Connect(function() -- line: 345
        -- upvalues: p40 (copy), CONSTANTS (copy), v38 (copy), n1 (ref), poll_collection (copy)
        n1 += 1

        if n1 >= CONSTANTS.candycorn_poll_ticks then
            n1 = 0
            poll_collection(p40, v38)
        end
    end))
    p40.maid:GiveTask(RunService.PreRender:Connect(function() -- line: 353
        -- upvalues: p40 (copy), v37 (copy), v2 (copy), v3 (copy), v6 (copy), step (copy)
        local elapsed = os.clock()

        v2.step(v37, elapsed)

        local active = p40.candycorn.active

        if next(active) == nil then
            return
        end

        local v40 = v3.get_local_root()
        local Position = if v40 then v40.Position else nil

        for v41 in active do
            step(p40, v41, Position, elapsed)
        end

        v6:execute(Enum.BulkMoveMode.FireCFrameChanged)
    end))
    p40.maid:GiveTask(function() -- line: 372
        -- upvalues: v6 (copy)
        v6:destroy()
    end)
end

return table.freeze(t1)
