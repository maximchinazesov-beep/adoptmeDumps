-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingClient
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local SharedModules = ReplicatedStorage.SharedModules
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local SkydivingNetService = require(script.Parent.SkydivingNetService)
local SkydivingProxyController = require(script.Parent.SkydivingProxyController)
local SkydivingInputController = require(script.Parent.SkydivingInputController)
local SkydivingCameraController = require(script.Parent.SkydivingCameraController)
local SkydivingCompanionController = require(script.Parent.SkydivingCompanionController)
local SkydivingRingRenderer = require(script.Parent.SkydivingRingRenderer)
local SkydivingParachuteHelper = require(script.Parent.SkydivingParachuteHelper)
local SkydivingUtilities = require(script.Parent.SkydivingUtilities)
local AnimationManager = require(ReplicatedStorage.ClientDB.AnimationManager)
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local ControlsDisabler = require(ReplicatedStorage.ClientModules.Game.ControlsDisabler)
local MinigameForcedState = require(ReplicatedStorage.ClientModules.Game.MinigameHelpers.MinigameForcedState)

require(ReplicatedStorage.ClientModules.Utilities.PlatformM)

local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
local GameplayFX = require(SharedModules.GameplayFX)
local Music = require(ReplicatedStorage.ClientModules.Core.Music)
local SoundDB = require(ReplicatedStorage.ClientDB.SoundDB)
local SoundPlayer = require(SharedModules.SoundPlayer)
local Maid = require(SharedModules.Maid)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local ContentProvider = game:GetService("ContentProvider")
local Resources = ReplicatedStorage:WaitForChild("Resources")
local SpawnPoof = Resources.IceSkating.SpawnPoof
local SkydivingConfettiBlast = Resources.Skydiving.SkydivingConfettiBlast
local v1 = AnimationManager.get_track("IceSkatingJump")
local v2 = Enum.RenderPriority.Input.Value + 1

local function restore_minigame_character_stats() --[[ restore_minigame_character_stats | Line: 52 | Upvalues: MinigameForcedState (copy) ]]
	MinigameForcedState.update_gravity()
	MinigameForcedState.update_walk_speed()
end

local t = {
	freefall = "SkydivingFreefall",
	pencil_dive = "SkydivingPencilDive",
	parachute = "SkydivingParachuting"
}

local function get_flat_launch_forward(p1) --[[ get_flat_launch_forward | Line: 69 ]]
	local LookVector = p1.LookVector
	local v1 = Vector3.new(LookVector.X, 0, LookVector.Z)

	if v1.Magnitude < 0.01 then
		return Vector3.new(0, 0, -1)
	end

	return v1.Unit
end

local function compute_launch_impulse(p1, p2) --[[ compute_launch_impulse | Line: 80 | Upvalues: SkydivingConstants (copy) ]]
	local cframe = p1.cframe
	local LookVector = cframe.LookVector
	local v1 = Vector3.new(LookVector.X, 0, LookVector.Z)
	local v2 = if v1.Magnitude < 0.01 then Vector3.new(0, 0, -1) else v1.Unit
	local Position = cframe.Position
	local v5 = Vector3.new(p1.touch_position.X - Position.X, 0, p1.touch_position.Z - Position.Z):Dot(v2)
	local v7 = math.abs((cframe.RightVector:Dot(v2))) * p1.half_size.X
	local v10 = math.max(v7 + math.abs((cframe.LookVector:Dot(v2))) * p1.half_size.Z, 0.1)
	local v13 = v2 * SkydivingConstants.LAUNCH_FORWARD_IMPULSE * (1 + math.clamp(math.max(0, -v5) / v10, 0, 1) * SkydivingConstants.LAUNCH_DEPTH_FORWARD_BOOST)

	return (v13 + Vector3.new(0, SkydivingConstants.LAUNCH_VERTICAL_IMPULSE, 0)) * p2 * 35
end

local t2 = {}

t2.__index = t2
function t2.new(p1, p2, p3) --[[ new | Line: 111 | Upvalues: Maid (copy), Players (copy), t2 (copy) ]]
	return setmetatable({
		proxy_controller = nil,
		input_controller = nil,
		camera_controller = nil,
		companion_controller = nil,
		ring_renderer = nil,
		_time_trial_teleport_back = false,
		_should_teleport_to_exit = false,
		_time_trial_failed = false,
		_ended = false,
		_destroying = false,
		_end_dive_sent = false,
		_anim_tracks = nil,
		_current_anim_mode = nil,
		_target_board_parts = nil,
		_target_board_animating = false,
		player = Players.LocalPlayer,
		_flag_renderer = p2,
		_is_time_trial = p3 or false,
		_on_ended = p1,
		maid = Maid.new()
	}, t2)
end
function t2._fail_time_trial(p1) --[[ _fail_time_trial | Line: 140 | Upvalues: UIManager (copy), SkydivingConstants (copy) ]]
	if not p1._time_trial_failed then
		p1._time_trial_failed = true
		p1._time_trial_teleport_back = true
		UIManager.apps.HintApp:hint({
			text = "You missed a ring! Time Trial failed!",
			overridable = true,
			length = 3,
			yields = false
		})
		task.delay(SkydivingConstants.TIME_TRIAL_ABORT_DELAY, function() --[[ Line: 148 | Upvalues: p1 (copy) ]]
			if p1._ended then
				return
			end

			if p1._end_dive_sent then
				p1:destroy()

				return
			end

			p1:end_dive(if p1.proxy_controller then p1.proxy_controller:get_position() else Vector3.new(0, 0, 0), false)
		end)
	end
end
function t2._fire_ended(p1, p2) --[[ _fire_ended | Line: 161 ]]
	if p1._ended then
		return
	end

	p1._ended = true

	if not p1._on_ended then
		return
	end

	p1._on_ended(p2)
end
function t2._on_attempt_exit(p1) --[[ _on_attempt_exit | Line: 171 | Upvalues: UIManager (copy) ]]
	if p1._ended then
		return
	end

	if UIManager.apps.DialogApp:dialog({
		text = "Are you sure you want to exit?",
		left = "No",
		right = "Yes"
	}) == "Yes" and not p1._ended then
		p1._should_teleport_to_exit = true
		p1:destroy()
	end
end
function t2.start_dive(p1, p2, p3) --[[ start_dive | Line: 190 | Upvalues: ControlsDisabler (copy), UIManager (copy), SkydivingNetService (copy), SkydivingCameraController (copy), ContentProvider (copy), v1 (copy), Maid (copy), RunService (copy), MinigameForcedState (copy), compute_launch_impulse (copy), SkydivingConstants (copy), SoundPlayer (copy), SkydivingInputController (copy), SkydivingProxyController (copy), SkydivingCompanionController (copy), ClientData (copy), SkydivingRingRenderer (copy), Promise (copy), UserInputService (copy), SkydivingParachuteHelper (copy), GameplayFX (copy), SpawnPoof (copy), Music (copy), v2 (copy), SoundDB (copy) ]]
	local Character = p1.player.Character
	local v12 = Character and Character:FindFirstChild("HumanoidRootPart")

	if not v12 then
		p1:_fire_ended()

		return
	end

	p1._interior = p2

	local TargetBoard = p2.Skydiving.TargetBoard
	local Position = TargetBoard:GetPivot().Position
	local Visual = TargetBoard:FindFirstChild("Visual")

	if Visual then
		p1._target_board_parts = {}

		for i = 1, 4 do
			local v22 = Visual:FindFirstChild((tostring(i)))

			if v22 then
				table.insert(p1._target_board_parts, v22)
			end
		end
	end

	p1._target_board_center = Position
	ControlsDisabler.disable_controls("Skydiving")
	p1.maid:GiveTask(function() --[[ Line: 220 | Upvalues: UIManager (ref) ]]
		UIManager.set_app_visibility("MinigameInGameApp", false)
	end)
	UIManager.apps.MinigameInGameApp:display({
		title = "Skydiving",
		hide_body = true,
		exit_title = "Exit Minigame",
		exit_callback = function() --[[ exit_callback | Line: 227 | Upvalues: p1 (copy) ]]
			p1:_on_attempt_exit()
		end
	})
	SkydivingNetService.StartDive:fire_server({})

	local Humanoid = Character:FindFirstChild("Humanoid")

	if Humanoid then
		p1.maid:GiveTask(Humanoid.Died:Connect(function() --[[ Line: 236 | Upvalues: p1 (copy) ]]
			p1:destroy()
		end))
	end

	p1.maid:GiveTask(p1.player.CharacterRemoving:Connect(function() --[[ Line: 241 | Upvalues: p1 (copy) ]]
		p1:destroy()
	end))

	if p3 then
		v12.CFrame = CFrame.new(v12.Position) * (p3.cframe - p3.cframe.Position)
	end

	local v4 = -v12.CFrame.LookVector.X
	local v5 = -v12.CFrame.LookVector.Z
	local v6 = math.atan2(v4, v5)
	local t = {
		get_character_position = function() --[[ get_character_position | Line: 251 | Upvalues: v12 (ref) ]]
			return v12.Position
		end,
		get_facing_angle = function() --[[ get_facing_angle | Line: 254 | Upvalues: v6 (copy) ]]
			return v6
		end
	}

	p1.camera_controller = SkydivingCameraController.new(t)
	ContentProvider:PreloadAsync({ v1 })

	local v7 = Humanoid:LoadAnimation(v1)
	local v8 = Maid.new()

	p1.maid:GiveTask(v8)

	local WalkSpeed = Humanoid.WalkSpeed
	local AutoRotate = Humanoid.AutoRotate

	Humanoid.WalkSpeed = 0
	Humanoid.AutoRotate = false
	v8:GiveTask(function() --[[ Line: 271 | Upvalues: Humanoid (copy), WalkSpeed (copy), AutoRotate (copy) ]]
		if not Humanoid.Parent then
			return
		end

		Humanoid.WalkSpeed = WalkSpeed
		Humanoid.AutoRotate = AutoRotate
	end)
	v8:GiveTask(RunService.RenderStepped:Connect(function() --[[ Line: 277 | Upvalues: Humanoid (copy) ]]
		if not Humanoid.Parent then
			return
		end

		Humanoid:Move(Vector3.new(0, 0, 0))
	end))
	MinigameForcedState.enable({
		disable_interactions = true,
		disable_interactions_with_me = true,
		can_receive_invites = false,
		can_use_potions = false,
		can_enter_doors = false,
		disable_pet_mounting = true,
		forced_equips = MinigameForcedState.get_forced_equips_by_category("pets"),
		app_visibility = {
			type = "include",
			app_names = { "DialogApp", "HintApp", "SpeechBubbleApp", "PlayerNameApp", "MinigameInGameApp", "TesterWatermarkApp", "AdminAbuseApp", "MinigameHotbarApp" }
		}
	})

	if Humanoid:GetState() == Enum.HumanoidStateType.Seated then
		Humanoid.StateChanged:Wait()
		task.wait(0.25)
	end

	task.spawn(function() --[[ Line: 313 | Upvalues: p1 (copy), v12 (ref), Humanoid (copy), p3 (copy), compute_launch_impulse (ref), SkydivingConstants (ref), SoundPlayer (ref) ]]
		if p1._ended or not v12.Parent then
			return
		end

		Humanoid:SetStateEnabled(Enum.HumanoidStateType.Jumping, true)
		v12.AssemblyLinearVelocity = Vector3.new(0, v12.AssemblyLinearVelocity.Y, 0)

		local LookVector = v12.CFrame.LookVector

		Humanoid.Jump = true

		local AssemblyMass = v12.AssemblyMass

		if p3 then
			v12:ApplyImpulse((compute_launch_impulse(p3, AssemblyMass)))
		else
			v12:ApplyImpulse(Vector3.new(LookVector.X * SkydivingConstants.LAUNCH_FORWARD_IMPULSE, SkydivingConstants.LAUNCH_VERTICAL_IMPULSE, LookVector.Z * SkydivingConstants.LAUNCH_FORWARD_IMPULSE) * AssemblyMass * 35)
		end

		SoundPlayer.FX:play("SkydivingJump")
	end)
	v7:Play()
	v7.TimePosition = 0.25
	task.delay(0.7, function() --[[ Line: 331 | Upvalues: v7 (copy) ]]
		v7:Stop(0.3)
	end)
	task.delay(1.3, function() --[[ Line: 334 | Upvalues: v7 (copy) ]]
		v7:Destroy()
	end)
	task.wait(1)
	v8:DoCleaning()

	if p1._ended then
		MinigameForcedState.disable()
		MinigameForcedState.update_gravity()
		MinigameForcedState.update_walk_speed()
		ControlsDisabler.enable_controls("Skydiving")

		return
	end

	local Character2 = p1.player.Character

	v12 = if Character2 then Character2:FindFirstChild("HumanoidRootPart") else Character2

	if not v12 then
		p1:destroy()

		return
	end

	local Position2 = v12.Position

	p1.input_controller = SkydivingInputController.new()
	p1.proxy_controller = SkydivingProxyController.new(Character2, Position2, Position.Y, Position, p2.Skydiving.Airship)
	p1.camera_controller.proxy_controller = p1.proxy_controller
	p1:_setup_animations(Humanoid)
	p1.companion_controller = SkydivingCompanionController.new(Position2, p1.proxy_controller:get_facing_angle())

	local v10 = ClientData.get("skydiving_manager")

	if v10 and v10.rings then
		p1.ring_renderer = SkydivingRingRenderer.new(v10.rings, p1._is_time_trial, Position2.Y)
		p1.maid:GiveTask(p1.ring_renderer.ring_collected:Connect(function(p1) --[[ Line: 377 | Upvalues: SoundPlayer (ref), SkydivingNetService (ref) ]]
			SoundPlayer.FX:play("SkydivingRing")
			SkydivingNetService.ClaimRings:fire_server({
				ring_ids = { p1 }
			})
		end))

		if p1._is_time_trial then
			p1.maid:GiveTask(p1.ring_renderer.ring_missed:Connect(function(p12) --[[ Line: 383 | Upvalues: p1 (copy) ]]
				p1:_fail_time_trial()
			end))
			p1._unreachable_ring_ids = p1.ring_renderer:get_unreachable_ring_ids()

			if #p1._unreachable_ring_ids > 0 then
				warn(string.format("[Skydiving] %d time-trial ring(s) are above the dive start and unreachable; excluding from completion", #p1._unreachable_ring_ids))
			end
		end
	end

	p1.maid:GiveTask(SkydivingNetService.ClaimRingsResult:on_client_event(function(p12) --[[ Line: 402 | Upvalues: p1 (copy) ]]
		if not p1.ring_renderer then
			return
		end

		for v1, v2 in p12.results do
			if v2.accepted then
				p1.ring_renderer:confirm_ring(v2.ring_id)

				continue
			end

			p1.ring_renderer:rollback_ring(v2.ring_id)

			if p1._is_time_trial then
				p1:_fail_time_trial()
			end
		end
	end))
	UIManager.apps.MinigameHotbarApp:on_minigame_start({
		dive = {
			layout_order = 1,
			visible = true,
			image = "rbxassetid://120073157089186",
			world_tap_enabled = false,
			inner_color = Color3.fromRGB(56, 168, 255),
			get_can_use = function() --[[ get_can_use | Line: 425 | Upvalues: p1 (copy) ]]
				return not p1._ended
			end,
			get_use_promise = function() --[[ get_use_promise | Line: 428 | Upvalues: p1 (copy), Promise (ref), UserInputService (ref) ]]
				p1.input_controller:set_pencil_diving(true)

				return Promise.new(function(p1, p2, p3) --[[ Line: 430 | Upvalues: UserInputService (ref) ]]
					local v1 = nil

					v1 = UserInputService.InputEnded:Connect(function(p12) --[[ Line: 432 | Upvalues: v1 (ref), p1 (copy) ]]
						if p12.UserInputType ~= Enum.UserInputType.MouseButton1 and p12.UserInputType ~= Enum.UserInputType.Touch then
							return
						end

						v1:Disconnect()
						p1()
					end)
					p3(function() --[[ Line: 439 | Upvalues: v1 (ref) ]]
						v1:Disconnect()
					end)
				end):finally(function() --[[ Line: 442 | Upvalues: p1 (ref) ]]
					if not p1.input_controller then
						return
					end

					p1.input_controller:set_pencil_diving(false)
				end)
			end,
			get_cooldown = function() --[[ get_cooldown | Line: 448 ]]
				return 0.01
			end
		}
	})
	p1.maid:GiveTask(function() --[[ Line: 451 | Upvalues: UIManager (ref) ]]
		UIManager.apps.MinigameHotbarApp:on_minigame_end()
	end)
	p1.maid:GiveTask(p1.proxy_controller.mode_changed:Connect(function(p12) --[[ Line: 455 | Upvalues: p1 (copy), UIManager (ref), SkydivingParachuteHelper (ref), SkydivingConstants (ref), GameplayFX (ref), SpawnPoof (ref), SoundPlayer (ref), SkydivingNetService (ref), Music (ref) ]]
		p1.camera_controller:set_mode(p12)

		if p1._flag_renderer then
			p1._flag_renderer:set_parachute_fade(p12 == "parachute")
		end

		if p12 ~= "parachute" then
			return
		end

		UIManager.apps.MinigameHotbarApp:on_minigame_end()
		p1:_start_target_board_animation()

		local Character = p1.player.Character
		local v2 = if Character then Character:FindFirstChild(SkydivingParachuteHelper.MODEL_NAME) else Character

		if v2 then
			SkydivingParachuteHelper.show(v2)
			SkydivingParachuteHelper.apply_local_transparency(v2, SkydivingConstants.PARACHUTE_LOCAL_TRANSPARENCY_MODIFIER)
			GameplayFX.emit_particle_group(SpawnPoof, v2:GetPivot().Position)
			SoundPlayer.FX:play("SkydivingParachute")
		end

		SkydivingNetService.SetParachute:fire_server({
			open = true
		})
		Music.duck_volume("Summer2026Skydiving", 0, 3)
	end))
	p1.maid:GiveTask(p1.proxy_controller.landed:Connect(function(p12, p2) --[[ Line: 479 | Upvalues: p1 (copy), TargetBoard (copy) ]]
		if p2 then
			p1:end_dive(p12, (p2:IsDescendantOf(TargetBoard)))
		else
			p1:destroy()
		end
	end))
	RunService:BindToRenderStep("SkydivingClient", v2, function(p12) --[[ Line: 489 | Upvalues: p1 (copy) ]]
		p1:_step(p12)
	end)
	p1.maid:GiveTask(function() --[[ Line: 493 | Upvalues: RunService (ref) ]]
		RunService:UnbindFromRenderStep("SkydivingClient")
	end)

	if SoundDB.Summer2026Skydiving then
		Music.play(100, SoundDB.Summer2026Skydiving)
	end

	p1._wind_loop = SoundPlayer.FX:loop("SkydivingWindLoop", v12)
	p1._rustle_loop = SoundPlayer.FX:loop("SkydivingRustleLoop", v12)
	p1._pencil_dive_wind_loop = SoundPlayer.FX:loop("SkydivingPencilWindLoop", v12)

	if p1._rustle_loop then
		p1._rustle_loop_max_volume = p1._rustle_loop.Volume
	end

	if not p1._pencil_dive_wind_loop then
		return
	end

	p1._pencil_dive_wind_loop_max_volume = p1._pencil_dive_wind_loop.Volume
	p1._pencil_dive_wind_loop.Volume = 0
end
function t2._setup_animations(p1, p2) --[[ _setup_animations | Line: 512 | Upvalues: t (copy), AnimationManager (copy) ]]
	local t2 = {}

	for v1, v2 in t do
		local v3 = p2:LoadAnimation((AnimationManager.get_track(v2)))

		v3.Looped = true
		t2[v1] = v3
	end

	p1._anim_tracks = t2
	p1:_set_anim_mode("freefall", 0)
end
function t2._start_target_board_animation(p1) --[[ _start_target_board_animation | Line: 524 ]]
	if not p1._target_board_animating and p1._target_board_parts then
		p1._target_board_animating = true
		task.spawn(function() --[[ Line: 530 | Upvalues: p1 (copy) ]]
			local _target_board_parts = p1._target_board_parts
			local v1 = 0

			while p1._target_board_animating do
				v1 = v1 % #_target_board_parts + 1

				for v2, v3 in _target_board_parts do
					v3.Material = if v2 == v1 then Enum.Material.Neon else Enum.Material.Plastic
				end

				task.wait(0.5)
			end
		end)
	end
end
function t2._stop_target_board_animation(p1) --[[ _stop_target_board_animation | Line: 543 ]]
	p1._target_board_animating = false

	if not p1._target_board_parts then
		return
	end

	for v1, v2 in p1._target_board_parts do
		v2.Material = Enum.Material.Plastic
	end
end
function t2._set_anim_mode(p1, p2, p3) --[[ _set_anim_mode | Line: 552 ]]
	if p2 == p1._current_anim_mode then
		return
	end

	if p1._current_anim_mode and p1._anim_tracks[p1._current_anim_mode] then
		p1._anim_tracks[p1._current_anim_mode]:Stop(p3)
	end

	p1._current_anim_mode = p2

	if not p1._anim_tracks[p2] then
		return
	end

	p1._anim_tracks[p2]:Play(p3)
end
function t2._step(p1, p2) --[[ _step | Line: 568 | Upvalues: SkydivingParachuteHelper (copy) ]]
	if not p1.proxy_controller then
		return
	end

	local v1 = p1.input_controller:get_move_vector()
	local v2 = p1.input_controller:get_is_pencil_diving()

	p1.proxy_controller:update(p2, v1, v2)

	local v3 = p1.proxy_controller:get_mode()

	if v3 == "parachute" then
		p1:_set_anim_mode("parachute", 0.5)
	elseif v2 then
		p1:_set_anim_mode("pencil_dive", 0.2)
	else
		p1:_set_anim_mode("freefall", 0.2)
	end

	local v4 = if v3 == "parachute" then 0 elseif v2 then 0 else 1
	local v5 = if v3 == "parachute" then 0 elseif v2 then 1 else 0
	local v6 = p2 * 5

	if p1._rustle_loop then
		local _rustle_loop_max_volume = p1._rustle_loop_max_volume

		p1._rustle_loop.Volume = math.clamp(p1._rustle_loop.Volume + (v4 * _rustle_loop_max_volume - p1._rustle_loop.Volume) * math.min(v6, 1), 0, _rustle_loop_max_volume)
	end

	if p1._pencil_dive_wind_loop then
		local _pencil_dive_wind_loop_max_volume = p1._pencil_dive_wind_loop_max_volume

		p1._pencil_dive_wind_loop.Volume = math.clamp(p1._pencil_dive_wind_loop.Volume + (v5 * _pencil_dive_wind_loop_max_volume - p1._pencil_dive_wind_loop.Volume) * math.min(v6, 1), 0, _pencil_dive_wind_loop_max_volume)
	end

	if p1.companion_controller then
		p1.companion_controller:update(p1.proxy_controller:get_character_position(), p1.proxy_controller:get_facing_angle())
	end

	if p1.ring_renderer then
		p1.ring_renderer:update_next_ring(p1.proxy_controller:get_position())
	end

	SkydivingParachuteHelper.update_other_parachutes_local_transparency(p1.player)
end
function t2._teardown(p1) --[[ _teardown | Line: 619 | Upvalues: MinigameForcedState (copy), ControlsDisabler (copy) ]]
	p1:_stop_target_board_animation()

	if p1._flag_renderer then
		p1._flag_renderer:set_parachute_fade(false)
	end

	if p1.companion_controller then
		p1.companion_controller:destroy()
		p1.companion_controller = nil
	end

	p1:_cleanup_controllers()
	MinigameForcedState.disable()
	MinigameForcedState.update_gravity()
	MinigameForcedState.update_walk_speed()
	ControlsDisabler.enable_controls("Skydiving")
end
function t2._teleport_to_airship(p1) --[[ _teleport_to_airship | Line: 634 | Upvalues: SkydivingUtilities (copy) ]]
	if not p1._interior then
		return false
	end

	local v1 = SkydivingUtilities.get_airship_interior_spawn_cframe(p1._interior)

	if v1 then
		return SkydivingUtilities.teleport_with_hold_transition(p1.player.Character, v1, function() --[[ Line: 642 | Upvalues: p1 (copy) ]]
			p1:_teardown()
		end)
	end

	return false
end
function t2._teleport_to_exit(p1) --[[ _teleport_to_exit | Line: 647 | Upvalues: SkydivingUtilities (copy) ]]
	return SkydivingUtilities.teleport_with_exit_transition(p1.player.Character, function() --[[ Line: 648 | Upvalues: p1 (copy) ]]
		p1:_teardown()
	end)
end
function t2._finalize_destroy(p1, p2) --[[ _finalize_destroy | Line: 653 ]]
	p1:_teardown()
	p1:_fire_ended(p2)
end
function t2.end_dive(p1, p2, p3) --[[ end_dive | Line: 658 | Upvalues: UIManager (copy), SkydivingNetService (copy), SkydivingConstants (copy), GameplayFX (copy), SkydivingConfettiBlast (copy), SoundPlayer (copy) ]]
	if p1._ended then
		return
	end

	if p1._is_time_trial and not p3 then
		p1._time_trial_teleport_back = true

		if not p1._time_trial_failed then
			p1._time_trial_failed = true
			UIManager.apps.HintApp:hint({
				text = "You missed a ring! Time Trial failed!",
				overridable = true,
				length = 3,
				yields = false
			})
		end
	end

	p1._end_dive_sent = true

	local t = {
		landing_position = p2
	}

	t.landed_on_target = p3 == true
	t.unreachable_ring_ids = p1._unreachable_ring_ids or {}
	SkydivingNetService.EndDive:fire_server(t)

	if p3 and p1._target_board_center then
		local _target_board_center = p1._target_board_center

		if (Vector3.new(p2.X, _target_board_center.Y, p2.Z) - _target_board_center).Magnitude <= SkydivingConstants.TARGET_OUTER_RADIUS * SkydivingConstants.TARGET_BULLSEYE_RADIUS_FRACTION then
			GameplayFX.emit_particle_group(SkydivingConfettiBlast, p2)
			SoundPlayer.FX:play("SkydivingLandBullseye")
		else
			SoundPlayer.FX:play("SkydivingLandTarget")
		end
	else
		SoundPlayer.FX:play("SkydivingLandMiss")
	end

	if p1.companion_controller then
		p1.companion_controller:destroy(true)
		p1.companion_controller = nil
	end

	if p1.camera_controller then
		p1.camera_controller:set_mode("landing")
	end

	task.delay(SkydivingConstants.CAMERA_LANDING_TRANSITION_TIME, function() --[[ Line: 704 | Upvalues: p1 (copy) ]]
		p1:destroy()
	end)
end
function t2.destroy(p1) --[[ destroy | Line: 709 | Upvalues: SkydivingNetService (copy), t2 (copy) ]]
	if p1._ended or p1._destroying then
		return
	end

	p1._destroying = true

	local _end_dive_sent = p1._end_dive_sent

	if not p1._end_dive_sent then
		p1._end_dive_sent = true

		local t = {
			landed_on_target = false,
			landing_position = if p1.proxy_controller then p1.proxy_controller:get_position() else Vector3.new(0, 0, 0)
		}

		t.unreachable_ring_ids = p1._unreachable_ring_ids or {}
		SkydivingNetService.EndDive:fire_server(t)
	end

	local v4 = if p1._should_teleport_to_exit then t2._teleport_to_exit elseif p1._is_time_trial and (p1._time_trial_teleport_back or not _end_dive_sent) then t2._teleport_to_airship else nil

	if v4 then
		task.spawn(function() --[[ Line: 734 | Upvalues: v4 (copy), p1 (copy) ]]
			if v4(p1) then
				p1:_fire_ended({
					teleported_back = true
				})
			else
				p1:_finalize_destroy({
					teleported_back = false
				})
			end
		end)
	else
		p1:_finalize_destroy({})
	end
end
function t2._cleanup_controllers(p1) --[[ _cleanup_controllers | Line: 747 | Upvalues: SkydivingParachuteHelper (copy), Music (copy), SoundDB (copy) ]]
	SkydivingParachuteHelper.clear_all_other_parachutes_local_transparency(p1.player)
	p1.maid:DoCleaning()

	if p1._anim_tracks then
		for v1, v2 in p1._anim_tracks do
			v2:Stop(0)
			v2:Destroy()
		end

		p1._anim_tracks = nil
		p1._current_anim_mode = nil
	end

	Music.unduck_volume("Summer2026Skydiving", 0)

	if SoundDB.Summer2026Skydiving then
		Music.stop(100, SoundDB.Summer2026Skydiving)
	end

	if p1._wind_loop then
		p1._wind_loop:Stop()
		p1._wind_loop = nil
	end

	if p1._rustle_loop then
		p1._rustle_loop:Stop()
		p1._rustle_loop = nil
	end

	if p1._pencil_dive_wind_loop then
		p1._pencil_dive_wind_loop:Stop()
		p1._pencil_dive_wind_loop = nil
	end

	if p1.input_controller then
		p1.input_controller:destroy()
		p1.input_controller = nil
	end

	if p1.camera_controller then
		p1.camera_controller:destroy()
		p1.camera_controller = nil
	end

	if p1.companion_controller then
		p1.companion_controller:destroy()
		p1.companion_controller = nil
	end

	if p1.proxy_controller then
		p1.proxy_controller:destroy()
		p1.proxy_controller = nil
	end

	if not p1.ring_renderer then
		return
	end

	p1.ring_renderer:destroy()
	p1.ring_renderer = nil
end

return t2

