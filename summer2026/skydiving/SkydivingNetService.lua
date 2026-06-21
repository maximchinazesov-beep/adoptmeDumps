-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingNetService
-- ==========================================

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetEvent = require(ReplicatedStorage.new.modules.Net.NetEvent)
local gt = require(ReplicatedStorage.SharedPackages.gt)
local t = {
	ClaimRings = NetEvent.new({
		request = gt.table({
			ring_ids = gt.array(gt.string({
				bytes = "[0, 100]"
			}))
		}),
		rate = {
			mode = "SlidingWindow",
			seconds = 1,
			limit = 22
		}
	}),
	StartDive = NetEvent.new({
		request = gt.table({}),
		rate = {
			mode = "SlidingWindow",
			seconds = 5,
			limit = 5
		}
	}),
	EndDive = NetEvent.new({
		request = gt.table({
			landing_position = gt.Vector3(),
			landed_on_target = gt.boolean(),
			unreachable_ring_ids = gt.array(gt.string({
				bytes = "[0, 100]"
			}))
		}),
		rate = {
			mode = "SlidingWindow",
			seconds = 5,
			limit = 5
		}
	}),
	ToggleTimeTrial = NetEvent.new({
		request = gt.table({
			enabled = gt.boolean()
		}),
		rate = {
			mode = "SlidingWindow",
			seconds = 1,
			limit = 5
		}
	}),
	SetParachute = NetEvent.new({
		request = gt.table({
			open = gt.boolean()
		}),
		rate = {
			mode = "SlidingWindow",
			seconds = 1,
			limit = 5
		}
	}),
	ClaimRingsResult = NetEvent.new({
		request = gt.table({
			results = gt.array(gt.table({
				ring_id = gt.string({
					bytes = "[0, 100]"
				}),
				accepted = gt.boolean()
			}))
		}),
		rate = {
			mode = "Infinite"
		}
	}),
	TimeTrialResult = NetEvent.new({
		request = gt.table({}),
		rate = {
			mode = "Infinite"
		}
	}),
	LeaderboardSync = NetEvent.new({
		request = gt.table({}),
		rate = {
			mode = "Infinite"
		}
	}),
	RequestLeaderboardSync = NetEvent.new({
		request = gt.table({}),
		rate = {
			mode = "SlidingWindow",
			seconds = 5,
			limit = 5
		}
	}),
	TargetBoardFlagSync = NetEvent.new({
		request = gt.table({}),
		rate = {
			mode = "Infinite"
		}
	}),
	RequestTargetBoardFlagSync = NetEvent.new({
		request = gt.table({}),
		rate = {
			mode = "SlidingWindow",
			seconds = 5,
			limit = 5
		}
	}),
	CollectCurrency = NetEvent.new({
		request = gt.none(),
		rate = {
			mode = "SlidingWindow",
			seconds = 2,
			limit = 3
		}
	})
}

function t.start_server() --[[ start_server | Line: 94 | Upvalues: t (copy) ]]
	local AdminAbuseSummerLaunch = require(script.Parent.Parent.AdminAbuseSummerLaunch)
	local DataM = require(game.ServerScriptService.Modules.Core.DataM.DataM.DataM)

	local function get_manager(p1) --[[ get_manager | Line: 98 | Upvalues: AdminAbuseSummerLaunch (copy), DataM (copy) ]]
		if AdminAbuseSummerLaunch.is_launch_unlocked() then
			return DataM.get(p1, "skydiving_manager")
		end
	end

	t.StartDive:on_server_event(function(p1) --[[ Line: 106 | Upvalues: AdminAbuseSummerLaunch (copy), DataM (copy) ]]
		local v1 = if AdminAbuseSummerLaunch.is_launch_unlocked() then DataM.get(p1, "skydiving_manager") else nil

		if not v1 then
			return
		end

		v1:start_session()
	end)
	t.ClaimRings:on_server_event(function(p1, p2) --[[ Line: 113 | Upvalues: AdminAbuseSummerLaunch (copy), DataM (copy) ]]
		local v1 = if AdminAbuseSummerLaunch.is_launch_unlocked() then DataM.get(p1, "skydiving_manager") else nil

		if not v1 then
			return
		end

		v1:process_ring_claims(p2.ring_ids)
	end)
	t.EndDive:on_server_event(function(p1, p2) --[[ Line: 120 | Upvalues: AdminAbuseSummerLaunch (copy), DataM (copy) ]]
		local v1 = if AdminAbuseSummerLaunch.is_launch_unlocked() then DataM.get(p1, "skydiving_manager") else nil

		if not v1 then
			return
		end

		v1:end_session(p2.landing_position, p2.unreachable_ring_ids, p2.landed_on_target)
	end)
	t.ToggleTimeTrial:on_server_event(function(p1, p2) --[[ Line: 127 | Upvalues: AdminAbuseSummerLaunch (copy), DataM (copy) ]]
		local v1 = if AdminAbuseSummerLaunch.is_launch_unlocked() then DataM.get(p1, "skydiving_manager") else nil

		if not v1 then
			return
		end

		v1:set_time_trial_enabled(p2.enabled)
	end)
	t.SetParachute:on_server_event(function(p1, p2) --[[ Line: 134 | Upvalues: AdminAbuseSummerLaunch (copy), DataM (copy) ]]
		local v1 = if AdminAbuseSummerLaunch.is_launch_unlocked() then DataM.get(p1, "skydiving_manager") else nil

		if not v1 then
			return
		end

		v1:set_parachute_visible(p2.open)
	end)
	t.CollectCurrency:on_server_event(function(p1) --[[ Line: 141 | Upvalues: AdminAbuseSummerLaunch (copy), DataM (copy) ]]
		local v1 = if AdminAbuseSummerLaunch.is_launch_unlocked() then DataM.get(p1, "skydiving_manager") else nil

		if not v1 then
			return
		end

		v1:collect_pending_currency()
	end)
end

return t

