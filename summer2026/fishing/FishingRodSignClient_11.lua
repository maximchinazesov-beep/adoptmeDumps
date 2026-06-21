-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local FishingRodDB = require(ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Fishing.DB.FishingRodDB)
local FishingRodSign = require(script.Parent.FishingRodSign)

require(script.Parent.FishingRodSignThemes)
require(script.Parent.FishingTypes)

local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local t = {}
local t2 = { "summer_2026_bronze_fishing_rod", "summer_2026_silver_fishing_rod", "summer_2026_gold_fishing_rod" }
local t3 = {
	summer_2026_bronze_fishing_rod = "bronze",
	summer_2026_silver_fishing_rod = "silver",
	summer_2026_gold_fishing_rod = "gold"
}

local function get_next_rod_kind(p1) --[[ get_next_rod_kind | Line: 26 | Upvalues: t2 (copy) ]]
	for v1, v2 in t2 do
		if not p1[v2] then
			return v2
		end
	end

	return nil
end

local function get_sign_props(p1) --[[ get_sign_props | Line: 35 | Upvalues: t2 (copy), t3 (copy), FishingRodDB (copy) ]]
	local bought_unique_items = p1.bought_unique_items
	local v1 = nil

	for v2, v3 in t2 do
		if not bought_unique_items[v3] then
			v1 = v3

			break
		end
	end

	if not v1 then
		return {
			theme = "gold",
			caught = 0,
			required = 0,
			visible = true,
			is_maxed = true,
			next_rod_kind = nil
		}
	end

	local v5 = FishingRodDB[v1]

	return {
		visible = true,
		theme = t3[v1],
		caught = p1.upgrade_fish_caught or 0,
		required = if v5 then v5.unlock_fish_count or 0 else 0,
		next_rod_kind = v1
	}
end

function t.mount(p1, p2) --[[ mount | Line: 62 | Upvalues: ReactRoblox (copy), get_sign_props (copy), React (copy), FishingRodSign (copy), t2 (copy), ClientData (copy) ]]
	local FishingShopItems = p1:FindFirstChild("FishingShopItems")

	if not FishingShopItems then
		return
	end

	local RodUpgradePedestal = FishingShopItems:FindFirstChild("RodUpgradePedestal")

	if not RodUpgradePedestal then
		return
	end

	local RodSign = RodUpgradePedestal:FindFirstChild("RodSign")

	if not RodSign then
		return
	end

	local SurfaceGui = RodSign:FindFirstChildOfClass("SurfaceGui")

	if not SurfaceGui then
		return
	end

	local Frame = SurfaceGui:FindFirstChild("Frame")

	if Frame and Frame:IsA("Frame") then
		local v1 = ReactRoblox.createRoot(Frame)

		local function render_sign(p1) --[[ render_sign | Line: 90 | Upvalues: get_sign_props (ref), Frame (copy), v1 (copy), React (ref), FishingRodSign (ref), RodUpgradePedestal (copy), t2 (ref) ]]
			local v12 = get_sign_props(p1)

			if v12.visible then
				Frame.Visible = true
				v1:render(React.createElement(FishingRodSign, v12))

				local NextRodSign = RodUpgradePedestal:FindFirstChild("NextRodSign")
				local v2 = if NextRodSign then NextRodSign:FindFirstChild("ClaimStateTitle", true) else NextRodSign

				if not v2 then
					return
				end

				v2.Text = if v12.next_rod_kind == t2[1] then "Free Fishing Rod:" else "Next Fishing Rod:"

				return
			end

			v1:render(nil)
			Frame.Visible = false
		end

		p2:GiveTask(ClientData.register_callback_plus_existing("fishing_manager", function(p1, p2) --[[ Line: 107 | Upvalues: render_sign (copy) ]]
			if p1 ~= game.Players.LocalPlayer then
				return
			end

			if p2 then
				render_sign(p2)
			end
		end))
		p2:GiveTask(function() --[[ Line: 116 | Upvalues: v1 (copy) ]]
			v1:render(nil)
		end)
	end
end

return t