-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local React = require(ReplicatedStorage.SharedPackages.React)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local v1 = NumberSequence.new(0)
local v2 = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.495, 0),
	NumberSequenceKeypoint.new(0.505, 1),
	NumberSequenceKeypoint.new(1, 1)
})
local v3 = React.createElement("UICorner", {
	BottomLeftRadius = UDim.new(0.1, 0),
	BottomRightRadius = UDim.new(0.1, 0),
	TopLeftRadius = UDim.new(0.1, 0),
	TopRightRadius = UDim.new(0.1, 0)
})
local v4 = TweenInfo.new(0.15, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function get_left_rotation(p1) --[[ get_left_rotation | Line: 31 ]]
	if p1 >= 1 then
		return 0
	end

	if p1 > 0.5 then
		return (p1 - 1) * 360
	end

	return 0
end

local function get_right_rotation(p1) --[[ get_right_rotation | Line: 40 ]]
	if p1 >= 1 then
		return 180
	end

	if p1 > 0.5 then
		return 180
	end

	if p1 > 0 then
		return p1 * 360
	end

	return 0
end

local function get_left_transparency(p1) --[[ get_left_transparency | Line: 51 | Upvalues: v1 (copy), v2 (copy) ]]
	if p1 >= 1 then
		return v1
	end

	if p1 > 0.5 then
		return v2
	end

	return v1
end

local function get_right_transparency(p1) --[[ get_right_transparency | Line: 60 | Upvalues: v1 (copy), v2 (copy) ]]
	if p1 >= 1 or p1 > 0.5 then
		return v1
	end

	if p1 > 0 then
		return v2
	end

	return v1
end

return function(p1) --[[ Line: 69 | Upvalues: React (copy), TweenPromise (copy), v4 (copy), get_left_rotation (copy), get_right_rotation (copy), get_left_transparency (copy), get_right_transparency (copy), v3 (copy) ]]
	local v1, v2 = React.useBinding(1)
	local v32 = React.useRef(nil)

	React.useEffect(function() --[[ Line: 73 | Upvalues: v32 (copy), TweenPromise (ref), v4 (ref) ]]
		local v1 = nil

		local function tween_in() --[[ tween_in | Line: 76 | Upvalues: v32 (ref), v1 (ref), TweenPromise (ref), v4 (ref) ]]
			local current = v32.current

			if current then
				current.Scale = 0
				v1 = TweenPromise.new(current, v4, {
					Scale = 1
				})

				return true
			end

			return false
		end

		local current = v32.current
		local v2

		if current then
			current.Scale = 0
			v1 = TweenPromise.new(current, v4, {
				Scale = 1
			})
			v2 = true
		else
			v2 = false
		end

		if v2 then
			return function() --[[ Line: 93 | Upvalues: v1 (ref) ]]
				if not v1 then
					return
				end

				v1:cancel()
			end
		end

		task.defer(tween_in)

		return function() --[[ Line: 93 | Upvalues: v1 (ref) ]]
			if not v1 then
				return
			end

			v1:cancel()
		end
	end, { p1.mount_key })
	React.useEffect(function() --[[ Line: 100 | Upvalues: v2 (copy), TweenPromise (ref), p1 (copy) ]]
		v2(1)

		local v1 = TweenPromise.callback(1, 0, TweenInfo.new(p1.duration, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), function(p1) --[[ Line: 106 | Upvalues: v2 (ref) ]]
			v2(p1)
		end)

		return function() --[[ Line: 111 | Upvalues: v1 (copy) ]]
			v1:cancel()
		end
	end, { p1.duration, p1.mount_key })

	local v42 = v1:map(function(p1) --[[ Line: 116 ]]
		return p1 > 0.5
	end)
	local v5 = v1:map(function(p1) --[[ Line: 119 ]]
		return p1 > 0
	end)
	local v6 = v1:map(get_left_rotation)
	local v7 = v1:map(get_right_rotation)
	local v8 = v1:map(get_left_transparency)
	local v9 = v1:map(get_right_transparency)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.fromScale(1, 1)
	}, {
		backing = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxassetid://111877624187256",
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(1, 1)
		}),
		stroke = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxassetid://117964839212224",
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = Color3.fromRGB(20, 14, 5),
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(1.02, 1.02)
		}, {
			uICorner = v3,
			uIGradient = React.createElement("UIGradient", {
				Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 154, 0)) })
			})
		}),
		timer = React.createElement("Frame", {
			BackgroundTransparency = 1,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1)
		}, {
			leftStroke = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				AnchorPoint = Vector2.new(1, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.5, 1),
				Visible = v42
			}, {
				frame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(0, 0.5),
					Position = UDim2.fromScale(0, 0.5),
					Size = UDim2.fromScale(2, 1)
				}, {
					uIPadding = React.createElement("UIPadding"),
					imageLabel = React.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						Image = "rbxassetid://117964839212224",
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.fromScale(1, 1)
					}, {
						uIGradient = React.createElement("UIGradient", {
							Rotation = v6,
							Transparency = v8
						}),
						uICorner = v3
					})
				})
			}),
			rightStroke = React.createElement("Frame", {
				BackgroundTransparency = 1,
				ClipsDescendants = true,
				AnchorPoint = Vector2.new(0, 0.5),
				Position = UDim2.fromScale(0.5, 0.5),
				Size = UDim2.fromScale(0.5, 1),
				Visible = v5
			}, {
				frame = React.createElement("Frame", {
					BackgroundTransparency = 1,
					AnchorPoint = Vector2.new(1, 0.5),
					Position = UDim2.fromScale(1, 0.5),
					Size = UDim2.fromScale(2, 1)
				}, {
					uIPadding = React.createElement("UIPadding"),
					imageLabel = React.createElement("ImageLabel", {
						BackgroundTransparency = 1,
						Image = "rbxassetid://117964839212224",
						ScaleType = Enum.ScaleType.Fit,
						Size = UDim2.fromScale(1, 1)
					}, {
						uIGradient = React.createElement("UIGradient", {
							Rotation = v7,
							Transparency = v9
						}),
						uICorner = v3
					})
				})
			})
		}),
		uIScale = React.createElement("UIScale", {
			Scale = 0,
			ref = v32
		}),
		stroke2 = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = "rbxassetid://117964839212224",
			Visible = false,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			ImageColor3 = Color3.fromRGB(255, 213, 0),
			Position = UDim2.fromScale(0.5, 0.5),
			ScaleType = Enum.ScaleType.Fit,
			Size = UDim2.fromScale(0.85, 0.85)
		}, {
			uICorner = v3
		})
	})
end