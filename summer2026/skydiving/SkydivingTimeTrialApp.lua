-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingTimeTrialApp
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local LiveOpsTime = require(ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local v1 = Font.new("rbxasset://fonts/families/FredokaOne.json")

local function format_time(p1) --[[ format_time | Line: 13 ]]
	return string.format("%d:%06.3f", math.floor(p1 / 60), p1 % 60)
end

local function SkydivingTimeTrialApp(p1) --[[ SkydivingTimeTrialApp | Line: 19 | Upvalues: React (copy), ClientData (copy), format_time (copy), LiveOpsTime (copy), RunService (copy), ReactRoblox (copy), v1 (copy), Players (copy) ]]
	local v12, v2 = React.useState(function() --[[ Line: 20 | Upvalues: ClientData (ref) ]]
		return ClientData.get("skydiving_manager")
	end)

	React.useEffect(function() --[[ Line: 24 | Upvalues: v2 (copy), ClientData (ref) ]]
		local function update() --[[ update | Line: 25 | Upvalues: v2 (ref), ClientData (ref) ]]
			v2(ClientData.get("skydiving_manager"))
		end

		v2(ClientData.get("skydiving_manager"))

		return ClientData.register_callback("skydiving_manager", update)
	end, {})

	local v3 = v12 and v12.time_trial_enabled or false
	local v4 = v12 and v12.in_session or false
	local v5 = if v12 then v12.time_trial_best_time else v12
	local v6, v7 = React.useBinding("0:00.000")

	React.useEffect(function() --[[ Line: 38 | Upvalues: v3 (copy), v7 (copy), format_time (ref) ]]
		if not v3 then
			return
		end

		v7(format_time(0))
	end, { v3 })
	React.useEffect(function() --[[ Line: 44 | Upvalues: v4 (copy), LiveOpsTime (ref), RunService (ref), v7 (copy), format_time (ref) ]]
		if v4 then
			local v1 = LiveOpsTime.now()
			local v2 = RunService.RenderStepped:Connect(function() --[[ Line: 49 | Upvalues: v7 (ref), format_time (ref), LiveOpsTime (ref), v1 (copy) ]]
				v7(format_time(LiveOpsTime.now() - v1))
			end)

			return function() --[[ Line: 52 | Upvalues: v2 (copy) ]]
				v2:Disconnect()
			end
		end
	end, { v4 })

	if not v3 then
		return nil
	end

	local v8 = if v5 then "PB: " .. string.format("%d:%06.3f", math.floor(v5 / 60), v5 % 60) else nil
	local t = {}
	local t2 = {
		DisplayOrder = 10,
		ResetOnSpawn = false,
		ScreenInsets = Enum.ScreenInsets.DeviceSafeInsets,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	}
	local t3 = {}
	local t4 = {
		BackgroundTransparency = 1,
		Image = "rbxassetid://135586118359344",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0.05),
		ScaleType = Enum.ScaleType.Fit,
		Size = UDim2.fromOffset(261, 161)
	}
	local t5 = {
		timer = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			TextScaled = true,
			AnchorPoint = Vector2.new(0, 0.5),
			AutomaticSize = Enum.AutomaticSize.X,
			FontFace = v1,
			Size = UDim2.fromScale(1, 0.25),
			Text = v6,
			TextColor3 = Color3.new(255/255, 255/255, 255/255)
		}, {
			uIStroke = React.createElement("UIStroke", {
				Thickness = 0.05,
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			})
		}),
		layout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			VerticalAlignment = Enum.VerticalAlignment.Center
		})
	}

	t5.bestTime = if v8 then React.createElement("TextLabel", {
	BackgroundTransparency = 1,
	LayoutOrder = 2,
	TextScaled = true,
	TextStrokeTransparency = 0,
	AutomaticSize = Enum.AutomaticSize.X,
	FontFace = v1,
	Size = UDim2.fromScale(1, 0.145),
	Text = v8,
	TextColor3 = Color3.fromRGB(255, 237, 0)
}, {
	uIStroke = React.createElement("UIStroke", {
		Thickness = 0.1,
		StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
	})
}) else v8
	t5.padding = React.createElement("UIPadding", {
		PaddingTop = UDim.new(0.15, 0)
	})
	t5.uIAspectRatioConstraint = React.createElement("UIAspectRatioConstraint", {
		AspectRatio = 1.2
	})
	t3.container = React.createElement("ImageLabel", t4, t5)
	t.SkydivingTimeTrialHUD = React.createElement("ScreenGui", t2, t3)

	return ReactRoblox.createPortal(t, Players.LocalPlayer.PlayerGui)
end

return React.memo(SkydivingTimeTrialApp)

