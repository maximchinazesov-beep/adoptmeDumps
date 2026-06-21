-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local FishBiteTimer = require(script.Parent.FishBiteTimer)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local t = {}
local t2 = { "rbxassetid://117964839212224", "rbxassetid://111877624187256" }
local v1 = 0
local v2 = nil

function t.preload() --[[ preload | Line: 19 | Upvalues: v2 (ref), Promise (copy), t2 (copy) ]]
	if not v2 then
		v2 = Promise.try(function() --[[ Line: 24 | Upvalues: t2 (ref) ]]
			game:GetService("ContentProvider"):PreloadAsync(t2)
		end)
	end

	return v2
end
function t.mount(p1, p2, p3) --[[ mount | Line: 31 | Upvalues: v1 (ref), ReactRoblox (copy), React (copy), FishBiteTimer (copy) ]]
	v1 = v1 + 1

	local v12 = v1
	local FishBiteBillboardGui = Instance.new("BillboardGui")

	FishBiteBillboardGui.Name = "FishBiteBillboardGui"
	FishBiteBillboardGui.Active = true
	FishBiteBillboardGui.AlwaysOnTop = true
	FishBiteBillboardGui.LightInfluence = 1
	FishBiteBillboardGui.Size = UDim2.fromOffset(100, 100)
	FishBiteBillboardGui.SizeOffset = Vector2.new(0, 0.5)
	FishBiteBillboardGui.StudsOffset = Vector3.new(0, 1, 0)
	FishBiteBillboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	FishBiteBillboardGui.Adornee = p1
	FishBiteBillboardGui.Parent = p1

	local Host = Instance.new("Frame")

	Host.Name = "Host"
	Host.BackgroundTransparency = 1
	Host.Size = UDim2.fromScale(1, 1)
	Host.Parent = FishBiteBillboardGui

	local v2 = ReactRoblox.createRoot(Host)

	task.defer(function() --[[ Line: 55 | Upvalues: FishBiteBillboardGui (copy), v2 (copy), React (ref), FishBiteTimer (ref), p2 (copy), v12 (copy) ]]
		if FishBiteBillboardGui.Parent then
			v2:render(React.createElement(FishBiteTimer, {
				duration = p2,
				mount_key = v12
			}))
		end
	end)
	p3(function() --[[ Line: 66 | Upvalues: v2 (copy), FishBiteBillboardGui (copy) ]]
		v2:render(nil)
		FishBiteBillboardGui:Destroy()
	end)
end

return t