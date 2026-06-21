-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingRingRenderer
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local GameplayFX = require(SharedModules.GameplayFX)
local Maid = require(SharedModules.Maid)
local Signal = require(SharedModules.Signal)
local Resources = ReplicatedStorage:WaitForChild("Resources")
local SkydivingRing = Resources.Skydiving.SkydivingRing
local SpawnPoof = Resources.IceSkating.SpawnPoof
local RING_PREVIEW_WINDOW = SkydivingConstants.RING_PREVIEW_WINDOW
local RING_BASE_TRANSPARENCY = SkydivingConstants.RING_BASE_TRANSPARENCY
local v1 = Color3.fromRGB(0, 126, 92)
local v2 = Color3.fromRGB(51, 154, 116)
local t = {}

t.__index = t
function t.new(p1, p2, p3) --[[ new | Line: 27 | Upvalues: Maid (copy), Signal (copy), t (copy) ]]
	local v1 = Maid.new()
	local SkydivingRings = Instance.new("Folder")

	SkydivingRings.Name = "SkydivingRings"
	SkydivingRings.Parent = workspace

	local v3 = setmetatable({
		_next_index = 1,
		_rings = {},
		_ring_folder = SkydivingRings,
		_sorted_ring_ids = {},
		_active_ring_ids = {},
		_is_time_trial = p2 or false,
		_start_altitude = p3,
		_maid = v1,
		ring_collected = Signal.new(),
		ring_missed = Signal.new()
	}, t)

	v1:GiveTask(v3.ring_collected)
	v1:GiveTask(v3.ring_missed)
	v1:GiveTask(SkydivingRings)

	for v4, v5 in p1 do
		v3:_create_ring(v4, v5.cframe, if p2 then true else not v5.scored)
	end

	v3:_build_sorted_order()

	return v3
end
function t._build_sorted_order(p1) --[[ _build_sorted_order | Line: 65 ]]
	local t = {}

	for v1, v2 in p1._rings do
		if not v2.collected then
			table.insert(t, v1)
		end
	end

	table.sort(t, function(p12, p2) --[[ Line: 73 | Upvalues: p1 (copy) ]]
		return p1._rings[p12].position.Y > p1._rings[p2].position.Y
	end)
	p1._sorted_ring_ids = t
end
function t._create_ring(p1, p2, p3, p4) --[[ _create_ring | Line: 80 | Upvalues: SkydivingRing (copy), Players (copy), RING_BASE_TRANSPARENCY (copy) ]]
	local v1 = SkydivingRing:Clone()

	v1.Name = p2
	v1:PivotTo(p3)

	local Collider = v1:FindFirstChild("Collider")
	local v2 = nil

	if Collider then
		Collider.CanCollide = false
		Collider.CanTouch = false
		Collider.Anchored = true

		if p4 then
			v2 = Collider.Touched:Connect(function(p12) --[[ Line: 94 | Upvalues: Players (ref), p1 (copy), p2 (copy) ]]
				local Character = Players.LocalPlayer.Character

				if not Character then
					return
				end

				if p12:IsDescendantOf(Character) then
					p1:_on_ring_touched(p2)
				end
			end)
		end
	end

	v1.Parent = p1._ring_folder

	local v4 = p3 - p3.Position
	local v5 = if Collider then Collider.Size / 2 else Vector3.new(0.5, 0.5, 0.5)
	local Y = (v4 * Vector3.new(v5.X, 0, 0)).Y
	local v6 = math.abs(Y)
	local Y3 = (v4 * Vector3.new(0, v5.Y, 0)).Y
	local v7 = v6 + math.abs(Y3)
	local Y4 = (v4 * Vector3.new(0, 0, v5.Z)).Y
	local v8 = v7 + math.abs(Y4)

	if p4 then
		p1:_set_ring_transparency(v1, RING_BASE_TRANSPARENCY)

		if p1._is_time_trial then
			p1:_apply_time_trial_visual(v1)
		end

		p1:_apply_activation_visual(v1, false)
	else
		p1:_apply_collected_visual(v1)
	end

	p1._rings[p2] = {
		pending = false,
		model = v1,
		position = p3.Position,
		y_extent = v8,
		collected = not p4,
		unreachable = if p1._start_altitude == nil then false elseif p3.Position.Y - v8 > p1._start_altitude then true else false,
		touched_connection = v2
	}
end

local function set_center_glow_active(p1, p2) --[[ set_center_glow_active | Line: 144 ]]
	local Attachment = p1:FindFirstChild("Attachment")

	if Attachment then
		local ParticleEmitter = Attachment:FindFirstChildOfClass("ParticleEmitter")

		if ParticleEmitter then
			ParticleEmitter.Enabled = p2
		end
	end

	local Decal = p1:FindFirstChild("Decal")
	local Decal1 = p1:FindFirstChild("Decal1")
	local v1 = if p2 then 0.7 else 1

	if Decal then
		Decal.Transparency = v1
	end

	if not Decal1 then
		return
	end

	Decal1.Transparency = v1
end

function t._set_ring_transparency(p1, p2, p3) --[[ _set_ring_transparency | Line: 164 ]]
	local Visual = p2:FindFirstChild("Visual")

	if not Visual then
		return
	end

	local Ring1 = Visual:FindFirstChild("Ring1")
	local Ring2 = Visual:FindFirstChild("Ring2")

	if Ring1 then
		Ring1.Transparency = p3
	end

	if not Ring2 then
		return
	end

	Ring2.Transparency = p3
end
function t._apply_time_trial_visual(p1, p2) --[[ _apply_time_trial_visual | Line: 181 | Upvalues: v1 (copy), v2 (copy) ]]
	local Visual = p2:FindFirstChild("Visual")

	if not Visual then
		return
	end

	local Ring1 = Visual:FindFirstChild("Ring1")
	local Ring2 = Visual:FindFirstChild("Ring2")

	if Ring1 then
		Ring1.Color = v1
	end

	if not Ring2 then
		return
	end

	Ring2.Color = v2
end
function t._apply_collected_visual(p1, p2) --[[ _apply_collected_visual | Line: 197 ]]
	local Visual = p2:FindFirstChild("Visual")

	if not Visual then
		return
	end

	local Ring1 = Visual:FindFirstChild("Ring1")
	local Ring2 = Visual:FindFirstChild("Ring2")
	local CenterGlow = Visual:FindFirstChild("CenterGlow")

	if Ring1 then
		Ring1.Transparency = 0.8
		Ring1.Material = Enum.Material.Cardboard
	end

	if Ring2 then
		Ring2.Transparency = 0.8
		Ring2.Material = Enum.Material.Cardboard
	end

	if not CenterGlow then
		return
	end

	local Attachment = CenterGlow:FindFirstChild("Attachment")

	if Attachment then
		local ParticleEmitter = Attachment:FindFirstChildOfClass("ParticleEmitter")

		if ParticleEmitter then
			ParticleEmitter.Enabled = false
		end
	end

	local Decal = CenterGlow:FindFirstChild("Decal")
	local Decal1 = CenterGlow:FindFirstChild("Decal1")

	if Decal then
		Decal.Transparency = 1
	end

	if not Decal1 then
		return
	end

	Decal1.Transparency = 1
end
function t._on_ring_touched(p1, p2) --[[ _on_ring_touched | Line: 220 ]]
	local v1 = p1._rings[p2]

	if not v1 or v1.collected then
		return
	end

	v1.collected = true
	v1.pending = true

	if v1.touched_connection then
		v1.touched_connection:Disconnect()
		v1.touched_connection = nil
	end

	p1:_animate_collection(v1)
	p1.ring_collected:Fire(p2)
end
function t._animate_collection(p1, p2) --[[ _animate_collection | Line: 237 | Upvalues: GameplayFX (copy), SpawnPoof (copy) ]]
	GameplayFX.emit_particle_group(SpawnPoof, p2.position)
	p1:_apply_collected_visual(p2.model)
end
function t.update_next_ring(p1, p2) --[[ update_next_ring | Line: 242 ]]
	local _sorted_ring_ids = p1._sorted_ring_ids
	local Y = p2.Y

	while p1._next_index <= #_sorted_ring_ids do
		local v1 = _sorted_ring_ids[p1._next_index]
		local v2 = p1._rings[v1]

		if v2 and not v2.collected then
			if not (Y < v2.position.Y - v2.y_extent) then
				break
			end

			if p1._is_time_trial and not v2.unreachable then
				p1.ring_missed:Fire(v1)
			end
		end

		p1._next_index = p1._next_index + 1
	end

	p1:_update_visible_window()
end
function t._update_visible_window(p1) --[[ _update_visible_window | Line: 264 | Upvalues: RING_PREVIEW_WINDOW (copy), RING_BASE_TRANSPARENCY (copy) ]]
	local _sorted_ring_ids = p1._sorted_ring_ids
	local count = 0
	local t = {}

	for i = p1._next_index, #_sorted_ring_ids do
		local v1 = _sorted_ring_ids[i]
		local v2 = p1._rings[v1]

		if v2 and not v2.collected then
			count = count + 1
			t[v1] = count

			if RING_PREVIEW_WINDOW <= count then
				break
			end
		end
	end

	for v3 in p1._active_ring_ids do
		if not t[v3] then
			local v4 = p1._rings[v3]

			if v4 and not v4.collected then
				p1:_set_ring_touchable(v3, false)
				p1:_apply_activation_visual(v4.model, false)
				p1:_set_ring_transparency(v4.model, RING_BASE_TRANSPARENCY)
			end
		end
	end

	for v5, v6 in t do
		local v7 = p1._rings[v5]

		p1:_set_ring_touchable(v5, true)
		p1:_apply_activation_visual(v7.model, v6 == 1)
		p1:_set_ring_transparency(v7.model, (v6 - 1) / RING_PREVIEW_WINDOW * RING_BASE_TRANSPARENCY)
	end

	p1._active_ring_ids = t
end
function t._apply_activation_visual(p1, p2, p3) --[[ _apply_activation_visual | Line: 307 | Upvalues: set_center_glow_active (copy) ]]
	local Visual = p2:FindFirstChild("Visual")

	if not Visual then
		return
	end

	local v1 = if p3 then Enum.Material.Neon else Enum.Material.Cardboard
	local Ring1 = Visual:FindFirstChild("Ring1")
	local Ring2 = Visual:FindFirstChild("Ring2")

	if Ring1 then
		Ring1.Material = v1
	end

	if Ring2 then
		Ring2.Material = v1
	end

	local CenterGlow = Visual:FindFirstChild("CenterGlow")

	if not CenterGlow then
		return
	end

	set_center_glow_active(CenterGlow, p3)
end
function t._set_ring_touchable(p1, p2, p3) --[[ _set_ring_touchable | Line: 329 ]]
	local v1 = p1._rings[p2]

	if not v1 then
		return
	end

	local Collider = v1.model:FindFirstChild("Collider")

	if not Collider then
		return
	end

	Collider.CanTouch = p3
end
function t.confirm_ring(p1, p2) --[[ confirm_ring | Line: 341 ]]
	local v1 = p1._rings[p2]

	if v1 then
		v1.pending = false
	end
end
function t.rollback_ring(p1, p2) --[[ rollback_ring | Line: 349 ]]
	local v1 = p1._rings[p2]

	if not v1 then
		return
	end

	v1.collected = false
	v1.pending = false

	local Visual = v1.model:FindFirstChild("Visual")

	if not Visual then
		return
	end

	local Ring1 = Visual:FindFirstChild("Ring1")
	local Ring2 = Visual:FindFirstChild("Ring2")
	local CenterGlow = Visual:FindFirstChild("CenterGlow")

	if Ring1 then
		Ring1.Material = Enum.Material.Cardboard
	end

	if Ring2 then
		Ring2.Material = Enum.Material.Cardboard
	end

	if CenterGlow then
		local Attachment = CenterGlow:FindFirstChild("Attachment")

		if Attachment then
			local ParticleEmitter = Attachment:FindFirstChildOfClass("ParticleEmitter")

			if ParticleEmitter then
				ParticleEmitter.Enabled = false
			end
		end

		local Decal = CenterGlow:FindFirstChild("Decal")
		local Decal1 = CenterGlow:FindFirstChild("Decal1")

		if Decal then
			Decal.Transparency = 1
		end

		if Decal1 then
			Decal1.Transparency = 1
		end
	end

	p1:_update_visible_window()
end
function t.get_unreachable_ring_ids(p1) --[[ get_unreachable_ring_ids | Line: 379 ]]
	local t = {}

	for v1, v2 in p1._rings do
		if v2.unreachable then
			table.insert(t, v1)
		end
	end

	return t
end
function t.destroy(p1) --[[ destroy | Line: 389 ]]
	for v1, v2 in p1._rings do
		if v2.touched_connection then
			v2.touched_connection:Disconnect()
			v2.touched_connection = nil
		end
	end

	p1._rings = {}
	p1._maid:DoCleaning()
end

return t

