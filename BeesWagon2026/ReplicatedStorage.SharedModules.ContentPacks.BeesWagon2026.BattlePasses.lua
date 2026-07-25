-- https://lua.expert/
local v1 = require(game.ReplicatedStorage.Fsys).load("TimeZoneHelper")

return {
	bees_2026_pass = {
		display_name = "Bee Pass",
		event_has_ended = false,
		hint_text = "Arrange bouquets for Queen Bee to earn XP!",
		event_end_reset_prompt = "This %s is ending soon, so it can no longer be restarted.",
		icon_image = "rbxassetid://139915211772925",
		event_end_timestamp = v1.from_region_datetime("PT", 2026, 8, 7, 8).UnixTimestamp,
		sprout_images = {
			A = "rbxassetid://18742673645",
			B = "rbxassetid://18742677743"
		},
		reset_options = {
			reset_prompt = "Pay %d %s to restart the Bee Pass and keep earning rewards?",
			free_reset_message = "You\'ve restarted the Bee Pass! You can claim each reward again.",
			can_reset_until_timestamp = v1.from_region_datetime("PT", 2026, 8, 7, 0).UnixTimestamp
		},
		track = {
			{
				xp_needed = 50,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_nectar_fountain",
					amount = 1
				}
			},
			{
				xp_needed = 50,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_natural_television",
					amount = 1
				}
			},
			{
				xp_needed = 100,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_potted_plant_pet_display",
					amount = 1
				}
			},
			{
				xp_needed = 100,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_honeycomb_oven",
					amount = 1
				}
			},
			{
				xp_needed = 100,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_honeycomb_sink",
					amount = 1
				}
			},
			{
				xp_needed = 100,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_honeycomb_fridge",
					amount = 1
				}
			},
			{
				xp_needed = 100,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_sticky_honey_couch",
					amount = 1
				}
			},
			{
				xp_needed = 200,
				reward = {
					category = "pets",
					kind = "bees_wagon_2026_sunflower_friend",
					amount = 1
				}
			},
			{
				xp_needed = 200,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_honey_drip_chandelier",
					amount = 1
				}
			},
			{
				xp_needed = 200,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_bee_jive_jukebox",
					amount = 1
				}
			},
			{
				xp_needed = 200,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_planted_terracotta_pots",
					amount = 1
				}
			},
			{
				xp_needed = 200,
				reward = {
					category = "furniture",
					kind = "bees_wagon_2026_queen_bee_throne",
					amount = 1
				}
			},
			{
				xp_needed = 400,
				reward = {
					category = "pets",
					kind = "bees_wagon_2026_violet_friend",
					amount = 1
				}
			}
		}
	}
}