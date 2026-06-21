-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingLeaderboardApp
-- ==========================================

-- https://lua.expert/
local SkydivingNetService = require(script.Parent.SkydivingNetService)
local t = { "Order", "Place" }
local t2 = { "DisplayName" }
local t3 = { "Timestamp", "Timer" }

local function format_time(p1) --[[ format_time | Line: 9 ]]
	return string.format("%d:%06.3f", math.floor(p1 / 60), p1 % 60)
end

local function find_text_label(p1, p2) --[[ find_text_label | Line: 15 ]]
	for v1, v2 in p2 do
		local v3 = p1:FindFirstChild(v2)

		if v3 and v3:IsA("TextLabel") then
			return v3
		end
	end

	return nil
end

local function clear_rows(p1) --[[ clear_rows | Line: 25 ]]
	for v1, v2 in p1:GetChildren() do
		if v2:GetAttribute("SkydivingLeaderboardRow") then
			v2:Destroy()
		end
	end
end

local function populate_row(p1, p2, p3) --[[ populate_row | Line: 33 | Upvalues: find_text_label (copy), t (copy), t2 (copy), t3 (copy) ]]
	local v1 = find_text_label(p1, t)

	if v1 then
		v1.Text = tostring(p2)
	end

	local v2 = find_text_label(p1, t2)

	if v2 then
		v2.Text = p3.display_name
	end

	local v3 = find_text_label(p1, t3)

	if not v3 then
		return
	end

	local v4 = p3.time

	v3.Text = string.format("%d:%06.3f", math.floor(v4 / 60), v4 % 60)
end

local function render_rows(p1, p2, p3) --[[ render_rows | Line: 50 | Upvalues: clear_rows (copy), populate_row (copy) ]]
	p2.Visible = false
	clear_rows(p1)

	for v1, v2 in p3 do
		local v3 = p2:Clone()

		v3:SetAttribute("SkydivingLeaderboardRow", true)
		v3.Name = "LeaderboardEntry_" .. v1
		v3.LayoutOrder = v1
		v3.Visible = true
		populate_row(v3, v1, v2)
		v3.Parent = p1
	end
end

return {
	mount = function(p1, p2, p3) --[[ mount | Line: 67 | Upvalues: SkydivingNetService (copy), render_rows (copy), clear_rows (copy) ]]
		p3((SkydivingNetService.LeaderboardSync:on_client_event(function(p12) --[[ Line: 68 | Upvalues: render_rows (ref), p1 (copy), p2 (copy) ]]
			render_rows(p1, p2, p12.entries or {})
		end)))
		p3(function() --[[ Line: 73 | Upvalues: clear_rows (ref), p1 (copy) ]]
			clear_rows(p1)
		end)
		SkydivingNetService.RequestLeaderboardSync:fire_server({})
	end
}

