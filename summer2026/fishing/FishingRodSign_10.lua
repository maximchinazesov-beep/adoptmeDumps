-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishingRodSignThemes = require(script.Parent.FishingRodSignThemes)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local React = require(ReplicatedStorage.SharedPackages.React)
local v1 = Color3.fromRGB(152, 152, 152)
local v2 = React.createElement("UICorner", {
	BottomLeftRadius = UDim.new(1, 0),
	BottomRightRadius = UDim.new(1, 0),
	TopLeftRadius = UDim.new(1, 0),
	TopRightRadius = UDim.new(1, 0)
})
local v3 = React.createElement("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(154, 156, 156)) })
})
local v4 = React.createElement("UIStroke", {
	Thickness = 2.5,
	Color = Color3.new(255/255, 255/255, 255/255)
}, {
	uIGradient = React.createElement("UIGradient", {
		Rotation = 100,
		Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(1, 1) })
	})
})

local function create_label_gradient(p1) --[[ create_label_gradient | Line: 45 | Upvalues: React (copy) ]]
	return React.createElement("UIGradient", {
		Rotation = -90,
		Color = p1
	})
end

local function create_fish_emojis() --[[ create_fish_emojis | Line: 52 | Upvalues: React (copy) ]]
	return {
		fishEmoji = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = "\240\159\144\159",
			TextScaled = true,
			ZIndex = 2,
			AnchorPoint = Vector2.new(0.5, 0.5),
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1),
			TextColor3 = Color3.new()
		}),
		fishEmoji2 = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			Text = "\240\159\144\159",
			TextScaled = true,
			TextTransparency = 0.5,
			AnchorPoint = Vector2.new(0.5, 0.5),
			FontFace = Font.new("rbxasset://fonts/families/SourceSansPro.json"),
			Position = UDim2.fromScale(0.5, 0.5),
			Size = UDim2.fromScale(1, 1.25),
			TextColor3 = Color3.new()
		}, {
			uIGradient = React.createElement("UIGradient", {
				Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new()), ColorSequenceKeypoint.new(1, Color3.new()) })
			})
		})
	}
end

local function FishingRodSign(p1) --[[ FishingRodSign | Line: 86 | Upvalues: FishingRodSignThemes (copy), React (copy), TweenPromise (copy), create_fish_emojis (copy), v2 (copy), v4 (copy), v3 (copy), v1 (copy) ]]
	local v12 = FishingRodSignThemes[p1.theme]
	local v22 = React.useRef(nil)
	local isIs_maxed = p1.is_maxed == true
	local v32 = if p1.required > 0 then if p1.caught >= p1.required then true else false else false
	local v42 = v12.showFillBar and (not v32 and not isIs_maxed)
	local v5 = if p1.required > 0 then math.clamp(p1.caught / p1.required, 0, 1) else 0

	React.useEffect(function() --[[ Line: 95 | Upvalues: v42 (copy), v22 (copy), TweenPromise (ref), v5 (copy) ]]
		if not v42 then
			return
		end

		local current = v22.current

		if current then
			local v1 = TweenPromise.new(current, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				Size = UDim2.fromScale(v5, 1)
			})

			return function() --[[ Line: 109 | Upvalues: v1 (copy) ]]
				v1:cancel()
			end
		end
	end, { v5, v42, v12.fillChildName })

	if not p1.visible then
		return nil
	end

	local v7 = if isIs_maxed then "MASTERED" else v12.fishCollectedText or (if v32 then "CLAIM NOW!" else ("%*/%* FISH"):format(p1.caught, p1.required))
	local t = {
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
		Padding = UDim.new(0.02, 0),
		SortOrder = Enum.SortOrder.LayoutOrder
	}

	if v12.listVerticalAlignment then
		t.VerticalAlignment = v12.listVerticalAlignment
	end

	local v9 = create_fish_emojis()
	local v10 = React.createElement("Frame", {
		BackgroundColor3 = Color3.fromRGB(38, 187, 255),
		Size = UDim2.fromScale(v5, 1),
		ref = v22
	}, {
		uICorner = v2,
		uIGradient = React.createElement("UIGradient", {
			Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 168, 255)) })
		}),
		fishEmoji = v9.fishEmoji,
		fishEmoji2 = v9.fishEmoji2
	})
	local t2 = {
		uICorner = v2,
		uIStroke = React.createElement("UIStroke", {
			Thickness = 2,
			ZIndex = 2,
			Color = v12.fillBarStroke
		}),
		uIStroke2 = v4,
		uIGradient = v3,
		[v12.fillChildName] = v10
	}
	local t3 = {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1)
	}
	local t4 = {}
	local t5 = {
		BackgroundTransparency = 1,
		LayoutOrder = 1,
		TextScaled = true,
		AnchorPoint = Vector2.new(0.5, 0),
		FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromScale(0.9, 0.3),
		Text = v12.rodTitleText,
		TextColor3 = Color3.new(255/255, 255/255, 255/255)
	}
	local t6 = {
		uIStroke = React.createElement("UIStroke", {
			Thickness = 2,
			Color = v1
		})
	}

	t6.themeGradient = React.createElement("UIGradient", {
		Rotation = -90,
		Color = v12.labelGradient
	})
	t4.rodTitle = React.createElement("TextLabel", t5, t6)
	t4.fishCollected = React.createElement("TextLabel", {
		BackgroundTransparency = 1,
		LayoutOrder = 3,
		TextScaled = true,
		AnchorPoint = Vector2.new(0.5, 0),
		FontFace = Font.new("rbxasset://fonts/families/LuckiestGuy.json"),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromScale(0.9, 0.25),
		Text = v7,
		TextColor3 = Color3.new(255/255, 255/255, 255/255)
	}, {
		uIStroke = React.createElement("UIStroke", {
			Thickness = 2,
			Color = v1
		}),
		themeGradient = React.createElement("UIGradient", {
			Rotation = -90,
			Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(170, 204, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(1, 124, 255)) })
		})
	})
	t4.uIListLayout = React.createElement("UIListLayout", t)
	t4.fillBar = React.createElement("Frame", {
		LayoutOrder = 2,
		BackgroundColor3 = v12.fillBarBackground,
		Size = UDim2.fromScale(1, 0.2),
		Visible = v42
	}, t2)

	return React.createElement("Frame", t3, t4)
end

return React.memo(FishingRodSign)