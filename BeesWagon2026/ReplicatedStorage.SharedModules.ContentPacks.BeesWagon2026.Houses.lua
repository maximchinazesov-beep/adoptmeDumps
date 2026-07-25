-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

return require(ReplicatedStorage.ClientDB.Inventory.EntryHelper).houses({
	beehive_house = {
		name = "Beehive House",
		model_name = "BeehiveHouse",
		image = "rbxassetid://101011840873508",
		order = 1,
		cost = 5450,
		is_for_sale = true,
		rarity = "house",
		default_color = Color3.fromRGB(255, 176, 0),
		recommended_furniture = {}
	}
})