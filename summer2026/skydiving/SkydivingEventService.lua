-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingEventService
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local SharedModules = ReplicatedStorage.SharedModules
local AdminAbuse = require(ReplicatedStorage.new.modules.AdminAbuse)
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local SkydivingLeaderboard = require(script.Parent.SkydivingLeaderboard)
local SkydivingNetService = require(script.Parent.SkydivingNetService)
local LiveOpsTime = require(SharedModules.Game.LiveOpsTime)
local Maid = require(SharedModules.Maid)
local Signal = require(SharedModules.Signal)
local CYCLE_DURATION = SkydivingConstants.CYCLE_DURATION
local t = {}
local v1 = 0
local t2 = {}
local t3 = {}
local v2 = Maid.new()

t.cycle_changed = Signal.new()
t.temporary_rings_changed = Signal.new()

local function calculate_cycle_timestamp(p1) --[[ calculate_cycle_timestamp | Line: 42 | Upvalues: CYCLE_DURATION (copy) ]]
	return p1 - p1 % CYCLE_DURATION
end

local v3 = nil
local v4 = nil

local function move_ring_positions_to_server_storage() --[[ move_ring_positions_to_server_storage | Line: 49 | Upvalues: v3 (ref) ]]
	local RingPositions = game.ServerStorage.Downloadable.Interiors["MainMap!Summerfest"].Skydiving.RingPositions

	RingPositions.Parent = game:GetService("ServerStorage")
	v3 = RingPositions
end

local function cache_target_center_position() --[[ cache_target_center_position | Line: 55 | Upvalues: v4 (ref) ]]
	local TargetCenter = game.ServerStorage.Downloadable.Interiors["MainMap!Summerfest"].Event.Skydiving.TargetCenter

	assert(TargetCenter:IsA("BasePart"), "Skydiving TargetCenter must be a BasePart")
	v4 = TargetCenter.Position
end

local function select_rings_for_cycle() --[[ select_rings_for_cycle | Line: 61 | Upvalues: v3 (ref), HttpService (copy) ]]
	local t = {}

	if not v3 then
		return t
	end

	for v1, v2 in v3:GetChildren() do
		if v2:IsA("Folder") or v2:IsA("Model") then
			local v32 = v2.Name

			for v4, v5 in v2:GetChildren() do
				if v5:IsA("BasePart") then
					local v6 = HttpService:GenerateGUID(false)

					t[v6] = {
						temporary = false,
						special = false,
						id = v6,
						group_id = v32,
						cframe = v5.CFrame
					}
				end
			end
		end
	end

	return t
end

local function get_ring_bounds() --[[ get_ring_bounds | Line: 96 | Upvalues: t2 (ref) ]]
	local v1 = nil
	local v2 = nil

	for v3, v4 in t2 do
		local Position = v4.cframe.Position

		if v1 then
			v1, v2 = Vector3.new(math.min(v1.X, Position.X), math.min(v1.Y, Position.Y), (math.min(v1.Z, Position.Z))), Vector3.new(math.max(v2.X, Position.X), math.max(v2.Y, Position.Y), (math.max(v2.Z, Position.Z)))

			continue
		end

		v1, v2 = Position, Position
	end

	return v1, v2
end

local function inject_aa_temporary_rings(p1) --[[ inject_aa_temporary_rings | Line: 111 | Upvalues: AdminAbuse (copy), get_ring_bounds (copy), v1 (ref), HttpService (copy) ]]
	local v12 = AdminAbuse.get_value("skydiving_temporary_rings")

	if not v12 or (typeof(v12) ~= "number" or v12 <= 0) then
		return
	end

	local v2, v3 = get_ring_bounds()

	if not (v2 and v3) then
		return
	end

	local v4 = Random.new(v1)
	local v5 = math.floor(v12)
	local v6 = v5

	for i = 1, v5 do
		local v8 = v2.Y + (if v6 == 1 then 0.5 else (i - 1) / (v6 - 1)) * (v3.Y - v2.Y)
		local v9 = v4:NextNumber(v2.X, v3.X)
		local v10 = v4:NextNumber(v2.Z, v3.Z)
		local v11 = ("aa_temporary_%*"):format((HttpService:GenerateGUID(false)))

		p1[v11] = {
			group_id = "aa_temporary",
			temporary = true,
			special = false,
			id = v11,
			cframe = CFrame.new(v9, v8, v10) * CFrame.Angles(v4:NextNumber(-3.141592653589793, math.pi), v4:NextNumber(-3.141592653589793, math.pi), v4:NextNumber(-3.141592653589793, math.pi))
		}
	end
end

local function broadcast_target_board_flags() --[[ broadcast_target_board_flags | Line: 146 | Upvalues: SkydivingNetService (copy), t3 (ref), v1 (ref) ]]
	SkydivingNetService.TargetBoardFlagSync:fire_all_clients({
		target_board_flags = t3,
		cycle_timestamp = v1
	})
end

local function remove_temporary_rings() --[[ remove_temporary_rings | Line: 153 | Upvalues: t2 (ref) ]]
	for v1, v2 in t2 do
		if v2.temporary then
			t2[v1] = nil
		end
	end
end

local function refresh_temporary_rings() --[[ refresh_temporary_rings | Line: 161 | Upvalues: t2 (ref), inject_aa_temporary_rings (copy), t (copy) ]]
	for v1, v2 in t2 do
		if v2.temporary then
			t2[v1] = nil
		end
	end

	inject_aa_temporary_rings(t2)
	t.temporary_rings_changed:Fire()
end

local function start_cycle(p1) --[[ start_cycle | Line: 167 | Upvalues: LiveOpsTime (copy), v1 (ref), CYCLE_DURATION (copy), t2 (ref), select_rings_for_cycle (copy), inject_aa_temporary_rings (copy), t3 (ref), t (copy), SkydivingNetService (copy) ]]
	local v12 = LiveOpsTime.now()

	v1 = v12 - v12 % CYCLE_DURATION
	t2 = select_rings_for_cycle()
	inject_aa_temporary_rings(t2)
	t3 = {}
	t.cycle_changed:Fire(v1, p1)
	SkydivingNetService.TargetBoardFlagSync:fire_all_clients({
		target_board_flags = t3,
		cycle_timestamp = v1
	})
end

function t.get_cycle_data() --[[ get_cycle_data | Line: 178 | Upvalues: v1 (ref), t2 (ref) ]]
	return {
		cycle_timestamp = v1,
		rings = t2
	}
end
function t.get_current_cycle_timestamp() --[[ get_current_cycle_timestamp | Line: 185 | Upvalues: v1 (ref) ]]
	return v1
end
function t.get_ring(p1) --[[ get_ring | Line: 189 | Upvalues: t2 (ref) ]]
	return t2[p1]
end
function t.get_target_center_position() --[[ get_target_center_position | Line: 193 | Upvalues: v4 (ref) ]]
	assert(v4, "Skydiving target center was not cached")

	return v4
end
function t.is_cycle_valid(p1) --[[ is_cycle_valid | Line: 198 | Upvalues: v1 (ref) ]]
	return p1 == v1
end
function t.update_target_board_flag(p1, p2, p3) --[[ update_target_board_flag | Line: 202 | Upvalues: t3 (ref), SkydivingNetService (copy), v1 (ref) ]]
	t3[tostring(p1.UserId)] = {
		position = p2,
		color = p3,
		display_name = p1.DisplayName
	}
	SkydivingNetService.TargetBoardFlagSync:fire_all_clients({
		target_board_flags = t3,
		cycle_timestamp = v1
	})
end
function t.remove_target_board_flag(p1) --[[ remove_target_board_flag | Line: 212 | Upvalues: t3 (ref), SkydivingNetService (copy), v1 (ref) ]]
	local v12 = tostring(p1.UserId)

	if not t3[v12] then
		return
	end

	t3[v12] = nil
	SkydivingNetService.TargetBoardFlagSync:fire_all_clients({
		target_board_flags = t3,
		cycle_timestamp = v1
	})
end
function t.sync_target_board_flags_to_player(p1) --[[ sync_target_board_flags_to_player | Line: 220 | Upvalues: SkydivingNetService (copy), t3 (ref), v1 (ref) ]]
	SkydivingNetService.TargetBoardFlagSync:fire_client(p1, {
		target_board_flags = t3,
		cycle_timestamp = v1
	})
end
function t.start() --[[ start | Line: 227 | Upvalues: RunService (copy), v3 (ref), v4 (ref), SkydivingLeaderboard (copy), start_cycle (copy), SkydivingConstants (copy), v2 (copy), LiveOpsTime (copy), CYCLE_DURATION (copy), v1 (ref), AdminAbuse (copy), t2 (ref), inject_aa_temporary_rings (copy), t (copy), SkydivingNetService (copy), Players (copy) ]]
	assert(RunService:IsServer(), "SkydivingEventService can only run on the server")

	local RingPositions = game.ServerStorage.Downloadable.Interiors["MainMap!Summerfest"].Skydiving.RingPositions

	RingPositions.Parent = game:GetService("ServerStorage")
	v3 = RingPositions

	local TargetCenter = game.ServerStorage.Downloadable.Interiors["MainMap!Summerfest"].Event.Skydiving.TargetCenter

	assert(TargetCenter:IsA("BasePart"), "Skydiving TargetCenter must be a BasePart")
	v4 = TargetCenter.Position
	SkydivingLeaderboard.start()
	start_cycle(SkydivingConstants.START_SOURCE.CYCLE)
	v2:GiveTask(RunService.Heartbeat:Connect(function() --[[ Line: 235 | Upvalues: LiveOpsTime (ref), CYCLE_DURATION (ref), v1 (ref), start_cycle (ref), SkydivingConstants (ref) ]]
		local v12 = LiveOpsTime.now()

		if v12 - v12 % CYCLE_DURATION == v1 then
			return
		end

		start_cycle(SkydivingConstants.START_SOURCE.CYCLE)
	end))
	v2:GiveTask(AdminAbuse.get_changed_signal("skydiving_force_respawn"):connect(function() --[[ Line: 244 | Upvalues: start_cycle (ref), SkydivingConstants (ref) ]]
		start_cycle(SkydivingConstants.START_SOURCE.ADMIN_ABUSE)
	end))
	v2:GiveTask(AdminAbuse.get_changed_signal("skydiving_temporary_rings"):connect(function() --[[ Line: 248 | Upvalues: t2 (ref), inject_aa_temporary_rings (ref), t (ref) ]]
		for v1, v2 in t2 do
			if v2.temporary then
				t2[v1] = nil
			end
		end

		inject_aa_temporary_rings(t2)
		t.temporary_rings_changed:Fire()
	end))
	v2:GiveTask(SkydivingNetService.RequestTargetBoardFlagSync:on_server_event(function(p1, p2) --[[ Line: 252 | Upvalues: t (ref) ]]
		t.sync_target_board_flags_to_player(p1)
	end))
	v2:GiveTask(Players.PlayerRemoving:Connect(function(p1) --[[ Line: 256 | Upvalues: t (ref) ]]
		t.remove_target_board_flag(p1)
	end))
end
function t.destroy() --[[ destroy | Line: 261 | Upvalues: v2 (copy) ]]
	v2:DoCleaning()
end

return t

