-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local CloudValues = load("CloudValues")
local LiveOpsTime = load("LiveOpsTime")
local v1 = require("../../CloudValueSchemas/spotlight")
local t1 = {}
local v2 = table.freeze({
    minigame_id = "spotlight",
    minigame_event_id = "halloween_2026",
    minigame_destination_id = "CircusMinigameInterior",
    minigame_music_id = "Halloween2026SpotlightMusic",
    minigame_schedule_order = 0,
    minigame_entry_lead = 2,
    minigame_max_players = 16,
    minigame_entry_cover_timeout = 30,
    join_zone_name = "SpotlightMinigameJoinZone",
    join_zone_marker_name = "SpotlightJoinZoneMarker",
    join_zone_resource_name = "JoinZone",
    join_zone_destination_id = "Circus",
    resource_folder_name = "Resources",
    resource_spotlight_folder_name = "Spotlight",
    resource_prefab_attribute = "SpotlightPrefab",
    resource_wait_timeout = 10,
    scene_static_map_suffix = "Static",
    scene_aim_point_folder_name = "AimPoints",
    scene_stage_centre_name = "StageCentre",
    scene_directions = table.freeze({ "SpotlightClockwise", "SpotlightCounterclockwise" }),
    scene_direction_signs = table.freeze({
        SpotlightClockwise = 1,
        SpotlightCounterclockwise = -1
    }),
    ceiling_orange_ring_name = "SpinOrange",
    ceiling_yellow_ring_name = "SpinYellow",
    ceiling_spin_period = 36,
    spawn_name = "PlayerSpawn",
    spawn_cover_lift = 3,
    spawn_pad_clearance = 4,
    spawn_pad_height = 10,
    act_count = 5,
    act_zero_duration = 22.5,
    act_duration = 19.5,
    act_throw_count = 3,
    act_throw_lead = 1.867,
    cutscene_duration = 5,
    cutscene_look_height = 2.5,
    cutscene_drift_rate = 1.3,
    cutscene_drift_sway = 0.22,
    cutscene_drift_tilt = 0.006108652381980153,
    cutscene_react_delay = 0.12,
    cutscene_jolt_attack = 3,
    cutscene_jolt_recovery = 8,
    cutscene_landing = 1,
    cutscene_land_from = 3,
    cutscene_land_to = 2.8,
    cutscene_land_height = 0.3,
    cutscene_land_fov = 32,
    cutscene_land_zoom_fov = 56,
    cutscene_land_lead = 5,
    cutscene_land_trail = 2,
    cutscene_feet_height = 0.5,
    cutscene_flinch_back = 0.6,
    cutscene_flinch_drop = 0.4,
    cutscene_flinch_duration = 0.45,
    cutscene_shake_duration = 0.4,
    cutscene_shake_rate = 12,
    cutscene_shake_tilt = 0.008726646259971648,
    cutscene_shake_roll = 0.005235987755982988,
    cutscene_present_from = 1.2,
    cutscene_present_to = 2.6,
    cutscene_present_lead = 2,
    cutscene_present_trail = 6,
    cutscene_present_lean = 0.05235987755982989,
    cutscene_present_distance = 3.4,
    cutscene_present_height = 0.3,
    cutscene_present_look = 0.07,
    cutscene_present_fov = 70,
    cutscene_gaze_from = 2.6,
    cutscene_gaze_to = 3.5,
    cutscene_gaze_look = 0.4,
    cutscene_clunk_back = 0.3,
    cutscene_clunk_fov = 2,
    cutscene_clunk_duration = 0.4,
    cutscene_face_height = 1.6,
    cutscene_face_ahead = 0.5,
    cutscene_copycat_wake = 4.5,
    cutscene_return_from = 3.2,
    cutscene_return_speed_up = 0.35,
    cutscene_return_stop = 0.15,
    cutscene_return_cruise_by = 4.05,
    cutscene_return_glide_from = 3.4,
    cutscene_return_glide_speed_up = 0.15,
    cutscene_return_settle_from = 4.4,
    cutscene_return_swing_from = 3.4,
    cutscene_return_swing_to = 3.9,
    cutscene_return_unswing_from = 4.3,
    cutscene_return_detour_step = 3,
    cutscene_return_max_detour = 36,
    cutscene_return_checks = 60,
    cutscene_return_clearance = 0.5,
    cutscene_return_min_distance = 6,
    cutscene_return_max_distance = 30,
    cutscene_return_height = 2,
    cutscene_bank_max = 0.10471975511965978,
    cutscene_bank_pull = 200,
    cutscene_bank_window = 0.1,
    camera_default_fov = 70,
    ringmaster_rig_name = "HoneyBunnyRig",
    ringmaster_scale = 5,
    ringmaster_torso_bone_name = "Torso",
    ringmaster_held_club = "Pin01",
    ringmaster_clubs = table.freeze({
        Pin01 = table.freeze({ "Metal1_Geo", "PinBase1_Geo", "PinTrim1_Geo", "Shaft1_Geo" }),
        Pin02 = table.freeze({ "Metal_Geo", "PinBase_Geo", "PinTrim_Geo", "Shaft_Geo" }),
        Pin03 = table.freeze({ "Metal2_Geo", "PinBase2_Geo", "PinTrim2_Geo", "Shaft2_Geo" })
    }),
    ringmaster_club_name = "JugglingClub",
    ringmaster_club_handle_name = "Shaft1_Geo",
    ringmaster_club_grip_name = "GripAttachment",
    ringmaster_state_attribute = "RingmasterState",
    ringmaster_throw_target_attribute = "ThrowTarget",
    ringmaster_reacted_attribute = "ReactedAt",
    ringmaster_transform_marker = "ModelTransform",
    ringmaster_jump_start = 0.3,
    ringmaster_trick2_duration = 9.6,
    ringmaster_first_aim_scale = 2,
    ringmaster_appear_poof_amount = 2,
    ringmaster_throw_duration = 2.133,
    ringmaster_club_release = 1.5,
    ringmaster_turn_speed = 6,
    ringmaster_club_arc_height = 6,
    ringmaster_club_spin_period = 0.35,
    ringmaster_club_rest_lift = 0.25,
    ringmaster_club_linger_duration = 1.7,
    ringmaster_club_density = 100,
    ringmaster_club_collision_group = "noncollide",
    ringmaster_animation_prefix = "Halloween2026HoneyBunny",
    ringmaster_animations = table.freeze({
        Jump = false,
        Summon = false,
        Aim = false,
        AimHold = true,
        Throw = false,
        Trick2 = true
    }),
    ringmaster_state_animations = table.freeze({
        aim = "Aim",
        throw = "Throw",
        summon = "Summon"
    }),
    ringmaster_hold_animations = table.freeze({
        aim = "AimHold"
    }),
    ringmaster_animation_lengths = table.freeze({
        Jump = 0.967,
        Summon = 1.233,
        Aim = 1.233,
        Throw = 2.133,
        Trick2 = 4.8
    }),
    ringmaster_react_animation = "",
    aim_dot_count = 18,
    aim_dot_size = 1,
    aim_flow_rate = 2,
    aim_start_color = Color3.fromRGB(255, 150, 40),
    aim_end_color = Color3.fromRGB(180, 90, 255),
    aim_ring_dot_count = 10,
    aim_ring_dot_size = 0.9,
    aim_ring_radius = 4.4,
    aim_ring_spin_period = 2.5,
    aim_pulse_period = 0.8,
    aim_light_range = 14,
    aim_light_brightness = 1,
    aim_fade_duration = 0.25,
    aim_min_visible = 0.01,
    aim_steps = 16,
    obstacle_folder_name = "Obstacles",
    obstacle_ground_folder_name = "Bottom",
    obstacle_knocked_down_attribute = "KnockedDown",
    obstacle_base_weight = 1,
    obstacle_break_spread = 2,
    obstacle_break_falloff = 0.5,
    obstacle_shatter_stride = 1,
    obstacle_shatter_far_stride = 1,
    obstacle_shake_amplitude = 0.03,
    obstacle_shake_frequency = 18,
    obstacle_shake_duration = 0.35,
    obstacle_shake_radius = 40,
    marker_spawner_folder_name = "MarkerSpawners",
    marker_ring_name = "PowerupRing",
    marker_token_names = table.freeze({
        speedup = "SpeedToken",
        range = "RangeToken"
    }),
    marker_primary_name = "Primary",
    marker_kind_attribute = "MarkerKind",
    marker_shown_attribute = "ShownAt",
    marker_claimed_attribute = "SpotlightMarkerClaimedAt",
    marker_patterns = table.freeze({
        { "speedup", "range", "speedup", "range", "speedup" },
        { "range", "speedup", "range", "speedup", "range" },
        { "speedup", "speedup", "range", "speedup", "range" },
        { "range", "speedup", "speedup", "range", "speedup" },
        { "speedup", "range", "range", "speedup", "speedup" }
    }),
    marker_speedup_bonus = 8,
    marker_range_bonus = 5,
    marker_claim_radius = 7,
    marker_claim_above = 8,
    marker_claim_below = 2,
    marker_fade_duration = 1.5,
    marker_pop_duration = 0.45,
    marker_pop_scale = 1.6,
    marker_token_height = 5,
    marker_token_bob_period = 3,
    marker_token_bob_height = 0.75,
    marker_token_spin_period = 6,
    marker_flash_duration = 0.9,
    marker_shake_amplitude = 0.025,
    marker_shake_frequency = 16,
    marker_shake_duration = 0.3,
    crypt_key_at_attribute = "SpotlightCryptKeyAt",
    crypt_key_claimed_attribute = "SpotlightCryptKeyClaimed",
    crypt_key_height = 3.5,
    crypt_key_first_act = 3,
    cannon_folder_name = "CandycornCannons",
    cannon_name_prefix = "Cannon",
    cannon_drop_name = "CannonCandycorn",
    cannon_drop_aim_attribute = "SpotlightCannonAim",
    cannon_fire_target_attribute = "FireTarget",
    cannon_fired_attribute = "FiredAt",
    cannon_count = 3,
    cannon_turn_speed = 9,
    cannon_aim_lead = 0.4,
    cannon_aim_reach = 60,
    cannon_landing_lift = 1,
    cannon_volley_stagger = 0.2,
    cannon_volley_shot_count = 8,
    cannon_volley_shot_interval = 0.08,
    cannon_volley_flight_duration = 1.5,
    cannon_volley_spread = 7,
    cannon_stream_interval = 0.24,
    cannon_stream_min_candycorn = 1,
    cannon_stream_max_candycorn = 3,
    cannon_stream_flight_duration = 1.1,
    cannon_stream_spread = 2.5,
    cannon_stream_cluster_spread = 3,
    cannon_stream_fan_angle = 0.6981317007977318,
    cannon_stream_fan_reach = 40,
    cannon_stream_fan_rise = 5,
    cannon_stream_shot_scale = 0.6,
    cannon_stream_muzzle_amount = 0.4,
    candycorn_model_name = "Candycorn",
    candycorn_spawner_folder_name = "CandycornSpawners",
    candycorn_score_attribute = "SpotlightCandycornScore",
    candycorn_radius_attribute = "SpotlightCollectRadius",
    candycorn_spawner_size = Vector3.new(6, 6, 6),
    candycorn_respawn_duration = 30,
    candycorn_max_per_round = 600,
    candycorn_collect_radius = 5,
    candycorn_collect_tolerance = 8,
    candycorn_max_pickup_rate = 25,
    candycorn_poll_ticks = 6,
    candycorn_confirm_timeout = 1,
    candycorn_appear_duration = 0.35,
    candycorn_bob_period = 3,
    candycorn_bob_height = 1,
    candycorn_bob_phase_spread = 20,
    candycorn_spin_period = 4,
    candycorn_lod_rate = 30,
    candycorn_lod_range = 80,
    candycorn_lod_sectors = 16,
    candycorn_lod_layer_split = 20,
    candycorn_collect_duration = 0.45,
    candycorn_collect_pop = 0.2,
    candycorn_collect_pop_scale = 1.35,
    candycorn_collect_arc = 3,
    candycorn_collect_spin = 9.42477796076938,
    candycorn_landing_sparkle = 0.4,
    candycorn_streak_steps = 10,
    candycorn_streak_grace = 1.25,
    candycorn_streak_boost = 1,
    candycorn_sound_debounce = 0.05,
    hit_invincibility_duration = 2.25,
    hit_blink_period = 0.3,
    hit_blink_color = Color3.fromRGB(255, 0, 0),
    hit_blink_transparency = 0,
    hit_pop_height = 5,
    hit_shake_amplitude = 0.04,
    hit_shake_frequency = 18,
    hit_shake_duration = 0.4,
    steal_share = 0.125,
    steal_base = 11,
    steal_max_pieces = 20,
    steal_burst_duration = 0.4,
    steal_burst_min_distance = 5,
    steal_burst_max_distance = 9,
    steal_burst_min_rise = 1,
    steal_burst_max_rise = 7,
    steal_ride_duration = 1.2,
    steal_ride_jitter = 0.35,
    steal_spin_period = 0.6,
    steal_startled_animation = "",
    spotlight_radius = 75,
    spotlight_speed = 10,
    spotlight_opening_speed_scale = 0.75,
    spotlight_closing_speed_scale = 1.6,
    spotlight_start_drop = 100,
    spotlight_opening_chase_speed = 30,
    spotlight_closing_chase_speed = 70,
    spotlight_opening_seek = 0.15,
    spotlight_closing_seek = 0.7,
    spotlight_opening_cooldown = 3,
    spotlight_closing_cooldown = 1,
    spotlight_seek_radius = 60,
    spotlight_latch_grace = 0.6,
    spotlight_sweep_catchup = 2.5,
    spotlight_sweep_height = 10,
    spotlight_sweep_rise = 10,
    spotlight_bob_period = 2.467,
    spotlight_wiggle_amplitude = 0.18,
    spotlight_wiggle_frequency = 1.6,
    spotlight_wiggle_interval = 4,
    spotlight_wiggle_duration = 1.2,
    spotlight_exposure_attribute = "SpotlightExposure",
    spotlight_targeted_attribute = "SpotlightTargeted",
    spotlight_caught_attribute = "SpotlightCaughtAt",
    spotlight_caught_by_attribute = "SpotlightCaughtBy",
    spotlight_discovered_attribute = "SpotlightDiscoveredAt",
    spotlight_stolen_attribute = "SpotlightStolenCandycorn",
    spotlight_expose_duration = 0.5,
    spotlight_conceal_duration = 1,
    spotlight_exposure_step = 0.05,
    spotlight_hunt_narrow = 0.3,
    spotlight_hunt_color = Color3.fromRGB(255, 132, 24),
    spotlight_hunt_pulse_rate = 1.6,
    spotlight_hunt_pulse_floor = 0.35,
    spotlight_hunt_fade_duration = 0.35,
    spotlight_lamp_steps = 32,
    spotlight_fizzle_duration = 1.5,
    spotlight_fizzle_flicker_frequency = 13,
    spotlight_fizzle_flicker_depth = 0.55,
    spotlight_turn_speed = 18,
    spotlight_update_interval = 0.05,
    spotlight_stream_depth = 3,
    spotlight_stream_catchup = 0.3,
    spotlight_stream_max_drift = 0.25,
    spotlight_stream_max_queue = 9,
    copycat_shaft_name = "CopycatShaft",
    copycat_pole_name = "Pole",
    copycat_pole_top_name = "Top",
    copycat_pole_bottom_name = "Bottom",
    copycat_side_name = "CopycatSide",
    copycat_bottom_name = "CopycatBottom",
    copycat_mouth_name = "MouthInterior",
    copycat_min_tilt = 0.7504915783575618,
    bottom_spotlight_uses_side_model = false,
    illuminator_folder_name = "IlluminatorSpawners",
    illuminator_name_prefix = "Illuminator",
    illuminator_count = 6,
    illuminator_turn_speed = 4,
    illuminator_idle_output = 0.15,
    illuminator_reach_angle = 1.0471975511965976,
    rig_head_name = "Head",
    rig_cone_name = "Spotlight",
    rig_yaw_hinge_name = "YRot",
    rig_pitch_hinge_name = "XRot",
    rig_yaw_dead_zone = 0.5,
    rig_aim_snap = 0.01,
    motor_sound_name = "RotateSound",
    motor_top_speed = 3,
    motor_spool_duration = 0.12,
    motor_load_smoothing = 0.25,
    motor_stall_load = 25,
    motor_slip = 0.2,
    motor_idle_pitch = 0.35,
    motor_top_pitch = 1.4,
    motor_speed_volume = 0.5,
    motor_load_volume = 0.35,
    motor_sound_step = 0.01,
    movement_buff_key = "spotlight_movement",
    movement_speed_bonus_attribute = "SpotlightSpeedBonus",
    movement_base_walk_speed = 16,
    movement_base_jump_power = 50,
    dash_button_name = "SpotlightDash",
    dash_button_image = "rbxassetid://71956613045280",
    dash_button_theme = "yellow",
    dash_keys_action_name = "SpotlightDashKeys",
    dash_keyboard_keys = table.freeze({
        Enum.KeyCode.LeftShift,
        Enum.KeyCode.RightShift,
        Enum.KeyCode.E,
        Enum.KeyCode.One
    }),
    dash_gamepad_key = Enum.KeyCode.ButtonX,
    dash_jump_gap = 16,
    dash_speed_bonus = 14,
    dash_boost_duration = 3,
    dash_recharge_duration = 3,
    dash_recharge_speedup_cut = 0.4,
    dash_stamp_scale_name = "SpotlightDashStamp",
    dash_stamp_scale = 2.4,
    dash_stamp_start = Vector2.new(0.5, 0.6666666666666666),
    dash_stamp_tilt = 8,
    dash_stamp_fade_duration = 0.05,
    dash_stamp_hold_duration = 0.5,
    dash_stamp_drop_duration = 0.32,
    dash_stamp_squash = 0.2,
    dash_stamp_settle_duration = 0.25,
    dash_stamp_shake_amplitude = 0.012,
    dash_stamp_shake_frequency = 20,
    dash_stamp_shake_duration = 0.2,
    dash_spring_frequency = 8.5,
    dash_spring_damping = 20,
    dash_punch_squash = 0.25,
    dash_punch_duration = 0.25,
    dash_pulse_duration = 0.65,
    dash_pulse_scale = 0.3,
    dash_pulse_frequency = 3.5,
    dash_pulse_damping = 7,
    dash_pulse_tilt = 12,
    dash_pulse_tilt_frequency = 1.75,
    dash_pulse_brighten = 0.6,
    dash_breath_period = 1.6,
    dash_breath_scale = 0.04,
    dash_breath_brighten = 0.18,
    dash_breath_unused_scale = 0.15,
    dash_breath_unused_tilt = 10,
    hint_duration = 5,
    hint_sprint_keyboard = "Press E for a Speed Boost!",
    hint_powerup_kind = table.freeze({
        speedup = "Go fast! Speed increased!",
        range = "Sticky situation! Magnet range increased"
    }),
    hint_first_spotted = "Avoid Stitches' Spotlight to keep your Candy!",
    hint_volley_pickup = "Boom! Candy boost!",
    hint_crypt_key = "You found a Crypt Key!",
    speed_full_at_bonuses = 2,
    speed_ramp = 6,
    speed_min_effort = 0.4,
    speed_min_visible = 0.004,
    speed_fov_gain = 14,
    speed_kick_fov = 9,
    speed_kick_duration = 0.65,
    speed_kick_shake_amplitude = 0.012,
    speed_kick_shake_frequency = 22,
    speed_trail_window = 0.5,
    speed_trail_min_length = 0.4,
    speed_trail_fade = 10,
    speed_trail_limbs = table.freeze({ "LeftHand", "RightHand", "LeftFoot", "RightFoot" }),
    speed_trail_width = 0.8,
    speed_trail_core = Color3.fromRGB(245, 253, 255),
    speed_trail_glow = Color3.fromRGB(110, 225, 255),
    speed_trail_tail = Color3.fromRGB(165, 95, 255),
    speed_spark_rate = 40,
    speed_spark_burst = 24,
    trampoline_folder_name = "Trampolines",
    trampoline_upwards_velocity = 100,
    trampoline_launch_duration = 0.1,
    trampoline_upper_height_cutoff = 8.5,
    trampoline_lower_height_cutoff = -10,
    teleporter_folder_name = "Teleporters",
    teleporter_ring_name = "OuterRing",
    teleporter_disc_name = "Top",
    teleporter_ring_color_attribute = "RingColor",
    teleporter_aura_tint_attribute = "AuraTint",
    teleporter_particle_color_attribute = "ParticleColor",
    teleporter_hover_height = 3,
    teleporter_hover_duration = 0.6,
    teleporter_sphere_radius = 4,
    teleporter_aura_whiten = 0.45,
    teleporter_sphere_transparency = 0.3,
    teleporter_sphere_pop_duration = 0.3,
    teleporter_sphere_squeeze = 0.8,
    teleporter_sphere_brightness = 3,
    teleporter_sphere_light_range = 14,
    teleporter_glow_fill_transparency = 0.6,
    teleporter_glow_outline_transparency = 0.1,
    teleporter_charge_rate = 45,
    teleporter_beam_width = 0.6,
    teleporter_beam_tail_transparency = 0.9,
    teleporter_beam_head_transparency = 0.15,
    teleporter_departure_burst = 0.6,
    teleporter_fade_duration = 0.25,
    teleporter_recharge_duration = 3,
    teleporter_recharge_peak = 0.5,
    teleporter_shake_amplitude = 0.05,
    teleporter_shake_frequency = 0.35,
    teleporter_shake_dissipate_duration = 0.45,
    teleporter_transit_duration = 0.6,
    billboard_max_distance = 80,
    score_billboard_name = "SpotlightScoreBillboard",
    score_billboard_size = UDim2.fromScale(2.4, 0.9),
    score_billboard_offset = Vector3.new(0, 2.4, 0),
    score_billboard_text_color = Color3.fromRGB(255, 248, 232),
    score_billboard_accent_color = Color3.fromRGB(255, 148, 40),
    score_billboard_stroke_color = Color3.fromRGB(92, 42, 12),
    score_billboard_stroke_thickness = 2,
    score_billboard_pop_duration = 0.28,
    score_billboard_pop_scale = 1.4,
    leaderboard_size = 6,
    leaderboard_sign_name = "LeaderboardSign",
    leaderboard_list_name = "Entries",
    leaderboard_row_prefix = "LeaderboardEntry",
    leaderboard_name_label_name = "DisplayName",
    leaderboard_score_name = "Score",
    leaderboard_score_label_name = "Text",
    reveal_bar_name = "SpotlightRevealBar",
    reveal_bar_size = UDim2.fromScale(2.6, 0.32),
    reveal_bar_offset = Vector3.new(0, 3.35, 0),
    reveal_bar_corner = UDim.new(0.5, 0),
    reveal_bar_inset = 2,
    reveal_bar_background_color = Color3.fromRGB(28, 24, 36),
    reveal_bar_stroke_color = Color3.fromRGB(20, 16, 28),
    reveal_bar_stroke_thickness = 1.5,
    reveal_bar_hidden_color = Color3.fromRGB(255, 214, 92),
    reveal_bar_spotted_color = Color3.fromRGB(255, 72, 48),
    flash_display_order = -10,
    flash_color = Color3.fromRGB(255, 244, 214),
    flash_brightness = 0.45,
    flash_min_inset = 0.1,
    flash_max_inset = 0.34,
    flash_rise_duration = 0.12,
    targeted_vignette_fade_duration = 0.25,
    targeted_vignette_min_visible = 0.01,
    visual_folder_name = "SpotlightVisuals",
    visual_min_scale = 0.01,
    ease_back_overshoot = 1.7,
    sound_folder_name = "Spotlight",
    sound_intro = "Spotlight/IntroCutscene",
    sound_ringmaster_windup = "Spotlight/ThrowR",
    sound_club_poof = "Spotlight/ClubPoof",
    sound_obstacle_hit = "Spotlight/Break",
    sound_marker_appear = "Spotlight/PowerupAppear",
    sound_marker_kind_activated = table.freeze({
        speedup = "Spotlight/SpeedUp",
        range = "Spotlight/MagnetUp"
    }),
    sound_cannon_turn = "Spotlight/CannonTurn",
    sound_cannon_shoot = "Spotlight/CannonShoot",
    sound_candycorn_collect = "Spotlight/CandyCorn",
    sound_candycorn_collect_count = 4,
    sound_copycat_new = "Spotlight/NewSpotlight",
    sound_spotlight_fill = "Spotlight/SpotlightFill",
    sound_spotlight_hit = "Spotlight/SpotlightHit",
    sound_dash = "Spotlight/Dash",
    sound_dash_drop = "Spotlight/SprintButtonStick",
    sound_dash_stamp = "Spotlight/ButtonStamp",
    sound_trampoline_bounce = "Spotlight/Bounce",
    sound_teleporter_launch = "Spotlight/Teleport",
    music_hold_priority = 102,
    music_powerup_speedup = 0.1,
    vfx_folder_name = "Vfx",
    vfx_default_emit_count = 20,
    vfx_lifetime_margin = 0.5,
    vfx_trail_max_lifetime = 5,
    vfx_trail_ribbon_name = "Ribbon",
    vfx_trail_sparks_name = "Sparks",
    vfx_poof = "Poof",
    vfx_obstacle_shatter = "BoardShatter",
    vfx_marker_activated = "MarkerActivated",
    vfx_cannon_muzzle = "CannonMuzzle",
    vfx_candycorn_land = "CandycornLand",
    vfx_candycorn_appear = "CandycornAppear",
    vfx_candycorn_collect = "CandycornCollect",
    vfx_candycorn_trail = "CandycornTrail",
    vfx_steal_trail = "StolenCandycornTrail",
    vfx_copycat_chomp = "Chomp",
    vfx_teleport_charge = "TeleportCharge",
    vfx_teleport_burst = "TeleportBurst"
})

local function read_constants() -- line: 671
    -- upvalues: CloudValues (copy), v1 (copy), v2 (copy)
    local v3 = table.clone(v2)

    for v4 in v1 do
        v3[v4] = CloudValues:getValue("spotlight", v4)
    end

    return table.freeze(v3)
end

t1.CONSTANTS = read_constants()
CloudValues:onChange(function() -- line: 682
    -- upvalues: t1 (copy), read_constants (copy)
    t1.CONSTANTS = read_constants()
end)

function t1.get_turn(p1, p2) -- line: 686
    return (p2 - p1 + 3.141592653589793) % 6.283185307179586 - 3.141592653589793
end

function t1.pair_by_angle(p3, p4, p5) -- line: 690
    -- upvalues: t1 (copy)
    local get_turn = t1.get_turn
    local t2 = {}
    local t3 = {}
    local n1 = 1e999

    local function crosses(p6, p7) -- line: 696
        -- upvalues: p3 (copy), p4 (copy), get_turn (copy), t2 (copy)
        for v5, v6 in t2 do
            local v7 = get_turn(p3[p7], p3[v6])

            if v7 * (v7 + get_turn(p3[v6], p4[v5]) - get_turn(p3[p7], p4[p6])) < 0 then
                return true
            end
        end

        return false
    end

    local function search(p8, p9) -- line: 711
        -- upvalues: p3 (copy), p4 (copy), p5 (copy), get_turn (copy), t2 (copy), t3 (ref), n1 (ref), crosses (copy), search (copy)
        if n1 <= p9 then
            return
        end

        if #p4 < p8 then
            n1 = p9
            t3 = {}

            for v8, v9 in t2 do
                local t4 = t3

                t4[v9] = v8
            end
        else
            for v10, v11 in p3 do
                local v13 = math.abs((get_turn(v11, p4[p8])))

                if v13 <= p5 and not table.find(t2, v10) and not crosses(p8, v10) then
                    t2[p8] = v10
                    search(p8 + 1, p9 + v13)
                    t2[p8] = nil
                end
            end
        end
    end

    search(1, 0)

    return t3
end

function t1.get_spotlight_lap_duration() -- line: 740
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS

    return CONSTANTS.spotlight_radius / CONSTANTS.spotlight_speed
end

function t1.get_spotlight_sweep_bob() -- line: 746
    -- upvalues: t1 (copy)
    return t1.get_spotlight_lap_duration() / t1.CONSTANTS.spotlight_bob_period
end

function t1.get_play_length() -- line: 750
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS

    return CONSTANTS.act_zero_duration + CONSTANTS.act_count * CONSTANTS.act_duration
end

function t1.get_intermission_length() -- line: 756
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS

    return CONSTANTS.minigame_entry_lead + CONSTANTS.cutscene_duration
end

function t1.get_round_ends_at(p10) -- line: 762
    -- upvalues: LiveOpsTime (copy), t1 (copy)
    return os.clock() + p10 - LiveOpsTime.now() + t1.get_play_length()
end

function t1.get_ringmaster_entrance() -- line: 766
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS

    return CONSTANTS.cutscene_landing - CONSTANTS.ringmaster_animation_lengths.Jump + CONSTANTS.ringmaster_jump_start
end

function t1.get_ringmaster_trick_start() -- line: 772
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS

    return CONSTANTS.cutscene_landing + CONSTANTS.ringmaster_animation_lengths.Summon
end

function t1.get_ringmaster_intro_duration() -- line: 778
    -- upvalues: t1 (copy)
    return t1.get_ringmaster_trick_start() + t1.CONSTANTS.ringmaster_trick2_duration
end

function t1.get_ringmaster_aim_duration() -- line: 782
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS

    return CONSTANTS.act_duration / CONSTANTS.act_throw_count - CONSTANTS.ringmaster_throw_duration - CONSTANTS.ringmaster_animation_lengths.Summon
end

function t1.get_ringmaster_encore_duration(p11) -- line: 790
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS
    local Trick2 = CONSTANTS.ringmaster_animation_lengths.Trick2
    local v14 = CONSTANTS.ringmaster_first_aim_scale * t1.get_ringmaster_aim_duration()

    return math.max(math.round((p11 - t1.get_ringmaster_intro_duration() - v14) / Trick2), 0) * Trick2
end

function t1.get_marker_uptime() -- line: 800
    -- upvalues: t1 (copy)
    local CONSTANTS = t1.CONSTANTS

    return CONSTANTS.act_duration - CONSTANTS.act_duration / CONSTANTS.act_throw_count + CONSTANTS.act_throw_lead
end

function t1.approach(p12, p13, p14) -- line: 806
    return p12 + (p13 - p12) * math.min(p14, 1)
end

function t1.get_narrow(p15) -- line: 810
    -- upvalues: t1 (copy)
    return 1 - (1 - t1.CONSTANTS.spotlight_hunt_narrow) * p15
end

function t1.get_resources() -- line: 814
    -- upvalues: ReplicatedStorage (copy), t1 (copy)
    local CONSTANTS = t1.CONSTANTS
    local v17 = ReplicatedStorage:FindFirstChild(CONSTANTS.resource_folder_name) or error((("ReplicatedStorage has no %* folder"):format(CONSTANTS.resource_folder_name)))

    return v17:FindFirstChild(CONSTANTS.resource_spotlight_folder_name) or error((("%* has no %* folder"):format(v17:GetFullName(), CONSTANTS.resource_spotlight_folder_name)))
end

return t1
