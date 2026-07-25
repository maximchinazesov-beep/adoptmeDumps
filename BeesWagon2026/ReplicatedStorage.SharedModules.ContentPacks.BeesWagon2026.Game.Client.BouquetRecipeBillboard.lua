-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")

require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)

local FlowerRecipeSlot = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.FlowerRecipeSlot)
local React = require(ReplicatedStorage.SharedPackages.React)

return React.memo(function(p1) --[[ Line: 13 | Upvalues: React (copy), FlowerRecipeSlot (copy) ]]
	local v1, v2 = React.useBinding(Vector2.new(0, 0))
	local v3 = v1:map(function(p1) --[[ Line: 15 ]]
		return UDim2.new(0.1, p1.X, 0.1, p1.Y)
	end)
	local v4, v5 = React.useBinding(Vector2.new(0, 0))
	local t = {}
	local t2 = {}
	local count = 0

	for v6, v7 in p1.recipe do
		t[v7] = (t[v7] or 0) + 1

		if not t2[v7] then
			t2[v7] = count
			count = count + 1
		end
	end

	local v8 = true

	for v9, v10 in t do
		if (p1.placed_counts[v9] or 0) < v10 then
			v8 = false

			break
		end
	end

	local t3 = {}

	for v11, v12 in t do
		local v13 = p1.placed_counts[v11] or 0
		local t4 = {
			flower_kind = v11,
			recipe_amount = v12,
			placed_amount = v13,
			enlarged = p1.enlarged,
			all_complete = v8
		}

		t4.layout_order = if if v12 <= v13 then true else false then 100 + t2[v11] else t2[v11]
		t3[v11] = React.createElement(FlowerRecipeSlot, t4)
	end

	local t4 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}
	local t5 = {
		Background = React.createElement("ImageLabel", {
			BackgroundTransparency = 0,
			BorderSizePixel = 0,
			Image = "rbxassetid://101100994983425",
			Position = UDim2.fromScale(0.5, 1),
			AnchorPoint = Vector2.new(0.5, 1),
			Size = v3,
			BackgroundColor3 = Color3.fromRGB(255, 211, 101),
			ScaleType = Enum.ScaleType.Tile,
			TileSize = v4:map(function(p1) --[[ Line: 68 ]]
				return UDim2.new(math.max(0.1, 1.92 / (p1.X / p1.Y)), 0, 1, 0)
			end),
			ZIndex = -1,
			[React.Change.AbsoluteSize] = function(p1) --[[ Line: 75 | Upvalues: v5 (copy) ]]
				v5(p1.AbsoluteSize)
			end
		}, {
			UICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(0, 12)
			})
		}),
		FlowerContents = React.createElement("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.fromScale(0.95, 0.95),
			Position = UDim2.fromScale(0.5, 0.5),
			AnchorPoint = Vector2.new(0.5, 0.5)
		}, {
			UIAspectRatio = React.createElement("UIAspectRatioConstraint", {
				AspectRatio = 1
			}),
			UIListLayout = React.createElement("UIListLayout", {
				[React.Change.AbsoluteContentSize] = function(p1) --[[ Line: 94 | Upvalues: v2 (copy) ]]
					v2(p1.AbsoluteContentSize)
				end,
				HorizontalFlex = Enum.UIFlexAlignment.SpaceAround,
				HorizontalAlignment = Enum.HorizontalAlignment.Center,
				VerticalAlignment = Enum.VerticalAlignment.Bottom,
				FillDirection = Enum.FillDirection.Horizontal,
				SortOrder = Enum.SortOrder.LayoutOrder,
				Wraps = true,
				Padding = UDim.new(0, 6)
			})
		}, t3)
	}

	t5.CompleteCheckmark = if v8 then React.createElement("ImageLabel", {
	BackgroundTransparency = 1,
	ZIndex = 200,
	Image = "rbxassetid://14370703836",
	Size = UDim2.fromScale(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	ScaleType = Enum.ScaleType.Fit
}) else v8

	return React.createElement("Frame", t4, t5)
end)