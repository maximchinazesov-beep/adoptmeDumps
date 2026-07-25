-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local load = require(ReplicatedStorage.Fsys).load
local v1 = load("GetHardwareSafeAreaInsets")
local v2 = load("InventoryDB")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local InteriorsM = require(ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM)
local LiveOpsTime = require(ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local v3 = UDim2.fromScale(0.535, 0.515)
local v4 = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local v5 = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local v6 = ColorSequence.new(Color3.fromRGB(255, 205, 76), Color3.fromRGB(255, 157, 36))
local v7 = Color3.fromRGB(255, 157, 36)
local t = {}

t.__index = t

local v8 = 0
local v9 = nil
local v10 = nil
local t2 = {}

t2.__index = t2

local t3 = {}

local function collect_planting_spots() --[[ collect_planting_spots | Line: 78 | Upvalues: InteriorsM (copy), t3 (copy), BeesWagonFlowerHelper (copy) ]]
	local v1 = InteriorsM.get_current_location()

	if not v1 or v1.destination_id ~= "MainMap" then
		return t3
	end

	local interior = v1.interior
	local v2 = if interior then interior:FindFirstChild("Event") else interior
	local v3 = if v2 then v2:FindFirstChild("Wagon") else v2
	local v4 = if v3 then v3:FindFirstChild("PlantingSpotRoots") else v3

	if not v4 then
		return t3
	end

	local t = {}

	for i = 1, BeesWagonFlowerHelper.PLANTING_SPOT_COUNT do
		local v5 = tostring(i)
		local v6 = v4:FindFirstChild(v5)

		if v6 then
			table.insert(t, {
				spot_index = v5,
				root = v6
			})
		end
	end

	return t
end

local function format_time(p1) --[[ format_time | Line: 103 ]]
	local v1 = math.max(0, p1)
	local v2 = math.floor(v1 / 60)

	return string.format("%02d:%02d", v2, (math.floor(v1 % 60)))
end

local t4 = {}

local function get_flower_image(p1) --[[ get_flower_image | Line: 113 | Upvalues: t4 (copy), v2 (copy), BeesWagonFlowerHelper (copy) ]]
	local v1 = t4[p1]

	if not v1 then
		local v22 = v2.toys[BeesWagonFlowerHelper.get_flower_item_kind(p1)]
		local v3 = if v22 then v22.image or "" else ""

		t4[p1] = v3
		v1 = v3
	end

	return v1
end

local function squares_overlap(p1, p2) --[[ squares_overlap | Line: 123 ]]
	return if math.abs(p1.center.X - p2.center.X) < p1.half + p2.half then math.abs(p1.center.Y - p2.center.Y) < p1.half + p2.half else false
end

local function merge_overlapping_squares(p1) --[[ merge_overlapping_squares | Line: 131 ]]
	local v1 = true

	while v1 do
		local count = 1

		v1 = false

		while count <= #p1 do
			local v2 = p1[count]
			local count2 = count + 1

			while count2 <= #p1 do
				local v3
				local v4 = p1[count2]

				v3 = if math.abs(v2.center.X - v4.center.X) < v2.half + v4.half then if math.abs(v2.center.Y - v4.center.Y) < v2.half + v4.half then true else false else false

				if v3 then
					local v13 = Vector2.new(math.min(v2.center.X - v2.half, v4.center.X - v4.half), (math.min(v2.center.Y - v2.half, v4.center.Y - v4.half)))
					local v20 = Vector2.new(math.max(v2.center.X + v2.half, v4.center.X + v4.half), (math.max(v2.center.Y + v2.half, v4.center.Y + v4.half)))

					v2.center = (v13 + v20) / 2
					v2.half = math.max(v20.X - v13.X, v20.Y - v13.Y) / 2
					table.remove(p1, count2)
					v1 = true
				else
					count2 = count2 + 1
				end
			end

			count = count + 1
		end
	end
end

local function build_singleton() --[[ build_singleton | Line: 163 | Upvalues: collect_planting_spots (copy), t (copy), Players (copy), RunService (copy), InteriorsM (copy), t3 (copy) ]]
	local t2 = {
		dim_alpha = 1,
		teardown_requested = false,
		fill_pool = {},
		hole_pool = {},
		pins = {},
		spots = collect_planting_spots()
	}
	local v2 = setmetatable(t2, t)
	local BeesWagon2026SeedToolHighlights = Instance.new("ScreenGui")

	BeesWagon2026SeedToolHighlights.Name = "BeesWagon2026SeedToolHighlights"
	BeesWagon2026SeedToolHighlights.ScreenInsets = Enum.ScreenInsets.None
	BeesWagon2026SeedToolHighlights.ResetOnSpawn = false
	BeesWagon2026SeedToolHighlights.DisplayOrder = -9999
	v2.gui = BeesWagon2026SeedToolHighlights

	local Dim = Instance.new("Frame")

	Dim.Name = "Dim"
	Dim.BackgroundTransparency = 1
	Dim.Size = UDim2.fromScale(1, 1)
	Dim.ZIndex = 1
	Dim.Visible = false
	Dim.Parent = BeesWagon2026SeedToolHighlights
	v2.dim = Dim

	local Pins = Instance.new("Frame")

	Pins.Name = "Pins"
	Pins.BackgroundTransparency = 1
	Pins.Size = UDim2.fromScale(1, 1)
	Pins.ZIndex = 2
	Pins.Parent = BeesWagon2026SeedToolHighlights
	v2.pin_container = Pins
	BeesWagon2026SeedToolHighlights.Parent = Players.LocalPlayer.PlayerGui
	v2.connections = { RunService.RenderStepped:Connect(function(p1) --[[ Line: 206 | Upvalues: v2 (copy) ]]
			v2:_update(p1)
		end), InteriorsM.on_location_changing:Connect(function() --[[ Line: 211 | Upvalues: v2 (copy), t3 (ref) ]]
			v2.spots = t3
		end), InteriorsM.on_location_changed:Connect(function() --[[ Line: 214 | Upvalues: v2 (copy), collect_planting_spots (ref) ]]
			v2.spots = collect_planting_spots()
		end) }

	return v2
end

function t.new() --[[ new | Line: 222 | Upvalues: v10 (ref), v8 (ref), Players (copy), BeesWagonFlowerHelper (copy), v9 (ref), build_singleton (copy), t2 (copy) ]]
	if v10 then
		task.cancel(v10)
		v10 = nil
	end

	v8 = v8 + 1
	Players.LocalPlayer:SetAttribute(BeesWagonFlowerHelper.SEED_TOOL_EQUIPPED_ATTRIBUTE, true)

	if v9 then
		v9.teardown_requested = false
	else
		v9 = build_singleton()
	end

	return setmetatable({
		_destroyed = false
	}, t2)
end
function t._update(p1, p2) --[[ _update | Line: 240 | Upvalues: v9 (ref), t3 (copy), ClientData (copy), Players (copy), BeesWagonFlowerHelper (copy), v1 (copy) ]]
	if p1.teardown_requested and p1.dim_alpha >= 1 then
		for v12, v2 in p1.connections do
			v2:Disconnect()
		end

		p1.gui:Destroy()

		if v9 ~= p1 then
			return
		end

		v9 = nil
	else
		local CurrentCamera = workspace.CurrentCamera
		local v3 = CurrentCamera.CFrame
		local FieldOfView = CurrentCamera.FieldOfView
		local ViewportSize = CurrentCamera.ViewportSize
		local v4 = if p1.teardown_requested then t3 else p1.spots

		if #v4 == 0 and (p1.dim_alpha >= 1 and next(p1.pins) == nil) then
			return
		end

		local v5

		if #v4 > 0 then
			local v6 = ClientData.get_server(Players.LocalPlayer, BeesWagonFlowerHelper.REPLICATION_KEY)

			v5 = if v6 then v6.planted_seeds or {} else {}
		else
			v5 = {}
		end

		if v4 == p1.last_spots and (v3 == p1.last_camera_cframe and (FieldOfView == p1.last_fov and (ViewportSize == p1.last_viewport and p1.dim_alpha == p1.last_target_alpha))) then
			p1:_update_pin_contents(v5)

			return
		end

		local t = {}
		local t2 = {}

		if ViewportSize ~= p1.last_inset_viewport then
			local v8 = v1()

			p1.last_inset_viewport = ViewportSize
			p1.origin = Vector2.new(v8.left, v8.top)
			p1.screen_size = ViewportSize + p1.origin + Vector2.new(v8.right, v8.bottom)
		end

		local origin = p1.origin

		if #v4 > 0 then
			local v10 = ViewportSize.Y / (math.tan((math.rad(FieldOfView / 2))) * 2)

			for v11, v12 in v4 do
				local spot_index = v12.spot_index
				local root = v12.root
				local v13 = CurrentCamera:WorldToViewportPoint(root.Position)

				if v13.Z > 0 then
					local v15 = math.clamp(4 * v10 / v13.Z, 30, 160)

					table.insert(t, {
						center = Vector2.new(v13.X, v13.Y) + origin,
						half = v15
					})
				end

				local v16, v17 = CurrentCamera:WorldToViewportPoint(root.Position + Vector3.new(0, 4, 0))

				if v17 then
					t2[spot_index] = Vector3.new(v16.X + origin.X, v16.Y + origin.Y, v16.Z)
				end
			end
		end

		p1:_update_pins(t2)
		p1:_update_pin_contents(v5)

		local v20 = if p1:_update_dim(t, p1.screen_size) then 0.825 else 1

		if p1.dim_alpha ~= v20 then
			local v21 = p2 * 0.8750000000000002

			if p1.dim_alpha < v20 then
				p1.dim_alpha = math.min(p1.dim_alpha + v21, v20)
			else
				p1.dim_alpha = math.max(p1.dim_alpha - v21, v20)
			end

			p1:_apply_dim_alpha()
		end

		p1.dim.Visible = if p1.dim_alpha < 1 then true else false
		p1.last_spots = v4
		p1.last_camera_cframe = v3
		p1.last_fov = FieldOfView
		p1.last_viewport = ViewportSize
		p1.last_target_alpha = v20
	end
end
function t._apply_dim_alpha(p1) --[[ _apply_dim_alpha | Line: 353 ]]
	for v1, v2 in p1.fill_pool do
		v2.BackgroundTransparency = p1.dim_alpha
	end

	for v3, v4 in p1.hole_pool do
		v4.ImageTransparency = p1.dim_alpha
	end
end
function t._update_pins(p1, p2) --[[ _update_pins | Line: 362 ]]
	for v1, v2 in p1.pins do
		if not p2[v1] then
			v2.frame:Destroy()
			p1.pins[v1] = nil
		end
	end

	for v3, v4 in p2 do
		local v5 = p1.pins[v3]

		if not v5 then
			local v6 = p1:_create_pin()

			p1.pins[v3] = v6
			v5 = v6
		end

		v5.frame.Position = UDim2.fromOffset(v4.X, v4.Y)
		v5.frame.ZIndex = -math.floor(v4.Z + 0.5)
	end
end

local function set_timer_mode(p1, p2) --[[ set_timer_mode | Line: 382 | Upvalues: TweenService (copy), v5 (copy) ]]
	local timer_mode = p1.timer_mode

	p1.timer_mode = p2

	if p1.shrink_tween then
		p1.shrink_tween:Cancel()
		p1.shrink_tween = nil
	end

	if p2 == "hidden" then
		p1.timer.Visible = false
		p1.timer_seconds = nil

		return
	end

	if p2 == "countdown" then
		p1.timer.Visible = true
		p1.timer_check.Visible = false
		p1.timer_label.Visible = true
		p1.timer_label_scale.Scale = 1

		return
	end

	p1.timer.Visible = true
	p1.timer_check.Visible = true
	p1.timer_seconds = nil

	if timer_mode == "countdown" then
		local v1 = TweenService:Create(p1.timer_label_scale, v5, {
			Scale = 0
		})

		p1.shrink_tween = v1
		v1.Completed:Once(function() --[[ Line: 408 | Upvalues: p1 (copy) ]]
			if p1.timer_mode ~= "check" then
				return
			end

			p1.timer_label.Visible = false
		end)
		v1:Play()
	else
		p1.timer_label.Visible = false
	end
end

function t._update_pin_contents(p1, p2) --[[ _update_pin_contents | Line: 420 | Upvalues: LiveOpsTime (copy), t4 (copy), v2 (copy), BeesWagonFlowerHelper (copy), set_timer_mode (copy) ]]
	if next(p1.pins) == nil then
		return
	end

	local v1 = LiveOpsTime.now()

	for v3, v4 in p1.pins do
		local v22
		local v5 = p2[v3]
		local v6 = "hidden"
		local v7 = nil

		if v5 then
			local flower_kind = v5.flower_kind
			local v8 = t4[flower_kind]

			if not v8 then
				local v9 = v2.toys[BeesWagonFlowerHelper.get_flower_item_kind(flower_kind)]
				local v10 = if v9 then v9.image or "" else ""

				t4[flower_kind] = v10
				v8 = v10
			end

			if BeesWagonFlowerHelper.is_flower_ready(v5, v1) then
				v22 = v8
				v6 = "check"
			elseif v5.watered_at then
				v22, v6, v7 = v8, "countdown", math.max(0, (math.ceil(v5.watered_at + BeesWagonFlowerHelper.get_growth_duration(v5.flower_kind) - v1)))
			else
				v22 = v8
			end
		else
			v22 = "rbxassetid://81865443030579"
		end

		if v4.icon_image ~= v22 then
			v4.icon_image = v22
			v4.icon.Image = v22
		end

		if v4.timer_mode ~= v6 then
			set_timer_mode(v4, v6)
		end

		if v7 and v4.timer_seconds ~= v7 then
			v4.timer_seconds = v7

			local v14 = math.max(0, v7)
			local v15 = math.floor(v14 / 60)

			v4.timer_label.Text = string.format("%02d:%02d", v15, (math.floor(v14 % 60)))
		end
	end
end
function t._create_pin(p1) --[[ _create_pin | Line: 460 | Upvalues: v6 (copy), v7 (copy), v3 (copy), TweenService (copy), v4 (copy) ]]
	local Frame = Instance.new("Frame")

	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundTransparency = 1
	Frame.Size = UDim2.new()

	local ArrowFrame = Instance.new("Frame")

	ArrowFrame.Name = "ArrowFrame"
	ArrowFrame.AnchorPoint = Vector2.new(0.5, 1)
	ArrowFrame.Position = UDim2.fromScale(0.5, 0)
	ArrowFrame.Size = UDim2.fromOffset(25, 25)
	ArrowFrame.BackgroundTransparency = 1
	ArrowFrame.Parent = Frame

	local Arrow = Instance.new("ImageLabel")

	Arrow.Name = "Arrow"
	Arrow.AnchorPoint = Vector2.new(0.5, 0.5)
	Arrow.Position = UDim2.fromScale(0.5, 0.5)
	Arrow.Size = UDim2.fromScale(1, 1)
	Arrow.BackgroundTransparency = 1
	Arrow.Image = "rbxassetid://10548513503"
	Arrow.ZIndex = -1
	Arrow.Parent = ArrowFrame

	local Badge = Instance.new("Frame")

	Badge.Name = "Badge"
	Badge.AnchorPoint = Vector2.new(0.5, 1)
	Badge.Position = UDim2.fromScale(0.5, 0)
	Badge.Size = UDim2.fromOffset(50, 50)
	Badge.BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
	Badge.Parent = ArrowFrame

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Badge

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.new(255/255, 255/255, 255/255)
	UIStroke.Thickness = 5
	UIStroke.Parent = Badge

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Color = v6
	UIGradient.Rotation = 90
	UIGradient.Parent = Badge

	local Icon = Instance.new("ImageLabel")

	Icon.Name = "Icon"
	Icon.AnchorPoint = Vector2.new(0.5, 0.5)
	Icon.Position = UDim2.fromScale(0.5, 0.5)
	Icon.Size = UDim2.fromScale(0.75, 0.75)
	Icon.BackgroundTransparency = 1
	Icon.Parent = Badge

	local Timer = Instance.new("Frame")

	Timer.Name = "Timer"
	Timer.AnchorPoint = Vector2.new(0, 0.5)
	Timer.Position = UDim2.new(1, 8, 0.5, 0)
	Timer.AutomaticSize = Enum.AutomaticSize.XY
	Timer.BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
	Timer.Visible = false
	Timer.Parent = Badge

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = Timer

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Color = v7
	UIStroke2.Thickness = 2
	UIStroke2.Parent = Timer

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingLeft = UDim.new(0, 8)
	UIPadding.PaddingRight = UDim.new(0, 10)
	UIPadding.PaddingTop = UDim.new(0, 3)
	UIPadding.PaddingBottom = UDim.new(0, 3)
	UIPadding.Parent = Timer

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.Parent = Timer

	local Clock = Instance.new("ImageLabel")

	Clock.Name = "Clock"
	Clock.LayoutOrder = 1
	Clock.Size = UDim2.fromOffset(16, 16)
	Clock.BackgroundTransparency = 1
	Clock.Image = "rbxassetid://14453643562"
	Clock.ImageColor3 = v7
	Clock.Parent = Timer

	local Check = Instance.new("ImageLabel")

	Check.Name = "Check"
	Check.AnchorPoint = Vector2.new(0.5, 0.5)
	Check.Position = v3
	Check.Size = UDim2.fromScale(1.25, 1.25)
	Check.BackgroundTransparency = 1
	Check.Image = "rbxassetid://14370703836"
	Check.ImageTransparency = 0.25
	Check.ZIndex = 2
	Check.Visible = false
	Check.Parent = Clock

	local Time = Instance.new("TextLabel")

	Time.Name = "Time"
	Time.LayoutOrder = 2
	Time.AutomaticSize = Enum.AutomaticSize.XY
	Time.Size = UDim2.new()
	Time.BackgroundTransparency = 1
	Time.Font = Enum.Font.GothamBold
	Time.Text = ""
	Time.TextSize = 16
	Time.TextColor3 = Color3.new(0/255, 0/255, 0/255)
	Time.Parent = Timer

	local UIScale = Instance.new("UIScale")

	UIScale.Parent = Time

	local UIScale2 = Instance.new("UIScale")

	UIScale2.Scale = 0
	UIScale2.Parent = ArrowFrame
	Frame.Parent = p1.pin_container
	TweenService:Create(UIScale2, v4, {
		Scale = 1
	}):Play()

	return {
		timer_mode = "hidden",
		shrink_tween = nil,
		icon_image = nil,
		timer_seconds = nil,
		frame = Frame,
		icon = Icon,
		timer = Timer,
		timer_check = Check,
		timer_label = Time,
		timer_label_scale = UIScale
	}
end
function t._update_dim(p1, p2, p3) --[[ _update_dim | Line: 605 | Upvalues: merge_overlapping_squares (copy) ]]
	merge_overlapping_squares(p2)

	local t = {}

	for v1, v2 in p2 do
		local v4 = math.round(v2.center.X - v2.half)
		local v6 = math.round(v2.center.X + v2.half)
		local v8 = math.round(v2.center.Y - v2.half)
		local v10 = math.round(v2.center.Y + v2.half)
		local v11 = math.max(v4, 0)
		local v12 = math.min(v6, p3.X)
		local v13 = math.max(v8, 0)
		local v14 = math.min(v10, p3.Y)

		if v11 < v12 and v13 < v14 then
			table.insert(t, {
				x0 = v11,
				x1 = v12,
				y0 = v13,
				y1 = v14,
				ix0 = v4,
				ix1 = v6,
				iy0 = v8,
				iy1 = v10
			})
		end
	end

	if #t == 0 then
		return false
	end

	local v15 = 0

	local function place_fill(p12, p2, p3, p4) --[[ place_fill | Line: 635 | Upvalues: v15 (ref), p1 (copy) ]]
		if p3 <= 0 or p4 <= 0 then
			return
		end

		v15 = v15 + 1

		local v1 = p1.fill_pool[v15]

		if not v1 then
			local Fill = Instance.new("Frame")

			Fill.Name = "Fill"
			Fill.BackgroundColor3 = Color3.new(0/255, 0/255, 0/255)
			Fill.BackgroundTransparency = p1.dim_alpha
			Fill.BorderSizePixel = 0
			Fill.Parent = p1.dim
			p1.fill_pool[v15] = Fill
			v1 = Fill
		end

		v1.Position = UDim2.fromOffset(p12, p2)
		v1.Size = UDim2.fromOffset(p3, p4)
		v1.Visible = true
	end

	local t2 = { 0, p3.Y }

	for v16, v17 in t do
		table.insert(t2, v17.y0)
		table.insert(t2, v17.y1)
	end

	table.sort(t2)

	for i = 1, #t2 - 1 do
		local v18 = t2[i]
		local v19 = t2[i + 1]

		if not (v19 - v18 <= 0) then
			local t3 = {}

			for v20, v21 in t do
				if v21.y0 <= v18 and v19 <= v21.y1 then
					table.insert(t3, v21)
				end
			end

			table.sort(t3, function(p1, p2) --[[ Line: 673 ]]
				return p1.x0 < p2.x0
			end)

			local v22 = 0

			for v23, v24 in t3 do
				place_fill(v22, v18, v24.x0 - v22, v19 - v18)
				v22 = math.max(v22, v24.x1)
			end

			place_fill(v22, v18, p3.X - v22, v19 - v18)
		end
	end

	for j = v15 + 1, #p1.fill_pool do
		p1.fill_pool[j].Visible = false
	end

	for v26, v27 in t do
		local v28 = p1.hole_pool[v26]

		if not v28 then
			local Hole = Instance.new("ImageLabel")

			Hole.Name = "Hole"
			Hole.BackgroundTransparency = 1
			Hole.Image = "rbxassetid://2032803348"
			Hole.ImageColor3 = Color3.new(0/255, 0/255, 0/255)
			Hole.ImageTransparency = p1.dim_alpha
			Hole.Parent = p1.dim
			p1.hole_pool[v26] = Hole
			v28 = Hole
		end

		v28.Position = UDim2.fromOffset(v27.ix0, v27.iy0)
		v28.Size = UDim2.fromOffset(v27.ix1 - v27.ix0, v27.iy1 - v27.iy0)
		v28.Visible = true
	end

	for k = #t + 1, #p1.hole_pool do
		p1.hole_pool[k].Visible = false
	end

	return true
end
function t2.destroy(p1) --[[ destroy | Line: 712 | Upvalues: v8 (ref), v10 (ref), Players (copy), BeesWagonFlowerHelper (copy), v9 (ref) ]]
	if p1._destroyed then
		return
	end

	p1._destroyed = true
	v8 = v8 - 1

	if not (v8 > 0) then
		v10 = task.delay(1, function() --[[ Line: 724 | Upvalues: v10 (ref), v8 (ref), Players (ref), BeesWagonFlowerHelper (ref), v9 (ref) ]]
			v10 = nil

			if v8 > 0 then
				return
			end

			Players.LocalPlayer:SetAttribute(BeesWagonFlowerHelper.SEED_TOOL_EQUIPPED_ATTRIBUTE, nil)

			if not v9 then
				return
			end

			v9.teardown_requested = true
		end)
	end
end

return t