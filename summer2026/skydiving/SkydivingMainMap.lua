-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingMainMap
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SharedModules = ReplicatedStorage.SharedModules
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local SkydivingCurrencyPileApp = require(script.Parent.SkydivingCurrencyPileApp)
local SkydivingFlagRenderer = require(script.Parent.SkydivingFlagRenderer)
local SkydivingLeaderboardApp = require(script.Parent.SkydivingLeaderboardApp)
local SkydivingTimeTrialApp = require(script.Parent.SkydivingTimeTrialApp)
local SkydivingNetService = require(script.Parent.SkydivingNetService)
local SkydivingUtilities = require(script.Parent.SkydivingUtilities)
local AltCurrencyData = require(SharedModules.SharedDB.AltCurrencyData)
local AdminAbuse = require(ReplicatedStorage.new.modules.AdminAbuse)
local TimeZoneHelper = require(ReplicatedStorage.SharedModules.TimeZoneHelper)
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local GameplayFX = require(SharedModules.GameplayFX)
local LiveOpsTime = require(SharedModules.Game.LiveOpsTime)
local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local Maid = require(SharedModules.Maid)
local v1 = false
local v2 = 0
local v3 = -1
local v4 = false
local t = {}

local function format_time(p1) --[[ format_time | Line: 36 ]]
	return string.format("%d:%06.3f", math.floor(p1 / 60), p1 % 60)
end

local function wait_for_dive_to_end(p1) --[[ wait_for_dive_to_end | Line: 42 ]]
	while p1.skydiving_client do
		task.wait()
	end
end

local function is_time_trial_enabled() --[[ is_time_trial_enabled | Line: 48 | Upvalues: ClientData (copy) ]]
	local v1 = ClientData.get("skydiving_manager")

	return if v1 then v1.time_trial_enabled or false else false
end

local function can_show_collect_reminder(p1, p2, p3, p4) --[[ can_show_collect_reminder | Line: 53 | Upvalues: ClientData (copy), v1 (ref), v4 (ref), v3 (ref), v2 (ref) ]]
	local v12

	if p2 > 0 then
		v12 = not p3

		if v12 then
			v12 = not p4

			if v12 then
				v12 = not p1.skydiving_client

				if v12 then
					local v22 = ClientData.get("skydiving_manager")

					v12 = not (if v22 then v22.time_trial_enabled or false else false) and (not p1._skydiving_awaiting_tt_result and (not v1 and (not v4 and v3 ~= v2)))
				end
			end
		end
	else
		v12 = false
	end

	return v12
end

local function prompt_retry(p1, p2) --[[ prompt_retry | Line: 67 | Upvalues: UIManager (copy), SkydivingNetService (copy) ]]
	if UIManager.apps.DialogApp:dialog({
		left = "No",
		right = "Yes",
		text = p1
	}) == "Yes" then
		SkydivingNetService.ToggleTimeTrial:fire_server({
			enabled = true
		})
		p2._skydiving_awaiting_tt_result = true

		return true
	end

	p2._skydiving_awaiting_tt_result = false

	return false
end

local function show_time_trial_result(p1, p2) --[[ show_time_trial_result | Line: 83 | Upvalues: format_time (copy), prompt_retry (copy) ]]
	local v1

	if p1.is_new_best then
		local v2 = p1.time

		v1 = "You got a new Personal Best in the Time Trial!\n" .. string.format("%d:%06.3f", math.floor(v2 / 60), v2 % 60)
	else
		local v4 = string.format("You completed the Time Trial with %s!", format_time(p1.time))

		if p1.best_time then
			local best_time = p1.best_time

			v1 = v4 .. "\nYour Personal Best is " .. string.format("%d:%06.3f", math.floor(best_time / 60), best_time % 60)
		else
			v1 = v4
		end
	end

	prompt_retry(v1 .. "\nRetry?", p2)
end

local function toggle_visuals(p1) --[[ toggle_visuals | Line: 98 ]]
	for v1, v2 in game:GetService("CollectionService"):GetTagged("show_when_skydiving") do
		if v2:IsA("BasePart") then
			v2.Transparency = if p1 then 0 else 1

			continue
		end

		if v2:IsA("Beam") then
			v2.Enabled = p1
		end
	end
end

local function start_dive(p1, p2, p3) --[[ start_dive | Line: 109 | Upvalues: toggle_visuals (copy), ClientData (copy), v2 (ref) ]]
	if p2.skydiving_client then
		return
	end

	toggle_visuals(true)

	local v1 = ClientData.get("skydiving_manager")
	local v22 = v1 and v1.time_trial_enabled or false

	p2._skydiving_awaiting_tt_result = v22
	p2._skydiving_tt_result_received = false
	p2._skydiving_session_ended_at = nil
	v2 = v2 + 1

	local v3 = require(script.Parent.SkydivingClient).new(function(p1) --[[ Line: 123 | Upvalues: p2 (copy), toggle_visuals (ref) ]]
		p2.skydiving_client = nil
		p2.skydiving_returned_to_airship = if p1 then p1.teleported_back or false else false
		toggle_visuals(false)
	end, p2.flag_renderer, v22)

	p2.skydiving_client = v3
	task.spawn(function() --[[ Line: 129 | Upvalues: v3 (copy), p1 (copy), p3 (copy) ]]
		v3:start_dive(p1, p3)
	end)
end

function t.render(p1, p2) --[[ render | Line: 134 | Upvalues: toggle_visuals (copy), Maid (copy), SkydivingFlagRenderer (copy), SkydivingLeaderboardApp (copy), ReactRoblox (copy), React (copy), SkydivingCurrencyPileApp (copy), SkydivingConstants (copy), RunService (copy), ClientData (copy), LiveOpsTime (copy), Players (copy), SkydivingUtilities (copy), SkydivingNetService (copy), ReplicatedStorage (copy), AltCurrencyData (copy), GameplayFX (copy), v1 (ref), v4 (ref), v3 (ref), v2 (ref), UIManager (copy), SkydivingTimeTrialApp (copy), show_time_trial_result (copy), prompt_retry (copy), TimeZoneHelper (copy), AdminAbuse (copy), start_dive (copy) ]]
	if p2.skydiving_maid then
		p2.skydiving_maid:DoCleaning()
	end

	toggle_visuals(false)

	local v12 = Maid.new()

	p2.skydiving_maid = v12
	p2.skydiving_client = nil
	p2.flag_renderer = SkydivingFlagRenderer.new()
	v12:GiveTask(p2.flag_renderer)

	local Skydiving = p1.Skydiving
	local Frame = Skydiving.SkydivingLeaderboard.Sign.SurfaceGui.Frame

	SkydivingLeaderboardApp.mount(Frame, Frame.LeaderboardEntry, function(p1) --[[ Line: 152 | Upvalues: v12 (copy) ]]
		v12:GiveTask(p1)
	end)

	local SkydivingCurrencyPile = Skydiving.SkydivingCurrencyPile
	local CurrencyCollectionSign = SkydivingCurrencyPile.CurrencyCollectionSign
	local v22 = ReactRoblox.createRoot(CurrencyCollectionSign.BillboardGui)

	v22:render(React.createElement(SkydivingCurrencyPileApp, {
		currency_piles_folder = SkydivingCurrencyPile.CurrencyPiles,
		collection_sign_part = CurrencyCollectionSign
	}))
	v12:GiveTask(function() --[[ Line: 165 | Upvalues: v22 (copy) ]]
		v22:unmount()
	end)

	local CollectionCircle = SkydivingCurrencyPile.CollectionCircle
	local v32 = 0
	local v42 = Skydiving.TargetBoard[SkydivingConstants.ACORN_REMINDER_SUPPRESS_ZONE_NAME]

	v42.CanCollide = false
	v42.CanQuery = false
	v42.Transparency = 1
	v12:GiveTask(RunService.Heartbeat:Connect(function() --[[ Line: 176 | Upvalues: p2 (copy), ClientData (ref), LiveOpsTime (ref), Players (ref), SkydivingUtilities (ref), CollectionCircle (copy), v42 (copy), v32 (ref), SkydivingNetService (ref), ReplicatedStorage (ref), AltCurrencyData (ref), GameplayFX (ref), v1 (ref), v4 (ref), v3 (ref), v2 (ref), UIManager (ref) ]]
		if p2._skydiving_awaiting_tt_result then
			local v12 = ClientData.get("skydiving_manager")

			if not ((if v12 then v12.in_session or false else false) or p2._skydiving_tt_result_received) then
				if p2._skydiving_session_ended_at then
					if LiveOpsTime.now() - p2._skydiving_session_ended_at > 3 then
						p2._skydiving_awaiting_tt_result = false
					end
				else
					p2._skydiving_session_ended_at = LiveOpsTime.now()
				end
			end
		end

		local v33 = ClientData.get("skydiving_manager")
		local v43 = if v33 then v33.pending_currency or 0 else 0
		local v5 = Players.LocalPlayer.Character and Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

		if not v5 then
			return
		end

		local v6 = SkydivingUtilities.is_at_collection_circle(CollectionCircle, v5.Position)
		local v7 = SkydivingUtilities.is_character_inside_part(Players.LocalPlayer.Character, v42)
		local v8 = LiveOpsTime.now()

		if v43 > 0 and (v6 and v8 - v32 >= 2) then
			v32 = v8
			SkydivingNetService.CollectCurrency:fire_server()

			local v9 = ReplicatedStorage.Resources.BucksBillboard:Clone()
			local ImageLabel = v9:FindFirstChild("ImageLabel", true)

			if ImageLabel then
				ImageLabel.Image = AltCurrencyData.buy_icon
			end

			GameplayFX.animate_billboard(v9, v5.CFrame.Position + Vector3.new(0, 2, 0), {
				time = 2,
				transform_billboard = function(p1) --[[ transform_billboard | Line: 212 | Upvalues: v43 (copy) ]]
					p1:FindFirstChild("TextLabel", true).Text = "+" .. tostring(v43)
				end
			})
		end

		local v10 = p2
		local v11

		if v43 > 0 then
			v11 = not v6

			if v11 then
				v11 = not v7

				if v11 then
					v11 = not v10.skydiving_client

					if v11 then
						local v12 = ClientData.get("skydiving_manager")

						v11 = not (if v12 then v12.time_trial_enabled or false else false) and (not v10._skydiving_awaiting_tt_result and (not v1 and (not v4 and (if v3 == v2 then false else true))))
					end
				end
			end
		else
			v11 = false
		end

		if not v11 then
			return
		end

		v4 = true

		local v14 = v2

		task.spawn(function() --[[ Line: 222 | Upvalues: p2 (ref), v43 (copy), v6 (copy), v7 (copy), ClientData (ref), v1 (ref), v4 (ref), v3 (ref), v2 (ref), v14 (copy), UIManager (ref), CollectionCircle (ref) ]]
			local v12 = p2
			local v22 = v6
			local v32 = v7
			local v42

			if v43 > 0 then
				v42 = not v22

				if v42 then
					v42 = not v32

					if v42 then
						v42 = not v12.skydiving_client

						if v42 then
							local v5 = ClientData.get("skydiving_manager")

							v42 = not (if v5 then v5.time_trial_enabled or false else false) and (not v12._skydiving_awaiting_tt_result and (not v1 and (not v4 and v3 ~= v2)))
						end
					end
				end
			else
				v42 = false
			end

			if not v42 then
				v4 = false

				return
			end

			v3 = v14

			local v72, v8 = UIManager.apps.DialogApp:dialog({
				text = "You have Acorns to collect! Pick them up now?",
				dialog_type = "CheckboxDialog",
				checkbox_text = "Do not show again this session",
				left = "No",
				right = "Yes"
			})

			v4 = false

			if v8 then
				v1 = true
			end

			if v72 ~= "Yes" then
				return
			end

			UIManager.apps.GuideArrowApp:navigate(p2.destination_id, function() --[[ Line: 241 | Upvalues: CollectionCircle (ref) ]]
				return CollectionCircle.Position
			end, nil, false)
		end)
	end))

	local v5 = Instance.new("Folder")
	local v6 = ReactRoblox.createRoot(v5)

	v6:render(React.createElement(SkydivingTimeTrialApp))
	v12:GiveTask(function() --[[ Line: 252 | Upvalues: v6 (copy), v5 (copy) ]]
		v6:unmount()
		v5:Destroy()
	end)
	v12:GiveTask(SkydivingNetService.TimeTrialResult:on_client_event(function(p1) --[[ Line: 259 | Upvalues: p2 (copy), show_time_trial_result (ref), prompt_retry (ref) ]]
		p2._skydiving_tt_result_received = true
		task.spawn(function() --[[ Line: 261 | Upvalues: p2 (ref), p1 (copy), show_time_trial_result (ref), prompt_retry (ref) ]]
			while p2.skydiving_client do
				task.wait()
			end

			if p1.completed then
				show_time_trial_result(p1, p2)
			else
				prompt_retry("Retry Time Trial?", p2)
			end
		end)
	end))

	local Airship = Skydiving.Airship
	local TimeTrial = Airship:FindFirstChild("TimeTrial")

	if TimeTrial and TimeTrial:IsA("BasePart") then
		TimeTrial.CanQuery = false
		TimeTrial.Transparency = 1
	end

	local LaunchCollider = Airship.LaunchCollider
	local UnixTimestamp = TimeZoneHelper.from_region_datetime("PT", 2026, 6, 20, 9, 30).UnixTimestamp

	local function is_launch_unlocked() --[[ is_launch_unlocked | Line: 282 | Upvalues: AdminAbuse (ref), LiveOpsTime (ref), UnixTimestamp (copy) ]]
		return AdminAbuse.get_value("open_airship_trapdoor") or LiveOpsTime.has_happened(UnixTimestamp)
	end

	LaunchCollider.CanTouch = AdminAbuse.get_value("open_airship_trapdoor") or LiveOpsTime.has_happened(UnixTimestamp)
	v12:GiveTask(AdminAbuse.get_changed_signal("open_airship_trapdoor"):connect(function() --[[ Line: 287 | Upvalues: LaunchCollider (copy), AdminAbuse (ref), LiveOpsTime (ref), UnixTimestamp (copy) ]]
		LaunchCollider.CanTouch = AdminAbuse.get_value("open_airship_trapdoor") or LiveOpsTime.has_happened(UnixTimestamp)
	end))

	if not LaunchCollider.CanTouch then
		v12:GiveTask(LiveOpsTime.delay_until(UnixTimestamp):andThen(function() --[[ Line: 292 | Upvalues: LaunchCollider (copy) ]]
			LaunchCollider.CanTouch = true
		end))
	end

	v12:GiveTask(LaunchCollider.Touched:Connect(function(p12) --[[ Line: 297 | Upvalues: p2 (copy), Players (ref), Airship (copy), start_dive (ref), p1 (copy), LaunchCollider (copy) ]]
		if p2.skydiving_client then
			return
		end

		local Character = Players.LocalPlayer.Character

		if not (Character and p12:IsDescendantOf(Character)) then
			return
		end

		local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

		if not HumanoidRootPart then
			return
		end

		for v1, v2 in Airship.TrapdoorWalls:GetChildren() do
			v2.CanCollide = false
			task.delay(5, function() --[[ Line: 315 | Upvalues: v2 (copy) ]]
				v2.CanCollide = true
			end)
		end

		start_dive(p1, p2, {
			cframe = LaunchCollider.CFrame,
			touch_position = HumanoidRootPart.Position,
			half_size = LaunchCollider.Size / 2
		})
	end))
end
function t.cleanup(p1, p2) --[[ cleanup | Line: 328 ]]
	if p2.skydiving_client then
		p2.skydiving_client:destroy()
		p2.skydiving_client = nil
	end

	if p2.skydiving_maid then
		p2.skydiving_maid:DoCleaning()
		p2.skydiving_maid = nil
	end

	p2.flag_renderer = nil
end

return t

