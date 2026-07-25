-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local InteractionsEngine = require(ReplicatedStorage.ClientModules.Core.InteractionsEngine.InteractionsEngine)
local InteriorHelper = require(ReplicatedStorage.ClientModules.Game.InteriorHelpers.InteriorHelper)
local v1 = load("UIManager")
local PlantingSpot = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.PlantingSpot)
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local PottedBouquet = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.PottedBouquet)
local BouquetProximityTracker = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.BouquetProximityTracker)
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local v2 = load("new:CutsceneHelper")
local v3 = TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)

local function poof_out_bouquets_in_sequence(p1) --[[ poof_out_bouquets_in_sequence | Line: 20 | Upvalues: Promise (copy), BeesWagonFlowerHelper (copy), SoundPlayer (copy) ]]
	local v1 = Promise.resolve()

	for v2, v3 in BeesWagonFlowerHelper.BOUQUET_POOF_OUT_SEQUENCE do
		v1 = v1:andThen(function() --[[ Line: 23 | Upvalues: SoundPlayer (ref), v3 (copy), p1 (copy), Promise (ref), BeesWagonFlowerHelper (ref) ]]
			SoundPlayer.FX:play("PrizeDisappear")

			for v1, v2 in v3 do
				local v32 = p1[v2]

				if v32 then
					v32:poof_out()
				end
			end

			return Promise.delay(BeesWagonFlowerHelper.BOUQUET_POOF_SEQUENCE_STEP_SECONDS)
		end)
	end

	return v1
end

local function play_queen_bee_thanks() --[[ play_queen_bee_thanks | Line: 35 | Upvalues: Promise (copy), BeesWagonFlowerHelper (copy) ]]
	return Promise.new(function(p1) --[[ Line: 36 | Upvalues: BeesWagonFlowerHelper (ref) ]]
		BeesWagonFlowerHelper.queen_bee_thanks_signal:Fire(p1)
	end):timeout(BeesWagonFlowerHelper.QUEEN_BEE_THANKS_TIMEOUT_SECONDS):catch(function() --[[ Line: 38 ]] end)
end

local function run_bouquet_complete_sequence(p1, p2) --[[ run_bouquet_complete_sequence | Line: 44 | Upvalues: v2 (copy), TweenPromise (copy), v3 (copy), play_queen_bee_thanks (copy), poof_out_bouquets_in_sequence (copy), Promise (copy), BeesWagonFlowerHelper (copy), ClientData (copy), Players (copy) ]]
	local CurrentCamera = workspace.CurrentCamera
	local v1 = CurrentCamera.CFrame
	local v22 = v2.enter({
		disable_controls = true
	})

	return TweenPromise.new(CurrentCamera, v3, {
		CFrame = p1.FinishCameraPivot.CFrame
	}):andThen(play_queen_bee_thanks):andThen(function() --[[ Line: 51 | Upvalues: poof_out_bouquets_in_sequence (ref), p2 (copy) ]]
		return poof_out_bouquets_in_sequence(p2)
	end):andThen(function() --[[ Line: 53 | Upvalues: Promise (ref), BeesWagonFlowerHelper (ref) ]]
		return Promise.delay(BeesWagonFlowerHelper.BOUQUET_POOF_HIDDEN_SECONDS)
	end):andThen(function() --[[ Line: 55 | Upvalues: ClientData (ref), Players (ref), BeesWagonFlowerHelper (ref), p2 (copy), TweenPromise (ref), CurrentCamera (copy), v3 (ref), v1 (copy) ]]
		local v12 = ClientData.get_server(Players.LocalPlayer, BeesWagonFlowerHelper.REPLICATION_KEY)
		local v2 = if v12 then v12.placed_flowers or {} else {}

		for v32, v4 in p2 do
			v4:poof_in()
			v4:set_state(v2[v32])
		end

		return TweenPromise.new(CurrentCamera, v3, {
			CFrame = v1
		})
	end):catch(warn):finally(function() --[[ Line: 65 | Upvalues: v22 (copy) ]]
		v22()
	end)
end

return {
	MainMap = {
		render = function(p1, p2) --[[ render | Line: 72 | Upvalues: Maid (copy), PlantingSpot (copy), PottedBouquet (copy), BouquetProximityTracker (copy), BeesWagonFlowerHelper (copy), run_bouquet_complete_sequence (copy), InteractionsEngine (copy), v1 (copy), InteriorHelper (copy), Players (copy), ClientData (copy) ]]
			local v12 = Maid.new()

			p2.bees_wagon_2026_maid = v12

			local Wagon = p1.Event.Wagon
			local t = {}

			for v2, v3 in Wagon.PlantingSpotRoots:GetChildren() do
				local v4 = PlantingSpot.new(v3)

				t[v4.spot_index] = v4
				v12:GiveTask(v4)
			end

			local t2 = {}

			for v5, v6 in Wagon.Bouquets:GetChildren() do
				if tonumber(v6.Name) then
					local v8 = v6.Name
					local v9 = v6:GetPivot()
					local v10 = v6.Parent

					v6.Parent = nil
					v12:GiveTask(function() --[[ Line: 95 | Upvalues: v6 (copy), v10 (copy) ]]
						v6.Parent = v10
					end)

					local v11 = PottedBouquet.new(v9, v8)

					t2[v8] = v11
					v12:GiveTask(v11)
				end
			end

			v12:GiveTask(BouquetProximityTracker.new(t2))

			local v122 = nil
			local v13 = false

			local function apply_flower_manager_state(p1, p2) --[[ apply_flower_manager_state | Line: 109 | Upvalues: t (copy), v122 (ref), BeesWagonFlowerHelper (ref), v13 (ref), t2 (copy), run_bouquet_complete_sequence (ref), Wagon (copy), v12 (copy) ]]
				local v1 = p1 and p1.planted_seeds or {}

				for v2, v3 in t do
					v3:set_state(v1[v2])
				end

				local v4 = p1 and p1.placed_flowers or {}
				local v5 = p1 and p1.bouquets_handed_in or 0

				if (if v122 == nil or not (v122 < v5) then false elseif v5 % BeesWagonFlowerHelper.BOUQUET_COUNT == 0 then true else false) and not v13 then
					v13 = true

					for v7, v8 in t2 do
						v8:set_complete()
					end

					local v9 = run_bouquet_complete_sequence(Wagon, t2)

					v12:GiveTask(v9)
					v9:finally(function() --[[ Line: 132 | Upvalues: v13 (ref) ]]
						v13 = false
					end)
				elseif not v13 then
					for v10, v11 in t2 do
						v11:set_state(v4[v10], p2)
					end
				end

				v122 = v5
			end

			v12:GiveTask(InteractionsEngine:register({
				text = function() --[[ text | Line: 145 ]]
					return "See the Bee Pass"
				end,
				part = Wagon.PassInteract.InteractionPart,
				on_selected = function() --[[ on_selected | Line: 149 | Upvalues: v1 (ref) ]]
					v1.apps.BattlePassApp:view("bees_2026_pass")
				end
			}))
			v12:GiveTask(InteriorHelper.register_purchase_block_interaction(Wagon.BeeHousePurchase.InteractionPart, "houses:beehive_house", {
				after_success_callback = function() --[[ after_success_callback | Line: 158 | Upvalues: v1 (ref), Players (ref) ]]
					if v1.apps.DialogApp:dialog({
						text = "Would you like to navigate to your house?",
						left = "No",
						right = "Yes"
					}) ~= "Yes" then
						return
					end

					v1.apps.GuideArrowApp:navigate({
						destination_id = "housing",
						destination_house_owner = Players.LocalPlayer
					})
				end
			}))

			local v14 = ClientData.get_server(Players.LocalPlayer, BeesWagonFlowerHelper.REPLICATION_KEY)

			if v14 then
				apply_flower_manager_state(v14, true)
			end

			v12:GiveTask(ClientData.register_callback(BeesWagonFlowerHelper.REPLICATION_KEY, function(p1, p2) --[[ Line: 178 | Upvalues: Players (ref), apply_flower_manager_state (copy) ]]
				if p1 == Players.LocalPlayer then
					apply_flower_manager_state(p2)
				end
			end))
		end,
		cleanup = function(p1, p2) --[[ cleanup | Line: 184 ]]
			p2.bees_wagon_2026_maid:Destroy()
		end
	}
}