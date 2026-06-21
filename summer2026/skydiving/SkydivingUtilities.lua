-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingUtilities
-- ==========================================

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ProjectileTrail = ReplicatedStorage:WaitForChild("Resources").Effects.ProjectileTrail
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local t = {
	create_movement_rig = function(p1, p2) --[[ create_movement_rig | Line: 17 | Upvalues: ProjectileTrail (copy) ]]
		local v1 = p2.responsiveness or 200
		local v2 = p2.max_force or 1000000
		local v3 = p2.trail_span or 1
		local t = {}
		local SkydivingAttachment = Instance.new("Attachment")

		SkydivingAttachment.Name = "SkydivingAttachment"
		SkydivingAttachment.Parent = p1
		table.insert(t, SkydivingAttachment)

		local AlignPosition = Instance.new("AlignPosition")

		AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
		AlignPosition.Attachment0 = SkydivingAttachment
		AlignPosition.Position = p2.position
		AlignPosition.Responsiveness = v1
		AlignPosition.MaxForce = v2
		AlignPosition.Parent = p1
		table.insert(t, AlignPosition)

		local AlignOrientation = Instance.new("AlignOrientation")

		AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
		AlignOrientation.Attachment0 = SkydivingAttachment
		AlignOrientation.CFrame = p1.CFrame - p1.CFrame.Position
		AlignOrientation.Responsiveness = v1
		AlignOrientation.MaxTorque = v2
		AlignOrientation.Parent = p1
		table.insert(t, AlignOrientation)

		local Attachment = Instance.new("Attachment")

		Attachment.Position = Vector3.new(0, v3, 0)
		Attachment.Parent = p1
		table.insert(t, Attachment)

		local Attachment2 = Instance.new("Attachment")

		Attachment2.Position = Vector3.new(0, -v3, 0)
		Attachment2.Parent = p1
		table.insert(t, Attachment2)

		local v4 = ProjectileTrail:Clone()

		v4.Attachment0 = Attachment
		v4.Attachment1 = Attachment2

		if p2.trail_lifetime then
			v4.Lifetime = p2.trail_lifetime
		end

		v4.Parent = p1
		table.insert(t, v4)

		local Attachment3 = Instance.new("Attachment")

		Attachment3.Position = Vector3.new(-v3, 0, 0)
		Attachment3.Parent = p1
		table.insert(t, Attachment3)

		local Attachment4 = Instance.new("Attachment")

		Attachment4.Position = Vector3.new(v3, 0, 0)
		Attachment4.Parent = p1
		table.insert(t, Attachment4)

		local v5 = ProjectileTrail:Clone()

		v5.Attachment0 = Attachment3
		v5.Attachment1 = Attachment4

		if p2.trail_lifetime then
			v5.Lifetime = p2.trail_lifetime
		end

		v5.Parent = p1
		table.insert(t, v5)

		return {
			align_position = AlignPosition,
			align_orientation = AlignOrientation,
			instances = t
		}
	end,
	destroy_movement_rig = function(p1) --[[ destroy_movement_rig | Line: 97 ]]
		for v1, v2 in p1.instances do
			v2:Destroy()
		end
	end,
	zero_character_velocity = function(p1) --[[ zero_character_velocity | Line: 103 ]]
		if not p1 then
			return
		end

		local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")

		if not (HumanoidRootPart and HumanoidRootPart:IsA("BasePart")) then
			return
		end

		HumanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
		HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
	end,
	get_airship_interior_spawn_cframe = function(p1) --[[ get_airship_interior_spawn_cframe | Line: 115 | Upvalues: Players (copy) ]]
		local v1 = p1:FindFirstChild("Doors") and p1.Doors:FindFirstChild("Airship")
		local v2 = if v1 then v1:FindFirstChild("WorkingParts") and v1.WorkingParts:FindFirstChild("TouchToEnter") else v1

		if v2 then
			local Character = Players.LocalPlayer.Character
			local v3 = if Character then Character:FindFirstChild("Humanoid") else Character
			local v4 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
			local v5 = if v3 and v4 then v3.HipHeight + v4.Size.Y / 2 else 3

			return v2.CFrame * CFrame.new(0, -v2.Size.Y / 2, 0) + Vector3.new(0, v5, 0)
		end

		local v6 = p1:FindFirstChild("Skydiving") and (p1.Skydiving:FindFirstChild("Airship") and p1.Skydiving.Airship:FindFirstChild("LaunchCollider"))

		if v6 then
			return v6.CFrame + Vector3.new(0, 3, 0)
		end

		return nil
	end,
	get_airship_exit_spawn_cframe = function() --[[ get_airship_exit_spawn_cframe | Line: 133 ]]
		local TeleportLocations = workspace.StaticMap:FindFirstChild("TeleportLocations")
		local v1 = if TeleportLocations then TeleportLocations:FindFirstChild("exterior_airship") else TeleportLocations

		if v1 and v1:IsA("BasePart") then
			return v1.CFrame
		end

		return nil
	end
}

function t.hold_character_at_cframe(p1, p2, p3) --[[ hold_character_at_cframe | Line: 139 | Upvalues: t (copy) ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	local Humanoid = p1:FindFirstChild("Humanoid")

	if not (HumanoidRootPart and (HumanoidRootPart:IsA("BasePart") and Humanoid)) then
		return
	end

	HumanoidRootPart.CFrame = p2
	t.zero_character_velocity(p1)

	local SkydivingExitHoldAttachment = Instance.new("Attachment")

	SkydivingExitHoldAttachment.Name = "SkydivingExitHoldAttachment"
	SkydivingExitHoldAttachment.Parent = HumanoidRootPart

	local AlignPosition = Instance.new("AlignPosition")

	AlignPosition.Mode = Enum.PositionAlignmentMode.OneAttachment
	AlignPosition.Attachment0 = SkydivingExitHoldAttachment
	AlignPosition.Position = p2.Position
	AlignPosition.Responsiveness = 200
	AlignPosition.MaxForce = 1000000
	AlignPosition.Parent = HumanoidRootPart

	local PlatformStand = Humanoid.PlatformStand

	Humanoid.PlatformStand = true

	local sum = 0

	while sum < p3 do
		sum = sum + task.wait()
		t.zero_character_velocity(p1)
	end

	AlignPosition:Destroy()
	SkydivingExitHoldAttachment:Destroy()
	Humanoid.PlatformStand = PlatformStand
	t.zero_character_velocity(p1)
end
function t.teleport_with_hold_transition(p1, p2, p3) --[[ teleport_with_hold_transition | Line: 178 | Upvalues: ReplicatedStorage (copy), SkydivingConstants (copy), t (copy) ]]
	local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)

	if not (p2 and p1) then
		return false
	end

	local EXIT_TELEPORT_FADE_LENGTH = SkydivingConstants.EXIT_TELEPORT_FADE_LENGTH

	UIManager.apps.TransitionsApp:transition({
		start_transparency = 1,
		end_transparency = 0,
		yields = true,
		length = EXIT_TELEPORT_FADE_LENGTH
	})

	if not p3 then
		t.hold_character_at_cframe(p1, p2, SkydivingConstants.EXIT_TELEPORT_HOLD_DURATION)
		UIManager.apps.TransitionsApp:transition({
			start_transparency = 0,
			end_transparency = 1,
			length = EXIT_TELEPORT_FADE_LENGTH
		})

		return true
	end

	p3()
	t.hold_character_at_cframe(p1, p2, SkydivingConstants.EXIT_TELEPORT_HOLD_DURATION)
	UIManager.apps.TransitionsApp:transition({
		start_transparency = 0,
		end_transparency = 1,
		length = EXIT_TELEPORT_FADE_LENGTH
	})

	return true
end
function t.teleport_with_exit_transition(p1, p2) --[[ teleport_with_exit_transition | Line: 213 | Upvalues: t (copy) ]]
	return t.teleport_with_hold_transition(p1, t.get_airship_exit_spawn_cframe(), p2)
end
function t.is_character_inside_part(p1, p2) --[[ is_character_inside_part | Line: 221 ]]
	if not (p1 and p2) then
		return false
	end

	local v1 = OverlapParams.new()

	v1.FilterType = Enum.RaycastFilterType.Include
	v1.FilterDescendantsInstances = { p1 }
	v1.MaxParts = 1

	return #workspace:GetPartsInPart(p2, v1) > 0
end
function t.is_at_collection_circle(p1, p2) --[[ is_at_collection_circle | Line: 234 ]]
	local Size = p1.Size
	local v1 = math.min(Size.X, Size.Y, Size.Z)
	local v2 = p1.CFrame:PointToObjectSpace(p2)
	local v3, v4

	if v1 == Size.X then
		v3 = math.max(Size.Y, Size.Z) / 2
		v4 = Vector2.new(v2.Y, v2.Z).Magnitude
	elseif v1 == Size.Y then
		v3 = math.max(Size.X, Size.Z) / 2
		v4 = Vector2.new(v2.X, v2.Z).Magnitude
	else
		v3 = math.max(Size.X, Size.Y) / 2
		v4 = Vector2.new(v2.X, v2.Y).Magnitude
	end

	return v4 <= v3
end

return t

