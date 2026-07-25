-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LiveOpsTime = require(ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local React = require(game.ReplicatedStorage.SharedPackages.React)
local TweenHelper = require(ReplicatedStorage.SharedModules.TweenHelper)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local ColorThemeContext = require(ReplicatedStorage.new.modules.ReactShared.Contexts.ColorThemeContext)
local v1 = UDim2.fromScale(0.535, 0.515)
local v2 = Color3.new(255/255, 255/255, 255/255)
local v3 = Color3.new(0/255, 0/255, 0/255)
local v4 = TweenHelper.tween_info({
	time = 0.25,
	easing_style = Enum.EasingStyle.Linear
})

local function ease_pop(p1) --[[ ease_pop | Line: 26 | Upvalues: TweenService (copy) ]]
	return TweenService:GetValue(p1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function format_time(p1) --[[ format_time | Line: 37 ]]
	local v1 = math.max(0, p1)
	local v2 = math.floor(v1 / 60)

	return string.format("%02d:%02d", v2, (math.floor(v1 % 60)))
end

local function CountdownTimer(p1) --[[ CountdownTimer | Line: 44 | Upvalues: React (copy), format_time (copy), ColorThemeContext (copy), ease_pop (copy), LiveOpsTime (copy), RunService (copy), TweenPromise (copy), v4 (copy), v2 (copy), v1 (copy), v3 (copy) ]]
	local v12, v22 = React.useBinding(format_time(p1.duration))
	local v32, v42 = React.useState(false)
	local v5, v6 = React.useBinding(0)
	local v7 = React.useRef(nil)
	local v8, v9 = React.useBinding(0)
	local v10 = React.useRef(nil)
	local v11 = React.useRef(false)
	local v122 = ColorThemeContext.use_color_theme()
	local v13 = React.useMemo(function() --[[ Line: 54 | Upvalues: React (ref), v5 (copy), ease_pop (ref), v8 (copy) ]]
		React.joinBindings({
			alpha = v5:map(ease_pop),
			check = v8
		}):map(function(p1) --[[ Line: 58 ]]
			return p1.alpha + (1 - p1.check)
		end)
	end, {})

	React.useEffect(function() --[[ Line: 64 | Upvalues: v42 (copy), v22 (copy), format_time (ref), p1 (copy), LiveOpsTime (ref), RunService (ref) ]]
		v42(false)
		v22(format_time(p1.duration))

		local v1 = LiveOpsTime.now() + p1.duration
		local v2 = nil

		v2 = RunService.Heartbeat:Connect(function() --[[ Line: 70 | Upvalues: v1 (copy), LiveOpsTime (ref), v22 (ref), format_time (ref), v42 (ref), p1 (ref), v2 (ref) ]]
			local v23 = math.max(0, v1 - LiveOpsTime.now())

			v22(format_time(v23))

			if not (v23 <= 0) then
				return
			end

			v42(true)

			if p1.on_complete then
				p1.on_complete()
			end

			v2:Disconnect()
		end)

		return function() --[[ Line: 82 | Upvalues: v2 (ref) ]]
			v2:Disconnect()
		end
	end, { p1.duration })
	React.useEffect(function() --[[ Line: 89 | Upvalues: v10 (copy), v32 (copy), TweenPromise (ref), v8 (copy), v4 (ref), v9 (copy) ]]
		if v10.current then
			v10.current:cancel()
		end

		v10.current = TweenPromise.callback(v8:getValue(), if v32 then 1 else 0, v4, v9)

		return function() --[[ Line: 97 | Upvalues: v10 (ref) ]]
			if not v10.current then
				return
			end

			v10.current:cancel()
		end
	end, { v32 })

	local isNotIn_range = p1.in_range ~= false

	React.useLayoutEffect(function() --[[ Line: 106 | Upvalues: v7 (copy), isNotIn_range (copy), v11 (copy), v6 (copy), TweenPromise (ref), v5 (copy), v4 (ref) ]]
		if v7.current then
			v7.current:cancel()
		end

		local v1 = if isNotIn_range then 1 else 0

		if v11.current then
			v7.current = TweenPromise.callback(v5:getValue(), v1, v4, v6)

			return function() --[[ Line: 120 | Upvalues: v7 (ref) ]]
				if not v7.current then
					return
				end

				v7.current:cancel()
			end
		end

		v11.current = true
		v6(v1)
	end, { isNotIn_range })

	local createElement = React.createElement
	local t = {
		LayoutOrder = p1.layout_order,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		BackgroundColor3 = v2
	}
	local t2 = {
		Scale = React.createElement("UIScale", {
			Scale = v13
		}),
		Corner = React.createElement("UICorner", {
			CornerRadius = UDim.new(1, 0)
		}),
		Stroke = React.createElement("UIStroke", {
			Thickness = 2,
			Color = v122.saturated,
			ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		})
	}
	local createElement2 = React.createElement
	local t3 = {}

	t3.PaddingLeft = UDim.new(0, if v32 then 4 else 10)
	t3.PaddingRight = UDim.new(0, if v32 then 4 else 12)
	t3.PaddingTop = UDim.new(0, 4)
	t3.PaddingBottom = UDim.new(0, 4)
	t2.Padding = createElement2("UIPadding", t3)
	t2.Layout = React.createElement("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		VerticalAlignment = Enum.VerticalAlignment.Center,
		SortOrder = Enum.SortOrder.LayoutOrder,
		Padding = UDim.new(0, 6)
	})
	t2.Icon = React.createElement("ImageLabel", {
		LayoutOrder = 1,
		BackgroundTransparency = 1,
		Image = "rbxassetid://14453643562",
		Size = UDim2.fromOffset(20, 20),
		ImageColor3 = v122.saturated
	}, {
		Check = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxassetid://14370703836",
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = v1,
			Size = UDim2.fromScale(1.25, 1.25),
			ImageTransparency = v8:map(function(p1) --[[ Line: 172 ]]
				return 1 - p1 * 0.75
			end)
		})
	})
	t2.Time = React.createElement("TextLabel", {
		LayoutOrder = 2,
		BackgroundTransparency = 1,
		TextSize = 20,
		TextStrokeTransparency = 1,
		Size = UDim2.fromScale(0, 0),
		AutomaticSize = Enum.AutomaticSize.XY,
		Font = Enum.Font.GothamBold,
		Text = v12,
		TextColor3 = v3,
		Visible = v8:map(function(p1) --[[ Line: 188 ]]
			return p1 <= 0
		end)
	}, {
		Scale = React.createElement("UIScale", {
			Scale = v8:map(function(p1) --[[ Line: 193 ]]
				return 1 - p1
			end)
		})
	})

	return createElement("Frame", t, t2)
end

return React.memo(CountdownTimer)