-- https://lua.expert

local v1 = require("./SpotlightBeamServer")
local v2 = require("./SpotlightCandycornServer")
local v3 = require("./SpotlightCannonsServer")
local v4 = require("./SpotlightMarkersServer")
local v5 = require("./SpotlightObstaclesServer")
local v6 = require("./SpotlightScene")
local v7 = require("./SpotlightServerState")
local v8 = require("./SpotlightShared")
local v9 = require("./SpotlightTargetsServer")
local t1 = {}

local function assert_timing_invariants() -- line: 15
    -- upvalues: v8 (copy)
    local CONSTANTS = v8.CONSTANTS
    local ringmaster_animation_lengths = CONSTANTS.ringmaster_animation_lengths
    local v10 = CONSTANTS.act_duration / CONSTANTS.act_throw_count - CONSTANTS.act_throw_lead - CONSTANTS.ringmaster_throw_duration - ringmaster_animation_lengths.Summon
    local v11 = v8.get_ringmaster_intro_duration()
    local v12 = CONSTANTS.act_duration - v8.get_marker_uptime()

    assert(v10 >= 0, "each throw's slot has to fit its throw and the next summon")
    assert(v10 + CONSTANTS.act_throw_lead >= ringmaster_animation_lengths.Aim, "the aim can hold past its animation, but not cut it short")
    assert(CONSTANTS.ringmaster_first_aim_scale * v8.get_ringmaster_aim_duration() - ringmaster_animation_lengths.Trick2 / 2 >= ringmaster_animation_lengths.Aim, "the first aim, even a juggling loop shorter, has to fit its animation")
    assert(CONSTANTS.ringmaster_throw_duration == ringmaster_animation_lengths.Throw, "the throw has no hold, so it lasts exactly its animation")
    assert(CONSTANTS.ringmaster_club_release < CONSTANTS.ringmaster_throw_duration, "the club has to leave the hand before the throw ends")
    assert(CONSTANTS.ringmaster_jump_start < ringmaster_animation_lengths.Jump, "the intro has to start inside the jump")
    assert(v8.get_ringmaster_entrance() >= 0, "she has to pop in after the cutscene starts")

    for _, v20 in {
            CONSTANTS.cutscene_land_lead,
            CONSTANTS.cutscene_land_trail,
            CONSTANTS.cutscene_present_lead,
            CONSTANTS.cutscene_present_trail
        } do
        assert(v20 >= 2 and v20 % 1 == 0, "the cutscene's eases are whole powers of 2 or more, to start and stop smoothly")
    end

    assert(CONSTANTS.cutscene_jolt_attack >= 3 and CONSTANTS.cutscene_jolt_recovery >= 3, "the cutscene's jolts rise and recover by powers of 3 or more, to start and stop smoothly")
    assert(v8.get_ringmaster_trick_start() < CONSTANTS.cutscene_return_from, "the copycat lights up as she starts juggling, before the camera heads back to the player")
    assert(v8.get_ringmaster_trick_start() < CONSTANTS.cutscene_copycat_wake and CONSTANTS.cutscene_copycat_wake <= CONSTANTS.cutscene_duration, "the copycat lights up before it swings out, and swings out within the cutscene")
    assert(CONSTANTS.cutscene_duration <= v11 and v11 <= CONSTANTS.cutscene_duration + CONSTANTS.act_zero_duration, "the intro has to outlast the cutscene and end before act 1")
    assert(v12 >= 3 and v12 <= 5, "a marker has to clear 3 to 5 seconds before its act ends")
    assert(CONSTANTS.marker_fade_duration < v8.get_marker_uptime(), "a marker spends its first marker_fade_duration arriving, and has to be claimable after it")
end

local function on_marker_claimed(p1, p2, p3, p4, p5) -- line: 83
    -- upvalues: v2 (copy), v8 (copy)
    local CONSTANTS = v8.CONSTANTS

    if p3 == "speedup" then
        local v28 = p2:GetAttribute(CONSTANTS.movement_speed_bonus_attribute) or 0

        p2:SetAttribute(CONSTANTS.movement_speed_bonus_attribute, v28 + CONSTANTS.marker_speedup_bonus)
    else
        v2.increase_collection_range(p2)
    end

    if p4 then
        p1.static_map:SetAttribute(CONSTANTS.ringmaster_reacted_attribute, os.clock())
    end

    if p5 then
        p1.crypt_key.claimed[p2] = true
        p2:SetAttribute(CONSTANTS.crypt_key_claimed_attribute, true)
    end
end

local function is_on_pad(p6, p7) -- line: 110
    -- upvalues: v8 (copy)
    local CONSTANTS = v8.CONSTANTS

    for _, v29 in p6.pads do
        local v30 = p7 - v29.Position
        local v31 = math.max(v29.Size.X, v29.Size.Y, v29.Size.Z) / 2 + CONSTANTS.spawn_pad_clearance

        if math.abs(v30.Y) <= CONSTANTS.spawn_pad_height and (v30 * Vector3.new(1, 0, 1)).Magnitude <= v31 then
            return true
        end
    end

    return false
end

function t1.get_spawn_points(p8) -- line: 125
    -- upvalues: v5 (copy), v8 (copy), is_on_pad (copy)
    local CONSTANTS = v8.CONSTANTS
    local v32

    for _, v33 in p8.spotlights do
        if not v32 or v33.activates_at > v32.activates_at then
            v32 = v33
        end
    end

    local origin = (v32 or error((("%* has no spotlight, so there is nothing to take cover from"):format((p8.static_map:GetFullName()))))).origin
    local Children = p8.static_map:WaitForChild(CONSTANTS.candycorn_spawner_folder_name):GetChildren()

    p8.random:Shuffle(Children)

    local t2 = {}
    local t3 = {}

    for _, v34 in Children do
        if v34:IsA("BasePart") and v34.Name ~= CONSTANTS.cannon_drop_name then
            local v35 = v34.Position + Vector3.new(0, 1, 0) * CONSTANTS.spawn_cover_lift

            if not is_on_pad(p8, v35) then
                local v36 = v5.get_cover(p8, origin, v35)

                if v36 and not t3[v36] then
                    t3[v36] = true
                    table.insert(t2, v35)
                end
            end
        end
    end

    return t2
end

function t1.setup(p9, p10) -- line: 166
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v8 (copy), assert_timing_invariants (copy), on_marker_claimed (copy)
    local CONSTANTS = v8.CONSTANTS
    local static_map = p9.static_map

    assert_timing_invariants()

    for _, v37 in {
            CONSTANTS.teleporter_folder_name,
            CONSTANTS.trampoline_folder_name
        } do
        for _, descendant in (p10:FindFirstChild(v37) or error((("%* has no %* folder"):format(p10:GetFullName(), v37)))):GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(p9.pads, descendant)
            end
        end
    end

    local v38 = v6.get_stage_centre(static_map)
    local v39 = static_map:WaitForChild(CONSTANTS.candycorn_spawner_folder_name)

    v2.connect_candycorn_spawners(p9, v39)
    v5.connect_all_obstacles(p9, static_map:WaitForChild(CONSTANTS.obstacle_folder_name), v38)
    v1.connect_spotlights(p9, v38, p10)
    v3.connect_cannons(p9, static_map:WaitForChild(CONSTANTS.cannon_folder_name), v39, static_map:WaitForChild(CONSTANTS.marker_spawner_folder_name))
    v4.connect_markers(p9, static_map:WaitForChild(CONSTANTS.marker_spawner_folder_name), function(...) -- line: 202
        -- upvalues: p9 (copy), on_marker_claimed (copy)
        on_marker_claimed(p9, ...)
    end)
    static_map:SetAttribute(CONSTANTS.ringmaster_state_attribute, "intro")
end

function t1.start(p11, p12) -- line: 210
    -- upvalues: v3 (copy), v4 (copy), v5 (copy), v8 (copy)
    local v41 = task.spawn(function() -- line: 211
        -- upvalues: p11 (copy), p12 (copy), v3 (copy), v4 (copy), v5 (copy), v8 (copy)
        local CONSTANTS = v8.CONSTANTS
        local static_map = p11.static_map
        local ringmaster_animation_lengths = CONSTANTS.ringmaster_animation_lengths
        local v42 = CONSTANTS.act_duration / CONSTANTS.act_throw_count - CONSTANTS.act_throw_lead - CONSTANTS.ringmaster_throw_duration - ringmaster_animation_lengths.Summon

        task.wait(p11.started_at + p11.intro_duration - os.clock())

        local v43 = v5.choose_target(p11)

        static_map:SetAttribute(CONSTANTS.ringmaster_throw_target_attribute, v43 and v43.Position)
        static_map:SetAttribute(CONSTANTS.ringmaster_state_attribute, "aim")
        task.wait(p11.ends_at - CONSTANTS.act_count * CONSTANTS.act_duration - os.clock())

        for i = 1, CONSTANTS.act_count do
            local v44 = v4.show(p11, p11.pattern[i], CONSTANTS.crypt_key_first_act <= i)
            local v45 = v3.fire(p11, v44)

            if i == CONSTANTS.act_count then
                task.delay(v45, v3.stream, p11, CONSTANTS.act_duration - v45)
            end

            for j = 1, CONSTANTS.act_throw_count do
                task.wait(CONSTANTS.act_throw_lead)

                if j == CONSTANTS.act_throw_count then
                    v4.hide(p11)
                end

                static_map:SetAttribute(CONSTANTS.ringmaster_state_attribute, "throw")
                task.wait(CONSTANTS.ringmaster_throw_duration)
                static_map:SetAttribute(CONSTANTS.ringmaster_state_attribute, "summon")
                static_map:SetAttribute(CONSTANTS.ringmaster_throw_target_attribute, nil)
                v5.knock_down(p11, v43)
                task.wait(ringmaster_animation_lengths.Summon)

                if i == CONSTANTS.act_count and j == CONSTANTS.act_throw_count then
                    v43 = nil
                else
                    v43 = v5.choose_target(p11)
                end

                static_map:SetAttribute(CONSTANTS.ringmaster_throw_target_attribute, v43 and v43.Position)
                static_map:SetAttribute(CONSTANTS.ringmaster_state_attribute, "aim")
                task.wait(v42)
            end
        end

        p12()
    end)

    p11.maid:GiveTask(function() -- line: 260
        -- upvalues: v41 (copy)
        if coroutine.status(v41) == "suspended" then
            task.cancel(v41)
        end
    end)
end

function t1.add_player(p13, p14) -- line: 267
    -- upvalues: v2 (copy), v7 (copy), v8 (copy)
    if p13.players[p14] then
        return
    end

    v7.clear_player(p14)
    p13.players[p14] = true
    v2.publish_radius(p14, v8.CONSTANTS.candycorn_collect_radius)
end

function t1.start_intro(p15, p16, p17) -- line: 278
    -- upvalues: v8 (copy)
    local CONSTANTS = v8.CONSTANTS
    local v46 = p15.ends_at - v8.get_play_length() - CONSTANTS.cutscene_duration

    p15.active_at[p16] = math.clamp(p17, p15.started_at, v46) + CONSTANTS.cutscene_duration
end

function t1.remove_player(p18, p19) -- line: 285
    -- upvalues: v2 (copy), v7 (copy), v9 (copy)
    if p18.players[p19] then
        local Character = p19.Character

        p18.players[p19] = nil
        p18.listeners[p19] = nil
        p18.active_at[p19] = nil
        v2.forget_player(p18, p19)

        if Character then
            v9.forget_character(p18, Character)
        end

        v7.clear_player(p19)
    end
end

function t1.stop(p20) -- line: 303
    -- upvalues: v7 (copy)
    p20.maid:Destroy()

    for v47 in p20.players do
        v7.clear_player(v47)
    end
end

return table.freeze(t1)
