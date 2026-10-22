

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.CloudValueSchemas.ghost_clusters
-- Took 0.3s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local v1 = require(game.ReplicatedStorage.Fsys).load("package:t")

local function ascending_tiers(v2) -- line 5
    if #v2 == 0 then
        return false, "score_candy_tiers needs at least one tier"
    end
    local v3 = #v2
    for v4 = 2, v3 do
        if v2[v4].score <= v2[v4 - 1].score then
            return false, (("score_candy_tiers[%*].score must be greater than the tier before it"):format(v4))
        end
    end
    return true
end

return {
    boss_drain_multiplier = {
        safeDefault = 2.5,
        type = v1.numberMinExclusive(0)
    },
    boss_stretch_extra_sec = {
        type = v1.strictArray(v1.numberMin(0), v1.numberMin(0), v1.numberMin(0), v1.numberMin(0)),
        safeDefault = { 8, 0, 0, 5 }
    },
    shield_hp_ghosts_per_active_player = {
        safeDefault = 1,
        type = v1.numberMinExclusive(0)
    },
    shield_final_wave_hp_scale = {
        safeDefault = 0.75,
        type = v1.numberMinExclusive(0)
    },
    boss_tornado_every_n_stops = {
        safeDefault = 2,
        type = v1.every(v1.integer, v1.numberMin(1))
    },
    score_candy_tiers = {
        type = v1.every(v1.array(v1.strictInterface({
            score = v1.numberMin(0),
            candy = v1.numberMin(0)
        })), ascending_tiers),
        safeDefault = {
            {
                score = 0,
                candy = 0
            },
            {
                score = 100,
                candy = 400
            },
            {
                score = 2000,
                candy = 750
            },
            {
                score = 5000,
                candy = 1500
            },
            {
                score = 15000,
                candy = 2250
            },
            {
                score = 25000,
                candy = 2750
            },
            {
                score = 40000,
                candy = 3000
            },
            {
                score = 72000,
                candy = 3750
            },
            {
                score = 100000,
                candy = 5000
            }
        }
    },
    candy_per_combo = {
        safeDefault = 100,
        type = v1.every(v1.integer, v1.numberMin(0))
    },
    max_currency_reward = {
        safeDefault = 5000,
        type = v1.every(v1.integer, v1.numberMin(0))
    }
}


-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersClientConstants
-- Took 0.27s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

return {
    SCORE_POPUP_MERGE_SEC = 1.5,
    SCORE_POPUP_FLOAT_SEC = 1.2,
    VACUUM_STREAM_RANGE = 20,
    VACUUM_STREAM_SEGMENTS = 10,
    VACUUM_STREAM_MAX_SLOPE = 0.6,
    VACUUM_STREAM_FALLBACK_DROP = 4,
    TELL_CYCLE_SEC = 5,
    TELL_ACTIVE_SEC = 1.2,
    TELL_SHAKE_STUDS = 0.12,
    TELL_SHAKE_DEG = 1.6,
    PET_ALERT_RADIUS = 24,
    PET_ALERT_RELEASE_RADIUS = 30,
    PET_BEG_STANDOFF = 4,
    PET_BEG_SPREAD = 1.5,
    PET_SCAN_INTERVAL_SEC = 0.1,
    PET_TRICK_PRIORITY = { "Beg", "Joy", "Joyful", "Sit" },
    PET_RUN_SPEED = 30,
    PET_NOTICE_BURST_COUNT = 3,
    PET_NOTICE_BURST_GAP_SEC = 0.4,
    PET_NOTICE_REST_SEC = 1.5,
    PET_NOTICE_DELAY_SEC = 0.05,
    PET_NOTICE_HOLD_SEC = 0.25,
    PET_NOTICE_JUMP_HEIGHT = 5,
    PET_FIND_FILL_TRANSPARENCY_MIN = 0.55,
    PET_FIND_FILL_TRANSPARENCY_MAX = 0.78,
    PET_FIND_PULSE_HZ = 0.5,
    PET_FOUND_SHAKE_ENVELOPE = 4,
    PET_FOUND_SHAKE_CYCLE_SEC = 0.5,
    BOSS_DEFEAT_INFLATE_SEC = 1.7,
    BOSS_DEFEAT_INFLATE_SCALE = 1.5,
    BOSS_DEFEAT_SHAKE_STUDS = 1.1,
    BOSS_DEFEAT_SHAKE_HZ = 9,
    BOSS_DEFEAT_RISE = 4,
    BOSS_DEFEAT_ORBIT_SEC = 2,
    BOSS_DEFEAT_ORBIT_RADIUS = 9,
    BOSS_DEFEAT_ORBIT_TURNS = 1.15,
    BOSS_DEFEAT_ORBIT_WOBBLE_STUDS = 2.4,
    BOSS_DEFEAT_ORBIT_WOBBLE_HZ = 2.2,
    BOSS_DEFEAT_POOF_PARTICLES = 90,
    BOSS_DEFEAT_POOF_LIFETIME = 4,
    BOSS_DEFEAT_POOF_SIZE_SCALE = 2.75,
    VISUAL_FOLLOW_RESPONSE = 18,
    VISUAL_BOB_HEIGHT = 0.35,
    VISUAL_BOB_SPEED = 2.2,
    VISUAL_SWAY_DEG = 4,
    VACUUM_VISUAL_THRASH_DISTANCE = {
        Small = 0.75,
        Medium = 1,
        Large = 0.35
    },
    HEAD_SPRING_DAMP = 0.75,
    HEAD_SPRING_FREQ = 3,
    INTRO_SEC = 4,
    INTRO_RISE_SEC = 2.2,
    INTRO_RISE_HEIGHT = 36,
    INTRO_BURY = 16,
    INTRO_FRAME_INSET = 4,
    INTRO_TWIRL_TURNS = 2,
    INTRO_HIDE_PORTION = 0.4,
    INTRO_FOCUS_LIFT = 12,
    INTRO_FOV_WIDE = 98,
    INTRO_DUTCH_DEG = 12,
    INTRO_AIM_DAMP = 0.7,
    INTRO_AIM_FREQ = 2.2,
    INTRO_FOV_DAMP = 0.48,
    INTRO_FOV_FREQ = 2.4,
    INTRO_ROLL_DAMP = 0.55,
    INTRO_ROLL_FREQ = 3,
    stream_curvature = function(v1, v2, v3) -- stream_curvature | line 147
        local v4 = (v1 * v3 + v2) / (v3 * v3)
        return (math.max(v4, 0))
    end,
    stream_point = function(v5, v6, v7, v8, v9) -- stream_point | line 153
        return v5 + v6 * v9 + Vector3.new(0, 1, 0) * (v7 * v9 - v8 * v9 * v9)
    end
}

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersConstants
-- Took 0.34s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local v1 = {
    TOY_KIND = "halloween_2026_ghost_vacuum",
    TOOL_KIND = "GhostVacuumTool",
    EVENT_ID = "halloween_2026",
    MINIGAME_ID = "ghost_clusters",
    MINIGAME_DESTINATION_ID = "ManorMinigameInterior",
    JOIN_ZONE_DESTINATION_ID = "HauntedManor",
    SCHEDULE_ORDER = 2,
    MAX_PLAYERS_PER_SESSION = 7,
    ROUND_SEC = 150,
    INTERMISSION_LENGTH = 4,
    BOSS_BREAKOUT_SEC = 75,
    BOSS_ABSORPTION_SEC = 3,
    WALK_SPEED = 22.4,
    GHOST_CAST_MAX_PER_WAVE = 3,
    GHOST_CAST_WINDOW_SEC = 57,
    GHOST_CAST_TRAVEL_SEC = 1.7,
    GHOST_CAST_STAGGER_MIN_SEC = 0.1,
    GHOST_CAST_STAGGER_MAX_SEC = 0.5,
    GHOST_CAST_EXIT_DISTANCE = 14,
    GHOST_CAST_EXIT_HEIGHT = 12,
    GHOST_CAST_WEAVE = 8,
    GHOST_CAST_TRAIL_LIFETIME = 1.15,
    MURAL_STRUGGLE_MIN_ENVELOPE = 0.5,
    MURAL_STRUGGLE_MAX_ENVELOPE = 2.4,
    MURAL_CAST_PULSE_SEC = 0.45,
    MURAL_CAST_PULSE_ENVELOPE = 1.3,
    MURAL_BREAKOUT_ENVELOPE = 3.5,
    VACUUM_RANGE = {
        Large = 65,
        Medium = 27,
        Small = 22
    },
    VACUUM_LOCK_RANGE_SLACK = 1.3
}

function v1.ghost_vacuum_range(v2, v3) -- line 54 | captures: v1
    if v3 then
        return v1.VACUUM_RANGE.Large
    end
    return v1.VACUUM_RANGE[v2]
end

v1.PROGRESS_PER_SEC_PER_PLAYER = 3.5
v1.PROGRESS_BASE = {
    Large = 70,
    Medium = 25,
    Small = 15
}
v1.PROGRESS_SOLO_BONUS = {
    Large = 112,
    Medium = 7.5,
    Small = 1.6666666666666667
}
v1.DRAIN_ASSIST_SCALE = 0.4
v1.DRAIN_MAX_COMBINED_WEIGHT = 3
v1.CANDY_VALUE = {
    Large = 5000,
    Medium = 1000,
    Small = 250
}
v1.SCORE_REPLICATE_SEC = 0.25
v1.SCORE_PER_CANDY = 4
v1.SCORE_DISPLAY_STEP = 50
v1.BOSS_VICTORY_DELAY_SEC = 5
v1.HEAD_AIM_EPSILON = 2
v1.VACUUM_AIM_CONE_VIEWPORT_FRAC = 0.15
v1.VACUUM_AIM_CONE_TOUCH_FRAC = 0.22
v1.VACUUM_REACQUIRE_DELAY_SEC = 0.15
v1.VACUUM_NEARBY_HIGHLIGHT_MAX = 10
v1.VACUUM_HIGHLIGHT_REFRESH_SEC = 0.06
v1.CONTRIBUTE_KEEPALIVE_TIMEOUT_SEC = 2
v1.COMBINE_SCORE_BONUS = 1000
v1.HAUNTED_PROP_RATIO = 0.8
v1.PROP_KIND_DENYLIST = {}
v1.MURAL_FURNITURE_KIND = "halloween_2026_haunted_mural"
v1.PROP_SMALL_MAX_EXTENT = 8
v1.PROP_MEDIUM_MAX_EXTENT = 12
v1.PROP_CAPACITY_MAX = {
    Large = 1,
    Medium = 1,
    Small = 3
}
v1.MEDIUM_PROP_SMALL_NEST_CHANCE = 0.4
v1.MEDIUM_PROP_SMALL_NEST_COUNT = 3
v1.PROP_FLUSH_SEC = 0.25
v1.PROP_PROGRESS_PUSH_SEC = 0.1
v1.PROP_RESTORE_SEC = 5
v1.MURAL_FLUSH_SEC = 2
v1.PROP_VACUUM_RANGE = 18
v1.MURAL_VACUUM_RANGE = 60
v1.FLEE_SPEED = {
    Large = 6,
    Medium = 9,
    Small = 13
}
v1.PANIC_BURST_SPEED = {
    Medium = 17,
    Small = 20
}
v1.PANIC_TIRED_SPEED = {
    Medium = 8,
    Small = 11
}
v1.PANIC_BURST_SEC = 0.55
v1.PANIC_LINGER_SEC = 1.1
v1.TURN_RATE_PANIC_DEG = 240
v1.TURN_RATE_AMBIENT_DEG = 140
v1.TURN_RATE_VACUUM_DEG = 540
v1.MOVE_ACCEL = 28
v1.ROAM_TARGET_REACHED_DISTANCE = 2.5
v1.BOUNDS_WALL_MARGIN = 3
v1.SERVER_MOTION_HZ = 10
v1.MAX_PREDICTION_SEC = 0.15
v1.VACUUM_RESISTANCE_FREQUENCY = 3.2
v1.VACUUM_RESISTANCE_SECONDARY_FREQUENCY = 7.4
v1.VACUUM_RESISTANCE_SECONDARY_SCALE = 0.4
v1.VACUUM_ESCAPE_BIAS = 0.35
v1.VACUUM_PLANTED_WALK_SPEED_SCALE = 0.5
v1.VACUUM_DRAG_FOLLOW_SPEED = 20
v1.BOSS_EXTRA_PLAYER_DRAIN_SAVE_SEC = 0.05
v1.BOSS_SCORE_SCALE = 0.35
v1.BOSS_SHIELD_THRESHOLDS = { 0.8, 0.4, 0.1 }
v1.SHIELD_FINAL_WAVE_SIZE = "Medium"
v1.SHIELD_WAVE_GHOST_COUNT = {
    Small = 3,
    Medium = 2
}
v1.SHIELD_FINAL_WAVE_HP_SCALE = 0.75
v1.SHIELD_ACTIVE_PLAYER_WINDOW_SEC = 20
v1.BOSS_COWER_SPEED = 8
v1.BOSS_HOVER_DROP = 3.5
v1.BOSS_MENACE_SPEED = 24
v1.BOSS_MENACE_PULL = 0.4
v1.BOSS_MENACE_WANDER_RATE = 0.25
v1.BOSS_MENACE_WANDER_TURN_RAD_PER_SEC = 3.5
v1.BOSS_MENACE_TURN_RESPONSE = 2.2
v1.BOSS_MENACE_BOB = 2.5
v1.BOSS_MENACE_BOB_HZ = 0.22
v1.BOSS_MENACE_HEIGHT_RESPONSE = 2
v1.BOSS_WALL_MARGIN = 8
v1.BOSS_MENACE_TARGET_SEC = 4.5
v1.BOSS_DIP_INTERVAL_MIN_SEC = 2.2
v1.BOSS_DIP_INTERVAL_MAX_SEC = 4
v1.BOSS_DIP_SEC = 1.1
v1.BOSS_DIP_SPEED = 46
v1.BOSS_DIP_HEIGHT = 6
v1.BOSS_SHIELDED_SCALE = 0.45
v1.BOSS_SHIELDED_TRANSPARENCY = 0.85
v1.GOLD_TOY_KIND = "halloween_2026_ghost_vacuum_gold"
v1.GOLD_DRAIN_MULTIPLIER = 1.35
v1.BOSS_DRAIN_ROAM_SPEED_SCALE = 0.45
v1.BOSS_FLOAT_SPEED = 16
v1.BOSS_NEARBY_LANDING_RADIUS_MIN = 8
v1.BOSS_NEARBY_LANDING_RADIUS_MAX = 22
v1.BOSS_ORBIT_SEC = 2.8
v1.BOSS_ORBIT_SPIN_RAD_PER_SEC = 4.2
v1.BOSS_ORBIT_RADIUS_MIN = 7
v1.BOSS_ORBIT_RADIUS_MAX = 14
v1.BOSS_ORBIT_HEIGHT = 5
v1.BOSS_ORBIT_BOB = 1.8
v1.BOSS_TORNADO_TO_RING_CATCHUP = 0.7
v1.BOSS_TORNADO_MAX_CATCHUP_SPEED = 20
v1.BOSS_TORNADO_VELOCITY_RESPONSE = 3.6
v1.BOSS_TORNADO_INITIAL_LIFT = 14
v1.BOSS_STOP_DWELL_SEC = 1.5
v1.ATTACK_WINDUP_SEC = 2.4
v1.ATTACK_HOLD_SEC = 0.4
v1.ATTACK_BURST_SEC = 0.32
v1.ATTACK_BURST_START_DIAMETER = 1.5
v1.ATTACK_SPIN_GEAR_RAD_PER_SEC = { 1.8, 8, 26 }
v1.TORNADO_INTERVAL_MIN_SEC = 8
v1.TORNADO_INTERVAL_MAX_SEC = 12
v1.ATTACK_RADIUS = {
    Small = 18,
    Medium = 24,
    Large = 92
}
v1.ATTACK_IMPULSE = {
    Small = 38,
    Medium = 48,
    Large = 70
}
v1.ATTACK_UP_IMPULSE = 22
v1.ATTACK_FLING_SEC = 0.65
v1.VACUUM_REACTION_BASE_ACCEL = {
    Small = 8,
    Medium = 12,
    Large = 5
}
v1.VACUUM_REACTION_PULSE_ACCEL = {
    Small = 12,
    Medium = 16,
    Large = 8
}
v1.VACUUM_REACTION_LATERAL_ACCEL = {
    Small = 5,
    Medium = 7,
    Large = 3
}
v1.VACUUM_REACTION_DRAG = 4
v1.VACUUM_REACTION_MAX_ACCEL = 30
v1.COMBINE_MAX_MASS = 15
v1.COMBINE_SCALE_PER_MASS = 0.15
v1.COMBINE_COLLISION_RADIUS_SCALE = 0.7
v1.MURAL_SPINE_MAX_YAW_DEG = 12
v1.MURAL_GHOST_HEIGHT_OFFSET = -6
v1.GHOST_ATTR = {
    Id = "GhostClustersId",
    Size = "GhostClustersSize",
    ModelName = "GhostClustersModelName",
    Progress = "GhostClustersProgress",
    ProgressRequired = "GhostClustersProgressRequired",
    VacuumLocked = "GhostClustersVacuumLocked",
    BeingVacuumed = "GhostClustersBeingVacuumed",
    MoveSeed = "GhostClustersMoveSeed",
    HeadTarget = "GhostClustersHeadTarget",
    CombineMass = "GhostClustersCombineMass",
    Orbiting = "GhostClustersOrbiting",
    Slot = "GhostClustersSlot",
    Shielded = "GhostClustersShielded",
    IsShield = "GhostClustersIsShield"
}
v1.LIVE_FOLDER_NAME = "GhostClustersLive"
v1.VISUAL_FOLDER_NAME = "GhostClustersVisuals"
v1.JOIN_ZONE_NAME = "GhostClustersMinigameJoinZone"

function v1.progress_required(v4) -- line 319 | captures: v1
    return v1.PROGRESS_BASE[v4] + v1.PROGRESS_SOLO_BONUS[v4]
end

function v1.candy_value(v5, v6) -- line 323 | captures: v1
    return v1.CANDY_VALUE[v5] * v6
end

function v1.score_value(v7, v8) -- line 327 | captures: v1
    return v7 * v1.SCORE_PER_CANDY * v8
end

local function candy_for_score(v9, v10) -- line 331
    if v9 <= v10[1].score then
        return v10[1].candy
    end
    local v11 = #v10
    for v12 = 2, v11 do
        local v13 = v10[v12 - 1]
        local v14 = v10[v12]
        if v9 <= v14.score then
            local v15 = v14.score - v13.score
            local v16 = (v9 - v13.score) / v15
            local v17 = v13.candy + (v14.candy - v13.candy) * v16
            return (math.floor(v17))
        end
    end
    return v10[#v10].candy
end

v1.candy_for_score = candy_for_score

function v1.boss_dip_interval() -- line 347 | captures: v1
    return v1.BOSS_DIP_INTERVAL_MIN_SEC + math.random() * (v1.BOSS_DIP_INTERVAL_MAX_SEC - v1.BOSS_DIP_INTERVAL_MIN_SEC)
end

function v1.tornado_interval() -- line 353 | captures: v1
    return v1.TORNADO_INTERVAL_MIN_SEC + math.random() * (v1.TORNADO_INTERVAL_MAX_SEC - v1.TORNADO_INTERVAL_MIN_SEC)
end

function v1.attack_spin_rad_per_sec(v18) -- line 359 | captures: v1
    local ATTACK_SPIN_GEAR_RAD_PER_SEC = v1.ATTACK_SPIN_GEAR_RAD_PER_SEC
    local v19 = v18 / v1.ATTACK_WINDUP_SEC
    local v20 = math.clamp(v19, 0, 1)
    if v20 < 0.3333333333333333 then
        return ATTACK_SPIN_GEAR_RAD_PER_SEC[1]
    end
    if v20 < 0.6666666666666666 then
        return ATTACK_SPIN_GEAR_RAD_PER_SEC[2]
    end
    return ATTACK_SPIN_GEAR_RAD_PER_SEC[3]
end

local function is_vacuum_ragdolled(v21) -- line 370
    local v22 = v21:GetState()
    if v22 == Enum.HumanoidStateType.Physics then
        return true
    end
    return v22 == Enum.HumanoidStateType.FallingDown
end

v1.is_vacuum_ragdolled = is_vacuum_ragdolled

function v1.tornado_orbit_offset(v23, v24) -- line 375 | captures: v1
    local v25 = math.cos(v23) * v24
    local BOSS_ORBIT_HEIGHT = v1.BOSS_ORBIT_HEIGHT
    local v26 = v23 * 2
    local v27 = BOSS_ORBIT_HEIGHT + math.sin(v26) * v1.BOSS_ORBIT_BOB
    local v28 = math.sin(v23) * v24
    return (Vector3.new(v25, v27, v28))
end

function v1.prop_vacuum_range(v29) -- line 385 | captures: v1
    if v29 then
        return v1.MURAL_VACUUM_RANGE
    end
    return v1.PROP_VACUUM_RANGE
end

local function flat_distance(v30, v31) -- line 391
    local v32 = v30.X - v31.X
    local v33 = v30.Z - v31.Z
    local v34 = v32 * v32 + v33 * v33
    return (math.sqrt(v34))
end

v1.flat_distance = flat_distance
return v1

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersGhosts
-- Took 0.41s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GhostClustersConstants = require(script.Parent.GhostClustersConstants)
local GhostClustersMotion = require(script.Parent.GhostClustersMotion)
local v1 = {
    Large = "BigGhost",
    Medium = "MediumGhost",
    Small = "SmallGhost"
}
local v2 = {
    MURAL_MODEL_NAME = "BigMuralGhost",
    create_slot_pool = function() -- create_slot_pool | line 65
        return {
            next_slot = 0,
            free_slots = {}
        }
    end
}

local function alloc_slot(v3) -- line 72
    local v4 = table.remove(v3.free_slots)
    if v4 == nil then
        local next_slot = v3.next_slot
        if next_slot > 255 then
            error("GhostClusters slot overflow")
        end
        v3.next_slot += 1
        return next_slot
    end
    return v4
end

function v2.model_name_for_size(v5) -- line 85 | captures: v1
    return v1[v5] or "SmallGhost"
end

function v2.get_template(v6) -- line 89 | captures: ReplicatedStorage
    return ReplicatedStorage.Resources.GhostClusters[v6]
end

local function get_or_create_child_folder(v7, v8) -- line 93
    local v9 = v7:FindFirstChild(v8)
    if v9 then
        return v9
    end
    local Folder = Instance.new("Folder")
    Folder.Name = v8
    Folder.Parent = v7
    return Folder
end

function v2.get_or_create_live_folder(v10) -- line 106 | captures: GhostClustersConstants
    local workspace_2 = workspace
    local LIVE_FOLDER_NAME = GhostClustersConstants.LIVE_FOLDER_NAME
    local v11 = workspace_2:FindFirstChild(LIVE_FOLDER_NAME)
    if not v11 then
        v11 = Instance.new("Folder")
        v11.Name = LIVE_FOLDER_NAME
        v11.Parent = workspace_2
    end
    local v12 = v11:FindFirstChild(v10)
    if v12 then
        return v12
    end
    local Folder = Instance.new("Folder")
    Folder.Name = v10
    Folder.Parent = v11
    return Folder
end

function v2.destroy_live_folder(v13) -- line 111 | captures: GhostClustersConstants
    local v14 = workspace:FindFirstChild(GhostClustersConstants.LIVE_FOLDER_NAME)
    local v15 = v14 and v14:FindFirstChild(v13)
    if v15 then
        v15:Destroy()
    end
    if v14 and #v14:GetChildren() == 0 then
        v14:Destroy()
    end
end

function v2.set_attrs(v16) -- line 122 | captures: GhostClustersConstants
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    local model = v16.model
    model:SetAttribute(GHOST_ATTR.Id, v16.id)
    model:SetAttribute(GHOST_ATTR.Size, v16.size)
    model:SetAttribute(GHOST_ATTR.ModelName, v16.model_name)
    model:SetAttribute(GHOST_ATTR.Progress, v16.vacuum_progress)
    model:SetAttribute(GHOST_ATTR.ProgressRequired, v16.progress_required)
    model:SetAttribute(GHOST_ATTR.VacuumLocked, v16.vacuum_locked)
    model:SetAttribute(GHOST_ATTR.BeingVacuumed, v16.being_vacuumed)
    model:SetAttribute(GHOST_ATTR.MoveSeed, v16.move_seed)
    model:SetAttribute(GHOST_ATTR.HeadTarget, v16.head_target)
    model:SetAttribute(GHOST_ATTR.CombineMass, v16.combine_mass)
    model:SetAttribute(GHOST_ATTR.Orbiting, v16.orbiting)
    model:SetAttribute(GHOST_ATTR.Slot, v16.slot)
end

function v2.set_vacuum_locked(v17, v18) -- line 139 | captures: GhostClustersConstants
    if v17.vacuum_locked ~= v18 then
        v17.vacuum_locked = v18
        v17.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.VacuumLocked, v18)
    end
end

function v2.set_being_vacuumed(v19, v20) -- line 147 | captures: GhostClustersConstants
    if v19.being_vacuumed ~= v20 then
        v19.being_vacuumed = v20
        v19.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.BeingVacuumed, v20)
    end
end

function v2.set_vacuum_progress(v21, v22, v23) -- line 155 | captures: GhostClustersConstants
    v21.vacuum_progress = v22
    if v23 then
        v21.replicated_progress = v22
        v21.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.Progress, v22)
    end
end

function v2.sync_being_vacuumed(v24) -- line 163 | captures: v2
    v2.set_being_vacuumed(v24, next(v24.contributors) ~= nil)
end

local function is_prop_rig_model(v25) -- line 167
    local Name = v25.Name
    if Name == "PropGhost" then
        return true
    end
    return Name:sub(-4) == "PROP"
end

local function is_under_prop_rig(v26, v27) -- line 175
    local Parent = v26.Parent
    while true do
        if Parent then
            if Parent == v27 then
                return false
            end
            local v28
            if Parent:IsA("Model") then
                local Name = Parent.Name
                local v29 = if Name == "PropGhost" then true else Name:sub(-4) == "PROP"
                v28 = not not v29
            else
                v28 = false
            end
            if v28 then
                break
            end
            Parent = Parent.Parent
            continue
        end
        return false
    end
    return true
end

v2.is_under_prop_rig = is_under_prop_rig

function v2.set_orbiting(v30, v31) -- line 186 | captures: GhostClustersConstants, v2
    v30.orbiting = v31
    v30.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.Orbiting, v31)
    for v32, v33 in v30.model:GetDescendants() do
        if v33:IsA("BasePart") and not v2.is_under_prop_rig(v33, v30.model) then
            v33.CanQuery = not v31
        end
    end
end

local function set_motion(v34, v35, v36) -- line 196
    v34.cframe = v35
    v34.velocity = v36
end

v2.set_motion = set_motion

function v2.root_floor_offset(v37, v38) -- line 201 | captures: GhostClustersConstants, v2
    local v39 = v37.RootPart.Size.Y / 2
    if (v38 or v37:GetAttribute(GhostClustersConstants.GHOST_ATTR.ModelName)) == v2.MURAL_MODEL_NAME then
        v39 += GhostClustersConstants.MURAL_GHOST_HEIGHT_OFFSET
    end
    return v39
end

function v2.set_effects_enabled(v40, v41) -- line 210 | captures: v2
    for v42, v43 in v40:GetDescendants() do
        if not v2.is_under_prop_rig(v43, v40) then
            if v43:IsA("ParticleEmitter") then
                if not v41 then
                    v43:Clear()
                end
                v43.Enabled = v41
            elseif v43:IsA("Beam") or v43:IsA("Trail") then
                v43.Enabled = v41
            end
        end
    end
end

function v2.clear_effects(v44) -- line 228 | captures: v2
    for v45, v46 in v44:GetDescendants() do
        if not v2.is_under_prop_rig(v46, v44) and v46:IsA("ParticleEmitter") then
            v46:Clear()
        end
    end
end

local v47 = {}
local v48 = { __mode = "k" }
local v49 = setmetatable(v47, v48)

function v2.beam_anchor(v50) -- line 248 | captures: v49
    local v51 = v49[v50]
    if v51 then
        return v51
    end
    local v52 = v50:FindFirstChild("TargetLock", true) or v50.RootPart
    v49[v50] = v52
    return v52
end

local function anchor_world_position(v53) -- line 263
    if v53:IsA("Attachment") then
        local Parent = v53.Parent
        if not (Parent and Parent:IsA("Bone")) then
            return v53.WorldPosition
        end
        return (Parent.TransformedWorldCFrame * v53.CFrame).Position
    end
    return v53.Position
end

v2.anchor_world_position = anchor_world_position

function v2.center_position_on_floor(v54, v55) -- line 274 | captures: v2
    return v55 + Vector3.new(0, 1, 0) * v2.root_floor_offset(v54.model, v54.model_name)
end

function v2.place_on_floor(v56, v57) -- line 278 | captures: v2
    local v58 = v57 + Vector3.new(0, 1, 0) * v2.root_floor_offset(v56.model, v56.model_name)
    v2.set_motion(v56, v58, (Vector3.new(0, 0, 0)))
end

function v2.collision_radius(v59) -- line 283 | captures: GhostClustersConstants
    local v60 = v59.model:GetExtentsSize()
    local X = v60.X
    local Z = v60.Z
    return math.max(X, Z) * GhostClustersConstants.COMBINE_COLLISION_RADIUS_SCALE
end

local function bounds_radius(v61) -- line 288
    local v62 = v61.model:GetExtentsSize()
    local X = v62.X
    local Z = v62.Z
    return math.max(X, Z) / 2
end

v2.bounds_radius = bounds_radius

function v2.absorb(v63, v64) -- line 293 | captures: GhostClustersConstants, v2
    local v65 = v63.cframe - Vector3.new(0, 1, 0) * v2.root_floor_offset(v63.model, v63.model_name)
    v63.combine_mass += v64.combine_mass
    v63.progress_required += v64.progress_required
    local set_vacuum_progress = v2.set_vacuum_progress
    local progress_required = v63.progress_required
    local v66 = v63.vacuum_progress + v64.vacuum_progress
    set_vacuum_progress(v63, math.min(progress_required, v66), true)
    v63.candy_paid += v64.candy_paid
    v63.bonus_candy += v64.bonus_candy + GhostClustersConstants.candy_value(v64.size, v64.combine_mass) - GhostClustersConstants.candy_value(v63.size, v64.combine_mass)
    v63.model:ScaleTo(v63.base_scale * (1 + (v63.combine_mass - 1) * GhostClustersConstants.COMBINE_SCALE_PER_MASS))
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    v63.model:SetAttribute(GHOST_ATTR.CombineMass, v63.combine_mass)
    v63.model:SetAttribute(GHOST_ATTR.ProgressRequired, v63.progress_required)
    v2.place_on_floor(v63, v65)
end

function v2.prepare_ghost_model(v67) -- line 319 | captures: v2
    local RootPart = v67.RootPart
    v67.PrimaryPart = RootPart
    for v68, v69 in v67:GetDescendants() do
        if v69:IsA("BasePart") and not v2.is_under_prop_rig(v69, v67) then
            v69.Anchored = true
            v69.CanCollide = false
            v69.CanQuery = true
            v69.CanTouch = false
            v69.Massless = true
        end
    end
    v2.set_effects_enabled(v67, false)
    return RootPart
end

function v2.spawn(v70) -- line 335 | captures: HttpService, GhostClustersConstants, GhostClustersMotion, v2
    local v71 = v70.model_name or v2.model_name_for_size(v70.size)
    local v72 = v2.get_template(v71):Clone()
    local v73 = v2.prepare_ghost_model(v72)
    v72.ModelStreamingMode = Enum.ModelStreamingMode.PersistentPerPlayer
    for v74, v75 in v72:GetDescendants() do
        if v75:IsA("Model") then
            v75.ModelStreamingMode = Enum.ModelStreamingMode.PersistentPerPlayer
        end
    end
    local v76 = v70.cframe + Vector3.new(0, 1, 0) * v2.root_floor_offset(v72, v71)
    v72:PivotTo(v76)
    local v77 = HttpService:GenerateGUID(false)
    v72.Name = ("Ghost_%*_%*"):format(v70.size, v77)
    local v78 = GhostClustersMotion.flat_unit(v76.LookVector)
    local v79 = math.random() * 1000
    local v80 = { id = v77 }
    local slot_pool = v70.slot_pool
    local v81 = table.remove(slot_pool.free_slots)
    if v81 == nil then
        local next_slot = slot_pool.next_slot
        if next_slot > 255 then
            error("GhostClusters slot overflow")
        end
        slot_pool.next_slot += 1
        v81 = next_slot
    end
    v80.slot = v81
    v80.size = v70.size
    v80.model_name = v71
    v80.model = v72
    v80.root = v73
    v80.cframe = v76
    v80.velocity = Vector3.new(0, 0, 0)
    v80.vacuum_progress = 0
    v80.progress_required = GhostClustersConstants.progress_required(v70.size)
    v80.vacuum_locked = false
    v80.being_vacuumed = false
    v80.contributors = {}
    v80.alive = true
    v80.move_seed = v79
    v80.heading = v78
    v80.speed = GhostClustersConstants.FLEE_SPEED[v70.size] or 0
    v80.panic_until = 0
    v80.panic_burst_until = 0
    v80.panic_from = nil
    if v70.size == "Large" then
        v80.head_target = v76.Position + v78 * 20
    else
        v80.head_target = nil
    end
    v80.capture_centroid = v76.Position
    v80.roam_target = nil
    v80.drag_offset = nil
    v80.combine_mass = 1
    v80.base_scale = v72:GetScale()
    v80.candy_paid = 0
    v80.bonus_candy = 0
    v80.replicated_progress = 0
    v80.attack_phase = "idle"
    v80.attack_kind = nil
    v80.attack_until = 0
    v80.next_tornado_at = os.clock() + math.random() * GhostClustersConstants.TORNADO_INTERVAL_MIN_SEC
    v80.orbiting = false
    v80.orbit_angle = 0
    v80.orbit_radius = 0
    v80.slot_pool = v70.slot_pool
    v2.set_attrs(v80)
    v72.Parent = v2.get_or_create_live_folder(v70.live_folder_name)
    return v80
end

local function destroy(v82) -- line 410
    if not v82.alive then
        return
    end
    v82.alive = false
    v82.contributors = {}
    local free_slots = v82.slot_pool.free_slots
    local slot = v82.slot
    table.insert(free_slots, slot)
    if v82.model.Parent then
        v82.model:Destroy()
    end
end

v2.destroy = destroy

function v2.set_large_head_aim(v83, v84) -- line 422 | captures: GhostClustersConstants
    local head_target = v83.head_target
    if not (head_target and (head_target - v84).Magnitude < GhostClustersConstants.HEAD_AIM_EPSILON) then
        v83.head_target = v84
        v83.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.HeadTarget, v84)
    end
end

function v2.apply_split_burst(v85, v86) -- line 431 | captures: GhostClustersConstants, v2
    local v87 = #v85
    local v88 = os.clock()
    for v89, v90 in v85 do
        local v91 = (v89 - 1) * (6.283185307179586 / v87)
        local v92 = math.cos(v91)
        local v93 = math.sin(v91)
        local v94 = Vector3.new(v92, 0, v93)
        local v95 = v2.center_position_on_floor(v90, v86)
        v2.set_motion(v90, CFrame.new(v95, v95 + v94), v94 * (GhostClustersConstants.PANIC_BURST_SPEED[v90.size] or 14))
        v90.heading = v94
        v90.speed = GhostClustersConstants.PANIC_BURST_SPEED[v90.size] or GhostClustersConstants.FLEE_SPEED[v90.size] or 14
        v90.panic_until = v88 + GhostClustersConstants.PANIC_LINGER_SEC
        v90.panic_burst_until = v88 + GhostClustersConstants.PANIC_BURST_SEC
        v90.panic_from = v86
    end
end

function v2.begin_panic(v96, v97) -- line 453 | captures: GhostClustersConstants, GhostClustersMotion, v2
    local v98 = GhostClustersMotion.flat_unit(v96.cframe.Position - v97)
    local v99 = GhostClustersConstants.PANIC_BURST_SPEED[v96.size] or GhostClustersConstants.FLEE_SPEED[v96.size] or 0
    local v100 = os.clock()
    v96.heading = v98
    v96.speed = v99
    v96.panic_from = v97
    v96.panic_until = v100 + GhostClustersConstants.PANIC_LINGER_SEC
    v96.panic_burst_until = v100 + GhostClustersConstants.PANIC_BURST_SEC
    v2.set_motion(v96, CFrame.new(v96.cframe.Position, v96.cframe.Position + v98), v98 * v99)
end

function v2.integrate_move(v101, v102, v103, v104, v105, v106) -- line 471 | captures: GhostClustersConstants, GhostClustersMotion, v2
    local v107, v108, v109, v110 = GhostClustersMotion.step_planar({
        position = v101.cframe.Position,
        heading = v101.heading,
        speed = v101.speed,
        desired_direction = v102,
        target_speed = v103,
        turn_rate_deg = v104,
        acceleration = GhostClustersConstants.MOVE_ACCEL,
        dt = v105,
        resolve_floor = v106,
        half_height = v2.root_floor_offset(v101.model, v101.model_name)
    })
    v101.heading = v108
    v101.speed = v109
    v2.set_motion(v101, v107, v110)
end

function v2.steer_facing(v111, v112, v113, v114) -- line 496 | captures: GhostClustersMotion
    local v115 = math.rad(v113) * v114
    v111.heading = GhostClustersMotion.flat_unit(GhostClustersMotion.steer_heading(v111.heading, GhostClustersMotion.flat_unit(v112), v115))
    return v111.heading
end

function v2.face_away_from(v116, v117, v118, v119) -- line 509 | captures: GhostClustersMotion, v2
    v2.steer_facing(v116, GhostClustersMotion.flat_unit(v116.cframe.Position - v117), v118, v119)
    v2.set_motion(v116, CFrame.new(v116.cframe.Position, v116.cframe.Position + v116.heading), v116.velocity)
end

function v2.snap_face_away_from(v120, v121) -- line 528 | captures: GhostClustersMotion, v2
    local v122 = GhostClustersMotion.flat_unit(v120.cframe.Position - v121)
    v120.heading = v122
    v2.set_motion(v120, CFrame.new(v120.cframe.Position, v120.cframe.Position + v122), v120.velocity)
end

return v2

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersHauntProps
-- Took 0.33s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local load = require(game.ReplicatedStorage.Fsys).load
local FurnitureDB = load("FurnitureDB")
local GhostClustersConstants = require(script.Parent.GhostClustersConstants)
local v1 = {}
local v2 = {}

local function measure_extent(v3) -- line 42 | captures: FurnitureDB, v2
    local v4 = v2[v3]
    if v4 then
        return v4
    end
    local v5, v6 = require(game:GetService("ServerScriptService").new.modules.ContentPacks.ContentPackAssetsServer).get_asset("Furniture", FurnitureDB[v3].model_name):GetBoundingBox()
    local X = v6.X
    local Y = v6.Y
    local Z = v6.Z
    local v7 = math.max(X, Y, Z)
    v2[v3] = v7
    return v7
end

local function tier_for_extent(v8) -- line 56 | captures: GhostClustersConstants
    if v8 <= GhostClustersConstants.PROP_SMALL_MAX_EXTENT then
        return "Small"
    end
    if v8 <= GhostClustersConstants.PROP_MEDIUM_MAX_EXTENT then
        return "Medium"
    end
    return "Large"
end

function v1.read_props(v9) -- line 65 | captures: load, GhostClustersConstants, measure_extent
    local v10 = {}
    for v11, v12 in load("InteriorFurnitureManager").get_interior_data(v9).furniture do
        if not GhostClustersConstants.PROP_KIND_DENYLIST[v12.id] then
            local v13 = measure_extent(v12.id)
            local v14
            if v13 <= GhostClustersConstants.PROP_SMALL_MAX_EXTENT then
                v14 = "Small"
            elseif v13 <= GhostClustersConstants.PROP_MEDIUM_MAX_EXTENT then
                v14 = "Medium"
            else
                v14 = "Large"
            end
            v10[v11] = {
                is_mural = false,
                haunted = false,
                capacity = 0,
                resolved = false,
                flush_progress = 0,
                unique = v11,
                kind = v12.id,
                tier = v14,
                spawn_size = v14,
                cframe = v12.cframe,
                flush_required = GhostClustersConstants.PROP_FLUSH_SEC,
                contributors = {}
            }
        end
    end
    local v15
    for v16, v17 in v10 do
        if v17.kind == GhostClustersConstants.MURAL_FURNITURE_KIND then
            v15 = v17
        end
    end
    for v18, v19 in v10 do
        if v19.tier == "Large" then
            v19.tier = "Medium"
        end
    end
    v15.is_mural = true
    v15.tier = "Large"
    v15.flush_required = GhostClustersConstants.MURAL_FLUSH_SEC
    return v10
end

function v1.assign_haunts(v20) -- line 112 | captures: load, GhostClustersConstants
    local v21 = {}
    for v22 in v20 do
        table.insert(v21, v22)
    end
    table.sort(v21)
    load("TableUtil").shuffle(v21)
    local v23 = #v21 * GhostClustersConstants.HAUNTED_PROP_RATIO + 0.5
    local v24 = math.floor(v23)
    for v25, v26 in v21 do
        local v27 = v20[v26]
        if v27.is_mural or v25 <= v24 then
            v27.haunted = v27.is_mural
            if v27.tier == "Medium" then
                if v27.is_mural then
                    v27.spawn_size = v27.tier
                    v27.capacity = math.random(GhostClustersConstants.PROP_CAPACITY_MAX[v27.tier])
                elseif math.random() < GhostClustersConstants.MEDIUM_PROP_SMALL_NEST_CHANCE then
                    v27.spawn_size = "Small"
                    v27.capacity = GhostClustersConstants.MEDIUM_PROP_SMALL_NEST_COUNT
                else
                    v27.spawn_size = v27.tier
                    v27.capacity = math.random(GhostClustersConstants.PROP_CAPACITY_MAX[v27.tier])
                end
            else
                v27.spawn_size = v27.tier
                v27.capacity = math.random(GhostClustersConstants.PROP_CAPACITY_MAX[v27.tier])
            end
        else
            v27.haunted = false
            v27.capacity = 0
            v27.spawn_size = v27.tier
        end
    end
end

function v1.cast_destinations(v28) -- line 152
    local v29 = {}
    for v30, v31 in v28 do
        if not v31.is_mural and v31.capacity > 0 then
            table.insert(v29, v31)
        end
    end
    table.sort(v29, function(v32, v33) -- line 159
        return v32.unique < v33.unique
    end)
    return v29
end

function v1.snapshot(v34) -- line 165
    local v35 = {}
    for v36, v37 in v34 do
        local v38 = {
            unique = v37.unique,
            kind = v37.kind,
            is_mural = v37.is_mural,
            haunted = v37.haunted,
            resolved = v37.resolved
        }
        table.insert(v35, v38)
    end
    return v35
end

return v1

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersLeaderboard
-- Took 0.35s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerRouter = require(ReplicatedStorage.Fsys).load("ServerRouter")
local v1 = {}
local v2 = {}
local v3 = {}

local function score_count() -- line 22 | captures: v1
    local v4 = 0
    for v5 in v1 do
        v4 += 1
    end
    return v4
end

local function lowest_score() -- line 30 | captures: v1
    local v6
    for v7, v8 in v1 do
        if v6 == nil or v8 < v6 then
            v6 = v8
        end
    end
    return v6
end

function v3.submit_scores(v9) -- line 40 | captures: v1, v2, Players, ServerRouter
    for v10, v11 in v9 do
        local v12 = v1[v10]
        if v12 then
            if v12 < v11 then
                v1[v10] = v11
            end
        else
            local v13
            for v14, v15 in v1 do
                if v13 == nil or v15 < v13 then
                    v13 = v15
                end
            end
            local v16 = 0
            for v17 in v1 do
                v16 += 1
            end
            if v16 < 6 or v13 ~= nil and v13 < v11 then
                v1[v10] = v11
            end
        end
    end
    local v18 = {}
    for v19, v20 in v1 do
        local v21 = Players:GetPlayerByUserId(v19)
        if v21 then
            local v22 = {
                user_id = v19,
                player_name = v21.Name,
                score = v20
            }
            table.insert(v18, v22)
        end
    end
    table.sort(v18, function(v23, v24) -- line 67
        local score = v23.score
        return v24.score < score
    end)
    v2 = {}
    v1 = {}
    local v25 = #v18
    local v26 = math.min(6, v25)
    for v27 = 1, v26 do
        local v28 = v18[v27]
        local v29 = v2
        table.insert(v29, v28)
        v1[v28.user_id] = v28.score
    end
    ServerRouter.get("Halloween2026API/LeaderboardUpdated"):FireAllClients(v2)
end

function v3.get_formatted_data() -- line 82 | captures: v2
    return v2
end

return v3

-- Задампить ServerRouter 

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersLeaderboardClient
-- Took 0.29s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local FormatHelper = load("FormatHelper")
local RouterClient = load("RouterClient")
local v1 = {}

local function populate(v2, v3, v4) -- line 10 | captures: FormatHelper
    for v5, v6 in v2:GetChildren() do
        if v6:IsA("Frame") and v6 ~= v3 then
            v6:Destroy()
        end
    end
    for v7, v8 in v4 or {} do
        local v9 = v3:Clone()
        v9.Visible = true
        v9.Place.Text = tostring(v7)
        v9.DisplayName.Text = v8.player_name
        v9.Score.Text = FormatHelper.add_number_commas(v8.score)
        v9.Parent = v2
    end
end

function v1.render(v10, v11) -- line 27 | captures: RouterClient, populate
    local Frame = v10.Leaderboard.LeaderboardSign.SurfaceGui.Frame
    local LeaderboardEntry = Frame.LeaderboardEntry
    LeaderboardEntry.Visible = false

    local function refresh(v12) -- line 32 | captures: Frame, LeaderboardEntry, populate
        populate(Frame, LeaderboardEntry, v12)
    end

    local v13 = RouterClient.get("Halloween2026API/GetLeaderboardData"):InvokeServer()
    populate(Frame, LeaderboardEntry, v13)
    v11:GiveTask(RouterClient.get("Halloween2026API/LeaderboardUpdated").OnClientEvent:Connect(refresh))
end

return v1

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersVacuumHelper
-- Took 0.86s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local GuiService = game:GetService("GuiService")
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local load = require(ReplicatedStorage.Fsys).load
local Maid = load("Maid")
local v1 = load("package:Promise")
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local GhostClustersClientConstants = require(script.Parent.GhostClustersClientConstants)
local GhostClustersConstants = require(script.Parent.GhostClustersConstants)
local GhostClustersGhostRenderer = require(script.Parent.GhostClustersGhostRenderer)
local GhostClustersGhosts = require(script.Parent.GhostClustersGhosts)
local GhostClustersPropRenderer = require(script.Parent.GhostClustersPropRenderer)
local GhostClustersVacuumDynamics = require(script.Parent.GhostClustersVacuumDynamics)
local GhostVacuumGunFx = require(script.Parent.GhostVacuumGunFx)

local function uses_auto_aim_vacuum() -- line 22 | captures: RunService, load
    if RunService:IsClient() then
        local PlatformM = load("PlatformM")
        local v2 = PlatformM.get_platform()
        if v2 ~= PlatformM.platform.phone and v2 ~= PlatformM.platform.tablet and v2 ~= PlatformM.platform.console then
            return PlatformM.is_using_gamepad()
        end
        return true
    end
    return false
end

local function is_local_player_ragdolled() -- line 40 | captures: Players, GhostClustersConstants
    local Character = Players.LocalPlayer.Character
    local v3 = Character and Character:FindFirstChild("Humanoid")
    if v3 and v3:IsA("Humanoid") then
        return GhostClustersConstants.is_vacuum_ragdolled(v3)
    end
    return false
end

local v4 = Color3.fromRGB(110, 255, 225)
local v5 = Color3.fromRGB(235, 255, 250)
local v6 = {}

local function is_eligible(v7) -- line 97
    return v7.distance <= v7.max_distance
end

local function aim_cone_px(v8, v9) -- line 101 | captures: GhostClustersConstants
    local v10 = if v9 then GhostClustersConstants.VACUUM_AIM_CONE_TOUCH_FRAC else GhostClustersConstants.VACUUM_AIM_CONE_VIEWPORT_FRAC
    return v8 * v10
end

local function is_aimed(v11, v12) -- line 110
    local screen_offset = v11.screen_offset
    if screen_offset ~= nil and screen_offset <= v12 then
        return v11.distance <= v11.max_distance
    end
    return false
end

local function select_best_aimed(v13, v14, v15) -- line 117
    local v16
    local v17 = (1/0)
    local v18 = (1/0)
    for v19, v20 in v13 do
        if v20.size == "Prop" == v15 then
            local screen_offset = v20.screen_offset
            if screen_offset ~= nil and screen_offset <= v14 and v20.distance <= v20.max_distance then
                local screen_offset = v20.screen_offset
                if screen_offset < v17 or screen_offset == v17 and v20.distance < v18 then
                    v18 = v20.distance
                    v16 = v20
                    v17 = screen_offset
                end
            end
        end
    end
    return v16
end

local function make_raycast_params(v21, v22) -- line 135
    local v23 = RaycastParams.new()
    v23.FilterType = v21
    v23.FilterDescendantsInstances = v22
    return v23
end

local raycast_visible = GhostVacuumGunFx.raycast_visible

local function for_each_beam(v24, v25) -- line 144
    for v26, v27 in v24:GetChildren() do
        if v27:IsA("Beam") then
            v25(v27)
        end
    end
end

local function style_highlight(v28, v29, v30, v31) -- line 152 | captures: v4, v5
    v28.DepthMode = v31
    v28.FillColor = v4
    v28.FillTransparency = v29
    v28.OutlineColor = v5
    v28.OutlineTransparency = v30
end

local function ghost_max_distance(v32) -- line 165 | captures: GhostClustersConstants, GhostClustersGhostRenderer
    local v33 = GhostClustersGhostRenderer.get_large_position() ~= nil
    return GhostClustersConstants.ghost_vacuum_range(v32, v33) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
end

local function prop_max_distance(v34) -- line 170 | captures: GhostClustersConstants
    return GhostClustersConstants.prop_vacuum_range(v34) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
end

local function play_fx(v35, v36) -- line 174 | captures: SoundPlayer
    if SoundPlayer.FX:get_source_sound(v35) then
        SoundPlayer.FX:play(v35, v36)
    end
end

local function loop_fx(v37, v38) -- line 180 | captures: SoundPlayer
    local v39 = SoundPlayer.FX:get_source_sound(v37)
    local v40, v41
    if v39 then
        v40 = SoundPlayer.FX:loop(v37, v38)
        v41 = typeof(v40) == "boolean"
    end
    if not v39 or v41 then
        return nil
    end
    return v40
end

function v6.get_aim_screen_point(v42, v43) -- line 194 | captures: GuiService, UserInputService
    if v43 then
        return v43
    end
    if v42 then
        return Vector2.new(v42.Position.X, v42.Position.Y) + GuiService:GetGuiInset()
    end
    return UserInputService:GetMouseLocation()
end

local function is_shielded_boss(v44) -- line 204 | captures: GhostClustersConstants
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    if v44:GetAttribute(GHOST_ATTR.Size) == "Large" then
        return v44:GetAttribute(GHOST_ATTR.Shielded) == true
    end
    return false
end

local function ghost_models() -- line 209 | captures: GhostClustersConstants
    local v45 = {}
    for v46, v47 in workspace[GhostClustersConstants.VISUAL_FOLDER_NAME]:GetChildren() do
        if v47:IsA("Model") and v47:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id) then
            local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
            if not (v47:GetAttribute(GHOST_ATTR.Size) == "Large" and v47:GetAttribute(GHOST_ATTR.Shielded) == true) then
                table.insert(v45, v47)
            end
        end
    end
    return v45
end

local function get_gameplay_position(v48) -- line 224 | captures: GhostClustersConstants, GhostClustersGhostRenderer
    local v49 = v48:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
    local v50 = GhostClustersGhostRenderer.get_gameplay_cframe(v49)
    if v50 then
        return v50.Position
    end
    return v48:GetPivot().Position
end

local function get_ghost_geometry(v51, v52) -- line 233 | captures: GhostClustersConstants, GhostClustersGhostRenderer
    local v53 = { root = v51.RootPart }
    local flat_distance = GhostClustersConstants.flat_distance
    local v54 = v51:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
    local v55 = GhostClustersGhostRenderer.get_gameplay_cframe(v54)
    local v56 = if v55 then v55.Position else v51:GetPivot().Position
    v53.distance = flat_distance(v52, v56)
    return v53
end

local function get_prop_geometry(v57, v58) -- line 242 | captures: GhostClustersConstants
    local PlacementBlock = v57.PlacementBlock
    return {
        root = PlacementBlock,
        distance = GhostClustersConstants.flat_distance(v58, PlacementBlock.Position)
    }
end

local function build_ghost_candidate(v59, v60) -- line 250 | captures: GhostClustersConstants, GhostClustersGhostRenderer
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    local v61 = v59:GetAttribute(GHOST_ATTR.Size)
    local v62 = { root = v59.RootPart }
    local flat_distance = GhostClustersConstants.flat_distance
    local v63 = v59:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
    local v64 = GhostClustersGhostRenderer.get_gameplay_cframe(v63)
    local v65 = if v64 then v64.Position else v59:GetPivot().Position
    v62.distance = flat_distance(v60, v65)
    local v66 = {
        id = v59:GetAttribute(GHOST_ATTR.Id),
        size = v61,
        distance = v62.distance
    }
    local v67 = GhostClustersGhostRenderer.get_large_position() ~= nil
    v66.max_distance = GhostClustersConstants.ghost_vacuum_range(v61, v67) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
    return v66
end

local function build_prop_candidate(v68, v69) -- line 262 | captures: GhostClustersConstants
    local PlacementBlock = v68.model.PlacementBlock
    local v70 = {
        root = PlacementBlock,
        distance = GhostClustersConstants.flat_distance(v69, PlacementBlock.Position)
    }
    local v71 = {
        size = "Prop",
        id = v68.unique,
        distance = v70.distance
    }
    local is_mural = v68.is_mural
    v71.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
    return v71
end

local function ghost_target(v72, v73) -- line 272 | captures: GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersGhosts
    local v74 = v72:GetAttribute(GhostClustersConstants.GHOST_ATTR.Size)
    local v75 = {
        is_prop = false,
        is_mural = false,
        id = v73,
        model = v72,
        size = v74
    }
    local v76 = GhostClustersGhostRenderer.get_large_position() ~= nil
    v75.max_distance = GhostClustersConstants.ghost_vacuum_range(v74, v76) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
    v75.beam_anchor = GhostClustersGhosts.beam_anchor(v72)
    return v75
end

local function prop_target(v77) -- line 285 | captures: GhostClustersConstants
    local v78 = {
        is_prop = true,
        size = "Prop",
        id = v77.unique,
        model = v77.model,
        is_mural = v77.is_mural
    }
    local is_mural = v77.is_mural
    v78.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
    v78.beam_anchor = v77.model.PlacementBlock
    return v78
end

local function target_root(v79) -- line 297
    if v79.is_prop then
        return v79.model.PlacementBlock
    end
    return v79.model.RootPart
end

local function los_exclude_list(v80) -- line 304 | captures: Players, GhostClustersConstants
    local v81 = {}
    local Character = Players.LocalPlayer.Character
    if Character then
        table.insert(v81, Character)
    end
    local v82 = workspace:FindFirstChild(GhostClustersConstants.VISUAL_FOLDER_NAME)
    if v82 then
        table.insert(v81, v82)
    end
    local v83 = workspace:FindFirstChild(GhostClustersConstants.LIVE_FOLDER_NAME)
    if v83 then
        table.insert(v81, v83)
    end
    local Pets = workspace.Pets
    table.insert(v81, Pets)
    local PetObjects = workspace.PetObjects
    table.insert(v81, PetObjects)
    if v80 then
        for v84, v85 in v80 do
            table.insert(v81, v85)
        end
    end
    return v81
end

local function is_furniture_obstructed(v86, v87) -- line 332 | captures: raycast_visible, los_exclude_list
    local v88, v89 = v87:GetBoundingBox()
    local v90 = v88.Position - v86
    local Magnitude = v90.Magnitude
    if not (Magnitude < 0.05) then
        local Exclude = Enum.RaycastFilterType.Exclude
        local v91 = los_exclude_list({ v87 })
        local v92 = RaycastParams.new()
        v92.FilterType = Exclude
        v92.FilterDescendantsInstances = v91
        local v93, v94 = raycast_visible(v86, v90, v92)
        if v93 then
            local v95 = Magnitude - v94
            local X = v89.X
            local Y = v89.Y
            local Z = v89.Z
            return math.max(X, Y, Z) * 0.5 + 4 < v95
        end
    end
    return false
end

local function root_of(v96, v97) -- line 353
    local v98 = v96
    local v99
    while true do
        if v98 then
            v99 = v97[v98]
            if v99 then
                break
            end
            v98 = v98.Parent
            continue
        end
        return nil
    end
    return v99
end

local function stream_range() -- line 366 | captures: GhostClustersClientConstants, GhostClustersConstants, GhostClustersGhostRenderer
    if GhostClustersGhostRenderer.get_large_position() then
        return GhostClustersConstants.VACUUM_RANGE.Large
    end
    return GhostClustersClientConstants.VACUUM_STREAM_RANGE
end

local function muzzle_drop(v100, v101) -- line 377 | captures: GhostClustersClientConstants, raycast_visible
    local v102 = raycast_visible(v100, Vector3.new(-0, -60, -0, -0), v101)
    if v102 then
        return v100.Y - v102.Position.Y
    end
    return GhostClustersClientConstants.VACUUM_STREAM_FALLBACK_DROP
end

local function stream_landing(v103, v104) -- line 388 | captures: GhostClustersClientConstants, GhostClustersConstants, GhostClustersGhostRenderer, raycast_visible, los_exclude_list
    local v105 = if GhostClustersGhostRenderer.get_large_position() then GhostClustersConstants.VACUUM_RANGE.Large else GhostClustersClientConstants.VACUUM_STREAM_RANGE
    local Exclude = Enum.RaycastFilterType.Exclude
    local v106 = los_exclude_list()
    local v107 = RaycastParams.new()
    v107.FilterType = Exclude
    v107.FilterDescendantsInstances = v106
    local X = v104.X
    local Z = v104.Z
    local v108 = Vector3.new(X, 0, Z)
    local Magnitude = v108.Magnitude
    if Magnitude < 0.001 then
        local v109 = raycast_visible(v103, v104 * v105, v107)
        local v110 = if v109 then v109.Position else v103 + v104 * v105
        return v110, v103 + (v110 - v103) * 0.5
    end
    local v111 = v108 / Magnitude
    local VACUUM_STREAM_MAX_SLOPE = GhostClustersClientConstants.VACUUM_STREAM_MAX_SLOPE
    local v112 = v104.Y / Magnitude
    local v113 = -VACUUM_STREAM_MAX_SLOPE
    local v114 = math.clamp(v112, v113, VACUUM_STREAM_MAX_SLOPE)
    local stream_curvature = GhostClustersClientConstants.stream_curvature
    local v115 = raycast_visible(v103, Vector3.new(-0, -60, -0, -0), v107)
    local v116 = if v115 then v103.Y - v115.Position.Y else GhostClustersClientConstants.VACUUM_STREAM_FALLBACK_DROP
    local v117 = stream_curvature(v114, v116, v105)

    local function control_at(v118) -- line 408 | captures: v103, v111, v114
        return v103 + v111 * (v118 * 0.5) + Vector3.new(0, 1, 0) * (v114 * v118 * 0.5)
    end

    local VACUUM_STREAM_SEGMENTS = GhostClustersClientConstants.VACUUM_STREAM_SEGMENTS
    local v119 = v103
    for v120 = 1, VACUUM_STREAM_SEGMENTS do
        local v121 = v105 * v120 / VACUUM_STREAM_SEGMENTS
        local v122 = GhostClustersClientConstants.stream_point(v103, v111, v114, v117, v121)
        local v123 = raycast_visible(v119, v122 - v119, v107)
        if v123 then
            return v123.Position, v103 + v111 * (v121 * 0.5) + Vector3.new(0, 1, 0) * (v114 * v121 * 0.5)
        end
        v119 = v122
    end
    return v119, v103 + v111 * (v105 * 0.5) + Vector3.new(0, 1, 0) * (v114 * v105 * 0.5)
end

local function aim_raycast(v124, v125) -- line 426 | captures: GhostClustersPropRenderer, raycast_visible, ghost_models, los_exclude_list
    local v126 = v125:ViewportPointToRay(v124.X, v124.Y)
    local v127 = v126.Direction * 500
    local v128 = v126.Origin + v127
    local Exclude = Enum.RaycastFilterType.Exclude
    local v129 = los_exclude_list()
    local v130 = RaycastParams.new()
    v130.FilterType = Exclude
    v130.FilterDescendantsInstances = v129
    local v131, v132 = raycast_visible(v126.Origin, v127, v130)
    local v133 = {}
    local v134 = {}
    local v135 = {}
    for v136, v137 in ghost_models() do
        table.insert(v133, v137)
        v134[v137] = v137
        v135[v137] = true
    end
    for v138, v139 in GhostClustersPropRenderer.get_targets() do
        local model = v139.model
        table.insert(v133, model)
        v134[v139.model] = v139.model
    end
    local v140, v141
    if #v133 > 0 then
        local Include = Enum.RaycastFilterType.Include
        local v142 = RaycastParams.new()
        v142.FilterType = Include
        v142.FilterDescendantsInstances = v133
        local Origin = v126.Origin
        local v143
        v140, v143 = raycast_visible(Origin, v127, v142, function(v144) -- line 449 | captures: v134, v135
            local v145 = v144
            local v146
            while true do
                if v145 then
                    local v147 = v134[v145]
                    if v147 then
                        v146 = v147
                        break
                    end
                    v145 = v145.Parent
                    continue
                end
                v146 = nil
                break
            end
            if v146 == nil then
                return false
            end
            return v135[v146] == true
        end)
        if v140 then
            if v131 then
                v141 = not (v143 <= v132 + 4)
            else
                v141 = false
            end
        else
            v141 = true
        end
    else
        v141 = true
    end
    if not v141 then
        local v148 = v140.Instance
        local v149
        while true do
            if v148 then
                local v150 = v134[v148]
                if v150 then
                    v149 = v150
                    break
                end
                v148 = v148.Parent
                continue
            end
            v149 = nil
            break
        end
        return v149, v140.Position
    end
    if v131 then
        local v151 = v131.Instance
        local v152
        while true do
            if v151 then
                local v153 = v134[v151]
                if v153 then
                    v152 = v153
                    break
                end
                v151 = v151.Parent
                continue
            end
            v152 = nil
            break
        end
        return v152, v131.Position
    end
    return nil, v128
end

local function annotate_screen_offsets(v154, v155, v156, v157, v158) -- line 463 | captures: GhostClustersGhosts
    for v159, v160 in v154 do
        local v161 = v156[v160.id]
        local v162
        if v161 then
            v162 = v161.model.PlacementBlock.Position
        else
            local v163 = v155[v160.id]
            v162 = GhostClustersGhosts.anchor_world_position(GhostClustersGhosts.beam_anchor(v163))
        end
        local v164 = v157:WorldToViewportPoint(v162)
        if v164.Z > 0 then
            v160.screen_offset = (Vector2.new(v164.X, v164.Y) - v158).Magnitude
        end
    end
end

local function gather_candidates(v165) -- line 489 | captures: GhostClustersConstants, GhostClustersPropRenderer, ghost_models, build_ghost_candidate, is_furniture_obstructed
    local v166 = {}
    local v167 = {}
    local v168 = {}
    for v169, v170 in ghost_models() do
        if v170:GetAttribute(GhostClustersConstants.GHOST_ATTR.Orbiting) ~= true then
            local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
            if not (v170:GetAttribute(GHOST_ATTR.Size) == "Large" and v170:GetAttribute(GHOST_ATTR.Shielded) == true) then
                local v171 = build_ghost_candidate(v170, v165)
                table.insert(v166, v171)
                v167[v171.id] = v170
            end
        end
    end
    for v172, v173 in GhostClustersPropRenderer.get_targets() do
        if not is_furniture_obstructed(v165, v173.model) then
            v168[v173.unique] = v173
            local PlacementBlock = v173.model.PlacementBlock
            local v174 = {
                root = PlacementBlock,
                distance = GhostClustersConstants.flat_distance(v165, PlacementBlock.Position)
            }
            local v175 = {
                size = "Prop",
                id = v173.unique,
                distance = v174.distance
            }
            local is_mural = v173.is_mural
            v175.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
            table.insert(v166, v175)
        end
    end
    return v166, v167, v168
end

local function target_from_candidate(v176, v177, v178) -- line 513 | captures: GhostClustersConstants, GhostClustersGhostRenderer, ghost_target
    local v179 = v178[v176.id]
    if v179 then
        local v180 = {
            is_prop = true,
            size = "Prop",
            id = v179.unique,
            model = v179.model,
            is_mural = v179.is_mural
        }
        local is_mural = v179.is_mural
        v180.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
        v180.beam_anchor = v179.model.PlacementBlock
        return v180
    end
    local v181 = GhostClustersGhostRenderer.get_visual(v176.id)
    if v181 then
        return (ghost_target(v181, v176.id))
    end
    return (ghost_target(v177[v176.id], v176.id))
end

local function candidate_model(v182, v183, v184) -- line 529 | captures: GhostClustersGhostRenderer
    local v185 = v184[v182.id]
    if v185 then
        return v185.model
    end
    return GhostClustersGhostRenderer.get_visual(v182.id) or v183[v182.id]
end

local function select_auto_target(v186, v187, v188, v189) -- line 544 | captures: GhostClustersConstants, GhostClustersGhostRenderer, ghost_target
    local function nearest(v190) -- line 550 | captures: v186, v187, v188, v189, GhostClustersConstants, GhostClustersGhostRenderer
        local v191
        local v192 = (1/0)
        for v193, v194 in v186 do
            local v195 = v188[v194.id] ~= nil
            if v195 == v190 and v194.distance <= v194.max_distance then
                local Position
                if v195 then
                    Position = v188[v194.id].model.PlacementBlock.Position
                else
                    local v196 = v187[v194.id]
                    local v197 = v196:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
                    local v198 = GhostClustersGhostRenderer.get_gameplay_cframe(v197)
                    if v198 then
                        Position = v198.Position
                    else
                        Position = v196:GetPivot().Position
                    end
                end
                local v199, v200 = v189:WorldToViewportPoint(Position)
                if v200 and v194.distance < v192 then
                    v191, v192 = v194, v194.distance
                end
            end
        end
        return v191
    end

    local v201 = nearest(false) or nearest(true)
    if v201 then
        local v202 = v188[v201.id]
        if v202 then
            local v203 = {
                is_prop = true,
                size = "Prop",
                id = v202.unique,
                model = v202.model,
                is_mural = v202.is_mural
            }
            local is_mural = v202.is_mural
            v203.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
            v203.beam_anchor = v202.model.PlacementBlock
            return v203
        end
        local v204 = GhostClustersGhostRenderer.get_visual(v201.id)
        if v204 then
            return (ghost_target(v204, v201.id))
        end
        return (ghost_target(v187[v201.id], v201.id))
    end
    return nil
end

local function screen_silhouette_distance(v205, v206, v207) -- line 579
    local v208, v209 = v205:GetBoundingBox()
    local v210 = v209 * 0.5
    local v211 = (1/0)
    local v212 = (1/0)
    local v213 = (-1/0)
    local v214 = (-1/0)
    local v215 = false
    for v216, v217 in { -1, 1 } do
        local v218 = v211
        local v219 = v212
        local v220 = v213
        local v221 = v214
        local v222 = v215
        for v223, v224 in { -1, 1 } do
            local v225 = v218
            local v226 = v219
            local v227 = v220
            local v228 = v221
            local v229 = v222
            for v230, v231 in { -1, 1 } do
                local v232 = v217 * v210.X
                local v233 = v224 * v210.Y
                local v234 = v231 * v210.Z
                local v235 = v206:WorldToViewportPoint((v208:PointToWorldSpace((Vector3.new(v232, v233, v234)))))
                if v235.Z > 0 then
                    local X = v235.X
                    v225 = math.min(v225, X)
                    local Y = v235.Y
                    v226 = math.min(v226, Y)
                    local X_2 = v235.X
                    v227 = math.max(v227, X_2)
                    local Y_2 = v235.Y
                    v228 = math.max(v228, Y_2)
                    v229 = true
                end
                v218 = v225
                v219 = v226
                v220 = v227
                v221 = v228
                v222 = v229
            end
            v211 = v218
            v212 = v219
            v213 = v220
            v214 = v221
            v215 = v222
        end
    end
    if v215 then
        local v236 = v211 - v207.X
        local v237 = v207.X - v213
        local v238 = math.max(v236, 0, v237)
        local v239 = v212 - v207.Y
        local v240 = v207.Y - v214
        local v241 = math.max(v239, 0, v240)
        local v242 = v238 * v238 + v241 * v241
        return (math.sqrt(v242))
    end
    return nil
end

local function select_screen_silhouette(v243, v244, v245, v246, v247, v248, v249) -- line 608 | captures: GhostClustersGhostRenderer, screen_silhouette_distance
    local v250
    local v251 = (1/0)
    local v252 = (1/0)
    for v253, v254 in v243 do
        if v254.size == "Prop" == v249 and v254.distance <= v254.max_distance then
            local v255 = v245[v254.id]
            local v256 = if v255 then v255.model else GhostClustersGhostRenderer.get_visual(v254.id) or v244[v254.id]
            local v257 = screen_silhouette_distance(v256, v246, v247)
            if v257 and v257 <= v248 and (v257 < v251 or v257 == v251 and v254.distance < v252) then
                v252 = v254.distance
                v250 = v254
                v251 = v257
            end
        end
    end
    return v250
end

local function pick_target(v258, v259, v260, v261, v262) -- line 637 | captures: UserInputService, GhostClustersConstants, GhostClustersGhostRenderer, select_best_aimed, ghost_target, aim_raycast, annotate_screen_offsets, select_screen_silhouette
    local v263, v264 = aim_raycast(v261, v262)
    if v263 then
        local v265 = v263:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id) or v263:GetAttribute("furniture_unique")
        if typeof(v265) == "string" then
            for v266, v267 in v258 do
                if v267.id == v265 and v267.distance <= v267.max_distance then
                    local v268 = v260[v267.id]
                    local v269
                    if v268 then
                        v269 = {
                            is_prop = true,
                            size = "Prop",
                            id = v268.unique,
                            model = v268.model,
                            is_mural = v268.is_mural
                        }
                        local is_mural = v268.is_mural
                        v269.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
                        v269.beam_anchor = v268.model.PlacementBlock
                    else
                        local v270 = GhostClustersGhostRenderer.get_visual(v267.id)
                        if v270 then
                            v269 = ghost_target(v270, v267.id)
                        else
                            v269 = ghost_target(v259[v267.id], v267.id)
                        end
                    end
                    return v269, v264
                end
            end
        end
    end
    annotate_screen_offsets(v258, v259, v260, v262, v261)
    local TouchEnabled = UserInputService.TouchEnabled
    local v271 = if TouchEnabled then 36 else 8
    local v272 = select_screen_silhouette(v258, v259, v260, v262, v261, v271, false) or select_screen_silhouette(v258, v259, v260, v262, v261, v271, true)
    local Y = v262.ViewportSize.Y
    local v273 = if TouchEnabled then GhostClustersConstants.VACUUM_AIM_CONE_TOUCH_FRAC else GhostClustersConstants.VACUUM_AIM_CONE_VIEWPORT_FRAC
    local v274 = Y * v273
    v272 = v272 or select_best_aimed(v258, v274, false) or select_best_aimed(v258, v274, true)
    if v272 then
        local v275 = v260[v272.id]
        local v276
        if v275 then
            v276 = {
                is_prop = true,
                size = "Prop",
                id = v275.unique,
                model = v275.model,
                is_mural = v275.is_mural
            }
            local is_mural = v275.is_mural
            v276.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
            v276.beam_anchor = v275.model.PlacementBlock
        else
            local v277 = GhostClustersGhostRenderer.get_visual(v272.id)
            if v277 then
                v276 = ghost_target(v277, v272.id)
            else
                v276 = ghost_target(v259[v272.id], v272.id)
            end
        end
        return v276, v264
    end
    return nil, v264
end

local function survey(v278, v279, v280) -- line 681 | captures: GhostClustersConstants, GhostClustersGhostRenderer, gather_candidates, pick_target
    local v281, v282, v283 = gather_candidates(v278)
    local v284, v285 = pick_target(v281, v282, v283, v279, v280)
    local v286 = {}
    for v287, v288 in v281 do
        if v288.distance <= v288.max_distance then
            table.insert(v286, v288)
        end
    end
    table.sort(v286, function(v289, v290) -- line 691
        return v289.distance < v290.distance
    end)
    local v291 = {}
    for v292, v293 in v286 do
        if GhostClustersConstants.VACUUM_NEARBY_HIGHLIGHT_MAX < v292 then
            break
        end
        local v294 = v283[v293.id]
        local v295 = if v294 then v294.model else GhostClustersGhostRenderer.get_visual(v293.id) or v282[v293.id]
        table.insert(v291, v295)
    end
    return v284, v285, v291
end

local function nearest_visible_target(v296, v297) -- line 705 | captures: GhostClustersConstants, GhostClustersGhostRenderer, ghost_target, gather_candidates
    local v298, v299, v300 = gather_candidates(v296)

    local function nearest(v301) -- line 550 | captures: v297, v298, v299, v300, GhostClustersConstants, GhostClustersGhostRenderer
        local v302
        local v303 = (1/0)
        for v304, v305 in v298 do
            local v306 = v300[v305.id] ~= nil
            if v306 == v301 and v305.distance <= v305.max_distance then
                local Position
                if v306 then
                    Position = v300[v305.id].model.PlacementBlock.Position
                else
                    local v307 = v299[v305.id]
                    local v308 = v307:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
                    local v309 = GhostClustersGhostRenderer.get_gameplay_cframe(v308)
                    if v309 then
                        Position = v309.Position
                    else
                        Position = v307:GetPivot().Position
                    end
                end
                local v310, v311 = v297:WorldToViewportPoint(Position)
                if v311 and v305.distance < v303 then
                    v302, v303 = v305, v305.distance
                end
            end
        end
        return v302
    end

    local v312 = nearest(false) or nearest(true)
    if v312 then
        local v313 = v300[v312.id]
        if v313 then
            local v314 = {
                is_prop = true,
                size = "Prop",
                id = v313.unique,
                model = v313.model,
                is_mural = v313.is_mural
            }
            local is_mural = v313.is_mural
            v314.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
            v314.beam_anchor = v313.model.PlacementBlock
            return v314
        end
        local v315 = GhostClustersGhostRenderer.get_visual(v312.id)
        if v315 then
            return (ghost_target(v315, v312.id))
        end
        return (ghost_target(v299[v312.id], v312.id))
    end
    return nil
end

function v6.create_minigame_session() -- line 710 | captures: load, GhostClustersConstants, v6
    local RouterClient = load("RouterClient")

    local function message_server(v316, v317) -- line 712 | captures: RouterClient, load, GhostClustersConstants
        local instanced_minigame = load("MinigameClientManager").get(GhostClustersConstants.MINIGAME_ID).instanced_minigame
        if instanced_minigame then
            RouterClient.get("MinigameAPI/MessageServer"):FireServer(instanced_minigame.minigame_id, v316, v317)
        end
    end

    local create_session = v6.create_session
    local v318 = {}

    function v318.start_contribute(v319, v320) -- line 721 | captures: RouterClient, load, GhostClustersConstants
        local v321 = {
            ghost_id = v319,
            use_token = v320
        }
        local instanced_minigame = load("MinigameClientManager").get(GhostClustersConstants.MINIGAME_ID).instanced_minigame
        if instanced_minigame then
            RouterClient.get("MinigameAPI/MessageServer"):FireServer(instanced_minigame.minigame_id, "start_contribute", v321)
        end
    end

    function v318.stop_contribute(v322, v323) -- line 727 | captures: RouterClient, load, GhostClustersConstants
        local v324 = {
            ghost_id = v322,
            use_token = v323
        }
        local instanced_minigame = load("MinigameClientManager").get(GhostClustersConstants.MINIGAME_ID).instanced_minigame
        if instanced_minigame then
            RouterClient.get("MinigameAPI/MessageServer"):FireServer(instanced_minigame.minigame_id, "stop_contribute", v324)
        end
    end

    function v318.start_prop_contribute(v325, v326) -- line 733 | captures: RouterClient, load, GhostClustersConstants
        local v327 = {
            unique = v325,
            use_token = v326
        }
        local instanced_minigame = load("MinigameClientManager").get(GhostClustersConstants.MINIGAME_ID).instanced_minigame
        if instanced_minigame then
            RouterClient.get("MinigameAPI/MessageServer"):FireServer(instanced_minigame.minigame_id, "start_prop_contribute", v327)
        end
    end

    function v318.stop_prop_contribute(v328, v329) -- line 739 | captures: RouterClient, load, GhostClustersConstants
        local v330 = {
            unique = v328,
            use_token = v329
        }
        local instanced_minigame = load("MinigameClientManager").get(GhostClustersConstants.MINIGAME_ID).instanced_minigame
        if instanced_minigame then
            RouterClient.get("MinigameAPI/MessageServer"):FireServer(instanced_minigame.minigame_id, "stop_prop_contribute", v330)
        end
    end

    return create_session(v318)
end

function v6.attach_tool_session(v331) -- line 748 | captures: v6
    if v331.ghost_clusters_session then
        v331.ghost_clusters_session:unequip()
        v331.ghost_clusters_session = nil
    end
    local v332 = v6.create_minigame_session()
    v332:equip(v331)
    v331.ghost_clusters_session = v332
end

function v6.create_session(v333) -- line 758 | captures: HttpService, Players, RunService, SoundService, UserInputService, load, Maid, v1, SoundPlayer, GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer, GhostClustersVacuumDynamics, GhostVacuumGunFx, uses_auto_aim_vacuum, v4, v5, v6, for_each_beam, ghost_target, is_furniture_obstructed, stream_landing, gather_candidates, survey
    local MinigameForcedState = load("MinigameForcedState")
    local v334 = {
        tool_wrapper = nil,
        beam_part = nil,
        fx = nil,
        align = nil,
        align_attachment = nil,
        reaction_force = nil,
        target = nil,
        use_token = nil,
        aim_screen_point = Vector2.zero,
        aim_input = nil,
        aim_mode = "cursor",
        drag_aim_point = nil,
        next_drag_survey_at = 0,
        cached_auto_target = nil,
        next_keepalive_at = 0,
        reacquire_at = 0,
        loop_sound = nil,
        pull_sound = nil,
        pull_progress = 0,
        pull_progress_at = 0,
        target_highlight = nil,
        hover_highlight = nil,
        nearby_highlights = {},
        next_highlight_refresh_at = 0,
        miss_attachment = nil,
        active_light = nil,
        humanoid = nil,
        original_auto_rotate = nil,
        original_walk_speed = nil,
        movement_buff_active = false,
        sucking = false,
        maid = Maid.new(),
        use_maid = Maid.new()
    }

    local function local_hrp() -- line 801 | captures: Players
        local Character = Players.LocalPlayer.Character
        local v335 = Character and Character:FindFirstChild("HumanoidRootPart")
        if v335 and v335:IsA("BasePart") then
            return v335
        end
        return nil
    end

    local function stop_loop_sound() -- line 810 | captures: v334
        if v334.loop_sound then
            v334.loop_sound:Stop()
            v334.loop_sound = nil
        end
    end

    local function stop_pull_sound() -- line 817 | captures: v334
        if v334.pull_sound then
            v334.pull_sound:Stop()
            v334.pull_sound = nil
        end
    end

    local function stop_reaction_force() -- line 824 | captures: v334
        if v334.reaction_force then
            v334.reaction_force.Force = Vector3.new(0, 0, 0)
            v334.reaction_force.Enabled = false
        end
    end

    local function plant_movement() -- line 833 | captures: MinigameForcedState, v334, GhostClustersConstants
        local humanoid = v334.humanoid
        if not (humanoid and v334.original_walk_speed == nil) then
            return
        end
        v334.original_walk_speed = humanoid.WalkSpeed
        local v336 = v334.original_walk_speed * GhostClustersConstants.VACUUM_PLANTED_WALK_SPEED_SCALE
        if MinigameForcedState.is_enabled() then
            MinigameForcedState.set_buff("GhostClustersVacuumPlant", {
                priority = 100,
                walk_speed = v336
            })
            v334.movement_buff_active = true
        else
            humanoid.WalkSpeed = v336
        end
    end

    local function restore_movement() -- line 851 | captures: MinigameForcedState, v334
        local humanoid = v334.humanoid
        if v334.movement_buff_active then
            MinigameForcedState.remove_buff("GhostClustersVacuumPlant")
            v334.movement_buff_active = false
        elseif humanoid and v334.original_walk_speed ~= nil then
            humanoid.WalkSpeed = v334.original_walk_speed
        end
        v334.original_walk_speed = nil
    end

    local function update_reaction_force(v337, v338) -- line 862 | captures: v334, GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersVacuumDynamics
        local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
        local reaction_acceleration = GhostClustersVacuumDynamics.reaction_acceleration
        local v339 = {
            size = v337:GetAttribute(GHOST_ATTR.Size),
            player_position = v338.Position,
            player_velocity = v338.AssemblyLinearVelocity
        }
        local v340 = v337:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
        local v341 = GhostClustersGhostRenderer.get_gameplay_cframe(v340)
        if v341 then
            v339.ghost_position = v341.Position
        else
            v339.ghost_position = v337:GetPivot().Position
        end
        v339.resistance_phase = workspace:GetServerTimeNow() * GhostClustersConstants.VACUUM_RESISTANCE_FREQUENCY + v337:GetAttribute(GHOST_ATTR.MoveSeed)
        local v342 = reaction_acceleration(v339)
        v334.reaction_force.Force = v342 * v338.AssemblyMass
        v334.reaction_force.Enabled = true
    end

    local function set_beam_attached(v343) -- line 876 | captures: v334
        if v334.fx then
            if v343 then
                v334.fx:hold_on(v343)
            else
                v334.fx:release()
            end
        end
    end

    local function apply_highlight(v344, v345, v346) -- line 887 | captures: v4, v5
        if v344 then
            v344:Destroy()
        end
        if v345 then
            local Highlight = Instance.new("Highlight")
            Highlight.Name = "GhostVacuumTarget"
            Highlight.Adornee = v345
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = v4
            Highlight.FillTransparency = v346
            Highlight.OutlineColor = v5
            Highlight.OutlineTransparency = 0.15
            Highlight.Parent = v345
            return Highlight
        end
        return nil
    end

    local function set_target_highlight(v347) -- line 902 | captures: v334, v4, v5
        local target_highlight = v334.target_highlight
        if target_highlight then
            target_highlight:Destroy()
        end
        local Highlight
        if v347 then
            Highlight = Instance.new("Highlight")
            Highlight.Name = "GhostVacuumTarget"
            Highlight.Adornee = v347
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = v4
            Highlight.FillTransparency = 0.2
            Highlight.OutlineColor = v5
            Highlight.OutlineTransparency = 0.15
            Highlight.Parent = v347
        end
        v334.target_highlight = Highlight
        if v334.target_highlight then
            v334.target_highlight.OutlineTransparency = 0
        end
    end

    local function set_hover_highlight(v348) -- line 909 | captures: v334, v4, v5
        local hover_highlight = v334.hover_highlight
        if hover_highlight and hover_highlight.Parent and hover_highlight.Adornee == v348 then
            return
        end
        if hover_highlight then
            hover_highlight:Destroy()
        end
        local Highlight
        if v348 then
            Highlight = Instance.new("Highlight")
            Highlight.Name = "GhostVacuumTarget"
            Highlight.Adornee = v348
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = v4
            Highlight.FillTransparency = 0.55
            Highlight.OutlineColor = v5
            Highlight.OutlineTransparency = 0.15
            Highlight.Parent = v348
        end
        v334.hover_highlight = Highlight
    end

    local function set_nearby_highlights(v349) -- line 919 | captures: v334, v4, v5
        local nearby_highlights = v334.nearby_highlights
        for v350, v351 in v349 do
            local v352 = nearby_highlights[v350]
            if not v352 then
                v352 = Instance.new("Highlight")
                v352.Name = "GhostVacuumNearby"
                v352.DepthMode = Enum.HighlightDepthMode.Occluded
                v352.FillColor = v4
                v352.FillTransparency = 0.82
                v352.OutlineColor = v5
                v352.OutlineTransparency = 0.35
                v352.Parent = workspace.Terrain
                nearby_highlights[v350] = v352
            end
            v352.Adornee = v351
        end
        local v353 = #v349 + 1
        local v354 = #nearby_highlights
        for v355 = v353, v354 do
            nearby_highlights[v355].Adornee = nil
        end
    end

    local function destroy_nearby_highlights() -- line 942 | captures: v334
        for v356, v357 in v334.nearby_highlights do
            v357:Destroy()
        end
        table.clear(v334.nearby_highlights)
    end

    local v358 = {}

    local function set_beam_curve(v359, v360) -- line 953 | captures: v358, for_each_beam
        for_each_beam(v359, function(v361) -- line 954 | captures: v360, v358
            if v358[v361] == nil then
                v358[v361] = v361.CurveSize0
            end
            v361.CurveSize0 = v360 or v358[v361]
        end)
    end

    local function aim_attachment_along(v362, v363, v364) -- line 962
        local v365 = v364 - v363
        local Magnitude = v365.Magnitude
        local v366, v367, v368
        if Magnitude < 0.05 then
            v368 = true
        elseif Magnitude == Magnitude then
            v366 = v365 / Magnitude
            local Y = v366.Y
            if math.abs(Y) > 0.99 then
                v367 = Vector3.new(1, 0, 0)
            else
                v367 = Vector3.new(0, 1, 0)
            end
            v368 = false
        else
            v368 = true
        end
        if not v368 then
            local v369 = v366:Cross(v367)
            if v369.Magnitude < 0.0001 then
                v362.WorldCFrame = CFrame.new(v363)
                return 0
            end
            local v370 = v369.Unit:Cross(v366)
            if v370.Magnitude < 0.0001 then
                v362.WorldCFrame = CFrame.new(v363)
                return 0
            end
            v362.WorldCFrame = CFrame.fromMatrix(v363, v366, v370.Unit)
            return Magnitude * 0.6666666666666666
        end
        v362.WorldCFrame = CFrame.new(v363)
        return 0
    end

    local function draw_stream(v371) -- line 989 | captures: v334, v358, aim_attachment_along, for_each_beam, stream_landing
        local beam_part = v334.beam_part
        local miss_attachment = v334.miss_attachment
        if not beam_part or not miss_attachment then
            return nil
        end
        local Position = beam_part.Position
        local v372 = v371 - Position
        if v372.Magnitude < 0.05 then
            return nil
        end
        local v373, v374 = stream_landing(Position, v372.Unit)
        local v375 = aim_attachment_along(miss_attachment, v373, v374)
        for_each_beam(beam_part, function(v376) -- line 954 | captures: v375, v358
            if v358[v376] == nil then
                v358[v376] = v376.CurveSize0
            end
            v376.CurveSize0 = v375 or v358[v376]
        end)
        if v334.fx then
            if miss_attachment then
                v334.fx:hold_on(miss_attachment)
            else
                v334.fx:release()
            end
        end
        return v373
    end

    local function clear_stream() -- line 1006 | captures: v334, v358, for_each_beam
        local beam_part = v334.beam_part
        if beam_part then
            local v377
            for_each_beam(beam_part, function(v378) -- line 954 | captures: v377, v358
                if v358[v378] == nil then
                    v358[v378] = v378.CurveSize0
                end
                v378.CurveSize0 = v377 or v358[v378]
            end)
        end
        if v334.fx then
            v334.fx:release()
        end
    end

    local function face_target(v379) -- line 1014 | captures: v334, Players
        local Character = Players.LocalPlayer.Character
        local v380 = Character and Character:FindFirstChild("HumanoidRootPart")
        if not (v380 and v380:IsA("BasePart")) then
            v380 = nil
        end
        if not (v380 and v334.align) then
            return
        end
        local v381 = v379.X - v380.Position.X
        local v382 = v379.Z - v380.Position.Z
        local v383 = Vector3.new(v381, 0, v382)
        if v383.Magnitude < 0.05 or not (v383.Magnitude == v383.Magnitude) then
            return
        end
        v334.humanoid.AutoRotate = false
        v334.align.Enabled = true
        v334.align.CFrame = CFrame.lookAt(Vector3.new(0, 0, 0), v383.Unit)
    end

    local function target_geometry(v384, v385) -- line 1028 | captures: GhostClustersConstants, GhostClustersGhostRenderer
        if v384.is_prop then
            local PlacementBlock = v384.model.PlacementBlock
            return {
                root = PlacementBlock,
                distance = GhostClustersConstants.flat_distance(v385, PlacementBlock.Position)
            }
        end
        local model = v384.model
        local v386 = { root = model.RootPart }
        local flat_distance = GhostClustersConstants.flat_distance
        local v387 = model:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
        local v388 = GhostClustersGhostRenderer.get_gameplay_cframe(v387)
        local v389 = if v388 then v388.Position else model:GetPivot().Position
        v386.distance = flat_distance(v385, v389)
        return v386
    end

    function v334.detach(v390) -- line 1035 | captures: v333, MinigameForcedState, v334, SoundPlayer
        local target = v390.target
        if v334.reaction_force then
            v334.reaction_force.Force = Vector3.new(0, 0, 0)
            v334.reaction_force.Enabled = false
        end
        local humanoid = v334.humanoid
        if v334.movement_buff_active then
            MinigameForcedState.remove_buff("GhostClustersVacuumPlant")
            v334.movement_buff_active = false
        elseif humanoid and v334.original_walk_speed ~= nil then
            humanoid.WalkSpeed = v334.original_walk_speed
        end
        v334.original_walk_speed = nil
        if v334.fx then
            v334.fx:release()
        end
        local target_highlight = v334.target_highlight
        if target_highlight then
            target_highlight:Destroy()
        end
        v334.target_highlight = nil
        if v334.target_highlight then
            v334.target_highlight.OutlineTransparency = 0
        end
        if v390.align then
            v390.align.Enabled = false
        end
        if v390.humanoid and v390.original_auto_rotate ~= nil then
            v390.humanoid.AutoRotate = v390.original_auto_rotate
        end
        if v390.active_light then
            local active_light = v390.active_light
            if v390.sucking then
                active_light.Brightness = 0.75
            else
                active_light.Brightness = 0
            end
        end
        if target then
            if target.is_prop then
                v333.stop_prop_contribute(target.id, v390.use_token)
            else
                v333.stop_contribute(target.id, v390.use_token)
            end
            v390.target = nil
        end
        if v334.loop_sound then
            v334.loop_sound:Stop()
            v334.loop_sound = nil
        end
        if v334.pull_sound then
            v334.pull_sound:Stop()
            v334.pull_sound = nil
        end
        if target then
            local beam_part = v390.beam_part
            if SoundPlayer.FX:get_source_sound("GhostVacuumStop") then
                SoundPlayer.FX:play("GhostVacuumStop", beam_part)
            end
        end
    end

    function v334.attach_to(v391, v392) -- line 1065 | captures: v333, v334, plant_movement, v358, face_target, SoundService, SoundPlayer, v4, v5, for_each_beam
        if v334.reaction_force then
            v334.reaction_force.Force = Vector3.new(0, 0, 0)
            v334.reaction_force.Enabled = false
        end
        v391.target = v392
        if v392.is_prop then
            v333.start_prop_contribute(v392.id, v391.use_token)
        else
            plant_movement()
            v333.start_contribute(v392.id, v391.use_token)
        end
        v391.next_keepalive_at = os.clock() + 0.4
        if v392.is_prop then
            if v334.pull_sound then
                v334.pull_sound:Stop()
                v334.pull_sound = nil
            end
        elseif not v391.pull_sound then
            local v393 = SoundPlayer.FX:loop("GhostClusters/ObjectGhostPull", SoundService)
            if typeof(v393) == "Instance" then
                v391.pull_sound = v393
                v391.pull_progress = 0
                v391.pull_progress_at = os.clock()
            end
        end
        local v394 = if v392.is_prop then v392.model.PlacementBlock else v392.model.RootPart
        if v391.beam_part then
            local beam_part = v391.beam_part
            local v395
            for_each_beam(beam_part, function(v396) -- line 954 | captures: v395, v358
                if v358[v396] == nil then
                    v358[v396] = v396.CurveSize0
                end
                v396.CurveSize0 = v395 or v358[v396]
            end)
        end
        local beam_anchor = v392.beam_anchor
        if v334.fx then
            if beam_anchor then
                v334.fx:hold_on(beam_anchor)
            else
                v334.fx:release()
            end
        end
        local model = v392.model
        local target_highlight = v334.target_highlight
        if target_highlight then
            target_highlight:Destroy()
        end
        local Highlight
        if model then
            Highlight = Instance.new("Highlight")
            Highlight.Name = "GhostVacuumTarget"
            Highlight.Adornee = model
            Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            Highlight.FillColor = v4
            Highlight.FillTransparency = 0.2
            Highlight.OutlineColor = v5
            Highlight.OutlineTransparency = 0.15
            Highlight.Parent = model
        end
        v334.target_highlight = Highlight
        if v334.target_highlight then
            v334.target_highlight.OutlineTransparency = 0
        end
        if v391.active_light then
            v391.active_light.Brightness = 0.5
        end
        face_target(v394.Position)
        if v391.loop_sound then
            return
        end
        local beam_part = v391.beam_part
        local v397
        if SoundPlayer.FX:get_source_sound("GhostVacuumLoop") then
            v397 = SoundPlayer.FX:loop("GhostVacuumLoop", beam_part)
            if typeof(v397) == "boolean" then
                v397 = nil
            end
        end
        v391.loop_sound = v397
    end

    local function get_auto_target(v398) -- line 1102
        return v398.cached_auto_target
    end

    v334.get_auto_target = get_auto_target

    function v334.probe_world_touch(v399, v400) -- line 1106 | captures: Players, v6, survey
        local Character = Players.LocalPlayer.Character
        local v401 = Character and Character:FindFirstChild("HumanoidRootPart")
        if not (v401 and v401:IsA("BasePart")) then
            v401 = nil
        end
        local CurrentCamera = workspace.CurrentCamera
        if v401 and CurrentCamera then
            local v402 = v6.get_aim_screen_point(v400)
            return survey(v401.Position, v402, CurrentCamera) ~= nil
        end
        return false
    end

    function v334.retarget(v403, v404, v405, v406) -- line 1117 | captures: GhostClustersConstants, ghost_target
        if v403.sucking and v403.use_token then
            local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
            if not (v404:GetAttribute(GHOST_ATTR.Size) == "Large" and v404:GetAttribute(GHOST_ATTR.Shielded) == true) then
                v403:attach_to((ghost_target(v404, v405)))
            end
        end
    end

    function v334.equip(v407, v408) -- line 1124 | captures: v334, set_nearby_highlights, Players, RunService, GhostClustersConstants, GhostClustersGhostRenderer, GhostVacuumGunFx, uses_auto_aim_vacuum, v4, v5, v6, ghost_target, gather_candidates, survey
        v407.tool_wrapper = v408
        local tool = v408.tool
        v407.beam_part = tool.ModelHandle.Visual.pCylinder1
        v407.fx = GhostVacuumGunFx.attach(tool.ModelHandle)
        local PointLight = Instance.new("PointLight")
        PointLight.Name = "GhostVacuumActiveLight"
        PointLight.Color = Color3.fromRGB(110, 255, 225)
        PointLight.Range = 14
        PointLight.Brightness = 0
        PointLight.Parent = v407.beam_part
        v407.active_light = PointLight
        local Character = Players.LocalPlayer.Character
        local HumanoidRootPart = Character.HumanoidRootPart
        local Humanoid = Character.Humanoid
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "GhostClustersAlignAttachment"
        Attachment.Parent = HumanoidRootPart
        local AlignOrientation = Instance.new("AlignOrientation")
        AlignOrientation.Name = "GhostClustersAlignOrientation"
        AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
        AlignOrientation.Attachment0 = Attachment
        AlignOrientation.Responsiveness = 25
        AlignOrientation.MaxTorque = 1000000000
        AlignOrientation.Enabled = false
        AlignOrientation.Parent = HumanoidRootPart
        local VectorForce = Instance.new("VectorForce")
        VectorForce.Name = "GhostClustersReactionForce"
        VectorForce.Attachment0 = Attachment
        VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        VectorForce.ApplyAtCenterOfMass = true
        VectorForce.Force = Vector3.new(0, 0, 0)
        VectorForce.Enabled = false
        VectorForce.Parent = HumanoidRootPart
        v407.align_attachment = Attachment
        v407.align = AlignOrientation
        v407.reaction_force = VectorForce
        v407.humanoid = Humanoid
        v407.original_auto_rotate = Humanoid.AutoRotate
        local Attachment_2 = Instance.new("Attachment")
        Attachment_2.Name = "GhostClustersMissBeam"
        Attachment_2.Parent = workspace.Terrain
        v407.miss_attachment = Attachment_2
        if v334.fx then
            v334.fx:release()
        end
        v407.maid:GiveTask(RunService.RenderStepped:Connect(function() -- line 1177 | captures: v407, v334, set_nearby_highlights, Players, GhostClustersConstants, GhostClustersGhostRenderer, uses_auto_aim_vacuum, v4, v5, v6, ghost_target, gather_candidates, survey
            local v409 = os.clock()
            if v409 < v407.next_highlight_refresh_at then
                return
            end
            v407.next_highlight_refresh_at = v409 + GhostClustersConstants.VACUUM_HIGHLIGHT_REFRESH_SEC
            local Character = Players.LocalPlayer.Character
            local v410 = Character and Character:FindFirstChild("HumanoidRootPart")
            if not (v410 and v410:IsA("BasePart")) then
                v410 = nil
            end
            local CurrentCamera = workspace.CurrentCamera
            if not v410 or not CurrentCamera then
                v407.cached_auto_target = nil
                local hover_highlight = v334.hover_highlight
                if not (hover_highlight and hover_highlight.Parent and hover_highlight.Adornee == nil) then
                    if hover_highlight then
                        hover_highlight:Destroy()
                    end
                    v334.hover_highlight = nil
                end
                set_nearby_highlights({})
            else
                local v411, v412
                if uses_auto_aim_vacuum() then
                    local v413, v414, v415 = gather_candidates(v410.Position)

                    local function nearest(v416) -- line 550 | captures: CurrentCamera, v413, v414, v415, GhostClustersConstants, GhostClustersGhostRenderer
                        local v417
                        local v418 = (1/0)
                        for v419, v420 in v413 do
                            local v421 = v415[v420.id] ~= nil
                            if v421 == v416 and v420.distance <= v420.max_distance then
                                local Position
                                if v421 then
                                    Position = v415[v420.id].model.PlacementBlock.Position
                                else
                                    local v422 = v414[v420.id]
                                    local v423 = v422:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
                                    local v424 = GhostClustersGhostRenderer.get_gameplay_cframe(v423)
                                    if v424 then
                                        Position = v424.Position
                                    else
                                        Position = v422:GetPivot().Position
                                    end
                                end
                                local v425, v426 = CurrentCamera:WorldToViewportPoint(Position)
                                if v426 and v420.distance < v418 then
                                    v417, v418 = v420, v420.distance
                                end
                            end
                        end
                        return v417
                    end

                    local v427 = nearest(false) or nearest(true)
                    if v427 then
                        local v428 = v415[v427.id]
                        if v428 then
                            v411 = {
                                is_prop = true,
                                size = "Prop",
                                id = v428.unique,
                                model = v428.model,
                                is_mural = v428.is_mural
                            }
                            local is_mural = v428.is_mural
                            v411.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
                            v411.beam_anchor = v428.model.PlacementBlock
                        else
                            local v429 = GhostClustersGhostRenderer.get_visual(v427.id)
                            if v429 then
                                v411 = ghost_target(v429, v427.id)
                            else
                                v411 = ghost_target(v414[v427.id], v427.id)
                            end
                        end
                    end
                    v407.cached_auto_target = v411
                    local v430 = {}
                    for v431, v432 in v413 do
                        if v432.distance <= v432.max_distance then
                            table.insert(v430, v432)
                        end
                    end
                    table.sort(v430, function(v433, v434) -- line 1207
                        return v433.distance < v434.distance
                    end)
                    v412 = {}
                    for v435, v436 in v430 do
                        if GhostClustersConstants.VACUUM_NEARBY_HIGHLIGHT_MAX < v435 then
                            break
                        end
                        local v437 = v415[v436.id]
                        local v438 = if v437 then v437.model else GhostClustersGhostRenderer.get_visual(v436.id) or v414[v436.id]
                        table.insert(v412, v438)
                    end
                else
                    v407.cached_auto_target = nil
                    local v439 = v6.get_aim_screen_point()
                    local v440
                    v411, v440, v412 = survey(v410.Position, v439, CurrentCamera)
                    _ = v440
                end
                local v441 = if v407.target then v407.target.model else nil
                local model
                if v441 then
                elseif v411 then
                    model = v411.model
                end
                local hover_highlight = v334.hover_highlight
                if not (hover_highlight and hover_highlight.Parent and hover_highlight.Adornee == model) then
                    if hover_highlight then
                        hover_highlight:Destroy()
                    end
                    local Highlight
                    if model then
                        Highlight = Instance.new("Highlight")
                        Highlight.Name = "GhostVacuumTarget"
                        Highlight.Adornee = model
                        Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                        Highlight.FillColor = v4
                        Highlight.FillTransparency = 0.55
                        Highlight.OutlineColor = v5
                        Highlight.OutlineTransparency = 0.15
                        Highlight.Parent = model
                    end
                    v334.hover_highlight = Highlight
                end
                local v442 = {}
                for v443, v444 in v412 do
                    if v444 ~= model and v444 ~= v441 then
                        table.insert(v442, v444)
                    end
                end
                set_nearby_highlights(v442)
            end
        end))
        v407.maid:GiveTask(function() -- line 1237 | captures: PointLight, Attachment, AlignOrientation, VectorForce, Attachment_2, v334
            PointLight:Destroy()
            Attachment:Destroy()
            AlignOrientation:Destroy()
            VectorForce:Destroy()
            Attachment_2:Destroy()
            local hover_highlight = v334.hover_highlight
            if not (hover_highlight and hover_highlight.Parent and hover_highlight.Adornee == nil) then
                if hover_highlight then
                    hover_highlight:Destroy()
                end
                v334.hover_highlight = nil
            end
            for v445, v446 in v334.nearby_highlights do
                v446:Destroy()
            end
            table.clear(v334.nearby_highlights)
        end)
    end

    local function drop_lock() -- line 1248 | captures: v334, GhostClustersConstants
        v334:detach()
        v334.reacquire_at = os.clock() + GhostClustersConstants.VACUUM_REACQUIRE_DELAY_SEC
    end

    function v334.start(v447, v448, v449, v450) -- line 1253 | captures: v333, v334, update_reaction_force, draw_stream, face_target, HttpService, Players, RunService, SoundService, SoundPlayer, GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer, v6, ghost_target, is_furniture_obstructed, gather_candidates, survey
        if not v447.sucking then
            local Character = Players.LocalPlayer.Character
            local v451 = Character and Character:FindFirstChild("Humanoid")
            if not (v451 and v451:IsA("Humanoid") and GhostClustersConstants.is_vacuum_ragdolled(v451)) then
                local Character = Players.LocalPlayer.Character
                local v452 = Character and Character:FindFirstChild("HumanoidRootPart")
                if not (v452 and v452:IsA("BasePart")) then
                    v452 = nil
                end
                local CurrentCamera = workspace.CurrentCamera
                if v452 then
                    local v453 = v450 or "cursor"
                    local v454 = v6.get_aim_screen_point(v448, v449)
                    local v455, v456
                    if v453 == "auto" then
                        local Position = v452.Position
                        local v457, v458, v459 = gather_candidates(Position)

                        local function nearest(v460) -- line 550 | captures: CurrentCamera, v457, v458, v459, GhostClustersConstants, GhostClustersGhostRenderer
                            local v461
                            local v462 = (1/0)
                            for v463, v464 in v457 do
                                local v465 = v459[v464.id] ~= nil
                                if v465 == v460 and v464.distance <= v464.max_distance then
                                    local Position
                                    if v465 then
                                        Position = v459[v464.id].model.PlacementBlock.Position
                                    else
                                        local v466 = v458[v464.id]
                                        local v467 = v466:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
                                        local v468 = GhostClustersGhostRenderer.get_gameplay_cframe(v467)
                                        if v468 then
                                            Position = v468.Position
                                        else
                                            Position = v466:GetPivot().Position
                                        end
                                    end
                                    local v469, v470 = CurrentCamera:WorldToViewportPoint(Position)
                                    if v470 and v464.distance < v462 then
                                        v461, v462 = v464, v464.distance
                                    end
                                end
                            end
                            return v461
                        end

                        local v471 = nearest(false) or nearest(true)
                        if v471 then
                            local v472 = v459[v471.id]
                            if v472 then
                                v455 = {
                                    is_prop = true,
                                    size = "Prop",
                                    id = v472.unique,
                                    model = v472.model,
                                    is_mural = v472.is_mural
                                }
                                local is_mural = v472.is_mural
                                v455.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
                                v455.beam_anchor = v472.model.PlacementBlock
                            else
                                local v473 = GhostClustersGhostRenderer.get_visual(v471.id)
                                if v473 then
                                    v455 = ghost_target(v473, v471.id)
                                else
                                    v455 = ghost_target(v458[v471.id], v471.id)
                                end
                            end
                        end
                        if v455 then
                        else
                            return false
                        end
                    else
                        v455, v456 = survey(v452.Position, v454, CurrentCamera)
                    end
                    v447.sucking = true
                    v447.reacquire_at = 0
                    v447.use_token = HttpService:GenerateGUID(false)
                    v447.aim_screen_point = v454
                    local v474 = if v453 == "drag" then v448 else nil
                    v447.aim_input = v474
                    v447.aim_mode = v453
                    v447.drag_aim_point = v456
                    v447.next_drag_survey_at = 0
                    local hover_highlight = v334.hover_highlight
                    if not (hover_highlight and hover_highlight.Parent and hover_highlight.Adornee == nil) then
                        if hover_highlight then
                            hover_highlight:Destroy()
                        end
                        v334.hover_highlight = nil
                    end
                    if v447.active_light then
                        v447.active_light.Brightness = 0.75
                    end
                    local beam_part = v447.beam_part
                    if SoundPlayer.FX:get_source_sound("GhostVacuumStart") then
                        SoundPlayer.FX:play("GhostVacuumStart", beam_part)
                    end
                    if v455 then
                        v447:attach_to(v455)
                    else
                        draw_stream(v456)
                    end
                    v447.use_maid:GiveTask(RunService.Heartbeat:Connect(function() -- line 1298 | captures: v447, v333, v334, update_reaction_force, draw_stream, face_target, Players, SoundService, SoundPlayer, GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer, v6, ghost_target, is_furniture_obstructed, gather_candidates, survey
                        local Character = Players.LocalPlayer.Character
                        local v475 = Character and Character:FindFirstChild("Humanoid")
                        if v475 and v475:IsA("Humanoid") and GhostClustersConstants.is_vacuum_ragdolled(v475) then
                            v447:stop()
                            return
                        end
                        local Character_2 = Players.LocalPlayer.Character
                        local v476 = Character_2 and Character_2:FindFirstChild("HumanoidRootPart")
                        if not (v476 and v476:IsA("BasePart")) then
                            v476 = nil
                        end
                        if not v476 then
                            v447:detach()
                            return
                        end
                        local CurrentCamera = workspace.CurrentCamera
                        local v477 = os.clock()
                        if v447.aim_mode == "drag" and CurrentCamera and v447.next_drag_survey_at <= v477 then
                            v447.next_drag_survey_at = v477 + 0.05
                            v447.aim_screen_point = v6.get_aim_screen_point(v447.aim_input)
                            local v478, v479 = survey(v476.Position, v447.aim_screen_point, CurrentCamera)
                            v447.drag_aim_point = v479
                            local target = v447.target
                            if target then
                                if v478 and v478.id == target.id then
                                    if v478.is_prop ~= target.is_prop then
                                        v447:detach()
                                        v447.reacquire_at = 0
                                    end
                                else
                                    v447:detach()
                                    v447.reacquire_at = 0
                                end
                            end
                            if v478 and not v447.target then
                                v447:attach_to(v478)
                            end
                        end
                        local target = v447.target
                        if not target then
                            if v447.aim_mode == "auto" then
                                if CurrentCamera and v447.next_drag_survey_at <= v477 and v447.reacquire_at <= v477 then
                                    v447.next_drag_survey_at = v477 + 0.05
                                    local Position = v476.Position
                                    local v480, v481, v482 = gather_candidates(Position)

                                    local function nearest(v483) -- line 550 | captures: CurrentCamera, v480, v481, v482, GhostClustersConstants, GhostClustersGhostRenderer
                                        local v484
                                        local v485 = (1/0)
                                        for v486, v487 in v480 do
                                            local v488 = v482[v487.id] ~= nil
                                            if v488 == v483 and v487.distance <= v487.max_distance then
                                                local Position
                                                if v488 then
                                                    Position = v482[v487.id].model.PlacementBlock.Position
                                                else
                                                    local v489 = v481[v487.id]
                                                    local v490 = v489:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
                                                    local v491 = GhostClustersGhostRenderer.get_gameplay_cframe(v490)
                                                    if v491 then
                                                        Position = v491.Position
                                                    else
                                                        Position = v489:GetPivot().Position
                                                    end
                                                end
                                                local v492, v493 = CurrentCamera:WorldToViewportPoint(Position)
                                                if v493 and v487.distance < v485 then
                                                    v484, v485 = v487, v487.distance
                                                end
                                            end
                                        end
                                        return v484
                                    end

                                    local v494 = nearest(false) or nearest(true)
                                    local v495
                                    if v494 then
                                        local v496 = v482[v494.id]
                                        if v496 then
                                            v495 = {
                                                is_prop = true,
                                                size = "Prop",
                                                id = v496.unique,
                                                model = v496.model,
                                                is_mural = v496.is_mural
                                            }
                                            local is_mural = v496.is_mural
                                            v495.max_distance = GhostClustersConstants.prop_vacuum_range(is_mural) * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
                                            v495.beam_anchor = v496.model.PlacementBlock
                                        else
                                            local v497 = GhostClustersGhostRenderer.get_visual(v494.id)
                                            if v497 then
                                                v495 = ghost_target(v497, v494.id)
                                            else
                                                v495 = ghost_target(v481[v494.id], v494.id)
                                            end
                                        end
                                    end
                                    if v495 then
                                        v447:attach_to(v495)
                                    else
                                        v447:stop()
                                    end
                                end
                            elseif not (CurrentCamera and v447.aim_mode == "cursor") then
                                if v447.aim_mode == "drag" and v447.drag_aim_point then
                                    local v498 = draw_stream(v447.drag_aim_point)
                                    if v498 then
                                        face_target(v498)
                                    end
                                end
                            else
                                v447.aim_screen_point = v6.get_aim_screen_point()
                                local v499, v500 = survey(v476.Position, v447.aim_screen_point, CurrentCamera)
                                local v501
                                if v499 then
                                    local v502 = os.clock()
                                    v501 = v447.reacquire_at <= v502
                                end
                                if not v499 or not v501 then
                                    local v503 = draw_stream(v500)
                                    if v503 then
                                        face_target(v503)
                                    end
                                else
                                    v447:attach_to(v499)
                                end
                            end
                        elseif not target.model.Parent then
                            local v504, v505, v506, v507
                            if target.is_prop then
                                v507 = true
                            else
                                local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
                                v504 = target.model:GetAttribute(GHOST_ATTR.ProgressRequired)
                                v505 = target.model:GetAttribute(GHOST_ATTR.Progress)
                                if typeof(v504) == "number" and v504 > 0 and typeof(v505) == "number" then
                                    if v447.pull_progress_at > 0 then
                                        v506 = os.clock() - v447.pull_progress_at
                                    else
                                        v506 = 0
                                    end
                                    v507 = false
                                else
                                    v507 = true
                                end
                            end
                            if not v507 then
                                local v508 = v505 + GhostClustersConstants.PROGRESS_PER_SEC_PER_PLAYER * v506
                                if (v504 <= v505 + 0.05 or v504 <= v508) and SoundPlayer.FX:get_source_sound("GhostClusters/GhostComplete") then
                                    SoundPlayer.FX:play("GhostClusters/GhostComplete", SoundService)
                                end
                            end
                            v334:detach()
                            v334.reacquire_at = os.clock() + GhostClustersConstants.VACUUM_REACQUIRE_DELAY_SEC
                        else
                            if target.is_prop then
                                local v509 = GhostClustersPropRenderer.get_entry(target.id)
                                if not v509 or v509.resolved or is_furniture_obstructed(v476.Position, target.model) then
                                    v334:detach()
                                    v334.reacquire_at = os.clock() + GhostClustersConstants.VACUUM_REACQUIRE_DELAY_SEC
                                    return
                                end
                            else
                                local v510
                                if target.model:GetAttribute(GhostClustersConstants.GHOST_ATTR.Orbiting) == true then
                                    v510 = false
                                else
                                    local model = target.model
                                    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
                                    local v511 = if model:GetAttribute(GHOST_ATTR.Size) == "Large" then model:GetAttribute(GHOST_ATTR.Shielded) == true else false
                                    v510 = not v511
                                end
                                if not v510 then
                                    v334:detach()
                                    v334.reacquire_at = os.clock() + GhostClustersConstants.VACUUM_REACQUIRE_DELAY_SEC
                                    return
                                end
                            end
                            local Position = v476.Position
                            local v512
                            if target.is_prop then
                                local PlacementBlock = target.model.PlacementBlock
                                v512 = {
                                    root = PlacementBlock,
                                    distance = GhostClustersConstants.flat_distance(Position, PlacementBlock.Position)
                                }
                            else
                                local model = target.model
                                v512 = { root = model.RootPart }
                                local flat_distance = GhostClustersConstants.flat_distance
                                local v513 = model:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
                                local v514 = GhostClustersGhostRenderer.get_gameplay_cframe(v513)
                                local v515 = if v514 then v514.Position else model:GetPivot().Position
                                v512.distance = flat_distance(Position, v515)
                            end
                            local distance = v512.distance
                            if target.max_distance < distance then
                                v334:detach()
                                v334.reacquire_at = os.clock() + GhostClustersConstants.VACUUM_REACQUIRE_DELAY_SEC
                            else
                                local beam_anchor = target.beam_anchor
                                if v334.fx then
                                    if beam_anchor then
                                        v334.fx:hold_on(beam_anchor)
                                    else
                                        v334.fx:release()
                                    end
                                end
                                face_target(v512.root.Position)
                                if not target.is_prop then
                                    update_reaction_force(target.model, v476)
                                    local pull_sound = v447.pull_sound
                                    if pull_sound then
                                        local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
                                        local v516 = target.model:GetAttribute(GHOST_ATTR.ProgressRequired) or 1
                                        local v517 = target.model:GetAttribute(GHOST_ATTR.Progress) or 0
                                        if v517 ~= v447.pull_progress then
                                            v447.pull_progress = v517
                                            v447.pull_progress_at = v477
                                        end
                                        if target.model:GetAttribute(GHOST_ATTR.VacuumLocked) == true then
                                            local v518 = v517 + GhostClustersConstants.PROGRESS_PER_SEC_PER_PLAYER * (v477 - v447.pull_progress_at)
                                            local v519 = v516 * 0.98
                                            v517 = math.min(v518, v519)
                                        end
                                        local v520 = v517 / math.max(v516, 0.001)
                                        pull_sound.PlaybackSpeed = math.clamp(v520, 0, 1) * 18 + 1
                                    end
                                end
                                if not (v447.next_keepalive_at <= v477) then
                                    return
                                end
                                v447.next_keepalive_at = v477 + 0.4
                                if target.is_prop then
                                    v333.start_prop_contribute(target.id, v447.use_token)
                                else
                                    v333.start_contribute(target.id, v447.use_token)
                                end
                            end
                        end
                    end))
                    return true
                end
            end
        end
        return false
    end

    function v334.stop(v521) -- line 1433 | captures: v334, v358, for_each_beam
        if not v521.sucking then
            return
        end
        v521.sucking = false
        v521.use_maid:DoCleaning()
        v521:detach()
        local beam_part = v334.beam_part
        if beam_part then
            local v522
            for_each_beam(beam_part, function(v523) -- line 954 | captures: v522, v358
                if v358[v523] == nil then
                    v358[v523] = v523.CurveSize0
                end
                v523.CurveSize0 = v522 or v358[v523]
            end)
        end
        if v334.fx then
            v334.fx:release()
        end
        v521.use_token = nil
        v521.aim_input = nil
        v521.aim_mode = "cursor"
        v521.drag_aim_point = nil
        if v521.active_light then
            v521.active_light.Brightness = 0
        end
        local _notify_stopped = v521._notify_stopped
        v521._notify_stopped = nil
        if _notify_stopped then
            _notify_stopped()
        end
    end

    function v334.use(v524, v525, v526, v527, v528, v529) -- line 1458 | captures: RunService, UserInputService, v1
        local function v530(v531, ...)
            table.insert(v531, ...)
        end

        if v524:start(v527, v528, v529) then
            local v532 = false
            local v533
            local v534 = v1.new(function(v535) -- line 1470 | captures: v533
                v533 = v535
            end)

            function v524._notify_stopped() -- line 1473 | captures: v532, v533
                if not v532 then
                    v532 = true
                    v533()
                end
            end

            local v536 = {
                v1.fromEvent(UserInputService.InputEnded, function(v537) -- line 1482 | captures: v527
                    if v527 then
                        if v537 == v527 then
                            return true
                        end
                        if v527.UserInputType.Name:sub(1, 7) == "Gamepad" and v537.UserInputType.Name:sub(1, 7) == "Gamepad" then
                            return v537.KeyCode == v527.KeyCode
                        end
                        return false
                    end
                    if v537.UserInputType == Enum.UserInputType.MouseButton1 then
                        return true
                    end
                    return v537.UserInputType == Enum.UserInputType.Touch
                end),
                v1.fromEvent(v525),
                v1.fromEvent(v526),
                v534
            }
            if v527 and v527.UserInputType.Name:sub(1, 7) == "Gamepad" then
                local KeyCode = v527.KeyCode
                v530(v536, v1.fromEvent(RunService.Heartbeat, function() -- line 1506 | captures: v527, KeyCode, UserInputService
                    return not UserInputService:IsGamepadButtonDown(v527.UserInputType, KeyCode)
                end))
            end
            v1.race(v536):expect()
            v524._notify_stopped = nil
            if not v532 then
                v532 = true
                v533()
            end
            v524:stop()
        end
        return false
    end

    function v334.unequip(v538) -- line 1518 | captures: v334
        v538:stop()
        if v334.loop_sound then
            v334.loop_sound:Stop()
            v334.loop_sound = nil
        end
        v538.maid:DoCleaning()
        if v538.fx then
            v538.fx:destroy()
            v538.fx = nil
        end
        v538.beam_part = nil
        v538.tool_wrapper = nil
        v538.align = nil
        v538.align_attachment = nil
        v538.reaction_force = nil
        v538.active_light = nil
        v538.miss_attachment = nil
        v538.humanoid = nil
        v538.original_auto_rotate = nil
        v538.original_walk_speed = nil
        v538.movement_buff_active = false
    end

    return v334
end

return v6

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostVacuumToyNet
-- Took 0.32s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local NetEvent = require(ReplicatedStorage.new.modules.Net.NetEvent)
local gt = require(ReplicatedStorage.SharedPackages.gt)
local GhostVacuumGunFx = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostVacuumGunFx)
local v1 = {
    ox = gt.number(),
    oy = gt.number(),
    oz = gt.number(),
    hx = gt.number(),
    hy = gt.number(),
    hz = gt.number(),
    user_id = gt.number(),
    pet_unique = gt.optional(gt.string())
}
local v2 = {
    Fire = NetEvent.new({
        name = "Halloween2026/GhostVacuumToyFire",
        request = v1,
        rate = {
            mode = "SlidingWindow",
            seconds = 1,
            limit = 8
        }
    })
}

local function is_vacuum_toy(v3) -- line 39
    if v3 == "halloween_2026_ghost_vacuum" then
        return true
    end
    return v3 == "halloween_2026_ghost_vacuum_gold"
end

local function spin_pet(v4, v5) -- line 43 | captures: ReplicatedStorage
    local load = require(ReplicatedStorage.Fsys).load
    local EquippedPets = load("EquippedPets")
    local PetEntityHelper = load("PetEntityHelper")
    local PetEntityManager = load("PetEntityManager")
    local PetMovementTarget = load("PetMovementTarget")
    local PetPerformanceName = load("PetPerformanceName")
    for v6, v7 in EquippedPets.get_controlled_char_wrappers() do
        if v7.pet_unique == v4 then
            local v8 = PetEntityManager.get_pet_entity(v7.char)
            if v8 then
                PetEntityHelper.stage_performance(v8, {
                    name = PetPerformanceName.RunInCircles,
                    options = {
                        walkspeed = 22,
                        radius = 3,
                        duration = 2.5,
                        eyes_id = "happy_eyes",
                        effects = { "love" },
                        target = PetMovementTarget.new({ target = v5 })
                    }
                })
            end
            return
        end
    end
end

function v2.replay(v9, v10) -- line 76 | captures: GhostVacuumGunFx
    local GhostVacuumTool = v9:FindFirstChild("GhostVacuumTool")
    local v11 = GhostVacuumTool and GhostVacuumTool:FindFirstChild("ModelHandle")
    if not (v11 and v11:IsA("Model")) then
        return
    end
    local v12 = GhostVacuumGunFx.attach(v11)
    v12:fire_at(v10)
    task.delay(0.4, function() -- line 84 | captures: v12
        v12:destroy()
    end)
end

function v2.start_server() -- line 89 | captures: Players, ReplicatedStorage, v2
    local DataM = require(ReplicatedStorage.Fsys).load("DataM")
    v2.Fire:on_server_event(function(v13, v14) -- line 93 | captures: DataM, Players, v2
        local toys = DataM.get_store(v13):get("equip_manager"):get_equipped().toys
        if toys then
            local kind = toys.kind
            if kind == "halloween_2026_ghost_vacuum" or kind == "halloween_2026_ghost_vacuum_gold" then
                local v15 = v13.Character and v13.Character:FindFirstChild("HumanoidRootPart")
                if v15 and v15:IsA("BasePart") then
                    local ox = v14.ox
                    local oy = v14.oy
                    local oz = v14.oz
                    local v16 = Vector3.new(ox, oy, oz)
                    local hx = v14.hx
                    local hy = v14.hy
                    local hz = v14.hz
                    local v17 = Vector3.new(hx, hy, hz)
                    if not ((v16 - v15.Position).Magnitude > 20 or (v17 - v15.Position).Magnitude > 90) then
                        v14.user_id = v13.UserId
                        for v18, v19 in Players:GetPlayers() do
                            if v19 ~= v13 then
                                v2.Fire:fire_client(v19, v14)
                            end
                        end
                    end
                end
            end
        end
    end)
end

if RunService:IsClient() then
    v2.Fire:on_client_event(function(v20) -- line 117 | captures: Players, v2, spin_pet
        local v21 = Players:GetPlayerByUserId(v20.user_id)
        local v22 = v21 and v21.Character
        if v22 then
            local replay = v2.replay
            local hx = v20.hx
            local hy = v20.hy
            local hz = v20.hz
            replay(v22, (Vector3.new(hx, hy, hz)))
        end
        if v20.pet_unique and v21 then
            spin_pet(v20.pet_unique, v21)
        end
    end)
end
v2.MAX_RANGE = 80
v2.spin_pet = spin_pet
return v2

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Minigames.GhostClustersMinigameClient
-- Took 0.67s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local TweenService = game:GetService("TweenService")
local load = require(ReplicatedStorage.Fsys).load
local Class = load("Class")
local ClientData = load("ClientData")
local ClientToolManager = load("ClientToolManager")
local v1 = load("new:CutsceneHelper")
local GameplayFX = require(ReplicatedStorage.SharedModules.GameplayFX)
local LiveOpsTime = load("LiveOpsTime")
local Music = load("Music")
local SoundDB = load("SoundDB")
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local Spring = load("Spring")
local InteriorsM = load("InteriorsM")
local MinigameClient = load("MinigameClient")
local MinigameForcedState = load("MinigameForcedState")
local MinigameRagdoll = require(ReplicatedStorage.ClientModules.Game.MinigameHelpers.MinigameRagdoll)
local v2 = load("package:Promise")
local PromiseQueue = load("PromiseQueue")
local PlatformM = load("PlatformM")
local PracticeDogHider = load("PracticeDogHider")
local UIManager = load("UIManager")
local ShakePromise = require(ReplicatedStorage.SharedModules.ShakePromise)
local GhostClustersClientConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersClientConstants)
local GhostClustersConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersConstants)
local GhostClustersGhostRenderer = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersGhostRenderer)
local GhostClustersGhosts = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersGhosts)
local GhostClustersMotion = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersMotion)
local GhostClustersMotionCodec = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersMotionCodec)
local GhostClustersNet = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersNet)
local GhostClustersPetGuide = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersPetGuide)
local GhostClustersProgressBar = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersProgressBar)
local GhostClustersPropRenderer = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersPropRenderer)
local GhostClustersVacuumHelper = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersVacuumHelper)
local CharacterScale = load("CharacterScale")
local EquippedPets = load("EquippedPets")
local GhostVacuumGunFx = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostVacuumGunFx)
local v3 = Class("GhostClustersMinigameClient", MinigameClient)
local v4 = Color3.fromRGB(31, 128, 29)

local function uses_auto_aim_vacuum_controls() -- line 64 | captures: PlatformM
    local v5 = PlatformM.get_platform()
    if v5 ~= PlatformM.platform.phone and v5 ~= PlatformM.platform.tablet and v5 ~= PlatformM.platform.console then
        return PlatformM.is_using_gamepad()
    end
    return true
end

local v6 = {
    Small = Color3.fromRGB(186, 130, 255),
    Medium = Color3.fromRGB(186, 130, 255)
}
local v7 = Color3.fromRGB(121, 55, 255)
local v8 = Color3.fromRGB(235, 86, 86)
local v9 = Color3.fromRGB(255, 168, 32)
local v10 = { 1, 1.2, 1.45 }
local v11 = {
    amplitude = 0.012,
    frequency = 18,
    time = 0.35,
    decay_percent = 0.8
}
local v12 = TweenInfo.new(0.12, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v13 = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

local function get_vacuum_item_data() -- line 104 | captures: ClientData, GhostClustersConstants
    local v14
    for v15, v16 in ClientData.get("inventory").toys do
        if v16.kind == GhostClustersConstants.GOLD_TOY_KIND then
            return v16
        end
        if v16.kind == GhostClustersConstants.TOY_KIND then
            v14 = v16
        end
    end
    return v14
end

local function wait_for_vacuum_item_data(v17) -- line 116 | captures: ClientData, v2, get_vacuum_item_data
    local v18 = v2.fromEvent(ClientData.DataChangedEvent, function(v19) -- line 117 | captures: get_vacuum_item_data
        if v19 == "inventory" then
            return get_vacuum_item_data() ~= nil
        end
        return false
    end):timeout(10)
    v17:GiveTask(function() -- line 120 | captures: v18
        v18:cancel()
    end)
    local v20 = get_vacuum_item_data()
    if v20 then
        v18:cancel()
        return v20
    end
    local v21 = v18:awaitStatus()
    if v21 == v2.Status.Cancelled then
        return nil
    end
    if v21 ~= v2.Status.Resolved then
        error("Ghost Vacuum was not granted before minigame hotbar setup")
    end
    return (get_vacuum_item_data())
end

function v3.pre_enter_minigame(v22, v23) -- line 140 | captures: v2, PromiseQueue
    v22._score = 0
    v22._gameplay_message_queue = PromiseQueue.new()
    v22._gameplay_message_queue:enqueue(function() -- line 143 | captures: v22, v2
        return v2.new(function(v24) -- line 144 | captures: v22
            v22._release_gameplay_messages = v24
        end)
    end)
    v22.leave_maid:GiveTask(function() -- line 148 | captures: v22
        v22._gameplay_message_queue:destroy()
    end)
end

function v3._enqueue_gameplay_message(v25, v26) -- line 154 | captures: v2
    v25._gameplay_message_queue:enqueue(function() -- line 155 | captures: v26, v2
        return v2.try(v26)
    end)
end

local function suppress_equipped_pet_scale(v27) -- line 160 | captures: CharacterScale, EquippedPets
    for v28, v29 in EquippedPets.get_equipped_char_wrappers() do
        local char = v29.char
        local v30 = CharacterScale.get_scale_params(char)
        CharacterScale.scale_pet(char, 1)
        v27:GiveTask(function() -- line 165 | captures: char, v30, CharacterScale
            if char.Parent then
                CharacterScale.scale_pet(char, v30.scale or 1, v30.animation_scale_override)
            end
        end)
    end
end

function v3.post_enter_minigame(v31, v32) -- line 173 | captures: RunService, MinigameForcedState, GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersMotionCodec, GhostClustersNet, GhostClustersPetGuide, GhostClustersPropRenderer, suppress_equipped_pet_scale
    MinigameForcedState.add_buff("ghost_clusters_walk_speed", { walk_speed = GhostClustersConstants.WALK_SPEED })
    suppress_equipped_pet_scale(v31.leave_maid)
    GhostClustersGhostRenderer.start(v31.minigame_id)
    v31.leave_maid:GiveTask(GhostClustersGhostRenderer.stop)
    v31._motion_epoch = v32.motion_epoch
    v31._score = 0
    v31._live_score_popup = nil
    v31._live_combo_popup = nil
    v31.leave_maid:GiveTask(function() -- line 184 | captures: v31
        if v31._live_combo_popup then
            v31._live_combo_popup.popup:release()
            v31._live_combo_popup = nil
        end
        v31._live_score_popup = nil
    end)
    v31.leave_maid:GiveTask(GhostClustersNet.motion:on_client_event(function(v33) -- line 191 | captures: v31, GhostClustersGhostRenderer, GhostClustersMotionCodec
        local v34, v35 = GhostClustersMotionCodec.unpack(v33)
        GhostClustersGhostRenderer.apply_snapshot(v34, v35, v31._motion_epoch)
    end))
    GhostClustersPropRenderer.start()
    v31.leave_maid:GiveTask(GhostClustersPropRenderer.stop)
    GhostClustersPetGuide.start()
    v31.leave_maid:GiveTask(GhostClustersPetGuide.stop)
    v31._player_orbit = nil
    v31._remote_beams = v31._remote_beams or {}
    v31.leave_maid:GiveTask(function() -- line 205 | captures: v31
        v31:_clear_remote_beams()
    end)
    v31.leave_maid:GiveTask(RunService.Heartbeat:Connect(function(v36) -- line 208 | captures: v31
        v31:_step_combo_popup()
        v31:_step_player_tornado_orbit(v36)
        v31:_step_remote_beams()
        v31:_step_auto_aim_vacuum_button()
        if v31:_is_vacuum_blocked() then
            v31:_stop_vacuum()
        end
    end))
    v31.leave_maid:GiveTask(function() -- line 217 | captures: v31
        v31:_clear_player_tornado()
    end)
    v31:_setup_vacuum_hotbar()
    v31:_lend_practice_dog()
    if v32 and v32.play_intro_cutscene then
        v31:_play_intro_cutscene()
    else
        v31._release_gameplay_messages()
    end
end

function v3._lend_practice_dog(v37) -- line 238 | captures: ClientToolManager, PracticeDogHider
    if not (#ClientToolManager.get_equipped_by_category("pets") > 0) then
        local v38 = PracticeDogHider.get_item_data()
        if v38 then
            local v39 = PracticeDogHider.suppress_hiding()
            task.spawn(ClientToolManager.equip, v38)
            v37.leave_maid:GiveTask(function() -- line 255 | captures: v38, v39, ClientToolManager
                task.spawn(ClientToolManager.unequip, v38)
                v39()
            end)
        end
    end
end

function v3._setup_vacuum_hotbar(v40) -- line 264 | captures: Players, ClientToolManager, v2, PlatformM, UIManager, GhostClustersVacuumHelper, v4, wait_for_vacuum_item_data
    local v41 = wait_for_vacuum_item_data(v40.leave_maid)
    if not v41 then
        return
    end
    v40._vacuum_item_unique = v41.unique
    local v42 = ClientToolManager.is_equipped(v41)

    local function get_vacuum_tool_wrapper() -- line 272 | captures: v41, UIManager
        return UIManager.apps.ToolApp.active_tools[v41.unique]
    end

    v40.leave_maid:GiveTask(task.spawn(function() -- line 280 | captures: v41, ClientToolManager, UIManager, GhostClustersVacuumHelper
        if not ClientToolManager.is_equipped(v41) then
            ClientToolManager.equip(v41)
        end
        for v43 = 1, 200 do
            local v44 = UIManager.apps.ToolApp.active_tools[v41.unique]
            if v44 and v44.tool then
                GhostClustersVacuumHelper.attach_tool_session(v44)
                return
            end
            task.wait(0.05)
        end
        error("Ghost Vacuum tool wrapper was not ready for minigame hotbar setup")
    end))
    local v45 = PlatformM.get_platform()
    local v46 = if v45 == PlatformM.platform.phone or v45 == PlatformM.platform.tablet then true else v45 == PlatformM.platform.console
    local MinigameHotbarApp = UIManager.apps.MinigameHotbarApp
    local v47 = {}
    local v48 = {
        layout_order = 1,
        visible = true,
        image = "rbxassetid://121349799904335",
        inner_color = v4,
        world_tap_enabled = not v46,
        gamepad_hotkey = Enum.KeyCode.ButtonR2
    }

    function v48.claim_world_touch(v49) -- line 311 | captures: v41, Players, UIManager
        for v50, v51 in (Players.LocalPlayer.PlayerGui:GetGuiObjectsAtPosition(v49.Position.X, v49.Position.Y)) do
            if v51:IsA("GuiObject") and v51.Active then
                return false
            end
        end
        local v52 = UIManager.apps.ToolApp.active_tools[v41.unique]
        local v53 = v52 and v52.ghost_clusters_session
        if v53 == nil then
            return false
        end
        return (v53:probe_world_touch(v49))
    end

    function v48.get_can_use() -- line 323 | captures: v40, v41, UIManager
        if v40:_is_vacuum_blocked() then
            return false
        end
        local v54 = UIManager.apps.ToolApp.active_tools[v41.unique]
        if v54 == nil then
            return false
        end
        return v54.ghost_clusters_session ~= nil
    end

    function v48.cancel_active_use() -- line 332 | captures: v41, UIManager
        local v55 = UIManager.apps.ToolApp.active_tools[v41.unique]
        if v55 and v55.in_use and v55.early_cancellation_signal then
            v55.early_cancellation_signal:fire()
        end
    end

    function v48.get_use_promise(v56) -- line 338 | captures: v41, v2, UIManager
        local v57 = if typeof(v56) == "table" then v56 else nil
        local aim_screen_point, v58
        if v57 then
            v58 = v57.press_input
            aim_screen_point = v57.aim_screen_point
        else
            v58 = v56
        end
        if not v57 or not aim_screen_point then
            aim_screen_point = nil
        end
        local v59
        if v58 == nil then
            v59 = false
        elseif v58.UserInputType == Enum.UserInputType.Touch then
            v59 = true
        else
            v59 = v58.UserInputType.Name:sub(1, 7) == "Gamepad"
        end
        local v60
        if not (v57 and v57.world_aim) then
            if v59 then
                v60 = "auto"
            else
                v60 = "cursor"
            end
        else
            v60 = "drag"
        end
        local try = v2.try
        local v61 = v58
        local aim_screen_point_2 = aim_screen_point
        local v62 = v60
        return try(function() -- line 351 | captures: v61, aim_screen_point_2, v62, v41, UIManager
            local v63 = UIManager.apps.ToolApp.active_tools[v41.unique]
            if not (v63 and v63.ghost_clusters_session) then
                return false
            end
            return v63:use({
                source = "MinigameHotbar",
                press_input = v61,
                aim_screen_point = aim_screen_point_2,
                aim_mode = v62
            })
        end)
    end

    function v48.get_cooldown() -- line 364
        return 0.1
    end

    v47.GhostVacuum = v48
    MinigameHotbarApp:on_minigame_start(v47)
    if v46 then
        UIManager.apps.MinigameHotbarApp:set_position_override(UDim2.new(1, -20, 0.785, -20), Vector2.new(1, 1))
        local GhostVacuum = UIManager.apps.MinigameHotbarApp:get_button("GhostVacuum")
        if GhostVacuum then
            GhostVacuum:set_scale_multiplier(1.2)
        end
    end
    v40.leave_maid:GiveTask(function() -- line 378 | captures: v40, v41, v42, ClientToolManager, UIManager
        v40._vacuum_item_unique = nil
        UIManager.apps.MinigameHotbarApp:on_minigame_end()
        local v64 = UIManager.apps.ToolApp.active_tools[v41.unique]
        if v64 and v64.ghost_clusters_session then
            v64.ghost_clusters_session:unequip()
            v64.ghost_clusters_session = nil
        end
        if not v42 then
            task.spawn(ClientToolManager.unequip, v41)
        end
    end)
end

function v3.minigame_interior_render(v65, v66, v67) -- line 392
    for v68, v69 in v66.GhostClusters.Points:GetDescendants() do
        if v69:IsA("BasePart") then
            v69.Transparency = 1
        end
    end
end

local function smoothstep(v70) -- line 401
    return v70 * v70 * (3 - v70 * 2)
end

function v3._play_intro_cutscene(v71) -- line 405 | captures: v1, Spring, InteriorsM, v2, GhostClustersClientConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer
    local Points = InteriorsM.get_current_location().interior.GhostClusters.Points
    local CameraPoints = Points.CameraPoints
    local CFrame_2 = CameraPoints["1"].CFrame
    local CFrame_3 = CameraPoints["2"].CFrame
    local WorldPosition = Points.GroundBounds.GhostPlane.WorldPosition
    v71:_play_match_intro()
    local CurrentCamera = workspace.CurrentCamera
    local FieldOfView = CurrentCamera.FieldOfView
    local v72 = v1.enter({
        disable_controls = true,
        hide_ui = true,
        shown_ui_apps = { "MinigameInGameApp", "MinigameHotbarApp" }
    })
    CurrentCamera.CFrame = CFrame_2
    CurrentCamera.FieldOfView = FieldOfView
    local v73 = false

    local function finish_cutscene() -- line 425 | captures: v73, v71, CurrentCamera, FieldOfView, v72, GhostClustersGhostRenderer
        if v73 then
            return
        end
        v73 = true
        GhostClustersGhostRenderer.stop_intro_entrance()
        v71._finish_intro_cutscene = nil
        CurrentCamera.FieldOfView = FieldOfView
        v72()
    end

    v71._finish_intro_cutscene = finish_cutscene
    v71.leave_maid:GiveTask(finish_cutscene)
    v71:cancel_on_game_start(v2.new(function() -- line 440
    end)):finally(function() -- line 440 | captures: v71
        v71._release_gameplay_messages()
    end)
    local v74 = Spring.new(GhostClustersClientConstants.INTRO_AIM_DAMP, GhostClustersClientConstants.INTRO_AIM_FREQ, WorldPosition + Vector3.new(0, 8, 0))
    local v75 = Spring.new(GhostClustersClientConstants.INTRO_FOV_DAMP, GhostClustersClientConstants.INTRO_FOV_FREQ, FieldOfView)
    local v76 = Spring.new(GhostClustersClientConstants.INTRO_ROLL_DAMP, GhostClustersClientConstants.INTRO_ROLL_FREQ, 0)
    local v77 = os.clock()
    local v78 = v77
    local v79 = GhostClustersPropRenderer.await_mural_model():andThen(function(v80) -- line 456 | captures: v73, v78, v71, CFrame_2, CFrame_3, WorldPosition, CurrentCamera, FieldOfView, v72, v74, v75, v76, v77, GhostClustersClientConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer
        if not v73 then
            GhostClustersGhostRenderer.play_intro_entrance(v80, WorldPosition, CFrame_2.Position, function(v81, v82) -- line 464 | captures: v73, v78, v71, CFrame_2, CFrame_3, WorldPosition, CurrentCamera, FieldOfView, v72, v74, v75, v76, v77, GhostClustersClientConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer
                local v83 = os.clock()
                local v84 = v83 - v78
                local v85 = math.clamp(v84, 0, 0.1)
                v78 = v83
                local v86 = v81.Position + Vector3.new(0, 1, 0) * GhostClustersClientConstants.INTRO_FOCUS_LIFT
                local X = v86.X
                local Y = v86.Y
                local v87 = WorldPosition.Y + 6
                local v88 = math.max(Y, v87)
                local Z = v86.Z
                local v89 = Vector3.new(X, v88, Z)
                v74:set_goal(v89)
                local v90 = v74:update(v85)
                local v91 = CFrame.lookAt(CFrame_2.Position, v90)
                local Y_2 = v91.LookVector.Y
                local v92 = math.clamp(Y_2, 0, 1)
                local v93
                if v82 <= 0 then
                    local v94 = (v83 - v77) * 2.6
                    local v95 = math.sin(v94)
                    local INTRO_DUTCH_DEG = GhostClustersClientConstants.INTRO_DUTCH_DEG
                    v93 = math.rad(INTRO_DUTCH_DEG) * v95 * (v92 * 0.75 + 0.25)
                else
                    v93 = 0
                end
                v76:set_goal(v93)
                local v96 = v91 * CFrame.Angles(0, 0, v76:update(v85))
                local INTRO_FOV_WIDE = GhostClustersClientConstants.INTRO_FOV_WIDE
                local v97 = FieldOfView + (INTRO_FOV_WIDE - FieldOfView) * (1 - v82)
                v75:set_goal(v97)
                CurrentCamera.FieldOfView = v75:update(v85)
                local v98 = v82 * v82 * (3 - v82 * 2)
                CurrentCamera.CFrame = v96:Lerp(CFrame_3, v98)
                if not (v82 >= 1) or v73 then
                    return
                end
                CurrentCamera.CFrame = CFrame_3
                GhostClustersPropRenderer.pulse_cast()
                if v73 then
                    return
                end
                v73 = true
                GhostClustersGhostRenderer.stop_intro_entrance()
                v71._finish_intro_cutscene = nil
                CurrentCamera.FieldOfView = FieldOfView
                v72()
            end)
        end
    end)
    v71.leave_maid:GiveTask(function() -- line 499 | captures: v79
        v79:cancel()
    end)
end

function v3.ingame_app_start_state(v99) -- line 504
    return {
        left = {
            title = "TIME LEFT",
            value = "",
            title_x_alignment = Enum.TextXAlignment.Center
        },
        right = {
            title = "Score",
            value = 0,
            is_value_animated = true
        }
    }
end

function v3._hold_world_music(v100) -- line 519 | captures: Music, SoundDB
    if not v100._world_music_held then
        v100._world_music_held = true
        Music.play(101, SoundDB.Silence)
    end
end

function v3._stop_sound(v101, v102) -- line 527
    if v102 then
        v102:Stop()
    end
end

function v3._fade_sound(v103, v104, v105, v106) -- line 533 | captures: TweenService
    if v104 then
        TweenService:Create(v104, TweenInfo.new(v106, Enum.EasingStyle.Linear), { Volume = v105 }):Play()
    end
end

function v3._start_hunt_music(v107) -- line 540 | captures: SoundService, SoundPlayer
    if v107.is_participating and not (v107._hunt_music or v107._boss_music or v107._buildup) then
        v107._awaiting_hunt_music = false
        local v108 = SoundPlayer.FX:loop("GhostClusters/MusicHuntLoop", SoundService)
        if v108 then
            v107._hunt_music = v108
        end
    end
end

function v3._start_boss_music(v109) -- line 551 | captures: SoundService, SoundPlayer
    if v109.is_participating and not v109._boss_music then
        v109:_stop_sound(v109._hunt_music)
        v109:_stop_sound(v109._buildup)
        v109._hunt_music = nil
        v109._buildup = nil
        local v110 = SoundPlayer.FX:loop("GhostClusters/MusicBossLoop", SoundService)
        if v110 then
            v109._boss_music = v110
        end
    end
end

function v3._play_boss_reveal_sequence(v111, v112) -- line 567 | captures: SoundService, SoundPlayer
    if v111._reveal_queued or v111._boss_music then
        return
    end
    v111._reveal_queued = true
    SoundPlayer.FX:play("GhostClusters/MusicStingerTransition", SoundService)
    task.delay(math.max(v112, 0), function() -- line 573 | captures: v111, SoundService, SoundPlayer
        if not v111.is_participating then
            return
        end
        v111:_stop_sound(v111._buildup)
        v111._buildup = nil
        local v113 = SoundPlayer.FX:play("GhostClusters/BigGhostReveal", SoundService)
        if v113 then
            v113.Ended:Once(function() -- line 581 | captures: v111
                v111:_start_boss_music()
            end)
        else
            v111:_start_boss_music()
        end
    end)
end

function v3._play_match_intro(v114) -- line 590 | captures: SoundService, SoundPlayer
    v114:_hold_world_music()
    v114._awaiting_hunt_music = true
    local v115 = SoundPlayer.FX:play("GhostClusters/Intro", SoundService)
    if v115 then
        v114._intro_sound = v115
        v115.Ended:Once(function() -- line 596 | captures: v114
            v114._intro_sound = nil
            v114:_start_hunt_music()
        end)
    else
        v114:_start_hunt_music()
    end
end

function v3._begin_ghost_buildup(v116, v117) -- line 605 | captures: SoundService, LiveOpsTime, SoundPlayer, GhostClustersConstants
    if not (v116._buildup or v116._boss_music) then
        local v118 = SoundPlayer.FX:loop("GhostClusters/BigGhostBuildUp", SoundService)
        if v118 then
            local Volume = v118.Volume
            v118.Volume = 0
            v116._buildup = v118
            local v119 = v117 + GhostClustersConstants.BOSS_ABSORPTION_SEC - LiveOpsTime.now()
            v116:_fade_sound(v118, Volume, (math.max(v119, 0.5)))
            local _hunt_music = v116._hunt_music
            local v120 = v119 - 3
            v116:_fade_sound(_hunt_music, 0, (math.max(v120, 0.5)))
        end
    end
end

function v3._show_vacuum_hold_hint(v121) -- line 623 | captures: PlatformM, UIManager
    local v122 = PlatformM.get_platform()
    if not (v122 ~= PlatformM.platform.phone and v122 ~= PlatformM.platform.tablet and v122 ~= PlatformM.platform.console) or PlatformM.is_using_gamepad() then
        UIManager.apps.HintApp:hint({
            text = "Press and hold to shoot!",
            overridable = true,
            length = 5,
            yields = false
        })
    end
end

function v3.game_started(v123, v124) -- line 635 | captures: LiveOpsTime, GhostClustersConstants, GhostClustersPropRenderer
    if v123._finish_intro_cutscene then
        v123._finish_intro_cutscene()
    end
    v123:_show_vacuum_hold_hint()
    local intermission_end_time = v123.intermission_end_time
    local boss_breakout_at = v124 and v124.boss_breakout_at or intermission_end_time + GhostClustersConstants.BOSS_BREAKOUT_SEC
    GhostClustersPropRenderer.begin_hunt(intermission_end_time, boss_breakout_at)
    v123:_ensure_progress_billboards()
    v123:_hold_world_music()
    local v125 = LiveOpsTime.now()
    local v126 = boss_breakout_at + GhostClustersConstants.BOSS_ABSORPTION_SEC
    if v126 <= v125 then
        v123:_start_boss_music()
    elseif boss_breakout_at <= v125 then
        v123:_begin_ghost_buildup(boss_breakout_at)
        v123:_play_boss_reveal_sequence(v126 - v125)
    else
        if not v123._awaiting_hunt_music then
            v123:_start_hunt_music()
        end
        local v127 = LiveOpsTime.delay_until(boss_breakout_at - 8)
        v123:cancel_on_game_end(v127:andThen(function() -- line 658 | captures: v123, boss_breakout_at
            v123:_begin_ghost_buildup(boss_breakout_at)
        end))
    end
end

function v3.ghost_clusters_score_msg(v128, v129, v130) -- line 666
    local v131 = v129 - v128._score
    v128._score = v129
    if v128.ingame_app_controller then
        v128.ingame_app_controller:set_right_value(v129)
    end
    if v131 ~= 0 then
        if v130 == "combo" then
            v128:_celebrate_combo()
        else
            v128:_queue_score_popup(v131)
        end
    end
end

local function score_popup_text(v132) -- line 681
    if v132 > 0 then
        return (("+%*"):format(v132))
    end
    return (tostring(v132))
end

local function combo_popup_text(v133) -- line 685
    return (("x%*"):format(v133))
end

local function player_head() -- line 689 | captures: Players
    local Character = Players.LocalPlayer.Character
    local v134 = Character and Character:FindFirstChild("Head")
    if v134 and v134:IsA("BasePart") then
        return v134
    end
    local v135 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v135 and v135:IsA("BasePart") then
        return v135
    end
    return nil
end

function v3._vacuum_target(v136) -- line 699 | captures: UIManager
    local _vacuum_item_unique = v136._vacuum_item_unique
    if _vacuum_item_unique then
        local v137 = UIManager.apps.ToolApp.active_tools[_vacuum_item_unique]
        local v138 = v137 and v137.ghost_clusters_session
        local v139 = v138 and v138.target
        if not (v139 and v139.model.Parent) then
            return nil
        end
        return v139
    end
    return nil
end

function v3._score_popup_anchor(v140) -- line 714 | captures: player_head
    return (player_head())
end

function v3._score_sprout_origin(v141) -- line 718
    local v142 = v141:_vacuum_target()
    if v142 then
        return v142.model:GetPivot().Position
    end
    return nil
end

function v3._queue_score_popup(v143, v144) -- line 730 | captures: ReplicatedStorage, SoundService, GameplayFX, SoundPlayer, GhostClustersClientConstants, v7, v8
    local v145 = v143:_score_sprout_origin()
    if v144 > 0 and v145 then
        GameplayFX.sprout_pickup(v145, v7)
        local v146 = v143:_vacuum_target()
        local v147 = v146 and v146.model.PrimaryPart
        SoundPlayer.FX:play("GhostClusters/Doober", v147 or SoundService)
    end
    local _live_score_popup = v143._live_score_popup
    local v148 = if _live_score_popup == nil then false else v144 > 0 == (_live_score_popup.total > 0)
    if _live_score_popup and v148 and _live_score_popup.popup:can_merge() then
        _live_score_popup.total += v144
        local popup = _live_score_popup.popup
        local total = _live_score_popup.total
        local v149
        if total > 0 then
            v149 = ("+%*"):format(total)
        else
            v149 = tostring(total)
        end
        popup:merge(v149)
    else
        local v150 = v143:_score_popup_anchor()
        if not v150 then
            return
        end
        local create_merging_billboard = GameplayFX.create_merging_billboard
        local ScoreBillboard = ReplicatedStorage.Resources.GhostClusters.ScoreBillboard
        local v151 = if v144 > 0 then v7 else v8
        local v152
        if v144 > 0 then
            v152 = ("+%*"):format(v144)
        else
            v152 = tostring(v144)
        end
        local v153 = create_merging_billboard(ScoreBillboard, v151, v152, v150, GhostClustersClientConstants.SCORE_POPUP_MERGE_SEC, GhostClustersClientConstants.SCORE_POPUP_FLOAT_SEC, {
            side_offset = 2,
            extra_height = -0.2
        })
        if v153 then
            v143._live_score_popup = {
                popup = v153,
                total = v144
            }
        end
    end
end

function v3._punch_score_counter(v154) -- line 772 | captures: TweenService, v9, v12, v13
    local ingame_app_controller = v154.ingame_app_controller
    if not ingame_app_controller then
        return
    end
    local ValueLabel = ingame_app_controller.instance.Body.Right.Container.ValueLabel
    local _combo_counter_scale = v154._combo_counter_scale
    local _combo_counter_scale_2 = _combo_counter_scale
    if not (_combo_counter_scale and _combo_counter_scale.Parent == ValueLabel) then
        _combo_counter_scale = Instance.new("UIScale")
        _combo_counter_scale_2 = _combo_counter_scale
        _combo_counter_scale.Name = "GhostClustersComboPunch"
        _combo_counter_scale.Parent = ValueLabel
        v154._combo_counter_scale = _combo_counter_scale
        v154.leave_maid:GiveTask(_combo_counter_scale)
        v154._combo_counter_color = ValueLabel.TextColor3
    end
    local _combo_counter_color = v154._combo_counter_color
    _combo_counter_scale.Scale = 1
    ValueLabel.TextColor3 = v9
    local v155 = TweenService:Create(_combo_counter_scale, v12, { Scale = 1.35 })
    v155.Completed:Once(function() -- line 792 | captures: _combo_counter_scale_2, ValueLabel, _combo_counter_color, TweenService, v13
        TweenService:Create(_combo_counter_scale_2, v13, { Scale = 1 }):Play()
        TweenService:Create(ValueLabel, v13, { TextColor3 = _combo_counter_color }):Play()
    end)
    v155:Play()
end

function v3._celebrate_combo(v156) -- line 799 | captures: SoundService, GameplayFX, SoundPlayer, ShakePromise, v9, v10, v11, player_head
    local _live_combo_popup = v156._live_combo_popup
    if _live_combo_popup and _live_combo_popup.popup:can_merge() then
        _live_combo_popup.popup:merge(_live_combo_popup.text)
    end
    local v157 = player_head()
    local v158 = v156:_score_sprout_origin() or v157 and v157:GetPivot().Position
    if v158 then
        GameplayFX.emit_poof(v158, 24, 1)
        local v159 = Random.new()
        for v160 = 1, 6 do
            local delay = task.delay
            local v161 = (v160 - 1) * 0.05
            delay(v161, function() -- line 811 | captures: v158, v159, GameplayFX, v9
                local function v162(v163, v164, ...)
                    return (Vector3.new(v163, v164, ...))
                end

                local v165 = v162(v159:NextNumber(-1, 1), v159:NextNumber(0, 1), v159:NextNumber(-1, 1)) * 2.5
                GameplayFX.sprout_pickup(v158 + v165, v9)
            end)
        end
    end
    for v166, v167 in v10 do
        local delay = task.delay
        local v168 = (v166 - 1) * 0.08
        local v169 = v167
        delay(v168, function() -- line 820 | captures: v169, SoundService, SoundPlayer
            SoundPlayer.FX:play("GhostClusters/Doober", SoundService, { playback_speed = v169 })
        end)
    end
    ShakePromise.callback(v11, function(v170) -- line 825
        local CurrentCamera = workspace.CurrentCamera
        CurrentCamera.CFrame *= CFrame.Angles(v170.X, v170.Y, v170.Z)
    end)
    v156:_punch_score_counter()
end

function v3._play_boss_defeat_cutscene(v171) -- line 833 | captures: SoundService, v1, SoundPlayer, InteriorsM, GhostClustersConstants, GhostClustersGhostRenderer
    local CFrame_2 = InteriorsM.get_current_location().interior.GhostClusters.Points.CameraPoints["1"].CFrame
    v171:_stop_vacuum()
    SoundPlayer.FX:play("GhostClusters/GhostComplete", SoundService)
    local CurrentCamera = workspace.CurrentCamera
    local FieldOfView = CurrentCamera.FieldOfView
    local v172 = v1.enter({
        disable_controls = true,
        hide_ui = true,
        shown_ui_apps = { "MinigameInGameApp" }
    })
    CurrentCamera.CFrame = CFrame_2
    CurrentCamera.FieldOfView = FieldOfView
    local v173 = GhostClustersGhostRenderer.play_boss_defeat(function(v174) -- line 850 | captures: CFrame_2, CurrentCamera
        CurrentCamera.CFrame = CFrame.lookAt(CFrame_2.Position, v174 + Vector3.new(0, 6, 0))
    end)
    local v175 = false

    local function finish_cutscene() -- line 855 | captures: v175, CurrentCamera, FieldOfView, v172, v173
        if v175 then
            return
        end
        v175 = true
        v173()
        CurrentCamera.FieldOfView = FieldOfView
        v172()
    end

    local v176 = task.delay(GhostClustersConstants.BOSS_VICTORY_DELAY_SEC, finish_cutscene)
    v171.leave_maid:GiveTask(function() -- line 865 | captures: v175, CurrentCamera, FieldOfView, v172, v173, v176
        if coroutine.status(v176) ~= "dead" then
            task.cancel(v176)
        end
        if v175 then
            return
        end
        v175 = true
        v173()
        CurrentCamera.FieldOfView = FieldOfView
        v172()
    end)
end

function v3.ghost_clusters_boss_captured_msg(v177) -- line 873
    if v177.is_participating then
        v177:_play_boss_defeat_cutscene()
    end
end

local function remote_gun_model(v178) -- line 880 | captures: Players, GhostClustersConstants
    local v179 = Players:GetPlayerByUserId(v178)
    local v180 = v179 and v179.Character
    if v180 then
        local v181 = v180:FindFirstChild(GhostClustersConstants.TOOL_KIND)
        if v181 then
            local ModelHandle = v181:FindFirstChild("ModelHandle")
            if not (ModelHandle and ModelHandle:IsA("Model")) then
                return nil
            end
            return ModelHandle
        end
    end
    return nil
end

local function remote_aim_part(v182, v183) -- line 897 | captures: GhostClustersGhostRenderer, GhostClustersGhosts, GhostClustersPropRenderer
    if v182 == "ghost" then
        local v184 = GhostClustersGhostRenderer.get_visual(v183)
        if v184 then
            return GhostClustersGhosts.beam_anchor(v184)
        end
    else
        local v185 = GhostClustersPropRenderer.get_entry(v183)
        local v186 = v185 and v185.model
        if v186 then
            return v186.PlacementBlock
        end
    end
    return nil
end

function v3._clear_remote_beams(v187) -- line 913
    local _remote_beams = v187._remote_beams
    if _remote_beams then
        for v188, v189 in _remote_beams do
            if v189.fx then
                v189.fx:destroy()
            end
        end
        v187._remote_beams = {}
    end
end

function v3._set_remote_beam(v190, v191, v192, v193, v194) -- line 926 | captures: Players
    if v191 == Players.LocalPlayer.UserId then
        return
    end
    local _remote_beams = v190._remote_beams
    if not _remote_beams then
        _remote_beams = {}
        v190._remote_beams = _remote_beams
    end
    local v195 = _remote_beams[v191]
    if v194 then
        if v195 then
            if v195.kind == v192 and v195.id == v193 then
                return
            end
            if v195.fx then
                v195.fx:destroy()
            end
        end
        _remote_beams[v191] = {
            kind = v192,
            id = v193
        }
    elseif v195 and v195.kind == v192 and v195.id == v193 then
        if v195.fx then
            v195.fx:destroy()
        end
        _remote_beams[v191] = nil
    end
end

function v3._step_remote_beams(v196) -- line 957 | captures: GhostClustersGhostRenderer, GhostClustersGhosts, GhostClustersPropRenderer, GhostVacuumGunFx, remote_gun_model
    local _remote_beams = v196._remote_beams
    if _remote_beams then
        for v197, v198 in _remote_beams do
            if v198.fx then
                if v198.model then
                    if not v198.model.Parent then
                        v198.fx:destroy()
                        v198.fx = nil
                        v198.model = nil
                    end
                else
                    v198.fx:destroy()
                    v198.fx = nil
                    v198.model = nil
                end
            end
            local kind = v198.kind
            local id = v198.id
            local v199
            if kind == "ghost" then
                local v200 = GhostClustersGhostRenderer.get_visual(id)
                if v200 then
                    v199 = GhostClustersGhosts.beam_anchor(v200)
                end
            else
                local v201 = GhostClustersPropRenderer.get_entry(id)
                local v202 = v201 and v201.model
                if v202 then
                    v199 = v202.PlacementBlock
                end
            end
            local v203 = remote_gun_model(v197)
            if v199 and v203 then
                if v198.model ~= v203 then
                    if v198.fx then
                        v198.fx:destroy()
                    end
                    v198.fx = GhostVacuumGunFx.attach(v203)
                    v198.model = v203
                end
                v198.fx:hold_on(v199)
            elseif v198.fx then
                v198.fx:release()
            end
        end
    end
end

function v3.ghost_clusters_vacuum_beam_msg(v204, v205, v206, v207, v208) -- line 987
    v204:_set_remote_beam(v205, v206, v207, v208)
end

function v3.ghost_clusters_vacuum_beams_msg(v209, v210) -- line 996
    for v211, v212 in v210 do
        v209:_set_remote_beam(v212[1], v212[2], v212[3], true)
    end
end

function v3.ghost_clusters_props_msg(v213, v214) -- line 1002 | captures: GhostClustersPropRenderer
    v213:_enqueue_gameplay_message(function() -- line 1003 | captures: v214, GhostClustersPropRenderer
        GhostClustersPropRenderer.sync(v214)
    end)
end

function v3.ghost_clusters_cast_wave_msg(v215, v216) -- line 1008 | captures: GhostClustersPropRenderer
    v215:_enqueue_gameplay_message(function() -- line 1009 | captures: v216, GhostClustersPropRenderer
        GhostClustersPropRenderer.play_cast_wave(v216)
    end)
end

function v3._mount_boss_bar(v217) -- line 1014 | captures: UIManager
    if v217._boss_bar_mounted then
        return
    end
    v217._boss_bar_mounted = true
    UIManager.set_app_visibility("GhostClustersBossBarApp", true)
    v217.leave_maid:GiveTask(function() -- line 1020 | captures: v217, UIManager
        v217._boss_bar_mounted = false
        UIManager.set_app_visibility("GhostClustersBossBarApp", false)
    end)
end

function v3.ghost_clusters_boss_breakout_msg(v218) -- line 1026 | captures: GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer
    v218:_enqueue_gameplay_message(function() -- line 1027 | captures: v218, GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersPropRenderer
        local v219 = GhostClustersPropRenderer.get_mural_position()
        GhostClustersPropRenderer.begin_breakout()
        GhostClustersGhostRenderer.absorb_toward(v219, GhostClustersConstants.BOSS_ABSORPTION_SEC)
        v218:_mount_boss_bar()
        v218:_play_boss_reveal_sequence(GhostClustersConstants.BOSS_ABSORPTION_SEC)
    end)
end

function v3.ghost_clusters_cleanup_props_msg(v220) -- line 1036 | captures: GhostClustersPropRenderer
    v220:_enqueue_gameplay_message(function() -- line 1037 | captures: GhostClustersPropRenderer
        GhostClustersPropRenderer.cleanup_non_mural()
    end)
end

function v3.ghost_clusters_prop_resolved_msg(v221, v222, v223) -- line 1042 | captures: SoundService, SoundPlayer, GhostClustersPropRenderer
    local v224 = GhostClustersPropRenderer.get_entry(v222)
    local v225 = v221:_vacuum_target()
    local v226 = if v225 == nil then false else v225.is_prop and v225.id == v222
    if v224 and v224.is_mural or v226 then
        if v223 then
            local v227 = v224 and v224.model and v224.model.PrimaryPart
            SoundPlayer.FX:play("GhostClusters/GhostAppear", v227 or SoundService)
        elseif v226 then
            SoundPlayer.FX:play("GhostClusters/NoGhosts", SoundService)
        end
    end
    GhostClustersPropRenderer.set_resolved(v222, v223)
end

function v3.ghost_clusters_prop_restored_msg(v228, v229) -- line 1059 | captures: GhostClustersPropRenderer
    GhostClustersPropRenderer.restore(v229)
end

function v3.ghost_clusters_prop_progress_msg(v230, v231, v232) -- line 1063 | captures: GhostClustersPropRenderer
    GhostClustersPropRenderer.set_flush_alpha(v231, v232)
end

function v3.ghost_clusters_retarget_msg(v233, v234) -- line 1067 | captures: UIManager, GhostClustersConstants, GhostClustersGhostRenderer
    local v235 = UIManager.apps.ToolApp.active_tools[v233._vacuum_item_unique]
    local v236 = v235 and v235.ghost_clusters_session
    local v237 = GhostClustersGhostRenderer.get_visual(v234)
    if v236 and v237 then
        v236:retarget(v237, v234, v237:GetAttribute(GhostClustersConstants.GHOST_ATTR.Size))
    end
end

function v3.ghost_clusters_attack_windup_msg(v238, v239, v240, v241, v242) -- line 1076 | captures: SoundService, SoundPlayer, GhostClustersConstants, GhostClustersGhostRenderer
    GhostClustersGhostRenderer.begin_attack(v239, v240, v242)
    local v243 = GhostClustersGhostRenderer.get_visual(v239)
    local v244, v245
    if v243 then
        v245 = v243:GetAttribute(GhostClustersConstants.GHOST_ATTR.Size)
        v244 = v243.PrimaryPart
    else
        v245 = v243
        v244 = SoundService
    end
    if not (v245 == "Large" and v240 == "tornado") then
        SoundPlayer.FX:play("GhostClusters/GhostAttack", v244)
    else
        SoundPlayer.FX:play("GhostClusters/BigGhostGravityAttack", v244)
    end
end

function v3.ghost_clusters_attack_fire_msg(v246, v247, v248, v249, v250, v251) -- line 1088 | captures: Players, MinigameRagdoll, GhostClustersConstants, GhostClustersGhostRenderer
    local v252 = GhostClustersGhostRenderer.get_visual(v247)
    local v253, v254
    if v252 then
        v254 = v252:GetAttribute(GhostClustersConstants.GHOST_ATTR.Size)
        v253 = v252:GetPivot().Position
    else
        v254 = v252
        v253 = v249
    end
    GhostClustersGhostRenderer.fire_attack(v247)
    GhostClustersGhostRenderer.play_attack_burst(v253, v250, v248)
    if v248 == "tornado" and v254 == "Large" then
        return
    end
    GhostClustersGhostRenderer.schedule_end_attack(v247)
    local Character = Players.LocalPlayer.Character
    local v255 = Character and Character.PrimaryPart
    if not v255 or v250 < (v255.Position - v249).Magnitude then
        return
    end
    v246:_stop_vacuum()
    local v256 = v255.Position.X - v249.X
    local v257 = v255.Position.Z - v249.Z
    local v258 = Vector3.new(v256, 0, v257)
    if v258.Magnitude < 0.05 then
        v258 = Vector3.new(1, 0, 0)
    end
    MinigameRagdoll.fling(v258.Unit * v251 + Vector3.new(0, 1, 0) * GhostClustersConstants.ATTACK_UP_IMPULSE, GhostClustersConstants.ATTACK_FLING_SEC, true, true)
end

function v3._step_auto_aim_vacuum_button(v259) -- line 1119 | captures: PlatformM, UIManager
    local v260 = PlatformM.get_platform()
    if v260 ~= PlatformM.platform.phone and v260 ~= PlatformM.platform.tablet and v260 ~= PlatformM.platform.console and not PlatformM.is_using_gamepad() then
        return
    end
    local GhostVacuum = UIManager.apps.MinigameHotbarApp:get_button("GhostVacuum")
    local v261, v262
    if GhostVacuum then
        if GhostVacuum.using then
            v262 = true
        else
            local v263 = UIManager.apps.ToolApp.active_tools[v259._vacuum_item_unique]
            v261 = v263 and v263.ghost_clusters_session
            v262 = false
        end
    else
        v262 = true
    end
    if v262 then
        return
    end
    if v261 then
        local v264 = if v261:get_auto_target() == nil then false else not v259:_is_vacuum_blocked()
        GhostVacuum:set_enabled(v264)
    end
end

function v3._stop_vacuum(v265) -- line 1135 | captures: UIManager
    local v266 = UIManager.apps.ToolApp.active_tools[v265._vacuum_item_unique]
    local v267 = v266 and v266.ghost_clusters_session
    if v267 then
        v267:stop()
    end
end

function v3._is_vacuum_blocked(v268) -- line 1143 | captures: Players, MinigameRagdoll, GhostClustersConstants
    if v268._player_orbit or MinigameRagdoll.is_enabled() then
        return true
    end
    local Character = Players.LocalPlayer.Character
    local v269 = Character and Character:FindFirstChild("Humanoid")
    if v269 == nil then
        return false
    end
    return v269:IsA("Humanoid") and GhostClustersConstants.is_vacuum_ragdolled(v269)
end

function v3._destroy_player_tornado_force(v270) -- line 1152
    local _player_orbit = v270._player_orbit
    if _player_orbit then
        if _player_orbit.force.Parent then
            _player_orbit.force:Destroy()
        end
        if _player_orbit.attachment.Parent then
            _player_orbit.attachment:Destroy()
        end
    end
end

function v3._clear_player_tornado(v271) -- line 1165 | captures: MinigameRagdoll
    v271:_destroy_player_tornado_force()
    v271._player_orbit = nil
    MinigameRagdoll.disable("ghost_clusters_tornado")
end

function v3._step_player_tornado_orbit(v272, v273) -- line 1171 | captures: Players, GhostClustersConstants, GhostClustersGhostRenderer, GhostClustersMotion
    local _player_orbit = v272._player_orbit
    if not _player_orbit then
        return
    end
    local v274 = GhostClustersGhostRenderer.get_large_position()
    local Character = Players.LocalPlayer.Character
    local v275 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v274 and v275 and v275:IsA("BasePart") and _player_orbit.force.Parent) then
        return
    end
    local v276 = GhostClustersMotion.tornado_desired_velocity(v275.Position, v274, _player_orbit.target_radius)
    local v277 = (GhostClustersMotion.approach_velocity(v275.AssemblyLinearVelocity, v276, v273, GhostClustersConstants.BOSS_TORNADO_VELOCITY_RESPONSE) - v275.AssemblyLinearVelocity) / v273 + Vector3.new(0, 1, 0) * workspace.Gravity
    _player_orbit.force.Force = v277 * v275.AssemblyMass
end

function v3.ghost_clusters_tornado_catch_msg(v278, v279) -- line 1193 | captures: Players, SoundService, SoundPlayer, MinigameRagdoll, GhostClustersConstants, GhostClustersGhostRenderer
    if typeof(v279) ~= "number" then
        return
    end
    v278:_stop_vacuum()
    SoundPlayer.FX:play("GhostClusters/BigGhostGravityHit", SoundService)
    v278:_destroy_player_tornado_force()
    v278._player_orbit = nil
    local Character = Players.LocalPlayer.Character
    local v280 = Character and Character:FindFirstChild("HumanoidRootPart")
    local v281
    if v280 and v280:IsA("BasePart") then
        MinigameRagdoll.enable("ghost_clusters_tornado")
        local Attachment = Instance.new("Attachment")
        Attachment.Name = "GhostClustersTornadoAttachment"
        Attachment.Parent = v280
        local VectorForce = Instance.new("VectorForce")
        VectorForce.Name = "GhostClustersTornadoForce"
        VectorForce.Attachment0 = Attachment
        VectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        VectorForce.ApplyAtCenterOfMass = true
        VectorForce.Parent = v280
        v278._player_orbit = {
            target_radius = v279,
            force = VectorForce,
            attachment = Attachment
        }
        local v282 = GhostClustersGhostRenderer.get_large_position()
        v281 = Vector3.new(1, 0, 0)
        if v282 then
            local v283 = v280.Position.X - v282.X
            local v284 = v280.Position.Z - v282.Z
            local v285 = Vector3.new(v283, 0, v284)
            if v285.Magnitude > 0.35 then
                local Unit = v285.Unit
                local v286 = -Unit.Z
                local X = Unit.X
                v281 = Vector3.new(v286, 0, X)
            end
        end
    else
        return
    end
    v280.AssemblyLinearVelocity += v281 * 8 + Vector3.new(0, 1, 0) * GhostClustersConstants.BOSS_TORNADO_INITIAL_LIFT
    v280.AssemblyAngularVelocity = Vector3.new(1.600000023841858, 2.4000000953674316, 0.8999999761581421)
end

function v3.ghost_clusters_tornado_release_msg(v287) -- line 1236 | captures: MinigameRagdoll
    v287:_destroy_player_tornado_force()
    v287._player_orbit = nil
    v287.leave_maid:GiveTask(task.delay(0.5, function() -- line 1239 | captures: v287, MinigameRagdoll
        if not v287._player_orbit then
            MinigameRagdoll.disable("ghost_clusters_tornado")
        end
    end))
end

function v3.ghost_clusters_attack_end_msg(v288, v289) -- line 1247 | captures: GhostClustersGhostRenderer
    GhostClustersGhostRenderer.end_attack(v289)
end

function v3._ensure_progress_billboards(v290) -- line 1251 | captures: RunService, GhostClustersConstants, GhostClustersProgressBar, v6
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    local v291 = workspace[GhostClustersConstants.VISUAL_FOLDER_NAME]

    local function attach(v292) -- line 1255 | captures: GHOST_ATTR, RunService, GhostClustersConstants, GhostClustersProgressBar, v6
        local function v293(...)
            return (typeof(...))
        end

        if v293(v292:GetAttribute(GHOST_ATTR.Id)) ~= "string" then
            return
        end
        local v294 = v292:GetAttribute(GHOST_ATTR.Size)
        if v294 == "Large" or v292:FindFirstChild("GhostClustersProgressGui") then
            return
        end
        local v295 = v292.PrimaryPart or v292.RootPart
        local create = GhostClustersProgressBar.create
        local v296 = {
            name = "GhostClustersProgressGui",
            studs_offset = Vector3.new(0, 6, 0),
            parent = v295,
            size = UDim2.fromOffset(160, 18)
        }
        v296.fill_color = v6[v294] or v6.Small
        local v297 = create(v296)
        local gui = v297.gui
        gui.Enabled = false
        local fill = v297.fill
        local v298 = v292:GetAttribute(GHOST_ATTR.Progress) or 0
        local v299 = os.clock()
        local v300

        local function refresh_fill() -- line 1280 | captures: v298, v299, v292, fill, GHOST_ATTR, GhostClustersConstants, GhostClustersProgressBar
            local v301 = v292:GetAttribute(GHOST_ATTR.ProgressRequired) or 1
            local v302 = v298
            if v292:GetAttribute(GHOST_ATTR.VacuumLocked) == true then
                local v303 = v302 + GhostClustersConstants.PROGRESS_PER_SEC_PER_PLAYER * (os.clock() - v299)
                local v304 = v301 * 0.98
                v302 = math.min(v303, v304)
            end
            GhostClustersProgressBar.set_remaining(fill, 1 - v302 / math.max(v301, 0.001))
        end

        local function refresh_visibility() -- line 1291 | captures: v300, v292, gui, refresh_fill, GHOST_ATTR, RunService
            local v305 = v292:GetAttribute(GHOST_ATTR.BeingVacuumed) == true
            gui.Enabled = v305
            if v305 then
                v300 = v300 or RunService.RenderStepped:Connect(refresh_fill)
                refresh_fill()
            elseif v300 then
                v300:Disconnect()
                v300 = nil
            end
        end

        local v306 = v292:GetAttribute(GHOST_ATTR.BeingVacuumed) == true
        gui.Enabled = v306
        if v306 then
            v300 = v300 or RunService.RenderStepped:Connect(refresh_fill)
            refresh_fill()
        elseif v300 then
            v300:Disconnect()
            v300 = nil
        end
        v292:GetAttributeChangedSignal(GHOST_ATTR.Progress):Connect(function() -- line 1305 | captures: v298, v299, v292, gui, refresh_fill, GHOST_ATTR
            v298 = v292:GetAttribute(GHOST_ATTR.Progress) or 0
            v299 = os.clock()
            if gui.Enabled then
                refresh_fill()
            end
        end)
        v292:GetAttributeChangedSignal(GHOST_ATTR.ProgressRequired):Connect(function() -- line 1312 | captures: gui, refresh_fill
            if gui.Enabled then
                refresh_fill()
            end
        end)
        v292:GetAttributeChangedSignal(GHOST_ATTR.BeingVacuumed):Connect(refresh_visibility)
        gui.AncestryChanged:Connect(function(v307, v308) -- line 1318 | captures: v300
            if not v308 and v300 then
                v300:Disconnect()
                v300 = nil
            end
        end)
    end

    for v309, v310 in v291:GetChildren() do
        if v310:IsA("Model") then
            attach(v310)
        end
    end
    if v290._billboard_added_connection then
        v290._billboard_added_connection:Disconnect()
    end
    v290._billboard_added_connection = v291.ChildAdded:Connect(function(v311) -- line 1334 | captures: attach
        if v311:IsA("Model") then
            task.defer(attach, v311)
        end
    end)
end

function v3._step_combo_popup(v312) -- line 1344 | captures: ReplicatedStorage, GameplayFX, GhostClustersClientConstants, GhostClustersConstants, v9, player_head
    local v313 = v312:_vacuum_target()
    local v314, v315
    if v313 then
        if v313.is_prop then
            v315 = 1
        else
            local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
            if v313.model:GetAttribute(GHOST_ATTR.Size) == "Large" then
                v315 = 1
            else
                v314, v315 = v313.model:GetAttribute(GHOST_ATTR.Id), v313.model:GetAttribute(GHOST_ATTR.CombineMass) or 1
            end
        end
    else
        v315 = 1
    end
    local _live_combo_popup = v312._live_combo_popup
    if typeof(v314) ~= "string" or v315 <= 1 then
        if _live_combo_popup then
            _live_combo_popup.popup:release()
            v312._live_combo_popup = nil
        end
    else
        local v316 = ("x%*"):format(v315)
        if _live_combo_popup and _live_combo_popup.ghost_id == v314 and _live_combo_popup.popup:can_merge() then
            if _live_combo_popup.text ~= v316 then
                _live_combo_popup.popup:merge(v316)
                _live_combo_popup.text = v316
            end
        else
            if _live_combo_popup then
                _live_combo_popup.popup:release()
                v312._live_combo_popup = nil
            end
            local v317 = player_head()
            if v317 then
                local v318 = GameplayFX.create_merging_billboard(ReplicatedStorage.Resources.BucksBillboard, v9, v316, v317, GhostClustersClientConstants.SCORE_POPUP_MERGE_SEC, GhostClustersClientConstants.SCORE_POPUP_FLOAT_SEC, {
                    hold_open = true,
                    hide_image = true,
                    side_offset = 3.4,
                    extra_height = 1.4
                })
                if v318 then
                    v312._live_combo_popup = {
                        popup = v318,
                        ghost_id = v314,
                        text = v316
                    }
                end
            end
        end
    end
end

function v3.post_exit_minigame(v319, v320) -- line 1403 | captures: Music, SoundDB
    v319:_stop_sound(v319._intro_sound)
    v319:_stop_sound(v319._hunt_music)
    v319:_stop_sound(v319._buildup)
    v319:_stop_sound(v319._boss_music)
    v319._intro_sound = nil
    v319._hunt_music = nil
    v319._buildup = nil
    v319._boss_music = nil
    v319._awaiting_hunt_music = false
    v319._reveal_queued = false
    if v319._world_music_held then
        Music.stop(101, SoundDB.Silence)
        v319._world_music_held = false
    end
    v319:_clear_player_tornado()
    if v319._billboard_added_connection then
        v319._billboard_added_connection:Disconnect()
        v319._billboard_added_connection = nil
    end
end

return v3

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Minigames.GhostClustersMinigameServer
-- Took 0.85s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerScriptService = game:GetService("ServerScriptService")
local ContentPackAssetsServer = require(ServerScriptService.new.modules.ContentPacks.ContentPackAssetsServer)
local load = require(ReplicatedStorage.Fsys).load
local AltCurrencyData = load("AltCurrencyData")
local Class = load("Class")
local CloudValues = load("CloudValues")
local DataM = load("DataM")
local InventoryDB = load("InventoryDB")
local LiveOpsTime = load("LiveOpsTime")
local MinigameServer = load("MinigameServer")
local v1 = load("new:PersistentPerPlayerConcurrencyServer")
local v2 = load("package:Promise")
local v3 = load("package:Sift")
local v4 = load("package:Stash")
local TableUtil = load("TableUtil")
local GhostClustersConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersConstants)
local GhostClustersLeaderboard = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersLeaderboard)
local GhostClustersGhosts = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersGhosts)
local GhostClustersHauntProps = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersHauntProps)
local GhostClustersMotion = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersMotion)
local GhostClustersMotionCodec = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersMotionCodec)
local GhostClustersNavMesh = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersNavMesh)
local GhostClustersNet = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersNet)

local function tuning(v5) -- line 63 | captures: CloudValues
    return CloudValues:getValue("ghost_clusters", v5)
end

local function owns_vacuum(v6, v7) -- line 67
    for v8, v9 in v6:get_items_with_id(v7) do
        if not v9.properties.ghost_clusters_loan then
            return true
        end
    end
    return false
end

local function grant_minigame_vacuum(v10) -- line 76 | captures: DataM, InventoryDB, GhostClustersConstants
    local inventory = DataM.get_store(v10):get("inventory")
    local v11 = false
    local v12
    for v13, v14 in inventory:get_items_with_id(GhostClustersConstants.GOLD_TOY_KIND) do
        if not v14.properties.ghost_clusters_loan then
            v12 = true
            v11 = true
            break
        end
    end
    if not v11 then
        v12 = false
    end
    if v12 then
        return
    end
    local v15 = false
    local v16
    for v17, v18 in inventory:get_items_with_id(GhostClustersConstants.TOY_KIND) do
        if not v18.properties.ghost_clusters_loan then
            v16 = true
            v15 = true
            break
        end
    end
    if not v15 then
        v16 = false
    end
    if not v16 then
        inventory:add_item(InventoryDB.toys[GhostClustersConstants.TOY_KIND], { ghost_clusters_loan = true }, true)
    end
end

local function suppress_potion_effects(v19) -- line 89 | captures: DataM
    local Character = v19.Character
    if Character then
        local Humanoid = Character:FindFirstChild("Humanoid")
        local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
        local v20 = Humanoid and Humanoid:FindFirstChild("GrowPotionCompleted") ~= nil
        if v20 then
            Humanoid.GrowPotionCompleted:Destroy()
        end
        local v21 = HumanoidRootPart and HumanoidRootPart:FindFirstChild("LevitateEffect")
        if v21 then
            v21.Parent = nil
        end
        if v20 then
            DataM.get_store(v19):get("avatar_manager").appearance_controllers.player:mark_updated()
        end
        return function() -- line 112 | captures: v19, v20, v21, DataM
            local Character = v19.Character
            if not Character then
                return
            end
            local Humanoid = Character:FindFirstChild("Humanoid")
            local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
            if v20 and Humanoid and not Humanoid:FindFirstChild("GrowPotionCompleted") then
                local BoolValue = Instance.new("BoolValue")
                BoolValue.Name = "GrowPotionCompleted"
                BoolValue.Parent = Humanoid
            end
            if v21 and HumanoidRootPart and not HumanoidRootPart:FindFirstChild("LevitateEffect") then
                v21.Parent = HumanoidRootPart
            end
            if v20 and Humanoid then
                DataM.get_store(v19):get("avatar_manager").appearance_controllers.player:mark_updated()
            end
        end
    end
    return function() -- line 92
    end
end

local function revoke_minigame_vacuum(v22) -- line 134 | captures: DataM, GhostClustersConstants
    if v22.Parent == game.Players then
        local inventory = DataM.get_store(v22):get("inventory")
        for v23, v24 in inventory:get_items_with_id(GhostClustersConstants.TOY_KIND) do
            if v24.properties.ghost_clusters_loan then
                inventory:delete_item(v24)
            end
        end
    end
end

local function contributor_drain_weight(v25) -- line 146 | captures: DataM, GhostClustersConstants
    local toys = DataM.get_store(v25):get("equip_manager"):get_equipped().toys
    if not (toys and toys.kind == GhostClustersConstants.GOLD_TOY_KIND) then
        return 1
    end
    return GhostClustersConstants.GOLD_DRAIN_MULTIPLIER
end

local function boss_progress_per_sec(v26, v27, v28) -- line 155 | captures: CloudValues, GhostClustersConstants
    local v29 = v26 / (GhostClustersConstants.PROGRESS_PER_SEC_PER_PLAYER * CloudValues:getValue("ghost_clusters", "boss_drain_multiplier")) - GhostClustersConstants.BOSS_EXTRA_PLAYER_DRAIN_SAVE_SEC * (v27 - 1)
    local v30 = math.max(v29, 0.05)
    local BOSS_SHIELD_THRESHOLDS = GhostClustersConstants.BOSS_SHIELD_THRESHOLDS
    local v31 = (BOSS_SHIELD_THRESHOLDS[v28 - 1] or 1) - (BOSS_SHIELD_THRESHOLDS[v28] or 0)
    local v32 = v30 * v31 + CloudValues:getValue("ghost_clusters", "boss_stretch_extra_sec")[v28]
    return v26 * v31 / v32
end

local function summed_drain_weight(v33) -- line 166
    local v34 = 0
    for v35, v36 in v33 do
        v34 += v36.weight
    end
    return v34
end

local function combined_drain_weight(v37) -- line 174 | captures: GhostClustersConstants
    local v38 = 0
    local v39 = 0
    for v40, v41 in v37 do
        v38 += v41.weight
        local weight = v41.weight
        v39 = math.max(v39, weight)
    end
    local v42 = v38 - v39
    local v43 = math.max(0, v42)
    local v44 = v39 + GhostClustersConstants.DRAIN_ASSIST_SCALE * math.sqrt(v43)
    local DRAIN_MAX_COMBINED_WEIGHT = GhostClustersConstants.DRAIN_MAX_COMBINED_WEIGHT
    return (math.min(v44, DRAIN_MAX_COMBINED_WEIGHT))
end

local v45 = Class("GhostClustersMinigameServer", MinigameServer)

function v45.init(v46) -- line 190 | captures: ContentPackAssetsServer, GhostClustersGhosts, GhostClustersNavMesh
    v46.interior = ContentPackAssetsServer.get_asset("Interiors", v46.minigame_destination_id)
    v46.navmesh = GhostClustersNavMesh.build(v46.interior)
    v46.live_folder_name = v46.minigame_id
    v46.ghosts = {}
    v46.props = {}
    v46.active_vacuum_by_player = {}
    v46.active_prop_by_player = {}
    v46.score_by_user = {}
    v46.large_id = nil
    v46.mural = nil
    v46.slot_pool = GhostClustersGhosts.create_slot_pool()
    v46.motion_accumulator = 0
    v46._motion_epoch = 0
    v46.heartbeat_connection = nil
    v46._round_prepared = false
    v46._round_active = false
    v46._boss_phase = false
    v46._boss_defeated = false
    v46._cast_threads = {}
    v46._clock_promise = nil
    v46._boss_breakout_at = 0
    v46._boss_spawn_at = 0
    v46._boss_waypoints = nil
    v46._boss_shield_thresholds_left = {}
    v46._shield_ghost_ids = {}
    v46._last_drain_at = {}
    v46._boss_shielded = false
    v46._boss_menace_target = nil
    v46._boss_menace_until = 0
    v46._boss_dip_at = 0
    v46._boss_dip_started = nil
    v46._boss_wander_angle = 0
    v46._boss_drift = Vector3.new(1, 0, 0)
    v46._boss_waypoint_index = 1
    v46._boss_stop_count = 0
    v46._boss_at_stop = false
    v46._boss_skip_until = 0
    v46._orbiting_players = {}
    v46._next_prop_progress_push_at = {}
    v46._prop_restore_at = {}
end

function v45._resolve_floor(v47, v48, v49, v50) -- line 234
    return v47.navmesh:resolve_move(v48, v49, v50)
end

function v45._floor_cframe_near(v51, v52) -- line 238
    local v53 = v51.navmesh:project(v52)
    return CFrame.new(v53)
end

function v45._reset_candy(v54, v55) -- line 243
    local score_by_user = v54.score_by_user
    local UserId = v55.UserId
    score_by_user[tostring(UserId)] = {
        raw = 0,
        replicated = 0,
        batch_at = nil,
        combos = 0
    }
end

function v45._score_record(v56, v57) -- line 252
    local UserId = v57.UserId
    local v58 = tostring(UserId)
    local v59 = v56.score_by_user[v58]
    if v59 then
        return v59
    end
    local v60 = {
        raw = 0,
        replicated = 0,
        batch_at = nil,
        combos = 0
    }
    v56.score_by_user[v58] = v60
    return v60
end

function v45._get_score(v61, v62) -- line 268
    return v61:_score_record(v62).raw
end

function v45._displayed_score(v63, v64) -- line 274 | captures: GhostClustersConstants
    local SCORE_DISPLAY_STEP = GhostClustersConstants.SCORE_DISPLAY_STEP
    local v65 = v63:_get_score(v64) / SCORE_DISPLAY_STEP
    return math.floor(v65) * SCORE_DISPLAY_STEP
end

function v45._flush_score(v66, v67, v68, v69) -- line 279 | captures: GhostClustersConstants
    local v70 = v66:_score_record(v67)
    local v71 = v66:_displayed_score(v67)
    if v71 == v70.replicated then
        return
    end
    local v72 = os.clock()
    if not v68 then
        local batch_at = v70.batch_at
        if batch_at == nil then
            v70.batch_at = v72
            return
        end
        if v72 - batch_at < GhostClustersConstants.SCORE_REPLICATE_SEC then
            return
        end
    end
    v70.replicated = v71
    v70.batch_at = nil
    v66:message_player(v67, "ghost_clusters_score", v71, v69)
end

function v45._add_score(v73, v74, v75, v76, v77) -- line 301
    if v75 == 0 then
        return
    end
    if v76 then
        v73:_flush_score(v74, true)
    end
    local v78 = v73:_score_record(v74)
    local v79 = v78.raw + v75
    v78.raw = math.max(0, v79)
    v73:_flush_score(v74, v76 == true, v77)
end

function v45._active_player_count(v80) -- line 318 | captures: GhostClustersConstants
    local v81 = os.clock() - GhostClustersConstants.SHIELD_ACTIVE_PLAYER_WINDOW_SEC
    local v82 = 0
    for v83, v84 in v80.minigame_players:get_as_list() do
        local v85 = v80._last_drain_at[v84]
        if v85 and v81 <= v85 then
            v82 += 1
        end
    end
    return (math.max(1, v82))
end

function v45._all_alive_ghosts(v86) -- line 330
    local v87 = {}
    for v88, v89 in v86.ghosts do
        if v89.alive then
            table.insert(v87, v89)
        end
    end
    return v87
end

function v45._broadcast_vacuum_beam(v90, v91, v92, v93, v94) -- line 340
    v90:message_all_players("ghost_clusters_vacuum_beam", v91.UserId, v92, v93, v94)
end

function v45._vacuum_beam_snapshot(v95) -- line 349
    local v96 = {}
    for v97, v98 in v95.ghosts do
        for v99 in v98.contributors do
            local v100 = {
                v99.UserId,
                "ghost",
                v98.id
            }
            table.insert(v96, v100)
        end
    end
    for v101, v102 in v95.props do
        for v103 in v102.contributors do
            local v104 = {
                v103.UserId,
                "prop",
                v102.unique
            }
            table.insert(v96, v104)
        end
    end
    return v96
end

function v45._destroy_ghost(v105, v106) -- line 364 | captures: GhostClustersGhosts
    local v107 = v105.ghosts[v106]
    if not v107 then
        return
    end
    for v108 in v107.contributors do
        v105:_flush_score(v108, true)
        v105:_broadcast_vacuum_beam(v108, "ghost", v106, false)
    end
    GhostClustersGhosts.destroy(v107)
    v105.ghosts[v106] = nil
    for v109, v110 in v105.active_vacuum_by_player do
        if v110.ghost_id == v106 then
            v105.active_vacuum_by_player[v109] = nil
        end
    end
    if v105.large_id == v106 then
        v105.large_id = nil
    end
    if v105._shield_ghost_ids[v106] then
        v105._shield_ghost_ids[v106] = nil
        if v105._boss_shielded and next(v105._shield_ghost_ids) == nil then
            v105:_lower_boss_shield()
        end
    end
end

function v45._spawn_ghost(v111, v112) -- line 391 | captures: v1, GhostClustersGhosts
    local v113 = v111:_floor_cframe_near(v112.cframe.Position)
    local v114 = GhostClustersGhosts.spawn({
        size = v112.size,
        cframe = v113,
        model_name = v112.model_name,
        slot_pool = v111.slot_pool,
        live_folder_name = v111.live_folder_name
    })
    v114.roam_target = v111.navmesh:pick_point_near(v113.Position)
    for v115, v116 in v111.minigame_players:get_as_list() do
        v1.add(v114.model, v116, "ghost_clusters_ghost")
    end
    v111.ghosts[v114.id] = v114
    return v114
end

function v45._destroy_all_ghosts(v117) -- line 412
    for v118 in v117.ghosts do
        v117:_destroy_ghost(v118)
    end
end

local function player_hrp(v119) -- line 418
    local Character = v119.Character
    local v120 = Character and Character:FindFirstChild("HumanoidRootPart")
    if v120 and v120:IsA("BasePart") then
        return v120
    end
    return nil
end

local function is_grounded_for_vacuum(v121) -- line 427 | captures: GhostClustersConstants
    local Character = v121.Character
    local v122 = Character and Character:FindFirstChild("Humanoid")
    if v122 and v122:IsA("Humanoid") then
        return not GhostClustersConstants.is_vacuum_ragdolled(v122)
    end
    return false
end

local function can_player_vacuum(v123, v124) -- line 436 | captures: GhostClustersConstants
    local v125, v126, v127
    if v124.Parent == nil then
        v126 = false
        v127 = true
    else
        local v128 = v123:is_participating(v124)
        if v128 then
            local Character = v124.Character
            v125 = Character and Character:FindFirstChild("Humanoid")
            v127 = false
        else
            v126 = v128
            v127 = true
        end
    end
    if not v127 then
        if not (v125 and v125:IsA("Humanoid")) then
            return false
        end
        v126 = not GhostClustersConstants.is_vacuum_ragdolled(v125)
    end
    return v126
end

local function is_valid_contributor(v129, v130, v131, v132) -- line 440 | captures: GhostClustersConstants
    if not (v130.size == "Large" and v129._boss_shielded) and not (v130.orbiting or v129._orbiting_players[v131]) then
        local v133
        if v131.Parent == nil then
            v133 = false
        else
            v133 = v129:is_participating(v131)
            if v133 then
                local Character = v131.Character
                if Character then
                    Character = Character:FindFirstChild("Humanoid")
                    if Character and Character:IsA("Humanoid") then
                        v133 = not GhostClustersConstants.is_vacuum_ragdolled(Character)
                    else
                        v133 = false
                    end
                else
                    v133 = false
                end
            end
        end
        if v133 then
            local Character = v131.Character
            local v134 = Character and Character:FindFirstChild("HumanoidRootPart")
            if not (v134 and v134:IsA("BasePart")) then
                v134 = nil
            end
            local v135
            if v134 then
                if v129.large_id == nil then
                    v135 = false
                else
                    v135 = v129.ghosts[v129.large_id] ~= nil
                end
            else
                return false
            end
            local v136 = GhostClustersConstants.ghost_vacuum_range(v130.size, v135)
            return GhostClustersConstants.flat_distance(v134.Position, v130.cframe.Position) <= v136 * v132
        end
    end
    return false
end

local function is_valid_prop_contributor(v137, v138, v139) -- line 456 | captures: GhostClustersConstants
    local v140, v141, v142
    if v139.Parent == nil then
        v141 = false
        v142 = true
    else
        local v143 = v137:is_participating(v139)
        if v143 then
            local Character = v139.Character
            v140 = Character and Character:FindFirstChild("Humanoid")
            v142 = false
        else
            v141 = v143
            v142 = true
        end
    end
    if not v142 then
        if not (v140 and v140:IsA("Humanoid")) then
            v141 = false
        else
            v141 = not GhostClustersConstants.is_vacuum_ragdolled(v140)
        end
    end
    if v141 then
        local Character = v139.Character
        local v144 = Character and Character:FindFirstChild("HumanoidRootPart")
        if not (v144 and v144:IsA("BasePart")) then
            v144 = nil
        end
        if v144 then
            local v145 = GhostClustersConstants.prop_vacuum_range(v138.is_mural)
            return GhostClustersConstants.flat_distance(v144.Position, v138.cframe.Position) <= v145 * GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK
        end
    end
    return false
end

local function get_capture_contributors(v146) -- line 469
    local v147, v148 = 0, Vector3.new(0, 0, 0)
    for v149 in v146.contributors do
        local Character = v149.Character
        local v150 = Character and Character:FindFirstChild("HumanoidRootPart")
        if not (v150 and v150:IsA("BasePart")) then
            v150 = nil
        end
        if v150 then
            v147, v148 = v147 + 1, v148 + v150.Position
        end
    end
    if v147 == 0 then
        return 0, v146.cframe.Position
    end
    local v151 = v148 / v147
    local X = v151.X
    local Y = v146.cframe.Position.Y
    local Z = v151.Z
    return v147, (Vector3.new(X, Y, Z))
end

function v45._release_fleeing_ghost(v152, v153) -- line 489 | captures: GhostClustersGhosts
    if not (v153.size ~= "Large" and next(v153.contributors) == nil and v153.vacuum_locked) then
        return
    end
    local capture_centroid = v153.capture_centroid
    v153.drag_offset = nil
    GhostClustersGhosts.set_vacuum_locked(v153, false)
    GhostClustersGhosts.begin_panic(v153, capture_centroid)
end

function v45._ghost_candy_value(v154, v155) -- line 502 | captures: GhostClustersConstants
    return GhostClustersConstants.candy_value(v155.size, v155.combine_mass) + v155.bonus_candy
end

function v45._handle_capture(v156, v157) -- line 508 | captures: GhostClustersConstants, GhostClustersGhosts
    local v158, v159
    if v157.alive then
        if v157.vacuum_progress < v157.progress_required then
            v159 = true
        else
            GhostClustersGhosts.set_vacuum_progress(v157, v157.progress_required, true)
            v158 = v157.id == v156.large_id
            v159 = false
        end
    else
        v159 = true
    end
    if v159 then
        return
    end
    if v158 then
        v156._boss_defeated = true
        for v160 in v157.contributors do
            v156:_flush_score(v160, true)
            v156:_broadcast_vacuum_beam(v160, "ghost", v157.id, false)
        end
        v157.contributors = {}
        for v161, v162 in v156.active_vacuum_by_player do
            if v162.ghost_id == v157.id then
                v156.active_vacuum_by_player[v161] = nil
            end
        end
        GhostClustersGhosts.sync_being_vacuumed(v157)
        if v157.attack_kind then
            v157.attack_phase = "idle"
            v157.attack_kind = nil
            v157.attack_until = 0
            v156:message_all_players("ghost_clusters_attack_end", v157.id)
        end
        v156:_dump_tornado_victims(v157)
        v157.alive = false
        v156:message_all_players("ghost_clusters_boss_captured")
        local delay = task.delay
        local BOSS_VICTORY_DELAY_SEC = GhostClustersConstants.BOSS_VICTORY_DELAY_SEC
        v156._boss_defeat_thread = delay(BOSS_VICTORY_DELAY_SEC, function() -- line 545 | captures: v156, v157
            v156._boss_defeat_thread = nil
            if v157.model.Parent then
                v157.model:Destroy()
            end
            if v156.ghosts[v157.id] == v157 then
                v156.ghosts[v157.id] = nil
            end
            if v156.large_id == v157.id then
                v156.large_id = nil
            end
            if v156._round_active then
                v156:end_game_now()
            end
        end)
    else
        v156:_destroy_ghost(v157.id)
    end
end

function v45._apply_drain_progress(v163, v164, v165, v166, v167) -- line 567 | captures: CloudValues, GhostClustersConstants, GhostClustersGhosts, boss_progress_per_sec
    if #v165 == 0 or v166 <= 0 then
        return
    end
    local v168 = v164.progress_required - v164.vacuum_progress
    if not (v168 <= 0) then
        local v169
        if v164.size == "Large" then
            v169 = CloudValues:getValue("ghost_clusters", "boss_drain_multiplier")
        else
            v169 = 1
        end
        local v170 = if v164.size == "Large" then boss_progress_per_sec(v164.progress_required, #v165, #GhostClustersConstants.BOSS_SHIELD_THRESHOLDS - #v163._boss_shield_thresholds_left + 1) * v167 else v166 * v169
        local v171 = math.min(v168, v170)
        local v172
        if v164.size == "Large" then
            if v163._boss_shielded then
                v172 = false
            else
                local v173 = v163._boss_shield_thresholds_left[1]
                if v173 then
                    local v174 = v164.progress_required * (1 - v173) - v164.vacuum_progress
                    if v174 <= v171 then
                        v171 = math.max(0, v174)
                        v172 = true
                    else
                        v172 = false
                    end
                else
                    v172 = false
                end
            end
        else
            v172 = false
        end
        local v175 = v163:_ghost_candy_value(v164) - v164.candy_paid
        local v176 = math.max(0, v175)
        local v177 = v176 / v168
        for v178, v179 in v165 do
            local v180 = v177 * (GhostClustersConstants.PROGRESS_PER_SEC_PER_PLAYER * v179.weight * v169 * v167)
            local v181 = GhostClustersConstants.score_value(v180, v164.combine_mass)
            if v164.size == "Large" then
                v181 *= GhostClustersConstants.BOSS_SCORE_SCALE
            end
            v163:_add_score(v179.player, v181)
        end
        local v182 = v176 * (v171 / v168)
        GhostClustersGhosts.set_vacuum_progress(v164, v164.vacuum_progress + v171, v172)
        v164.candy_paid += v182
        if v172 then
            v163:_raise_boss_shield()
        end
    end
    v163:_handle_capture(v164)
end

function v45._nearest_participant_position(v183, v184) -- line 624 | captures: GhostClustersConstants
    local Position
    local v185 = (1/0)
    for v186, v187 in v183.minigame_players:get_as_list() do
        local Character = v187.Character
        local v188 = Character and Character:FindFirstChild("HumanoidRootPart")
        if not (v188 and v188:IsA("BasePart")) then
            v188 = nil
        end
        if v188 then
            local v189 = GhostClustersConstants.flat_distance(v188.Position, v184)
            if v189 < v185 then
                Position = v188.Position
                v185 = v189
            end
        end
    end
    return Position, v185
end

function v45._drag_fleeing_ghost(v190, v191, v192, v193) -- line 640 | captures: GhostClustersConstants, GhostClustersGhosts
    local drag_offset = v191.drag_offset
    if not drag_offset then
        local v194 = v191.cframe.Position.X - v192.X
        local v195 = v191.cframe.Position.Z - v192.Z
        drag_offset = Vector3.new(v194, 0, v195)
    end
    v191.drag_offset = drag_offset
    local v196 = GhostClustersGhosts.bounds_radius(v191)
    local v197 = GhostClustersGhosts.root_floor_offset(v191.model, v191.model_name)
    local v198 = v191.cframe.Position - Vector3.new(0, 1, 0) * v197
    local v199 = v190.navmesh:project(v192 + drag_offset, v196)
    local v200 = GhostClustersGhosts.center_position_on_floor(v191, v199)
    local v201 = v200 - v191.cframe.Position
    local v202 = GhostClustersConstants.VACUUM_DRAG_FOLLOW_SPEED * v193
    if not (v201.Magnitude <= v202) then
        v200 = v191.cframe.Position + v201.Unit * v202
    end
    local v203 = v190:_resolve_floor(v198, v200 - Vector3.new(0, 1, 0) * v197, v196) + Vector3.new(0, 1, 0) * v197
    local v204 = (v203 - v191.cframe.Position) / v193
    v191.speed = GhostClustersConstants.flat_distance(Vector3.new(0, 0, 0), v204)
    GhostClustersGhosts.set_motion(v191, CFrame.new(v203, v203 + v191.heading), v204)
    GhostClustersGhosts.face_away_from(v191, v192, GhostClustersConstants.TURN_RATE_VACUUM_DEG, v193)
end

function v45._combine_ghosts(v205, v206, v207) -- line 663 | captures: GhostClustersConstants, GhostClustersGhosts
    local v208 = {}
    local v209 = {}
    for v210 in v206.contributors do
        v208[v210] = true
    end
    for v211 in v207.contributors do
        v208[v211] = true
        local v212 = v205.active_vacuum_by_player[v211]
        if v212 and v212.ghost_id == v207.id then
            v209[v211] = true
            v206.contributors[v211] = true
            v212.ghost_id = v206.id
        end
    end
    GhostClustersGhosts.absorb(v206, v207)
    GhostClustersGhosts.sync_being_vacuumed(v206)
    for v213 in v209 do
        v205:message_player(v213, "ghost_clusters_retarget", v206.id)
    end
    v205:_destroy_ghost(v207.id)
    for v214 in v209 do
        v205:_broadcast_vacuum_beam(v214, "ghost", v206.id, true)
    end
    for v215 in v208 do
        local v216 = v205:_score_record(v215)
        v216.combos += 1
        v205:_add_score(v215, GhostClustersConstants.COMBINE_SCORE_BONUS, true, "combo")
    end
    v205:_handle_capture(v206)
end

function v45._try_combine_dragged_ghosts(v217) -- line 695 | captures: GhostClustersConstants, GhostClustersGhosts
    local v218 = v217:_all_alive_ghosts()
    table.sort(v218, function(v219, v220) -- line 697
        return v219.id < v220.id
    end)
    for v221, v222 in v218 do
        if v222.alive and not v222.orbiting and v222.size ~= "Large" and next(v222.contributors) ~= nil and v222.combine_mass < GhostClustersConstants.COMBINE_MAX_MASS then
            for v223, v224 in v218 do
                if v224 ~= v222 and v224.alive and not v224.orbiting and v224.size ~= "Large" and v222.combine_mass + v224.combine_mass <= GhostClustersConstants.COMBINE_MAX_MASS then
                    local v225 = GhostClustersGhosts.collision_radius(v222) + GhostClustersGhosts.collision_radius(v224)
                    if GhostClustersConstants.flat_distance(v222.cframe.Position, v224.cframe.Position) <= v225 then
                        v217:_combine_ghosts(v222, v224)
                        break
                    end
                end
            end
        end
    end
end

function v45._step_motion(v226, v227) -- line 731 | captures: GhostClustersConstants, GhostClustersGhosts, GhostClustersMotion, get_capture_contributors
    local function v228(v229, ...)
        return (math.max(v229, ...))
    end

    local function v230(v231, ...)
        return (math.max(v231, ...))
    end

    local v232 = v226.large_id and v226.ghosts[v226.large_id]
    if v232 and v232.alive then
        local Position = v232.cframe.Position
        local v233 = v226:_nearest_participant_position(Position)
        GhostClustersGhosts.set_large_head_aim(v232, v233 or Position + v232.heading * 20)
    end
    local v234 = os.clock()
    for v235, v236 in v226:_all_alive_ghosts() do
        if not v236.orbiting then
            if v236.attack_phase == "windup" or v236.attack_phase == "orbit" then
                GhostClustersGhosts.set_motion(v236, v236.cframe, (Vector3.new(0, 0, 0)))
            elseif v236.size == "Large" then
                if v226._boss_phase and v226._boss_waypoints then
                    v226:_step_boss_float(v236, v227)
                else
                    local Position = v236.cframe.Position
                    local roam_target = v236.roam_target
                    if roam_target then
                        if GhostClustersConstants.flat_distance(Position, roam_target) <= GhostClustersConstants.ROAM_TARGET_REACHED_DISTANCE then
                            roam_target = v226.navmesh:pick_point_near(Position)
                            v236.roam_target = roam_target
                        end
                    else
                        roam_target = v226.navmesh:pick_point_near(Position)
                        v236.roam_target = roam_target
                    end
                    local Large = GhostClustersConstants.FLEE_SPEED.Large
                    if next(v236.contributors) then
                        Large *= GhostClustersConstants.BOSS_DRAIN_ROAM_SPEED_SCALE
                    end
                    local v237 = GhostClustersConstants.flat_distance(Position, roam_target)
                    local v238 = GhostClustersMotion.flat_unit(roam_target - Position)
                    if v237 <= GhostClustersConstants.ROAM_TARGET_REACHED_DISTANCE then
                        Large = 0
                    end
                    local v239 = v228(GhostClustersConstants.BOUNDS_WALL_MARGIN, GhostClustersGhosts.bounds_radius(v236))
                    GhostClustersGhosts.integrate_move(v236, v238, Large, GhostClustersConstants.TURN_RATE_AMBIENT_DEG, v227, function(v240, v241) -- line 780 | captures: v226, v239
                        return v226:_resolve_floor(v240, v241, v239)
                    end)
                    if next(v236.contributors) then
                        local v242, v243 = get_capture_contributors(v236)
                        GhostClustersGhosts.face_away_from(v236, v243, GhostClustersConstants.TURN_RATE_VACUUM_DEG, v227)
                    end
                end
            else
                local Position = v236.cframe.Position
                local v244, v245 = get_capture_contributors(v236)
                if v244 > 0 then
                    GhostClustersGhosts.set_vacuum_locked(v236, true)
                    v236.capture_centroid = v245
                    v226:_drag_fleeing_ghost(v236, v245, v227)
                else
                    v226:_release_fleeing_ghost(v236)
                    local v246, v247, v248
                    if v234 < v236.panic_until and v236.panic_from then
                        v246 = GhostClustersMotion.flat_unit(Position - v236.panic_from)
                        local v249 = if v234 < v236.panic_burst_until then GhostClustersConstants.PANIC_BURST_SPEED else GhostClustersConstants.PANIC_TIRED_SPEED
                        v247 = v249[v236.size] or GhostClustersConstants.FLEE_SPEED[v236.size] or 14
                        v248 = GhostClustersConstants.TURN_RATE_PANIC_DEG
                    else
                        local v250, v251 = v226:_nearest_participant_position(Position)
                        local v252 = GhostClustersConstants.VACUUM_RANGE[v236.size]
                        if v250 and v251 <= v252 then
                            v246 = GhostClustersMotion.flat_unit(Position - v250)
                            v247 = GhostClustersConstants.FLEE_SPEED[v236.size]
                        else
                            local roam_target = v236.roam_target
                            if roam_target then
                                if GhostClustersConstants.flat_distance(Position, roam_target) <= GhostClustersConstants.ROAM_TARGET_REACHED_DISTANCE then
                                    roam_target = v226.navmesh:pick_point_near(Position)
                                    v236.roam_target = roam_target
                                end
                            else
                                roam_target = v226.navmesh:pick_point_near(Position)
                                v236.roam_target = roam_target
                            end
                            local v253 = GhostClustersConstants.flat_distance(Position, roam_target)
                            v246 = GhostClustersMotion.flat_unit(roam_target - Position)
                            if v253 <= GhostClustersConstants.ROAM_TARGET_REACHED_DISTANCE then
                                v247 = 0
                            else
                                v247 = GhostClustersConstants.FLEE_SPEED[v236.size] * 0.65
                            end
                        end
                        v248 = GhostClustersConstants.TURN_RATE_AMBIENT_DEG
                    end
                    local v254 = v230(GhostClustersConstants.BOUNDS_WALL_MARGIN, GhostClustersGhosts.bounds_radius(v236))
                    GhostClustersGhosts.integrate_move(v236, v246, v247, v248, v227, function(v255, v256) -- line 843 | captures: v226, v254
                        return v226:_resolve_floor(v255, v256, v254)
                    end)
                end
            end
        end
    end
    v226:_try_combine_dragged_ghosts()
end

function v45._advance_boss_waypoint(v257) -- line 851
    local _boss_waypoints = v257._boss_waypoints
    if _boss_waypoints then
        v257._boss_waypoint_index = v257._boss_waypoint_index % #_boss_waypoints + 1
    end
end

function v45._pick_menace_target(v258) -- line 858
    local v259 = {}
    for v260, v261 in v258.minigame_players:get_as_list() do
        local Character = v261.Character
        local v262 = Character and Character:FindFirstChild("HumanoidRootPart")
        if v262 and v262:IsA("BasePart") and v262 then
            table.insert(v259, v261)
        end
    end
    if #v259 == 0 then
        return nil
    end
    return v259[math.random(#v259)]
end

function v45._boss_hover_y(v263, v264) -- line 871
    local _boss_waypoints = v263._boss_waypoints
    local v265 = _boss_waypoints and _boss_waypoints[1]
    if v265 then
        return v265.Y
    end
    return v264.cframe.Position.Y
end

function v45._step_boss_menace(v266, v267, v268) -- line 882 | captures: GhostClustersConstants, GhostClustersGhosts
    local v269 = os.clock()
    local _boss_menace_target = v266._boss_menace_target
    local v270, v271
    if _boss_menace_target == nil or v266._boss_menace_until <= v269 then
        v271 = false
    else
        local Character = _boss_menace_target.Character
        if Character then
            Character = Character:FindFirstChild("HumanoidRootPart")
            if Character and Character:IsA("BasePart") then
                if Character == nil then
                    v271 = false
                else
                    v270 = _boss_menace_target
                    v271 = true
                end
            else
                v271 = false
            end
        else
            v271 = false
        end
    end
    if not v271 then
        v270 = v266:_pick_menace_target()
        v266._boss_menace_target = v270
        v266._boss_menace_until = v269 + GhostClustersConstants.BOSS_MENACE_TARGET_SEC
    end
    local _boss_dip_started = v266._boss_dip_started
    local v272
    if _boss_dip_started == nil then
        if v266._boss_dip_at <= v269 then
            v266._boss_dip_started = v269
        end
        v272 = 0
    else
        local v273 = (v269 - _boss_dip_started) / GhostClustersConstants.BOSS_DIP_SEC
        if v273 >= 1 then
            v266._boss_dip_started = nil
            v266._boss_dip_at = v269 + GhostClustersConstants.boss_dip_interval()
            v272 = 0
        else
            local v274 = v273 * 3.141592653589793
            v272 = math.sin(v274)
        end
    end
    local Position = v267.cframe.Position
    local v275
    if v270 then
        local Character = v270.Character
        local v276 = Character and Character:FindFirstChild("HumanoidRootPart")
        if not (v276 and v276:IsA("BasePart")) then
        else
            v275 = v276
        end
    else
        v275 = v270
    end
    local v277 = if v275 then v275.Position else Position
    local v278 = math.noise(v269 * GhostClustersConstants.BOSS_MENACE_WANDER_RATE, v267.move_seed)
    v266._boss_wander_angle += v278 * GhostClustersConstants.BOSS_MENACE_WANDER_TURN_RAD_PER_SEC * v268
    local _boss_wander_angle = v266._boss_wander_angle
    local v279 = math.cos(_boss_wander_angle)
    local _boss_wander_angle_2 = v266._boss_wander_angle
    local v280 = math.sin(_boss_wander_angle_2)
    local v281 = Vector3.new(v279, 0, v280)
    local v282 = v277.X - Position.X
    local v283 = v277.Z - Position.Z
    local v284 = Vector3.new(v282, 0, v283)
    local v285
    if v284.Magnitude > 1 then
        v285 = v284.Unit
    else
        v285 = Vector3.new(0, 0, 0)
    end
    local v286 = GhostClustersConstants.BOSS_MENACE_PULL + (1 - GhostClustersConstants.BOSS_MENACE_PULL) * v272
    local v287 = v281 * (1 - v286) + v285 * v286
    if v287.Magnitude > 0.05 then
        local v288 = v268 * GhostClustersConstants.BOSS_MENACE_TURN_RESPONSE
        local v289 = math.min(v288, 1)
        local v290 = v266._boss_drift + (v287.Unit - v266._boss_drift) * v289
        if v290.Magnitude > 0.05 then
            v266._boss_drift = v290.Unit
        else
            v266._boss_drift = v266._boss_drift
        end
    end
    local v291 = if v272 > 0 then GhostClustersConstants.BOSS_DIP_SPEED else GhostClustersConstants.BOSS_MENACE_SPEED
    local v292 = Position + v266._boss_drift * v291 * v268
    local v293 = v266.navmesh:project(v292, GhostClustersConstants.BOSS_WALL_MARGIN)
    local v294 = v293.X - v292.X
    local v295 = v293.Z - v292.Z
    if Vector3.new(v294, 0, v295).Magnitude > 0.01 then
        local v296 = v293.X - Position.X
        local v297 = v293.Z - Position.Z
        local v298 = Vector3.new(v296, 0, v297)
        if v298.Magnitude > 0.05 then
            local Z = v298.Unit.Z
            local X = v298.Unit.X
            v266._boss_wander_angle = math.atan2(Z, X)
            v266._boss_drift = v298.Unit
        end
    end
    local v299 = v269 * GhostClustersConstants.BOSS_MENACE_BOB_HZ * 3.141592653589793 * 2 + v267.move_seed
    local v300 = math.sin(v299) * GhostClustersConstants.BOSS_MENACE_BOB
    local v301 = v266:_boss_hover_y(v267) + v300
    local v302 = v301 + (v277.Y + GhostClustersConstants.BOSS_DIP_HEIGHT - v301) * v272
    local Y = Position.Y
    local v303 = v302 - Position.Y
    local v304 = v268 * GhostClustersConstants.BOSS_MENACE_HEIGHT_RESPONSE * (v272 * 4 + 1)
    local v305 = Y + v303 * math.min(v304, 1)
    local X = v293.X
    local Z = v293.Z
    local v306 = Vector3.new(X, v305, Z)
    local v307 = v277.X - v306.X
    local v308 = v277.Z - v306.Z
    local v309 = Vector3.new(v307, 0, v308)
    local v310 = if v309.Magnitude > 0.05 then v309.Unit else v267.heading
    v267.heading = v310
    GhostClustersGhosts.set_motion(v267, CFrame.new(v306, v306 + v310), (v306 - Position) / math.max(v268, 0.0001))
end

function v45._step_boss_float(v311, v312, v313) -- line 964 | captures: CloudValues, GhostClustersConstants, GhostClustersGhosts, GhostClustersMotion, get_capture_contributors
    if v311._boss_shielded then
        v311:_step_boss_menace(v312, v313)
    else
        local v314 = v311._boss_waypoints[v311._boss_waypoint_index]
        local Position = v312.cframe.Position
        local v315 = v314 - Position
        local Magnitude = v315.Magnitude
        if Magnitude <= GhostClustersConstants.ROAM_TARGET_REACHED_DISTANCE then
            if v312.attack_phase ~= "windup" and v312.attack_phase ~= "orbit" then
                if v311._boss_at_stop then
                    if v311._boss_skip_until > 0 then
                        local v316 = os.clock()
                        if v311._boss_skip_until <= v316 then
                            v311._boss_skip_until = 0
                            v311._boss_at_stop = false
                            v311:_advance_boss_waypoint()
                        end
                    end
                else
                    v311._boss_at_stop = true
                    v311._boss_stop_count += 1
                    if (v311._boss_stop_count - 1) % CloudValues:getValue("ghost_clusters", "boss_tornado_every_n_stops") == 0 then
                        v311:_begin_attack(v312, "tornado")
                    else
                        v311._boss_skip_until = os.clock() + GhostClustersConstants.BOSS_STOP_DWELL_SEC
                    end
                end
                GhostClustersGhosts.set_motion(v312, v312.cframe, (Vector3.new(0, 0, 0)))
                if next(v312.contributors) then
                    local v317, v318 = get_capture_contributors(v312)
                    GhostClustersGhosts.face_away_from(v312, v318, GhostClustersConstants.TURN_RATE_VACUUM_DEG, v313)
                end
            else
                GhostClustersGhosts.set_motion(v312, v312.cframe, (Vector3.new(0, 0, 0)))
            end
        else
            v311._boss_at_stop = false
            local BOSS_FLOAT_SPEED = GhostClustersConstants.BOSS_FLOAT_SPEED
            if next(v312.contributors) then
                BOSS_FLOAT_SPEED *= GhostClustersConstants.BOSS_DRAIN_ROAM_SPEED_SCALE
            end
            local Unit = v315.Unit
            local v319 = BOSS_FLOAT_SPEED * v313
            local v320 = Position + Unit * math.min(v319, Magnitude)
            local v321 = GhostClustersMotion.flat_unit(Unit)
            v312.heading = v321
            GhostClustersGhosts.set_motion(v312, CFrame.new(v320, v320 + v321), Unit * BOSS_FLOAT_SPEED)
            if next(v312.contributors) then
                local v322, v323 = get_capture_contributors(v312)
                GhostClustersGhosts.face_away_from(v312, v323, GhostClustersConstants.TURN_RATE_VACUUM_DEG, v313)
            end
        end
    end
end

function v45._assign_boss_waypoints(v324) -- line 1015 | captures: GhostClustersConstants
    local Big = v324.interior.GhostClusters.Points.Big
    local v325 = Vector3.new(0, 1, 0) * (GhostClustersConstants.MURAL_GHOST_HEIGHT_OFFSET - GhostClustersConstants.BOSS_HOVER_DROP)
    v324._boss_waypoints = {
        Big.Center.WorldPosition + v325,
        Big.Left.WorldPosition + v325,
        Big.Right.WorldPosition + v325
    }
    v324._boss_waypoint_index = 1
    v324._boss_stop_count = 0
    v324._boss_at_stop = false
    v324._boss_skip_until = 0
end

function v45._begin_attack(v326, v327, v328) -- line 1030 | captures: GhostClustersConstants
    if v326._boss_shielded and v327.size == "Large" or v327.attack_phase == "windup" or v327.attack_phase == "orbit" then
        return
    end
    v327.attack_kind = v328
    v327.attack_phase = "windup"
    v327.attack_until = os.clock() + GhostClustersConstants.ATTACK_WINDUP_SEC
    v326:message_all_players("ghost_clusters_attack_windup", v327.id, v328, v327.cframe.Position, GhostClustersConstants.ATTACK_RADIUS[v327.size])
end

function v45._fire_attack(v329, v330) -- line 1049 | captures: GhostClustersConstants
    local attack_kind = v330.attack_kind
    local Position = v330.cframe.Position
    local v331 = GhostClustersConstants.ATTACK_RADIUS[v330.size]
    local v332 = GhostClustersConstants.ATTACK_IMPULSE[v330.size]
    if v330.size == "Large" then
        v330.attack_phase = "orbit"
        v330.attack_until = os.clock() + GhostClustersConstants.BOSS_ORBIT_SEC
        v329:_pull_into_tornado(v330, true)
    else
        local v333 = {}
        for v334 in v330.contributors do
            local Character = v334.Character
            local v335 = Character and Character:FindFirstChild("HumanoidRootPart")
            if not (v335 and v335:IsA("BasePart")) then
                v335 = nil
            end
            if v335 and (v335.Position - Position).Magnitude <= v331 then
                table.insert(v333, v334)
            end
        end
        for v336, v337 in v333 do
            v329:_stop_contribute(v337, nil, nil, true)
        end
        v330.attack_phase = "idle"
        v330.attack_kind = nil
        v330.attack_until = 0
    end
    v329:message_all_players("ghost_clusters_attack_fire", v330.id, attack_kind, Position, v331, v332)
end

function v45._step_attacks(v338, v339) -- line 1076 | captures: GhostClustersConstants
    for v340, v341 in v338:_all_alive_ghosts() do
        if v341.attack_phase == "windup" then
            if v341.attack_until <= v339 then
                v338:_fire_attack(v341)
            end
        elseif v341.attack_phase == "orbit" then
            if v341.attack_until <= v339 then
                v338:_release_tornado_orbit(v341)
            end
        elseif v341.size ~= "Large" and not v341.orbiting and not (v339 < v341.next_tornado_at) then
            v341.next_tornado_at = v339 + GhostClustersConstants.tornado_interval()
            v338:_begin_attack(v341, "tornado")
        end
    end
end

function v45._orbit_target_radius(v342, v343, v344) -- line 1101 | captures: GhostClustersConstants
    local v345 = v343 - v344
    local X = v345.X
    local Z = v345.Z
    local Magnitude = Vector3.new(X, 0, Z).Magnitude
    local BOSS_ORBIT_RADIUS_MIN = GhostClustersConstants.BOSS_ORBIT_RADIUS_MIN
    local BOSS_ORBIT_RADIUS_MAX = GhostClustersConstants.BOSS_ORBIT_RADIUS_MAX
    return (math.clamp(Magnitude, BOSS_ORBIT_RADIUS_MIN, BOSS_ORBIT_RADIUS_MAX))
end

function v45._begin_orbit(v346, v347) -- line 1111 | captures: GhostClustersConstants, GhostClustersGhosts
    local v348 = {}
    for v349 in v347.contributors do
        table.insert(v348, v349)
    end
    for v350, v351 in v348 do
        v346:_stop_contribute(v351, nil, nil, true)
    end
    GhostClustersGhosts.set_vacuum_locked(v347, false)
    GhostClustersGhosts.set_orbiting(v347, true)
    v347.attack_phase = "idle"
    v347.attack_kind = nil
    v346:message_all_players("ghost_clusters_attack_end", v347.id)
    local v352 = v346.large_id and v346.ghosts[v346.large_id]
    local v353 = if v352 then v352.cframe.Position else v347.cframe.Position
    v347.orbit_radius = v346:_orbit_target_radius(v347.cframe.Position, v353)
    local v354 = v347.velocity + Vector3.new(0, 1, 0) * GhostClustersConstants.BOSS_TORNADO_INITIAL_LIFT
    GhostClustersGhosts.set_motion(v347, v347.cframe, v354)
end

function v45._begin_player_orbit(v355, v356) -- line 1131
    if v355._orbiting_players[v356] then
        return
    end
    v355:_stop_contribute(v356, nil, nil, true)
    v355:_stop_prop_contribute(v356, nil, nil, true)
    local v357 = v355.large_id and v355.ghosts[v355.large_id]
    local Character = v356.Character
    local v358 = Character and Character:FindFirstChild("HumanoidRootPart")
    if not (v358 and v358:IsA("BasePart")) then
        v358 = nil
    end
    if not v357 or not v358 then
        return
    end
    local v359 = v355:_orbit_target_radius(v358.Position, v357.cframe.Position)
    v355._orbiting_players[v356] = { radius = v359 }
    v355:message_player(v356, "ghost_clusters_tornado_catch", v359)
end

function v45._dump_player_orbit(v360, v361) -- line 1149
    if v360._orbiting_players[v361] then
        v360._orbiting_players[v361] = nil
        v360:message_player(v361, "ghost_clusters_tornado_release")
    end
end

function v45._dump_tornado_victims(v362, v363) -- line 1157 | captures: GhostClustersGhosts
    local v364 = if v363 then v363.cframe.Position else nil
    for v365, v366 in v362:_all_alive_ghosts() do
        if v366.orbiting then
            GhostClustersGhosts.set_orbiting(v366, false)
            local v367 = v362.navmesh:drop_from_above(v366.cframe.Position)
            GhostClustersGhosts.place_on_floor(v366, CFrame.new(v367))
            GhostClustersGhosts.begin_panic(v366, v364 or v366.cframe.Position)
        end
    end
    local v368 = {}
    for v369 in v362._orbiting_players do
        table.insert(v368, v369)
    end
    for v370, v371 in v368 do
        v362:_dump_player_orbit(v371)
    end
end

function v45._pull_into_tornado(v372, v373, v374) -- line 1177 | captures: GhostClustersConstants
    local Position = v373.cframe.Position
    local Large = GhostClustersConstants.ATTACK_RADIUS.Large
    for v375, v376 in v372:_all_alive_ghosts() do
        if v376.size == "Small" and not v376.orbiting and (v376.cframe.Position - Position).Magnitude <= Large then
            v372:_begin_orbit(v376)
        end
    end
    if v374 then
        for v377, v378 in v372.minigame_players:get_as_list() do
            if not v372._orbiting_players[v378] then
                local Character = v378.Character
                local v379 = Character and Character:FindFirstChild("HumanoidRootPart")
                if not (v379 and v379:IsA("BasePart")) then
                    v379 = nil
                end
                if v379 and (v379.Position - Position).Magnitude <= Large then
                    v372:_begin_player_orbit(v378)
                end
            end
        end
    end
end

function v45._step_tornado_orbit(v380, v381) -- line 1199 | captures: GhostClustersConstants, GhostClustersGhosts, GhostClustersMotion
    local v382 = v380.large_id and v380.ghosts[v380.large_id]
    if v382 and v382.alive then
        if v382.attack_phase ~= "windup" then
            if v382.attack_phase == "orbit" then
                v380:_pull_into_tornado(v382, false)
                local Position = v382.cframe.Position
                local BOSS_TORNADO_VELOCITY_RESPONSE = GhostClustersConstants.BOSS_TORNADO_VELOCITY_RESPONSE
                for v383, v384 in v380:_all_alive_ghosts() do
                    if v384.orbiting then
                        local v385 = GhostClustersMotion.tornado_desired_velocity(v384.cframe.Position, Position, v384.orbit_radius)
                        local v386 = GhostClustersMotion.approach_velocity(v384.velocity, v385, v381, BOSS_TORNADO_VELOCITY_RESPONSE)
                        local v387 = v384.cframe.Position + v386 * v381
                        local v388 = GhostClustersMotion.flat_unit(v386)
                        v384.heading = v388
                        local X = v386.X
                        local Z = v386.Z
                        v384.speed = Vector3.new(X, 0, Z).Magnitude
                        GhostClustersGhosts.set_motion(v384, CFrame.new(v387, v387 + v388), v386)
                    end
                end
            else
                v380:_dump_tornado_victims(v382)
            end
        end
    else
        v380:_dump_tornado_victims(nil)
    end
end

function v45._release_tornado_orbit(v389, v390) -- line 1230
    v389:_dump_tornado_victims(v390)
    v390.attack_phase = "idle"
    v390.attack_kind = nil
    v390.attack_until = 0
    v389:message_all_players("ghost_clusters_attack_end", v390.id)
    v389._boss_at_stop = false
    v389:_advance_boss_waypoint()
end

function v45._nearby_surface_landing(v391, v392) -- line 1240 | captures: GhostClustersConstants
    local v393 = math.random() * 3.141592653589793 * 2
    local v394 = GhostClustersConstants.BOSS_NEARBY_LANDING_RADIUS_MAX - GhostClustersConstants.BOSS_NEARBY_LANDING_RADIUS_MIN
    local v395 = GhostClustersConstants.BOSS_NEARBY_LANDING_RADIUS_MIN + math.random() * v394
    local v396 = math.cos(v393) * v395
    local v397 = math.sin(v393) * v395
    local v398 = v392 + Vector3.new(v396, 0, v397)
    return v391.navmesh:drop_from_above(v398)
end

function v45._lower_boss_shield(v399) -- line 1249 | captures: GhostClustersConstants
    v399._boss_shielded = false
    local v400 = v399.large_id and v399.ghosts[v399.large_id]
    if v400 and v400.alive then
        v400.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.Shielded, false)
        if #GhostClustersConstants.BOSS_SHIELD_THRESHOLDS - #v399._boss_shield_thresholds_left == 1 then
            v399:_begin_attack(v400, "tornado")
        end
    end
end

function v45._raise_boss_shield(v401) -- line 1263 | captures: CloudValues, GhostClustersConstants, GhostClustersGhosts, GhostClustersMotion
    local v402 = v401.large_id and v401.ghosts[v401.large_id]
    if v402 and v402.alive then
        table.remove(v401._boss_shield_thresholds_left, 1)
        if v402.attack_phase == "orbit" then
            v401:_release_tornado_orbit(v402)
        elseif v402.attack_phase == "windup" then
            v402.attack_phase = "idle"
            v402.attack_kind = nil
            v402.attack_until = 0
            v401:message_all_players("ghost_clusters_attack_end", v402.id)
        end
    else
        return
    end
    local v403 = {}
    for v404 in v402.contributors do
        table.insert(v403, v404)
    end
    for v405, v406 in v403 do
        v401:_stop_contribute(v406, nil, nil, true)
    end
    local v407 = #v401._boss_shield_thresholds_left == 0
    local v408 = if v407 then GhostClustersConstants.SHIELD_FINAL_WAVE_SIZE else "Small"
    local v409 = GhostClustersConstants.SHIELD_WAVE_GHOST_COUNT[v408]
    local v410 = CloudValues:getValue("ghost_clusters", "shield_hp_ghosts_per_active_player") * v401:_active_player_count() / v409
    if v407 then
        v410 *= GhostClustersConstants.SHIELD_FINAL_WAVE_HP_SCALE
    end
    local Position = v402.cframe.Position
    for v411 = 1, v409 do
        local v412 = v401:_spawn_ghost({
            size = v408,
            cframe = CFrame.new(v401:_nearby_surface_landing(Position))
        })
        v412.progress_required *= v410
        v412.bonus_candy += GhostClustersConstants.candy_value(v408, 1) * (v410 - 1)
        v412.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.ProgressRequired, v412.progress_required)
        v412.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.IsShield, true)
        v401._shield_ghost_ids[v412.id] = true
        GhostClustersGhosts.begin_panic(v412, Position)
    end
    v401._boss_shielded = true
    v401._boss_menace_target = nil
    v401._boss_menace_until = 0
    v401._boss_dip_started = nil
    v401._boss_dip_at = os.clock() + GhostClustersConstants.boss_dip_interval()
    v401._boss_drift = GhostClustersMotion.flat_unit(v402.heading)
    v402.model:SetAttribute(GhostClustersConstants.GHOST_ATTR.Shielded, true)
end

function v45._flush_prop(v413, v414) -- line 1318 | captures: GhostClustersGhosts, GhostClustersMotion
    local function v415(v416, ...)
        table.insert(v416, ...)
    end

    local v417 = v413.navmesh:project(v414.cframe.Position)
    local v418 = {}
    local capacity = v414.capacity
    for v419 = 1, capacity do
        local v420 = {
            size = v414.spawn_size,
            cframe = CFrame.new(v417)
        }
        if v414.is_mural then
            v420.model_name = GhostClustersGhosts.MURAL_MODEL_NAME
        else
            v420.model_name = nil
        end
        v415(v418, v413:_spawn_ghost(v420))
    end
    if v414.is_mural then
        local v421 = v418[1]
        v413.large_id = v421.id
        local v422 = GhostClustersMotion.flat_unit(v414.cframe.LookVector)
        v421.heading = v422
        GhostClustersGhosts.place_on_floor(v421, CFrame.new(v417, v417 + v422))
    else
        GhostClustersGhosts.apply_split_burst(v418, v417)
    end
end

function v45._resolve_prop(v423, v424) -- line 1343 | captures: GhostClustersConstants
    local v425 = {}
    for v426 in v424.contributors do
        v425[v426] = true
    end
    for v427 in v425 do
        v423:_broadcast_vacuum_beam(v427, "prop", v424.unique, false)
    end
    v424.contributors = {}
    v424.resolved = true
    v424.flush_progress = v424.flush_required
    for v428, v429 in v423.active_prop_by_player do
        if v429.unique == v424.unique then
            v423.active_prop_by_player[v428] = nil
        end
    end
    if v424.haunted then
        v423:_flush_prop(v424)
    end
    if not v424.is_mural then
        v423._prop_restore_at[v424.unique] = os.clock() + GhostClustersConstants.PROP_RESTORE_SEC
    end
    v423:message_all_players("ghost_clusters_prop_resolved", v424.unique, v424.haunted)
end

function v45._restore_prop(v430, v431) -- line 1372
    v430._prop_restore_at[v431.unique] = nil
    v430._next_prop_progress_push_at[v431.unique] = nil
    v431.resolved = false
    v431.haunted = false
    v431.flush_progress = 0
    v430:message_all_players("ghost_clusters_prop_restored", v431.unique)
end

function v45._step_props(v432, v433, v434) -- line 1381 | captures: GhostClustersConstants, is_valid_prop_contributor
    if not v432._boss_phase then
        for v435, v436 in v432.props do
            if v436.resolved then
                local v437 = v432._prop_restore_at[v436.unique]
                if v437 and v437 <= v434 then
                    v432:_restore_prop(v436)
                end
            elseif not v436.is_mural and next(v436.contributors) ~= nil then
                local v438 = 0
                for v439 in v436.contributors do
                    if is_valid_prop_contributor(v432, v436, v439) then
                        v438 += 1
                    else
                        v436.contributors[v439] = nil
                        v432:_broadcast_vacuum_beam(v439, "prop", v436.unique, false)
                        local v440 = v432.active_prop_by_player[v439]
                        if v440 and v440.unique == v436.unique then
                            v432.active_prop_by_player[v439] = nil
                        end
                    end
                end
                if v438 ~= 0 then
                    v436.flush_progress += v433 * v438
                    local v441 = v436.flush_progress / v436.flush_required
                    local v442 = math.clamp(v441, 0, 1)
                    if (v432._next_prop_progress_push_at[v436.unique] or 0) <= v434 then
                        v432._next_prop_progress_push_at[v436.unique] = v434 + GhostClustersConstants.PROP_PROGRESS_PUSH_SEC
                        for v443 in v436.contributors do
                            v432:message_player(v443, "ghost_clusters_prop_progress", v436.unique, v442)
                        end
                    end
                    local flush_progress = v436.flush_progress
                    if v436.flush_required <= flush_progress then
                        v432:_resolve_prop(v436)
                    end
                end
            end
        end
    end
end

function v45._stop_gameplay(v444) -- line 1429
    v444:_dump_tornado_victims(v444.large_id and v444.ghosts[v444.large_id])
    v444._round_active = false
    if v444.heartbeat_connection then
        v444.heartbeat_connection:Disconnect()
        v444.heartbeat_connection = nil
    end
end

function v45._flush_motion(v445) -- line 1438 | captures: GhostClustersGhosts, GhostClustersMotion, GhostClustersMotionCodec, GhostClustersNet
    local v446 = {}
    for v447, v448 in v445:_all_alive_ghosts() do
        local v449 = {
            slot = v448.slot,
            velocity = v448.velocity,
            position = v448.cframe.Position,
            look = GhostClustersMotion.flat_unit(v448.cframe.LookVector)
        }
        table.insert(v446, v449)
        if next(v448.contributors) and v448.vacuum_progress ~= v448.replicated_progress then
            GhostClustersGhosts.set_vacuum_progress(v448, v448.vacuum_progress, true)
        end
    end
    if #v446 == 0 then
        return
    end
    local v450 = GhostClustersMotionCodec.encode_tick(workspace:GetServerTimeNow() - v445._motion_epoch)
    local v451 = v445.minigame_players:get()
    for v452, v453 in GhostClustersMotionCodec.pack(v450, v446) do
        GhostClustersNet.motion:fire_clients(v451, v453)
    end
end

function v45._heartbeat(v454, v455) -- line 1461 | captures: DataM, GhostClustersConstants, GhostClustersGhosts, combined_drain_weight, is_valid_contributor
    if not v454._round_active then
        return
    end
    local v456 = os.clock()
    local v457 = {}
    for v458, v459 in v454.active_vacuum_by_player do
        local v460 = v456 - v459.last_seen_at
        if GhostClustersConstants.CONTRIBUTE_KEEPALIVE_TIMEOUT_SEC < v460 then
            table.insert(v457, v458)
        end
    end
    for v461, v462 in v457 do
        v454:_stop_contribute(v462, nil, nil, true)
    end
    local PROGRESS_PER_SEC_PER_PLAYER = GhostClustersConstants.PROGRESS_PER_SEC_PER_PLAYER
    for v463, v464 in v454:_all_alive_ghosts() do
        local v465 = {}
        for v466 in v464.contributors do
            if is_valid_contributor(v454, v464, v466, GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK) then
                local v467 = { player = v466 }
                local toys = DataM.get_store(v466):get("equip_manager"):get_equipped().toys
                if toys and toys.kind == GhostClustersConstants.GOLD_TOY_KIND then
                    v467.weight = GhostClustersConstants.GOLD_DRAIN_MULTIPLIER
                else
                    v467.weight = 1
                end
                table.insert(v465, v467)
            else
                v464.contributors[v466] = nil
                v454:_broadcast_vacuum_beam(v466, "ghost", v464.id, false)
                v454:_flush_score(v466, true)
            end
        end
        if #v465 == 0 then
            GhostClustersGhosts.sync_being_vacuumed(v464)
            v454:_release_fleeing_ghost(v464)
        else
            GhostClustersGhosts.sync_being_vacuumed(v464)
            for v468, v469 in v465 do
                v454._last_drain_at[v469.player] = v456
            end
            local v470
            if v454._shield_ghost_ids[v464.id] then
                local v471 = 0
                v470 = 0
                for v472, v473 in v465 do
                    v471 += v473.weight
                    v470 = v471
                end
            else
                v470 = combined_drain_weight(v465)
            end
            v454:_apply_drain_progress(v464, v465, PROGRESS_PER_SEC_PER_PLAYER * v470 * v455, v455)
        end
    end
    v454:_step_attacks(v456)
    v454:_step_tornado_orbit(v455)
    for v474, v475 in v454.minigame_players:get_as_list() do
        v454:_flush_score(v475, false)
    end
    v454:_step_props(v455, os.clock())
    v454.motion_accumulator += v455
    local v476 = 1 / GhostClustersConstants.SERVER_MOTION_HZ
    local v477 = false
    while v476 <= v454.motion_accumulator do
        v454.motion_accumulator -= v476
        v454:_step_motion(v476)
        v477 = true
    end
    if v477 then
        v454:_flush_motion()
    end
end

function v45._prepare_round(v478, v479) -- line 1529 | captures: GhostClustersConstants, GhostClustersGhosts, GhostClustersHauntProps
    v478.motion_accumulator = 0
    v478._round_active = false
    v478._boss_phase = false
    v478._boss_defeated = false
    v478._boss_shielded = false
    v478._boss_shield_thresholds_left = table.clone(GhostClustersConstants.BOSS_SHIELD_THRESHOLDS)
    v478._shield_ghost_ids = {}
    v478._last_drain_at = {}
    v478._boss_menace_target = nil
    v478._boss_dip_started = nil
    v478._boss_waypoints = nil
    v478._boss_waypoint_index = 1
    v478._boss_stop_count = 0
    v478._boss_at_stop = false
    v478._boss_skip_until = 0
    v478._orbiting_players = {}
    v478._next_prop_progress_push_at = {}
    v478._prop_restore_at = {}
    v478._motion_epoch = workspace:GetServerTimeNow()
    v478:_destroy_all_ghosts()
    v478.active_vacuum_by_player = {}
    v478.active_prop_by_player = {}
    GhostClustersGhosts.destroy_live_folder(v478.live_folder_name)
    v478:_cancel_round_threads()
    v478.slot_pool = GhostClustersGhosts.create_slot_pool()
    v478.props = GhostClustersHauntProps.read_props(v478.minigame_destination_id)
    GhostClustersHauntProps.assign_haunts(v478.props)
    v478.mural = nil
    for v480, v481 in v478.props do
        if v481.is_mural then
            v478.mural = v481
            break
        end
    end
    v478._round_prepared = true
end

function v45._activate_gameplay(v482) -- line 1569 | captures: RunService
    v482._round_active = true
    if v482.heartbeat_connection then
        v482.heartbeat_connection:Disconnect()
    end
    local Heartbeat = RunService.Heartbeat
    v482.heartbeat_connection = Heartbeat:Connect(function(v483) -- line 1574 | captures: v482
        v482:_heartbeat(v483)
    end)
end

function v45._cancel_cast_threads(v484) -- line 1579
    for v485, v486 in v484._cast_threads do
        task.cancel(v486)
    end
    v484._cast_threads = {}
end

function v45._cancel_round_threads(v487) -- line 1586
    v487:_cancel_cast_threads()
    if v487._clock_promise then
        v487._clock_promise:cancel()
        v487._clock_promise = nil
    end
    local _boss_defeat_thread = v487._boss_defeat_thread
    v487._boss_defeat_thread = nil
    if _boss_defeat_thread and coroutine.status(_boss_defeat_thread) ~= "dead" then
        task.cancel(_boss_defeat_thread)
    end
end

function v45._absorbed_minion_candy(v488) -- line 1602 | captures: GhostClustersConstants
    local v489 = 0
    for v490, v491 in v488:_all_alive_ghosts() do
        if v491.size ~= "Large" then
            local v492 = v488:_ghost_candy_value(v491) - v491.candy_paid
            v489 += math.max(0, v492)
        end
    end
    for v493, v494 in v488.props do
        if not (v494.resolved or v494.is_mural) and v494.haunted then
            v489 += GhostClustersConstants.candy_value(v494.spawn_size, 1) * v494.capacity
        end
    end
    return v489
end

function v45._cleanup_non_mural_props(v495) -- line 1617
    for v496, v497 in v495.props do
        if not v497.is_mural and not v497.resolved then
            for v498 in v497.contributors do
                v495:_broadcast_vacuum_beam(v498, "prop", v497.unique, false)
            end
            v497.resolved = true
            v497.contributors = {}
        end
    end
    v495.active_prop_by_player = {}
    v495._prop_restore_at = {}
    v495:message_all_players("ghost_clusters_cleanup_props")
end

function v45._complete_boss_breakout(v499) -- line 1634 | captures: GhostClustersConstants
    if not v499._round_active then
        return
    end
    local v500 = v499:_absorbed_minion_candy()
    for v501, v502 in v499:_all_alive_ghosts() do
        if v502.size ~= "Large" then
            v499:_destroy_ghost(v502.id)
        end
    end
    v499:_cleanup_non_mural_props()
    if not v499.mural.resolved then
        v499:_resolve_prop(v499.mural)
    end
    local v503 = v499.ghosts[v499.large_id]
    v503.bonus_candy += v500
    v499:_assign_boss_waypoints()
    v499._boss_shielded = false
    v499._boss_shield_thresholds_left = table.clone(GhostClustersConstants.BOSS_SHIELD_THRESHOLDS)
    v499._shield_ghost_ids = {}
end

function v45._begin_boss_breakout(v504) -- line 1659
    if not v504._round_active or v504._boss_phase then
        return
    end
    v504._boss_phase = true
    v504:_cancel_cast_threads()
    v504:message_all_players("ghost_clusters_boss_breakout")
end

function v45._cast_wave(v505, v506) -- line 1668
    if not v505._round_active or v505._boss_phase then
        return
    end
    local v507 = {}
    for v508, v509 in v506 do
        if not v509.resolved then
            v509.haunted = true
            local v510 = {
                is_mural = false,
                haunted = true,
                resolved = false,
                unique = v509.unique,
                kind = v509.kind,
                spawn_size = v509.spawn_size
            }
            table.insert(v507, v510)
        end
    end
    if #v507 ~= 0 then
        v505:message_all_players("ghost_clusters_cast_wave", v507)
    end
end

function v45._stamp_round_clock(v511) -- line 1693 | captures: GhostClustersConstants
    v511._boss_breakout_at = v511.intermission_end_time + GhostClustersConstants.BOSS_BREAKOUT_SEC
    v511._boss_spawn_at = v511._boss_breakout_at + GhostClustersConstants.BOSS_ABSORPTION_SEC
end

function v45._schedule_round_clock(v512) -- line 1699 | captures: LiveOpsTime, v2, TableUtil, GhostClustersConstants, GhostClustersHauntProps
    v512:_cancel_round_threads()
    v512:_stamp_round_clock()
    local v513 = {}
    local v514 = GhostClustersHauntProps.cast_destinations(v512.props)
    TableUtil.shuffle(v514)
    local GHOST_CAST_MAX_PER_WAVE = GhostClustersConstants.GHOST_CAST_MAX_PER_WAVE
    local v515 = {}
    for v516, v517 in v514 do
        local v518 = v516 / GHOST_CAST_MAX_PER_WAVE
        local v519 = math.ceil(v518)
        if not v515[v519] then
            v515[v519] = {}
        end
        local v520 = v515[v519]
        table.insert(v520, v517)
    end
    local v521 = #v515
    local GHOST_CAST_WINDOW_SEC = GhostClustersConstants.GHOST_CAST_WINDOW_SEC
    local intermission_end_time = v512.intermission_end_time
    for v522, v523 in v515 do
        local v524 = if v521 == 1 then 0 else (v522 - 1) * (GHOST_CAST_WINDOW_SEC / (v521 - 1))
        local v525 = { at = intermission_end_time + v524 }
        local v526 = v523

        function v525.run() -- line 1724 | captures: v512, v526
            v512:_cast_wave(v526)
        end

        table.insert(v513, v525)
    end
    local v527 = { at = v512._boss_breakout_at }

    function v527.run() -- line 1731 | captures: v512
        v512:_begin_boss_breakout()
    end

    table.insert(v513, v527)
    local v528 = { at = v512._boss_spawn_at }

    function v528.run() -- line 1737 | captures: v512
        v512:_complete_boss_breakout()
    end

    table.insert(v513, v528)
    table.sort(v513, function(v529, v530) -- line 1741
        return v529.at < v530.at
    end)
    local v531 = v2.resolve()
    for v532, v533 in v513 do
        local at = v533.at
        local run = v533.run
        v531 = v531:andThen(function() -- line 1749 | captures: at, run, LiveOpsTime
            return LiveOpsTime.delay_until(at):andThen(run)
        end)
    end
    v512._clock_promise = v512:cancel_on_game_end(v531)
end

local function stop_tracked_use(v534, v535, v536, v537, v538, v539) -- line 1756
    local v540 = v534[v535]
    if not (v539 or v540 and v540[v536] == v537 and v540.use_token == v538) then
        return nil, nil
    end
    v534[v535] = nil
    if v540 then
        return v540, v540[v536]
    end
    return v540, v537
end

function v45._stop_contribute(v541, v542, v543, v544, v545) -- line 1774 | captures: GhostClustersGhosts
    local active_vacuum_by_player = v541.active_vacuum_by_player
    local v546 = active_vacuum_by_player[v542]
    local v547
    if not v545 and (not v546 or v546.ghost_id ~= v543 or v546.use_token ~= v544) then
        v546 = nil
    else
        active_vacuum_by_player[v542] = nil
        if v546 then
            v547 = v546.ghost_id
        else
            v547 = v543
        end
    end
    if v545 or v546 then
        v541:_flush_score(v542, true)
        if v547 then
            local v548 = v541.ghosts[v547]
            if v548 and v548.contributors[v542] then
                v548.contributors[v542] = nil
                GhostClustersGhosts.sync_being_vacuumed(v548)
                v541:_release_fleeing_ghost(v548)
                v541:_broadcast_vacuum_beam(v542, "ghost", v547, false)
            end
        else
            for v549, v550 in v541.ghosts do
                if v550.contributors[v542] then
                    v550.contributors[v542] = nil
                    GhostClustersGhosts.sync_being_vacuumed(v550)
                    v541:_release_fleeing_ghost(v550)
                    v541:_broadcast_vacuum_beam(v542, "ghost", v550.id, false)
                end
            end
        end
    end
end

function v45._stop_prop_contribute(v551, v552, v553, v554, v555) -- line 1806
    local active_prop_by_player = v551.active_prop_by_player
    local v556 = active_prop_by_player[v552]
    local v557
    if not v555 and (not v556 or v556.unique ~= v553 or v556.use_token ~= v554) then
        v556 = nil
    else
        active_prop_by_player[v552] = nil
        if v556 then
            v557 = v556.unique
        else
            v557 = v553
        end
    end
    if v555 or v556 then
        if v557 then
            local v558 = v551.props[v557]
            if v558 and v558.contributors[v552] then
                v558.contributors[v552] = nil
                v551:_broadcast_vacuum_beam(v552, "prop", v557, false)
            end
        else
            for v559, v560 in v551.props do
                if v560.contributors[v552] then
                    v560.contributors[v552] = nil
                    v551:_broadcast_vacuum_beam(v552, "prop", v560.unique, false)
                end
            end
        end
    end
end

function v45.start_contribute_msg(v561, v562, v563) -- line 1833 | captures: GhostClustersConstants, GhostClustersGhosts, is_valid_contributor, get_capture_contributors
    if typeof(v563) == "table" then
        local ghost_id = v563.ghost_id
        if typeof(ghost_id) == "string" then
            local use_token = v563.use_token
            if typeof(use_token) == "string" and v561:is_participating(v562) and not v561._orbiting_players[v562] then
                local ghost_id = v563.ghost_id
                local v564 = v561.active_vacuum_by_player[v562]
                if v564 then
                    if v564.ghost_id == ghost_id then
                        if v564.use_token ~= v563.use_token then
                            v561:_stop_contribute(v562, nil, nil, true)
                        end
                    else
                        v561:_stop_contribute(v562, nil, nil, true)
                    end
                end
                local v565 = v561.ghosts[ghost_id]
                if v565 and v565.alive then
                    if is_valid_contributor(v561, v565, v562, GhostClustersConstants.VACUUM_LOCK_RANGE_SLACK) then
                        v561.active_vacuum_by_player[v562] = {
                            ghost_id = ghost_id,
                            use_token = v563.use_token,
                            last_seen_at = os.clock()
                        }
                        local v566 = next(v565.contributors) == nil
                        local v567 = v565.contributors[v562] == true
                        v565.contributors[v562] = true
                        if not v567 then
                            v561:_broadcast_vacuum_beam(v562, "ghost", ghost_id, true)
                        end
                        GhostClustersGhosts.sync_being_vacuumed(v565)
                        local v568, v569 = get_capture_contributors(v565)
                        if v566 then
                            GhostClustersGhosts.snap_face_away_from(v565, v569)
                        end
                        if v565.size ~= "Large" then
                            GhostClustersGhosts.set_vacuum_locked(v565, true)
                            v565.capture_centroid = v569
                            if v566 then
                                local v570 = v565.cframe.Position.X - v569.X
                                local v571 = v565.cframe.Position.Z - v569.Z
                                v565.drag_offset = Vector3.new(v570, 0, v571)
                                GhostClustersGhosts.set_motion(v565, v565.cframe, (Vector3.new(0, 0, 0)))
                            end
                        end
                    elseif v564 then
                        v561:_stop_contribute(v562, ghost_id, v563.use_token)
                    end
                end
            end
        end
    end
end

function v45.stop_contribute_msg(v572, v573, v574) -- line 1885
    if typeof(v574) == "table" then
        local ghost_id = v574.ghost_id
        if typeof(ghost_id) == "string" then
            local use_token = v574.use_token
            if typeof(use_token) == "string" and v572:is_participating(v573) then
                v572:_stop_contribute(v573, v574.ghost_id, v574.use_token)
            end
        end
    end
end

function v45.start_prop_contribute_msg(v575, v576, v577) -- line 1895 | captures: is_valid_prop_contributor
    if typeof(v577) == "table" then
        local unique = v577.unique
        if typeof(unique) == "string" then
            local use_token = v577.use_token
            if typeof(use_token) == "string" and v575:is_participating(v576) and not v575._boss_phase then
                local v578 = v575.props[v577.unique]
                local v579
                if v578 then
                    if v578.resolved or v578.is_mural then
                        v579 = true
                    else
                        local v580 = v575.active_prop_by_player[v576]
                        if v580 then
                            if v580.unique == v577.unique then
                                if v580.use_token ~= v577.use_token then
                                    v575:_stop_prop_contribute(v576, nil, nil, true)
                                end
                            else
                                v575:_stop_prop_contribute(v576, nil, nil, true)
                            end
                        end
                        v579 = false
                    end
                else
                    v579 = true
                end
                if v579 then
                    return
                end
                if is_valid_prop_contributor(v575, v578, v576) then
                    v575.active_prop_by_player[v576] = {
                        unique = v577.unique,
                        use_token = v577.use_token
                    }
                    local v581 = v578.contributors[v576] == true
                    v578.contributors[v576] = true
                    if not v581 then
                        v575:_broadcast_vacuum_beam(v576, "prop", v578.unique, true)
                    end
                    local unique = v578.unique
                    local v582 = v578.flush_progress / v578.flush_required
                    v575:message_player(v576, "ghost_clusters_prop_progress", unique, (math.clamp(v582, 0, 1)))
                elseif v575.active_prop_by_player[v576] then
                    v575:_stop_prop_contribute(v576, v577.unique, v577.use_token)
                end
            end
        end
    end
end

function v45.stop_prop_contribute_msg(v583, v584, v585) -- line 1936
    if typeof(v585) == "table" then
        local unique = v585.unique
        if typeof(unique) == "string" then
            local use_token = v585.use_token
            if typeof(use_token) == "string" and v583:is_participating(v584) then
                v583:_stop_prop_contribute(v584, v585.unique, v585.use_token)
            end
        end
    end
end

function v45.on_player_joined(v586, v587, v588) -- line 1946 | captures: v1, GhostClustersHauntProps, grant_minigame_vacuum, suppress_potion_effects
    grant_minigame_vacuum(v587)
    v586:_reset_candy(v587)
    local v589 = v586.minigame_players:get_data(v587)
    if v589.potion_restore then
        v589.potion_restore()
    end
    v589.potion_restore = suppress_potion_effects(v587)
    for v590, v591 in v586.ghosts do
        v1.add(v591.model, v587, "ghost_clusters_ghost")
    end
    if v586._round_prepared then
        v586:message_player(v587, "enter_game", {
            intermission_end_time = v586.intermission_end_time,
            end_time = v586.end_time,
            play_intro_cutscene = not v586._round_active,
            boss_breakout_at = v586._boss_breakout_at,
            boss_spawn_at = v586._boss_spawn_at,
            motion_epoch = v586._motion_epoch
        })
        if v586._round_active then
            v586:message_player(v587, "ghost_clusters_props", GhostClustersHauntProps.snapshot(v586.props))
            v586:message_player(v587, "ghost_clusters_vacuum_beams", v586:_vacuum_beam_snapshot())
        end
    end
end

function v45.on_player_left(v592, v593, v594) -- line 1980 | captures: v1, revoke_minigame_vacuum
    local v595 = v592.minigame_players:get_data(v593)
    if v595.potion_restore then
        v595.potion_restore()
        v595.potion_restore = nil
    end
    v592:_dump_player_orbit(v593)
    v592:_stop_contribute(v593, nil, nil, true)
    v592:_stop_prop_contribute(v593, nil, nil, true)
    revoke_minigame_vacuum(v593)
    for v596, v597 in v592.ghosts do
        v1.remove(v597.model, v593, "ghost_clusters_ghost")
    end
end

function v45.players_loaded(v598) -- line 1997
    v598:_prepare_round(#v598.minigame_players:get_as_list())
    v598:_stamp_round_clock()
    return {
        play_intro_cutscene = true,
        boss_breakout_at = v598._boss_breakout_at,
        boss_spawn_at = v598._boss_spawn_at,
        motion_epoch = v598._motion_epoch
    }
end

function v45.game_started(v599) -- line 2008 | captures: GhostClustersHauntProps
    for v600, v601 in v599.minigame_players:get_as_list() do
        v599:_reset_candy(v601)
    end
    v599:_activate_gameplay()
    v599:message_all_players("ghost_clusters_props", GhostClustersHauntProps.snapshot(v599.props))
    v599:_schedule_round_clock()
end

function v45._submit_leaderboard(v602) -- line 2020 | captures: GhostClustersLeaderboard
    local v603 = {}
    local v604 = false
    for v605, v606 in v602.minigame_players:get_as_list() do
        v602:_flush_score(v606, true)
        local v607 = v602:_displayed_score(v606)
        if v607 ~= 0 then
            v603[v606.UserId] = v607
            v604 = true
        end
    end
    if v604 then
        GhostClustersLeaderboard.submit_scores(v603)
    end
end

function v45._reward_stats(v608, v609) -- line 2037 | captures: CloudValues, GhostClustersConstants, tuning
    local function v610(v611, ...)
        return (math.min(v611, ...))
    end

    v608:_flush_score(v609, true)
    local v612 = v608:_displayed_score(v609)
    local combos = v608:_score_record(v609).combos
    local v613, v614
    if v612 > 0 then
        v613 = GhostClustersConstants.candy_for_score(v612, tuning("score_candy_tiers")) + combos * CloudValues:getValue("ghost_clusters", "candy_per_combo")
        v614 = v610(v613, tuning("max_currency_reward"))
    else
        v613 = 0
        v614 = 0
    end
    return {
        score = v612,
        combos = combos,
        candy = v613,
        currency = v614,
        boss_defeated = v608._boss_defeated == true
    }
end

function v45.game_ended(v615) -- line 2058 | captures: AltCurrencyData, v3, v4
    v615:_stop_gameplay()
    v615:_submit_leaderboard()
    task.spawn(function() -- line 2062 | captures: v615, AltCurrencyData, v3, v4
        v4:log("ghost_clusters_minigame_ended", {
            players = v3.Array.map(v615.minigame_players:get_as_list(), function(v616) -- line 2064 | captures: v615, AltCurrencyData
                local v617 = v615:_reward_stats(v616)
                return {
                    user_id = v616.UserId,
                    score = v617.score,
                    combos = v617.combos,
                    candy = v617.candy,
                    currency = v617.currency,
                    currency_type = AltCurrencyData.name,
                    boss_defeated = v617.boss_defeated
                }
            end)
        })
    end)
end

function v45.finally(v618) -- line 2080 | captures: GhostClustersGhosts
    v618:_stop_gameplay()
    v618._round_prepared = false
    v618._boss_phase = false
    v618._boss_defeated = false
    v618._boss_shielded = false
    v618._shield_ghost_ids = {}
    v618._last_drain_at = {}
    v618:_cancel_round_threads()
    v618:_destroy_all_ghosts()
    GhostClustersGhosts.destroy_live_folder(v618.live_folder_name)
    v618.large_id = nil
    v618.mural = nil
    v618.props = {}
    v618._prop_restore_at = {}
    v618.score_by_user = {}
    v618.active_vacuum_by_player = {}
    v618.active_prop_by_player = {}
    v618._orbiting_players = {}
end

function v45.get_game_stats(v619, v620, v621, v622) -- line 2101
    local v623 = v619:_reward_stats(v620)
    return {
        results = {
            {
                title = "Score",
                value = v623.score
            },
            {
                title = "Combo",
                value = v623.combos
            }
        },
        ghost_clusters_score = v623.score,
        ghost_clusters_combos = v623.combos,
        ghost_clusters_candy = v623.candy,
        ghost_clusters_currency = v623.currency,
        boss_defeated = v623.boss_defeated
    }
end

function v45.calculate_currency_reward(v624, v625, v626) -- line 2123
    return v626.ghost_clusters_currency or 0
end

function v45.calculate_other_rewards(v627, v628, v629) -- line 2130
    if not v629.boss_defeated or (v629.ghost_clusters_score or 0) == 0 then
        return {}
    end
    return {
        {
            type = "item",
            category = "toys",
            kind = "halloween_2026_rusty_key"
        }
    }
end

return v45

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Minigames.GhostClustersScalerClient
-- Took 0.31s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local InventoryDB = load("InventoryDB")
local MinigameScalerClient = load("MinigameScalerClient")
local v1 = load("package:Sift")
local GhostClustersConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersConstants)
local GhostClustersMinigameClient = require(script.Parent.GhostClustersMinigameClient)
local new = MinigameScalerClient.new
local v2 = { minigame_class = GhostClustersMinigameClient }
local v3 = {
    minigame_name = "Ghost Gallery",
    skip_restore_equips = true,
    minigame_id = GhostClustersConstants.MINIGAME_ID,
    minigame_destination_id = GhostClustersConstants.MINIGAME_DESTINATION_ID,
    join_zone_destination_id = GhostClustersConstants.JOIN_ZONE_DESTINATION_ID,
    interior_enter_options = {
        spawn_cframe = function(v4) -- spawn_cframe | line 20
            return v4.PlayerSpawn.CFrame
        end
    }
}

function v3.get_join_zone_model(v5) -- line 24 | captures: ReplicatedStorage, GhostClustersConstants
    local v6 = v5:FindFirstChild(GhostClustersConstants.JOIN_ZONE_NAME)
    if v6 then
        return v6
    end
    local v7 = ReplicatedStorage.Resources.JoinZone:Clone()
    v7.Name = GhostClustersConstants.JOIN_ZONE_NAME
    v7:PivotTo(v5.GhostClustersJoinZoneMarker.CFrame)
    v7.Parent = v5
    return v7
end

local v8 = {}

v8.forced_equips = v1.Dictionary.map(InventoryDB, function(v9, v10) -- line 41 | captures: v1, GhostClustersConstants
    if v10 == "toys" then
        return {
                GhostClustersConstants.TOY_KIND,
                GhostClustersConstants.GOLD_TOY_KIND
            },
            v10
    end
    if v10 == "pets" then
        return v1.Dictionary.keys(v9), v10
    end
    return {}, v10
end)
v8.app_visibility = {
    type = "include",
    include_essential = true,
    app_names = { "GhostClustersBossBarApp", "MinigameHotbarApp", "MinigameInGameApp", "MinigameRewardsApp" }
}
v3.minigame_restriction_overrides = v8
v2.minigame_options = v3
return new(v2)

-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Minigames.GhostClustersScalerServer
-- Took 0.3s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MinigameScalerServer = require(ReplicatedStorage.Fsys).load("MinigameScalerServer")
local GhostClustersConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersConstants)
local GhostClustersMinigameServer = require(script.Parent.GhostClustersMinigameServer)
local HalloweenStormConstants = require(ReplicatedStorage.SharedModules.ContentPacks.Halloween2026.Game.HalloweenStorm.HalloweenStormConstants)
local new = MinigameScalerServer.new
local v1 = {
    max_players = GhostClustersConstants.MAX_PLAYERS_PER_SESSION,
    minigame_class = GhostClustersMinigameServer
}
local v2 = {
    minimum_players = 1,
    event_id = GhostClustersConstants.EVENT_ID,
    minigame_id = GhostClustersConstants.MINIGAME_ID,
    minigame_length = GhostClustersConstants.ROUND_SEC,
    intermission_length = GhostClustersConstants.INTERMISSION_LENGTH,
    schedule_order = GhostClustersConstants.SCHEDULE_ORDER,
    schedule_available_at = HalloweenStormConstants.SWAP_AT,
    minigame_destination_id = GhostClustersConstants.MINIGAME_DESTINATION_ID,
    join_zone_destination_id = GhostClustersConstants.JOIN_ZONE_DESTINATION_ID
}

function v2.get_join_zone_model(v3) -- line 27 | captures: ReplicatedStorage, GhostClustersConstants
    local v4 = v3:FindFirstChild(GhostClustersConstants.JOIN_ZONE_NAME)
    if v4 then
        return v4
    end
    local v5 = ReplicatedStorage.Resources.JoinZone:Clone()
    v5.Name = GhostClustersConstants.JOIN_ZONE_NAME
    v5:PivotTo(v3.GhostClustersJoinZoneMarker.CFrame)
    v5.Parent = v3
    return v5
end

v1.minigame_options = v2
return new(v1)


-- залупа не факт
-- Script Path: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026.Game.GhostClusters.GhostClustersGhostRenderer
-- Took 0.63s to decompile.
-- Executor: Potassium (v2.5.1)

-- https://sitetest1.lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local Debris = game:GetService("Debris")
local load = require(ReplicatedStorage.Fsys).load
local Maid = load("Maid")
local Spring = load("Spring")
local TweenPromise = load("TweenPromise")
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local GhostClustersClientConstants = require(script.Parent.GhostClustersClientConstants)
local GhostClustersConstants = require(script.Parent.GhostClustersConstants)
local GhostClustersGhostAnimator = require(script.Parent.GhostClustersGhostAnimator)
local GhostClustersGhosts = require(script.Parent.GhostClustersGhosts)
local GhostClustersMotion = require(script.Parent.GhostClustersMotion)
local GhostClustersMotionCodec = require(script.Parent.GhostClustersMotionCodec)
local GhostClustersVacuumDynamics = require(script.Parent.GhostClustersVacuumDynamics)
local v1 = {}
local v2, v3
local v4 = {}
local v5 = {}
local Folder, v6
local v7 = 0
local v8 = 0
local v9
local v10 = 0
local v11

local function emit_boss_poof(v12) -- line 94 | captures: Debris, GhostClustersClientConstants
    local v13 = game.ReplicatedStorage.Resources.Particles.PridePinPoof:Clone()
    local BOSS_DEFEAT_POOF_SIZE_SCALE = GhostClustersClientConstants.BOSS_DEFEAT_POOF_SIZE_SCALE
    local v14 = {}
    for v15, v16 in v13.Size.Keypoints do
        v14[v15] = NumberSequenceKeypoint.new(v16.Time, v16.Value * BOSS_DEFEAT_POOF_SIZE_SCALE, v16.Envelope * BOSS_DEFEAT_POOF_SIZE_SCALE)
    end
    v13.Size = NumberSequence.new(v14)
    local Speed = v13.Speed
    v13.Speed = NumberRange.new(Speed.Min * BOSS_DEFEAT_POOF_SIZE_SCALE, Speed.Max * BOSS_DEFEAT_POOF_SIZE_SCALE)
    local Attachment = Instance.new("Attachment")
    v13.Parent = Attachment
    Attachment.Position = v12
    Attachment.Parent = workspace.Terrain
    v13:Emit(GhostClustersClientConstants.BOSS_DEFEAT_POOF_PARTICLES)
    Debris:AddItem(Attachment, GhostClustersClientConstants.BOSS_DEFEAT_POOF_LIFETIME)
end

local v17 = { "rbxassetid://5822873905", "rbxassetid://5822873988", "rbxassetid://5822874065" }
local v18 = {}

local function clear_tether(v19) -- line 120 | captures: v18
    local v20 = v18[v19]
    if not v20 then
        return
    end
    v20.beam:Destroy()
    v20.a0:Destroy()
    v20.a1:Destroy()
    v18[v19] = nil
end

local function sync_tethers() -- line 131 | captures: v4, GhostClustersConstants, v17, v18
    local v21
    for v22, v23 in v4 do
        if v23.size == "Large" then
            v21 = v23
            break
        end
        v21 = nil
    end
    local v24 = if v21 == nil then false else v21.visual:GetAttribute(GhostClustersConstants.GHOST_ATTR.Shielded) == true
    local v25 = {}
    if v21 and v24 then
        local v26 = 0
        for v27, v28 in v4 do
            if v28.visual:GetAttribute(GhostClustersConstants.GHOST_ATTR.IsShield) == true then
                v25[v27] = true
                if not v18[v27] then
                    v26 += 1
                    local Attachment = Instance.new("Attachment")
                    Attachment.Parent = v21.visual.RootPart
                    local Attachment_2 = Instance.new("Attachment")
                    Attachment_2.Parent = v28.visual.RootPart
                    local Beam = Instance.new("Beam")
                    Beam.Attachment0 = Attachment
                    Beam.Attachment1 = Attachment_2
                    Beam.Texture = v17[(v26 - 1) % #v17 + 1]
                    Beam.FaceCamera = true
                    Beam.Width0 = 5.5
                    Beam.Width1 = 2.5
                    Beam.LightEmission = 1
                    Beam.TextureSpeed = 1
                    Beam.Transparency = NumberSequence.new(0.2)
                    Beam.Parent = Attachment
                    v18[v27] = {
                        beam = Beam,
                        a0 = Attachment,
                        a1 = Attachment_2
                    }
                end
            end
        end
    end
    local v29 = {}
    for v30 in v18 do
        if not v25[v30] then
            table.insert(v29, v30)
        end
    end
    for v31, v32 in v29 do
        local v33 = v18[v32]
        if v33 then
            v33.beam:Destroy()
            v33.a0:Destroy()
            v33.a1:Destroy()
            v18[v32] = nil
        end
    end
end

local function set_source_hidden(v34, v35) -- line 181 | captures: GhostClustersGhosts
    for v36, v37 in v34:GetDescendants() do
        if v37:IsA("BasePart") then
            if v35 then
                v37.LocalTransparencyModifier = 1
            else
                v37.LocalTransparencyModifier = 0
            end
        end
    end
    GhostClustersGhosts.set_effects_enabled(v34, false)
end

local function add_aim_query(v38) -- line 191
    local v39, v40 = v38:GetBoundingBox()
    local Part = Instance.new("Part")
    Part.Name = "AimQuery"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = true
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true
    Part.Transparency = 1
    Part.Size = v40
    Part.CFrame = v39
    Part.Parent = v38
end

local function prepare_visual(v41) -- line 210 | captures: GhostClustersGhosts
    GhostClustersGhosts.prepare_ghost_model(v41)
    local v42, v43 = v41:GetBoundingBox()
    local Part = Instance.new("Part")
    Part.Name = "AimQuery"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = true
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true
    Part.Transparency = 1
    Part.Size = v43
    Part.CFrame = v42
    Part.Parent = v41
end

local v44 = 0

local function remove_entry(v45) -- line 217 | captures: v4, v5, v18
    local v46 = v4[v45]
    if not v46 then
        return
    end
    v4[v45] = nil
    v5[v46.slot] = nil
    if v46.size == "Large" then
        local v47 = {}
        for v48 in v18 do
            table.insert(v47, v48)
        end
        for v49, v50 in v47 do
            local v51 = v18[v50]
            if v51 then
                v51.beam:Destroy()
                v51.a0:Destroy()
                v51.a1:Destroy()
                v18[v50] = nil
            end
        end
    else
        local v52 = v18[v45]
        if v52 then
            v52.beam:Destroy()
            v52.a0:Destroy()
            v52.a1:Destroy()
            v18[v45] = nil
        end
    end
    v46.maid:DoCleaning()
end

local function add_source(v53) -- line 238 | captures: v4, v5, Folder, v44, Maid, Spring, SoundPlayer, GhostClustersClientConstants, GhostClustersConstants, GhostClustersGhostAnimator, GhostClustersGhosts, v1, sync_tethers, set_source_hidden, remove_entry
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    local v54 = v53:GetAttribute(GHOST_ATTR.Id)
    if typeof(v54) ~= "string" then
        return
    end
    remove_entry(v54)
    local v55 = v53:GetAttribute(GHOST_ATTR.Size)
    local v56 = v53:GetAttribute(GHOST_ATTR.ModelName)
    local v57 = GhostClustersGhosts.get_template(v56):Clone()
    local v58 = v53:GetPivot()
    local v59 = v53:GetAttribute(GHOST_ATTR.Slot)
    local v60 = v5[v59]
    if v60 then
        remove_entry(v60.id)
    end
    GhostClustersGhosts.prepare_ghost_model(v57)
    local v61, v62 = v57:GetBoundingBox()
    local Part = Instance.new("Part")
    Part.Name = "AimQuery"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = true
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true
    Part.Transparency = 1
    Part.Size = v62
    Part.CFrame = v61
    Part.Parent = v57
    v57.Name = v53.Name
    v57:PivotTo(v58)
    v57:ScaleTo(v53:GetScale())
    v57.Parent = Folder
    GhostClustersGhosts.clear_effects(v57)
    local v63 = GhostClustersGhostAnimator.create(v57, v56)
    local v64, Spine03
    if v56 == GhostClustersGhosts.MURAL_MODEL_NAME then
        v1.stop_intro_entrance()
        Spine03 = v57.RootPart.HumanoidRootPart.Spine01.Spine02.Spine03
        v64 = Spring.new(GhostClustersClientConstants.HEAD_SPRING_DAMP, GhostClustersClientConstants.HEAD_SPRING_FREQ, 0)
    end
    local v65 = Maid.new()
    local v66 = {
        shown_transparency = 0,
        applied_transparency = 0,
        snapshot_velocity = Vector3.new(0, 0, 0),
        snapshot_time = 0,
        snapshot_tick = nil,
        absorb_from = nil,
        attack_kind = nil,
        attack_started_at = 0,
        attack_spin_angle = 0,
        attack_radius = 0,
        attack_radius_part = nil,
        id = v54,
        source = v53,
        visual = v57,
        maid = v65,
        slot = v59,
        cframe = v58,
        scale = v53:GetScale(),
        shown_scale = v53:GetScale(),
        size = v55,
        model_name = v56,
        move_seed = v53:GetAttribute(GHOST_ATTR.MoveSeed),
        snapshot_cframe = v58,
        aim_target = v53:GetAttribute(GHOST_ATTR.HeadTarget),
        aim_spring = v64,
        spine03 = Spine03,
        animator = v63,
        being_vacuumed = v53:GetAttribute(GHOST_ATTR.BeingVacuumed)
    }
    v4[v54] = v66
    v5[v59] = v66
    for v67, v68 in GHOST_ATTR do
        local v69 = v68

        local sync_attribute = function() -- sync_attribute | line 308 | captures: v53, GHOST_ATTR, v57, v66, v69, sync_tethers
            local v70 = v53:GetAttribute(v69)
            v57:SetAttribute(v69, v70)
            if v69 == GHOST_ATTR.HeadTarget then
                v66.aim_target = v70
            elseif v69 == GHOST_ATTR.BeingVacuumed then
                v66.being_vacuumed = v70
                v66.animator.set_being_vacuumed(v66.being_vacuumed)
            elseif v69 == GHOST_ATTR.Shielded then
                v66.animator.set_cowering(v70 == true)
                sync_tethers()
            elseif v69 == GHOST_ATTR.IsShield then
                sync_tethers()
            end
        end

        sync_attribute()
        v65:GiveTask(v53:GetAttributeChangedSignal(v68):Connect(sync_attribute))
    end
    set_source_hidden(v53, true)
    if v53:GetAttribute(GHOST_ATTR.IsShield) == true and os.clock() - v44 > 0.5 then
        v44 = os.clock()
        SoundPlayer.FX:play("GhostClusters/BigGhostTinySpawn", v57.PrimaryPart)
    end
    v65:GiveTask(function() -- line 332 | captures: v57, v63, GhostClustersGhosts
        GhostClustersGhosts.set_effects_enabled(v57, false)
        v63.destroy()
        v57:Destroy()
    end)
end

local function observe_live_folder(v71, v72) -- line 341 | captures: GhostClustersConstants, remove_entry, add_source
    for v73, v74 in v71:GetChildren() do
        if v74:IsA("Model") then
            add_source(v74)
        end
    end
    v72:GiveTask(v71.ChildAdded:Connect(function(v75) -- line 348 | captures: add_source
        if v75:IsA("Model") then
            add_source(v75)
        end
    end))
    v72:GiveTask(v71.ChildRemoved:Connect(function(v76) -- line 353 | captures: GhostClustersConstants, remove_entry
        if v76:IsA("Model") then
            local v77 = v76:GetAttribute(GhostClustersConstants.GHOST_ATTR.Id)
            if typeof(v77) == "string" then
                remove_entry(v77)
            end
        end
    end))
end

local function on_child_named(v78, v79, v80, v81) -- line 363
    local v82 = v78:FindFirstChild(v79)
    if v82 then
        v81(v82)
    else
        local v83
        v83 = v78.ChildAdded:Connect(function(v84) -- line 370 | captures: v83, v79, v81
            if v84.Name == v79 then
                v83:Disconnect()
                v81(v84)
            end
        end)
        v80:GiveTask(v83)
    end
end

function v1.start(v85) -- line 379 | captures: v2, v4, v5, Folder, v6, v7, v8, v9, v10, v11, RunService, SoundService, Maid, SoundPlayer, GhostClustersClientConstants, GhostClustersConstants, GhostClustersGhosts, GhostClustersMotion, GhostClustersVacuumDynamics, v1, emit_boss_poof, remove_entry, observe_live_folder, on_child_named
    v1.stop()
    local v86 = Maid.new()
    v2 = v86
    v4 = {}
    v5 = {}
    v10 = 0
    v11 = nil
    local Folder_2 = Instance.new("Folder")
    Folder_2.Name = GhostClustersConstants.VISUAL_FOLDER_NAME
    Folder_2.Parent = workspace
    Folder = Folder_2
    v86:GiveTask(Folder_2)
    local workspace_2 = workspace
    local LIVE_FOLDER_NAME = GhostClustersConstants.LIVE_FOLDER_NAME
    on_child_named(workspace_2, LIVE_FOLDER_NAME, v86, function(v87) -- line 395 | captures: v85, v86, observe_live_folder, on_child_named
        on_child_named(v87, v85, v86, function(v88) -- line 396 | captures: v86, observe_live_folder
            observe_live_folder(v88, v86)
        end)
    end)
    v86:GiveTask(RunService.RenderStepped:Connect(function(v89) -- line 401 | captures: v4, v6, v7, v8, v9, SoundService, SoundPlayer, GhostClustersClientConstants, GhostClustersConstants, GhostClustersGhosts, GhostClustersMotion, GhostClustersVacuumDynamics, emit_boss_poof
        local v90 = workspace:GetServerTimeNow()
        local v91 = -GhostClustersClientConstants.VISUAL_FOLLOW_RESPONSE * v89
        local v92 = 1 - math.exp(v91)
        local v93 = v6 ~= nil
        if v93 then
            v91 = os.clock() - v7
            if v8 <= v91 then
                v6 = nil
                v93 = false
            end
        end
        if v93 then
            local v94 = (os.clock() - v7) / v8
            v91 = math.clamp(v94, 0, 1)
        else
            v91 = 0
        end
        v91 = v91 * v91 * (3 - v91 * 2)
        for v95, v96 in v4 do
            if v96.defeated and v9 and v9.id == v96.id then
                if v9.driving and not v9.poofed then
                    local v97 = os.clock() - v9.started_at
                    local BOSS_DEFEAT_INFLATE_SEC = GhostClustersClientConstants.BOSS_DEFEAT_INFLATE_SEC
                    local v98 = v97 / BOSS_DEFEAT_INFLATE_SEC
                    local v99 = math.clamp(v98, 0, 1)
                    v98 = v9.from_scale * (1 + (GhostClustersClientConstants.BOSS_DEFEAT_INFLATE_SCALE - 1) * v99)
                    local v100 = v9.from_position + Vector3.new(0, 1, 0) * (GhostClustersClientConstants.BOSS_DEFEAT_RISE * v99)
                    local v101, v102, v103
                    if v97 < BOSS_DEFEAT_INFLATE_SEC then
                        local v104 = v97 * GhostClustersClientConstants.BOSS_DEFEAT_SHAKE_HZ * 3.141592653589793 * 2
                        local attack_radius_part = math.sin(v104) * GhostClustersClientConstants.BOSS_DEFEAT_SHAKE_STUDS * v99 * v99
                        v104 = attack_radius_part * 0.5
                        v103, v102 = v100 + Vector3.new(attack_radius_part, 0, v104), v9.from_look
                    else
                        v101 = (v97 - BOSS_DEFEAT_INFLATE_SEC) / GhostClustersClientConstants.BOSS_DEFEAT_ORBIT_SEC
                        local attack_radius_part = math.clamp(v101, 0, 1)
                        v101 = attack_radius_part * attack_radius_part * (3 - attack_radius_part * 2)
                        local v105 = attack_radius_part * 3.141592653589793 * 2 * GhostClustersClientConstants.BOSS_DEFEAT_ORBIT_TURNS
                        local v106 = v97 * GhostClustersClientConstants.BOSS_DEFEAT_ORBIT_WOBBLE_HZ * 3.141592653589793 * 2
                        local v107 = math.sin(v106)
                        v106 = GhostClustersClientConstants.BOSS_DEFEAT_ORBIT_RADIUS * v101 * (v107 * 0.22 + 1)
                        v103 = v100 + (v9.orbit_right * math.sin(v105) + v9.from_look * (1 - math.cos(v105))) * v106 + Vector3.new(0, 1, 0) * (GhostClustersClientConstants.BOSS_DEFEAT_ORBIT_WOBBLE_STUDS * v107 * v101)
                        v102 = v9.orbit_right * math.cos(v105) + v9.from_look * math.sin(v105)
                        v98 *= v107 * 0.04 + 1
                    end
                    v101 = v96.visual:GetScale() - v98
                    if math.abs(v101) > 0.001 then
                        v96.visual:ScaleTo(v98)
                    end
                    v96.visual:PivotTo(CFrame.lookAt(v103, v103 + v102))
                    v9.on_position(v103)
                    if BOSS_DEFEAT_INFLATE_SEC + GhostClustersClientConstants.BOSS_DEFEAT_ORBIT_SEC <= v97 then
                        v9.poofed = true
                        emit_boss_poof(v103)
                        SoundPlayer.FX:play("GhostClusters/BigGhostGravityHit", SoundService)
                        GhostClustersGhosts.set_effects_enabled(v96.visual, false)
                        for v108, v109 in v96.visual:GetDescendants() do
                            if v109:IsA("BasePart") then
                                v109.LocalTransparencyModifier = 1
                            end
                        end
                        v96.applied_transparency = 1
                    end
                end
            else
                local v110, BOSS_DEFEAT_INFLATE_SEC, v111
                if v93 then
                    v110 = v96.size
                    if v110 == "Large" then
                        BOSS_DEFEAT_INFLATE_SEC = v90 - v96.snapshot_time
                        v111 = GhostClustersConstants.MAX_PREDICTION_SEC
                        v110 = math.clamp(BOSS_DEFEAT_INFLATE_SEC, 0, v111)
                        BOSS_DEFEAT_INFLATE_SEC = GhostClustersMotion.predict(v96.snapshot_cframe, v96.snapshot_velocity, v110)
                        v96.cframe = v96.cframe:Lerp(BOSS_DEFEAT_INFLATE_SEC, v92)
                    else
                        v110 = v96.absorb_from or v96.cframe
                        v96.absorb_from = v110
                        v96.cframe = v110:Lerp(CFrame.new(v6), v91)
                    end
                else
                    BOSS_DEFEAT_INFLATE_SEC = v90 - v96.snapshot_time
                    v111 = GhostClustersConstants.MAX_PREDICTION_SEC
                    v110 = math.clamp(BOSS_DEFEAT_INFLATE_SEC, 0, v111)
                    BOSS_DEFEAT_INFLATE_SEC = GhostClustersMotion.predict(v96.snapshot_cframe, v96.snapshot_velocity, v110)
                    v96.cframe = v96.cframe:Lerp(BOSS_DEFEAT_INFLATE_SEC, v92)
                end
                v110 = v96.source:GetScale()
                if v110 ~= v96.scale then
                    v96.scale = v110
                end
                BOSS_DEFEAT_INFLATE_SEC = v96.size
                local v112
                if BOSS_DEFEAT_INFLATE_SEC == "Large" then
                    BOSS_DEFEAT_INFLATE_SEC = v96.visual:GetAttribute(GhostClustersConstants.GHOST_ATTR.Shielded) == true
                    local v113 = v89 * 6
                    v112 = math.min(1, v113)
                    if BOSS_DEFEAT_INFLATE_SEC then
                        v111 = v96.scale * GhostClustersConstants.BOSS_SHIELDED_SCALE
                    else
                        v111 = v96.scale
                    end
                    v96.shown_scale += (v111 - v96.shown_scale) * v112
                    if BOSS_DEFEAT_INFLATE_SEC then
                        v113 = GhostClustersConstants.BOSS_SHIELDED_TRANSPARENCY
                    else
                        v113 = 0
                    end
                    v96.shown_transparency += (v113 - v96.shown_transparency) * v112
                    if not BOSS_DEFEAT_INFLATE_SEC then
                        local v114 = v96.shown_scale - v96.scale
                        if math.abs(v114) < 0.02 then
                            v96.shown_scale = v96.scale
                        end
                        if v96.shown_transparency < 0.02 then
                            v96.shown_transparency = 0
                        end
                    end
                    if v96.shown_transparency ~= v96.applied_transparency then
                        v96.applied_transparency = v96.shown_transparency
                        for v115, v116 in v96.visual:GetDescendants() do
                            if v116:IsA("BasePart") then
                                v116.LocalTransparencyModifier = v96.shown_transparency
                            end
                        end
                    end
                end
                if v96.model_name == GhostClustersGhosts.MURAL_MODEL_NAME then
                    BOSS_DEFEAT_INFLATE_SEC = GhostClustersClientConstants.VISUAL_BOB_HEIGHT
                else
                    BOSS_DEFEAT_INFLATE_SEC = 0
                end
                v112 = v96.cframe * GhostClustersMotion.visual_offset(v96.move_seed, v90, BOSS_DEFEAT_INFLATE_SEC, GhostClustersClientConstants.VISUAL_BOB_SPEED, GhostClustersClientConstants.VISUAL_SWAY_DEG)
                if v96.being_vacuumed and not v96.attack_kind then
                    v112 *= GhostClustersVacuumDynamics.visual_resistance_offset(v96.size, v90 * GhostClustersConstants.VACUUM_RESISTANCE_FREQUENCY + v96.move_seed)
                end
                v111 = v96.attack_kind
                if v111 then
                    v111 = os.clock() - v96.attack_started_at
                    v96.attack_spin_angle += GhostClustersConstants.attack_spin_rad_per_sec(v111) * v89
                    v112 *= CFrame.Angles(0, v96.attack_spin_angle, 0)
                elseif v96.visual:GetAttribute(GhostClustersConstants.GHOST_ATTR.Orbiting) == true then
                    v112 *= CFrame.Angles(0, os.clock() * 14, 0)
                end
                if v96.size == "Large" then
                    v111 = v96.shown_scale
                else
                    v111 = v96.scale
                end
                local v117 = v96.visual:GetScale() - v111
                if math.abs(v117) > 0.001 then
                    v96.visual:ScaleTo(v111)
                end
                if v96.attack_kind == nil then
                    v117 = v96.animator.is_hit_playing()
                else
                    v117 = true
                end
                local attack_radius_part = v96.aim_spring
                local v118, v119
                if attack_radius_part then
                    local v120
                    if v117 then
                        v96.aim_spring:set_goal(0)
                    else
                        attack_radius_part = v96.being_vacuumed
                        if attack_radius_part then
                            v96.aim_spring:set_goal(0)
                        else
                            attack_radius_part = v96.aim_target
                            if attack_radius_part then
                                attack_radius_part = GhostClustersMotion.flat_unit(v96.aim_target - v112.Position)
                                v118 = GhostClustersMotion.flat_unit(v112.LookVector)
                                local Y = v118:Cross(attack_radius_part).Y
                                v120 = v118:Dot(attack_radius_part)
                                v119 = math.atan2(Y, v120)
                                v96.aim_spring:set_goal(v119)
                            else
                                v96.aim_spring:set_goal(0)
                            end
                        end
                    end
                    attack_radius_part = v96.aim_spring:update(v89)
                    v119 = GhostClustersConstants.MURAL_SPINE_MAX_YAW_DEG
                    v118 = math.rad(v119)
                    v120 = -v118
                    v119 = math.clamp(attack_radius_part, v120, v118)
                    local Transform = attack_radius_part - v119
                    if v117 then
                        v119 = 0
                    else
                        v112 *= CFrame.Angles(0, Transform, 0)
                    end
                else
                    v119 = 0
                end
                v96.visual:PivotTo(v112)
                if v96.spine03 and v119 ~= 0 then
                    v96.spine03.Transform = v96.spine03.Transform * CFrame.Angles(0, v119, 0)
                end
                attack_radius_part = v96.attack_radius_part
                if attack_radius_part then
                    v118 = os.clock() - v96.attack_started_at
                    attack_radius_part.CFrame = CFrame.new(v112.Position)
                    local v121 = v118 * 5
                    local sin = math.sin(v121)
                    attack_radius_part.Transparency = math.abs(sin) * 0.16 + 0.52
                end
            end
        end
    end))
    v86:GiveTask(function() -- line 588 | captures: v4, Folder, v6, remove_entry
        local v122 = {}
        for v123 in v4 do
            table.insert(v122, v123)
        end
        for v124, v125 in v122 do
            remove_entry(v125)
        end
        Folder = nil
        v6 = nil
    end)
end

function v1.stop_intro_entrance() -- line 601 | captures: v3
    local v126 = v3
    v3 = nil
    if v126 then
        v126()
    end
end

function v1.stop() -- line 609 | captures: v2, v9, v1
    v9 = nil
    v1.stop_intro_entrance()
    if v2 then
        v2:DoCleaning()
        v2 = nil
    end
end

function v1.get_visual(v127) -- line 618 | captures: v4
    local v128 = v4[v127]
    if v128 then
        return v128.visual
    end
    return nil
end

function v1.get_gameplay_cframe(v129) -- line 623 | captures: v4
    local v130 = v4[v129]
    if v130 then
        return v130.cframe
    end
    return nil
end

local function remaining_fraction(v131) -- line 628 | captures: GhostClustersConstants
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    local v132 = v131:GetAttribute(GHOST_ATTR.ProgressRequired)
    local v133 = 1 - v131:GetAttribute(GHOST_ATTR.Progress) / v132
    return (math.clamp(v133, 0, 1))
end

function v1.get_boss_state() -- line 638 | captures: v4, GhostClustersConstants
    local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
    local v134 = {}
    local v135
    for v136, v137 in v4 do
        if v137.size == "Large" then
            v135 = v137
        elseif v137.visual:GetAttribute(GHOST_ATTR.IsShield) == true then
            table.insert(v134, v137)
        end
    end
    if v135 == nil or v135.defeated then
        return nil
    end
    table.sort(v134, function(v138, v139) -- line 655
        return v138.slot < v139.slot
    end)
    local v140 = table.create(#v134)
    for v141, v142 in v134 do
        local v143 = { id = v142.id }
        local visual = v142.visual
        local GHOST_ATTR = GhostClustersConstants.GHOST_ATTR
        local v144 = visual:GetAttribute(GHOST_ATTR.ProgressRequired)
        local v145 = 1 - visual:GetAttribute(GHOST_ATTR.Progress) / v144
        v143.remaining = math.clamp(v145, 0, 1)
        v143.draining = v142.being_vacuumed
        table.insert(v140, v143)
    end
    local v146 = {}
    local visual = v135.visual
    local GHOST_ATTR_2 = GhostClustersConstants.GHOST_ATTR
    local v147 = visual:GetAttribute(GHOST_ATTR_2.ProgressRequired)
    local v148 = 1 - visual:GetAttribute(GHOST_ATTR_2.Progress) / v147
    v146.remaining = math.clamp(v148, 0, 1)
    v146.shielded = v135.visual:GetAttribute(GHOST_ATTR.Shielded) == true
    v146.shield_ghosts = v140
    return v146
end

function v1.apply_snapshot(v149, v150, v151) -- line 674 | captures: v5, v10, v11, GhostClustersMotionCodec
    if v11 == nil then
        v11 = v149
    elseif GhostClustersMotionCodec.is_newer_tick(v149, v11) then
        if v149 < v11 then
            v10 += 1
        end
        v11 = v149
    end
    for v152, v153 in v150 do
        local v154 = v5[v153.slot]
        if v154 then
            local snapshot_tick = v154.snapshot_tick
            if snapshot_tick == nil or GhostClustersMotionCodec.is_newer_tick(v149, snapshot_tick) then
                v154.snapshot_tick = v149
                v154.snapshot_cframe = CFrame.new(v153.position, v153.position + v153.look)
                v154.snapshot_velocity = v153.velocity
                v154.snapshot_time = v151 + GhostClustersMotionCodec.unwrap_elapsed_sec(v149, v10)
                local set_speed = v154.animator.set_speed
                local X = v153.velocity.X
                local Z = v153.velocity.Z
                set_speed(Vector3.new(X, 0, Z).Magnitude)
            end
        end
    end
end

function v1.get_large_position() -- line 707 | captures: v4
    for v155, v156 in v4 do
        if v156.size == "Large" then
            return v156.visual:GetPivot().Position
        end
    end
    return nil
end

function v1.begin_attack(v157, v158, v159) -- line 716 | captures: v4, Folder, v1
    local v160 = v4[v157]
    if not v160 then
        return
    end
    v1.end_attack(v157)
    v160.attack_kind = v158
    v160.attack_started_at = os.clock()
    v160.attack_spin_angle = 0
    v160.attack_radius = v159
    v160.animator.begin_tornado()
    if v160.size ~= "Large" then
        return
    end
    local Part = Instance.new("Part")
    Part.Name = "GhostClustersTornadoRadius"
    Part.Shape = Enum.PartType.Ball
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true
    Part.Material = Enum.Material.ForceField
    Part.Color = Color3.fromRGB(0, 255, 255)
    Part.Transparency = 0.55
    local v161 = Vector3.new(1, 1, 1)
    local v162 = v159 * 2
    Part.Size = v161 * math.max(0.2, v162)
    Part.CFrame = CFrame.new(v160.cframe.Position)
    Part.Parent = Folder
    v160.attack_radius_part = Part
    v160.maid:GiveTask(Part)
end

function v1.end_attack(v163) -- line 751 | captures: v4
    local v164 = v4[v163]
    if not v164 then
        return
    end
    v164.attack_kind = nil
    v164.attack_spin_angle = 0
    v164.visual:ScaleTo(v164.scale)
    v164.animator.end_attack()
    if v164.attack_radius_part then
        v164.attack_radius_part:Destroy()
        v164.attack_radius_part = nil
    end
end

function v1.fire_attack(v165) -- line 766 | captures: v4
    local v166 = v4[v165]
    if v166 then
        v166.animator.play_hit()
    end
end

function v1.schedule_end_attack(v167) -- line 774 | captures: v2, GhostClustersConstants, v1
    v2:GiveTask(task.delay(GhostClustersConstants.ATTACK_HOLD_SEC, function() -- line 775 | captures: v167, v1
        v1.end_attack(v167)
    end))
end

function v1.play_attack_burst(v168, v169, v170) -- line 780 | captures: v2, Folder, TweenPromise, GhostClustersConstants
    local ATTACK_BURST_START_DIAMETER = GhostClustersConstants.ATTACK_BURST_START_DIAMETER
    local v171 = v169 * 2
    local v172 = math.max(ATTACK_BURST_START_DIAMETER, v171)
    local Part = Instance.new("Part")
    Part.Name = "GhostClustersAttackBurst"
    Part.Shape = Enum.PartType.Ball
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true
    Part.Material = Enum.Material.ForceField
    Part.Color = Color3.fromRGB(0, 255, 255)
    Part.Transparency = 0.12
    Part.Size = Vector3.new(1, 1, 1) * ATTACK_BURST_START_DIAMETER
    Part.CFrame = CFrame.new(v168)
    Part.Parent = Folder
    v2:GiveTask(TweenPromise.new(Part, TweenInfo.new(GhostClustersConstants.ATTACK_BURST_SEC, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Transparency = 1,
        Size = Vector3.new(1, 1, 1) * v172
    }):andThen(function() -- line 807 | captures: Part
        Part:Destroy()
    end))
end

function v1.play_boss_defeat(v173) -- line 816 | captures: v4, v9, SoundService, SoundPlayer, GhostClustersMotion
    local v174
    for v175, v176 in v4 do
        if v176.size == "Large" then
            v174 = v176
            break
        end
        v174 = nil
    end
    if v174 then
        v174.defeated = true
        v174.attack_kind = nil
        if v174.attack_radius_part then
            v174.attack_radius_part:Destroy()
            v174.attack_radius_part = nil
        end
        v174.animator.end_attack()
        v174.animator.set_cowering(true)
        v174.animator.set_speed(0)
        local v177 = v174.visual:GetPivot()
        local v178 = GhostClustersMotion.flat_unit(v177.LookVector)
        v9 = {
            driving = true,
            poofed = false,
            id = v174.id,
            from_position = v177.Position,
            from_look = v178,
            orbit_right = Vector3.new(0, 1, 0):Cross(v178),
            from_scale = v174.visual:GetScale(),
            started_at = os.clock(),
            on_position = v173
        }
        SoundPlayer.FX:play("GhostClusters/BigGhostBuildUp", SoundService)
        v173(v177.Position)
        local v179 = v174
        return function() -- line 856 | captures: v179, v9
            if v9 and v9.id == v179.id then
                v9.driving = false
            end
        end
    end
    return function() -- line 825
    end
end

function v1.absorb_toward(v180, v181) -- line 863 | captures: v4, v6, v7, v8
    v6 = v180
    v7 = os.clock()
    v8 = v181
    for v182, v183 in v4 do
        if v183.size ~= "Large" then
            v183.absorb_from = v183.cframe
        end
    end
end

local function spawn_ephemeral(v184, v185, v186) -- line 874 | captures: v2, Folder, RunService, GhostClustersGhostAnimator, GhostClustersGhosts
    local v187 = GhostClustersGhosts.get_template(v184):Clone()
    GhostClustersGhosts.prepare_ghost_model(v187)
    local v188, v189 = v187:GetBoundingBox()
    local Part = Instance.new("Part")
    Part.Name = "AimQuery"
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = true
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Massless = true
    Part.Transparency = 1
    Part.Size = v189
    Part.CFrame = v188
    Part.Parent = v187
    v187.Parent = Folder
    GhostClustersGhosts.clear_effects(v187)
    local v190 = GhostClustersGhostAnimator.create(v187, v184)
    v185(v187, v190)
    local v191 = false
    local v192

    local function cleanup() -- line 887 | captures: v191, v192, v187, v190, GhostClustersGhosts
        if v191 then
            return
        end
        v191 = true
        GhostClustersGhosts.set_effects_enabled(v187, false)
        v190.destroy()
        if v192.Connected then
            v192:Disconnect()
        end
        v187:Destroy()
    end

    v192 = RunService.RenderStepped:Connect(function() -- line 899 | captures: v191, v192, v186, v187, v190, GhostClustersGhosts
        if v186(v187) then
            return
        end
        if v191 then
            return
        end
        v191 = true
        GhostClustersGhosts.set_effects_enabled(v187, false)
        v190.destroy()
        if v192.Connected then
            v192:Disconnect()
        end
        v187:Destroy()
    end)
    v2:GiveTask(cleanup)
    return cleanup
end

local function ease_out(v193) -- line 908
    return 1 - (1 - v193) * (1 - v193)
end

local function ease_in(v194) -- line 912
    return v194 * v194
end

local function smoothstep(v195) -- line 916
    return v195 * v195 * (3 - v195 * 2)
end

local function set_visual_transparency(v196, v197) -- line 920
    for v198, v199 in v196:GetDescendants() do
        if v199:IsA("BasePart") then
            v199.LocalTransparencyModifier = v197
        end
    end
end

function v1.play_intro_entrance(v200, v201, v202, v203) -- line 931 | captures: v3, GhostClustersClientConstants, GhostClustersConstants, GhostClustersGhosts, GhostClustersMotion, v1, spawn_ephemeral, set_visual_transparency
    local Position = v200:GetBoundingBox().Position
    local v204 = GhostClustersMotion.flat_unit(v202 - v201)
    local v205 = GhostClustersMotion.flat_unit(Position - v201)
    local Y = v204:Cross(v205).Y
    local v206 = v204:Dot(v205)
    local v207 = math.atan2(Y, v206)
    local INTRO_RISE_SEC = GhostClustersClientConstants.INTRO_RISE_SEC
    local INTRO_SEC = GhostClustersClientConstants.INTRO_SEC
    local v208 = INTRO_SEC - INTRO_RISE_SEC
    if v208 <= 0 then
        error("Ghost Clusters intro entrance has no time after the rise")
    end
    local v209 = v201 - Vector3.new(0, 1, 0) * GhostClustersClientConstants.INTRO_BURY
    local v210 = v201 + Vector3.new(0, 1, 0) * GhostClustersClientConstants.INTRO_RISE_HEIGHT
    local v211 = Position + v205 * GhostClustersClientConstants.INTRO_FRAME_INSET
    local v212 = os.clock()
    local v213 = 1
    local v214
    local v215 = false

    local function pose_at(v216) -- line 956 | captures: v204, v207, INTRO_RISE_SEC, v208, v209, v210, v211, GhostClustersClientConstants
        local v217 = INTRO_RISE_SEC <= v216
        local v218, v219, v220, v221
        if v217 then
            local v222 = (v216 - INTRO_RISE_SEC) / v208
            v220 = math.clamp(v222, 0, 1)
            v219 = v210:Lerp(v211, v220 * v220)
            local v223 = v220 / GhostClustersClientConstants.INTRO_HIDE_PORTION
            local v224 = math.clamp(v223, 0, 1)
            v221 = 1 - (1 - v224) * (1 - v224)
            v218 = v207 * (v220 * v220 * (3 - v220 * 2)) + (1 - (1 - v220) * (1 - v220)) * GhostClustersClientConstants.INTRO_TWIRL_TURNS * 3.141592653589793 * 2
        else
            local v225 = v216 / INTRO_RISE_SEC
            v219 = v209:Lerp(v210, 1 - (1 - v225) * (1 - v225))
            v218 = 0
            v221 = 0
            v220 = 0
        end
        local v226 = CFrame.Angles(0, v218, 0):VectorToWorldSpace(v204)
        return CFrame.lookAt(v219, v219 + v226), v220, v221, v217
    end

    local function apply(v227, v228) -- line 977 | captures: v213, v214, v215, v203, INTRO_SEC, pose_at, GhostClustersConstants, set_visual_transparency
        local v229 = INTRO_SEC <= v228
        local v230 = if v229 then INTRO_SEC else v228
        local v231, v232, v233, v234 = pose_at(v230)
        if v234 and not v215 then
            v215 = true
            v214.set_cowering(true)
        end
        local v235 = v213 * (1 + (GhostClustersConstants.BOSS_SHIELDED_SCALE - 1) * v233)
        local v236 = v227:GetScale() - v235
        if math.abs(v236) > 0.001 then
            v227:ScaleTo(v235)
        end
        if v233 > 0 then
            set_visual_transparency(v227, GhostClustersConstants.BOSS_SHIELDED_TRANSPARENCY * v233)
        end
        if v229 then
            v203(v231, 1)
            return false
        end
        v227:PivotTo(v231)
        v203(v231, v232)
        return true
    end

    v1.stop_intro_entrance()
    local MURAL_MODEL_NAME = GhostClustersGhosts.MURAL_MODEL_NAME

    local function v237(v238, v239) -- line 1001 | captures: v213, v214, apply
        v214 = v239
        v214.set_speed(10)
        v213 = v238:GetScale()
        apply(v238, 0)
    end

    v3 = spawn_ephemeral(MURAL_MODEL_NAME, v237, function(v240) -- line 1007 | captures: v212, apply
        return (apply(v240, os.clock() - v212))
    end)
    return v1.stop_intro_entrance
end

local function bezier_point(v241, v242, v243, v244, v245) -- line 1013
    local v246 = v241:Lerp(v242, v245)
    local v247 = v242:Lerp(v243, v245)
    local v248 = v243:Lerp(v244, v245)
    return v246:Lerp(v247, v245):Lerp(v247:Lerp(v248, v245), v245)
end

local function attach_cast_trail(v249) -- line 1020 | captures: GhostClustersConstants
    local RootPart = v249.RootPart
    local Attachment = Instance.new("Attachment")
    local v250 = RootPart.Size.Y * 0.22
    local v251 = RootPart.Size.Z * 0.2
    Attachment.Position = Vector3.new(0, v250, v251)
    Attachment.Parent = RootPart
    local Attachment_2 = Instance.new("Attachment")
    local v252 = -RootPart.Size.Y * 0.12
    local v253 = RootPart.Size.Z * 0.35
    Attachment_2.Position = Vector3.new(0, v252, v253)
    Attachment_2.Parent = RootPart
    local Trail = Instance.new("Trail")
    Trail.Attachment0 = Attachment
    Trail.Attachment1 = Attachment_2
    Trail.Lifetime = GhostClustersConstants.GHOST_CAST_TRAIL_LIFETIME
    Trail.MinLength = 0.05
    Trail.FaceCamera = true
    Trail.LightEmission = 0.7
    Trail.LightInfluence = 0.2
    Trail.WidthScale = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(1, 0.05)
    })
    Trail.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.15),
        NumberSequenceKeypoint.new(1, 1)
    })
    Trail.Color = ColorSequence.new(Color3.fromRGB(210, 245, 255), Color3.fromRGB(170, 120, 255))
    Trail.Enabled = true
    Trail.Parent = RootPart
    return Trail
end

function v1.play_cast(v254, v255, v256) -- line 1050 | captures: GhostClustersConstants, GhostClustersGhosts, spawn_ephemeral, set_visual_transparency, bezier_point, attach_cast_trail
    local v257 = GhostClustersGhosts.model_name_for_size(v256)
    local v258 = v255.X - v254.X
    local v259 = v255.Z - v254.Z
    local v260 = Vector3.new(v258, 0, v259)
    local v261
    if v260.Magnitude > 0.05 then
        v261 = v260.Unit
    else
        v261 = Vector3.new(0, 0, 1)
    end
    local v262 = Vector3.new(0, 1, 0):Cross(v261)
    local GHOST_CAST_EXIT_DISTANCE = GhostClustersConstants.GHOST_CAST_EXIT_DISTANCE
    local v263 = v260.Magnitude * 0.35
    local v264 = math.max(v263, 4)
    local v265 = math.min(GHOST_CAST_EXIT_DISTANCE, v264)
    local GHOST_CAST_EXIT_HEIGHT = GhostClustersConstants.GHOST_CAST_EXIT_HEIGHT
    local v266 = (math.random() * 2 - 1) * GhostClustersConstants.GHOST_CAST_WEAVE
    local v267 = v254 + v261 * v265 + Vector3.new(0, 1, 0) * GHOST_CAST_EXIT_HEIGHT
    local v268 = v255 + Vector3.new(0, 1, 0) * (GHOST_CAST_EXIT_HEIGHT * 0.35) + v262 * v266
    local GHOST_CAST_TRAVEL_SEC = GhostClustersConstants.GHOST_CAST_TRAVEL_SEC
    local v269 = os.clock()
    local v270
    local v271 = false
    local v272 = v261

    local function v273(v274, v275) -- line 1066 | captures: v270, v254, v272, attach_cast_trail
        v270 = attach_cast_trail(v274)
        v274:PivotTo(CFrame.lookAt(v254, v254 + v272))
        v275.set_speed(10)
    end

    spawn_ephemeral(v257, v273, function(v276) -- line 1070 | captures: v270, v271, v254, v255, v267, v268, GHOST_CAST_TRAVEL_SEC, v269, v272, set_visual_transparency, bezier_point
        local v277 = os.clock() - v269
        local v278 = v277 / GHOST_CAST_TRAVEL_SEC
        local v279 = math.clamp(v278, 0, 1)
        local v280 = v279 * v279 * (3 - v279 * 2)
        local v281 = bezier_point(v254, v267, v268, v255, v280)
        local v282 = v280 + 0.04
        local v283 = bezier_point(v254, v267, v268, v255, (math.min(v282, 1))) - v281
        if v283.Magnitude < 0.05 then
            v283 = v272
        end
        v276:PivotTo(CFrame.lookAt(v281, v281 + v283))
        if v279 >= 1 and not v271 then
            v271 = true
            set_visual_transparency(v276, 1)
            v270.Enabled = false
        end
        return v277 < GHOST_CAST_TRAVEL_SEC + v270.Lifetime
    end)
end

return v1
