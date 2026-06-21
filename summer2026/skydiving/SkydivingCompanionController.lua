-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingCompanionController
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameplayFX = require(ReplicatedStorage.SharedModules.GameplayFX)
local PetEntityHelper = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityHelper)
local PetEntityManager = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityManager)
local SkydivingUtilities = require(script.Parent.SkydivingUtilities)
local SpawnPoof = ReplicatedStorage:WaitForChild("Resources").IceSkating.SpawnPoof
local t = {}

t.__index = t

local function calculate_slot_offsets(p1) --[[ calculate_slot_offsets | Line: 22 ]]
	local t = {}

	for i = 1, p1 do
		local v1 = math.ceil(i / 2)

		table.insert(t, (Vector3.new((if i % 2 == 1 then -1 else 1) * v1 * 5, 0, (v1 - 1) * 2 + 3)))
	end

	return t
end

local function create_companion(p1, p2, p3) --[[ create_companion | Line: 34 | Upvalues: GameplayFX (copy), SpawnPoof (copy), SkydivingUtilities (copy), PetEntityHelper (copy) ]]
	local root = p1.base.root

	GameplayFX.emit_particle_group(SpawnPoof, root.Position)
	root.CFrame = CFrame.new(p2) * (root.CFrame - root.CFrame.Position)
	GameplayFX.emit_particle_group(SpawnPoof, p2)

	local v1 = SkydivingUtilities.create_movement_rig(root, {
		responsiveness = 30,
		trail_span = 0.5,
		trail_lifetime = 2,
		position = p2
	})

	PetEntityHelper.cancel_all_performances(p1)
	PetEntityHelper.stage_performance(p1, {
		name = "SkydivingCompanion",
		options = {}
	})

	return {
		pet_entity = p1,
		offset = p3,
		movement_rig = v1
	}
end

local function cleanup_companion(p1, p2) --[[ cleanup_companion | Line: 63 | Upvalues: GameplayFX (copy), SpawnPoof (copy), Players (copy), SkydivingUtilities (copy), PetEntityHelper (copy) ]]
	local pet_entity = p1.pet_entity
	local root = pet_entity.base.root

	GameplayFX.emit_particle_group(SpawnPoof, root.Position)

	local Character = Players.LocalPlayer.Character
	local v1 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character

	if v1 then
		root.CFrame = CFrame.new(v1.Position + Vector3.new(0, 0, 3)) * (root.CFrame - root.CFrame.Position)
		GameplayFX.emit_particle_group(SpawnPoof, root.Position)
	end

	SkydivingUtilities.destroy_movement_rig(p1.movement_rig)
	PetEntityHelper.cancel_performance(pet_entity, "SkydivingCompanion")

	if not p2 then
		return
	end

	task.spawn(function() --[[ Line: 81 | Upvalues: PetEntityHelper (ref), pet_entity (copy) ]]
		task.wait(0.2)
		PetEntityHelper.stage_performance(pet_entity, {
			name = "HappyHop",
			options = {}
		})
		task.wait(0.75)
		PetEntityHelper.stage_performance(pet_entity, {
			name = "HappyHop",
			options = {}
		})
	end)
end

local function create_shoulder_companion(p1, p2) --[[ create_shoulder_companion | Line: 90 | Upvalues: SkydivingUtilities (copy) ]]
	local PrimaryPart = p1.PrimaryPart

	if not PrimaryPart then
		return nil
	end

	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			v2.Anchored = false
			v2.CanCollide = false
			v2.CanQuery = false
			v2.CanTouch = false
			v2.Massless = true
		end
	end

	p1:PivotTo(CFrame.new(p2))
	p1.Parent = workspace

	return {
		offset = Vector3.new(3, 1.5, 0),
		model = p1,
		hrp = PrimaryPart,
		movement_rig = SkydivingUtilities.create_movement_rig(PrimaryPart, {
			responsiveness = 30,
			trail_span = 0.5,
			trail_lifetime = 2,
			position = p2
		})
	}
end

local function cleanup_shoulder_companion(p1) --[[ cleanup_shoulder_companion | Line: 125 | Upvalues: SkydivingUtilities (copy) ]]
	SkydivingUtilities.destroy_movement_rig(p1.movement_rig)
	p1.model:Destroy()
end

local function update_companion(p1, p2) --[[ update_companion | Line: 130 ]]
	local movement_rig = p1.movement_rig

	movement_rig.align_position.Position = p2

	local v2 = p2 - (p1.pet_entity and p1.pet_entity.base.root or p1.hrp).Position
	local v3 = Vector3.new(v2.X, 0, v2.Z)

	if not (v3.Magnitude > 0.01) then
		return
	end

	local v5 = math.clamp(math.atan2(v2.Y, v3.Magnitude), -1.3962634015954636, 1.3962634015954636)

	movement_rig.align_orientation.CFrame = CFrame.new(Vector3.new(0, 0, 0), v3.Unit) * CFrame.Angles(v5, 0, 0)
end

function t.new(p1, p2) --[[ new | Line: 144 | Upvalues: PetEntityManager (copy), calculate_slot_offsets (copy), create_companion (copy), t (copy) ]]
	local t2 = {}

	for v1, v2 in PetEntityManager.get_pet_entities() do
		if v2.client_has_control and not v2.is_npc_pet then
			table.insert(t2, v2)
		end
	end

	local v5 = Vector3.new(-math.sin(p2), 0, -math.cos(p2))
	local v8 = Vector3.new(-math.cos(p2), 0, (math.sin(p2)))
	local v9 = calculate_slot_offsets(#t2)
	local t3 = {}

	for v10, v11 in t2 do
		local v12 = v9[v10]

		table.insert(t3, (create_companion(v11, p1 + v8 * v12.X + v5 * -v12.Z, v12)))
	end

	return setmetatable({
		_shoulder_companion = nil,
		_companions = t3
	}, t)
end
function t.add_companion(p1, p2, p3, p4, p5) --[[ add_companion | Line: 169 | Upvalues: create_companion (copy) ]]
	local v3 = Vector3.new(-math.sin(p5), 0, -math.cos(p5))

	table.insert(p1._companions, (create_companion(p2, p4 + Vector3.new(-math.cos(p5), 0, (math.sin(p5))) * p3.X + v3 * -p3.Z, p3)))
end
function t.set_shoulder_companion(p1, p2, p3, p4) --[[ set_shoulder_companion | Line: 176 | Upvalues: SkydivingUtilities (copy), create_shoulder_companion (copy) ]]
	if p1._shoulder_companion then
		local _shoulder_companion = p1._shoulder_companion

		SkydivingUtilities.destroy_movement_rig(_shoulder_companion.movement_rig)
		_shoulder_companion.model:Destroy()
		p1._shoulder_companion = nil
	end

	local v3 = Vector3.new(-math.sin(p4), 0, -math.cos(p4))

	p1._shoulder_companion = create_shoulder_companion(p2, p3 + Vector3.new(-math.cos(p4), 0, (math.sin(p4))) * 3 + Vector3.new(0, 1.5, 0) + v3 * -0)
end
function t.update(p1, p2, p3) --[[ update | Line: 190 | Upvalues: update_companion (copy) ]]
	local v3 = Vector3.new(-math.sin(p3), 0, -math.cos(p3))
	local v6 = Vector3.new(-math.cos(p3), 0, (math.sin(p3)))

	for v7, v8 in p1._companions do
		local offset = v8.offset

		update_companion(v8, p2 + v6 * offset.X + v3 * -offset.Z)
	end

	if not p1._shoulder_companion then
		return
	end

	local offset = p1._shoulder_companion.offset

	update_companion(p1._shoulder_companion, p2 + v6 * offset.X + Vector3.new(0, offset.Y, 0) + v3 * -offset.Z)
end
function t.destroy(p1, p2) --[[ destroy | Line: 207 | Upvalues: cleanup_companion (copy), SkydivingUtilities (copy) ]]
	for v1, v2 in p1._companions do
		cleanup_companion(v2, p2 == true)
	end

	p1._companions = {}

	if not p1._shoulder_companion then
		return
	end

	local _shoulder_companion = p1._shoulder_companion

	SkydivingUtilities.destroy_movement_rig(_shoulder_companion.movement_rig)
	_shoulder_companion.model:Destroy()
	p1._shoulder_companion = nil
end

return t

