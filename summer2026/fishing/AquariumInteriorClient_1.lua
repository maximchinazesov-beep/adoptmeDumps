-- https://lua.expert/
local AnimationManager = require(game.ReplicatedStorage.ClientDB.AnimationManager)
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingPurchasesDB = require(ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Fishing.DB.FishingPurchasesDB)
local FishingRodDB = require(ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Fishing.DB.FishingRodDB)
local FishingNetService = require(ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Fishing.FishingNetService)
local FishingRodSignClient = require(ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Fishing.FishingRodSignClient)
local ClientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local GameplayFX = require(ReplicatedStorage.SharedModules.GameplayFX)

require(script.Parent.FishingTypes)

local InteractionsEngine = require(game.ReplicatedStorage.ClientModules.Core.InteractionsEngine.InteractionsEngine)
local KindDB = require(game.ReplicatedStorage.ClientDB.Inventory.KindDB)
local Maid = require(game.ReplicatedStorage.SharedModules.Maid)
local Promise = require(game.ReplicatedStorage.SharedPackages.Promise)
local TweenPromise = require(game.ReplicatedStorage.SharedModules.TweenPromise)
local UIManager = require(game.ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
local t = {}
local Fishing = game.ReplicatedStorage.Resources.Fishing
local t2 = { "summer_2026_bronze_fishing_rod", "summer_2026_silver_fishing_rod", "summer_2026_gold_fishing_rod" }
local t3 = { "... I love fisheng.", "Hereee, fishe fisheeee...", "I here there\'s a big one in this lake.........", "STRONG FISHY........", "Did ye see it?!?! MONSTER!!!", "Aye\'ll get a gud pic for Cricket... they\'ll believ me!!!" }

local function get_next_rod_kind(p1) --[[ get_next_rod_kind | Line: 39 | Upvalues: t2 (copy) ]]
	for v1, v2 in t2 do
		if not p1[v2] then
			return v2
		end
	end

	return nil
end

local function update_rod_pedestal_visual(p1, p2, p3) --[[ update_rod_pedestal_visual | Line: 48 | Upvalues: Fishing (copy), GameplayFX (copy) ]]
	local Visual = p1:FindFirstChild("Visual")
	local RodVisual = p1:FindFirstChild("RodVisual", true)

	if not (Visual and (Visual:IsA("Model") and (RodVisual and RodVisual:IsA("BasePart")))) then
		return
	end

	if p3.rod_pedestal_display_kind == p2 then
		return
	end

	local v1 = if p3.rod_pedestal_display_kind == nil then false elseif p2 == nil then false else true

	p3.rod_pedestal_display_kind = p2

	for v2, v3 in Visual:GetChildren() do
		if v3:GetAttribute("FishingRodDisplay") then
			v3:Destroy()
		end
	end

	if not p2 then
		return
	end

	local v4 = Fishing.FishingShopRods:FindFirstChild(p2)

	if not v4 then
		return
	end

	if v1 then
		GameplayFX.emit_poof(RodVisual.Position, 15, 2.5)
	end

	local v5 = v4:Clone()

	v5:SetAttribute("FishingRodDisplay", true)

	for v6, v7 in v5:GetDescendants() do
		if v7:IsA("BasePart") then
			v7.Anchored = true
			v7.CanCollide = false
		end
	end

	v5.Parent = Visual
	v5:PivotTo(RodVisual.CFrame)
end

local function destroy_interaction(p1, p2) --[[ destroy_interaction | Line: 94 ]]
	if not p1[p2] then
		return
	end

	p1[p2]:destroy()
	p1[p2] = nil
end

local function update_rod_upgrade_pedestal(p1, p2, p3) --[[ update_rod_upgrade_pedestal | Line: 101 | Upvalues: t2 (copy), update_rod_pedestal_visual (copy), Fishing (copy), FishingRodDB (copy), KindDB (copy), InteractionsEngine (copy), FishingNetService (copy) ]]
	local bought_unique_items = p2.bought_unique_items
	local v1 = nil

	for v2, v3 in t2 do
		if not bought_unique_items[v3] then
			v1 = v3

			break
		end
	end

	update_rod_pedestal_visual(p1, v1, p3)

	if p3.rod_upgrade_interaction then
		p3.rod_upgrade_interaction:destroy()
		p3.rod_upgrade_interaction = nil
	end

	local SoldOutSign = p1:FindFirstChild("SoldOutSign")

	if SoldOutSign then
		SoldOutSign:Destroy()
	end

	if not v1 then
		local v4 = Fishing.SoldOutSign:Clone()

		v4:PivotTo(p1.InteractionPart.CFrame * CFrame.Angles(0, math.pi, 0) * CFrame.new(0, 0, -1.8))
		v4.Parent = p1

		return
	end

	local v5 = FishingRodDB[v1]
	local v6 = KindDB[v1]

	if not (v5 and v6) then
		return
	end

	if v1 == t2[1] then
		p3.rod_upgrade_interaction = InteractionsEngine:register({
			part = p1.InteractionPart,
			text = ("Claim FREE %*"):format(v6.name),
			on_selected = function() --[[ on_selected | Line: 129 | Upvalues: FishingNetService (ref), v1 (copy) ]]
				FishingNetService.purchase_item(v1, 1)
			end
		})

		return
	end

	if not ((v5.unlock_fish_count or 0) <= (p2.upgrade_fish_caught or 0)) then
		return
	end

	p3.rod_upgrade_interaction = InteractionsEngine:register({
		part = p1.InteractionPart,
		text = ("Claim %*"):format(v6.name),
		on_selected = function() --[[ on_selected | Line: 143 | Upvalues: FishingNetService (ref) ]]
			FishingNetService.upgrade_fishing_rod()
		end
	})
end

function t.render(p1, p2) --[[ render | Line: 150 | Upvalues: Maid (copy), FishingRodSignClient (copy), ClientData (copy), update_rod_upgrade_pedestal (copy), FishingRodDB (copy), KindDB (copy), Fishing (copy), FishingPurchasesDB (copy), InteractionsEngine (copy), UIManager (copy), AnimationManager (copy), TweenPromise (copy), Promise (copy), t3 (copy) ]]
	local v1 = p2.aquarium_maid or Maid.new()

	p2.aquarium_maid = v1
	v1:DoCleaning()
	FishingRodSignClient.mount(p1, v1)
	v1:GiveTask(ClientData.register_callback_plus_existing("fishing_manager", function(p12, p2) --[[ Line: 158 | Upvalues: p1 (copy), update_rod_upgrade_pedestal (ref), v1 (copy), FishingRodDB (ref), KindDB (ref), Fishing (ref), FishingPurchasesDB (ref), InteractionsEngine (ref), UIManager (ref) ]]
		if p12 ~= game.Players.LocalPlayer then
			return
		end

		local RodUpgradePedestal = p1.FishingShopItems:FindFirstChild("RodUpgradePedestal")

		if RodUpgradePedestal then
			update_rod_upgrade_pedestal(RodUpgradePedestal, p2, v1)
		end

		for v2, v3 in p1.FishingShopItems:GetChildren() do
			local v12
			local v4 = v3.Name

			if v4 ~= "RodUpgradePedestal" and not FishingRodDB[v4] then
				local v5 = KindDB[v4]
				local v6 = ("trade_%*_interaction"):format(v4)

				if p2.bought_unique_items[v4] and not v3:FindFirstChild("SoldOutSign") then
					local v7 = Fishing.SoldOutSign:Clone()

					v7:PivotTo(v3.InteractionPart.CFrame)
					v7.Parent = v3
					v3.Visual:Destroy()

					if v1[v6] then
						v1[v6]:destroy()
					end

					continue
				end

				if not v1[v6] then
					local v8 = FishingPurchasesDB.get(v4)
					local v9 = ("Trade: %*"):format(v5.name)

					v12 = if next(v8.cost) then v9 else ("Claim FREE %*"):format(v5.name)
					v1[v6] = InteractionsEngine:register({
						part = v3.InteractionPart,
						text = v12,
						on_selected = function() --[[ on_selected | Line: 193 | Upvalues: UIManager (ref), v4 (copy) ]]
							UIManager.apps.FishTradingApp:open(v4)
						end
					})
				end
			end
		end
	end))

	local v2 = Random.new()
	local t = {}

	for v3, v4 in p1.Jellyfish:GetChildren() do
		local Pet = v4.Pet
		local Top = v4.Top
		local Bottom = v4.Bottom
		local v6 = Pet.Humanoid.Animator:LoadAnimation((AnimationManager.get_track(KindDB.ugc_refresh_2024_jellyfish.anims.idle)))

		v6.TimePosition = v2:NextNumber() * v6.Length
		v6:Play()
		table.insert(t, TweenPromise.callback_heartbeat(0, 1, v2:NextNumber(), TweenInfo.new(8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, -1, true, 1), function(p1) --[[ Line: 214 | Upvalues: Pet (copy), Bottom (copy), Top (copy) ]]
			Pet:PivotTo(Bottom.CFrame:Lerp(Top.CFrame, p1))
		end))
	end

	v1.jellyfish_promises = Promise.all(t)

	local v10 = p1.Burt.Humanoid.Animator:LoadAnimation((AnimationManager.get_track("FishingAvatarCastIdle")))

	v10.Looped = true
	v10:Play()
	v1.burt_barks_promise = Promise.new(function(p12, p2, p3) --[[ Line: 227 | Upvalues: v2 (copy), t3 (ref), UIManager (ref), p1 (copy) ]]
		while not p3() do
			UIManager.apps.SpeechBubbleApp:create_for_character(p1.Burt, t3[v2:NextInteger(1, #t3)], {
				length = 4,
				max_distance = 180
			})
			task.wait(8)
		end
	end)
end
function t.cleanup(p1, p2) --[[ cleanup | Line: 239 ]]
	if not p2.aquarium_maid then
		return
	end

	p2.aquarium_maid:DoCleaning()
end

return t