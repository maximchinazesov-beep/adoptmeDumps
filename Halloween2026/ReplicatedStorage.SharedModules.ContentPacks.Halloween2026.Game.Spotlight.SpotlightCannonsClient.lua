-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightCandycornPivoter")
local v2 = require("./SpotlightCannons")
local v3 = require("./SpotlightClientState")
local v4 = require("./SpotlightNet")
local v5 = require("./SpotlightRigs")
local v6 = require("./SpotlightShared")
local t1 = {}

local function get_launch_velocity(p1, p2, p3) -- line: 31
    return (p2 - p1 - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * p3 * p3) / p3
end

local function aim_along(p4, p5) -- line: 35
    -- upvalues: v6 (copy)
    p4.target = p4.origin + p5.Unit * v6.CONSTANTS.cannon_aim_reach
end

local function spawn_shot(p6, p7, p8, p9, p10, p11) -- line: 39
    -- upvalues: v1 (copy), v3 (copy), v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local elapsed = os.clock()
    local v9 = v3.build_visual(p7)

    v9:ScaleTo(v9:GetScale() * p11)
    v9:PivotTo(CFrame.new(p8))
    v9.Parent = p6.visuals

    local v10 = v9.PrimaryPart or error((("%* has no PrimaryPart to fly"):format((p7:GetFullName()))))
    local v11 = v3.attach_trail(p6, CONSTANTS.vfx_candycorn_trail, p8)

    v1.launch(v3.get_pivoter(p6), v10, v11, p9, elapsed, p10)

    local t2 = {
        visual = v9,
        handle = v10,
        trail = v11,
        from = p8,
        velocity = p9,
        flight = p10,
        lands_at = elapsed + p10
    }

    table.insert(p6.cannons.shots, t2)
end

local function aim_volley(p12) -- line: 71
    -- upvalues: v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local Attribute = p12.model:GetAttribute(CONSTANTS.cannon_fire_target_attribute)

    if Attribute then
        local v12 = Attribute + Vector3.new(0, 1, 0) * CONSTANTS.cannon_landing_lift
        local muzzlePosition = p12.muzzle.Position
        local cannon_volley_flight_duration = CONSTANTS.cannon_volley_flight_duration
        local v15 = (v12 - muzzlePosition - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * cannon_volley_flight_duration * cannon_volley_flight_duration) / cannon_volley_flight_duration

        p12.target = p12.origin + v15.Unit * v6.CONSTANTS.cannon_aim_reach
    end

    return Attribute
end

local function fire_cannon(p13, p14, p15) -- line: 83
    -- upvalues: v2 (copy), v3 (copy), v6 (copy), spawn_shot (copy)
    local CONSTANTS = v6.CONSTANTS
    local Attribute = p15.model:GetAttribute(CONSTANTS.cannon_fired_attribute)
    local CONSTANTS2 = v6.CONSTANTS
    local Attribute2 = p15.model:GetAttribute(CONSTANTS2.cannon_fire_target_attribute)

    if not Attribute2 then
        return
    end

    local v16 = Attribute2 + Vector3.new(0, 1, 0) * CONSTANTS2.cannon_landing_lift
    local muzzlePosition = p15.muzzle.Position
    local cannon_volley_flight_duration = CONSTANTS2.cannon_volley_flight_duration
    local v19 = (v16 - muzzlePosition - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * cannon_volley_flight_duration * cannon_volley_flight_duration) / cannon_volley_flight_duration

    p15.target = p15.origin + v19.Unit * v6.CONSTANTS.cannon_aim_reach

    if not Attribute then
        return
    end

    local cannon_volley_flight_duration2 = CONSTANTS.cannon_volley_flight_duration

    p15.rig.aim = p15.target
    v3.play_layered_sound(CONSTANTS.sound_cannon_shoot, p15.muzzle)

    for v20, v21 in v2.get_landings(Attribute2, v2.get_seed(Attribute, p15.index)) do
        p13.maid:GiveTask(task.delay((v20 - 1) * CONSTANTS.cannon_volley_shot_interval, function() -- line: 98
            -- upvalues: p13 (copy), p14 (copy), p15 (copy), CONSTANTS (copy), cannon_volley_flight_duration2 (copy), v20 (copy), v21 (copy), v3 (copy), spawn_shot (copy)
            local muzzlePosition = p15.muzzle.Position

            if v20 == 1 then
                v3.play_vfx(p13, CONSTANTS.vfx_cannon_muzzle, p15.muzzle.CFrame)
            end

            spawn_shot(p13, p14, muzzlePosition, (v21 - muzzlePosition - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * cannon_volley_flight_duration2 * cannon_volley_flight_duration2) / cannon_volley_flight_duration2, cannon_volley_flight_duration2, 1)
        end))
    end
end

local function fire_stream_shot(p16, p17, p18, p19, p20) -- line: 110
    -- upvalues: v3 (copy), v6 (copy), spawn_shot (copy)
    local CONSTANTS = v6.CONSTANTS
    local muzzlePosition = p18.muzzle.Position
    local v26 = math.max(p20 - workspace:GetServerTimeNow(), CONSTANTS.cannon_stream_flight_duration / 4)
    local v29 = (p19[1] - muzzlePosition - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * v26 * v26) / v26

    p18.target = p18.origin + v29.Unit * v6.CONSTANTS.cannon_aim_reach
    p18.rig.aim = p18.target
    v3.play_layered_sound(CONSTANTS.sound_cannon_shoot, p18.muzzle)
    v3.play_vfx(p16, CONSTANTS.vfx_cannon_muzzle, p18.muzzle.CFrame, CONSTANTS.cannon_stream_muzzle_amount)

    for _, v30 in p19 do
        spawn_shot(p16, p17, muzzlePosition, (v30 - muzzlePosition - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * v26 * v26) / v26, v26, CONSTANTS.cannon_stream_shot_scale)
    end
end

local function land_shots(p21, p22) -- line: 143
    -- upvalues: v1 (copy), v3 (copy), v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local shots = p21.cannons.shots

    for i = #shots, 1, -1 do
        local v33 = shots[i]

        if not (p22 < v33.lands_at) then
            local flight = v33.flight
            local v34 = v33.from + v33.velocity * flight + Vector3.new(0, 1, 0) * (-0.5 * workspace.Gravity * flight * flight)

            v1.land(v3.get_pivoter(p21), v33.handle)

            local trail = v33.trail

            if trail then
                trail.CFrame = CFrame.new(v34)
                v3.release_trail(trail)
            end

            v3.play_vfx(p21, CONSTANTS.vfx_candycorn_land, v34)
            v33.visual:Destroy()
            table.remove(shots, i)
        end
    end
end

function t1.connect_all_cannons(p23, p24, p25) -- line: 170
    -- upvalues: RunService (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), fire_cannon (copy), fire_stream_shot (copy), land_shots (copy)
    local CONSTANTS = v6.CONSTANTS

    for i = 1, CONSTANTS.cannon_count do
        local v35 = p24:WaitForChild((("%*%*"):format(CONSTANTS.cannon_name_prefix, i)))
        local v36 = v3.get_rig(p23, v35)
        local t3 = {
            target = nil,
            model = v35,
            index = i,
            rig = v36,
            origin = v5.get_beam(v36.joints.frames, 0, 0).Position,
            muzzle = v3.wait_for_head(v35)
        }

        p23.cannons.cannons[i] = t3
        p23.maid:GiveTask(v35:GetAttributeChangedSignal(CONSTANTS.cannon_fire_target_attribute):Connect(function() -- line: 188
            -- upvalues: CONSTANTS (copy), v36 (copy), t3 (copy), v3 (copy), v6 (copy)
            local CONSTANTS2 = v6.CONSTANTS
            local Attribute = t3.model:GetAttribute(CONSTANTS2.cannon_fire_target_attribute)

            if not Attribute then
                return
            end

            local v37 = Attribute + Vector3.new(0, 1, 0) * CONSTANTS2.cannon_landing_lift
            local muzzlePosition = t3.muzzle.Position
            local cannon_volley_flight_duration = CONSTANTS2.cannon_volley_flight_duration
            local v40 = (v37 - muzzlePosition - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * cannon_volley_flight_duration * cannon_volley_flight_duration) / cannon_volley_flight_duration

            t3.target = t3.origin + v40.Unit * v6.CONSTANTS.cannon_aim_reach
            v3.play_layered_sound(CONSTANTS.sound_cannon_turn, v36.base)
        end))
        p23.maid:GiveTask(v35:GetAttributeChangedSignal(CONSTANTS.cannon_fired_attribute):Connect(function() -- line: 193
            -- upvalues: p23 (copy), p25 (copy), t3 (copy), fire_cannon (copy)
            fire_cannon(p23, p25, t3)
        end))
    end

    p23.maid:GiveTask(v4.cannon_stream:on_client_event(function(p26) -- line: 198
        -- upvalues: p23 (copy), p25 (copy), CONSTANTS (copy), v3 (copy), v6 (copy), fire_stream_shot (copy)
        local v41 = p23.cannons.cannons[p26.cannon] or error((("Spotlight streamed cannon %*, which this client never built"):format(p26.cannon)))
        local v42 = p26.lands_at - p26.fires_at
        local muzzlePosition = v41.muzzle.Position
        local v45 = (p26.landings[1] - muzzlePosition - Vector3.new(0, -workspace.Gravity, 0) * 0.5 * v42 * v42) / v42

        v41.target = v41.origin + v45.Unit * v6.CONSTANTS.cannon_aim_reach
        v3.play_layered_sound(CONSTANTS.sound_cannon_turn, v41.rig.base)
        p23.maid:GiveTask(task.delay(math.max(p26.fires_at - workspace:GetServerTimeNow(), 0), fire_stream_shot, p23, p25, v41, p26.landings, p26.lands_at))
    end))
    p23.maid:GiveTask(RunService.PreRender:Connect(function(p27) -- line: 219
        -- upvalues: p23 (copy), CONSTANTS (copy), v3 (copy), land_shots (copy)
        land_shots(p23, os.clock())

        local v47 = v3.get_fizzle(p23.power.rack)

        for _, v48 in p23.cannons.cannons do
            v3.turn_rig(v48.rig, v48.target, CONSTANTS.cannon_turn_speed, p27, v47)
        end
    end))
end

return table.freeze(t1)
