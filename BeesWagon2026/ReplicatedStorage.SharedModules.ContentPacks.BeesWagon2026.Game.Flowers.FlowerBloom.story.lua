-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Workspace = game:GetService("Workspace")
local FlowerBloom = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Flowers.FlowerBloom)
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local Signal = require(ReplicatedStorage.SharedModules.Signal)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local t = { "bluebell", "fern", "rose", "daisy", "iris", "poppy" }
local Flowers = ServerStorage.ContentPacks.BeesWagon2026.SharedResources.Flowers
local v1 = CFrame.new(0, 3, 0)

local function validate_flower(p1) --[[ validate_flower | Line: 18 | Upvalues: t (copy) ]]
	for v1, v2 in t do
		if v2 == p1 then
			return p1
		end
	end

	error((("Unknown flower \"%*\". Expected one of: %*"):format(p1, (table.concat(t, ", ")))))
end

local function clamp_duration(p1) --[[ clamp_duration | Line: 28 ]]
	return math.max(p1, 0.01)
end

local function destroy_preview(p1) --[[ destroy_preview | Line: 43 ]]
	if not p1 then
		return
	end

	p1.controller:destroy()

	if not p1.clone.Parent then
		return
	end

	p1.clone:Destroy()
end

local function create_preview(p1) --[[ create_preview | Line: 54 | Upvalues: Flowers (copy), v1 (copy), Workspace (copy), FlowerBloom (copy) ]]
	local v12 = Flowers[p1]:Clone()

	v12.Name = ("FlowerBloomStory_%*"):format(p1)
	v12:PivotTo(v1)
	v12.Parent = Workspace

	return {
		flower_name = p1,
		clone = v12,
		controller = FlowerBloom.mount(v12)
	}
end

local function status_app(p1) --[[ status_app | Line: 68 | Upvalues: React (copy) ]]
	local controls = p1.controls

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}, {
		Status = React.createElement("TextLabel", {
			BackgroundTransparency = 0.2,
			TextSize = 16,
			Size = UDim2.fromOffset(320, 96),
			Position = UDim2.fromOffset(12, 12),
			BackgroundColor3 = Color3.fromRGB(20, 20, 20),
			TextColor3 = Color3.new(255/255, 255/255, 255/255),
			TextXAlignment = Enum.TextXAlignment.Left,
			TextYAlignment = Enum.TextYAlignment.Top,
			FontFace = Font.fromName("Montserrat", Enum.FontWeight.SemiBold),
			Text = ("Flower: %*\nDuration: %*s\nBloom: %*"):format(controls.flower, string.format("%.2f", controls.duration), (string.format("%.2f", p1.bloom_t)))
		}, {
			Padding = React.createElement("UIPadding", {
				PaddingTop = UDim.new(0, 8),
				PaddingBottom = UDim.new(0, 8),
				PaddingLeft = UDim.new(0, 10),
				PaddingRight = UDim.new(0, 10)
			})
		})
	})
end

local function story_async(p1, p2, p3) --[[ story_async | Line: 97 | Upvalues: ReactRoblox (copy), Maid (copy), React (copy), status_app (copy), TweenPromise (copy), t (copy), create_preview (copy) ]]
	local v1 = ReactRoblox.createRoot(Instance.new("Folder"))
	local v2 = nil
	local v3 = Maid.new()
	local v4 = 0

	p1:GiveTask(v3)
	p1:GiveTask(function() --[[ Line: 104 | Upvalues: v2 (ref) ]]
		local v1 = v2

		if not v1 then
			return
		end

		v1.controller:destroy()

		if not v1.clone.Parent then
			return
		end

		v1.clone:Destroy()
	end)

	local function render_status(p1) --[[ render_status | Line: 108 | Upvalues: v1 (copy), ReactRoblox (ref), React (ref), status_app (ref), v4 (ref), p2 (copy) ]]
		v1:render(ReactRoblox.createPortal(React.createElement(status_app, {
			controls = p1,
			bloom_t = v4
		}), p2.target))
	end

	local function restart_bloom_animation(p1) --[[ restart_bloom_animation | Line: 115 | Upvalues: v3 (copy), v2 (ref), v4 (ref), v1 (copy), ReactRoblox (ref), React (ref), status_app (ref), p2 (copy), TweenPromise (ref) ]]
		v3:DoCleaning()

		if v2 then
			v4 = 0
			v2.controller:bloom(0)
			v1:render(ReactRoblox.createPortal(React.createElement(status_app, {
				controls = p1,
				bloom_t = v4
			}), p2.target))
			v3:GiveTask(TweenPromise.callback(0, 1, TweenInfo.new(p1.duration, Enum.EasingStyle.Linear), function(p12) --[[ Line: 128 | Upvalues: v4 (ref), v2 (ref), p1 (copy), v1 (ref), ReactRoblox (ref), React (ref), status_app (ref), p2 (ref) ]]
				v4 = p12
				v2.controller:bloom(p12)
				v1:render(ReactRoblox.createPortal(React.createElement(status_app, {
					controls = p1,
					bloom_t = p12
				}), p2.target))
			end))
		end
	end

	local function apply_controls(p1) --[[ apply_controls | Line: 135 | Upvalues: t (ref), v2 (ref), create_preview (ref), restart_bloom_animation (copy) ]]
		local flower = p1.flower
		local v1

		do
			local __inline_returned = false

			for v22, v3 in t do
				if v3 == flower then
					v1 = flower
					__inline_returned = true

					break
				end
			end

			if not __inline_returned then
				error((("Unknown flower \"%*\". Expected one of: %*"):format(flower, (table.concat(t, ", ")))))
			end
		end

		local v4 = math.max(p1.duration, 0.01)
		local v5

		if v2 and v2.flower_name == v1 then
			v5 = v4
		else
			local v6 = v2

			if v6 then
				v6.controller:destroy()

				if v6.clone.Parent then
					v6.clone:Destroy()
				end
			end

			v5 = v4
			v2 = create_preview(v1)
		end

		restart_bloom_animation({
			flower = v1,
			duration = v5
		})
	end

	apply_controls(p2.controls)
	p1:GiveTask(p3:Connect(apply_controls))
	p1:GiveTask(function() --[[ Line: 152 | Upvalues: v1 (copy) ]]
		v1:unmount()
	end)
end

return {
	summary = "Preview BeesWagon2026 flower bloom in Workspace. Duration controls how long the 0\226\134\1461 bloom takes; changing it restarts from 0.",
	controls = {
		flower = "rose",
		duration = 5
	},
	render = function(p1) --[[ render | Line: 163 | Upvalues: Maid (copy), Signal (copy), Promise (copy), story_async (copy) ]]
		local v1 = Maid.new()
		local v2 = Signal.new()

		v1:GiveTask(Promise.try(story_async, v1, p1, v2):catch(warn))
		v1:GiveTask((p1.subscribe(function(p1, p2) --[[ Line: 169 | Upvalues: v2 (copy) ]]
			local v1 = false

			for v22, v3 in p2 do
				if v3.__new ~= v3.__old then
					v1 = true

					break
				end
			end

			if v1 then
				v2:Fire(p1)
			end
		end)))

		return function() --[[ Line: 185 | Upvalues: v1 (copy) ]]
			v1:DoCleaning()
		end
	end
}