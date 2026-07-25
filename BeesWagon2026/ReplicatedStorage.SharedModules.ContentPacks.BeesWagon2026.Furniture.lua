-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FurnitureUseHelperDB = require(ReplicatedStorage.ClientDB.Housing.FurnitureUseDB.FurnitureUseHelperDB)
local NPCHelper = require(ReplicatedStorage.ClientDB.Housing.FurnitureUseDB.Helpers.NPCHelper)
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local load = require(ReplicatedStorage.Fsys).load
local v1 = load("EntryHelper")
local v2 = NPCHelper.format_npc_dialogue({
	Intro = { "Hello, my subject!", 2.5, "It\'s pollinator season!", 2, "There\'s a hive full of worker bees waiting for fresh nectar and my command.", 5, "I want to see Adoption Island bloom with flowers!", 3.5 },
	["I want to adopt you!"] = { "Oh, honey, of course you do!", 3, "You\'re gonna need some Honey and a great deal of luck.", 4.5, "We\'ll find out if you\'re sweet enough soon!", 3.5 },
	["The Bee Pass?"] = {
		"My worker bees have put together the sweetest set of rewards.",
		4.5,
		"Earn items for the vases you fill with flowers. Pay attention to my orders!",
		5,
		"There are Violet and Sunflower Friends waiting in the blooms.",
		4.5,
		"And you can do it over and over again! Go on, join the buzz!",
		4.5,
		"A Sunflower Friend is waiting in the blooms.",
		3
	},
	["I don\'t know how to garden!"] = { "Anyone can help save the bees.", 3, "Joni will sell you any seeds you need.", 3.5, "Plant them around the island and water them daily to see them grow!", 5 }
})
local t = { "I don\'t know how to garden!", "I want to adopt you!", "The Bee Pass?" }
local Thanks = NPCHelper.format_npc_dialogue({
	Thanks = { "Wow! Thanks for all the hard work!", 2.5, "These bouquets will look beautiful in my hive!", 3.5 }
}).Thanks

return v1.furniture({
	BeesWagon2026JoniNPC = {
		name = "Joni",
		model_name = "BeesWagon2026JoniNPC",
		behavior = function() --[[ behavior | Line: 73 | Upvalues: NPCHelper (copy), load (copy) ]]
			local v1 = NPCHelper.NPC_SIMPLE("BeesWagon2026JoniNPC", {
				npc_db_override = {
					name = "Joni"
				}
			})

			function v1.client_use() --[[ Line: 80 | Upvalues: load (ref) ]]
				load("UIManager").apps.SeedShopApp:view()
			end

			return v1
		end
	},
	bees_wagon_2026_nectar_fountain = {
		name = "Nectar Fountain",
		model_name = "BeesWagon2026NectarFountain",
		image_id = 87630205473539,
		type = "Decor",
		subtype = "Statues",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_natural_television = {
		name = "Natural Television",
		model_name = "BeesWagon2026NaturalTelevision",
		image_id = 72620461047580,
		type = "Electronics",
		subtype = "TVs",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_potted_plant_pet_display = {
		name = "Potted Plant Pet Display",
		model_name = "BeesWagon2026PottedPlantPetDisplay",
		image_id = 75824064378193,
		type = "Decor",
		subtype = "Displays",
		off_sale = true,
		cost = 0,
		delivery_box = {},
		tags = { "DisplayStand", "Stand", "BeesWagon2026" },
		behavior = function() --[[ behavior | Line: 119 | Upvalues: FurnitureUseHelperDB (copy) ]]
			return FurnitureUseHelperDB.DISPLAY_STAND("pet")
		end
	},
	bees_wagon_2026_honeycomb_oven = {
		name = "Honeycomb Oven",
		model_name = "BeesWagon2026HoneycombOven",
		image_id = 90314011572454,
		type = "Appliances",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_honeycomb_sink = {
		name = "Honeycomb Sink",
		model_name = "BeesWagon2026HoneycombSink",
		image_id = 102527920005326,
		type = "Tables",
		subtype = "Sinks",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_honeycomb_fridge = {
		name = "Honeycomb Fridge",
		model_name = "BeesWagon2026HoneycombFridge",
		image_id = 126841261519658,
		type = "Appliances",
		subtype = "Fridges",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_sticky_honey_couch = {
		name = "Sticky Honey Couch",
		model_name = "BeesWagon2026StickyHoneyCouch",
		image_id = 98203838882552,
		type = "Sit",
		subtype = "Sofas",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_honey_drip_chandelier = {
		name = "Honey Drip Chandelier",
		model_name = "BeesWagon2026HoneyDripChandelier",
		image_id = 133762991815855,
		type = "Lights",
		subtype = "Chandeliers",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_bee_jive_jukebox = {
		name = "Bee-jive Jukebox",
		model_name = "BeesWagon2026BeeJiveJukebox",
		image_id = 76735730176934,
		type = "Electronics",
		subtype = "Jukeboxes",
		off_sale = true,
		cost = 0,
		behavior = function() --[[ behavior | Line: 178 | Upvalues: FurnitureUseHelperDB (copy) ]]
			return FurnitureUseHelperDB.RADIO
		end,
		delivery_box = {}
	},
	bees_wagon_2026_planted_terracotta_pots = {
		name = "Planted Terracotta Pots",
		model_name = "BeesWagon2026PlantedTerracottaPots",
		image_id = 92880958780135,
		type = "Plants",
		subtype = "Plants",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_queen_bee_throne = {
		name = "Queen Bee Throne",
		model_name = "BeesWagon2026QueenBeeThrone",
		image_id = 136597629619853,
		type = "Sit",
		subtype = "Thrones",
		off_sale = true,
		cost = 0,
		delivery_box = {}
	},
	bees_wagon_2026_hexagonal_window = {
		name = "Hexagonal Window",
		model_name = "BeesWagon2026HexagonalWindow",
		image_id = 74334410868670,
		type = "Decor",
		subtype = "Windows",
		cost = 57,
		permitted_houses = { "beehive_house" }
	},
	bees_wagon_2026_sweet_curtains = {
		name = "Sweet Curtains",
		model_name = "BeesWagon2026SweetCurtains",
		image_id = 102427626215047,
		type = "Decor",
		subtype = "Windows",
		cost = 80,
		permitted_houses = { "beehive_house" }
	},
	BeesWagon2026QueenBee = {
		name = "Queen Queen Bee",
		model_name = "queen_bee",
		behavior = function() --[[ behavior | Line: 233 | Upvalues: NPCHelper (copy), ReplicatedStorage (copy), load (copy), BeesWagonFlowerHelper (copy), Promise (copy), Thanks (copy), v2 (copy), t (copy) ]]
			local v1, v22 = NPCHelper.NPC({
				name = "Queen Queen Bee"
			}, {
				idle_anim = "BeeSit",
				talking_to_anim = "BeeSit",
				pet_kind = "queen_bee"
			})
			local v3 = false
			local v4 = v1.post_render or (function() --[[ Line: 244 ]] end)

			function v1.post_render(p1, p2, p3, p4, p5) --[[ Line: 245 | Upvalues: ReplicatedStorage (ref), v4 (copy), load (ref), BeesWagonFlowerHelper (ref), Promise (ref), v22 (copy), Thanks (ref) ]]
				local InventoryDB = require(ReplicatedStorage.ClientDB.Inventory.InventoryDB)

				v4(p1, p2, p3, p4, p5)

				local v1 = load("PetAccessoryEquipHelper")
				local v2 = load("DownloadClient")

				p5.accessory_download_promises = {}
				p5.accessory_cleanup_callbacks = {}

				local t = {
					flower_crown = {
						position = Vector3.new(0, 0.05261467, -0.046742905),
						rotation = Vector3.new(13.603838, -68.53965, 0),
						scale = Vector3.new(1.65, 1.65, 1.65)
					}
				}

				for v3, v42 in { "flower_crown" } do
					local v5 = InventoryDB.pet_accessories[v42]

					if not v5 then
						error("Accessory entry not found for kind: " .. v42)
					end

					local v6 = v2.promise_download_copy("PetAvatarResources", v5.model_handle):andThen(function(p1) --[[ Line: 268 | Upvalues: p2 (copy), load (ref), v1 (copy), v5 (copy), t (copy), v42 (copy), p5 (copy) ]]
						local NPC = p2.NPC

						if not NPC:GetAttribute("RigType") then
							load("new:PetRigs").Rigs.Proxy.transform(NPC)
						end

						local v12 = v1.equip_accessory({
							pet_model = NPC,
							accessory_base_asset = p1,
							accessory_item_entry = v5
						})
						local v2 = t[v42]

						if v2 then
							v1.adjust_accessory(NPC, v12.accessory, v2)
						end

						table.insert(p5.accessory_cleanup_callbacks, v12.unequip)
					end)

					table.insert(p5.accessory_download_promises, v6)
				end

				p5.maid:GiveTask(BeesWagonFlowerHelper.queen_bee_thanks_signal:Connect(function(p1) --[[ Line: 289 | Upvalues: Promise (ref), v22 (ref), p5 (copy), Thanks (ref) ]]
					Promise.try(function() --[[ Line: 290 | Upvalues: v22 (ref), p5 (ref), Thanks (ref) ]]
						v22.play_dialog_async(p5.npc, Thanks)
					end):catch(warn):finally(p1)
				end))
			end

			local v5 = v1.unrender or (function() --[[ Line: 296 ]] end)

			function v1.unrender(p1, p2, p3, p4) --[[ Line: 297 | Upvalues: v5 (copy) ]]
				v5(p1, p2, p3, p4)

				for v1, v2 in p4.accessory_download_promises do
					v2:cancel()
				end

				for v3, v4 in p4.accessory_cleanup_callbacks do
					v4()
				end

				p4.accessory_cleanup_callbacks = nil
			end
			function v1.client_use(p1, p2, p3, p4, p5, p6, p7) --[[ client_use | Line: 311 | Upvalues: v22 (copy), v2 (ref) ]]
				v22.play_focused_dialog(v2[p7])
			end
			function v1.get_override_choices(p1) --[[ get_override_choices | Line: 315 | Upvalues: t (ref), v3 (ref), v22 (copy), v2 (ref) ]]
				local t2 = {}

				for v1, v23 in t do
					table.insert(t2, {
						text = v23,
						on_selected = function() --[[ on_selected | Line: 320 | Upvalues: p1 (copy), v23 (copy) ]]
							return p1(v23)
						end
					})
				end

				if v3 then
					return t2
				end

				return {
					{
						text = "Talk",
						on_selected = function() --[[ on_selected | Line: 330 | Upvalues: v3 (ref), v22 (ref), v2 (ref), t2 (copy) ]]
							v3 = true
							v22.play_focused_dialog(v2.Intro)

							return t2
						end
					}
				}
			end

			return v1
		end
	}
})