-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingCameraController
-- ==========================================

-- https://lua.expert/
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local CameraUtil = require(ReplicatedStorage.ClientModules.Utilities.CameraUtil)
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local Maid = require(SharedModules.Maid)
local Spring = require(SharedModules.Spring)
local Camera = Enum.RenderPriority.Camera.Value

local function lerp_angle(p1, p2, p3) --[[ lerp_angle | Line: 16 ]]
	local sum = (p2 - p1) % 6.283185307179586

	if sum > math.pi then
		sum = sum - 6.283185307179586
	end

	return p1 + sum * p3
end

local t = {}

t.__index = t
function t.new(p1) --[[ new | Line: 27 | Upvalues: SkydivingConstants (copy), Spring (copy), Maid (copy), CameraUtil (copy), t (copy), RunService (copy), Camera (copy) ]]
	local CurrentCamera = workspace.CurrentCamera
	local v1 = p1:get_character_position()
	local v3 = Spring.new(SkydivingConstants.CAMERA_DIVE_SPRING_DAMPING, SkydivingConstants.CAMERA_DIVE_SPRING_FREQUENCY, v1 + Vector3.new(0, SkydivingConstants.CAMERA_DIVE_HEIGHT_OFFSET, 0))
	local v4 = Maid.new()
	local v6 = setmetatable({
		mode = "dive_intro",
		transition_alpha = 0,
		camera = CurrentCamera,
		proxy_controller = p1,
		position_spring = v3,
		_saved_camera_type = CurrentCamera.CameraType,
		_first_person_cleanup = CameraUtil.enter_scriptable_camera(),
		_intro_start_cf = CurrentCamera.CFrame,
		_smooth_angle = p1:get_facing_angle(),
		maid = v4
	}, t)

	RunService:BindToRenderStep("SkydivingCamera", Camera, function(p1) --[[ Line: 54 | Upvalues: v6 (copy) ]]
		v6:_step(p1)
	end)
	v4:GiveTask(function() --[[ Line: 58 | Upvalues: RunService (ref) ]]
		RunService:UnbindFromRenderStep("SkydivingCamera")
	end)

	return v6
end
function t._step(p1, p2) --[[ _step | Line: 65 ]]
	if p1.mode == "dive_intro" then
		p1:_step_dive_intro(p2)

		return
	end

	if p1.mode == "dive" then
		p1:_step_dive(p2)

		return
	end

	if p1.mode == "parachute" then
		p1:_step_parachute(p2)

		return
	end

	if p1.mode ~= "landing" then
		return
	end

	p1:_step_landing(p2)
end
function t._compute_dive_camera(p1, p2) --[[ _compute_dive_camera | Line: 77 | Upvalues: SkydivingConstants (copy) ]]
	local v1 = p1.proxy_controller:get_character_position()
	local v2 = p1.proxy_controller:get_facing_angle()
	local _smooth_angle = p1._smooth_angle
	local v3 = 1 - math.exp(p2 * -8)
	local sum = (v2 - _smooth_angle) % 6.283185307179586

	if sum > math.pi then
		sum = sum - 6.283185307179586
	end

	p1._smooth_angle = _smooth_angle + sum * v3

	local v4 = p1.proxy_controller.get_pencil_dive_blend and p1.proxy_controller:get_pencil_dive_blend() or 0
	local v5 = SkydivingConstants.CAMERA_DIVE_HEIGHT_OFFSET + v4 * SkydivingConstants.CAMERA_PENCIL_DIVE_EXTRA_HEIGHT
	local v9 = Vector3.new(-math.sin(p1._smooth_angle), 0, -math.cos(p1._smooth_angle))

	p1.position_spring:set_goal(v1 + Vector3.new(0, v5, 0) + -v9 * (SkydivingConstants.CAMERA_DIVE_BACK_OFFSET + v4 * SkydivingConstants.CAMERA_PENCIL_DIVE_EXTRA_BACK))

	local v12 = p1.position_spring:update(p2)

	return v12, CFrame.lookAt(v12, v1 + v9 * (v5 * math.tan(SkydivingConstants.CAMERA_DIVE_PITCH * (1 - v4 * SkydivingConstants.CAMERA_PENCIL_DIVE_PITCH_REDUCTION))), v9)
end
function t._step_dive_intro(p1, p2) --[[ _step_dive_intro | Line: 100 | Upvalues: SkydivingConstants (copy) ]]
	p1.transition_alpha = math.min(1, p1.transition_alpha + p2 / SkydivingConstants.CAMERA_DIVE_INTRO_TIME)

	local _, v2 = p1:_compute_dive_camera(p2)

	p1.camera.CFrame = p1._intro_start_cf:Lerp(v2, p1.transition_alpha * p1.transition_alpha * (3 - 2 * p1.transition_alpha))

	if not (p1.transition_alpha >= 1) then
		return
	end

	p1.mode = "dive"
end
function t._step_dive(p1, p2) --[[ _step_dive | Line: 113 ]]
	local _, sum = p1:_compute_dive_camera(p2)
	local v1 = p1.proxy_controller.get_pencil_dive_blend and p1.proxy_controller:get_pencil_dive_blend() or 0

	if v1 > 0.01 then
		local v2 = 0.15 * v1
		local v3 = (math.random() - 0.5) * 2 * v2
		local v4 = (math.random() - 0.5) * 2 * v2

		sum = sum + Vector3.new(v3, v4, (math.random() - 0.5) * 2 * v2)
	end

	p1.camera.CFrame = sum
end
function t._step_parachute(p1, p2) --[[ _step_parachute | Line: 130 | Upvalues: SkydivingConstants (copy) ]]
	p1.transition_alpha = math.min(1, p1.transition_alpha + p2 / SkydivingConstants.CAMERA_PARACHUTE_TRANSITION_TIME)

	local v2 = p1.proxy_controller:get_character_position()
	local v3 = p1.proxy_controller:get_facing_angle()
	local _smooth_angle = p1._smooth_angle
	local v4 = 1 - math.exp(p2 * -8)
	local sum = (v3 - _smooth_angle) % 6.283185307179586

	if sum > math.pi then
		sum = sum - 6.283185307179586
	end

	p1._smooth_angle = _smooth_angle + sum * v4

	local v7 = v2 + Vector3.new(math.sin(p1._smooth_angle), 0, (math.cos(p1._smooth_angle))) * SkydivingConstants.CAMERA_PARACHUTE_BEHIND_DISTANCE
	local v8 = v7 + Vector3.new(0, SkydivingConstants.CAMERA_PARACHUTE_HEIGHT_OFFSET, 0)
	local v11 = Vector3.new(-math.sin(p1._smooth_angle), 0, -math.cos(p1._smooth_angle))

	p1.position_spring:set_goal(((v2 + Vector3.new(0, SkydivingConstants.CAMERA_DIVE_HEIGHT_OFFSET, 0) - v11 * SkydivingConstants.CAMERA_DIVE_BACK_OFFSET):Lerp(v8, p1.transition_alpha)))

	local v13 = p1.position_spring:update(p2)

	p1.camera.CFrame = CFrame.lookAt(v13, v2, (Vector3.new(-math.sin(p1._smooth_angle), 0, -math.cos(p1._smooth_angle)))):Lerp(CFrame.lookAt(v13, v2), p1.transition_alpha)
end
function t._step_landing(p1, p2) --[[ _step_landing | Line: 156 | Upvalues: SkydivingConstants (copy) ]]
	p1.transition_alpha = math.min(1, p1.transition_alpha + p2 / SkydivingConstants.CAMERA_LANDING_TRANSITION_TIME)

	local v2 = p1.proxy_controller:get_character_position()
	local v3 = p1.proxy_controller:get_facing_angle()
	local v6 = v2 + Vector3.new(math.sin(v3), 0, (math.cos(v3))) * SkydivingConstants.CAMERA_PARACHUTE_BEHIND_DISTANCE

	p1.position_spring:set_goal(v6 + Vector3.new(0, SkydivingConstants.CAMERA_PARACHUTE_HEIGHT_OFFSET, 0))
	p1.camera.CFrame = CFrame.lookAt(p1.position_spring:update(p2), v2)

	if not (p1.transition_alpha >= 1) then
		return
	end

	p1.camera.CameraType = p1._saved_camera_type
end
function t.set_mode(p1, p2) --[[ set_mode | Line: 177 ]]
	if p2 ~= p1.mode then
		p1.mode = p2
		p1.transition_alpha = 0
	end
end
function t.destroy(p1) --[[ destroy | Line: 185 ]]
	if p1._first_person_cleanup then
		p1._first_person_cleanup()
		p1._first_person_cleanup = nil
	end

	p1.camera.CameraType = p1._saved_camera_type
	p1.maid:DoCleaning()
end

return t

