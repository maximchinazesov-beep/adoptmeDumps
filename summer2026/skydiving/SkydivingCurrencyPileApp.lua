-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingCurrencyPileApp
-- ==========================================

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Debris = game:GetService("Debris")
local React = require(ReplicatedStorage.SharedPackages.React)
local ClientData = require(ReplicatedStorage.ClientModules.Core.ClientData)
local SkydivingConstants = require(script.Parent.SkydivingConstants)

local function SkydivingCurrencyPileApp(p1) --[[ SkydivingCurrencyPileApp | Line: 11 | Upvalues: React (copy), ClientData (copy), SkydivingConstants (copy), ReplicatedStorage (copy), Debris (copy) ]]
	local currency_piles_folder = p1.currency_piles_folder
	local collection_sign_part = p1.collection_sign_part
	local v1, v2 = React.useState(function() --[[ Line: 15 | Upvalues: ClientData (ref) ]]
		local v1 = ClientData.get("skydiving_manager")

		return if v1 then v1.pending_currency or 0 else 0
	end)

	React.useEffect(function() --[[ Line: 20 | Upvalues: ClientData (ref), v2 (copy) ]]
		local function update() --[[ update | Line: 21 | Upvalues: ClientData (ref), v2 (ref) ]]
			local v1 = ClientData.get("skydiving_manager")

			v2(if v1 then v1.pending_currency or 0 else 0)
		end

		local v1 = ClientData.get("skydiving_manager")
		local v22 = v2

		v22(if v1 then v1.pending_currency or 0 else 0)

		return ClientData.register_callback("skydiving_manager", update)
	end, {})

	if currency_piles_folder then
		for v3, v4 in currency_piles_folder:GetDescendants() do
			if v4:IsA("BasePart") then
				v4.Transparency = 1
			end
		end
	end

	local v5 = React.useRef(0)

	React.useEffect(function() --[[ Line: 38 | Upvalues: currency_piles_folder (copy), SkydivingConstants (ref), v1 (copy), v5 (copy), collection_sign_part (copy), ReplicatedStorage (ref), Debris (ref) ]]
		if not currency_piles_folder then
			return
		end

		local v2 = if v1 == 0 then 0 else math.clamp(math.ceil(v1 / (SkydivingConstants.CURRENCY_PILE_AMOUNT_FOR_MAX_STAGE / 4)), 1, 4)

		if v2 ~= v5.current then
			v5.current = v2

			local v52 = collection_sign_part and collection_sign_part.Position - Vector3.new(0, 6, 0) or Vector3.new()
			local IceSkating = ReplicatedStorage.Resources:FindFirstChild("IceSkating")

			if IceSkating then
				local SpawnPoof = IceSkating:FindFirstChild("SpawnPoof")

				if SpawnPoof then
					local v6 = SpawnPoof:Clone()

					v6.Position = v52
					v6.Parent = workspace
					v6.Clouds1:Emit(20)
					v6.Clouds2:Emit(10)
					Debris:AddItem(v6, 5)
				end
			end
		end

		if v2 == 0 then
			return
		end

		local v7 = currency_piles_folder:FindFirstChild("CurrencyPile" .. tostring(v2))

		if not v7 then
			return function() --[[ Line: 76 | Upvalues: currency_piles_folder (ref) ]]
				if not currency_piles_folder then
					return
				end

				for v1, v2 in currency_piles_folder:GetDescendants() do
					if v2:IsA("BasePart") then
						v2.Transparency = 1
					end
				end
			end
		end

		for v8, v9 in v7:GetDescendants() do
			if v9:IsA("BasePart") then
				v9.Transparency = 0
			end
		end

		return function() --[[ Line: 76 | Upvalues: currency_piles_folder (ref) ]]
			if not currency_piles_folder then
				return
			end

			for v1, v2 in currency_piles_folder:GetDescendants() do
				if v2:IsA("BasePart") then
					v2.Transparency = 1
				end
			end
		end
	end, { v1 })

	local v6 = tostring(v1)

	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.fromScale(0.5, 1),
		Size = UDim2.fromScale(1, 0.5)
	}, {
		uIListLayout = React.createElement("UIListLayout", {
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
			Padding = UDim.new(0, 0)
		}),
		collectTitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 1,
			Text = "COLLECT YOUR",
			TextScaled = true,
			FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
			Size = UDim2.fromScale(1, 0.275),
			TextColor3 = Color3.fromRGB(249, 168, 121)
		}, {
			uIStroke = React.createElement("UIStroke", {
				Thickness = 0.1,
				Color = Color3.fromRGB(82, 54, 10),
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			}),
			uIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)),
					ColorSequenceKeypoint.new(0.383333, Color3.fromRGB(164, 165, 167)),
					ColorSequenceKeypoint.new(0.539, Color3.fromRGB(251, 252, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 136, 138))
				})
			})
		}),
		currencyTitle = React.createElement("TextLabel", {
			BackgroundTransparency = 1,
			LayoutOrder = 2,
			Text = "ACORNS",
			TextScaled = true,
			FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
			Size = UDim2.fromScale(1, 0.275),
			TextColor3 = Color3.fromRGB(249, 168, 121)
		}, {
			uIStroke = React.createElement("UIStroke", {
				Thickness = 0.1,
				Color = Color3.fromRGB(82, 54, 10),
				StrokeSizingMode = Enum.StrokeSizingMode.ScaledSize
			}),
			uIGradient = React.createElement("UIGradient", {
				Rotation = 90,
				Color = ColorSequence.new({
					ColorSequenceKeypoint.new(0, Color3.new(255/255, 255/255, 255/255)),
					ColorSequenceKeypoint.new(0.383333, Color3.fromRGB(164, 165, 167)),
					ColorSequenceKeypoint.new(0.539, Color3.fromRGB(251, 252, 255)),
					ColorSequenceKeypoint.new(1, Color3.fromRGB(136, 136, 138))
				})
			})
		}),
		progress = React.createElement("Frame", {
			LayoutOrder = 3,
			BackgroundColor3 = Color3.fromRGB(82, 54, 10),
			Size = UDim2.fromScale(0.5, 0.2)
		}, {
			uICorner = React.createElement("UICorner", {
				CornerRadius = UDim.new(1, 0)
			}),
			totalPending = React.createElement("TextLabel", {
				BackgroundTransparency = 1,
				TextScaled = true,
				AnchorPoint = Vector2.new(0, 0.5),
				FontFace = Font.new("rbxasset://fonts/families/FredokaOne.json"),
				Position = UDim2.fromScale(0, 0.5),
				Size = UDim2.fromScale(1, 0.8),
				Text = v6,
				TextColor3 = Color3.fromRGB(247, 192, 255)
			})
		})
	})
end

return React.memo(SkydivingCurrencyPileApp)

