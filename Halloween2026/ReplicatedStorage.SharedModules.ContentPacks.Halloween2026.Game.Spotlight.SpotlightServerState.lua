-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Maid = require(ReplicatedStorage.Fsys).load("Maid")

require("./SpotlightRigs")

local v1 = require("./SpotlightShared")
local t1 = {
    new_round = function(p1, p2, p3) -- new_round | line: 143
        -- upvalues: Maid (copy), v1 (copy)
        local CONSTANTS = v1.CONSTANTS
        local v2 = RaycastParams.new()

        v2.FilterType = Enum.RaycastFilterType.Include

        local v3 = Random.new()
        local scene_directions, marker_patterns = CONSTANTS.scene_directions, CONSTANTS.marker_patterns
        local v4 = p3 - CONSTANTS.act_count * CONSTANTS.act_duration + CONSTANTS.act_throw_lead

        return {
            maid = Maid.new(),
            static_map = p1,
            started_at = p2,
            ends_at = p3,
            intro_duration = v1.get_ringmaster_intro_duration() + v1.get_ringmaster_encore_duration(v4 - p2),
            direction = scene_directions[v3:NextInteger(1, #scene_directions)],
            pattern = marker_patterns[v3:NextInteger(1, #marker_patterns)],
            random = v3,
            pads = {},
            candycorn = {
                respawn_head = 1,
                respawn_tail = 0,
                by_part = {},
                rate = {},
                respawns = {}
            },
            cannons = {
                cannons = {},
                drops = {},
                markers = {},
                spots = {}
            },
            markers = {
                set_index = nil,
                kind = nil,
                shown_at = 0,
                reacted = false,
                sets = {},
                crypt_keys = {}
            },
            crypt_key = {
                claimed = {}
            },
            obstacles = {
                buffers = {},
                slot_of = {},
                raycast_params = v2
            },
            spotlights = {},
            targets = {
                exposure = {},
                cooldown_until = {},
                invincible_until = {}
            },
            players = {},
            listeners = {},
            active_at = {}
        }
    end,
    clear_player = function(p4) -- clear_player | line: 200
        -- upvalues: v1 (copy)
        local CONSTANTS = v1.CONSTANTS

        for _, v5 in {
                CONSTANTS.candycorn_score_attribute,
                CONSTANTS.candycorn_radius_attribute,
                CONSTANTS.movement_speed_bonus_attribute,
                CONSTANTS.marker_claimed_attribute,
                CONSTANTS.crypt_key_claimed_attribute,
                CONSTANTS.crypt_key_at_attribute
            } do
            p4:SetAttribute(v5, nil)
        end

        local Character = p4.Character

        if Character then
            for _, v6 in {
                    CONSTANTS.spotlight_exposure_attribute,
                    CONSTANTS.spotlight_targeted_attribute,
                    CONSTANTS.spotlight_caught_attribute,
                    CONSTANTS.spotlight_caught_by_attribute,
                    CONSTANTS.spotlight_discovered_attribute,
                    CONSTANTS.spotlight_stolen_attribute
                } do
                Character:SetAttribute(v6, nil)
            end
        end
    end,
    get_characters = function(p5) -- get_characters | line: 235
        local t2 = {}

        for v7 in p5.players do
            local Character = v7.Character

            if Character and Character.PrimaryPart then
                table.insert(t2, Character)
            end
        end

        return t2
    end
}

return table.freeze(t1)
