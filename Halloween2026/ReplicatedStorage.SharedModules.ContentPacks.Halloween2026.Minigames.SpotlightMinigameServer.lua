-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local ContentPackAssetsServer = require(ServerScriptService.new.modules.ContentPacks.ContentPackAssetsServer)
local load = require(ReplicatedStorage.Fsys).load
local Class = load("Class")
local MinigameServer = load("MinigameServer")
local v1 = require("../Game/Spotlight/SpotlightCandycornServer")
local v2 = require("../Game/Spotlight/SpotlightInterior")
local v3 = require("../Game/Spotlight/SpotlightLeaderboardServer")
local v4 = require("../Game/Spotlight/SpotlightRound")
local v5 = require("../Game/Spotlight/SpotlightServerState")
local v6 = require("../Game/Spotlight/SpotlightShared")
local v7 = Class("SpotlightMinigameServer", MinigameServer)

function v7.init(p1) -- line: 18
    p1.round = nil
    p1.final_candycorn = {}
    p1.found_crypt_key = {}
end

function v7._record_final(p2, p3, p4) -- line: 24
    -- upvalues: v1 (copy)
    p2.final_candycorn[p4] = v1.get_score(p4)
    p2.found_crypt_key[p4] = p3.crypt_key.claimed[p4]
end

function v7.players_loaded(p5) -- line: 29
    -- upvalues: ContentPackAssetsServer (copy), v2 (copy), v4 (copy), v5 (copy), v6 (copy)
    local v8 = v2.get_static_map_name(p5.minigame_destination_id)
    local v9 = workspace.StaticMap:FindFirstChild(v8) or error((("Spotlight has no static map to run in; expected %*"):format(v8)))
    local v10 = v5.new_round(v9, os.clock(), v6.get_round_ends_at(p5.intermission_end_time))

    p5.round = v10
    v4.setup(v10, ContentPackAssetsServer.get_asset("Interiors", p5.minigame_destination_id) or error((("Spotlight has no interior asset for %*"):format(p5.minigame_destination_id))))

    local v11 = v4.get_spawn_points(v10)

    assert(#v11 > 0, (("%* has nowhere behind a board to start anybody"):format((v9:GetFullName()))))

    local t1 = {}

    for v14, v15 in p5.minigame_players:get_as_list() do
        v4.add_player(v10, v15)
        t1[tostring(v15.UserId)] = v11[(v14 - 1) % #v11 + 1]
    end

    return {
        spotlight_direction = v10.direction,
        spotlight_starts = t1,
        spotlight_intro_duration = v10.intro_duration
    }
end

function v7.game_started(p6) -- line: 63
    -- upvalues: v4 (copy)
    v4.start(p6.round or error("Spotlight started a round it never prepared"), function() -- line: 64
        -- upvalues: p6 (copy)
        p6:end_game_now()
    end)
end

function v7.game_ended(p7) -- line: 69
    -- upvalues: v3 (copy), v4 (copy)
    local round = p7.round

    if not round then
        return
    end

    local t2 = {}

    for v16 in round.players do
        p7:_record_final(round, v16)
        t2[v16] = p7.final_candycorn[v16]
    end

    v3.submit(t2)
    p7.round = nil
    v4.stop(round)
end

function v7.session_ready_msg(p8, p9) -- line: 86
    local round = p8.round

    if round and round.players[p9] then
        round.listeners[p9] = true
    end
end

function v7.intro_started_msg(p10, p11, p12) -- line: 95
    -- upvalues: v4 (copy)
    local round = p10.round

    if round and round.players[p11] and typeof(p12) == "number" and p12 == p12 then
        local ServerTimeNow = workspace:GetServerTimeNow()

        v4.start_intro(round, p11, os.clock() - math.max(ServerTimeNow - p12, 0))
    end
end

function v7.candycorn_collect_msg(p13, p14, p15) -- line: 105
    -- upvalues: v1 (copy)
    local round = p13.round

    if round and round.players[p14] and typeof(p15) == "Instance" and p15:IsA("BasePart") then
        v1.on_reported(round, p14, p15, os.clock())
    end
end

function v7.get_game_stats(p16, p17) -- line: 118
    -- upvalues: v6 (copy)
    local CONSTANTS = v6.CONSTANTS
    local v18 = p16.final_candycorn[p17] or 0
    local v20 = math.min(v18 * CONSTANTS.earned_candycorn_multiplier, CONSTANTS.earned_candycorn_max)

    return {
        results = {
            {
                title = "Candy Earned",
                value = v18
            }
        },
        spotlight_candycorn = v18,
        spotlight_currency = v20,
        spotlight_crypt_key = p16.found_crypt_key[p17] == true
    }
end

function v7.calculate_currency_reward(_, _, p20) -- line: 134
    return p20.spotlight_currency
end

function v7.calculate_other_rewards(_, _, p23) -- line: 138
    if p23.spotlight_crypt_key then
        return {
            {
                type = "item",
                category = "toys",
                kind = "halloween_2026_rusty_key"
            }
        }
    end

    return {}
end

function v7.on_player_left(p24, p25) -- line: 152
    -- upvalues: v4 (copy)
    local round = p24.round

    if round and round.players[p25] then
        p24:_record_final(round, p25)
        v4.remove_player(round, p25)
    end
end

return v7
