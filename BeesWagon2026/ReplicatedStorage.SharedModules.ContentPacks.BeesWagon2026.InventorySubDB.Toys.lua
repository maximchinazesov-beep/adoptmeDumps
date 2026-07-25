-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local EntryHelper = require(game.ReplicatedStorage.ClientDB.Inventory.EntryHelper)
local t = {}
local t2 = {
	rose = 25,
	iris = 35,
	daisy = 55,
	poppy = 65,
	bluebell = 45,
	fern = 75
}

for v1, v2 in BeesWagonFlowerHelper.FLOWER_ITEM_KINDS_MAP do
	t[v1] = {
		rarity = "common",
		donatable = false,
		event_name = "Bees",
		model_handle = "BeesWagon2026Flowers",
		tool = "BeesWagon2026FlowersTool",
		name = ("%* Flower"):format(BeesWagonFlowerHelper.FLOWER_NAMES_BY_KIND[v2]),
		image = BeesWagonFlowerHelper.FLOWER_ICONS[v2],
		countdown_end_timestamp = BeesWagonFlowerHelper.TAKEDOWN_TIMESTAMP,
		anims = {
			hold = "CandyCannonHold"
		}
	}
end

for v3, v4 in BeesWagonFlowerHelper.SEED_ITEM_KINDS_MAP do
	t[v3] = {
		rarity = "common",
		donatable = false,
		event_name = "Bees",
		model_handle = "BeesWagon2026Seeds",
		tool = "BeesWagon2026SeedsTool",
		name = ("%* Seeds"):format(BeesWagonFlowerHelper.FLOWER_NAMES_BY_KIND[v4]),
		image = BeesWagonFlowerHelper.SEED_ICONS[v4],
		cost = t2[v4],
		countdown_end_timestamp = BeesWagonFlowerHelper.TAKEDOWN_TIMESTAMP,
		anims = {
			hold = "CandyCannonHold"
		}
	}
end

return EntryHelper.toys(t)