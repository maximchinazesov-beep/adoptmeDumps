-- https://lua.expert

local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightNet")
local v3 = require("./SpotlightShared")
local t1 = {}

local function enqueue(p1, p2) -- line: 27
    -- upvalues: v3 (copy)
    table.insert(p1, p2)

    while #p1 > v3.CONSTANTS.spotlight_stream_max_queue do
        table.remove(p1, 1)
    end
end

local function get_buffered(p3) -- line: 35
    local to = p3.to
    local v4 = if to then to.span - p3.elapsed else 0

    for _, v5 in p3.queue do
        v4 += v5.span
    end

    return v4
end

local function advance(p4) -- line: 46
    local queue = p4.queue

    while #queue > 0 do
        local to = p4.to

        if to then
            if p4.elapsed < to.span then
                break
            else
                p4.elapsed -= to.span
            end
        end

        p4.from = to
        p4.to = table.remove(queue, 1)
    end

    local to = p4.to

    if to and #queue == 0 then
        p4.elapsed = math.min(p4.elapsed, to.span)
    end
end

local function get_streamed(p5, p6) -- line: 69
    -- upvalues: v3 (copy), advance (copy)
    local CONSTANTS = v3.CONSTANTS
    local v6 = CONSTANTS.spotlight_stream_depth * CONSTANTS.spotlight_update_interval
    local to = p5.to
    local v7 = if to then to.span - p5.elapsed else 0

    for _, v8 in p5.queue do
        v7 += v8.span
    end

    local v9 = (v7 - v6) / v6 * CONSTANTS.spotlight_stream_catchup
    local spotlight_stream_max_drift = CONSTANTS.spotlight_stream_max_drift

    p5.elapsed = p5.elapsed + p6 * (math.clamp(v9, -spotlight_stream_max_drift, spotlight_stream_max_drift) + 1)
    advance(p5)

    local to2 = p5.to

    if not to2 then
        return nil, 0
    end

    local from = p5.from

    if not from then
        return to2.at, to2.hunt
    end

    local v12 = math.min(p5.elapsed / to2.span, 1)

    return from.at:Lerp(to2.at, v12), from.hunt + (to2.hunt - from.hunt) * v12
end

local function has_reached(p7, p8) -- line: 95
    local entered_at = p7.entered_at

    if entered_at == nil then
        return false
    end

    return os.clock() >= entered_at + p8
end

local function update_beam(p9, p10, p11, p12, p13) -- line: 101
    -- upvalues: v1 (copy), v3 (copy)
    local CONSTANTS = v3.CONSTANTS
    local lamp = p11.lamp
    local v13 = p12 * v1.get_hunt_pulse(os.clock())

    p9.beam_colors[p10] = lamp.color:Lerp(CONSTANTS.spotlight_hunt_color, v13)
    v1.set_lamp(lamp, v13, p13, p12)
end

function t1.connect_stream(p14) -- line: 117
    -- upvalues: v2 (copy)
    p14.maid:GiveTask(v2.beam:on_client_event(function(p15) -- line: 118
        -- upvalues: p14 (copy)
        (p14.on_beam[p15.index] or error((("Spotlight streamed copycat %*, which this client never built"):format(p15.index))))(p15)
    end))
end

function t1.connect_spotlight(p16, p17, p18, p19) -- line: 125
    -- upvalues: RunService (copy), SoundService (copy), v1 (copy), v3 (copy), enqueue (copy), get_streamed (copy), update_beam (copy)
    local CONSTANTS = v3.CONSTANTS
    local v14 = v1.get_rig(p16, p17)
    local t2 = {
        on = false,
        level = 0
    }
    local t3 = {
        from = nil,
        to = nil,
        elapsed = 0,
        sequence = 0,
        lamp = v1.get_lamp(p16, p17, true),
        queue = {}
    }

    p16.on_beam[p18] = function(p20) -- line: 147
        -- upvalues: p16 (copy), CONSTANTS (copy), t2 (copy), t3 (copy), SoundService (copy), v1 (copy), v3 (copy), enqueue (copy)
        if p20.sequence <= t3.sequence then
            return
        end

        if p20.lit then
            local v15 = v3.get_ringmaster_trick_start()
            local entered_at = p16.entered_at

            if entered_at ~= nil and os.clock() >= entered_at + v15 and not t2.on then
                t2.on = true
                v1.play_layered_sound(CONSTANTS.sound_copycat_new, SoundService)
            end
        end

        local v16 = if t3.sequence > 0 then p20.sequence - t3.sequence - 1 else 0

        t3.sequence = p20.sequence

        local v17 = if p20.span > 0 then p20.span else CONSTANTS.spotlight_update_interval

        enqueue(t3.queue, {
            at = p20.target,
            hunt = p20.hunt,
            span = v17 + v16 * CONSTANTS.spotlight_update_interval
        })
    end

    p16.maid:GiveTask(RunService.PreAnimation:Connect(function(p21) -- line: 169
        -- upvalues: p16 (copy), p18 (copy), p19 (copy), CONSTANTS (copy), v14 (copy), t2 (copy), t3 (copy), v1 (copy), get_streamed (copy), update_beam (copy)
        v1.charge(t2, p21)

        local v18, v19 = get_streamed(t3, p21)
        local cutscene_copycat_wake = CONSTANTS.cutscene_copycat_wake
        local entered_at = p16.entered_at

        if entered_at == nil or not (os.clock() >= entered_at + cutscene_copycat_wake) then
            v18 = p19
            v19 = 0
        end

        local v20 = v1.get_fizzle(t2)

        v1.turn_rig(v14, v18, CONSTANTS.spotlight_turn_speed, p21, v20)
        update_beam(p16, p18, t3, v19, v20)
    end))
end

return table.freeze(t1)
