-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingManagerServer
-- ==========================================

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerScriptService = game:GetService("ServerScriptService")
local SharedModules = ReplicatedStorage.SharedModules
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local SkydivingEventService = require(script.Parent.SkydivingEventService)
local SkydivingNetService = require(script.Parent.SkydivingNetService)
local SkydivingParachuteHelper = require(script.Parent.SkydivingParachuteHelper)
local AltCurrencyData = require(SharedModules.SharedDB.AltCurrencyData)
local CurrencyServer = require(ServerScriptService.new.modules.Utilities.CurrencyServer)
local SkydivingLeaderboard = require(script.Parent.SkydivingLeaderboard)
local DataM = require(ServerScriptService.Modules.Core.DataM.DataM.DataM)
local LiveOpsTime = require(SharedModules.Game.LiveOpsTime)
local Maid = require(SharedModules.Maid)
local NotificationManager = require(game.ServerScriptService.Modules.Game.NotificationManager)
local ServerRouter = require(ServerScriptService.Modules.Core.ServerRouter)
local SettingsHelper = require(SharedModules.SettingsHelper)
local Stash = require(ServerScriptService.ServerPackages.Stash)
local Resources = ReplicatedStorage:WaitForChild("Resources")
local v1 = CFrame.new()

local function get_parachute_template() --[[ get_parachute_template | Line: 28 | Upvalues: Resources (copy) ]]
	local Skydiving = Resources:FindFirstChild("Skydiving")
	local v1 = if Skydiving then Skydiving:FindFirstChild("SkydivingParachute") else Skydiving

	return if v1 then v1 else Resources:FindFirstChild("SkydivingParachute")
end

local t = {}

t.__index = t

local function build_rings_from_cycle(p1) --[[ build_rings_from_cycle | Line: 74 ]]
	local t = {}

	for v1, v2 in p1.rings do
		t[v1] = {
			scored = false,
			cframe = v2.cframe,
			group_id = v2.group_id,
			temporary = v2.temporary,
			special = v2.special
		}
	end

	return t
end

local function count_scored_rings(p1) --[[ count_scored_rings | Line: 90 ]]
	local count = 0

	for v1, v2 in p1 do
		if v2.scored then
			count = count + 1
		end
	end

	return count
end

local function restore_scored_state(p1, p2) --[[ restore_scored_state | Line: 100 ]]
	for v1, v2 in p1 do
		local v3 = p2[v1]

		if v3 and v3.scored then
			v2.scored = true
		end
	end
end

local function calculate_target_score(p1, p2) --[[ calculate_target_score | Line: 112 | Upvalues: SkydivingConstants (copy) ]]
	local Magnitude = (Vector3.new(p1.X, p2.Y, p1.Z) - p2).Magnitude

	if SkydivingConstants.TARGET_OUTER_RADIUS < Magnitude then
		return 0
	end

	return math.floor((1 - math.clamp(Magnitude / SkydivingConstants.TARGET_OUTER_RADIUS, 0, 1)) * SkydivingConstants.TARGET_MAX_REWARD)
end

local function is_valid_target_landing(p1, p2) --[[ is_valid_target_landing | Line: 125 | Upvalues: SkydivingConstants (copy) ]]
	if (Vector3.new(p1.X, p2.Y, p1.Z) - p2).Magnitude > SkydivingConstants.TARGET_OUTER_RADIUS then
		return false
	end

	return math.abs(p1.Y - p2.Y) <= SkydivingConstants.VALIDATION_LANDING_TOLERANCE
end

local function currency_per_ring(p1) --[[ currency_per_ring | Line: 136 | Upvalues: SkydivingConstants (copy) ]]
	local count = 0

	for v1, v2 in p1 do
		if not v2.temporary then
			count = count + 1
		end
	end

	if count <= 0 then
		return 0
	end

	return math.floor(SkydivingConstants.TOTAL_RING_CURRENCY / count)
end

function t.new(p1, p2) --[[ new | Line: 151 | Upvalues: Maid (copy), t (copy), SkydivingEventService (copy), build_rings_from_cycle (copy), SettingsHelper (copy) ]]
	local v2 = setmetatable({
		cycle_timestamp = 0,
		pending_currency = 0,
		target_best_score = 0,
		target_best_position = nil,
		time_trial_enabled = false,
		time_trial_best_time = nil,
		session = nil,
		_parachute = nil,
		player = p1,
		rings = {},
		maid = Maid.new()
	}, t)
	local v3 = SkydivingEventService.get_cycle_data()
	local cycle_timestamp = v3.cycle_timestamp

	v2.cycle_timestamp = cycle_timestamp
	v2.rings = build_rings_from_cycle(v3)
	v2.pending_currency = if p2 then p2.pending_currency or 0 else 0
	v2.time_trial_best_time = if p2 then p2.time_trial_best_time else nil

	if p2 and p2.cycle_timestamp == cycle_timestamp then
		v2.target_best_score = p2.target_best_score or 0

		local target_best_position = p2.target_best_position

		v2.target_best_position = if target_best_position and typeof(target_best_position) == "table" then Vector3.new(target_best_position[1], target_best_position[2], target_best_position[3]) else target_best_position

		if p2.scored_rings then
			for v10 in p2.scored_rings do
				if v2.rings[v10] then
					v2.rings[v10].scored = true
				end
			end
		end

		if v2.target_best_score > 0 and v2.target_best_position then
			local v11, v12 = SettingsHelper.get_setting_server({
				setting_id = "theme_color",
				player = p1
			})

			SkydivingEventService.update_target_board_flag(p1, v2.target_best_position, if v11 then v12 else nil)
		end
	end

	v2.maid:GiveTask(SkydivingEventService.cycle_changed:Connect(function(p1, p2) --[[ Line: 197 | Upvalues: v2 (copy) ]]
		v2:on_cycle_changed(p1)
	end))
	v2.maid:GiveTask(SkydivingEventService.temporary_rings_changed:Connect(function() --[[ Line: 201 | Upvalues: v2 (copy) ]]
		v2:on_temporary_rings_changed()
	end))

	return v2
end
function t.on_cycle_changed(p1, p2) --[[ on_cycle_changed | Line: 208 | Upvalues: SkydivingEventService (copy), build_rings_from_cycle (copy) ]]
	local v1 = build_rings_from_cycle((SkydivingEventService.get_cycle_data()))

	if p2 == p1.cycle_timestamp then
		local rings = p1.rings

		for v2, v3 in v1 do
			local v4 = rings[v2]

			if v4 and v4.scored then
				v3.scored = true
			end
		end
	end

	p1.cycle_timestamp = p2
	p1.rings = v1
	p1.target_best_score = 0
	p1.target_best_position = nil
	p1:mark_changed()
end
function t.on_temporary_rings_changed(p1) --[[ on_temporary_rings_changed | Line: 223 | Upvalues: SkydivingEventService (copy) ]]
	local v1 = SkydivingEventService.get_cycle_data()

	for v2, v3 in p1.rings do
		if v3.temporary then
			p1.rings[v2] = nil
		end
	end

	for v4, v5 in v1.rings do
		if v5.temporary and not p1.rings[v4] then
			p1.rings[v4] = {
				scored = false,
				temporary = true,
				special = false,
				cframe = v5.cframe,
				group_id = v5.group_id
			}
		end
	end

	p1:mark_changed()
end
function t.set_time_trial_enabled(p1, p2) --[[ set_time_trial_enabled | Line: 247 ]]
	p1.time_trial_enabled = p2
	p1:mark_changed()
end
function t.set_parachute_visible(p1, p2) --[[ set_parachute_visible | Line: 255 | Upvalues: SkydivingParachuteHelper (copy) ]]
	if not p1._parachute then
		return
	end

	if p2 then
		SkydivingParachuteHelper.show(p1._parachute)
	else
		SkydivingParachuteHelper.hide(p1._parachute)
	end
end
function t.spawn_parachute(p1) --[[ spawn_parachute | Line: 268 | Upvalues: Resources (copy), SkydivingParachuteHelper (copy), v1 (copy) ]]
	if p1._parachute then
		return
	end

	local Character = p1.player.Character
	local v12 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character

	if not v12 then
		return
	end

	local Skydiving = Resources:FindFirstChild("Skydiving")
	local v2 = if Skydiving then Skydiving:FindFirstChild("SkydivingParachute") else Skydiving
	local v3 = v2 or Resources:FindFirstChild("SkydivingParachute")

	if not v3 then
		warn("[Skydiving] SkydivingParachute template missing from Resources")

		return
	end

	local v4 = v3:Clone()

	v4.Name = SkydivingParachuteHelper.MODEL_NAME

	local PrimaryPart = v4.PrimaryPart

	if not PrimaryPart then
		warn("[Skydiving] SkydivingParachute has no PrimaryPart; cannot weld")
		v4:Destroy()

		return
	end

	for v5, v6 in v4:GetDescendants() do
		if v6:IsA("BasePart") then
			v6.Anchored = false
			v6.CanCollide = false
			v6.CanQuery = false
			v6.CanTouch = false
			v6.Massless = true
		end
	end

	v4:PivotTo(v12.CFrame * v1)

	local WeldConstraint = Instance.new("WeldConstraint")

	WeldConstraint.Part0 = v12
	WeldConstraint.Part1 = PrimaryPart
	WeldConstraint.Parent = PrimaryPart
	SkydivingParachuteHelper.hide(v4)
	v4.Parent = Character
	p1._parachute = v4
end
function t.despawn_parachute(p1) --[[ despawn_parachute | Line: 323 ]]
	if not p1._parachute then
		return
	end

	p1._parachute:Destroy()
	p1._parachute = nil
end
function t.start_session(p1) --[[ start_session | Line: 330 | Upvalues: LiveOpsTime (copy), SkydivingConstants (copy) ]]
	if p1.session then
		return
	end

	local t = {}

	for v1, v2 in p1.rings do
		t[v1] = table.clone(v2)
	end

	local v3

	if p1.time_trial_enabled then
		v3 = {}

		for v4 in p1.rings do
			v3[v4] = false
		end
	else
		v3 = nil
	end

	local Character = p1.player.Character
	local v5 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
	local t2 = {
		last_claim_time = 0,
		first_ring_time = nil,
		rings_collected = 0,
		rings = t,
		start_time = LiveOpsTime.now(),
		time_trial_enabled = p1.time_trial_enabled,
		time_trial_rings_collected = v3,
		launch_altitude = v5 and v5.Position.Y or nil
	}
	local count = 0

	for v7, v8 in p1.rings do
		if not v8.temporary then
			count = count + 1
		end
	end

	t2.currency_per_ring = if count <= 0 then 0 else math.floor(SkydivingConstants.TOTAL_RING_CURRENCY / count)
	p1.session = t2
	p1:spawn_parachute()
end
function t.process_ring_claims(p1, p2) --[[ process_ring_claims | Line: 370 | Upvalues: LiveOpsTime (copy), SkydivingConstants (copy), SkydivingNetService (copy) ]]
	if not p1.session then
		return
	end

	local t = {}
	local v1 = LiveOpsTime.now()
	local Character = p1.player.Character
	local v2 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
	local v3 = if v2 then v2.Position else v2

	for v4, v5 in p2 do
		local v6 = false
		local v7 = p1.session.rings[v5]

		if v7 then
			local v8 = if v3 then if (v3 - v7.cframe.Position).Magnitude <= SkydivingConstants.VALIDATION_PROXIMITY_RADIUS then true else false else true

			if v8 and (if p1.session.last_claim_time > 0 then if v1 - p1.session.last_claim_time >= SkydivingConstants.VALIDATION_MIN_TIME_BETWEEN_RINGS then true else false else true) then
				if not v7.scored then
					v7.scored = true

					local session = p1.session

					session.rings_collected = session.rings_collected + 1

					if not p1.session.first_ring_time then
						p1.session.first_ring_time = v1
					end

					local v10 = p1.rings[v5]

					if v10 then
						v10.scored = true
					end

					p1.pending_currency = p1.pending_currency + p1.session.currency_per_ring
					v6 = true
				end

				if p1.session.time_trial_rings_collected and not p1.session.time_trial_rings_collected[v5] then
					p1.session.time_trial_rings_collected[v5] = true
					v6 = true
				end

				if v6 then
					p1.session.last_claim_time = v1
				end
			end
		end

		table.insert(t, {
			ring_id = v5,
			accepted = v6
		})
	end

	p1:mark_changed()
	SkydivingNetService.ClaimRingsResult:fire_client(p1.player, {
		results = t
	})
end
function t.exclude_unreachable_rings(p1, p2, p3) --[[ exclude_unreachable_rings | Line: 444 ]]
	local time_trial_rings_collected = p2.time_trial_rings_collected

	if not time_trial_rings_collected then
		return
	end

	local launch_altitude = p2.launch_altitude
	local count = 0
	local count2 = 0

	for v1, v2 in p3 do
		if time_trial_rings_collected[v2] == false then
			local v3 = p1.rings[v2]

			if v3 and (not launch_altitude or launch_altitude < v3.cframe.Position.Y) then
				time_trial_rings_collected[v2] = true
				count = count + 1

				continue
			end

			count2 = count2 + 1
		end
	end

	if count > 0 then
		warn(string.format("[Skydiving] excluded %d unreachable time-trial ring(s) for %s", count, p1.player.Name))
	end

	if not (count2 > 0) then
		return
	end

	warn(string.format("[Skydiving] rejected %d \'unreachable\' ring report(s) at or below launch altitude for %s", count2, p1.player.Name))
end
function t.end_session(p1, p2, p3, p4) --[[ end_session | Line: 486 | Upvalues: LiveOpsTime (copy), SkydivingEventService (copy), SkydivingConstants (copy), SettingsHelper (copy), NotificationManager (copy), SkydivingLeaderboard (copy), SkydivingNetService (copy) ]]
	if p1.session then
		local session = p1.session

		p1.session = nil
		p1:despawn_parachute()

		local v1 = LiveOpsTime.now()
		local v2 = SkydivingEventService.get_target_center_position()
		local player = p1.player

		task.delay(0.5, function() --[[ Line: 505 | Upvalues: p2 (copy), p4 (copy), v2 (copy), SkydivingConstants (ref), p1 (copy), SettingsHelper (ref), player (copy), SkydivingEventService (ref), NotificationManager (ref), session (copy), p3 (copy), v1 (copy), SkydivingLeaderboard (ref), SkydivingNetService (ref) ]]
			local v12 = p2
			local v22

			if p4 == true then
				local v3 = v2

				v22 = if (Vector3.new(v12.X, v3.Y, v12.Z) - v3).Magnitude > SkydivingConstants.TARGET_OUTER_RADIUS then false elseif math.abs(v12.Y - v3.Y) <= SkydivingConstants.VALIDATION_LANDING_TOLERANCE then true else false
			else
				v22 = false
			end

			local v5

			if v22 then
				local v6 = v2
				local Magnitude = (Vector3.new(v12.X, v6.Y, v12.Z) - v6).Magnitude

				v5 = if SkydivingConstants.TARGET_OUTER_RADIUS < Magnitude then 0 else math.floor((1 - math.clamp(Magnitude / SkydivingConstants.TARGET_OUTER_RADIUS, 0, 1)) * SkydivingConstants.TARGET_MAX_REWARD)
			else
				v5 = 0
			end

			if v22 and p1.target_best_score < v5 then
				local v10 = v5 - p1.target_best_score

				p1.target_best_score = v5
				p1.target_best_position = v12

				local v11 = p1

				v11.pending_currency = v11.pending_currency + v10

				local v122 = Vector3.new(v12.X, v2.Y, v12.Z)
				local v13, v14 = SettingsHelper.get_setting_server({
					setting_id = "theme_color",
					player = player
				})

				SkydivingEventService.update_target_board_flag(player, v122, if v13 then v14 else nil)
				NotificationManager.indicate_event({
					name = "sky_diving_target_hit",
					player = p1.player
				})
				p1:mark_changed()
			end

			if not (session.time_trial_enabled and session.time_trial_rings_collected) then
				return
			end

			if p3 then
				p1:exclude_unreachable_rings(session, p3)
			end

			local v17 = true

			for v18, v19 in session.time_trial_rings_collected do
				if not v19 then
					v17 = false

					break
				end
			end

			local v20 = v1 - session.start_time

			if v17 and v22 then
				local time_trial_best_time = p1.time_trial_best_time
				local v21 = not time_trial_best_time or (if v20 < time_trial_best_time then true else false)

				if v21 then
					p1.time_trial_best_time = v20
					SkydivingLeaderboard.submit_time(player, v20)
				end

				SkydivingNetService.TimeTrialResult:fire_client(player, {
					completed = true,
					time = v20,
					is_new_best = v21,
					best_time = p1.time_trial_best_time
				})
				NotificationManager.indicate_event({
					name = "sky_diving_time_trial_completed",
					player = p1.player
				})
				p1:mark_changed()
			else
				SkydivingNetService.TimeTrialResult:fire_client(player, {
					completed = false,
					reason = if v17 then "missed_target" else "rings_missed"
				})
			end
		end)
		p1.time_trial_enabled = false
		p1:mark_changed()
	end
end
function t.collect_pending_currency(p1) --[[ collect_pending_currency | Line: 582 | Upvalues: CurrencyServer (copy), AltCurrencyData (copy), ServerRouter (copy), Stash (copy) ]]
	if p1.pending_currency <= 0 then
		return
	end

	local pending_currency = p1.pending_currency

	p1.pending_currency = 0
	CurrencyServer.modify(AltCurrencyData.name, p1.player, pending_currency, "Summer2026", "SkydivingRings")
	ServerRouter.get("ProductsAPI/CurrencySproutedOutOfCharacterEffect"):FireClient(p1.player, p1.player, "small", AltCurrencyData.name)

	local t = {
		user_id = p1.player.UserId,
		currency = AltCurrencyData.name,
		amount = pending_currency,
		cycle_timestamp = p1.cycle_timestamp
	}
	local count = 0

	for v3, v4 in p1.rings do
		if v4.scored then
			count = count + 1
		end
	end

	t.rings_scored = count
	t.target_best_score = p1.target_best_score
	Stash:log("skydiving_currency_collected", t)
	p1:mark_changed()
end
function t.serialize_for_client_replication(p1) --[[ serialize_for_client_replication | Line: 610 ]]
	local t = {}

	for v1, v2 in p1.rings do
		t[v1] = {
			cframe = v2.cframe,
			group_id = v2.group_id,
			scored = v2.scored,
			temporary = v2.temporary,
			special = v2.special
		}
	end

	local t2 = {
		cycle_timestamp = p1.cycle_timestamp,
		rings = t,
		pending_currency = p1.pending_currency,
		target_best_score = p1.target_best_score,
		target_best_position = p1.target_best_position
	}

	t2.in_session = p1.session ~= nil
	t2.time_trial_enabled = p1.time_trial_enabled
	t2.time_trial_best_time = p1.time_trial_best_time

	return t2
end
function t.serialize_for_save(p1) --[[ serialize_for_save | Line: 634 ]]
	local t = {}

	for v1, v2 in p1.rings do
		if v2.scored then
			t[v1] = true
		end
	end

	local t2 = {
		cycle_timestamp = p1.cycle_timestamp,
		scored_rings = t,
		pending_currency = p1.pending_currency,
		target_best_score = p1.target_best_score
	}

	t2.target_best_position = if p1.target_best_position then { p1.target_best_position.X, p1.target_best_position.Y, p1.target_best_position.Z } else nil
	t2.time_trial_best_time = p1.time_trial_best_time

	return t2
end
function t.mark_changed(p1) --[[ mark_changed | Line: 654 | Upvalues: DataM (copy) ]]
	local v1 = DataM.get_store(p1.player)

	if v1 and not v1.destroyed then
		v1:push_update("skydiving_manager")
	end
end
function t.destroy(p1) --[[ destroy | Line: 663 ]]
	p1:despawn_parachute()
	p1.maid:DoCleaning()
end

return t

