-- https://lua.expert/
local TextService = game:GetService("TextService")
local load = require(game.ReplicatedStorage:WaitForChild("Fsys")).load
local v1 = load("Class")
local v2 = load("InventoryDB")
local v3 = load("SoundPlayer")
local v4 = load("XboxSupport")
local v5 = load("package:Promise")
local v6 = v1("SeedShopApp", load("UIBaseApp"))
local t = { "bees_wagon_2026_rose_seeds", "bees_wagon_2026_iris_seeds", "bees_wagon_2026_daisy_seeds", "bees_wagon_2026_poppy_seeds", "bees_wagon_2026_bluebell_seeds", "bees_wagon_2026_fern_seeds" }

table.sort(t, function(p1, p2) --[[ Line: 23 | Upvalues: v2 (copy) ]]
	return (v2.toys[p1] and v2.toys[p1].cost or 0) < (v2.toys[p2] and v2.toys[p2].cost or 0)
end)
function v6.view(p1) --[[ view | Line: 31 ]]
	if not p1.UIManager.is_visible("SeedShopApp") then
		p1.UIManager.set_app_visibility(p1.ClassName, true)
	end
end
function v6.close(p1) --[[ close | Line: 36 ]]
	p1.UIManager.set_app_visibility(p1.ClassName, false)
end
function v6._attempt_to_buy(p1, p2) --[[ _attempt_to_buy | Line: 42 | Upvalues: load (copy) ]]
	return load("ShopM").buy_item({
		category = "toys",
		kind = p2
	})
end
function v6._render(p1) --[[ _render | Line: 50 | Upvalues: t (copy), v2 (copy), TextService (copy), v5 (copy) ]]
	for v1, v22 in p1.scrolling_frame:GetChildren() do
		if v22:IsA("Frame") then
			v22:Destroy()
		end
	end

	p1.first_buy_button = nil

	local count = 0

	for v3, v4 in t do
		local v52 = v2.toys[v4]

		if v52 then
			count = count + 1

			local v6 = p1.item_template:Clone()

			v6.Name = v4
			v6.LayoutOrder = v3
			v6.Title.Text = v52.name
			v6.Item.ItemImage.Image = v52.image

			local TypeLabel = v6.Price.TypeLabel

			TypeLabel.Text = tostring(v52.cost or 0)

			local GetTextBoundsParams = Instance.new("GetTextBoundsParams")

			GetTextBoundsParams.Text = TypeLabel.Text
			GetTextBoundsParams.Font = TypeLabel.FontFace
			GetTextBoundsParams.Size = TypeLabel.TextSize
			GetTextBoundsParams.Width = (1 / 0)
			v6.Price.Icon.Position = UDim2.new(0, TypeLabel.Position.X.Offset + TextService:GetTextBoundsAsync(GetTextBoundsParams).X + 5, 0, 0)

			local ClaimButton = v6.ButtonFrame.ClaimButton
			local v9 = false

			p1.UIManager.wrap(ClaimButton, "DepthButton"):start({
				mouse_button1_click = function() --[[ mouse_button1_click | Line: 95 | Upvalues: v9 (ref), p1 (copy), v4 (copy), v5 (ref) ]]
					if not v9 then
						v9 = true
						p1:_attempt_to_buy(v4)
						v5.delay(1):andThen(function() --[[ Line: 99 | Upvalues: v9 (ref) ]]
							v9 = false
						end)
					end
				end
			})

			if not p1.first_buy_button then
				p1.first_buy_button = ClaimButton
			end

			v6.Parent = p1.scrolling_frame
		end
	end

	local v10 = p1.scrolling_frame:FindFirstChildWhichIsA("UIListLayout")
	local v11 = if v10 then v10.Padding.Offset or 0 else 0

	p1.scrolling_frame.CanvasSize = UDim2.new(0, 0, 0, (math.max(0, count * p1.item_template.Size.Y.Offset + math.max(0, count - 1) * v11)))
end
function v6.show(p1) --[[ show | Line: 121 | Upvalues: v3 (copy) ]]
	p1.body.Visible = true
	v3.Interface:play("TaskBoard/Open")
	p1:_render()
end
function v6.hide(p1) --[[ hide | Line: 127 | Upvalues: v3 (copy) ]]
	p1.body.Visible = false

	if p1.is_initial_hide then
		p1.is_initial_hide = false
	else
		v3.Interface:play("TaskBoard/Close")
	end
end
function v6.refresh(p1, p2) --[[ refresh | Line: 137 ]]
	local v1 = p1.UIManager.is_closed({ "MainMenuApp", "MannequinPurchaseApp", "JackboxRewardApp", "StickerRewardsApp", "TradePreviewApp", "TradeHistoryApp", "MinigameRewardsApp", "MinigameNewsPaperApp" })

	if not p2[p1.ClassName] then
		v1 = false
	end

	p1:set_visibility(v1)
end
function v6.start(p1) --[[ start | Line: 156 | Upvalues: v4 (copy) ]]
	p1.body = p1.instance.Body
	p1.inner_body = p1.body.InnerBody
	p1.header = p1.body.Header
	p1.scrolling_frame = p1.inner_body.ScrollingFrame
	p1.item_template = p1.scrolling_frame.ItemTemplate
	p1.item_template.Parent = nil
	p1.first_buy_button = nil
	p1.is_initial_hide = true
	p1.exit_button = p1.UIManager.wrap(p1.header.ExitFrame.ExitButton, "DepthButton"):start({
		mouse_button1_click = function() --[[ mouse_button1_click | Line: 167 | Upvalues: p1 (copy) ]]
			p1:close()
		end
	})
	p1.watch = v4.quick_watch({
		selection_parent = p1.body,
		default_selection = function() --[[ default_selection | Line: 174 | Upvalues: p1 (copy) ]]
			if p1.first_buy_button then
				return p1.first_buy_button
			end

			return p1.scrolling_frame
		end,
		app_name = p1.ClassName,
		exit_buttons = { p1.header.ExitFrame.ExitButton }
	})
end

return v6