-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingProxyController
-- ==========================================

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local SkydivingUtilities = require(script.Parent.SkydivingUtilities)
local RaycastHelper = require(ReplicatedStorage.new.modules.RaycastHelper)
local Maid = require(SharedModules.Maid)
local Signal = require(SharedModules.Signal)
local Spring = require(SharedModules.Spring)
local t = {}

t.__index = t
function t.new(p1, p2, p3, p4, p5) --[[ new | Line: 16 | Upvalues: Spring (copy), SkydivingConstants (copy), SkydivingUtilities (copy), Maid (copy), Signal (copy), t (copy) ]]
	local HumanoidRootPart = p1:FindFirstChild("HumanoidRootPart")
	local Humanoid = p1:FindFirstChild("Humanoid")
	local SkydivingProxy = Instance.new("Part")

	SkydivingProxy.Name = "SkydivingProxy"
	SkydivingProxy.Anchored = true
	SkydivingProxy.CanCollide = false
	SkydivingProxy.CanTouch = false
	SkydivingProxy.CanQuery = false
	SkydivingProxy.Transparency = 1
	SkydivingProxy.Size = Vector3.new(1, 1, 1)
	SkydivingProxy.CFrame = CFrame.new(p2)
	SkydivingProxy.Parent = workspace

	local v1 = Spring.new(SkydivingConstants.CHARACTER_SPRING_DAMPING, SkydivingConstants.CHARACTER_SPRING_FREQUENCY, p2)

	Humanoid.AutoRotate = false
	Humanoid.PlatformStand = true

	local v2 = SkydivingUtilities.create_movement_rig(HumanoidRootPart, {
		responsiveness = 200,
		max_force = 1000000,
		trail_span = 1,
		trail_lifetime = 2.5,
		position = p2
	})
	local v3 = Maid.new()
	local t2 = {
		mode = "freefall",
		_has_landed = false,
		_landing_ray_timer = 0,
		_last_xz_velocity = Vector3.new(0, 0, 0),
		_turn_velocity = 0,
		_parachute_blend = 1,
		_pre_parachute_angle = 0,
		_parachute_turn_offset = 0,
		_pre_parachute_fall_speed = 0,
		_smooth_roll = 0,
		_smooth_pitch_tilt = 0,
		_pencil_dive_blend = 0,
		_lift_energy = 1,
		_parachute_forward_blend = 1,
		_original_auto_rotate = true,
		character = p1,
		hrp = HumanoidRootPart,
		humanoid = Humanoid,
		airship = p5,
		proxy = SkydivingProxy,
		position_spring = v1,
		_movement_rig = v2
	}

	t2.facing_angle = math.atan2(-HumanoidRootPart.CFrame.LookVector.X, -HumanoidRootPart.CFrame.LookVector.Z)
	t2.target_board_altitude = p3
	t2.target_board_center = Vector3.new(p4.X, 0, p4.Z)
	t2.maid = v3
	t2.mode_changed = Signal.new()
	t2.landed = Signal.new()

	local v7 = setmetatable(t2, t)

	v3:GiveTask(SkydivingProxy)
	v3:GiveTask(function() --[[ Line: 88 | Upvalues: SkydivingUtilities (ref), v2 (copy) ]]
		SkydivingUtilities.destroy_movement_rig(v2)
	end)
	v3:GiveTask(v7.mode_changed)
	v3:GiveTask(v7.landed)

	return v7
end

local function is_valid_landing_surface(p1) --[[ is_valid_landing_surface | Line: 97 ]]
	local v1 = p1.Instance

	if not v1.CanCollide then
		return false
	end

	if v1.Transparency >= 1 then
		return false
	end

	local v2 = v1

	while v2 and v2 ~= workspace do
		if v2:IsA("Model") and v2:FindFirstChildOfClass("Humanoid") then
			return false
		end

		v2 = v2.Parent
	end

	return true
end

function t.update(p1, p2, p3, p4) --[[ update | Line: 116 | Upvalues: SkydivingConstants (copy), RaycastHelper (copy), is_valid_landing_surface (copy) ]]
	if p1.mode ~= "parachute" then
		if p4 then
			p1.mode = "pencil_dive"
		else
			p1.mode = "freefall"
		end
	end

	local Position = p1.proxy.Position
	local v1 = SkydivingConstants.MODE_SPEEDS[p1.mode]
	local fall_speed = v1.fall_speed
	local xz_speed = v1.xz_speed
	local v2 = 0
	local v3 = 0
	local v4 = 0

	if p1.mode == "parachute" then
		if p1._parachute_blend < 1 then
			p1._parachute_blend = math.min(1, p1._parachute_blend + p2 / SkydivingConstants.PARACHUTE_TRANSITION_TIME)
		end

		v2 = p1._parachute_blend * p1._parachute_blend * (3 - 2 * p1._parachute_blend)
		p1._parachute_turn_offset = p1._parachute_turn_offset - p3.X * SkydivingConstants.PARACHUTE_TURN_RATE * v2 * p2
		p1.facing_angle = p1._pre_parachute_angle + p1._parachute_turn_offset

		local v6 = math.max(0, p3.Y)
		local v8 = math.max(0, -p3.Y)

		if v8 > 0 then
			p1._lift_energy = math.max(0, p1._lift_energy - SkydivingConstants.PARACHUTE_LIFT_DRAIN_RATE * p2)
		elseif v6 > 0 then
			p1._lift_energy = math.min(1, p1._lift_energy + SkydivingConstants.PARACHUTE_LIFT_FORWARD_RECHARGE_RATE * p2)
		else
			p1._lift_energy = math.min(1, p1._lift_energy + SkydivingConstants.PARACHUTE_LIFT_NEUTRAL_RECHARGE_RATE * p2)
		end

		v3 = v6
		v4 = v8 * p1._lift_energy

		local v12 = 1 + (1 + v6 * (SkydivingConstants.PARACHUTE_PITCH_MAX - 1) - v4 * (1 - SkydivingConstants.PARACHUTE_PITCH_MIN) - 1) * v2
		local v14 = -(p1._pre_parachute_fall_speed + (fall_speed - p1._pre_parachute_fall_speed) * v2) * v12 + SkydivingConstants.PARACHUTE_LIFT_SPEED * v4 * v2

		p1._parachute_forward_blend = p1._parachute_forward_blend + (1 - (v4 + (v8 - v4) * 0.5) - p1._parachute_forward_blend) * (1 - math.exp(-SkydivingConstants.PARACHUTE_TILT_SMOOTHING * p2))

		local v19 = Vector3.new(-math.sin(p1.facing_angle), 0, -math.cos(p1.facing_angle)) * xz_speed * SkydivingConstants.PARACHUTE_FORWARD_MULTIPLIER * p1._parachute_forward_blend * v12 * v2 * p2

		p1.proxy.CFrame = CFrame.new(Position + v19 + Vector3.new(0, v14 * p2, 0)) * CFrame.Angles(0, p1.facing_angle, 0)
	else
		local v22 = Vector3.new(-math.sin(p1.facing_angle), 0, -math.cos(p1.facing_angle))
		local v25 = Vector3.new(-math.cos(p1.facing_angle), 0, (math.sin(p1.facing_angle)))

		if math.abs(p3.X) > 0.01 then
			local v27 = -(if p3.X > 0 then 1 else -1) * SkydivingConstants.DIVE_STEER_RATE

			p1._turn_velocity = p1._turn_velocity + (v27 - p1._turn_velocity) * math.clamp(SkydivingConstants.DIVE_STEER_ACCEL * p2 / SkydivingConstants.DIVE_STEER_RATE, 0, 1)
		else
			p1._turn_velocity = p1._turn_velocity * math.max(0, 1 - SkydivingConstants.DIVE_STEER_ACCEL * p2 / SkydivingConstants.DIVE_STEER_RATE)
		end

		p1.facing_angle = p1.facing_angle + p1._turn_velocity * p2
		p1._last_xz_velocity = p1._last_xz_velocity + (v22 * p3.Y + v25 * -p3.X * SkydivingConstants.DIVE_STRAFE_FRACTION - p1._last_xz_velocity) * (1 - math.exp(-SkydivingConstants.DIVE_XZ_SMOOTHING * p2))
		p1.proxy.CFrame = CFrame.new(Position + (p1._last_xz_velocity * xz_speed * p2 + v22 * SkydivingConstants.DIVE_FORWARD_DRIFT * p2) + Vector3.new(0, -fall_speed * p2, 0))
	end

	local Position2 = p1.proxy.Position

	if p1.mode ~= "parachute" and Position2.Y <= p1.target_board_altitude + SkydivingConstants.PARACHUTE_ALTITUDE_THRESHOLD then
		p1._pre_parachute_angle = p1.facing_angle
		p1._parachute_turn_offset = 0
		p1._pre_parachute_fall_speed = v1.fall_speed
		p1._parachute_blend = 0
		p1.mode = "parachute"
		p1.mode_changed:Fire("parachute")
	end

	p1.position_spring:set_goal(Position2)

	local v36 = p1.position_spring:update(p2)

	if p1.mode == "parachute" then
		local v38 = 1 - math.exp(-SkydivingConstants.PARACHUTE_TILT_SMOOTHING * p2)

		p1._smooth_roll = p1._smooth_roll + (-p3.X * SkydivingConstants.PARACHUTE_ROLL_ANGLE * v2 - p1._smooth_roll) * v38
		p1._smooth_pitch_tilt = p1._smooth_pitch_tilt + (-(v3 - v4) * SkydivingConstants.PARACHUTE_PITCH_ANGLE * v2 - p1._smooth_pitch_tilt) * v38
		p1._movement_rig.align_position.Position = v36
		p1._movement_rig.align_orientation.CFrame = CFrame.Angles(0, p1.facing_angle, 0) * CFrame.Angles(-1.5707963267948966 * (1 - v2) + p1._smooth_pitch_tilt, 0, p1._smooth_roll)
	else
		local v42 = 1 - math.exp(-SkydivingConstants.DIVE_TILT_SMOOTHING * p2)

		p1._smooth_roll = p1._smooth_roll + (-p3.X * SkydivingConstants.DIVE_ROLL_ANGLE - p1._smooth_roll) * v42
		p1._pencil_dive_blend = p1._pencil_dive_blend + ((if p4 then 1 else 0) - p1._pencil_dive_blend) * (1 - math.exp(-SkydivingConstants.PENCIL_DIVE_TRANSITION_SPEED * p2))

		local v48 = -p1._pencil_dive_blend * SkydivingConstants.PENCIL_DIVE_EXTRA_PITCH

		p1._smooth_pitch_tilt = p1._smooth_pitch_tilt + (-p3.Y * SkydivingConstants.DIVE_PITCH_ANGLE - p1._smooth_pitch_tilt) * v42
		p1._movement_rig.align_position.Position = v36
		p1._movement_rig.align_orientation.CFrame = CFrame.Angles(0, p1.facing_angle, 0) * CFrame.Angles(-1.5707963267948966 + p1._smooth_pitch_tilt + v48, 0, p1._smooth_roll)
	end

	if p1._has_landed then
		return
	end

	if Position2.Y <= p1.target_board_altitude - 50 then
		p1._has_landed = true
		p1.landed:Fire(Position2, nil)

		return
	end

	p1._landing_ray_timer = p1._landing_ray_timer + p2

	if not (p1._landing_ray_timer >= 0.15) then
		return
	end

	p1._landing_ray_timer = 0

	local v49 = p1.character:FindFirstChild("RightFoot") or p1.character:FindFirstChild("Right Leg")
	local v50 = v49 and v49.CFrame or CFrame.new(v36)
	local v54 = RaycastHelper.cast_ray({
		origin = v50.Position - v50.UpVector * (v49 and v49.Size.Y / 2 or 0),
		direction = -v50.UpVector * 2,
		filter_type = Enum.RaycastFilterType.Exclude,
		instances = { p1.proxy, p1.character, p1.airship },
		callback = is_valid_landing_surface
	})

	if not v54 then
		return
	end

	p1._has_landed = true
	p1.landed:Fire(v54.Position, v54.Instance)
end
function t.get_position(p1) --[[ get_position | Line: 275 ]]
	return p1.proxy.Position
end
function t.get_character_position(p1) --[[ get_character_position | Line: 279 ]]
	return p1.position_spring:get_position()
end
function t.get_mode(p1) --[[ get_mode | Line: 283 ]]
	return p1.mode
end
function t.get_facing_angle(p1) --[[ get_facing_angle | Line: 287 ]]
	return p1.facing_angle
end
function t.get_pencil_dive_blend(p1) --[[ get_pencil_dive_blend | Line: 291 ]]
	return p1._pencil_dive_blend
end
function t.destroy(p1) --[[ destroy | Line: 295 | Upvalues: SkydivingUtilities (copy) ]]
	p1.maid:DoCleaning()

	if p1.hrp and p1.hrp.Parent then
		SkydivingUtilities.zero_character_velocity(p1.character)
	end

	p1.humanoid.PlatformStand = false
	p1.humanoid.AutoRotate = p1._original_auto_rotate
end

return t

