-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SoundService = game:GetService("SoundService")
local Trampoline = require(ReplicatedStorage.Fsys).load("Trampoline")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function connect_trampoline(p1, p2) -- line: 12
    -- upvalues: Trampoline (copy), v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS

    assert(p2:IsA("BasePart"), (("%* must be a trampoline memento part"):format((p2:GetFullName()))))
    p2.Transparency = 1

    local t2 = {
        upwards_velocity = CONSTANTS.trampoline_upwards_velocity,
        time_length = CONSTANTS.trampoline_launch_duration,
        upper_height_cutoff = CONSTANTS.trampoline_upper_height_cutoff,
        lower_height_cutoff = CONSTANTS.trampoline_lower_height_cutoff
    }

    for _, descendant in p2:GetDescendants() do
        if descendant:IsA("BasePart") and descendant.CanTouch then
            Trampoline.hook_up_trampoline(descendant, t2)
            p1.maid:GiveTask(descendant.Touched:Connect(function(p3) -- line: 32
                -- upvalues: descendant (copy), Trampoline (copy), v1 (copy)
                if v1.is_local_character_part(p3) then
                    Trampoline.jump(descendant, p3)
                end
            end))
        end
    end
end

function t1.connect_all_trampolines(p4, p5) -- line: 40
    -- upvalues: SoundService (copy), Trampoline (copy), v1 (copy), v2 (copy), connect_trampoline (copy)
    local CONSTANTS = v2.CONSTANTS

    for _, child in p5:GetChildren() do
        connect_trampoline(p4, child)
    end

    p4.maid:GiveTask(Trampoline.bounced:Connect(function(p6, p7) -- line: 47
        -- upvalues: p5 (copy), CONSTANTS (copy), SoundService (copy), v1 (copy)
        if p6:IsDescendantOf(p5) and v1.is_local_character_part(p7) then
            v1.play_layered_sound(CONSTANTS.sound_trampoline_bounce, SoundService)
        end
    end))
end

return table.freeze(t1)
