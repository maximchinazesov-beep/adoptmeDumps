-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MinigameScalerServer = require(ReplicatedStorage.Fsys).load("MinigameScalerServer")
local v1 = require("../Game/Spotlight/SpotlightInterior")
local v2 = require("./SpotlightMinigameServer")
local v3 = require("../Game/Spotlight/SpotlightShared")

return MinigameScalerServer.new({
    max_players = v3.CONSTANTS.minigame_max_players,
    minigame_class = v2,
    minigame_options = {
        minimum_players = 1,
        event_id = v3.CONSTANTS.minigame_event_id,
        minigame_id = v3.CONSTANTS.minigame_id,
        minigame_length = math.ceil((v3.get_play_length())),
        intermission_length = math.ceil((v3.get_intermission_length())),
        schedule_order = v3.CONSTANTS.minigame_schedule_order,
        minigame_destination_id = v3.CONSTANTS.minigame_destination_id,
        join_zone_destination_id = v3.CONSTANTS.join_zone_destination_id,
        get_join_zone_model = v1.get_join_zone
    }
})
