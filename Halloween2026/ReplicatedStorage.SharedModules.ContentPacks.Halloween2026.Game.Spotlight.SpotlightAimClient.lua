-- https://lua.expert

require("./SpotlightClientState")

local v1 = require("./SpotlightShared")
local t1 = {}

local function build_orb(p1) -- line: 22
    local Part = Instance.new("Part")

    Part.Name = "AimOrb"
    Part.Shape = Enum.PartType.Ball
    Part.Material = Enum.Material.Neon
    Part.Anchored = true
    Part.CanCollide = false
    Part.CanQuery = false
    Part.CanTouch = false
    Part.CastShadow = false
    Part.Transparency = 1
    Part.Parent = p1

    return Part
end

local function set_visible(p2, p3) -- line: 38
    p2.visible = p3

    for _, v2 in p2.orbs do
        v2.Transparency = p3 and 0 or 1
    end

    if not p3 then
        p2.brightness = 0
        p2.light.Brightness = 0
    end
end

local function round(p4, p5) -- line: 52
    return math.max(math.round(p4 * p5), 1) / p5
end

local function set_size(p6, p7, p8) -- line: 56
    if p8 ~= p6.sizes[p7] then
        p6.sizes[p7] = p8
        p6.orbs[p7].Size = Vector3.new(1, 1, 1) * p8
    end
end

function t1.build(p9) -- line: 63
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local Folder = Instance.new("Folder")

    Folder.Name = "SpotlightAimGuide"
    Folder.Parent = p9.visuals
    p9.maid:GiveTask(Folder)

    local t2 = {}
    local t3 = {}
    local t4 = {}

    for i = 1, CONSTANTS.aim_dot_count do
        local Part = Instance.new("Part")

        Part.Name = "AimOrb"
        Part.Shape = Enum.PartType.Ball
        Part.Material = Enum.Material.Neon
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Transparency = 1
        Part.Parent = Folder
        t2[i] = Part
        t3[i] = -1
        t4[i] = -1
    end

    for i = CONSTANTS.aim_dot_count + 1, CONSTANTS.aim_dot_count + CONSTANTS.aim_ring_dot_count do
        local Part = Instance.new("Part")

        Part.Name = "AimOrb"
        Part.Shape = Enum.PartType.Ball
        Part.Material = Enum.Material.Neon
        Part.Anchored = true
        Part.CanCollide = false
        Part.CanQuery = false
        Part.CanTouch = false
        Part.CastShadow = false
        Part.Transparency = 1
        Part.Parent = Folder
        Part.Color = CONSTANTS.aim_end_color
        t2[i] = Part
        t3[i] = -1
    end

    local Attachment = Instance.new("Attachment")

    Attachment.Name = "SpotlightAimGlow"
    Attachment.Parent = workspace.Terrain
    p9.maid:GiveTask(Attachment)

    local PointLight = Instance.new("PointLight")

    PointLight.Color = CONSTANTS.aim_end_color
    PointLight.Range = CONSTANTS.aim_light_range
    PointLight.Brightness = 0
    PointLight.Parent = Attachment

    return {
        shown = 0,
        visible = false,
        brightness = 0,
        from = Vector3.new(0, 0, 0),
        to = Vector3.new(0, 0, 0),
        orbs = t2,
        dot_count = CONSTANTS.aim_dot_count,
        cframes = table.create(#t2),
        sizes = t3,
        tints = t4,
        glow = Attachment,
        light = PointLight,
        glow_at = Attachment.WorldPosition
    }
end

function t1.step(p10, p11, p12, p13, p14) -- line: 113
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS

    if p12 then
        p10.from = p11
        p10.to = p12
    end

    local v5 = v1.approach(p10.shown, if p12 then 1 else 0, p13 / CONSTANTS.aim_fade_duration)

    p10.shown = v5

    if v5 < CONSTANTS.aim_min_visible then
        if p10.visible then
            p10.visible = false

            for _, v6 in p10.orbs do
                v6.Transparency = 1
            end

            p10.brightness = 0
            p10.light.Brightness = 0
        end
    else
        if not p10.visible then
            p10.visible = true

            for _, v7 in p10.orbs do
                v7.Transparency = 0
            end
        end

        local aim_steps = CONSTANTS.aim_steps
        local orbs, cframes, tints, dot_count = p10.orbs, p10.cframes, p10.tints, p10.dot_count
        local from, to = p10.from, p10.to
        local ringmaster_club_arc_height = CONSTANTS.ringmaster_club_arc_height
        local v8 = p14 * CONSTANTS.aim_flow_rate % 1

        for i = 1, dot_count do
            local v9 = (i - 1 + v8) / dot_count
            local v11 = math.sin(v9 * 3.141592653589793)
            local v14 = CONSTANTS.aim_dot_size * (math.max(math.round((v11 * 0.7 + 0.3) * v5 * aim_steps), 1) / aim_steps)

            if v14 ~= p10.sizes[i] then
                p10.sizes[i] = v14
                p10.orbs[i].Size = Vector3.new(1, 1, 1) * v14
            end

            local v16 = math.round(v9 * aim_steps) / aim_steps

            if v16 ~= tints[i] then
                tints[i] = v16
                orbs[i].Color = CONSTANTS.aim_start_color:Lerp(CONSTANTS.aim_end_color, v16)
            end

            cframes[i] = CFrame.new(from:Lerp(to, v9) + Vector3.new(0, 1, 0) * ringmaster_club_arc_height * v11)
        end

        local v17 = (from - to) * Vector3.new(1, 0, 1)
        local v18 = if v17.Magnitude > 0.001 then v17.Unit else Vector3.new(0, 0, 1)
        local Unit = v18:Cross((Vector3.new(0, 1, 0))).Unit
        local v19 = p14 * 2 * 3.141592653589793 / CONSTANTS.aim_ring_spin_period
        local v21 = math.sin(p14 * 2 * 3.141592653589793 / CONSTANTS.aim_pulse_period) * 0.5 + 0.5
        local v22 = #orbs - dot_count
        local v25 = CONSTANTS.aim_ring_dot_size * (math.max(math.round((v21 * 0.4 + 0.8) * v5 * aim_steps), 1) / aim_steps)

        for i = 1, v22 do
            local v26 = dot_count + i
            local v27 = v19 + (i - 1) * 2 * 3.141592653589793 / v22
            local v28 = (Unit * math.cos(v27) + Vector3.new(0, 1, 0) * math.sin(v27)) * CONSTANTS.aim_ring_radius

            if v25 ~= p10.sizes[v26] then
                p10.sizes[v26] = v25
                p10.orbs[v26].Size = Vector3.new(1, 1, 1) * v25
            end

            cframes[v26] = CFrame.new(to + v28)
        end

        workspace:BulkMoveTo(orbs, cframes, Enum.BulkMoveMode.FireCFrameChanged)

        local v29 = to + v18

        if v29 ~= p10.glow_at then
            p10.glow_at = v29
            p10.glow.WorldPosition = v29
        end

        local v32 = CONSTANTS.aim_light_brightness * (math.max(math.round((v21 * 0.3 + 0.7) * v5 * aim_steps), 1) / aim_steps)

        if v32 ~= p10.brightness then
            p10.brightness = v32
            p10.light.Brightness = v32
        end
    end
end

return table.freeze(t1)
