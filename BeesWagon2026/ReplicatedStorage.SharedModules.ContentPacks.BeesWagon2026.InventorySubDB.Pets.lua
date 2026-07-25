-- https://lua.expert/
return require(game.ReplicatedStorage.ClientDB.Inventory.EntryHelper).pets({
	bees_wagon_2026_violet_friend = {
		name = "Violet Friend",
		model = "BeesWagon2026VioletFriend",
		image = "rbxassetid://119284351481681",
		rarity = "rare",
		generate_npc_furniture_on_runtime = true,
		origin_entry = {
			origin = "Queen\'s Bouquet",
			year = 2026,
			origin_items = {}
		},
		anims = {
			sleep = "BeesWagon2026VioletFriendSleep",
			running = "BeesWagon2026VioletFriendRun",
			idle = "BeesWagon2026VioletFriendIdle",
			eating = "BeesWagon2026VioletFriendEat",
			sit = "BeesWagon2026VioletFriendSit",
			flying = "BeesWagon2026VioletFriendRun",
			hold = "BeesWagon2026VioletFriendBeingHeldSingle",
			double_hold = "BeesWagon2026VioletFriendBeingHeldDouble"
		},
		tricks = {
			{ "Sit", "BeesWagon2026VioletFriendSit" },
			{ "Joyful", "BeesWagon2026VioletFriendJoyful" },
			{ "Beg", "BeesWagon2026VioletFriendBeg" },
			{ "Jump", "BeesWagon2026VioletFriendJump" },
			{ "Trick 1", "BeesWagon2026VioletFriendTrick1" },
			{ "Trick 2", "BeesWagon2026VioletFriendTrick2" }
		},
		neon_parts = {
			CollarPetals_Geo = Color3.fromRGB(151, 105, 204),
			Head_Geo = Color3.fromRGB(151, 105, 204),
			Blush_Geo = Color3.fromRGB(151, 105, 204),
			LeavesTrim_Geo = Color3.fromRGB(151, 105, 204)
		}
	},
	bees_wagon_2026_sunflower_friend = {
		name = "Sunflower Friend",
		model = "BeesWagon2026SunflowerFriend",
		image = "rbxassetid://116677376014234",
		rarity = "rare",
		already_has_flying_wings = true,
		generate_npc_furniture_on_runtime = true,
		origin_entry = {
			origin = "Queen\'s Bouquet",
			year = 2026,
			origin_items = {}
		},
		anims = {
			sleep = "BeesWagon2026SunflowerFriendSleep",
			running = "BeesWagon2026SunflowerFriendRun",
			idle = "BeesWagon2026SunflowerFriendIdle",
			eating = "BeesWagon2026SunflowerFriendEat",
			sit = "BeesWagon2026SunflowerFriendSit",
			flying = "BeesWagon2026SunflowerFriendFly",
			hold = "BeesWagon2026SunflowerFriendBeingHeldSingle",
			double_hold = "BeesWagon2026SunflowerFriendBeingHeldDouble"
		},
		tricks = {
			{ "Sit", "BeesWagon2026SunflowerFriendSit" },
			{ "Joyful", "BeesWagon2026SunflowerFriendJoyful" },
			{ "Beg", "BeesWagon2026SunflowerFriendBeg" },
			{ "Jump", "BeesWagon2026SunflowerFriendJump" },
			{ "Trick 1", "BeesWagon2026SunflowerFriendTrick1" },
			{ "Trick 2", "BeesWagon2026SunflowerFriendTrick2" }
		},
		neon_parts = {
			Torso2 = Color3.fromRGB(189, 145, 43),
			Torso = Color3.fromRGB(189, 145, 43)
		}
	}
})