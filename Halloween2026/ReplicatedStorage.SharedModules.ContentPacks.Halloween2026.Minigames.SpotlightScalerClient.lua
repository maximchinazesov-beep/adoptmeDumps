-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MinigameScalerClient = require(ReplicatedStorage.Fsys).load("MinigameScalerClient")
local v1 = require("../Game/Spotlight/SpotlightInterior")
local v2 = require("./SpotlightMinigameClient")
local v3 = require("../Game/Spotlight/SpotlightShared")

return MinigameScalerClient.new({
    minigame_class = v2,
    minigame_options = {
        minigame_name = "Stitches' Spotlight",
        minigame_id = v3.CONSTANTS.minigame_id,
        ingame_music_id = v3.CONSTANTS.minigame_music_id,
        minigame_destination_id = v3.CONSTANTS.minigame_destination_id,
        join_zone_destination_id = v3.CONSTANTS.join_zone_destination_id,
        get_join_zone_model = v1.get_join_zone,
        minigame_restriction_overrides = {
            app_visibility = {
                type = "include",
                include_essential = true,
                app_names = { "MinigameHotbarApp", "MinigameInGameApp", "MinigameRewardsApp" }
            }
        }
    }
})
