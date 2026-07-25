-- https://lua.expert/
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local t = {}

t.__index = t
function t.new(p1) --[[ new | Line: 11 | Upvalues: t (copy), RunService (copy) ]]
	local v2 = setmetatable({
		bouquets_by_index = p1
	}, t)

	v2.connection = RunService.Heartbeat:Connect(function() --[[ Line: 16 | Upvalues: v2 (copy) ]]
		v2:_update()
	end)

	return v2
end
function t._update(p1) --[[ _update | Line: 23 | Upvalues: LocalPlayer (copy) ]]
	local Character = LocalPlayer.Character
	local v1 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character
	local v2 = if v1 then v1.Position * Vector3.new(1, 0, 1) else v1
	local t = {}
	local v3 = (1 / 0)
	local v4 = nil

	for v5, v6 in p1.bouquets_by_index do
		local v7 = if v2 then (v6.billboard_attachment.WorldPosition * Vector3.new(1, 0, 1) - v2).Magnitude else (1 / 0)

		t[v5] = v7

		if v7 < v3 then
			v3 = v7
			v4 = v5
		end
	end

	for v8, v9 in p1.bouquets_by_index do
		v9:set_proximity(t[v8], v8 == v4)
	end
end
function t.destroy(p1) --[[ destroy | Line: 46 ]]
	p1.connection:Disconnect()
end

return t