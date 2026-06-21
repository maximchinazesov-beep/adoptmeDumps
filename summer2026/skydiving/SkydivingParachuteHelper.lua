-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingParachuteHelper
-- ==========================================

-- https://lua.expert/
local Players = game:GetService("Players")
local SkydivingConstants = require(script.Parent.SkydivingConstants)
local t = {
	MODEL_NAME = "SkydivingParachute"
}

local function for_each_base_part(p1, p2) --[[ for_each_base_part | Line: 19 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			p2(v2)
		end
	end
end

local function set_visible(p1, p2) --[[ set_visible | Line: 27 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") or (v2:IsA("Decal") or v2:IsA("Texture")) then
			v2.Transparency = if p2 then 0 else 1

			continue
		end

		if v2:IsA("ParticleEmitter") or (v2:IsA("Beam") or v2:IsA("Trail")) then
			v2.Enabled = p2
		end
	end
end

function t.is_open(p1) --[[ is_open | Line: 37 ]]
	if p1:IsA("Model") and p1.PrimaryPart then
		return p1.PrimaryPart.Transparency < 1
	end

	for v2, v3 in p1:GetDescendants() do
		if v3:IsA("BasePart") then
			return v3.Transparency < 1
		end
	end

	return false
end
function t.apply_local_transparency(p1, p2) --[[ apply_local_transparency | Line: 51 | Upvalues: for_each_base_part (copy) ]]
	for_each_base_part(p1, function(p1) --[[ Line: 52 | Upvalues: p2 (copy) ]]
		p1.LocalTransparencyModifier = p2
	end)
end
function t.clear_local_transparency(p1) --[[ clear_local_transparency | Line: 57 | Upvalues: t (copy) ]]
	t.apply_local_transparency(p1, 0)
end
function t.update_other_parachutes_local_transparency(p1) --[[ update_other_parachutes_local_transparency | Line: 61 | Upvalues: SkydivingConstants (copy), Players (copy), t (copy) ]]
	local PARACHUTE_LOCAL_TRANSPARENCY_MODIFIER = SkydivingConstants.PARACHUTE_LOCAL_TRANSPARENCY_MODIFIER

	for v1, v2 in Players:GetPlayers() do
		if v2 ~= p1 then
			local Character = v2.Character
			local v3 = if Character then Character:FindFirstChild(t.MODEL_NAME) else Character

			if v3 then
				if t.is_open(v3) then
					t.apply_local_transparency(v3, PARACHUTE_LOCAL_TRANSPARENCY_MODIFIER)

					continue
				end

				t.clear_local_transparency(v3)
			end
		end
	end
end
function t.clear_all_other_parachutes_local_transparency(p1) --[[ clear_all_other_parachutes_local_transparency | Line: 83 | Upvalues: Players (copy), t (copy) ]]
	for v1, v2 in Players:GetPlayers() do
		if v2 ~= p1 then
			local Character = v2.Character
			local v3 = if Character then Character:FindFirstChild(t.MODEL_NAME) else Character

			if v3 then
				t.clear_local_transparency(v3)
			end
		end
	end
end
function t.hide(p1) --[[ hide | Line: 97 | Upvalues: set_visible (copy) ]]
	set_visible(p1, false)
end
function t.show(p1) --[[ show | Line: 101 | Upvalues: set_visible (copy) ]]
	set_visible(p1, true)
end

return t

