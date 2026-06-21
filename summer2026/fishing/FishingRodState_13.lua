-- https://lua.expert/
local ClientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local CloudValues = require(game.ReplicatedStorage.ClientModules.CloudValues)
local ControlsDisabler = require(game.ReplicatedStorage.ClientModules.Game.ControlsDisabler)
local FishingAnims = require(script.Parent.FishingAnims)
local FishingCostColorDB = require(script.Parent.DB.FishingCostColorDB)
local FishBiteTimerClient = require(script.Parent.FishBiteTimerClient)
local FishingNetService = require(script.Parent.FishingNetService)
local FishingReactionTime = require(script.Parent.FishingReactionTime)
local GameplayFX = require(game.ReplicatedStorage.SharedModules.GameplayFX)
local InteractionsEngine = require(game.ReplicatedStorage.ClientModules.Core.InteractionsEngine.InteractionsEngine)
local KindDB = require(game.ReplicatedStorage.ClientDB.Inventory.KindDB)
local Maid = require(game.ReplicatedStorage.SharedModules.Maid)
local PlatformM = require(game.ReplicatedStorage.ClientModules.Utilities.PlatformM)
local Promise = require(game.ReplicatedStorage.SharedPackages.Promise)
local RaycastHelper = require(game.ReplicatedStorage.new.modules.RaycastHelper)
local SoundPlayer = require(game.ReplicatedStorage.SharedModules.SoundPlayer)
local Spring = require(game.ReplicatedStorage.SharedModules.Spring)
local StateMachinePromise = require(game.ReplicatedStorage.new.modules.StateMachinePromise)
local TweenPromise = require(game.ReplicatedStorage.SharedModules.TweenPromise)
local UIManager = require(game.ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
local Players = game:GetService("Players")
local Debris = game:GetService("Debris")
local RunService = game:GetService("RunService")
local Fishing = game.ReplicatedStorage.Resources.Fishing
local t = {
	damping = 0.72,
	frequency = 2.8,
	pull_velocity = 28,
	settle_distance = 0.08,
	max_duration = 1.25
}
local t2 = {
	damping = 1,
	frequency = 4,
	pull_velocity = 22,
	settle_distance = 0.06,
	max_duration = 0.75
}

local function finish_bobber_at_spawn(p1, p2) --[[ finish_bobber_at_spawn | Line: 96 ]]
	p1:PivotTo(p2.BobberSpawn.CFrame)
	p1.PrimaryPart.Anchored = false
	p1.PrimaryPart.RodWeldConstraint.Enabled = true
end

local function play_fish_caught_celebration(p1, p2) --[[ play_fish_caught_celebration | Line: 102 | Upvalues: Players (copy), Promise (copy), Maid (copy), FishingAnims (copy), TweenPromise (copy), KindDB (copy), FishingCostColorDB (copy), GameplayFX (copy), SoundPlayer (copy) ]]
	local Character = Players.LocalPlayer.Character

	if not (Character and (if Character then Character:FindFirstChild("HumanoidRootPart") else Character)) then
		return Promise.resolve()
	end

	local v2 = game.ReplicatedStorage.Resources.Fishing.Fish:FindFirstChild(p1)

	if not v2 then
		return Promise.resolve()
	end

	local v3 = Maid.new()
	local v4 = v2:Clone()

	v3:GiveTask(v4)
	v4.Parent = workspace

	for v5, v6 in v4:GetDescendants() do
		if v6:IsA("BasePart") then
			v6.Anchored = true
			v6.CanCollide = false
		end
	end

	v4:PivotTo(CFrame.identity)

	local v7, _ = v4:GetBoundingBox()
	local Position = v7.Position

	v4:PivotTo(p2)

	local AnimationController = v4:FindFirstChild("AnimationController")
	local v8 = if AnimationController then AnimationController:FindFirstChild("Animator") else AnimationController

	if v8 then
		FishingAnims.play_fish_anim(v8, p1, "idle", true)
	end

	local CurrentCamera = workspace.CurrentCamera
	local Position2 = p2.Position
	local v9 = Position2 + Vector3.new(0, 6, 0) + p2.LookVector * 3
	local v10 = v4:GetScale()

	local function get_camera_target_pos() --[[ get_camera_target_pos | Line: 149 | Upvalues: CurrentCamera (copy) ]]
		return CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 7
	end

	local function get_side_facing_camera_cf(p1) --[[ get_side_facing_camera_cf | Line: 153 | Upvalues: CurrentCamera (copy), Position (copy) ]]
		local v1 = CFrame.lookAt(p1, CurrentCamera.CFrame.Position) * CFrame.Angles(0, 1.5707963267948966, 0)

		return v1 + v1:VectorToWorldSpace(-Position)
	end

	return TweenPromise.callback(0, 1, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), function(p1) --[[ Line: 161 | Upvalues: v4 (copy), CurrentCamera (copy), Position2 (copy), v9 (copy), Position (copy) ]]
		if v4 and v4.Parent then
			local v3 = CFrame.lookAt((1 - p1) * (1 - p1) * Position2 + 2 * (1 - p1) * p1 * v9 + p1 * p1 * (CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 7), CurrentCamera.CFrame.Position) * CFrame.Angles(0, 1.5707963267948966, 0)

			v4:PivotTo(v3 + v3:VectorToWorldSpace(-Position))
		end
	end):andThen(function() --[[ Line: 171 | Upvalues: v4 (copy), TweenPromise (ref), CurrentCamera (copy), Position (copy) ]]
		if v4 and v4.Parent then
			return TweenPromise.callback(0, 1, TweenInfo.new(0.2, Enum.EasingStyle.Linear), function(p1) --[[ Line: 176 | Upvalues: v4 (ref), CurrentCamera (ref), Position (ref) ]]
				if not (v4 and v4.Parent) then
					return
				end

				local v3 = CFrame.lookAt(CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * 7, CurrentCamera.CFrame.Position) * CFrame.Angles(0, 1.5707963267948966, 0)

				v4:PivotTo(v3 + v3:VectorToWorldSpace(-Position))
			end)
		end
	end):andThen(function() --[[ Line: 182 | Upvalues: v4 (copy), TweenPromise (ref), Character (copy), v10 (copy) ]]
		if v4 and v4.Parent then
			local v1 = v4:GetPivot()

			return TweenPromise.callback(0, 1, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p1) --[[ Line: 189 | Upvalues: Character (ref), v4 (ref), v1 (copy), v10 (ref) ]]
				local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

				if not (HumanoidRootPart and (v4 and v4.Parent)) then
					return
				end

				v4:PivotTo(v1:Lerp(HumanoidRootPart.CFrame, p1))
				v4:ScaleTo((math.lerp(v10, 0.05, p1)))
			end)
		end
	end):andThen(function() --[[ Line: 197 | Upvalues: KindDB (ref), p1 (copy), FishingCostColorDB (ref), Character (copy), GameplayFX (ref), SoundPlayer (ref) ]]
		local v1 = KindDB[p1]
		local v2 = KindDB[p1] and v1.name or p1
		local v3 = if v1 then v1.image else v1
		local v5 = FishingCostColorDB[p1] and FishingCostColorDB[p1].light or Color3.fromRGB(1, 146, 69)
		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if HumanoidRootPart then
			GameplayFX.create_billboard(v5, ("+1 %*"):format(v2), v3, HumanoidRootPart)
		end

		SoundPlayer.FX:play("FishingCatchDoober")
	end):finally(function() --[[ Line: 209 | Upvalues: v3 (copy) ]]
		v3:DoCleaning()
	end)
end

local function spring_pivot_to(p1, p2, p3) --[[ spring_pivot_to | Line: 216 | Upvalues: Spring (copy), Promise (copy), RunService (copy) ]]
	local function resolve_goal() --[[ resolve_goal | Line: 217 | Upvalues: p2 (copy) ]]
		if typeof(p2) == "function" then
			return p2()
		end

		return p2
	end

	local v1 = p1:GetPivot()
	local v2 = if typeof(p2) == "function" then p2() else p2
	local v3 = Spring.new(p3.damping, p3.frequency, v1.Position)
	local v4 = Spring.new(p3.damping, p3.frequency * 0.85, v1.LookVector)

	v3:set_goal(v2.Position)
	v4:set_goal(v2.LookVector)

	if p3.pull_velocity then
		local v5 = v2.Position - v1.Position

		if v5.Magnitude > 0.01 then
			v3:set_velocity(v5.Unit * p3.pull_velocity)
		end
	end

	local v6 = p3.settle_distance or 0.08
	local v7 = p3.max_duration or 1.25
	local v8 = nil

	return Promise.new(function(p12, p22, p3) --[[ Line: 243 | Upvalues: v8 (ref), RunService (ref), p2 (copy), v3 (copy), v4 (copy), p1 (copy), v6 (copy), v7 (copy) ]]
		local v1 = tick()

		local function stop() --[[ stop | Line: 246 | Upvalues: v8 (ref) ]]
			if not v8 then
				return
			end

			v8:Disconnect()
			v8 = nil
		end

		v8 = RunService.Heartbeat:Connect(function(p13) --[[ Line: 253 | Upvalues: p3 (copy), v8 (ref), p2 (ref), v3 (ref), v4 (ref), p1 (ref), v6 (ref), v1 (copy), v7 (ref), p12 (copy) ]]
			if p3() then
				if not v8 then
					return
				end

				v8:Disconnect()
				v8 = nil
			else
				local v2 = if typeof(p2) == "function" then p2() else p2
				local Position = v2.Position
				local LookVector = v2.LookVector

				v3:set_goal(Position)
				v4:set_goal(LookVector)
				v3:update(p13)
				v4:update(p13)

				local v32 = v3:get_position()
				local v42 = v4:get_position()

				p1:PivotTo(CFrame.new(v32, v32 + (if v42.Magnitude > 0.001 then v42.Unit else LookVector)))

				if not ((v32 - Position).Magnitude < v6 and v3:get_velocity().Magnitude < 0.75 or v7 < tick() - v1) then
					return
				end

				p1:PivotTo(v2)

				if v8 then
					v8:Disconnect()
					v8 = nil
				end

				p12()
			end
		end)
		p3(stop)
	end)
end

local function get_pole_attachment(p1) --[[ get_pole_attachment | Line: 291 ]]
	return p1.RootPart:FindFirstChild("PoleAttachment", true)
end

local function get_root_joint(p1) --[[ get_root_joint | Line: 295 ]]
	local v1 = if p1 then p1:FindFirstChild("HumanoidRootPart") else p1

	if not v1 then
		return nil
	end

	local RootJoint = v1:FindFirstChild("RootJoint")

	if RootJoint and RootJoint:IsA("Motor6D") then
		return RootJoint
	end

	for v2, v3 in p1:GetDescendants() do
		if v3:IsA("Motor6D") and v3.Part0 == v1 then
			return v3
		end
	end

	return nil
end

local function set_root_aim(p1, p2) --[[ set_root_aim | Line: 314 ]]
	local v1 = p1:get_value("root_joint")
	local v2 = p1:get_value("root_joint_rest_c0")

	if v1 and v2 then
		v1.C0 = v1.C0:Lerp(v2 * CFrame.Angles(math.lerp(-0.10471975511965978, 0.3141592653589793, (math.clamp(p2, 0, 1))), 0, 0), 0.25)
	end
end

local function restore_root_aim(p1) --[[ restore_root_aim | Line: 325 ]]
	local v1 = p1:get_value("root_joint")
	local v2 = p1:get_value("root_joint_rest_c0")

	if not (v1 and v2) then
		return
	end

	v1.C0 = v2
end

local function emit_fishing_ripple(p1) --[[ emit_fishing_ripple | Line: 333 | Upvalues: Fishing (copy), Debris (copy) ]]
	local FishingRipple = Fishing:FindFirstChild("FishingRipple")

	if not FishingRipple then
		return
	end

	local v1 = FishingRipple:Clone()

	v1.Parent = workspace
	v1.WorldPosition = p1

	local v2 = 0

	for v3, v4 in v1:QueryDescendants("ParticleEmitter") do
		if v4:IsA("ParticleEmitter") then
			local v5 = v4:GetAttribute("EmitCount")

			if v5 then
				v4:Emit(v5)
			end

			if v4.Lifetime then
				v2 = math.max(v2, v4.Lifetime.Max)
			end
		end
	end

	Debris:AddItem(v1, (math.max(v2, 2)))
end

local function update_line_beam(p1, p2, p3, p4, p5) --[[ update_line_beam | Line: 362 ]]
	local Beam = p1.PrimaryPart:FindFirstChild("Beam")

	if not (Beam and Beam:IsA("Beam")) then
		return
	end

	local Magnitude = (p2 - p3).Magnitude

	if p5 then
		local v1 = math.clamp(Magnitude * 0.09 * p5, 0.08, 0.55)

		Beam.CurveSize0 = v1
		Beam.CurveSize1 = -v1 * 0.75
	else
		local v3 = math.clamp(p4 * 0.035 * (2 - math.clamp(Magnitude / p4, 0.85, 1.2)), 0.04, 0.3)

		Beam.CurveSize0 = v3
		Beam.CurveSize1 = -v3 * 0.65
	end
end

local function release_bobber_for_cast(p1) --[[ release_bobber_for_cast | Line: 382 ]]
	p1.PrimaryPart.RodWeldConstraint.Enabled = false
	p1.PrimaryPart.Anchored = true
end

local function prep_bobber_for_reel(p1, p2) --[[ prep_bobber_for_reel | Line: 389 ]]
	p1.PrimaryPart.RodWeldConstraint.Enabled = false

	if not p2 then
		p1.PrimaryPart.MouthRigidConstraint.Enabled = false
	end

	p1.PrimaryPart.Anchored = true
end

local function stop_cast_payout(p1) --[[ stop_cast_payout | Line: 397 ]]
	local v1 = p1:get_value("cast_payout_stop")

	if not v1 then
		return
	end

	v1()
	p1:set_value("cast_payout_stop", nil)
end

local function start_cast_line_payout(p1, p2, p3) --[[ start_cast_line_payout | Line: 405 | Upvalues: Spring (copy), RunService (copy), update_line_beam (copy) ]]
	local v1 = Spring.new(0.45, 8.5, p1:GetPivot().Position)
	local PoleAttachment = p2.RootPart:FindFirstChild("PoleAttachment", true)
	local v2 = if PoleAttachment then PoleAttachment.WorldPosition else p1:GetPivot().Position
	local v3 = RunService.Heartbeat:Connect(function(p12) --[[ Line: 410 | Upvalues: PoleAttachment (ref), p2 (copy), v2 (ref), p3 (copy), v1 (copy), p1 (copy), update_line_beam (ref) ]]
		PoleAttachment = p2.RootPart:FindFirstChild("PoleAttachment", true)

		if not PoleAttachment then
			return
		end

		local WorldPosition = PoleAttachment.WorldPosition
		local v12 = (WorldPosition - v2) / math.max(p12, 0.004166666666666667)

		v2 = WorldPosition

		local v3 = math.clamp(p3(), 0, 1)
		local v4 = v3 * 6.05 + 0.45
		local Character = game.Players.LocalPlayer.Character
		local v5 = if Character then Character.PrimaryPart else Character
		local v7 = Vector3.new(0, -1, 0) + (if v5 then -v5.CFrame.LookVector else Vector3.new(0, 0, 0)) * 0.4

		v1:set_goal(WorldPosition + (if v7.Magnitude > 0.01 then v7.Unit else Vector3.new(0, -1, 0)) * v4)

		if v12.Magnitude > 0.01 then
			v1:add_velocity(v12 * 0.6)
		end

		v1:update(p12)

		local v9 = v1:get_position()
		local v10 = WorldPosition - v9

		p1:PivotTo(CFrame.new(v9, v9 + (if v10.Magnitude > 0.01 then v10.Unit else Vector3.new(0, 1, 0))))
		update_line_beam(p1, WorldPosition, v9, v4, 1.35 - v3 * 0.45)
	end)

	return function() --[[ Line: 455 | Upvalues: v3 (copy) ]]
		v3:Disconnect()
	end
end

local function await_rod_tip_release(p1) --[[ await_rod_tip_release | Line: 463 | Upvalues: Promise (copy), RunService (copy) ]]
	local v1 = nil

	return Promise.new(function(p1, p23, p33) --[[ Line: 466 | Upvalues: v1 (ref), RunService (ref), p1 (copy) ]]
		local v12 = nil
		local v2 = Vector3.new(0, 0, 0)
		local v3 = 0
		local v4 = false
		local v52 = tick()

		local function stop() --[[ stop | Line: 473 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end

			v1:Disconnect()
			v1 = nil
		end

		v1 = RunService.Heartbeat:Connect(function(p12) --[[ Line: 480 | Upvalues: p33 (copy), v1 (ref), p1 (ref), v12 (ref), v4 (ref), v3 (ref), p1 (copy), v2 (ref), v52 (copy) ]]
			if p33() then
				if not v1 then
					return
				end

				v1:Disconnect()
				v1 = nil
			else
				local PoleAttachment = p1.RootPart:FindFirstChild("PoleAttachment", true)

				if not PoleAttachment then
					return
				end

				local WorldPosition = PoleAttachment.WorldPosition

				if not v12 then
					v12 = WorldPosition

					return
				end

				local v13 = (WorldPosition - v12) / math.max(p12, 0.004166666666666667)

				v12 = WorldPosition

				local Magnitude = v13.Magnitude

				if Magnitude >= 6 then
					v4 = true
				end

				if v4 and Magnitude < v3 then
					if v1 then
						v1:Disconnect()
						v1 = nil
					end

					p1(v2)
				else
					v2 = v13
					v3 = Magnitude

					if not (tick() - v52 > 0.22) then
						return
					end

					if v1 then
						v1:Disconnect()
						v1 = nil
					end

					p1(v13)
				end
			end
		end)
		p33(stop)
	end)
end

local function launch_bobber_arc(p1, p2, p3, p4, p5) --[[ launch_bobber_arc | Line: 526 | Upvalues: Promise (copy), RunService (copy), emit_fishing_ripple (copy) ]]
	local Position = p1:GetPivot().Position
	local v1 = Vector3.new(Position.X, 0, Position.Z)
	local Magnitude = (Vector3.new(p3.X, 0, p3.Z) - v1).Magnitude
	local v2 = math.clamp(Magnitude / 26, 0, 1)
	local v3 = math.lerp(0.34, 0.65, v2)
	local v4 = math.clamp(Magnitude * 0.34, 10, 32) * (math.clamp(p4, 0, 1) * 0.25 + 1)
	local v6 = v3 * math.clamp(1 - (if p5 then p5.Magnitude else 0) / 60, 0.8, 1)
	local PoleAttachment = p2.RootPart:FindFirstChild("PoleAttachment", true)
	local v7 = if PoleAttachment then PoleAttachment.WorldPosition else Position
	local v8 = math.max(Position.Y, v7.Y, p3.Y) + v4 + 6
	local v11 = Vector3.new(p3.X - v7.X, 0, p3.Z - v7.Z)
	local v12 = if v11.Magnitude > 0.01 then -v11.Unit else Vector3.new(0, 0, 0)
	local v13 = v2 * 7
	local v16 = Vector3.new(v7.X + (p3.X - v7.X) * 0.32 + v12.X * v13, v8, v7.Z + (p3.Z - v7.Z) * 0.32 + v12.Z * v13)
	local v17 = nil

	return Promise.new(function(p12, p22, p32) --[[ Line: 560 | Upvalues: Position (copy), v17 (ref), RunService (ref), v6 (ref), v16 (copy), p3 (copy), p1 (copy), p2 (copy), emit_fishing_ripple (ref) ]]
		local v1 = 0
		local v2 = Position

		local function stop() --[[ stop | Line: 564 | Upvalues: v17 (ref) ]]
			if not v17 then
				return
			end

			v17:Disconnect()
			v17 = nil
		end

		v17 = RunService.Heartbeat:Connect(function(p13) --[[ Line: 571 | Upvalues: p32 (copy), v17 (ref), v1 (ref), v6 (ref), Position (ref), v16 (ref), p3 (ref), v2 (ref), p1 (ref), p2 (ref), emit_fishing_ripple (ref), p12 (copy) ]]
			if p32() then
				if not v17 then
					return
				end

				v17:Disconnect()
				v17 = nil
			else
				v1 = v1 + p13

				local v22 = 1 - (1 - math.clamp(v1 / v6, 0, 1)) ^ 2
				local v3 = 1 - v22
				local v4 = Position * (v3 * v3) + v16 * (v3 * 2 * v22) + p3 * (v22 * v22)
				local v5 = v4 - v2

				v2 = v4
				p1:PivotTo(CFrame.new(v4, v4 + (if v5.Magnitude > 0.01 then v5.Unit else Vector3.new(0, 1, 0))))

				local PoleAttachment = p2.RootPart:FindFirstChild("PoleAttachment", true)

				if PoleAttachment then
					local WorldPosition = PoleAttachment.WorldPosition
					local Magnitude = (PoleAttachment.WorldPosition - p3).Magnitude
					local Beam = p1.PrimaryPart:FindFirstChild("Beam")

					if Beam and Beam:IsA("Beam") then
						local v9 = math.clamp((WorldPosition - v4).Magnitude * 0.09 * 0.35, 0.08, 0.55)

						Beam.CurveSize0 = v9
						Beam.CurveSize1 = -v9 * 0.75
					end
				end

				if not (v6 <= v1) then
					return
				end

				p1:PivotTo(CFrame.new(p3))
				emit_fishing_ripple(p3)

				if v17 then
					v17:Disconnect()
					v17 = nil
				end

				p12()
			end
		end)
		p32(stop)
	end)
end

local function start_bobber_line_sim(p1, p2, p3, p4, p5) --[[ start_bobber_line_sim | Line: 611 | Upvalues: Spring (copy), RunService (copy) ]]
	local v1 = if p5 then p5.bob_intensity or 1 else 1
	local v2 = Spring.new(0.58, 4, p1:GetPivot().Position)
	local PoleAttachment = p2.RootPart:FindFirstChild("PoleAttachment", true)
	local v3 = if PoleAttachment then PoleAttachment.WorldPosition else p1:GetPivot().Position
	local v4 = tick()

	return RunService.Heartbeat:Connect(function(p12) --[[ Line: 624 | Upvalues: PoleAttachment (ref), p2 (copy), v3 (ref), v4 (copy), v1 (copy), p3 (copy), p4 (copy), v2 (copy), p1 (copy) ]]
		PoleAttachment = p2.RootPart:FindFirstChild("PoleAttachment", true)

		if not PoleAttachment then
			return
		end

		local WorldPosition = PoleAttachment.WorldPosition
		local v12 = (WorldPosition - v3) / math.max(p12, 0.004166666666666667)

		v3 = WorldPosition

		local v22 = tick() - v4
		local v32 = math.sin(v22 * 2.4) * 0.15 * v1 + math.sin(v22 * 3.8) * (0.06 * v1)
		local v6 = p3 + Vector3.new(math.sin(v22 * 1.6) * 0.06 * v1, v32, math.cos(v22 * 1.25) * 0.06 * v1) - WorldPosition

		v2:set_goal(if v6.Magnitude > 0.01 then WorldPosition + v6.Unit * p4 else WorldPosition + Vector3.new(0, -p4, 0))

		if v12.Magnitude > 0.01 then
			v2:add_velocity(v12 * 0.22)
		end

		v2:update(p12)

		local v9 = v2:get_position()
		local v10 = WorldPosition - v9
		local v11 = if v10.Magnitude > 0.01 then v10.Unit else Vector3.new(0, 1, 0)
		local v122 = math.sin(v22 * 2.1) * 0.10471975511965978 * v1

		p1:PivotTo(CFrame.new(v9, v9 + v11) * CFrame.Angles(0, 0, v122))

		local v13 = p4
		local Beam = p1.PrimaryPart:FindFirstChild("Beam")

		if not Beam then
			return
		end

		if not Beam:IsA("Beam") then
			return
		end

		local v16 = math.clamp(v13 * 0.035 * (2 - math.clamp((WorldPosition - v9).Magnitude / v13, 0.85, 1.2)), 0.04, 0.3)

		Beam.CurveSize0 = v16
		Beam.CurveSize1 = -v16 * 0.65
	end)
end

local function start_bobber_line_sim_for_state(p1, p2) --[[ start_bobber_line_sim_for_state | Line: 667 | Upvalues: start_bobber_line_sim (copy) ]]
	local v1, v2 = p1:get_values("bobber", "tool_model")
	local v3, v4 = p1:get_values("water_anchor", "line_length")

	if v1 and (v2 and (v3 and v4)) then
		p1:cleanup_on_change_state(start_bobber_line_sim(v1, v2, v3, v4, {
			bob_intensity = p2
		}))
	end
end

local function _visualize_fishing_raycast(p1, p2) --[[ _visualize_fishing_raycast | Line: 679 ]]
	local Part = Instance.new("Part")

	Part.CFrame = p1
	Part.Anchored = true
	Part.CanCollide = false
	Part.Size = Vector3.new(1, 1, 1)
	Part.Parent = game.Workspace

	local Part2 = Instance.new("Part")

	Part2.CFrame = p2
	Part2.Anchored = true
	Part2.CanCollide = false
	Part2.Size = Vector3.new(1, 1, 1)
	Part2.Parent = game.Workspace

	local Attachment = Instance.new("Attachment")

	Attachment.Parent = Part

	local Attachment2 = Instance.new("Attachment")

	Attachment2.Parent = Part2

	local Beam = Instance.new("Beam")

	Beam.Parent = Part
	Beam.Attachment0 = Attachment
	Beam.Attachment1 = Attachment2
end

local function fishing_raycast(p1) --[[ fishing_raycast | Line: 705 | Upvalues: RaycastHelper (copy) ]]
	local PrimaryPart = game.Players.LocalPlayer.Character.PrimaryPart
	local v1 = math.lerp(8, 26, p1)
	local v2 = PrimaryPart.CFrame * CFrame.new(PrimaryPart.CFrame.LookVector * Vector3.new(0, 1, 0)) * CFrame.new(0, 0, -v1)
	local v3 = v2 * CFrame.new(0, -25, -v1)

	return RaycastHelper.cast_ray({
		respect_can_collide = true,
		collision_group = "players",
		origin = v2.Position,
		direction = (v3.Position - v2.Position).Unit * (v2.Position - v3.Position).Magnitude,
		filter_type = Enum.RaycastFilterType.Exclude,
		instances = { game.Workspace.PlayerCharacters }
	})
end

local function cleanup_fishing_gui() --[[ cleanup_fishing_gui | Line: 724 ]]
	local FishingTarget = game.Workspace:FindFirstChild("FishingTarget")

	if not FishingTarget then
		return
	end

	FishingTarget:Destroy()
end

local v1 = false

return StateMachinePromise.new({
	charging = {
		can_enter = function(p1, p2, p3, p4) --[[ can_enter | Line: 735 | Upvalues: ClientData (copy), UIManager (copy), fishing_raycast (copy), PlatformM (copy), ControlsDisabler (copy), InteractionsEngine (copy), FishingAnims (copy), v1 (ref), Promise (copy) ]]
			if p1:get_current_state() then
				return false
			end

			local ModelHandle = p3.tool.ModelHandle
			local FishingRodBobber = ModelHandle:FindFirstChild("FishingRodBobber")

			if not FishingRodBobber then
				return false
			end

			local Humanoid = game.Players.LocalPlayer.Character.Humanoid

			if Humanoid:GetState() ~= Enum.HumanoidStateType.Running then
				return false
			end

			local v3 = nil

			for v4, v5 in (ClientData.get("inventory") or {}).gifts or {} do
				if v5.kind == "summer_2026_fishing_bait" or v5.kind == "summer_2026_monster_fishing_bait" then
					v3 = v5

					break
				end
			end

			if v3 then
				local v6 = fishing_raycast(0)
				local v7 = fishing_raycast(1)

				if not v6 or v6.Material ~= Enum.Material.Water then
					UIManager.apps.HintApp:hint({
						yields = false,
						overridable = false,
						text = "Find a fishing spot by the water!",
						time = 2.5
					})

					return false
				end

				p1:set_values({
					tool_model = ModelHandle,
					bobber = FishingRodBobber,
					rod_kind = p2.kind,
					min_raycast_result = v6,
					max_raycast_result = v7
				})

				if PlatformM.is_using_gamepad() then
					game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = true
				else
					ControlsDisabler.disable_controls("fishing")
				end

				InteractionsEngine:disable("fishing")
				FishingAnims.set_animators(Humanoid.Animator, ModelHandle.AnimationController.Animator)

				local v8 = p1.value_changed_signal:connect(function(p1, p2) --[[ Line: 812 | Upvalues: v1 (ref) ]]
					if p1 ~= "bobber_approached" or p2 ~= true then
						return
					end

					v1 = true
				end)

				p1:cleanup_on_exit_state(function() --[[ Line: 817 | Upvalues: v8 (copy), p1 (copy), InteractionsEngine (ref), FishingRodBobber (copy), ModelHandle (copy), ControlsDisabler (ref), FishingAnims (ref) ]]
					v8:destroy()

					local v1 = p1
					local v2 = v1:get_value("cast_payout_stop")

					if v2 then
						v2()
						v1:set_value("cast_payout_stop", nil)
					end

					local v3 = p1
					local v4 = v3:get_value("root_joint")
					local v5 = v3:get_value("root_joint_rest_c0")

					if v4 and v5 then
						v4.C0 = v5
					end

					InteractionsEngine:enable("fishing")

					if FishingRodBobber and (FishingRodBobber.Parent ~= nil and (ModelHandle and ModelHandle.parent ~= nil)) then
						FishingRodBobber:PivotTo(ModelHandle.BobberSpawn.CFrame)
						FishingRodBobber.PrimaryPart.Anchored = false
						FishingRodBobber.PrimaryPart.RodWeldConstraint.Enabled = true
						FishingRodBobber.PrimaryPart.MouthRigidConstraint.Enabled = false
					end

					ControlsDisabler.enable_controls("fishing")
					game.Players.LocalPlayer.Character.PrimaryPart.Anchored = false
					FishingAnims.cleanup()

					local FishingTarget = game.Workspace:FindFirstChild("FishingTarget")

					if not FishingTarget then
						return
					end

					FishingTarget:Destroy()
				end)
				p1:cleanup_on_exit_state(Promise.fromEvent(p4):andThen(function() --[[ Line: 833 | Upvalues: p1 (copy) ]]
					p1:exit_state()
				end))

				return true
			end

			UIManager.apps.DialogApp:dialog({
				text = "You need Bait to fish!",
				button = "Next"
			})

			if UIManager.apps.DialogApp:dialog({
				text = "Navigate to the Fishing Shop?",
				left = "No",
				right = "Yes"
			}) ~= "Yes" then
				return false
			end

			UIManager.apps.GuideArrowApp:navigate_promise({
				final_destination = "Aquarium",
				custom_position_or_method = function(p1) --[[ custom_position_or_method | Line: 776 ]]
					local BaitNavigationPosition = p1:FindFirstChild("BaitNavigationPosition")

					return if BaitNavigationPosition then BaitNavigationPosition.Position else BaitNavigationPosition
				end
			})

			return false
		end,
		enter = function(p1, p2, p3, p4) --[[ enter | Line: 839 | Upvalues: get_root_joint (copy), FishingAnims (copy), start_cast_line_payout (copy), Fishing (copy), SoundPlayer (copy), Promise (copy), TweenPromise (copy), set_root_aim (copy) ]]
			local v1, v2 = p1:get_values("min_raycast_result", "max_raycast_result")
			local v3, v4 = p1:get_values("bobber", "tool_model")

			v3.PrimaryPart.RodWeldConstraint.Enabled = false
			v3.PrimaryPart.Anchored = true

			local v5 = get_root_joint(game.Players.LocalPlayer.Character)

			if v5 then
				p1:set_value("root_joint", v5)
				p1:set_value("root_joint_rest_c0", v5.C0)
			end

			local v6 = FishingAnims.play_rod_anim("FishingRodCastBackswing")

			p1:set_value("cast_payout_stop", (start_cast_line_payout(v3, v4, function() --[[ Line: 851 | Upvalues: v6 (copy) ]]
				if v6.IsPlaying and v6.Length > 0 then
					return math.clamp(v6.TimePosition / v6.Length, 0, 1)
				end

				return 1
			end)))

			local v7 = Fishing.FishingTarget:Clone()
			local v8 = CFrame.new(v1.Position)
			local v9 = CFrame.new(v2.Position)

			v7:PivotTo(v8)
			v7.Target.Transparency = 1
			v7.Parent = game.Workspace
			p1:cleanup_on_change_state((SoundPlayer.FX:play("FishingCastPower")))

			return Promise.all({ Promise.all({ FishingAnims.await_anim(FishingAnims.play_avatar_anim("FishingAvatarCastBackswing")), FishingAnims.await_anim(v6) }):andThen(function() --[[ Line: 873 | Upvalues: FishingAnims (ref) ]]
					FishingAnims.play_avatar_anim("FishingAvatarCastHold", true)
					FishingAnims.play_rod_anim("FishingRodCastHold", true)
				end), Promise.all({ TweenPromise.callback(0, 1, TweenInfo.new(1.2, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut, 0, true), function(p12) --[[ Line: 878 | Upvalues: p1 (copy), v7 (copy), v8 (copy), v9 (copy), set_root_aim (ref) ]]
						p1:set_value("cast_power", p12)
						v7:PivotTo(v8:Lerp(v9, p12))
						set_root_aim(p1, p12)
					end), TweenPromise.callback(0, 1, TweenInfo.new(0.24, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), function(p1) --[[ Line: 883 | Upvalues: v7 (copy) ]]
						v7.Target.Transparency = math.lerp(1, 0.5, p1)
					end) }):andThen(function() --[[ Line: 886 | Upvalues: p1 (copy) ]]
					p1:enter_state("casting")
				end) })
		end
	},
	casting = {
		can_enter = function(p1) --[[ can_enter | Line: 893 ]]
			return p1:get_current_state() == "charging"
		end,
		enter = function(p1) --[[ enter | Line: 896 | Upvalues: fishing_raycast (copy), UIManager (copy), Promise (copy), SoundPlayer (copy), FishingAnims (copy), RunService (copy), launch_bobber_arc (copy) ]]
			local v1 = p1:get_value("root_joint")
			local v2 = p1:get_value("root_joint_rest_c0")

			if v1 and v2 then
				v1.C0 = v2
			end

			local v3, v4, v5 = p1:get_values("bobber", "cast_power", "tool_model")
			local v6 = fishing_raycast(v4)

			if v6 and v6.Material == Enum.Material.Water then
				SoundPlayer.FX:play("FishingCast")
				v3.PrimaryPart.RodWeldConstraint.Enabled = false
				v3.PrimaryPart.Anchored = true

				local t = {}
				local v7 = Promise.all({ FishingAnims.await_anim(FishingAnims.play_avatar_anim("FishingAvatarCastFollowThrough")), FishingAnims.await_anim(FishingAnims.play_rod_anim("FishingRodCastFollowThrough")) }):andThen(function() --[[ Line: 922 | Upvalues: FishingAnims (ref) ]]
					FishingAnims.play_avatar_anim("FishingAvatarCastIdle", true)
					FishingAnims.play_rod_anim("FishingRodCastIdle", true)

					local FishingTarget = game.Workspace:FindFirstChild("FishingTarget")

					if not FishingTarget then
						return
					end

					FishingTarget:Destroy()
				end)
				local v8 = nil

				t[1] = v7
				t[2] = Promise.new(function(p1, p23, p33) --[[ Line: 466 | Upvalues: v8 (ref), RunService (ref), v5 (copy) ]]
					local v12 = nil
					local v2 = Vector3.new(0, 0, 0)
					local v3 = 0
					local v4 = false
					local v52 = tick()

					local function stop() --[[ stop | Line: 473 | Upvalues: v8 (ref) ]]
						if not v1 then
							return
						end

						v1:Disconnect()
						v1 = nil
					end

					v8 = RunService.Heartbeat:Connect(function(p12) --[[ Line: 480 | Upvalues: p33 (copy), v8 (ref), v5 (ref), v12 (ref), v4 (ref), v3 (ref), p1 (copy), v2 (ref), v52 (copy) ]]
						if p33() then
							if not v1 then
								return
							end

							v1:Disconnect()
							v1 = nil
						else
							local PoleAttachment = p1.RootPart:FindFirstChild("PoleAttachment", true)

							if not PoleAttachment then
								return
							end

							local WorldPosition = PoleAttachment.WorldPosition

							if not v12 then
								v12 = WorldPosition

								return
							end

							local v13 = (WorldPosition - v12) / math.max(p12, 0.004166666666666667)

							v12 = WorldPosition

							local Magnitude = v13.Magnitude

							if Magnitude >= 6 then
								v4 = true
							end

							if v4 and Magnitude < v3 then
								if v1 then
									v1:Disconnect()
									v1 = nil
								end

								p1(v2)
							else
								v2 = v13
								v3 = Magnitude

								if not (tick() - v52 > 0.22) then
									return
								end

								if v1 then
									v1:Disconnect()
									v1 = nil
								end

								p1(v13)
							end
						end
					end)
					p33(stop)
				end):andThen(function(p12) --[[ Line: 927 | Upvalues: p1 (copy), launch_bobber_arc (ref), v3 (copy), v5 (copy), v6 (copy), v4 (copy) ]]
					local v1 = p1
					local v2 = v1:get_value("cast_payout_stop")

					if not v2 then
						return launch_bobber_arc(v3, v5, v6.Position, v4, p12):andThen(function() --[[ Line: 929 | Upvalues: v5 (ref), p1 (ref), v6 (ref) ]]
							local PoleAttachment = v5.RootPart:FindFirstChild("PoleAttachment", true)

							if not PoleAttachment then
								return
							end

							p1:set_value("water_anchor", v6.Position)
							p1:set_value("line_length", (PoleAttachment.WorldPosition - v6.Position).Magnitude)
						end)
					end

					v2()
					v1:set_value("cast_payout_stop", nil)

					return launch_bobber_arc(v3, v5, v6.Position, v4, p12):andThen(function() --[[ Line: 929 | Upvalues: v5 (ref), p1 (ref), v6 (ref) ]]
						local PoleAttachment = v5.RootPart:FindFirstChild("PoleAttachment", true)

						if not PoleAttachment then
							return
						end

						p1:set_value("water_anchor", v6.Position)
						p1:set_value("line_length", (PoleAttachment.WorldPosition - v6.Position).Magnitude)
					end)
				end)

				return Promise.all(t):andThen(function() --[[ Line: 937 | Upvalues: SoundPlayer (ref), p1 (copy) ]]
					SoundPlayer.FX:play("FishingBobberLand")
					p1:enter_state("waiting")
				end)
			end

			UIManager.apps.HintApp:hint({
				yields = false,
				overridable = false,
				text = "You missed the water!",
				time = 2.5
			})
			p1:enter_state("canceling")

			return Promise.resolve()
		end
	},
	waiting = {
		can_enter = function(p1) --[[ can_enter | Line: 944 ]]
			local v1 = p1:get_current_state()

			return if v1 == "casting" or (v1 == "hooked" or v1 == "struggling") then true else v1 == "catching"
		end,
		enter = function(p1) --[[ enter | Line: 951 | Upvalues: start_bobber_line_sim_for_state (copy), Promise (copy) ]]
			p1:clear_values("hotspot_kind", "fish_unique", "struggles_remaining", "tier_delta", "hooked_despawn_registered", "bite_reaction_duration")
			start_bobber_line_sim_for_state(p1, 1)

			return Promise.resolve()
		end
	},
	hooked = {
		can_enter = function(p1, p2) --[[ can_enter | Line: 958 ]]
			local v1 = p1:get_current_state()

			return if p2 then if v1 == "waiting" then true else v1 == "struggling" else p2
		end,
		enter = function(p1, p2) --[[ enter | Line: 962 | Upvalues: start_bobber_line_sim_for_state (copy), FishingReactionTime (copy), SoundPlayer (copy), FishBiteTimerClient (copy), Promise (copy) ]]
			p1:set_value("fish_state", p2)
			start_bobber_line_sim_for_state(p1, 1.5)

			local PrimaryPart = p1:get_value("bobber").PrimaryPart
			local v1 = p1:get_value("bite_reaction_duration")

			if not v1 then
				v1 = FishingReactionTime.get_adjusted_bite_time(p2:get_value("fish_kind"), (p1:get_value("rod_kind")))
			end

			SoundPlayer.FX:play("FishingFishBite")
			FishBiteTimerClient.mount(PrimaryPart, v1, function(p12) --[[ Line: 977 | Upvalues: p1 (copy) ]]
				p1:cleanup_on_change_state(p12)
			end)

			if p1:get_value("hooked_despawn_registered") then
				return Promise.resolve()
			end

			p1:set_value("hooked_despawn_registered", true)
			p1:cleanup_on_exit_state(function() --[[ Line: 983 | Upvalues: p2 (copy) ]]
				if p2:get_current_state() == "despawn" then
					return
				end

				p2:enter_state("despawn", true)
			end)

			return Promise.resolve()
		end
	},
	struggling = {
		can_enter = function(p1) --[[ can_enter | Line: 993 ]]
			local v1 = p1:get_value("fish_state")

			return if p1:get_current_state() == "hooked" then if v1 then v1:get_current_state() == "bite" else v1 else false
		end,
		enter = function(p1) --[[ enter | Line: 997 | Upvalues: SoundPlayer (copy), Promise (copy), CloudValues (copy), FishingAnims (copy) ]]
			local v1 = p1:get_value("fish_state")

			v1:enter_state("catching")
			p1:set_value("struggles_remaining", (p1:get_value("struggles_remaining") or 0) - 1)

			local v2 = SoundPlayer.FX:loop("FishingFishTooStrongLoop")

			SoundPlayer.FX:play("FishingFishTooStrongBite")
			p1:cleanup_on_change_state(v2)

			local v3 = false

			return Promise.try(function() --[[ Line: 1010 | Upvalues: Promise (ref), CloudValues (ref), v3 (ref), FishingAnims (ref) ]]
				return Promise.all({ Promise.delay(CloudValues:getValue("fishing", "fishing_struggle_duration")):andThen(function() --[[ Line: 1012 | Upvalues: v3 (ref) ]]
						v3 = true
					end), FishingAnims.loop_anim_until(FishingAnims.play_avatar_anim("FishingAvatarReelingStruggle", true), function() --[[ Line: 1015 | Upvalues: v3 (ref) ]]
						return v3
					end), FishingAnims.loop_anim_until(FishingAnims.play_rod_anim("FishingRodReelingStruggle", true), function() --[[ Line: 1018 | Upvalues: v3 (ref) ]]
						return v3
					end) })
			end):andThen(function() --[[ Line: 1022 | Upvalues: v1 (copy) ]]
				v1:enter_state("bite")
			end)
		end
	},
	catching = {
		can_enter = function(p1) --[[ can_enter | Line: 1028 ]]
			local v1 = p1:get_value("fish_state")

			return if p1:get_current_state() == "hooked" then if v1 then v1:get_current_state() == "bite" else v1 else false
		end,
		enter = function(p1) --[[ enter | Line: 1032 | Upvalues: SoundPlayer (copy), CloudValues (copy), Promise (copy), FishingAnims (copy), FishingNetService (copy), spring_pivot_to (copy), t (copy), play_fish_caught_celebration (copy) ]]
			local v1 = p1:get_value("fish_state")

			v1:enter_state("catching")

			local v2 = SoundPlayer.FX:loop("FishingReelInLoop")

			SoundPlayer.FX:play("FishingReelInStart")
			p1:cleanup_on_change_state(v2)

			local v3 = p1:get_value("bobber")

			p1:cleanup_on_change_state(function() --[[ Line: 1040 | Upvalues: v3 (copy) ]]
				if not (v3 and v3.Parent) then
					return
				end

				v3.PrimaryPart.MouthRigidConstraint.Enabled = false
				v3.PrimaryPart.MouthRigidConstraint.Attachment1 = nil
			end)

			local v4 = p1:get_value("tier_delta") or 0
			local v5 = 1 + math.max(0, v4) * CloudValues:getValue("fishing", "fishing_catch_animation_speed_bonus_per_tier_above")
			local v6 = 3 / v5

			return Promise.try(function() --[[ Line: 1051 | Upvalues: FishingAnims (ref), v5 (copy), Promise (ref), v6 (copy) ]]
				local v1 = false

				local function f2() --[[ Line: 1053 | Upvalues: v1 (ref) ]]
					return v1
				end

				local v3 = FishingAnims.play_avatar_anim("FishingAvatarReelingControlled", true)
				local v4 = FishingAnims.play_rod_anim("FishingRodReelingControlled", true)

				v3:AdjustSpeed(v5)
				v4:AdjustSpeed(v5)

				return Promise.all({ Promise.delay(v6):andThen(function() --[[ Line: 1061 | Upvalues: v1 (ref) ]]
						v1 = true
					end), FishingAnims.loop_anim_until(v3, f2), FishingAnims.loop_anim_until(v4, f2) })
			end):andThen(function() --[[ Line: 1067 | Upvalues: p1 (copy), FishingNetService (ref), v2 (copy), v1 (copy), SoundPlayer (ref), Promise (ref), FishingAnims (ref), spring_pivot_to (ref), t (ref), play_fish_caught_celebration (ref) ]]
				local v12, v22, v3, v4 = p1:get_values("hotspot_kind", "fish_unique", "tool_model", "bobber")

				FishingNetService.catch_fish(v12, v22)
				v4.PrimaryPart.RodWeldConstraint.Enabled = false
				v4.PrimaryPart.Anchored = true
				v2:Destroy()

				local v5 = v1:get_value("fish_kind")

				if v5 == "summer_2026_bronze_fish" then
					SoundPlayer.FX:play("FishingCatchBronzeFish")
				elseif v5 == "summer_2026_silver_fish" then
					SoundPlayer.FX:play("FishingCatchSilverFish")
				elseif v5 == "summer_2026_gold_fish" then
					SoundPlayer.FX:play("FishingCatchGoldFish")
				elseif v5 == "summer_2026_rainbow_fish" then
					SoundPlayer.FX:play("FishingCatchRainbowFish")
				elseif v5 == "summer_2026_lake_monster" then
					SoundPlayer.FX:play("FishingCatchLakeMonster")
				end

				return Promise.all({
					FishingAnims.await_anim(FishingAnims.play_avatar_anim("FishingAvatarCatch")),
					FishingAnims.await_anim(FishingAnims.play_rod_anim("FishingRodCatch")),
					spring_pivot_to(v4, function() --[[ Line: 1086 | Upvalues: v3 (copy) ]]
						return v3.BobberSpawn.CFrame
					end, t):andThen(function() --[[ Line: 1092 | Upvalues: v4 (copy), v3 (copy) ]]
						local v1 = v4

						v1:PivotTo(v3.BobberSpawn.CFrame)
						v1.PrimaryPart.Anchored = false
						v1.PrimaryPart.RodWeldConstraint.Enabled = true
					end),
					Promise.delay(0.2):andThen(function() --[[ Line: 1095 | Upvalues: v4 (copy), v1 (ref), v5 (copy), play_fish_caught_celebration (ref), Promise (ref) ]]
						local v12 = v4:GetPivot()

						v4.PrimaryPart.MouthRigidConstraint.Enabled = false
						v4.PrimaryPart.MouthRigidConstraint.Attachment1 = nil
						v1:exit_state()

						if v5 then
							return play_fish_caught_celebration(v5, v12)
						end

						return Promise.resolve()
					end)
				})
			end):andThen(function() --[[ Line: 1109 | Upvalues: p1 (copy) ]]
				p1:clear_values("fish_state")
				p1:exit_state()
			end)
		end
	},
	canceling = {
		can_enter = function(p1) --[[ can_enter | Line: 1116 ]]
			local v1 = p1:get_current_state()

			return if v1 == "waiting" or v1 == "casting" then true else v1 == "struggling"
		end,
		enter = function(p1) --[[ enter | Line: 1120 | Upvalues: SoundPlayer (copy), v1 (ref), UIManager (copy), Promise (copy), FishingAnims (copy), spring_pivot_to (copy), t2 (copy) ]]
			local v12 = p1:get_value("cast_payout_stop")

			if v12 then
				v12()
				p1:set_value("cast_payout_stop", nil)
			end

			local v2 = p1:get_value("root_joint")
			local v3 = p1:get_value("root_joint_rest_c0")

			if v2 and v3 then
				v2.C0 = v3
			end

			SoundPlayer.FX:play("FishingUncast")

			if v1 then
				return Promise.try(function() --[[ Line: 1133 | Upvalues: p1 (copy), Promise (ref), FishingAnims (ref), spring_pivot_to (ref), t2 (ref) ]]
					local v1, v2 = p1:get_values("tool_model", "bobber")

					v2.PrimaryPart.RodWeldConstraint.Enabled = false
					v2.PrimaryPart.MouthRigidConstraint.Enabled = false
					v2.PrimaryPart.Anchored = true

					return Promise.all({ Promise.any({ FishingAnims.await_anim(FishingAnims.play_avatar_anim("FishingAvatarCatch")), FishingAnims.await_anim(FishingAnims.play_rod_anim("FishingRodCatch")), Promise.delay(0.5) }), spring_pivot_to(v2, function() --[[ Line: 1136 | Upvalues: v1 (copy) ]]
							return v1.BobberSpawn.CFrame
						end, t2):andThen(function() --[[ Line: 1145 | Upvalues: v2 (copy), v1 (copy) ]]
							local v12 = v2

							v12:PivotTo(v1.BobberSpawn.CFrame)
							v12.PrimaryPart.Anchored = false
							v12.PrimaryPart.RodWeldConstraint.Enabled = true
						end) })
				end):andThen(function() --[[ Line: 1149 | Upvalues: p1 (copy) ]]
					p1:exit_state()
				end)
			end

			UIManager.apps.HintApp:hint({
				yields = false,
				overridable = true,
				text = "Fish will only approach your bobber if they can see it",
				time = 3,
				color = Color3.new(0.933333, 0.776471, 0.266667)
			})

			return Promise.try(function() --[[ Line: 1133 | Upvalues: p1 (copy), Promise (ref), FishingAnims (ref), spring_pivot_to (ref), t2 (ref) ]]
				local v1, v2 = p1:get_values("tool_model", "bobber")

				v2.PrimaryPart.RodWeldConstraint.Enabled = false
				v2.PrimaryPart.MouthRigidConstraint.Enabled = false
				v2.PrimaryPart.Anchored = true

				return Promise.all({ Promise.any({ FishingAnims.await_anim(FishingAnims.play_avatar_anim("FishingAvatarCatch")), FishingAnims.await_anim(FishingAnims.play_rod_anim("FishingRodCatch")), Promise.delay(0.5) }), spring_pivot_to(v2, function() --[[ Line: 1136 | Upvalues: v1 (copy) ]]
						return v1.BobberSpawn.CFrame
					end, t2):andThen(function() --[[ Line: 1145 | Upvalues: v2 (copy), v1 (copy) ]]
						local v12 = v2

						v12:PivotTo(v1.BobberSpawn.CFrame)
						v12.PrimaryPart.Anchored = false
						v12.PrimaryPart.RodWeldConstraint.Enabled = true
					end) })
			end):andThen(function() --[[ Line: 1149 | Upvalues: p1 (copy) ]]
				p1:exit_state()
			end)
		end
	}
})