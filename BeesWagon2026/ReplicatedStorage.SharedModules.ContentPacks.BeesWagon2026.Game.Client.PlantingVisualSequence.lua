-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local v1 = if RunService:IsRunning() then ReplicatedStorage.Resources else ServerStorage.ContentPacks.BeesWagon2026.SharedResources
local SeedPouch = v1.SeedPouch
local BeesWagon2026WateringCan = v1.BeesWagon2026WateringCan
local v2 = CFrame.new(0, 1, 0)
local v3 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v4 = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local v5 = CFrame.new(0, 2, -3) * CFrame.Angles(0.5235987755982988, 1.5707963267948966, 0)
local v6 = CFrame.new(0, 0.5, -0.8) * CFrame.Angles(0, 1.5707963267948966, 0)
local v7 = TweenInfo.new(0.18, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local v8 = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v9 = CFrame.new(0, 0.3, -0.5)
local v10 = TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
local v11 = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
local t = {
	Color3.fromRGB(125, 106, 92),
	Color3.fromRGB(125, 81, 64),
	Color3.fromRGB(91, 52, 32),
	Color3.fromRGB(72, 36, 25)
}
local v12 = TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
local v13 = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local t2 = {}

t2.__index = t2
t2.SPROUT_BUD_SCALE = 0.05

local function get_base_transparency(p1) --[[ get_base_transparency | Line: 68 ]]
	local v1 = p1:GetAttribute("PlantingVisualBaseTransparency")

	if v1 == nil then
		v1 = p1.Transparency
		p1:SetAttribute("PlantingVisualBaseTransparency", v1)
	end

	return v1
end

local function set_model_transparency_alpha(p1, p2) --[[ set_model_transparency_alpha | Line: 77 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") or v2:IsA("Decal") then
			local v3 = v2:GetAttribute("PlantingVisualBaseTransparency")

			if v3 == nil then
				v3 = v2.Transparency
				v2:SetAttribute("PlantingVisualBaseTransparency", v3)
			end

			v2.Transparency = v3 + (1 - v3) * p2
		end
	end
end

local function tween_model_transparency_alpha(p1, p2, p3) --[[ tween_model_transparency_alpha | Line: 86 | Upvalues: TweenPromise (copy), Promise (copy) ]]
	local t = {}

	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") or v2:IsA("Decal") then
			local v3 = v2:GetAttribute("PlantingVisualBaseTransparency")

			if v3 == nil then
				v3 = v2.Transparency
				v2:SetAttribute("PlantingVisualBaseTransparency", v3)
			end

			table.insert(t, TweenPromise.new(v2, p3, {
				Transparency = v3 + (1 - v3) * p2
			}))
		end
	end

	return Promise.all(t)
end

local function find_particle_emitter(p1) --[[ find_particle_emitter | Line: 98 ]]
	local Part = p1:FindFirstChild("Part")
	local v1 = if Part then Part:FindFirstChildOfClass("ParticleEmitter") else Part

	if v1 then
		return v1
	end

	for v2, v3 in p1:GetDescendants() do
		if v3:IsA("ParticleEmitter") then
			return v3
		end
	end

	return nil
end

local function get_seed_particle_emitter(p1) --[[ get_seed_particle_emitter | Line: 114 ]]
	local RightMount = p1:FindFirstChild("RightMount")
	local v1 = if RightMount then RightMount:FindFirstChild("Attachment") else RightMount

	return if v1 then v1:FindFirstChildOfClass("ParticleEmitter") else v1
end

local function get_soil_parts(p1) --[[ get_soil_parts | Line: 121 ]]
	local HoleintheGround = p1:FindFirstChild("HoleintheGround")
	local v1 = if HoleintheGround then HoleintheGround:FindFirstChild("Soil") else HoleintheGround

	if not v1 then
		return {}
	end

	if v1:IsA("BasePart") then
		return { v1 }
	end

	local t = {}

	for v2, v3 in v1:GetDescendants() do
		if v3:IsA("BasePart") then
			table.insert(t, v3)
		end
	end

	return t
end

local function tween_soil_wetness(p1, p2) --[[ tween_soil_wetness | Line: 141 | Upvalues: Promise (copy), t (copy), TweenPromise (copy) ]]
	if #p1 == 0 then
		return Promise.resolve()
	end

	local v1 = #t

	return TweenPromise.callback(1, v1, p2, function(p1) --[[ Line: 147 | Upvalues: v1 (copy), t (ref), p1 (copy) ]]
		local v2 = math.clamp(p1, 1, v1)
		local v7 = t[math.floor(v2)]:Lerp(t[math.min(math.floor(v2) + 1, v1)], v2 - math.floor(v2))

		for v8, v9 in p1 do
			v9.Color = v7
		end
	end)
end

local function tween_pivot_rotation(p1, p2, p3, p4, p5, p6, p7) --[[ tween_pivot_rotation | Line: 159 | Upvalues: TweenPromise (copy) ]]
	return TweenPromise.callback(p5, p6, p7, function(p1) --[[ Line: 160 | Upvalues: p4 (copy), p1 (copy), p3 (copy), p2 (copy) ]]
		p1:PivotTo(p3 * CFrame.fromAxisAngle(p4, (math.rad(p1))) * p3:Inverse() * p2)
	end)
end

function t2.new(p1, p2, p3, p4) --[[ new | Line: 166 | Upvalues: Maid (copy), t2 (copy) ]]
	return setmetatable({
		destroyed = false,
		maid = Maid.new(),
		planting_area = p1,
		base_cframe = p2,
		seed_type = p3,
		get_sprout = p4
	}, t2)
end
function t2._wait(p1, p2) --[[ _wait | Line: 187 | Upvalues: Promise (copy) ]]
	local v1 = Promise.delay(p2)

	p1.maid.step = v1
	v1:expect()
end
function t2._play_seed_pouch_phase(p1) --[[ _play_seed_pouch_phase | Line: 193 | Upvalues: SeedPouch (copy), v5 (copy), BeesWagonFlowerHelper (copy), set_model_transparency_alpha (copy), tween_model_transparency_alpha (copy), v3 (copy), v6 (copy), SoundPlayer (copy), v7 (copy), TweenPromise (copy), v4 (copy) ]]
	if p1.destroyed then
		return
	end

	local v1 = SeedPouch:Clone()
	local v2 = p1.base_cframe * v5

	for v32, v42 in v1:GetChildren() do
		if v42.Name ~= p1.seed_type and BeesWagonFlowerHelper.FLOWER_KINDS[v42.Name] then
			v42:Destroy()
		end
	end

	v1:PivotTo(v2)
	v1.Parent = workspace
	p1.maid.seed_pouch = v1
	set_model_transparency_alpha(v1, 1)

	local v52 = tween_model_transparency_alpha(v1, 0, v3)

	p1.maid.step = v52
	v52:expect()

	local ShakePivot = v1:FindFirstChild("ShakePivot", true)
	local v62 = if ShakePivot and ShakePivot:IsA("Attachment") then ShakePivot.WorldCFrame else v2 * v6
	local RightMount = v1:FindFirstChild("RightMount")
	local v72 = if RightMount then RightMount:FindFirstChild("Attachment") else RightMount
	local v8 = if v72 then v72:FindFirstChildOfClass("ParticleEmitter") else v72

	SoundPlayer.FX:play("Plant_Seeds", p1.planting_area:FindFirstChildWhichIsA("BasePart"))

	local v9, v10 = v8, 0

	for i = 1, 6 do
		local v11 = if i % 2 == 1 then 30 else -30
		local v13 = Vector3.new(1, 0, 0)
		local v14 = TweenPromise.callback(v10, v11, v7, function(p1) --[[ Line: 160 | Upvalues: v13 (copy), v1 (copy), v62 (copy), v2 (copy) ]]
			v1:PivotTo(v62 * CFrame.fromAxisAngle(v13, (math.rad(p1))) * v62:Inverse() * v2)
		end)

		p1.maid.step = v14
		v14:expect()

		if v9 and i % 2 == 0 then
			v9:Emit(5)
			v10 = v11

			continue
		end

		v10 = v11
	end

	local v16 = Vector3.new(1, 0, 0)
	local v17 = TweenPromise.callback(v10, 0, v7, function(p1) --[[ Line: 160 | Upvalues: v16 (copy), v1 (copy), v62 (copy), v2 (copy) ]]
		v1:PivotTo(v62 * CFrame.fromAxisAngle(v16, (math.rad(p1))) * v62:Inverse() * v2)
	end)

	p1.maid.step = v17
	v17:expect()

	local v18 = tween_model_transparency_alpha(v1, 1, v4)

	p1.maid.step = v18
	v18:expect()
	p1:_wait(1)
	p1.maid.seed_pouch = nil
end
function t2._play_watering_phase(p1) --[[ _play_watering_phase | Line: 250 | Upvalues: BeesWagon2026WateringCan (copy), v2 (copy), SoundPlayer (copy), set_model_transparency_alpha (copy), tween_model_transparency_alpha (copy), v8 (copy), v9 (copy), v10 (copy), TweenPromise (copy), find_particle_emitter (copy), get_soil_parts (copy), v12 (copy), Promise (copy), t (copy), v11 (copy) ]]
	if p1.destroyed then
		return
	end

	local v1 = BeesWagon2026WateringCan:Clone()
	local v22 = p1.base_cframe * v2

	v1:PivotTo(v22)
	v1.Parent = workspace
	p1.maid.watering_can = v1
	SoundPlayer.FX:play("Plant_Water", p1.planting_area:FindFirstChildWhichIsA("BasePart"))
	set_model_transparency_alpha(v1, 1)

	local v3 = tween_model_transparency_alpha(v1, 0, v8)

	p1.maid.step = v3
	v3:expect()

	local PourPivot = v1:FindFirstChild("PourPivot", true)
	local v4 = if PourPivot and PourPivot:IsA("Attachment") then PourPivot.WorldCFrame else v22 * v9
	local v6 = Vector3.new(1, 0, 0)
	local v7 = TweenPromise.callback(0, 50, v10, function(p1) --[[ Line: 160 | Upvalues: v6 (copy), v1 (copy), v4 (copy), v22 (copy) ]]
		v1:PivotTo(v4 * CFrame.fromAxisAngle(v6, (math.rad(p1))) * v4:Inverse() * v22)
	end)

	p1.maid.step = v7
	v7:expect()

	local v82 = find_particle_emitter(v1)

	if v82 then
		v82.Enabled = true
	end

	local v92 = get_soil_parts(p1.planting_area)
	local v102 = v12
	local v112

	if #v92 == 0 then
		v112 = Promise.resolve()
	else
		local v13 = #t

		v112 = TweenPromise.callback(1, v13, v102, function(p1) --[[ Line: 147 | Upvalues: v13 (copy), t (ref), v92 (copy) ]]
			local v2 = math.clamp(p1, 1, v13)
			local v7 = t[math.floor(v2)]:Lerp(t[math.min(math.floor(v2) + 1, v13)], v2 - math.floor(v2))

			for v8, v9 in v92 do
				v9.Color = v7
			end
		end)
	end

	p1.maid.soil_tween = v112
	p1:_wait(2)

	local v16, v17, v18

	if not v82 then
		local v15

		v15 = v10
		v16 = Vector3.new(1, 0, 0)
		v17 = TweenPromise.callback(50, 0, v10, function(p1) --[[ Line: 160 | Upvalues: v16 (copy), v1 (copy), v4 (copy), v22 (copy) ]]
			v1:PivotTo(v4 * CFrame.fromAxisAngle(v16, (math.rad(p1))) * v4:Inverse() * v22)
		end)
		p1.maid.step = v17
		v17:expect()
		p1:_wait(0.5)
		v18 = tween_model_transparency_alpha(v1, 1, v11)
		p1.maid.step = v18
		v18:expect()
		p1.maid.watering_can = nil

		return
	end

	v82.Enabled = false
	v16 = Vector3.new(1, 0, 0)
	v17 = TweenPromise.callback(50, 0, v10, function(p1) --[[ Line: 160 | Upvalues: v16 (copy), v1 (copy), v4 (copy), v22 (copy) ]]
		v1:PivotTo(v4 * CFrame.fromAxisAngle(v16, (math.rad(p1))) * v4:Inverse() * v22)
	end)
	p1.maid.step = v17
	v17:expect()
	p1:_wait(0.5)
	v18 = tween_model_transparency_alpha(v1, 1, v11)
	p1.maid.step = v18
	v18:expect()
	p1.maid.watering_can = nil
end
function t2._play_sprout_pop_phase(p1) --[[ _play_sprout_pop_phase | Line: 302 | Upvalues: SoundPlayer (copy), TweenPromise (copy), t2 (copy), v13 (copy) ]]
	if p1.destroyed then
		return
	end

	local v1 = p1.get_sprout()

	if v1 ~= nil then
		SoundPlayer.FX:play("Plant_Sprout", p1.planting_area:FindFirstChildWhichIsA("BasePart"))

		local v2 = TweenPromise.callback(t2.SPROUT_BUD_SCALE, 1, v13, function(p1) --[[ Line: 311 | Upvalues: v1 (copy) ]]
			v1:ScaleTo(p1)
		end)

		p1.maid.step = v2
		v2:expect()
	end
end
function t2.play(p1) --[[ play | Line: 318 | Upvalues: Promise (copy) ]]
	return Promise.try(function() --[[ Line: 319 | Upvalues: p1 (copy) ]]
		p1:_play_seed_pouch_phase()
		p1:_play_watering_phase()
		p1:_play_sprout_pop_phase()
	end):catch(function(p12) --[[ Line: 323 | Upvalues: p1 (copy), Promise (ref) ]]
		if p1.destroyed then
			return
		end

		return Promise.reject(p12)
	end)
end
function t2.destroy(p1) --[[ destroy | Line: 331 ]]
	p1.destroyed = true
	p1.maid:Destroy()
end

return t2