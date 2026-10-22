-- https://lua.expert

local Players = game:GetService("Players")
local v1 = require("./SpotlightCandycornServer")

require("./SpotlightServerState")

local v2 = require("./SpotlightShared")
local t1 = {}

local function get_seen_angle(p1, p2, p3, p4) -- line: 12
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local origin = p2.origin
    local v3 = (p3.PrimaryPart or error((("%* has no PrimaryPart"):format((p3:GetFullName()))))).Position - origin
    local v4 = p2.chasing == p3
    local v5, v6

    if v4 then
        v6 = p2.target
        v5 = p2.cone_angle
    else
        v6 = p2.shown
        v5 = p2.cone_angle * v2.get_narrow(p2.hunt)
    end

    local v9 = math.acos((math.clamp((v6 - origin).Unit:Dot(v3.Unit), -1, 1)))

    if (v4 or not (v5 < v9)) and not workspace:Raycast(origin, v3, p1.obstacles.raycast_params) then
        if v9 <= v5 then
            if v4 then
                p2.unseen_since = nil
            end

            return v9
        end

        local v10 = p2.unseen_since or p4

        p2.unseen_since = v10

        if p4 - v10 < CONSTANTS.spotlight_latch_grace then
            return v9
        end
    end

    return nil
end

local function publish_exposure(p5, p6) -- line: 53
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local spotlight_exposure_step = CONSTANTS.spotlight_exposure_step
    local v11

    if p6 >= 1 then
        v11 = 1
    elseif not (p6 <= 0) then
        v11 = math.clamp(math.round(p6 / spotlight_exposure_step) * spotlight_exposure_step, spotlight_exposure_step, 1 - spotlight_exposure_step)
    end

    if p5:GetAttribute(CONSTANTS.spotlight_exposure_attribute) ~= v11 then
        p5:SetAttribute(CONSTANTS.spotlight_exposure_attribute, v11)
    end
end

local function update_exposure(p7, p8, p9, p10, p11, p12) -- line: 66
    -- upvalues: v2 (copy), get_seen_angle (copy), publish_exposure (copy)
    local CONSTANTS = v2.CONSTANTS
    local targets = p7.targets
    local t2 = {}
    local t3 = {}

    for _, v15 in p8 do
        table.clear(v15.spotted)
    end

    for _, v16 in p9 do
        local v17

        if p10[v16] then
            local v18
            local n1 = 1e999

            for _, v19 in p8 do
                local v20 = get_seen_angle(p7, v19, v16, p11)

                if v20 then
                    v19.spotted[v16] = v20

                    if v20 < n1 then
                        n1 = v20
                        v18 = v19
                    end
                end

                v17 = v18
            end
        end

        local v21 = v17 ~= nil
        local v22 = targets.exposure[v16] or 0
        local v23 = if v21 then math.min(v22 + p12 / CONSTANTS.spotlight_expose_duration, 1) else math.max(v22 - p12 / CONSTANTS.spotlight_conceal_duration, 0)

        if v17 and v23 >= 1 then
            t3[v16] = v17.index
            v23 = 0
            targets.invincible_until[v16] = p11 + CONSTANTS.hit_invincibility_duration

            for _, v26 in p8 do
                v26.spotted[v16] = nil
            end
        end

        if v23 > 0 then
            t2[v16] = v23
        end

        if not t3[v16] then
            publish_exposure(v16, v23)
        end
    end

    targets.exposure = t2

    return t3
end

local function set_chasing(p13, p14) -- line: 131
    -- upvalues: v2 (copy)
    local spotlight_targeted_attribute = v2.CONSTANTS.spotlight_targeted_attribute
    local chasing = p13.chasing

    if chasing then
        chasing:SetAttribute(spotlight_targeted_attribute, nil)
    end

    p13.chasing = p14
    p13.unseen_since = nil

    if p14 then
        p14:SetAttribute(spotlight_targeted_attribute, p13.index)
    end
end

local function is_claimed(p15, p16) -- line: 147
    for _, v27 in p15 do
        if v27.chasing == p16 then
            return true
        end
    end

    return false
end

local function pick(p17, p18, p19, p20) -- line: 157
    local v28
    local n2 = 1e999

    for v29, v30 in p19 do
        local v31 = p17.cooldown_until[v29]

        if (v31 == nil or not (p20 < v31)) and v30 < n2 then
            local v32 = false

            for _, v33 in p18 do
                if v33.chasing == v29 then
                    v32 = true
                    break
                end
            end

            if not v32 then
                n2 = v30
                v28 = v29
            end
        end
    end

    return v28
end

local function update_chase(p21, p22, p23, p24) -- line: 177
    -- upvalues: v2 (copy), pick (copy)
    local CONSTANTS = v2.CONSTANTS
    local v34 = CONSTANTS.spotlight_opening_cooldown + (CONSTANTS.spotlight_closing_cooldown - CONSTANTS.spotlight_opening_cooldown) * p23

    for _, v35 in p22 do
        local chasing = v35.chasing

        if chasing and not v35.spotted[chasing] then
            p21.cooldown_until[chasing] = p24 + v34

            local spotlight_targeted_attribute = v2.CONSTANTS.spotlight_targeted_attribute
            local chasing2 = v35.chasing

            if chasing2 then
                chasing2:SetAttribute(spotlight_targeted_attribute, nil)
            end

            v35.chasing = nil
            v35.unseen_since = nil
        end
    end

    for _, v36 in p22 do
        if not v36.chasing then
            local v37 = pick(p21, p22, v36.spotted, p24)

            if v37 then
                local spotlight_targeted_attribute = v2.CONSTANTS.spotlight_targeted_attribute
                local chasing = v36.chasing

                if chasing then
                    chasing:SetAttribute(spotlight_targeted_attribute, nil)
                end

                v36.chasing = v37
                v36.unseen_since = nil
                v37:SetAttribute(spotlight_targeted_attribute, v36.index)
            end
        end
    end
end

function t1.forget_character(p25, p26) -- line: 208
    -- upvalues: v2 (copy)
    local targets = p25.targets

    targets.exposure[p26] = nil
    targets.cooldown_until[p26] = nil
    targets.invincible_until[p26] = nil

    for _, v38 in p25.spotlights do
        v38.spotted[p26] = nil

        if v38.chasing == p26 then
            local spotlight_targeted_attribute = v2.CONSTANTS.spotlight_targeted_attribute
            local chasing = v38.chasing

            if chasing then
                chasing:SetAttribute(spotlight_targeted_attribute, nil)
            end

            v38.chasing = nil
            v38.unseen_since = nil
        end
    end
end

function t1.get_carriers(p27, p28, p29) -- line: 224
    -- upvalues: Players (copy), v1 (copy), v2 (copy)
    local invincible_until = p27.targets.invincible_until
    local v39 = p27.ends_at - v2.get_play_length()
    local t4 = {}

    for _, v40 in p28 do
        local PlayerFromCharacter = Players:GetPlayerFromCharacter(v40)

        if PlayerFromCharacter then
            local v41 = (p27.active_at[PlayerFromCharacter] or v39) <= p29
            local v42 = p29 < (invincible_until[v40] or 0)

            if v41 and not v42 and v1.get_score(PlayerFromCharacter) > 0 then
                t4[v40] = true
            end
        end
    end

    return t4
end

function t1.get_seek(p30, p31, p32, p33, p34) -- line: 245
    -- upvalues: v2 (copy), pick (copy)
    local CONSTANTS = v2.CONSTANTS
    local t5 = {}

    for v43 in p33 do
        local PrimaryPart = v43.PrimaryPart
        local Magnitude = if PrimaryPart then ((PrimaryPart.Position - p32.target) * Vector3.new(1, 0, 1)).Magnitude else nil

        if Magnitude and Magnitude <= CONSTANTS.spotlight_seek_radius then
            t5[v43] = Magnitude
        end
    end

    local v44 = pick(p30.targets, p31, t5, p34)
    local v45 = v44 and v44.PrimaryPart

    if v45 then
        return v45.Position
    end

    return nil
end

function t1.update(p35, p36, p37, p38, p39, p40, p41) -- line: 270
    -- upvalues: update_exposure (copy), update_chase (copy)
    local v46 = update_exposure(p35, p36, p37, p38, p40, p41)

    update_chase(p35.targets, p36, p39, p40)

    return v46
end

return table.freeze(t1)
