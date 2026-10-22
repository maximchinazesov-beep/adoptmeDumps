-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local load = require(ReplicatedStorage.Fsys).load
local Class = load("Class")
local MinigameClient = load("MinigameClient")
local Music = load("Music")
local SoundDB = load("SoundDB")
local v1 = require("../Game/Spotlight/SpotlightBeamClient")
local v2 = require("../Game/Spotlight/SpotlightCandycornClient")
local v3 = require("../Game/Spotlight/SpotlightCannonsClient")
local v4 = require("../Game/Spotlight/SpotlightCeilingClient")
local v5 = require("../Game/Spotlight/SpotlightClientState")
local v6 = require("../Game/Spotlight/SpotlightCopycats")
local v7 = require("../Game/Spotlight/SpotlightCutsceneClient")
local v8 = require("../Game/Spotlight/SpotlightDashClient")
local v9 = require("../Game/Spotlight/SpotlightFlashClient")
local v10 = require("../Game/Spotlight/SpotlightHitClient")
local v11 = require("../Game/Spotlight/SpotlightIlluminatorsClient")
local v12 = require("../Game/Spotlight/SpotlightInterior")
local v13 = require("../Game/Spotlight/SpotlightMarkersClient")
local v14 = require("../Game/Spotlight/SpotlightMovementClient")
local v15 = require("../Game/Spotlight/SpotlightObstaclesClient")
local v16 = require("../Game/Spotlight/SpotlightPrefabs")
local v17 = require("../Game/Spotlight/SpotlightPreloadClient")
local v18 = require("../Game/Spotlight/SpotlightRevealBars")
local v19 = require("../Game/Spotlight/SpotlightRingmasterClient")
local v20 = require("../Game/Spotlight/SpotlightScene")
local v21 = require("../Game/Spotlight/SpotlightScoreBillboards")
local v22 = require("../Game/Spotlight/SpotlightShared")
local v23 = require("../Game/Spotlight/SpotlightSpeedClient")
local v24 = require("../Game/Spotlight/SpotlightStolenCandycornClient")
local v25 = require("../Game/Spotlight/SpotlightTeleportersClient")
local v26 = require("../Game/Spotlight/SpotlightTrampolinesClient")
local v27 = Class("SpotlightMinigameClient", MinigameClient)

local function start_intro(p1) -- line: 39
    -- upvalues: SoundService (copy), Music (copy), SoundDB (copy), v5 (copy), v22 (copy)
    local CONSTANTS = v22.CONSTANTS

    p1.entered_at = os.clock()
    p1.maid:GiveTask(task.delay(CONSTANTS.cutscene_duration, v5.start, p1))
    v5.play_layered_sound(CONSTANTS.sound_intro, SoundService)
    v5.when_started(p1, function() -- line: 46
        -- upvalues: CONSTANTS (copy), Music (copy), SoundDB (copy)
        local v28 = SoundDB[CONSTANTS.minigame_music_id] or error((("SoundDB has no %*"):format(CONSTANTS.minigame_music_id)))

        Music.reset_time_position(v28.id)
        Music.play(100, v28)
        Music.stop(101, SoundDB.Silence)
        Music.stop(CONSTANTS.music_hold_priority, SoundDB.Silence)
    end)
end

function v27.ingame_app_start_state(_) -- line: 55
    return {
        left = {
            title = "TIME LEFT",
            value = "",
            title_x_alignment = Enum.TextXAlignment.Center
        },
        right = {
            title = "Candy Corn",
            value = 0,
            is_value_animated = true
        }
    }
end

function v27.join_zone_interior_render(p3, p4, p5) -- line: 70
    -- upvalues: MinigameClient (copy), v17 (copy)
    MinigameClient.join_zone_interior_render(p3, p4, p5)
    v17.start()
    p3.join_zone_maid:GiveTask(p3.minigame_state:get_property_changed_signal("players_loading"):Connect(function(p6) -- line: 75
        -- upvalues: p3 (copy), v17 (copy)
        if p6 and p3.is_queued and not p3.is_participating then
            v17.start_interior(p3.minigame_destination_id)
        end
    end))
end

function v27.init(p7) -- line: 83
    p7.session = nil
    p7.direction = nil
    p7.intro_duration = nil
end

function v27.enter_minigame(p8, p9) -- line: 89
    -- upvalues: MinigameClient (copy), v5 (copy), v12 (copy)
    local v29 = p9.spotlight_starts[tostring(v5.LOCAL_PLAYER.UserId)]

    p8.direction = p9.spotlight_direction
    p8.intro_duration = p9.spotlight_intro_duration
    p8.interior_enter_options = {
        spawn_cframe = function(p10) -- spawn_cframe | line: 95
            -- upvalues: v29 (copy), v12 (copy)
            local v30 = v12.get_player_spawn(p10)

            if v29 then
                return v30.Rotation + v29
            end

            return v30
        end
    }
    MinigameClient.enter_minigame(p8, p9)
end

function v27._connect_score_hud(p11, p12) -- line: 105
    -- upvalues: v5 (copy), v22 (copy)
    local CONSTANTS = v22.CONSTANTS
    local LOCAL_PLAYER = v5.LOCAL_PLAYER

    local function score_changed() -- line: 109
        -- upvalues: p11 (copy), CONSTANTS (copy), LOCAL_PLAYER (copy)
        if p11.ingame_app_controller then
            p11.ingame_app_controller:set_right_value(LOCAL_PLAYER:GetAttribute(CONSTANTS.candycorn_score_attribute) or 0)
        end
    end

    p12.maid:GiveTask(LOCAL_PLAYER:GetAttributeChangedSignal(CONSTANTS.candycorn_score_attribute):Connect(score_changed))

    if p11.ingame_app_controller then
        p11.ingame_app_controller:set_right_value(LOCAL_PLAYER:GetAttribute(CONSTANTS.candycorn_score_attribute) or 0)
    end
end

function v27._connect_session(p13, p14, p15) -- line: 121
    -- upvalues: v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), v8 (copy), v9 (copy), v10 (copy), v11 (copy), v12 (copy), v13 (copy), v14 (copy), v15 (copy), v16 (copy), v17 (copy), v18 (copy), v19 (copy), v20 (copy), v21 (copy), v22 (copy), v23 (copy), v24 (copy), v25 (copy), v26 (copy)
    local CONSTANTS = v22.CONSTANTS

    v1.connect_stream(p14)
    v17.start()
    p14.setup_phase = "static map"

    local v31 = workspace.StaticMap:WaitForChild(v12.get_static_map_name(p13.minigame_destination_id), CONSTANTS.resource_wait_timeout) or error((("no static map for %*"):format(p13.minigame_destination_id)))

    table.insert(p14.arena, p15)
    table.insert(p14.arena, v31)

    p14.report_collected = function(p16) -- line: 135
        -- upvalues: p13 (copy)
        p13:message_server("candycorn_collect", p16)
    end

    p14.get_players = function() -- line: 138
        -- upvalues: p13 (copy)
        return p13:get_players()
    end

    p14.players_changed = p13.minigame_state:get_property_changed_signal("player_user_ids")
    p13:_connect_score_hud(p14)
    v14.connect_movement(p14)

    local v32 = p13.direction or error("Spotlight entered its round without a scene direction")
    local v33 = p13.intro_duration or error("Spotlight entered its round without an intro duration")
    local v34 = v20.get_stage_centre(v31)
    local v35 = v22.get_resources():FindFirstChild(CONSTANTS.candycorn_model_name) or error((("Resources has no %* to show candy corn with"):format(CONSTANTS.candycorn_model_name)))

    p14.setup_phase = "arena folders"

    local v36 = v31:WaitForChild(CONSTANTS.illuminator_folder_name)
    local v37 = v31:WaitForChild(CONSTANTS.cannon_folder_name)
    local v38 = p15:WaitForChild(CONSTANTS.teleporter_folder_name)
    local v39 = p15:WaitForChild(CONSTANTS.trampoline_folder_name)
    local v40 = v31:WaitForChild(CONSTANTS.marker_spawner_folder_name)

    p14.setup_phase = "copycats"

    local v41 = v6.get_stack(p15)
    local v42 = table.create(#v41)

    for v43, v44 in v41 do
        local clone = v44.template:Clone()

        clone:PivotTo(v44.offset * v44.template:GetPivot())
        clone.Parent = p14.visuals
        v42[v43] = clone
    end

    local v45 = v42[v6.get_opening(v41)]

    p14.setup_phase = "arena"
    v2.connect_candycorn_spawners(p14, v31:WaitForChild(CONSTANTS.candycorn_spawner_folder_name), v35, v34)
    v16.unpack_all(v36)
    v16.unpack_all(v37)
    v16.unpack_all(v38)
    v16.unpack_all(v39)
    v15.connect_all_obstacles(p14, v31:WaitForChild(CONSTANTS.obstacle_folder_name), v34)
    v26.connect_all_trampolines(p14, v39)
    v25.connect_all_teleporters(p14, v38)
    v4.connect_rings(p14, p15, v32)
    v11.connect_all_illuminators(p14, v36, v34)
    v3.connect_all_cannons(p14, v37, v35)

    for v46, v47 in v42 do
        v1.connect_spotlight(p14, v47, v46, v6.get_rest(v41, v46).target)
    end

    v24.connect_theft(p14, v42, v35)
    v10.connect_hits(p14)
    v19.connect_ringmaster(p14, v31, v33)
    v13.connect_all_markers(p14, v40)
    v21.connect_score_billboards(p14)
    v18.connect_reveal_bars(p14)
    v5.connect_shakes(p14)
    v23.connect_speed(p14)
    v8.connect_dash(p14)
    v9.connect_flash(p14)
    v7.connect_cutscene(p14, v32, v34, v45:GetPivot().Position, { p15, v31 })
    p14.is_ready = true
    p13:message_server("session_ready")
end

function v27.post_enter_minigame(p17) -- line: 221
    -- upvalues: v17 (copy), v22 (copy), start_intro (copy)
    local CONSTANTS = v22.CONSTANTS
    local session = p17.session

    if not session then
        return
    end

    local t2 = {}
    local v48
    local n1 = 0
    local v49

    while true do
        if p17.session == session and n1 < CONSTANTS.minigame_entry_cover_timeout then
            local v50

            if not session.is_ready or v48 then
                v50 = v48
            else
                session.setup_phase = "assets"
                v50 = v17.load_round(session.maid, session.arena)
            end

            if not (v50 and v50.done) then
                local setup_phase = session.setup_phase
                local v51 = task.wait()

                n1 += v51
                t2[setup_phase] = (t2[setup_phase] or 0) + v51
                v48 = v50
                continue
            end

            v49 = v50
        else
            v49 = v48
        end

        break
    end

    if p17.session ~= session then
        return
    end

    start_intro(session)
    p17:message_server("intro_started", workspace:GetServerTimeNow())

    if not (n1 < CONSTANTS.minigame_entry_cover_timeout) then
        local v52 = session.setup_phase
        local n2 = 0

        for v53, v54 in t2 do
            if n2 < v54 then
                n2 = v54
                v52 = v53
            end
        end

        local v55 = if v49 then (", %* assets loaded and %* failed"):format(v49.loaded, v49.failed) else ""

        warn((("[Spotlight] - Entry cover gave up after %* s, mostly on %*%*"):format(string.format("%.1f", n1), v52, v55)))
    end
end

function v27.minigame_interior_render(p18, p19) -- line: 269
    -- upvalues: Music (copy), SoundDB (copy), v5 (copy), v22 (copy)
    local CONSTANTS = v22.CONSTANTS
    local v56 = v5.new_session()

    p18.session = v56
    Music.play(CONSTANTS.music_hold_priority, SoundDB.Silence)
    v56.maid:GiveTask(function() -- line: 275
        -- upvalues: CONSTANTS (copy), Music (copy), SoundDB (copy)
        Music.stop(CONSTANTS.music_hold_priority, SoundDB.Silence)
        Music.adjust_global_playback_speed(1)
    end)

    local v57 = task.spawn(p18._connect_session, p18, v56, p19)

    p18.leave_maid:GiveTask(function() -- line: 282
        -- upvalues: p18 (copy), v56 (copy), v57 (copy)
        if coroutine.status(v57) == "suspended" then
            task.cancel(v57)
        end

        v56.maid:Destroy()
        p18.session = nil
    end)
end

return v27
