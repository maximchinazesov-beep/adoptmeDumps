-- https://lua.expert

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function smootherstep(p1) -- line: 30
    return p1 ^ 3 * (p1 * (p1 * 6 - 15) + 10)
end

local function eased(p2, p3, p4) -- line: 34
    local v4 = math.clamp((p2 - p3) / (p4 - p3), 0, 1)

    return v4 ^ 3 * (v4 * (v4 * 6 - 15) + 10)
end

local function skewed(p5, p6, p7, p8, p9) -- line: 38
    local v6 = math.clamp((p5 - p6) / (p7 - p6), 0, 1)
    local v7 = p8 + p9 + 1
    local n1 = 0
    local n2 = 1

    for i = 0, v7 do
        if p8 < i then
            n1 += n2 * v6 ^ i * (1 - v6) ^ (v7 - i)
        end

        n2 *= (v7 - i) / (i + 1)
    end

    return n1
end

local function pulse(p10, p11, p12) -- line: 54
    if p10 <= 0 or p10 >= 1 then
        return 0
    end

    local v8 = p11 / (p11 + p12)

    return (p10 / v8) ^ p11 * ((1 - p10) / (1 - v8)) ^ p12
end

local function ramp(p13) -- line: 64
    return p13 ^ 6 - p13 ^ 5 * 3 + p13 ^ 4 * 2.5
end

local function arrived(p14, p15, p16) -- line: 68
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local cutscene_return_stop = CONSTANTS.cutscene_return_stop
    local v10 = math.clamp((p14 - p15) / (CONSTANTS.cutscene_duration - p15), 0, 1)
    local v11 = 1 / (1 - (p16 + cutscene_return_stop) / 2)

    if v10 < p16 then
        local v12 = v11 * p16
        local v13 = v10 / p16

        return v12 * (v13 ^ 6 - v13 ^ 5 * 3 + v13 ^ 4 * 2.5)
    end

    if 1 - cutscene_return_stop < v10 then
        local v14 = v11 * cutscene_return_stop
        local v15 = (1 - v10) / cutscene_return_stop

        return 1 - v14 * (v15 ^ 6 - v15 ^ 5 * 3 + v15 ^ 4 * 2.5)
    end

    return v11 * (v10 - p16 / 2)
end

local function get_frames(p17, p18) -- line: 84
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local ringmaster_scale = CONSTANTS.ringmaster_scale

    local function ahead(p19, p20) -- line: 88
        -- upvalues: p17 (copy), p18 (copy), ringmaster_scale (copy)
        return p18.centre + p17 * p19 * ringmaster_scale + Vector3.new(0, 1, 0) * p20 * ringmaster_scale
    end

    local cutscene_face_ahead, cutscene_face_height = CONSTANTS.cutscene_face_ahead, CONSTANTS.cutscene_face_height
    local v16 = p18.centre + p17 * cutscene_face_ahead * ringmaster_scale + Vector3.new(0, 1, 0) * cutscene_face_height * ringmaster_scale
    local t2 = {}
    local cutscene_land_from, cutscene_land_height = CONSTANTS.cutscene_land_from, CONSTANTS.cutscene_land_height

    t2.start = p18.centre + p17 * cutscene_land_from * ringmaster_scale + Vector3.new(0, 1, 0) * cutscene_land_height * ringmaster_scale

    local cutscene_land_to, cutscene_land_height2 = CONSTANTS.cutscene_land_to, CONSTANTS.cutscene_land_height

    t2.landed = p18.centre + p17 * cutscene_land_to * ringmaster_scale + Vector3.new(0, 1, 0) * cutscene_land_height2 * ringmaster_scale

    local cutscene_present_distance, cutscene_present_height = CONSTANTS.cutscene_present_distance, CONSTANTS.cutscene_present_height

    t2.presented = p18.centre + p17 * cutscene_present_distance * ringmaster_scale + Vector3.new(0, 1, 0) * cutscene_present_height * ringmaster_scale

    local cutscene_feet_height = CONSTANTS.cutscene_feet_height

    t2.feet = p18.centre + p17 * 0 * ringmaster_scale + Vector3.new(0, 1, 0) * cutscene_feet_height * ringmaster_scale
    t2.overhead = v16:Lerp(p18.copycat, CONSTANTS.cutscene_present_look)
    t2.gazed = v16:Lerp(p18.copycat, CONSTANTS.cutscene_gaze_look)

    return t2
end

local function build_path(p21, p22, p23, p24, p25) -- line: 105
    -- upvalues: v2 (copy), skewed (copy), arrived (copy)
    local CONSTANTS = v2.CONSTANTS
    local Position = p22.Position
    local v17 = (Position - p21.presented) * Vector3.new(1, 0, 1)
    local v18 = math.max(p21.presented.Y, Position.Y)
    local cutscene_return_speed_up, cutscene_present_from, cutscene_present_to, cutscene_present_lead = CONSTANTS.cutscene_return_speed_up, CONSTANTS.cutscene_present_from, CONSTANTS.cutscene_present_to, CONSTANTS.cutscene_present_lead
    local cutscene_present_trail = CONSTANTS.cutscene_present_trail

    return function(p26) -- line: 117
        -- upvalues: p21 (copy), p22 (copy), p23 (copy), p24 (copy), p25 (copy), CONSTANTS (copy), Position (copy), v17 (copy), v18 (copy), cutscene_return_speed_up (copy), cutscene_present_from (copy), cutscene_present_to (copy), cutscene_present_lead (copy), cutscene_present_trail (copy), skewed (copy), arrived (copy)
        local v19 = skewed(p26, 0, CONSTANTS.cutscene_landing, CONSTANTS.cutscene_land_lead, CONSTANTS.cutscene_land_trail)
        local v20 = skewed(p26, cutscene_present_from, cutscene_present_to, cutscene_present_lead, cutscene_present_trail)
        local cutscene_gaze_from, cutscene_gaze_to = CONSTANTS.cutscene_gaze_from, CONSTANTS.cutscene_gaze_to
        local v22 = math.clamp((p26 - cutscene_gaze_from) / (cutscene_gaze_to - cutscene_gaze_from), 0, 1)
        local v23 = v22 ^ 3 * (v22 * (v22 * 6 - 15) + 10)
        local v24 = -p25 * CONSTANTS.cutscene_present_lean
        local v25 = (p26 - cutscene_present_from) / (cutscene_present_to - cutscene_present_from)
        local v26 = cutscene_present_lead + 1
        local v27

        if v25 <= 0 or v25 >= 1 then
            v27 = 0
        else
            local v28 = v26 / (v26 + cutscene_present_trail)

            v27 = (v25 / v28) ^ v26 * ((1 - v25) / (1 - v28)) ^ cutscene_present_trail
        end

        local v29 = v24 * v27
        local v30 = arrived(p26, CONSTANTS.cutscene_return_from, cutscene_return_speed_up)
        local v31 = p21.start + (p21.landed - p21.start) * v19 + (p21.presented - p21.landed) * v20
        local v32 = p21.feet + (p21.overhead - p21.feet) * v20 + (p21.gazed - p21.overhead) * v23
        local v33 = arrived(p26, CONSTANTS.cutscene_return_glide_from, CONSTANTS.cutscene_return_glide_speed_up)
        local cutscene_return_swing_from, cutscene_return_swing_to = CONSTANTS.cutscene_return_swing_from, CONSTANTS.cutscene_return_swing_to
        local v35 = math.clamp((p26 - cutscene_return_swing_from) / (cutscene_return_swing_to - cutscene_return_swing_from), 0, 1)
        local v36 = v35 ^ 3 * (v35 * (v35 * 6 - 15) + 10) - arrived(p26, CONSTANTS.cutscene_return_unswing_from, cutscene_return_speed_up)
        local cutscene_return_from, cutscene_return_cruise_by = CONSTANTS.cutscene_return_from, CONSTANTS.cutscene_return_cruise_by
        local v38 = math.clamp((p26 - cutscene_return_from) / (cutscene_return_cruise_by - cutscene_return_from), 0, 1)
        local v39 = v38 ^ 3 * (v38 * (v38 * 6 - 15) + 10)
        local v40 = arrived(p26, CONSTANTS.cutscene_return_settle_from, cutscene_return_speed_up)
        local v41 = (v18 - p21.presented.Y) * v39 + (Position.Y - v18) * v40
        local v42 = (CFrame.lookAt(v31, v32).Rotation * CFrame.Angles(0, 0, v29)):Lerp(p22.Rotation, v30)
        local v43 = CONSTANTS.cutscene_land_zoom_fov + (CONSTANTS.cutscene_land_fov - CONSTANTS.cutscene_land_zoom_fov) * v19 + (CONSTANTS.cutscene_present_fov - CONSTANTS.cutscene_land_fov) * v20 + (p23 - CONSTANTS.cutscene_present_fov) * v30

        return CFrame.new(v31 + v17 * v33 + p24 * v36 + Vector3.new(0, 1, 0) * v41) * v42, v43
    end
end

local function is_clear(p27, p28) -- line: 152
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local cutscene_return_from = CONSTANTS.cutscene_return_from
    local v44 = CONSTANTS.cutscene_duration - cutscene_return_from
    local cutscene_return_checks = CONSTANTS.cutscene_return_checks
    local Position = p27(cutscene_return_from).Position

    for i = 1, cutscene_return_checks do
        local Position2 = p27(cutscene_return_from + v44 * i / cutscene_return_checks).Position

        if workspace:Raycast(Position, Position2 - Position, p28) then
            return false
        end

        Position = Position2
    end

    return true
end

local function get_return_distance() -- line: 170
    -- upvalues: Players (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local PlayerModule = Players.LocalPlayer:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule")

    return (math.clamp((require(PlayerModule):GetCameras().activeCameraController or error("Spotlight's cutscene has no camera controller to hand the camera back to")):GetCameraToSubjectDistance(), CONSTANTS.cutscene_return_min_distance, CONSTANTS.cutscene_return_max_distance))
end

local function get_finish(p29, p30, p31, p32) -- line: 184
    -- upvalues: v2 (copy), get_return_distance (copy)
    local CONSTANTS = v2.CONSTANTS
    local v45 = p29 + Vector3.new(0, 1, 0) * CONSTANTS.cutscene_look_height
    local v46 = p29 - p30:Cross((Vector3.new(0, 1, 0))) * p31 * get_return_distance() + Vector3.new(0, 1, 0) * CONSTANTS.cutscene_return_height
    local v47 = workspace:Raycast(v45, v46 - v45, p32)

    if not v47 then
        return CFrame.lookAt(v46, v45)
    end

    local v49 = math.max(v47.Distance - CONSTANTS.cutscene_return_clearance, CONSTANTS.cutscene_return_clearance)

    return CFrame.lookAt(v45 + (v46 - v45).Unit * v49, v45)
end

local function plan_path(p33, p34, p35) -- line: 202
    -- upvalues: v2 (copy), skewed (copy), arrived (copy), get_frames (copy), is_clear (copy), get_finish (copy)
    local CONSTANTS = v2.CONSTANTS
    local v50 = CONSTANTS.scene_direction_signs[p34.direction] or error((("unhandled scene direction %*"):format(p34.direction)))
    local Position = p33.Position
    local Unit = ((Position - p34.centre) * Vector3.new(1, 0, 1)).Unit
    local v51 = get_frames(Unit, p34)
    local t3 = {
        0
    }
    local cutscene_return_detour_step = CONSTANTS.cutscene_return_detour_step

    for i = cutscene_return_detour_step, CONSTANTS.cutscene_return_max_detour, cutscene_return_detour_step do
        table.insert(t3, i)
        table.insert(t3, -i)
    end

    local v52

    for _, v53 in { v50, -v50 } do
        local v54 = get_finish(Position, Unit, v53, p34.blockers)
        local v55 = -Unit:Cross((Vector3.new(0, 1, 0))) * v53
        local v56 = v52

        for _, v57 in t3 do
            local v58 = v55 * v57
            local CONSTANTS = v2.CONSTANTS
            local Position = v54.Position
            local v59 = (Position - v51.presented) * Vector3.new(1, 0, 1)
            local v60 = math.max(v51.presented.Y, Position.Y)
            local cutscene_return_speed_up, cutscene_present_from, cutscene_present_to, cutscene_present_lead = CONSTANTS.cutscene_return_speed_up, CONSTANTS.cutscene_present_from, CONSTANTS.cutscene_present_to, CONSTANTS.cutscene_present_lead
            local cutscene_present_trail = CONSTANTS.cutscene_present_trail

            local function v61(p36) -- line: 117
                -- upvalues: p35 (copy), v51 (copy), v53 (copy), v54 (copy), v58 (copy), CONSTANTS (copy), Position (copy), v59 (copy), v60 (copy), cutscene_return_speed_up (copy), cutscene_present_from (copy), cutscene_present_to (copy), cutscene_present_lead (copy), cutscene_present_trail (copy), skewed (copy), arrived (copy)
                local v62 = skewed(p36, 0, CONSTANTS.cutscene_landing, CONSTANTS.cutscene_land_lead, CONSTANTS.cutscene_land_trail)
                local v63 = skewed(p36, cutscene_present_from, cutscene_present_to, cutscene_present_lead, cutscene_present_trail)
                local cutscene_gaze_from, cutscene_gaze_to = CONSTANTS.cutscene_gaze_from, CONSTANTS.cutscene_gaze_to
                local v65 = math.clamp((p36 - cutscene_gaze_from) / (cutscene_gaze_to - cutscene_gaze_from), 0, 1)
                local v66 = v65 ^ 3 * (v65 * (v65 * 6 - 15) + 10)
                local v67 = -v53 * CONSTANTS.cutscene_present_lean
                local v68 = (p36 - cutscene_present_from) / (cutscene_present_to - cutscene_present_from)
                local v69 = cutscene_present_lead + 1
                local v70

                if v68 <= 0 or v68 >= 1 then
                    v70 = 0
                else
                    local v71 = v69 / (v69 + cutscene_present_trail)

                    v70 = (v68 / v71) ^ v69 * ((1 - v68) / (1 - v71)) ^ cutscene_present_trail
                end

                local v72 = v67 * v70
                local v73 = arrived(p36, CONSTANTS.cutscene_return_from, cutscene_return_speed_up)
                local v74 = v51.start + (v51.landed - v51.start) * v62 + (v51.presented - v51.landed) * v63
                local v75 = v51.feet + (v51.overhead - v51.feet) * v63 + (v51.gazed - v51.overhead) * v66
                local v76 = arrived(p36, CONSTANTS.cutscene_return_glide_from, CONSTANTS.cutscene_return_glide_speed_up)
                local cutscene_return_swing_from, cutscene_return_swing_to = CONSTANTS.cutscene_return_swing_from, CONSTANTS.cutscene_return_swing_to
                local v78 = math.clamp((p36 - cutscene_return_swing_from) / (cutscene_return_swing_to - cutscene_return_swing_from), 0, 1)
                local v79 = v78 ^ 3 * (v78 * (v78 * 6 - 15) + 10) - arrived(p36, CONSTANTS.cutscene_return_unswing_from, cutscene_return_speed_up)
                local cutscene_return_from, cutscene_return_cruise_by = CONSTANTS.cutscene_return_from, CONSTANTS.cutscene_return_cruise_by
                local v81 = math.clamp((p36 - cutscene_return_from) / (cutscene_return_cruise_by - cutscene_return_from), 0, 1)
                local v82 = v81 ^ 3 * (v81 * (v81 * 6 - 15) + 10)
                local v83 = arrived(p36, CONSTANTS.cutscene_return_settle_from, cutscene_return_speed_up)
                local v84 = (v60 - v51.presented.Y) * v82 + (Position.Y - v60) * v83
                local v85 = (CFrame.lookAt(v74, v75).Rotation * CFrame.Angles(0, 0, v72)):Lerp(v54.Rotation, v73)
                local v86 = CONSTANTS.cutscene_land_zoom_fov + (CONSTANTS.cutscene_land_fov - CONSTANTS.cutscene_land_zoom_fov) * v62 + (CONSTANTS.cutscene_present_fov - CONSTANTS.cutscene_land_fov) * v63 + (p35 - CONSTANTS.cutscene_present_fov) * v73

                return CFrame.new(v74 + v59 * v76 + v58 * v79 + Vector3.new(0, 1, 0) * v84) * v85, v86
            end

            if is_clear(v61, p34.blockers) then
                return v61
            end

            v56 = v56 or v61
            v52 = v56
        end
    end

    return v52 or error("Spotlight's cutscene tried no way back to the player")
end

local function get_flinch(p37, p38) -- line: 236
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local cutscene_jolt_attack, cutscene_jolt_recovery = CONSTANTS.cutscene_jolt_attack, CONSTANTS.cutscene_jolt_recovery
    local v87 = v2.get_ringmaster_trick_start() + CONSTANTS.cutscene_react_delay
    local v88 = (p37 - CONSTANTS.cutscene_landing) / CONSTANTS.cutscene_flinch_duration
    local v89

    if v88 <= 0 or v88 >= 1 then
        v89 = 0
    else
        local v90 = cutscene_jolt_attack / (cutscene_jolt_attack + cutscene_jolt_recovery)

        v89 = (v88 / v90) ^ cutscene_jolt_attack * ((1 - v88) / (1 - v90)) ^ cutscene_jolt_recovery
    end

    local v91 = (p37 - v87) / CONSTANTS.cutscene_clunk_duration
    local v92

    if v91 <= 0 or v91 >= 1 then
        v92 = 0
    else
        local v93 = cutscene_jolt_attack / (cutscene_jolt_attack + cutscene_jolt_recovery)

        v92 = (v91 / v93) ^ cutscene_jolt_attack * ((1 - v91) / (1 - v93)) ^ cutscene_jolt_recovery
    end

    return -p38.LookVector * (CONSTANTS.cutscene_flinch_back * v89 + CONSTANTS.cutscene_clunk_back * v92) - Vector3.new(0, 1, 0) * CONSTANTS.cutscene_flinch_drop * v89, CONSTANTS.cutscene_clunk_fov * v92
end

local function get_bank(p39, p40, p41) -- line: 251
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local cutscene_bank_window = CONSTANTS.cutscene_bank_window
    local v94 = p39(p40 - cutscene_bank_window)
    local v95 = p39(p40 + cutscene_bank_window)
    local v96 = (v94.Position - p41.Position * 2 + v95.Position) / cutscene_bank_window ^ 2
    local cutscene_return_settle_from, cutscene_duration = CONSTANTS.cutscene_return_settle_from, CONSTANTS.cutscene_duration
    local v98 = math.clamp((p40 - cutscene_return_settle_from) / (cutscene_duration - cutscene_return_settle_from), 0, 1)
    local v99 = 1 - v98 ^ 3 * (v98 * (v98 * 6 - 15) + 10)

    return -CONSTANTS.cutscene_bank_max * math.tanh(v96:Dot(p41.RightVector) / CONSTANTS.cutscene_bank_pull) * v99
end

local function get_shake(p42) -- line: 263
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local v102 = p42 - CONSTANTS.cutscene_landing
    local v103 = v102 / CONSTANTS.cutscene_shake_duration
    local v104 = if v103 <= 0 or v103 >= 1 then 0 else (v103 / 0.25) ^ 2 * ((1 - v103) / 0.75) ^ 6

    if v104 <= 0 then
        return CFrame.identity
    end

    local v105 = 6.283185307179586 * CONSTANTS.cutscene_shake_rate * v102

    return CFrame.Angles(math.sin(v105) * CONSTANTS.cutscene_shake_tilt * v104, 0, math.sin(v105 * 0.7) * CONSTANTS.cutscene_shake_roll * v104)
end

local function get_drift(p43, p44) -- line: 281
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local cutscene_return_from, cutscene_duration = CONSTANTS.cutscene_return_from, CONSTANTS.cutscene_duration
    local v109 = math.clamp((p44 - cutscene_return_from) / (cutscene_duration - cutscene_return_from), 0, 1)
    local v110 = 1 - v109 ^ 3 * (v109 * (v109 * 6 - 15) + 10)

    if v110 <= 0 then
        return CFrame.identity
    end

    local cutscene_drift_rate = CONSTANTS.cutscene_drift_rate
    local v111 = CONSTANTS.cutscene_drift_sway * v110
    local v112 = CONSTANTS.cutscene_drift_tilt * v110

    return CFrame.new(math.sin(p43 * cutscene_drift_rate) * v111, math.cos(p43 * cutscene_drift_rate * 1.7) * v111, 0) * CFrame.Angles(math.sin(p43 * cutscene_drift_rate * 0.9) * v112, math.cos(p43 * cutscene_drift_rate * 1.3) * v112, 0)
end

local function set_camera_scripted(p45) -- line: 297
    local CurrentCamera = workspace.CurrentCamera

    if p45 then
        CurrentCamera.CameraType = Enum.CameraType.Scriptable
    else
        CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

local function stop(p46) -- line: 301
    local cutscene = p46.cutscene

    if cutscene.phase == "playing" then
        workspace.CurrentCamera.FieldOfView = cutscene.fov
        cutscene.phase = "done"
        cutscene.path = nil
        p46.power.rack.on = true
        workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
    end
end

local function start(p47, p48) -- line: 317
    -- upvalues: v1 (copy), plan_path (copy)
    local cutscene = p47.cutscene
    local v120 = v1.get_local_root()

    if not v120 then
        return
    end

    cutscene.fov = workspace.CurrentCamera.FieldOfView
    cutscene.path = plan_path(v120, p48, cutscene.fov)
    cutscene.phase = "playing"
    p47.power.rack.on = false
    p47.power.rack.level = 0
    workspace.CurrentCamera.CameraType = Enum.CameraType.Scriptable
end

local function step(p49, p50) -- line: 335
    -- upvalues: v2 (copy), get_flinch (copy), get_bank (copy), get_shake (copy), get_drift (copy)
    local CONSTANTS = v2.CONSTANTS
    local cutscene = p49.cutscene

    if cutscene.phase == "playing" then
        local v121 = p50 - (p49.entered_at or error("Spotlight's cutscene played before its player entered"))

        if CONSTANTS.cutscene_duration <= v121 then
            local cutscene = p49.cutscene

            if cutscene.phase == "playing" then
                workspace.CurrentCamera.FieldOfView = cutscene.fov
                cutscene.phase = "done"
                cutscene.path = nil
                p49.power.rack.on = true
                workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
            end
        else
            local rack = p49.power.rack

            if CONSTANTS.cutscene_landing <= v121 and not rack.on then
                rack.on = true
                rack.level = 1
            end

            local v122 = cutscene.path or error("Spotlight's cutscene is playing without a path")
            local v123, v124 = v122(v121)
            local v125, v126 = get_flinch(v121, v123)
            local CurrentCamera = workspace.CurrentCamera

            CurrentCamera.CFrame = (v123 + v125) * CFrame.Angles(0, 0, (get_bank(v122, v121, v123))) * get_shake(v121) * get_drift(p50, v121)
            CurrentCamera.FieldOfView = v124 + v126
        end
    end
end

local function step_power(p51, p52) -- line: 366
    -- upvalues: v1 (copy)
    v1.charge(p51.power.rack, p52)
end

function t1.connect_cutscene(p53, p54, p55, p56, p57) -- line: 370
    -- upvalues: RunService (copy), v1 (copy), v2 (copy), start (copy), step (copy)
    local CONSTANTS = v2.CONSTANTS
    local cutscene = p53.cutscene
    local v127 = RaycastParams.new()

    v127.FilterType = Enum.RaycastFilterType.Include
    v127.FilterDescendantsInstances = p57

    local t4 = {
        direction = p54,
        centre = p55,
        copycat = p56,
        blockers = v127
    }

    p53.maid:GiveTask(function() -- line: 386
        -- upvalues: p53 (copy)
        local cutscene = p53.cutscene

        if cutscene.phase == "playing" then
            workspace.CurrentCamera.FieldOfView = cutscene.fov
            cutscene.phase = "done"
            cutscene.path = nil
            p53.power.rack.on = true
            workspace.CurrentCamera.CameraType = Enum.CameraType.Custom
        end
    end)
    p53.maid:GiveTask(RunService.PreRender:Connect(function(p58) -- line: 390
        -- upvalues: p53 (copy), CONSTANTS (copy), cutscene (copy), t4 (copy), v1 (copy), start (copy), step (copy)
        local elapsed = os.clock()
        local entered_at = p53.entered_at

        if cutscene.phase == "waiting" and entered_at then
            if elapsed - entered_at < CONSTANTS.cutscene_duration then
                start(p53, t4)
            else
                cutscene.phase = "done"
            end
        end

        step(p53, elapsed)
        v1.charge(p53.power.rack, p58)
    end))
end

return table.freeze(t1)
