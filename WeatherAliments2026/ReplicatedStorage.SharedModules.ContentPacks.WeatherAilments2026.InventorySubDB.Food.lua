-- https://lua.expert/
return require(game.ReplicatedStorage.ClientDB.Inventory.EntryHelper).food({
	super_age_potion = {
		name = "Super Age-Up Potion",
		image = "rbxassetid://117907854580741",
		rarity = "legendary",
		donatable = true,
		forced_journal_visibility = true,
		cannot_feed_to_doll = true,
		cannot_feed_to_egg = true,
		cannot_feed_to_self = true,
		custom_tooltip_description = "Grants 183 tasks of experience to a pet\'s age.",
		model_handle = "SuperAgePotion",
		tool = "GenericTool",
		uses = 1,
		anims = {
			hold = "PotionHold",
			use = "PotionDrink"
		}
	}
})