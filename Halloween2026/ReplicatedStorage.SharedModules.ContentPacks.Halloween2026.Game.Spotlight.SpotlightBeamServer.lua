-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightCandycornServer")
local v2 = require("./SpotlightCopycats")
local v3 = require("./SpotlightNet")
local v4 = require("./SpotlightRigs")
local v5 = require("./SpotlightServerState")
local v6 = require("./SpotlightShared")
local v7 = require("./SpotlightTargetsServer")
local t1 = {}

local function get_stream_lag() -- line: 13
    -- upvalues: v6 (copy)
    local CONSTANTS = v6.CONSTANTS

    return CONSTANTS.spotlight_stream_depth * CONSTANTS.spotlight_update_interval + 1 / CONSTANTS.spotlight_turn_speed
end

local function chase_target(p1, p2, p3, p4) -- line: 19
    -- upvalues: v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local PrimaryPart = p2.PrimaryPart
    local v8 = if PrimaryPart then PrimaryPart.AssemblyLinearVelocity * Vector3.new(1, 0, 1) else Vector3.new(0, 0, 0)
    local Position = p2:GetPivot().Position
    local CONSTANTS2 = v6.CONSTANTS
    local v9 = Position + v8 * (CONSTANTS2.spotlight_stream_depth * CONSTANTS2.spotlight_update_interval + 1 / CONSTANTS2.spotlight_turn_speed)
    local v10 = CONSTANTS.spotlight_opening_chase_speed + (CONSTANTS.spotlight_closing_chase_speed - CONSTANTS.spotlight_opening_chase_speed) * p3

    p1.target = p1.target + (v9 - p1.target) * math.min(v10 * p4, 1)

    local v13 = p1.target - p1.centre

    p1.angle = math.atan2(-v13.Z, v13.X)
end

local function get_wiggle(p5) -- line: 39
    -- upvalues: v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local v15 = p5 % CONSTANTS.spotlight_wiggle_interval

    if CONSTANTS.spotlight_wiggle_duration < v15 then
        return 0
    end

    local v17 = math.sin(v15 / CONSTANTS.spotlight_wiggle_duration * 3.141592653589793)

    return math.sin(v15 * CONSTANTS.spotlight_wiggle_frequency * 2 * 3.141592653589793) * v17 * CONSTANTS.spotlight_wiggle_amplitude
end

local function get_speed_ramp(p6, p7) -- line: 53
    return (math.clamp(1 - p7 / p6.activates_at, 0, 1))
end

local function sweep_ring(p8, p9, p10, p11, p12, p13) -- line: 57
    -- upvalues: v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local v20 = CONSTANTS.spotlight_opening_speed_scale + (CONSTANTS.spotlight_closing_speed_scale - CONSTANTS.spotlight_opening_speed_scale) * p10
    local v21 = 6.283185307179586 / v6.get_spotlight_lap_duration()

    p8.angle += p8.sign * p13 * v21 * v20

    local angle = p8.angle
    local CONSTANTS2 = v6.CONSTANTS
    local v22 = p12 % CONSTANTS2.spotlight_wiggle_interval
    local v23

    if CONSTANTS2.spotlight_wiggle_duration < v22 then
        v23 = 0
    else
        local v25 = math.sin(v22 / CONSTANTS2.spotlight_wiggle_duration * 3.141592653589793)

        v23 = math.sin(v22 * CONSTANTS2.spotlight_wiggle_frequency * 2 * 3.141592653589793) * v25 * CONSTANTS2.spotlight_wiggle_amplitude
    end

    local v27 = angle + v23
    local v32 = p8.centre + Vector3.new(CONSTANTS.spotlight_radius * math.cos(v27), CONSTANTS.spotlight_sweep_height + CONSTANTS.spotlight_sweep_rise * math.sin(v27 * v6.get_spotlight_sweep_bob()), CONSTANTS.spotlight_radius * -math.sin(v27))

    if p11 then
        local v33 = CONSTANTS.spotlight_opening_seek + (CONSTANTS.spotlight_closing_seek - CONSTANTS.spotlight_opening_seek) * p9
        local v34 = p11 - p8.centre

        v32 = v32:Lerp(p11, v33 * math.max(math.cos((math.atan2(-v34.Z, v34.X) - v27 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793), 0))
    end

    p8.target += CONSTANTS.spotlight_sweep_catchup * p13 * (v32 - p8.target)
end

local function keep_tilt(p14) -- line: 94
    -- upvalues: v4 (copy)
    local min_tilt = p14.min_tilt

    if min_tilt <= 0 then
        return
    end

    local frames = p14.frames
    local Position = v4.get_beam(frames, v4.aim(frames, p14.target, p14.yaw)).Position
    local v38 = p14.target - Position
    local Magnitude = v38.Magnitude

    if Magnitude <= 0 or -v38.Y / Magnitude <= math.cos(min_tilt) then
        return
    end

    local v39 = v38 * Vector3.new(1, 0, 1)

    if v39.Magnitude <= 0 then
        v39 = Vector3.new(math.cos(p14.angle), 0, -math.sin(p14.angle))
    end

    p14.target = Position + (v39.Unit * math.sin(min_tilt) - Vector3.new(0, 1, 0) * math.cos(min_tilt)) * Magnitude
end

local function face(p15) -- line: 118
    -- upvalues: v4 (copy)
    local frames = p15.frames
    local v42, v43 = v4.aim(frames, p15.shown, p15.yaw)

    p15.yaw = v42
    p15.origin = v4.get_beam(frames, v42, v43).Position
end

local function hunt(p16, p17, p18, p19, p20, p21) -- line: 126
    -- upvalues: v6 (copy), chase_target (copy), sweep_ring (copy)
    local CONSTANTS = v6.CONSTANTS
    local v44 = next(p16.spotted) == nil and 0 or 1

    p16.hunt = v6.approach(p16.hunt, v44, p21 / CONSTANTS.spotlight_hunt_fade_duration)

    local chasing = p16.chasing

    if chasing then
        chase_target(p16, chasing, p17, p21)
    else
        sweep_ring(p16, p17, p18, p19, p20, p21)
    end
end

local function step_shown(p22, p23) -- line: 148
    -- upvalues: v6 (copy)
    local shown_history = p22.shown_history

    table.insert(shown_history, {
        at = p22.target,
        when = p23
    })

    local CONSTANTS = v6.CONSTANTS
    local v45 = p23 - (CONSTANTS.spotlight_stream_depth * CONSTANTS.spotlight_update_interval + 1 / CONSTANTS.spotlight_turn_speed)

    while #shown_history > 2 and shown_history[2].when <= v45 do
        table.remove(shown_history, 1)
    end

    local v46 = shown_history[1]
    local v47 = shown_history[2]

    if not v47 then
        p22.shown = v46.at

        return
    end

    local v48 = v47.when - v46.when
    local v49 = if v48 > 0 then math.clamp((v45 - v46.when) / v48, 0, 1) else 1

    p22.shown = v46.at:Lerp(v47.at, v49)
end

local function step_awake(p24, p25, p26, p27) -- line: 168
    -- upvalues: v1 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), keep_tilt (copy), hunt (copy), step_shown (copy)
    local t3 = {}

    for _, v51 in p24.spotlights do
        if not v51.awake and v51.wakes_at <= p26 then
            v51.awake = true
        end

        if v51.awake then
            table.insert(t3, v51)
        end
    end

    if #t3 == 0 then
        return
    end

    for _, v52 in t3 do
        step_shown(v52, p26)

        local frames = v52.frames
        local v53, v54 = v4.aim(frames, v52.shown, v52.yaw)

        v52.yaw = v53
        v52.origin = v4.get_beam(frames, v53, v54).Position
    end

    local v55 = v5.get_characters(p24)
    local v57 = math.clamp(1 - p25 / v6.get_play_length(), 0, 1)
    local v58 = v7.get_carriers(p24, v55, p26)
    local v59 = v7.update(p24, t3, v55, v58, v57, p26, p27)

    v1.hit(v59, p26)

    for _, v60 in t3 do
        local v61 = if v60.chasing then nil else v7.get_seek(p24, t3, v60, v58, p26)

        hunt(v60, v57, math.clamp(1 - p25 / v60.activates_at, 0, 1), v61, p26, p27)
        keep_tilt(v60)
    end
end

local function stream(p28, p29, p30) -- line: 207
    -- upvalues: v3 (copy), v6 (copy)
    local v63 = p30 - p29.sent_at

    if v63 < v6.CONSTANTS.spotlight_update_interval then
        return
    end

    p29.sent_at = p30
    p29.sequence += 1
    v3.beam:fire_clients(p28.listeners, {
        index = p29.index,
        lit = p29.lights_at <= p30,
        target = p29.target,
        hunt = p29.hunt,
        sequence = p29.sequence,
        span = v63
    })
end

local function measure_cone_angle(p31) -- line: 230
    -- upvalues: v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local v64 = p31:FindFirstChild(CONSTANTS.rig_cone_name, true) or error((("%* has no %* to measure its beam by"):format(p31:GetFullName(), CONSTANTS.rig_cone_name)))

    return (math.atan(v64.Size.X / 2 / v64.Size.Y))
end

local function build_spotlight(p32, p33, p34, p35) -- line: 239
    -- upvalues: v2 (copy), v6 (copy), measure_cone_angle (copy)
    local CONSTANTS = v6.CONSTANTS
    local v66 = p34[p35]
    local v67 = v2.get_rest(p34, p35)
    local v68 = CONSTANTS.scene_direction_signs[p32.direction] or error((("unhandled scene direction %*"):format(p32.direction)))
    local v69 = v66.activates_at >= v6.get_play_length()
    local v70 = if v69 then p32.started_at + CONSTANTS.cutscene_copycat_wake else p32.ends_at - v66.activates_at

    return {
        awake = false,
        chasing = nil,
        unseen_since = nil,
        hunt = 0,
        sequence = 0,
        index = p35,
        activates_at = v66.activates_at,
        wakes_at = v70,
        lights_at = if v69 then p32.started_at + v6.get_ringmaster_trick_start() else v70,
        spotted = {},
        target = v67.target,
        shown = v67.target,
        shown_history = {},
        centre = p33,
        sent_at = p32.started_at,
        frames = v67.frames,
        yaw = v67.yaw,
        origin = v67.beam.Position,
        min_tilt = v67.min_tilt,
        cone_angle = measure_cone_angle(v66.template),
        angle = v67.angle,
        sign = if (p35 - v2.get_opening(p34)) % 2 == 0 then v68 else -v68
    }
end

function t1.connect_spotlights(p36, p37, p38) -- line: 287
    -- upvalues: RunService (copy), v2 (copy), step_awake (copy), stream (copy), build_spotlight (copy)
    local v71 = v2.get_stack(p38)

    for i = 1, #v71 do
        table.insert(p36.spotlights, (build_spotlight(p36, p37, v71, i)))
    end

    p36.maid:GiveTask(RunService.Heartbeat:Connect(function(p39) -- line: 293
        -- upvalues: p36 (copy), step_awake (copy), stream (copy)
        local elapsed = os.clock()

        if not (elapsed < p36.started_at) then
            step_awake(p36, p36.ends_at - elapsed, elapsed, p39)

            for _, v73 in p36.spotlights do
                stream(p36, v73, elapsed)
            end
        end
    end))
end

return table.freeze(t1)
