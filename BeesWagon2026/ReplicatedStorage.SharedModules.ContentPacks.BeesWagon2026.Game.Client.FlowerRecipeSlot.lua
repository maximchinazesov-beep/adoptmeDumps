-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local React = require(ReplicatedStorage.SharedPackages.React)
local UsePopScale = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.UsePopScale)

local function FlowerRecipeSlot(p1) --[[ FlowerRecipeSlot | Line: 16 | Upvalues: UsePopScale (copy), React (copy), BeesWagonFlowerHelper (copy) ]]
	local v1 = p1.placed_amount >= p1.recipe_amount
	local v4 = UsePopScale(p1.all_complete or not v1 or p1.enlarged, 0, 1)
	local v7 = UsePopScale(if v1 then p1.enlarged else v1, 1, 0.8)
	local v8 = UsePopScale(p1.enlarged, 0, 1)
	local v9 = v4:map(function(p1) --[[ Line: 23 ]]
		return p1 > 0
	end)
	local t = {
		BackgroundTransparency = 1,
		LayoutOrder = p1.layout_order,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = v4:map(function(p1) --[[ Line: 32 ]]
			return UDim2.fromScale(0.67 * p1, 0.4 * p1)
		end),
		Visible = v9
	}
	local t2 = {
		UIAspectRatio = React.createElement("UIAspectRatioConstraint", {
			AspectRatio = 1
		}),
		UIFlexItem = React.createElement("UIFlexItem", {
			FlexMode = Enum.UIFlexMode.None,
			ItemLineAlignment = Enum.ItemLineAlignment.Center
		})
	}
	local t3 = {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = v7:map(function(p1) --[[ Line: 48 ]]
			return UDim2.fromScale(p1, p1)
		end)
	}
	local t4 = {
		FlowerImage = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			Image = BeesWagonFlowerHelper.FLOWER_ICONS[p1.flower_kind],
			Size = UDim2.fromScale(1, 1)
		}),
		FlowerShadow = React.createElement("ImageLabel", {
			BackgroundTransparency = 1,
			ZIndex = -5,
			Image = BeesWagonFlowerHelper.FLOWER_ICONS[p1.flower_kind],
			ImageColor3 = Color3.new(0/255, 0/255, 0/255),
			Size = UDim2.fromScale(1.2, 1.1),
			AnchorPoint = Vector2.new(0.5, 0.5),
			Position = UDim2.fromScale(0.5, 0.5)
		})
	}

	t4.Checkmark = if v1 then not p1.all_complete and React.createElement("ImageLabel", {
	BackgroundTransparency = 1,
	ZIndex = 100,
	Image = "rbxassetid://14370703836",
	Size = UDim2.fromScale(0.7, 0.7),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	ScaleType = Enum.ScaleType.Fit
}) else v1

	local t5 = {
		ZIndex = 10,
		Position = UDim2.fromScale(0.6, 0.6),
		Size = v8:map(function(p1) --[[ Line: 79 ]]
			return UDim2.fromScale(0.5 * p1, 0.5 * p1)
		end),
		BackgroundColor3 = Color3.new(255/255, 255/255, 255/255)
	}
	local t6 = {
		UICorner = React.createElement("UICorner", {
			CornerRadius = UDim.new(0.1, 0)
		})
	}
	local t7 = {
		BackgroundTransparency = 1,
		TextScaled = true,
		Font = Enum.Font.FredokaOne,
		Size = UDim2.fromScale(0.5, 0.5)
	}

	t7.Text = math.min(p1.placed_amount, p1.recipe_amount)
	t7.Position = UDim2.fromScale(0.02, 0.02)
	t6.Numerator = React.createElement("TextLabel", t7)
	t6.Denominator = React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		TextScaled = true,
		Font = Enum.Font.FredokaOne,
		Size = UDim2.fromScale(0.5, 0.5),
		Text = p1.recipe_amount,
		AnchorPoint = Vector2.new(1, 1),
		Position = UDim2.fromScale(0.98, 0.98)
	})
	t6.Divisor = React.createElement("Frame", {
		BorderSizePixel = 0,
		Rotation = 45,
		BackgroundColor3 = Color3.new(0/255, 0/255, 0/255),
		Size = UDim2.fromScale(0.05, 1),
		Position = UDim2.fromScale(0.5, 0.5),
		AnchorPoint = Vector2.new(0.5, 0.5)
	})
	t4.CounterFrame = React.createElement("Frame", t5, t6)
	t2.Content = React.createElement("Frame", t3, t4)

	return React.createElement("Frame", t, t2)
end

return React.memo(FlowerRecipeSlot)