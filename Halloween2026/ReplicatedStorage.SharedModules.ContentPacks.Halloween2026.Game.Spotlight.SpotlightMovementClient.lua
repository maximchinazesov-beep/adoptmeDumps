-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MinigameForcedState = require(ReplicatedStorage.Fsys).load("MinigameForcedState")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function get_walk_speed(p1) -- line: 11
    -- upvalues: v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local v3 = CONSTANTS.movement_base_walk_speed + (v1.LOCAL_PLAYER:GetAttribute(CONSTANTS.movement_speed_bonus_attribute) or 0)

    if p1.dash.phase == "boost" then
        v3 += CONSTANTS.dash_speed_bonus
    end

    return v3
end

function t1.apply(p2) -- line: 24
    -- upvalues: MinigameForcedState (copy), v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS

    if not p2.has_started then
        MinigameForcedState.set_buff(CONSTANTS.movement_buff_key, {
            walk_speed = 0,
            jump_power = 0
        })

        return
    end

    local set_buff = MinigameForcedState.set_buff
    local movement_buff_key = CONSTANTS.movement_buff_key
    local t2 = {}
    local CONSTANTS2 = v2.CONSTANTS
    local v4 = CONSTANTS2.movement_base_walk_speed + (v1.LOCAL_PLAYER:GetAttribute(CONSTANTS2.movement_speed_bonus_attribute) or 0)

    if p2.dash.phase == "boost" then
        v4 += CONSTANTS2.dash_speed_bonus
    end

    t2.walk_speed = v4
    t2.jump_power = CONSTANTS.movement_base_jump_power
    set_buff(movement_buff_key, t2)
end

function t1.connect_movement(p3) -- line: 38
    -- upvalues: MinigameForcedState (copy), v1 (copy), v2 (copy), t1 (copy)
    local CONSTANTS = v2.CONSTANTS

    local function changed() -- line: 41
        -- upvalues: p3 (copy), t1 (copy)
        t1.apply(p3)
    end

    p3.maid:GiveTask(v1.LOCAL_PLAYER:GetAttributeChangedSignal(CONSTANTS.movement_speed_bonus_attribute):Connect(changed))
    p3.maid:GiveTask(function() -- line: 50
        -- upvalues: CONSTANTS (copy), MinigameForcedState (copy)
        MinigameForcedState.remove_buff(CONSTANTS.movement_buff_key)
    end)
    t1.apply(p3)
    v1.when_started(p3, changed)
end

return table.freeze(t1)
