-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local SurfaceBillboard = require(ReplicatedStorage.new.modules.ReactShared.SurfaceBillboard)

require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)

local BouquetRecipeBillboard = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.BouquetRecipeBillboard)
local React = require(ReplicatedStorage.SharedPackages.React)
local TweenHelper = require(ReplicatedStorage.SharedModules.TweenHelper)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local UsePopScale = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.UsePopScale)
local v1 = Vector2.new(900, 500)
local v2 = TweenHelper.tween_info({
	time = 0.25,
	easing_style = Enum.EasingStyle.Linear
})

local function ease_pop(p1) --[[ ease_pop | Line: 32 | Upvalues: TweenService (copy) ]]
	return TweenService:GetValue(p1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

local function count_placed_flowers(p1) --[[ count_placed_flowers | Line: 44 ]]
	local t = {}

	for v1, v2 in p1 do
		t[v2] = (t[v2] or 0) + 1
	end

	return t
end

local function use_enlarge_scale(p1, p2) --[[ use_enlarge_scale | Line: 54 | Upvalues: React (copy), TweenPromise (copy), v2 (copy), TweenService (copy), RunService (copy) ]]
	local v1, v22 = React.useBinding(0.3)
	local v3 = React.useRef(0.3)
	local v4 = React.useRef(0.3)
	local v5 = React.useRef(nil)
	local v6 = React.useRef(false)

	local function retarget(p1) --[[ retarget | Line: 61 | Upvalues: v6 (copy), v3 (copy), v22 (copy), v5 (copy), v4 (copy), v1 (copy), TweenPromise (ref), v2 (ref), TweenService (ref) ]]
		if not v6.current then
			v6.current = true
			v3.current = p1
			v22(p1)

			return
		end

		local v12 = p1 - v3.current

		if math.abs(v12) < 0.01 then
			return
		end

		if not v5.current then
			v4.current = v1:getValue()
			v3.current = p1
			v5.current = TweenPromise.callback(0, 1, v2, function(p13) --[[ Line: 80 | Upvalues: v22 (ref), v4 (ref), v3 (ref), TweenService (ref) ]]
				v22(v4.current + (v3.current - v4.current) * TweenService:GetValue(p13, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
			end)

			return
		end

		v5.current:cancel()
		v4.current = v1:getValue()
		v3.current = p1
		v5.current = TweenPromise.callback(0, 1, v2, function(p13) --[[ Line: 80 | Upvalues: v22 (ref), v4 (ref), v3 (ref), TweenService (ref) ]]
			v22(v4.current + (v3.current - v4.current) * TweenService:GetValue(p13, Enum.EasingStyle.Back, Enum.EasingDirection.Out))
		end)
	end

	React.useEffect(function() --[[ Line: 85 | Upvalues: p1 (copy), retarget (copy), RunService (ref), p2 (copy), v5 (copy) ]]
		if p1 then
			local v1 = RunService.RenderStepped:Connect(function() --[[ Line: 91 | Upvalues: p2 (ref), retarget (ref) ]]
				local CurrentCamera = workspace.CurrentCamera

				if CurrentCamera then
					retarget((math.clamp(math.clamp((p2.WorldPosition - CurrentCamera.CFrame.Position).Magnitude / 8, 0, 2) * 0.5, 0.3, 1)))
				end
			end)

			return function() --[[ Line: 102 | Upvalues: v1 (copy), v5 (ref) ]]
				v1:Disconnect()

				if not v5.current then
					return
				end

				v5.current:cancel()
			end
		end

		retarget(0.3)
	end, { p1, p2 })

	return v1
end

local function use_screen_fit_offset(p1, p2, p3) --[[ use_screen_fit_offset | Line: 113 | Upvalues: React (copy), RunService (copy), v1 (copy) ]]
	local v12 = React.useRef(Vector3.new(0, 0, 0))
	local v2 = React.useCallback(function() --[[ Line: 115 | Upvalues: v12 (copy) ]]
		return v12.current
	end, {})

	React.useEffect(function() --[[ Line: 119 | Upvalues: p1 (copy), v12 (copy), RunService (ref), v1 (ref), p3 (copy), p2 (copy) ]]
		if p1 then
			local v13 = RunService.RenderStepped:Connect(function() --[[ Line: 125 | Upvalues: v1 (ref), p3 (ref), p2 (ref), v12 (ref) ]]
				local CurrentCamera = workspace.CurrentCamera

				if not CurrentCamera then
					return
				end

				local v2 = CurrentCamera:WorldToViewportPoint(p2.WorldPosition + CurrentCamera.CFrame.UpVector * (v1.Y / 50 * p3:getValue()))

				if v2.Z <= 0 then
					v12.current = Vector3.new(0, 0, 0)

					return
				end

				local v3 = 80 - v2.Y

				if v3 <= 0 then
					v12.current = Vector3.new(0, 0, 0)
				else
					v12.current = -CurrentCamera.CFrame.UpVector * math.min(v3 * (2 * v2.Z * math.tan(math.rad(CurrentCamera.FieldOfView) / 2) / CurrentCamera.ViewportSize.Y), 6)
				end
			end)

			return function() --[[ Line: 152 | Upvalues: v13 (copy), v12 (ref) ]]
				v13:Disconnect()
				v12.current = Vector3.new(0, 0, 0)
			end
		end

		v12.current = Vector3.new(0, 0, 0)
	end, { p1, p2, p3 })

	return v2
end

local function PottedBouquetBillboard(p1) --[[ PottedBouquetBillboard | Line: 161 | Upvalues: UsePopScale (copy), use_enlarge_scale (copy), use_screen_fit_offset (copy), React (copy), SurfaceBillboard (copy), v1 (copy), BouquetRecipeBillboard (copy) ]]
	local t = {}

	for v12, v2 in p1.placed_flowers do
		t[v2] = (t[v2] or 0) + 1
	end

	local v3 = UsePopScale(p1.visible, 0, 1)
	local v4 = use_enlarge_scale(p1.enlarged, p1.attachment)

	return React.createElement(SurfaceBillboard, {
		pixels_per_stud = 50,
		world_size = Vector3.new(50, 50, 0.001),
		max_distance = 200,
		target = p1.attachment,
		get_offset = use_screen_fit_offset(p1.enlarged, p1.attachment, v4)
	}, {
		VisibilityScaler = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromOffset(v1.X, v1.Y),
			Position = UDim2.fromScale(0.5, 1),
			AnchorPoint = Vector2.new(0.5, 1)
		}, {
			UIScale = React.createElement("UIScale", {
				Scale = v3
			}),
			SizeScaler = React.createElement("Frame", {
				BackgroundTransparency = 1,
				AnchorPoint = Vector2.new(0.5, 1),
				Position = UDim2.fromScale(0.5, 1),
				Size = v4:map(function(p1) --[[ Line: 187 | Upvalues: v1 (ref) ]]
					return UDim2.fromOffset(v1.X * p1, v1.Y * p1)
				end)
			}, {
				Recipe = React.createElement(BouquetRecipeBillboard, {
					recipe = p1.recipe,
					placed_counts = t,
					enlarged = p1.enlarged
				})
			})
		})
	})
end

return React.memo(PottedBouquetBillboard)