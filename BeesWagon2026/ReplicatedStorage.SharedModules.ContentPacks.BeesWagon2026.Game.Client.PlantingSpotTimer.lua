-- https://lua.expert/
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local CountdownTimer = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.Client.CountdownTimer)
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local LiveOpsTime = require(ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local SEED_TOOL_EQUIPPED_ATTRIBUTE = BeesWagonFlowerHelper.SEED_TOOL_EQUIPPED_ATTRIBUTE

local function PlantingSpotTimer(p1) --[[ PlantingSpotTimer | Line: 22 | Upvalues: React (copy), LocalPlayer (copy), SEED_TOOL_EQUIPPED_ATTRIBUTE (copy), Promise (copy), LiveOpsTime (copy), ReactRoblox (copy), CountdownTimer (copy) ]]
	local v1, v2 = React.useState(false)
	local v3, v4 = React.useState(function() --[[ Line: 26 | Upvalues: LocalPlayer (ref), SEED_TOOL_EQUIPPED_ATTRIBUTE (ref) ]]
		return LocalPlayer:GetAttribute(SEED_TOOL_EQUIPPED_ATTRIBUTE) == true
	end)

	React.useEffect(function() --[[ Line: 30 | Upvalues: LocalPlayer (ref), SEED_TOOL_EQUIPPED_ATTRIBUTE (ref), v4 (copy) ]]
		local v1 = LocalPlayer:GetAttributeChangedSignal(SEED_TOOL_EQUIPPED_ATTRIBUTE):Connect(function() --[[ Line: 31 | Upvalues: v4 (ref), LocalPlayer (ref), SEED_TOOL_EQUIPPED_ATTRIBUTE (ref) ]]
			v4(LocalPlayer:GetAttribute(SEED_TOOL_EQUIPPED_ATTRIBUTE) == true)
		end)

		return function() --[[ Line: 34 | Upvalues: v1 (copy) ]]
			v1:Disconnect()
		end
	end, {})
	React.useEffect(function() --[[ Line: 39 | Upvalues: Promise (ref), LocalPlayer (ref), v2 (copy), p1 (copy) ]]
		local v1 = Promise.new(function(p12, p2, p3) --[[ Line: 40 | Upvalues: LocalPlayer (ref), v2 (ref), p1 (ref) ]]
			while not p3() do
				local Character = LocalPlayer.Character
				local v1 = if Character then Character:FindFirstChild("HumanoidRootPart") else Character

				if v1 then
					v2(if (v1.CFrame.Position - p1.attachment.WorldPosition).Magnitude < 20 then true else false)
				else
					v2(false)
				end

				task.wait(1)
			end

			p12()
		end)

		return function() --[[ Line: 57 | Upvalues: v1 (copy) ]]
			v1:cancel()
		end
	end, { p1.attachment })

	local v5 = React.useMemo(function() --[[ Line: 62 | Upvalues: p1 (copy), LiveOpsTime (ref) ]]
		return math.max(0, p1.ready_at - LiveOpsTime.now())
	end, { p1.ready_at })
	local t = {
		StudsOffset = Vector3.new(0, 2, 0),
		StudsOffsetWorldSpace = Vector3.new(0, 2, 0),
		AlwaysOnTop = true,
		LightInfluence = 0,
		MaxDistance = 35,
		ClipsDescendants = false,
		Adornee = p1.attachment,
		Size = UDim2.fromOffset(160, 50)
	}
	local t2 = {}
	local t3 = {
		duration = v5
	}

	t3.in_range = if v1 then not v3 else v1
	t2.Timer = React.createElement(CountdownTimer, t3)

	return ReactRoblox.createPortal(React.createElement("BillboardGui", t, t2), p1.attachment)
end

return React.memo(PlantingSpotTimer)