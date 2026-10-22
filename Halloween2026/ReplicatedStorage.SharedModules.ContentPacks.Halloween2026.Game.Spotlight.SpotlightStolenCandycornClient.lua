-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local BulkMoveToBatch = require(ReplicatedStorage.Fsys).load("BulkMoveToBatch")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}
local v3 = Random.new()
local v4 = BulkMoveToBatch.new()

local function spawn_pieces(p1, p2, p3, p4, p5) -- line: 30
    -- upvalues: v1 (copy), v2 (copy), v3 (copy)
    local CONSTANTS = v2.CONSTANTS

    assert(p1.stolen.mouths[p4], (("Spotlight has no copycat %* to feed candy corn to"):format(p4)))

    local v7 = math.min(p5, CONSTANTS.steal_max_pieces)
    local v8 = v3:NextNumber(0, 6.283185307179586)

    for i = 1, v7 do
        local v9 = v1.build_visual(p2)

        v9:PivotTo(CFrame.new(p3))
        v9.Parent = p1.visuals

        local v10 = v8 + 6.283185307179586 * i / v7
        local v11 = v3:NextNumber(CONSTANTS.steal_burst_min_distance, CONSTANTS.steal_burst_max_distance)
        local v12 = v3:NextNumber(CONSTANTS.steal_burst_min_rise, CONSTANTS.steal_burst_max_rise)
        local steal_ride_jitter = CONSTANTS.steal_ride_jitter
        local v13 = 6.283185307179586 / CONSTANTS.steal_spin_period * v3:NextNumber(0.5, 1.5)

        table.insert(p1.stolen.pieces, {
            elapsed = 0,
            visual = v9,
            offsets = v1.get_part_offsets(v9),
            from = p3,
            burst = p3 + Vector3.new(math.cos(v10) * v11, v12, math.sin(v10) * v11),
            axis = v3:NextUnitVector(),
            spin_rate = if v3:NextInteger(0, 1) == 0 then v13 else -v13,
            duration = CONSTANTS.steal_ride_duration * v3:NextNumber(1 - steal_ride_jitter, 1 + steal_ride_jitter),
            mouth = p4,
            trail = v1.attach_trail(p1, CONSTANTS.vfx_steal_trail, p3)
        })
    end
end

local function watch_character(p6, p7, p8, p9, p10) -- line: 73
    -- upvalues: SoundService (copy), v1 (copy), v2 (copy), spawn_pieces (copy)
    local CONSTANTS = v2.CONSTANTS
    local v16 = p8 == v1.LOCAL_PLAYER
    local n1 = 0
    local v17
    local v18 = v1.load_track(p10, p9:FindFirstChildWhichIsA("Animator", true), CONSTANTS.steal_startled_animation)

    if v16 then
        p10:GiveTask(p9:GetAttributeChangedSignal(CONSTANTS.spotlight_exposure_attribute):Connect(function() -- line: 92
            -- upvalues: p9 (copy), CONSTANTS (copy), n1 (ref), v17 (ref), SoundService (copy), v1 (copy)
            local v19 = n1

            n1 = p9:GetAttribute(CONSTANTS.spotlight_exposure_attribute) or 0

            if v19 < n1 and not v17 then
                v17 = v1.play_layered_sound(CONSTANTS.sound_spotlight_fill, SoundService)

                return
            end

            if n1 < v19 and v17 then
                for _, v20 in v17 do
                    v20:Stop()
                end

                v17 = nil
            end
        end))
    end

    p10:GiveTask(p9:GetAttributeChangedSignal(CONSTANTS.spotlight_discovered_attribute):Connect(function() -- line: 107
        -- upvalues: p6 (copy), p9 (copy), CONSTANTS (copy), v17 (ref), v18 (copy), v16 (copy), SoundService (copy), v1 (copy)
        if p9:GetAttribute(CONSTANTS.spotlight_discovered_attribute) == nil then
            return
        end

        if v18 then
            v18:Stop()
            v18:Play()
        end

        if v16 then
            v17 = nil
            v1.play_layered_sound(CONSTANTS.sound_spotlight_hit, SoundService)

            if not p6.stolen.has_been_spotted then
                p6.stolen.has_been_spotted = true
                v1.show_hint(CONSTANTS.hint_first_spotted)
            end
        end
    end))
    p10:GiveTask(p9:GetAttributeChangedSignal(CONSTANTS.spotlight_caught_attribute):Connect(function() -- line: 128
        -- upvalues: p6 (copy), p7 (copy), p9 (copy), CONSTANTS (copy), spawn_pieces (copy)
        local Attribute = p9:GetAttribute(CONSTANTS.spotlight_stolen_attribute)

        if Attribute and p9:GetAttribute(CONSTANTS.spotlight_caught_attribute) ~= nil then
            local PrimaryPart = p9.PrimaryPart

            if PrimaryPart then
                local v21 = p9:GetAttribute(CONSTANTS.spotlight_caught_by_attribute) or error((("%* was caught without a copycat"):format((p9:GetFullName()))))

                spawn_pieces(p6, p7, PrimaryPart.Position, v21, Attribute)
            end
        end
    end))
end

local function step(p11, p12) -- line: 143
    -- upvalues: v1 (copy), v2 (copy), v4 (copy)
    local CONSTANTS = v2.CONSTANTS
    local stolen = p11.stolen
    local pieces, mouths = stolen.pieces, stolen.mouths

    for i = #pieces, 1, -1 do
        local v22 = pieces[i]
        local v23 = mouths[v22.mouth]

        v22.elapsed += p12

        local steal_burst_duration = CONSTANTS.steal_burst_duration
        local v24 = v1.get_alpha(steal_burst_duration, v22.elapsed, v22.duration)
        local v25 = if v22.elapsed < steal_burst_duration then v22.from:Lerp(v22.burst, v1.ease_out(v22.elapsed / steal_burst_duration)) else v22.burst:Lerp(v23.Position, v24 * v24)
        local trail = v22.trail

        if trail then
            v4:add_part(trail, CFrame.new(v25))
        end

        if v24 >= 1 then
            v1.play_vfx(p11, CONSTANTS.vfx_copycat_chomp, v23.Position)

            if trail then
                v1.release_trail(trail)
            end

            v22.visual:Destroy()
            table.remove(pieces, i)
        else
            local v26 = CFrame.new(v25) * CFrame.fromAxisAngle(v22.axis, v22.elapsed * v22.spin_rate)

            for v27, v28 in v22.offsets do
                v4:add_part(v27, v26 * v28)
            end
        end
    end

    v4:execute(Enum.BulkMoveMode.FireCFrameChanged)
end

function t1.connect_theft(p13, p14, p15) -- line: 185
    -- upvalues: RunService (copy), v1 (copy), v2 (copy), v4 (copy), watch_character (copy), step (copy)
    local CONSTANTS = v2.CONSTANTS
    local stolen = p13.stolen

    for v29, v30 in p14 do
        stolen.mouths[v29] = v30:FindFirstChild(CONSTANTS.copycat_mouth_name, true) or error((("%* has no %* to eat candy corn with"):format(v30:GetFullName(), CONSTANTS.copycat_mouth_name)))
    end

    v1.connect_characters(p13, function(p16, p17, p18) -- line: 194
        -- upvalues: p13 (copy), p15 (copy), watch_character (copy)
        watch_character(p13, p15, p16, p17, p18)
    end)
    p13.maid:GiveTask(function() -- line: 198
        -- upvalues: v4 (copy)
        v4:destroy()
    end)
    p13.maid:GiveTask(RunService.PreRender:Connect(function(p19) -- line: 202
        -- upvalues: p13 (copy), stolen (copy), step (copy)
        if #stolen.pieces > 0 then
            step(p13, p19)
        end
    end))
end

return table.freeze(t1)
