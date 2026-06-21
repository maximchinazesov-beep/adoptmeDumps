-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingFlagRenderer
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SharedModules = ReplicatedStorage.SharedModules
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local SkydivingNetService = require(script.Parent.SkydivingNetService)
local ColorThemeDB = require(ReplicatedStorage.ClientDB.ColorThemeDB)
local GameplayFX = require(SharedModules.GameplayFX)
local LiveOpsTime = require(SharedModules.Game.LiveOpsTime)
local Maid = require(SharedModules.Maid)
local SoundPlayer = require(SharedModules.SoundPlayer)
local Resources = ReplicatedStorage:WaitForChild("Resources")
local SpawnPoof = Resources.IceSkating.SpawnPoof
local SkyDivingFlag = Resources.Skydiving.SkyDivingFlag
local CYCLE_DURATION = SkydivingConstants.CYCLE_DURATION
local t = {}

t.__index = t
function t.new() --[[ new | Line: 27 | Upvalues: Maid (copy), t (copy), SkydivingNetService (copy), RunService (copy) ]]
	local v1 = Maid.new()
	local SkydivingFlags = Instance.new("Folder")

	SkydivingFlags.Name = "SkydivingFlags"
	SkydivingFlags.Parent = workspace

	local v3 = setmetatable({
		_cycle_timestamp = 0,
		_parachute_fade = false,
		_countdown_timer = 0,
		_target_board_flags = {},
		_flag_folder = SkydivingFlags,
		_maid = v1
	}, t)

	v1:GiveTask(SkydivingFlags)
	v1:GiveTask(SkydivingNetService.TargetBoardFlagSync:on_client_event(function(p1) --[[ Line: 45 | Upvalues: v3 (copy) ]]
		v3:_sync(p1.target_board_flags, p1.cycle_timestamp)
	end))
	v1:GiveTask(RunService.Heartbeat:Connect(function(p1) --[[ Line: 49 | Upvalues: v3 (copy) ]]
		v3:_update_countdown(p1)
	end))
	SkydivingNetService.RequestTargetBoardFlagSync:fire_server({})

	return v3
end
function t._sync(p1, p2, p3) --[[ _sync | Line: 58 | Upvalues: GameplayFX (copy), SpawnPoof (copy), Players (copy), SoundPlayer (copy) ]]
	p1._cycle_timestamp = p3

	for v1, v2 in p1._target_board_flags do
		if not p2[v1] then
			GameplayFX.emit_particle_group(SpawnPoof, v2.position)
			v2.model:Destroy()
			p1._target_board_flags[v1] = nil
		end
	end

	for v3, v4 in p2 do
		local v5 = p1._target_board_flags[v3]

		if v5 then
			if v5.position ~= v4.position then
				GameplayFX.emit_particle_group(SpawnPoof, v5.position)
				v5.model:PivotTo(CFrame.new(v4.position))
				v5.position = v4.position
				GameplayFX.emit_particle_group(SpawnPoof, v4.position)

				if v3 == tostring(Players.LocalPlayer.UserId) then
					SoundPlayer.FX:play("SkydivingFlag")
				end
			end

			if v5.color ~= v4.color then
				p1:_apply_color(v5.model, v4.color)
				v5.color = v4.color
			end

			continue
		end

		p1:_create_flag(v3, v4)
	end

	if not p1._parachute_fade then
		return
	end

	p1:_apply_fade()
end
function t._create_flag(p1, p2, p3) --[[ _create_flag | Line: 95 | Upvalues: SkyDivingFlag (copy), Players (copy), SoundPlayer (copy), GameplayFX (copy), SpawnPoof (copy) ]]
	local v1 = SkyDivingFlag:Clone()

	v1.Name = "Flag_" .. p2
	v1:PivotTo(CFrame.new(p3.position))

	for v2, v3 in v1:GetDescendants() do
		if v3:IsA("BasePart") then
			v3.CanCollide = false
			v3.CanTouch = false
			v3.CanQuery = false
			v3.Anchored = true
		end
	end

	p1:_apply_color(v1, p3.color)

	local v4 = tostring(Players.LocalPlayer.UserId)

	if p2 == v4 then
		v1:ScaleTo(1.5)
		SoundPlayer.FX:play("SkydivingFlag")
	end

	v1.Parent = p1._flag_folder
	GameplayFX.emit_particle_group(SpawnPoof, p3.position)

	local v5 = v1:FindFirstChildWhichIsA("BillboardGui", true)
	local v6 = nil

	if v5 and p2 == v4 then
		v5.Enabled = true
		v6 = v5:FindFirstChildWhichIsA("TextLabel")
	elseif v5 then
		v5:Destroy()
		v5 = nil
	end

	p1._target_board_flags[p2] = {
		model = v1,
		color = p3.color,
		position = p3.position,
		display_name = p3.display_name,
		billboard = v5,
		text_label = v6
	}
end
function t._apply_color(p1, p2, p3) --[[ _apply_color | Line: 143 | Upvalues: ColorThemeDB (copy) ]]
	local v1 = ColorThemeDB.themes[p3]

	if not v1 then
		return
	end

	local Base = p2:FindFirstChild("Base")
	local Pole = p2:FindFirstChild("Pole")
	local Beam = Pole:FindFirstChild("Beam")

	if Base then
		Base.Color = v1.saturated
	end

	if Pole then
		Pole.Color = v1.saturated
	end

	if not Beam then
		return
	end

	local medium_dark = v1.medium_dark
	local v2 = Color3.new(medium_dark.R * 0.5, medium_dark.G * 0.5, medium_dark.B * 0.5)

	Beam.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, v1.medium_light),
		ColorSequenceKeypoint.new(0.339, v2),
		ColorSequenceKeypoint.new(0.5, v2),
		ColorSequenceKeypoint.new(1, v1.medium_light)
	})
end
function t._update_countdown(p1, p2) --[[ _update_countdown | Line: 174 | Upvalues: Players (copy), CYCLE_DURATION (copy), LiveOpsTime (copy) ]]
	p1._countdown_timer = p1._countdown_timer + p2

	if p1._countdown_timer < 1 then
		return
	end

	p1._countdown_timer = 0

	local v1 = p1._target_board_flags[tostring(Players.LocalPlayer.UserId)]

	if v1 and v1.text_label then
		local v3 = math.max(0, p1._cycle_timestamp + CYCLE_DURATION - LiveOpsTime.now())
		local v4 = math.floor(v3 / 60)

		v1.text_label.Text = string.format("%d:%02d", v4, (math.floor(v3 % 60)))
	end
end
function t.set_parachute_fade(p1, p2) --[[ set_parachute_fade | Line: 192 ]]
	if p1._parachute_fade ~= p2 then
		p1._parachute_fade = p2
		p1:_apply_fade()
	end
end
function t._apply_fade(p1) --[[ _apply_fade | Line: 200 | Upvalues: Players (copy) ]]
	local v1 = tostring(Players.LocalPlayer.UserId)
	local v2 = if p1._parachute_fade then 0.5 else 0

	for v3, v4 in p1._target_board_flags do
		if v3 ~= v1 then
			local Base = v4.model:FindFirstChild("Base")
			local Pole = v4.model:FindFirstChild("Pole")

			if Base then
				Base.Transparency = v2
			end

			if Pole then
				Pole.Transparency = v2
			end
		end
	end
end
function t.destroy(p1) --[[ destroy | Line: 220 ]]
	p1._target_board_flags = {}
	p1._maid:DoCleaning()
end

return t

