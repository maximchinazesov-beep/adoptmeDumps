-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local AnimationManager = require(ReplicatedStorage.ClientDB.AnimationManager)
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local ClientToolManager = require(ReplicatedStorage.ClientModules.Game.ClientToolManager)
local InteractionsEngine = require(ReplicatedStorage.ClientModules.Core.InteractionsEngine.InteractionsEngine)
local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local BeesWagonWagonNet = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonWagonNet)
local LiveOpsTime = require(ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local PlantingVisualSequence = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.PlantingVisualSequence)
local PlantingSpotTimer = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.PlantingSpotTimer)
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local v1 = if RunService:IsRunning() then ReplicatedStorage.Resources else ServerStorage.ContentPacks.BeesWagon2026.SharedResources
local PlantingArea = v1.PlantingArea
local Sprout = v1.Sprout
local v2 = Color3.fromRGB(90, 180, 255)
local t = {}

t.__index = t
function t.new(p1) --[[ new | Line: 32 | Upvalues: Maid (copy), t (copy), PlantingArea (copy), ReactRoblox (copy), AnimationManager (copy), RunService (copy) ]]
	local v2 = setmetatable({
		planted_seed = nil,
		has_received_state = false,
		growing_sprout = nil,
		sprout_budded = false,
		maid = Maid.new(),
		spot_index = p1.Name
	}, t)
	local v4 = PlantingArea:Clone()

	v4:PivotTo(p1.CFrame)
	v4.Parent = workspace
	v2.maid:GiveTask(v4)
	v2.planting_area = v4

	local PlayerFlower = v4.Flowers:FindFirstChild("PlayerFlower")

	v2.watering_cframe = PlayerFlower.WorldCFrame
	v2.player_flower_attachment = PlayerFlower

	local v5 = ReactRoblox.createRoot(Instance.new("Folder"))

	v2.timer_root = v5
	v2.maid:GiveTask(function() --[[ Line: 58 | Upvalues: v5 (copy) ]]
		v5:unmount()
	end)

	local Part = Instance.new("Part")

	Part.Size = Vector3.new(1, 1, 1)
	Part.Anchored = true
	Part.CanCollide = false
	Part.Transparency = 1
	Part.CFrame = v2.watering_cframe
	Part.Parent = workspace
	v2.maid:GiveTask(Part)
	v2.interaction_part = Part

	local Flyer = v4:FindFirstChild("Flyer")
	local v6 = if Flyer then Flyer:FindFirstChild("Bee") else Flyer
	local v7 = Flyer and Flyer.PrimaryPart

	v6.Humanoid.Animator:LoadAnimation((AnimationManager.get_track("BeeRunning"))):Play()
	v2.maid:GiveTask(RunService.Heartbeat:Connect(function(p1) --[[ Line: 81 | Upvalues: v7 (copy) ]]
		local v1 = v7

		v1.CFrame = v1.CFrame * CFrame.Angles(0, -0.3141592653589793 * p1, 0)
	end))
	v2:_refresh_interaction()

	return v2
end
function t.set_state(p1, p2) --[[ set_state | Line: 90 ]]
	local planted_seed = p1.planted_seed

	p1.planted_seed = p2

	local v1 = p1.has_received_state and (if planted_seed == nil then if p2 == nil then false else true else false)

	p1.has_received_state = true
	p1:_refresh_visuals()
	p1:_refresh_interaction()
	p1:_refresh_timer()

	if not v1 then
		return
	end

	p1:_play_planting_visual(p2.flower_kind)
end
function t._refresh_timer(p1) --[[ _refresh_timer | Line: 108 | Upvalues: React (copy), PlantingSpotTimer (copy), BeesWagonFlowerHelper (copy) ]]
	local planted_seed = p1.planted_seed

	if planted_seed == nil or planted_seed.watered_at == nil then
		p1.timer_root:render(nil)
	else
		p1.timer_root:render(React.createElement(PlantingSpotTimer, {
			attachment = p1.player_flower_attachment,
			ready_at = planted_seed.watered_at + BeesWagonFlowerHelper.get_growth_duration(planted_seed.flower_kind)
		}))
	end
end

local function get_equipped_seed() --[[ get_equipped_seed | Line: 124 | Upvalues: ClientToolManager (copy), BeesWagonFlowerHelper (copy) ]]
	for v1, v2 in ClientToolManager.get_equipped_by_category("toys") do
		if BeesWagonFlowerHelper.SEED_ITEM_KINDS_MAP[v2.kind] then
			return v2
		end
	end

	return nil
end

local function find_next_seed_of_kind(p1, p2) --[[ find_next_seed_of_kind | Line: 133 | Upvalues: ClientData (copy) ]]
	local v1 = ClientData.get("inventory")
	local v2 = if v1 then v1.toys else v1

	if not v2 then
		return nil
	end

	for v3, v4 in v2 do
		if v3 ~= p2 and v4.kind == p1 then
			return v4
		end
	end

	return nil
end

local function plant_and_equip_next(p1, p2) --[[ plant_and_equip_next | Line: 146 | Upvalues: BeesWagonWagonNet (copy), ClientData (copy), ClientToolManager (copy) ]]
	BeesWagonWagonNet.RequestPlantSeed:fire_server({
		spot_index = p1,
		seed_item_unique = p2.unique
	})

	local kind = p2.kind
	local unique = p2.unique
	local v1 = ClientData.get("inventory")
	local v2 = if v1 then v1.toys else v1
	local v3

	if v2 then
		for v4, v5 in v2 do
			if v4 ~= unique and v5.kind == kind then
				v3 = v5

				break
			end
		end
	end

	if not v3 then
		return
	end

	ClientToolManager.backpack_equip(v3, {
		suppress_fail_message = true
	})
end

function t._refresh_interaction(p1) --[[ _refresh_interaction | Line: 158 | Upvalues: InteractionsEngine (copy), ClientToolManager (copy), BeesWagonFlowerHelper (copy), plant_and_equip_next (copy), UIManager (copy), LiveOpsTime (copy), SoundPlayer (copy), BeesWagonWagonNet (copy) ]]
	p1.maid.interaction = nil

	local planted_seed = p1.planted_seed

	if planted_seed == nil then
		p1.maid.interaction = InteractionsEngine:register({
			text = function() --[[ text | Line: 165 ]]
				return "Plant Seed"
			end,
			part = p1.interaction_part,
			on_selected = function() --[[ on_selected | Line: 167 | Upvalues: ClientToolManager (ref), BeesWagonFlowerHelper (ref), plant_and_equip_next (ref), p1 (copy), UIManager (ref) ]]
				local v1 = nil

				for v2, v3 in ClientToolManager.get_equipped_by_category("toys") do
					if BeesWagonFlowerHelper.SEED_ITEM_KINDS_MAP[v3.kind] then
						v1 = v3

						break
					end
				end

				if v1 then
					plant_and_equip_next(p1.spot_index, v1)

					return
				end

				local v4 = UIManager.apps.BackpackApp:pick_item({
					no_results_text = "You have no flower seeds!",
					visible_backpack_categories = { "event" },
					allow_callback = function(p1) --[[ allow_callback | Line: 177 | Upvalues: BeesWagonFlowerHelper (ref) ]]
						return BeesWagonFlowerHelper.SEED_ITEM_KINDS_MAP[p1.kind] ~= nil
					end
				})

				if v4 then
					plant_and_equip_next(p1.spot_index, v4)
				end
			end
		})

		return
	end

	if not BeesWagonFlowerHelper.is_flower_ready(planted_seed, LiveOpsTime.now()) then
		return
	end

	local v1 = BeesWagonFlowerHelper.FLOWER_NAMES_BY_KIND[planted_seed.flower_kind]

	p1.maid.interaction = InteractionsEngine:register({
		text = function() --[[ text | Line: 191 | Upvalues: v1 (copy) ]]
			return ("Pick %*"):format(v1)
		end,
		part = p1.interaction_part,
		on_selected = function() --[[ on_selected | Line: 193 | Upvalues: SoundPlayer (ref), BeesWagonWagonNet (ref), p1 (copy) ]]
			SoundPlayer.FX:play("Harvest")
			BeesWagonWagonNet.RequestPickFlower:fire_server(p1.spot_index)
		end
	})
end
function t._refresh_visuals(p1) --[[ _refresh_visuals | Line: 203 | Upvalues: BeesWagonFlowerHelper (copy), LiveOpsTime (copy), Maid (copy) ]]
	p1.maid.growth_visual = nil
	p1.growing_sprout = nil

	local planted_seed = p1.planted_seed
	local v1 = if planted_seed == nil then false else BeesWagonFlowerHelper.is_flower_ready(planted_seed, LiveOpsTime.now())

	if planted_seed == nil or v1 then
		p1.maid.planting_visual = nil
	end

	if planted_seed == nil or planted_seed.watered_at == nil then
		return
	end

	local v2 = Maid.new()

	p1.maid.growth_visual = v2

	if v1 then
		p1:_render_grown_flower(v2, planted_seed.flower_kind)
	else
		p1:_render_growing_water_disc(v2, planted_seed.watered_at)
		p1:_render_growing_sprout(v2)
	end
end
function t._play_planting_visual(p1, p2) --[[ _play_planting_visual | Line: 229 | Upvalues: PlantingVisualSequence (copy) ]]
	p1.maid.planting_visual = nil
	p1.sprout_budded = true

	if p1.growing_sprout then
		p1.growing_sprout:ScaleTo(PlantingVisualSequence.SPROUT_BUD_SCALE)
	end

	local v1 = PlantingVisualSequence.new(p1.planting_area, p1.watering_cframe, p2, function() --[[ Line: 239 | Upvalues: p1 (copy) ]]
		return p1.growing_sprout
	end)

	p1.maid.planting_visual = v1
	v1:play():catch(warn):finally(function() --[[ Line: 246 | Upvalues: p1 (copy) ]]
		p1.sprout_budded = false

		if not p1.growing_sprout then
			return
		end

		p1.growing_sprout:ScaleTo(1)
	end)
end
function t._render_growing_sprout(p1, p2) --[[ _render_growing_sprout | Line: 256 | Upvalues: Sprout (copy), PlantingVisualSequence (copy) ]]
	local v1 = Sprout:Clone()

	v1:PivotTo(p1.watering_cframe)
	v1:ScaleTo(if p1.sprout_budded then PlantingVisualSequence.SPROUT_BUD_SCALE else 1)
	v1.Parent = workspace
	p2:GiveTask(v1)
	p1.growing_sprout = v1
end
function t._render_growing_water_disc(p1, p2, p3) --[[ _render_growing_water_disc | Line: 266 | Upvalues: v2 (copy), RunService (copy), LiveOpsTime (copy), BeesWagonFlowerHelper (copy) ]]
	local PlantingSpotWaterDisc = Instance.new("Part")

	PlantingSpotWaterDisc.Name = "PlantingSpotWaterDisc"
	PlantingSpotWaterDisc.Shape = Enum.PartType.Cylinder
	PlantingSpotWaterDisc.Anchored = true
	PlantingSpotWaterDisc.CanCollide = false
	PlantingSpotWaterDisc.CastShadow = false
	PlantingSpotWaterDisc.Color = v2
	PlantingSpotWaterDisc.Material = Enum.Material.Water
	PlantingSpotWaterDisc.Transparency = 0.25
	PlantingSpotWaterDisc.Size = Vector3.new(0.15, 0.01, 0.01)
	PlantingSpotWaterDisc.CFrame = p1.watering_cframe * CFrame.Angles(0, 0, 1.5707963267948966)
	PlantingSpotWaterDisc.Parent = workspace
	p2:GiveTask(PlantingSpotWaterDisc)
	p2:GiveTask(RunService.Heartbeat:Connect(function() --[[ Line: 282 | Upvalues: p1 (copy), p3 (copy), LiveOpsTime (ref), BeesWagonFlowerHelper (ref), PlantingSpotWaterDisc (copy) ]]
		local planted_seed = p1.planted_seed

		if not planted_seed or planted_seed.watered_at ~= p3 then
			return
		end

		local v2 = math.clamp((LiveOpsTime.now() - p3) / BeesWagonFlowerHelper.get_growth_duration(planted_seed.flower_kind), 0, 1)
		local v3 = math.max(0.01, v2 * 5)

		PlantingSpotWaterDisc.Size = Vector3.new(0.15, v3, v3)

		if not (v2 >= 1) then
			return
		end

		p1:_refresh_visuals()
		p1:_refresh_interaction()
		p1:_refresh_timer()
	end))
end
function t._render_grown_flower(p1, p2, p3) --[[ _render_grown_flower | Line: 301 | Upvalues: v1 (copy) ]]
	local v12 = v1.Flowers:FindFirstChild(p3)

	if v12 then
		local v2 = v12:Clone()

		v2:PivotTo(p1.watering_cframe)
		v2:ScaleTo(2.25)
		v2.Parent = workspace
		p2:GiveTask(v2)
	end
end
function t.destroy(p1) --[[ destroy | Line: 312 ]]
	p1.growing_sprout = nil
	p1.maid:Destroy()
end

return t