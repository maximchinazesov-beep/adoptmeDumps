-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local InteractionsEngine = require(ReplicatedStorage.ClientModules.Core.InteractionsEngine.InteractionsEngine)
local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local BeesWagonWagonNet = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonWagonNet)
local GameplayFX = require(ReplicatedStorage.SharedModules.GameplayFX)
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local PottedBouquetBillboard = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.PottedBouquetBillboard)
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local v1 = if RunService:IsRunning() then ReplicatedStorage.Resources else ServerStorage.ContentPacks.BeesWagon2026.SharedResources
local v2 = TweenInfo.new(1.6, Enum.EasingStyle.Exponential, Enum.EasingDirection.Out)
local v3 = TweenInfo.new(1.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local t = {
	["1"] = true,
	["2"] = true,
	["3"] = true
}
local t2 = {}

t2.__index = t2
function t2.new(p1, p2) --[[ new | Line: 58 | Upvalues: Maid (copy), BeesWagonFlowerHelper (copy), Players (copy), v1 (copy), t2 (copy), ReactRoblox (copy) ]]
	local v2 = setmetatable({
		awaiting_local_placement = false,
		maid = Maid.new(),
		bouquet_index = p2,
		requirements = BeesWagonFlowerHelper.get_bouquet_requirements(p2, Players.LocalPlayer.UserId),
		placed_flowers = {},
		placed_flower_models = {},
		bouquet_model = v1.BouquetTemplate:Clone()
	}, t2)

	v2.bouquet_model:PivotTo(p1)
	v2.bouquet_model.Parent = workspace
	v2.maid:GiveTask(v2.bouquet_model)
	v2.top_sparkles = v2.bouquet_model.VFXTop.Sparkles
	v2.bottom_sparkles = v2.bouquet_model.VFX.Sparkles
	v2.top_sparkles.Enabled = false
	v2.bottom_sparkles.Enabled = false

	local Part = Instance.new("Part")

	Part.Size = Vector3.new(4, 5, 4)
	Part.Anchored = true
	Part.CanCollide = false
	Part.CanQuery = false
	Part.CanTouch = false
	Part.Transparency = 1
	Part.CFrame = p1
	Part.Parent = workspace
	v2.maid:GiveTask(Part)
	v2.interaction_part = Part

	local RecipeBillboardAttachment = Instance.new("Attachment")

	RecipeBillboardAttachment.Name = "RecipeBillboardAttachment"
	RecipeBillboardAttachment.CFrame = CFrame.new(0, 5, 0)
	RecipeBillboardAttachment.Parent = Part
	v2.billboard_attachment = RecipeBillboardAttachment

	local v3 = ReactRoblox.createRoot(Instance.new("Folder"))

	v2.billboard_root = v3
	v2.maid:GiveTask(function() --[[ Line: 98 | Upvalues: v3 (copy) ]]
		v3:unmount()
	end)
	v2.billboard_visible = false
	v2.billboard_enlarged = false
	v2.poofed_out = false
	v2:_render_placed_flowers()
	v2:_refresh_interaction()
	v2:_refresh_billboard()

	return v2
end

local function placed_flowers_equal(p1, p2) --[[ placed_flowers_equal | Line: 112 ]]
	if #p1 ~= #p2 then
		return false
	end

	for i = 1, #p1 do
		if p1[i] ~= p2[i] then
			return false
		end
	end

	return true
end

function t2.set_state(p1, p2, p3) --[[ set_state | Line: 123 | Upvalues: SoundPlayer (copy) ]]
	local v1 = if p2 then p2 else {}
	local placed_flowers = p1.placed_flowers
	local v2, v3, v4

	if #placed_flowers == #v1 then
		for i = 1, #placed_flowers do
			if placed_flowers[i] ~= v1[i] then
				v2 = false

				if v2 then
					return
				end

				v3 = #p1.placed_flowers
				v4 = if p1.awaiting_local_placement and v3 < #v1 then v3 + 1 else nil
				p1.awaiting_local_placement = false

				if #v1 == #p1.requirements then
					if not p3 then
						SoundPlayer.FX:play("FlowerPlaceComplete")
					end

					p1.top_sparkles:Emit(18)
				elseif v3 < #v1 and not p3 then
					SoundPlayer.FX:play("FlowerPlace")
				end

				p1.placed_flowers = v1
				p1:_render_placed_flowers(v4)
				p1:_refresh_interaction()
				p1:_refresh_billboard()
				p1:_refresh_sparkles()

				return
			end
		end

		v2 = true
	else
		v2 = false
	end

	if v2 then
		return
	end

	v3 = #p1.placed_flowers
	v4 = if p1.awaiting_local_placement and v3 < #v1 then v3 + 1 else nil
	p1.awaiting_local_placement = false

	if #v1 == #p1.requirements then
		if not p3 then
			SoundPlayer.FX:play("FlowerPlaceComplete")
		end

		p1.top_sparkles:Emit(18)
	elseif v3 < #v1 and not p3 then
		SoundPlayer.FX:play("FlowerPlace")
	end

	p1.placed_flowers = v1
	p1:_render_placed_flowers(v4)
	p1:_refresh_interaction()
	p1:_refresh_billboard()
	p1:_refresh_sparkles()
end
function t2.set_complete(p1) --[[ set_complete | Line: 156 | Upvalues: BeesWagonFlowerHelper (copy) ]]
	if #p1.placed_flowers >= #p1.requirements then
		return
	end

	local v1 = table.clone(p1.placed_flowers)
	local v2 = BeesWagonFlowerHelper.compute_remaining_requirements(p1.requirements, p1.placed_flowers)

	for v3, v4 in p1.requirements do
		if #v1 >= #p1.requirements then
			break
		end

		local v5 = v2[v4]

		if v5 and v5 > 0 then
			v2[v4] = v5 - 1
			table.insert(v1, v4)
		end
	end

	p1:set_state(v1)
end
function t2.poof_out(p1) --[[ poof_out | Line: 175 ]]
	p1.poofed_out = true
	p1:_emit_poof_particles()
	p1.bouquet_model.Parent = nil
	p1.maid.flower_maid = nil
	p1.placed_flower_models = {}
	p1.placed_flowers = {}
	p1.top_sparkles.Enabled = false
	p1.bottom_sparkles.Enabled = false
	p1.maid.interaction = nil
	p1.billboard_root:render(nil)
end
function t2.poof_in(p1) --[[ poof_in | Line: 188 | Upvalues: SoundPlayer (copy) ]]
	SoundPlayer.FX:play("PrizeDisappear")
	p1.poofed_out = false
	p1.bouquet_model.Parent = workspace
	p1:_refresh_interaction()
	p1:_refresh_billboard()
	p1:_refresh_sparkles()
	p1:_emit_poof_particles()
	p1:_emit_confetti_burst()
end
function t2._emit_poof_particles(p1) --[[ _emit_poof_particles | Line: 199 | Upvalues: GameplayFX (copy) ]]
	GameplayFX.emit_poof(p1.bouquet_model:GetPivot().Position + Vector3.new(0, 1.5, 0), 20, 2)
end
function t2._emit_confetti_burst(p1) --[[ _emit_confetti_burst | Line: 204 | Upvalues: t (copy), SoundPlayer (copy), GameplayFX (copy), v1 (copy) ]]
	local v12 = if t[p1.bouquet_index] then -25 else 25
	local v2 = (p1.bouquet_model:GetPivot() + Vector3.new(0, 1.5, 0)) * CFrame.Angles(0, 0, (math.rad(v12)))

	SoundPlayer.FX:play("Winter2023CelebrationFireworkLauncherExplode")
	GameplayFX.emit_particle_group(v1.ConfettiBurst, v2, 30, 4)
end
function t2.set_proximity(p1, p2, p3) --[[ set_proximity | Line: 211 ]]
	local v1 = if p2 <= 40 then true else false
	local v2 = if p3 then p2 <= 4 else p3

	if v1 == p1.billboard_visible and v2 == p1.billboard_enlarged then
		return
	end

	p1.billboard_visible = v1
	p1.billboard_enlarged = v2
	p1:_refresh_billboard()
end
function t2._refresh_billboard(p1) --[[ _refresh_billboard | Line: 224 | Upvalues: React (copy), PottedBouquetBillboard (copy) ]]
	if p1.poofed_out then
		return
	end

	if #p1.placed_flowers >= #p1.requirements then
		p1.billboard_root:render(nil)
	else
		p1.billboard_root:render(React.createElement(PottedBouquetBillboard, {
			attachment = p1.billboard_attachment,
			recipe = p1.requirements,
			placed_flowers = p1.placed_flowers,
			visible = p1.billboard_visible,
			enlarged = p1.billboard_enlarged
		}))
	end
end
function t2._get_bouquet_root_models(p1) --[[ _get_bouquet_root_models | Line: 245 ]]
	local v1 = p1.bouquet_model.BouquetRoots:GetChildren()

	table.sort(v1, function(p1, p2) --[[ Line: 247 ]]
		return p1.Name < p2.Name
	end)

	return v1
end
function t2._render_placed_flowers(p1, p2) --[[ _render_placed_flowers | Line: 251 | Upvalues: Maid (copy), v1 (copy) ]]
	local v12 = Maid.new()

	p1.maid.flower_maid = v12
	p1.placed_flower_models = {}

	local v2 = p1:_get_bouquet_root_models()
	local v4 = Random.new(tonumber(p1.bouquet_index) or 0)

	for v5, v6 in p1.placed_flowers do
		local v7 = v2[v5]

		if v7 then
			local v8 = v1.Flowers:FindFirstChild(v6)

			if v8 then
				local v9 = v8:Clone()
				local v10 = v7:GetPivot()
				local v11 = v7:GetScale()
				local v13 = v10 * CFrame.Angles(0, math.rad((v4:NextNumber(-15, 15))), 0)

				v9:ScaleTo(v11 * v4:NextNumber(1, 1.3))

				if p2 and p2 <= v5 then
					p1:_animate_flower_drop(v12, v9, v13)
				else
					v9:PivotTo(v13)
				end

				v9.Parent = workspace
				v12:GiveTask(v9)
				table.insert(p1.placed_flower_models, v9)
			end
		end
	end
end
function t2._animate_flower_drop(p1, p2, p3, p4) --[[ _animate_flower_drop | Line: 287 | Upvalues: TweenPromise (copy), v3 (copy), v2 (copy) ]]
	local v1 = p4 + Vector3.new(0, 6, 0)

	p3:PivotTo(v1)

	for v22, v32 in p3:GetDescendants() do
		if v32:IsA("BasePart") then
			local Transparency = v32.Transparency

			v32.Transparency = 1
			p2:GiveTask(TweenPromise.new(v32, v3, {
				Transparency = Transparency
			}))
		end
	end

	p2:GiveTask(TweenPromise.callback(0, 1, v2, function(p1) --[[ Line: 299 | Upvalues: p3 (copy), v1 (copy), p4 (copy) ]]
		p3:PivotTo(v1:Lerp(p4, p1))
	end))
end

local function local_player_has_any_matching(p1) --[[ local_player_has_any_matching | Line: 304 | Upvalues: ClientData (copy), BeesWagonFlowerHelper (copy) ]]
	for v3, v4 in (ClientData.get("inventory") or {}).toys or {} do
		for v5 in p1 do
			if v4.kind == BeesWagonFlowerHelper.get_flower_item_kind(v5) then
				return true
			end
		end
	end

	return false
end

function t2._refresh_interaction(p1) --[[ _refresh_interaction | Line: 319 | Upvalues: BeesWagonFlowerHelper (copy), InteractionsEngine (copy), local_player_has_any_matching (copy), SoundPlayer (copy), UIManager (copy), BeesWagonWagonNet (copy) ]]
	p1.maid.interaction = nil

	if not (#p1.placed_flowers >= BeesWagonFlowerHelper.FLOWERS_PER_BOUQUET) then
		p1.maid.interaction = InteractionsEngine:register({
			text = function() --[[ text | Line: 325 ]]
				return "Arrange"
			end,
			part = p1.interaction_part,
			on_selected = function() --[[ on_selected | Line: 327 | Upvalues: BeesWagonFlowerHelper (ref), p1 (copy), local_player_has_any_matching (ref), SoundPlayer (ref), UIManager (ref), BeesWagonWagonNet (ref) ]]
				if local_player_has_any_matching((BeesWagonFlowerHelper.compute_remaining_requirements(p1.requirements, p1.placed_flowers))) then
					p1.awaiting_local_placement = true
					BeesWagonWagonNet.RequestAddBouquetFlower:fire_server(p1.bouquet_index)
				else
					SoundPlayer.FX:play("FlowerPlaceWrong")
					UIManager.apps.HintApp:hint({
						text = "You need more flowers for this vase!",
						length = 4,
						yields = false,
						overridable = true
					})
				end
			end
		})
	end
end
function t2._first_missing_kind(p1, p2) --[[ _first_missing_kind | Line: 345 ]]
	local t = {}

	for v1, v2 in p1.requirements do
		if p2[v2] and not t[v2] then
			t[v2] = true

			return v2
		end
	end

	return nil
end
function t2._refresh_sparkles(p1) --[[ _refresh_sparkles | Line: 359 ]]
	local v1 = #p1.placed_flowers == #p1.requirements

	p1.top_sparkles.Enabled = v1
	p1.bottom_sparkles.Enabled = v1
end
function t2.destroy(p1) --[[ destroy | Line: 365 ]]
	p1.maid:Destroy()
end

return t2