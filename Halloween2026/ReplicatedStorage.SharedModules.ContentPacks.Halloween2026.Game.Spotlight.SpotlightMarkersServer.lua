-- https://lua.expert

local RunService = game:GetService("RunService")

require("./SpotlightServerState")

local v1 = require("./SpotlightShared")
local t1 = {}

local function is_standing_in(p1, p2) -- line: 10
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local PrimaryPart = p2.PrimaryPart

    if PrimaryPart then
        local v2 = PrimaryPart.Position - p1.Position

        if not (v2.Y > CONSTANTS.marker_claim_above or v2.Y < -CONSTANTS.marker_claim_below) then
            return (v2 * Vector3.new(1, 0, 1)).Magnitude <= CONSTANTS.marker_claim_radius
        end
    end

    return false
end

local function get_standing_in(p3, p4) -- line: 26
    -- upvalues: v1 (copy)
    for _, v3 in p3 do
        local CONSTANTS = v1.CONSTANTS
        local PrimaryPart = p4.PrimaryPart

        if PrimaryPart then
            local v4 = PrimaryPart.Position - v3.Position

            if not (v4.Y > CONSTANTS.marker_claim_above) and not (v4.Y < -CONSTANTS.marker_claim_below) and (v4 * Vector3.new(1, 0, 1)).Magnitude <= CONSTANTS.marker_claim_radius then
                return v3
            end
        end
    end

    return nil
end

local function get_nearest(p5, p6) -- line: 36
    local v5 = p6 and p6.PrimaryPart

    if not v5 then
        return nil
    end

    local v6
    local n1 = 1e999

    for _, v7 in p5 do
        local Magnitude = (v7.Position - v5.Position).Magnitude

        if Magnitude < n1 then
            n1 = Magnitude
            v6 = v7
        end
    end

    return v6
end

local function update(p7, p8, p9) -- line: 53
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local markers = p7.markers
    local kind, set_index = markers.kind, markers.set_index

    if not kind or not set_index or p9 < markers.shown_at + CONSTANTS.marker_fade_duration then
        return
    end

    local v8 = markers.sets[set_index]

    for v9 in p7.players do
        local Character = v9.Character
        local v10

        if v9:GetAttribute(CONSTANTS.marker_claimed_attribute) ~= markers.shown_at and Character then
            for _, v11 in v8 do
                local CONSTANTS = v1.CONSTANTS
                local PrimaryPart = Character.PrimaryPart

                if PrimaryPart then
                    local v12 = PrimaryPart.Position - v11.Position

                    if not (v12.Y > CONSTANTS.marker_claim_above) and not (v12.Y < -CONSTANTS.marker_claim_below) and (v12 * Vector3.new(1, 0, 1)).Magnitude <= CONSTANTS.marker_claim_radius then
                        v10 = v11
                        break
                    end
                end

                v10 = nil
            end
        end

        if v10 then
            v9:SetAttribute(CONSTANTS.marker_claimed_attribute, markers.shown_at)

            local v13 = not markers.reacted

            markers.reacted = true
            p8(v9, kind, v13, v10 == markers.crypt_keys[v9])
        end
    end
end

function t1.show(p10, p11, p12) -- line: 81
    -- upvalues: v1 (copy), get_nearest (copy)
    local CONSTANTS = v1.CONSTANTS
    local markers = p10.markers
    local v14 = p10.random:NextInteger(1, #markers.sets)

    while v14 == markers.set_index do
        v14 = p10.random:NextInteger(1, #markers.sets)
    end

    local ServerTimeNow = workspace:GetServerTimeNow()

    markers.set_index = v14
    markers.kind = p11
    markers.shown_at = ServerTimeNow
    markers.reacted = false

    local v15 = markers.sets[v14]

    for v16 in p10.players do
        if p12 and not p10.crypt_key.claimed[v16] then
            local v17 = get_nearest(v15, v16.Character) or v15[p10.random:NextInteger(1, #v15)]

            markers.crypt_keys[v16] = v17
            v16:SetAttribute(CONSTANTS.crypt_key_at_attribute, v17.Position)
        end
    end

    for _, v18 in v15 do
        v18:SetAttribute(CONSTANTS.marker_shown_attribute, ServerTimeNow)
        v18:SetAttribute(CONSTANTS.marker_kind_attribute, p11)
    end

    return v15
end

function t1.hide(p13) -- line: 123
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local markers = p13.markers
    local set_index = markers.set_index

    if not markers.kind or not set_index then
        return
    end

    markers.kind = nil

    for v19 in markers.crypt_keys do
        v19:SetAttribute(CONSTANTS.crypt_key_at_attribute, nil)
    end

    table.clear(markers.crypt_keys)

    for _, v20 in markers.sets[set_index] do
        v20:SetAttribute(CONSTANTS.marker_kind_attribute, nil)
        v20:SetAttribute(CONSTANTS.marker_shown_attribute, nil)
    end
end

function t1.connect_markers(p14, p15, p16) -- line: 145
    -- upvalues: RunService (copy), t1 (copy), update (copy)
    local t2 = {}

    for _, child in p15:GetChildren() do
        local t3 = {}

        for _, descendant in child:GetDescendants() do
            if descendant:IsA("BasePart") then
                table.insert(t3, descendant)
            end
        end

        if #t3 > 0 then
            table.insert(t2, t3)
        end
    end

    assert(#t2 > 1, (("%* needs at least two marker sets to move the markers between acts"):format((p15:GetFullName()))))
    p14.markers.sets = t2
    p14.maid:GiveTask(RunService.Heartbeat:Connect(function() -- line: 164
        -- upvalues: p14 (copy), p16 (copy), update (copy)
        update(p14, p16, workspace:GetServerTimeNow())
    end))
    p14.maid:GiveTask(function() -- line: 168
        -- upvalues: p14 (copy), t1 (copy)
        t1.hide(p14)
    end)
end

return table.freeze(t1)
