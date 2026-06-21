-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingLeaderboard
-- ==========================================

-- https://lua.expert/
local MessagingService = game:GetService("MessagingService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local SkydivingNetService = require(script.Parent.SkydivingNetService)
local BaseSyncedValue = require(ReplicatedStorage.new.modules.SyncedValues.BaseSyncedValue)
local v1 = if game.GameId == 0 then false else not RunService:IsStudio()
local TIME_TRIAL_LEADERBOARD_SIZE = SkydivingConstants.TIME_TRIAL_LEADERBOARD_SIZE
local t = {}
local t2 = {}
local t3 = {}
local t4 = {}

for v2, v3 in {} do
	t[v3] = true
end

local function build_sorted_list() --[[ build_sorted_list | Line: 27 | Upvalues: t2 (copy), t3 (copy), TIME_TRIAL_LEADERBOARD_SIZE (copy) ]]
	local t = {}

	for v1, v2 in t2 do
		table.insert(t, v2)
	end

	for v3, v4 in t3 do
		table.insert(t, v4)
	end

	table.sort(t, function(p1, p2) --[[ Line: 37 ]]
		return p1.time < p2.time
	end)

	if not (TIME_TRIAL_LEADERBOARD_SIZE < #t) then
		return t
	end

	local t4 = {}

	for i = 1, TIME_TRIAL_LEADERBOARD_SIZE do
		t4[i] = t[i]
	end

	return t4
end

function t4.submit_time(p1, p2) --[[ submit_time | Line: 52 | Upvalues: t2 (copy), t (copy), v1 (copy), MessagingService (copy), t4 (copy) ]]
	local UserId = p1.UserId
	local v12 = t2[UserId]

	if v12 and v12.time <= p2 then
		return false
	end

	t2[UserId] = {
		is_benchmark = false,
		user_id = UserId,
		display_name = p1.DisplayName,
		time = p2,
		is_admin = t[UserId] or false
	}

	if not (v1 and t[UserId]) then
		t4.broadcast()

		return true
	end

	task.spawn(function() --[[ Line: 69 | Upvalues: MessagingService (ref), UserId (copy), p1 (copy), p2 (copy) ]]
		pcall(function() --[[ Line: 70 | Upvalues: MessagingService (ref), UserId (ref), p1 (ref), p2 (ref) ]]
			MessagingService:PublishAsync("SkydivingTimeTrial", {
				user_id = UserId,
				display_name = p1.DisplayName,
				time = p2
			})
		end)
	end)
	t4.broadcast()

	return true
end
function t4.set_benchmark(p1, p2, p3) --[[ set_benchmark | Line: 84 | Upvalues: t3 (copy), t4 (copy) ]]
	t3[p1] = {
		user_id = 0,
		is_admin = false,
		is_benchmark = true,
		display_name = p2,
		time = p3
	}
	t4.broadcast()
end
function t4.remove_benchmark(p1) --[[ remove_benchmark | Line: 95 | Upvalues: t3 (copy), t4 (copy) ]]
	if not t3[p1] then
		return
	end

	t3[p1] = nil
	t4.broadcast()
end
function t4.remove_player(p1) --[[ remove_player | Line: 102 | Upvalues: t2 (copy), t4 (copy) ]]
	if not t2[p1.UserId] then
		return
	end

	t2[p1.UserId] = nil
	t4.broadcast()
end
function t4.get_sorted_list() --[[ get_sorted_list | Line: 109 | Upvalues: build_sorted_list (copy) ]]
	return build_sorted_list()
end
function t4.get_player_best(p1) --[[ get_player_best | Line: 113 | Upvalues: t2 (copy) ]]
	local v1 = t2[p1.UserId]

	return if v1 then v1.time else v1
end
function t4.broadcast() --[[ broadcast | Line: 118 | Upvalues: SkydivingNetService (copy), build_sorted_list (copy) ]]
	SkydivingNetService.LeaderboardSync:fire_all_clients({
		entries = build_sorted_list()
	})
end
function t4.sync_to_player(p1) --[[ sync_to_player | Line: 124 | Upvalues: SkydivingNetService (copy), build_sorted_list (copy) ]]
	SkydivingNetService.LeaderboardSync:fire_client(p1, {
		entries = build_sorted_list()
	})
end
function t4.start() --[[ start | Line: 130 | Upvalues: v1 (copy), BaseSyncedValue (copy), MessagingService (copy), t2 (copy), t4 (copy), SkydivingNetService (copy) ]]
	if not v1 then
		SkydivingNetService.RequestLeaderboardSync:on_server_event(function(p13, p23) --[[ Line: 157 | Upvalues: t4 (ref) ]]
			t4.sync_to_player(p13)
		end)

		return
	end

	BaseSyncedValue.try_with_backoff(function() --[[ Line: 132 | Upvalues: MessagingService (ref), t2 (ref), t4 (ref) ]]
		MessagingService:SubscribeAsync("SkydivingTimeTrial", function(p1) --[[ Line: 133 | Upvalues: t2 (ref), t4 (ref) ]]
			local Data = p1.Data

			if not (Data and (Data.user_id and Data.time)) then
				return
			end

			local v1 = t2[Data.user_id]

			if v1 and v1.time <= Data.time then
				return
			end

			t2[Data.user_id] = {
				is_admin = true,
				is_benchmark = false,
				user_id = Data.user_id,
				display_name = Data.display_name or "Admin",
				time = Data.time
			}
			t4.broadcast()
		end)
	end)
	SkydivingNetService.RequestLeaderboardSync:on_server_event(function(p13, p23) --[[ Line: 157 | Upvalues: t4 (ref) ]]
		t4.sync_to_player(p13)
	end)
end

return t4

