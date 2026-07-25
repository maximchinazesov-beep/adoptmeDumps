-- https://lua.expert/
local ChangeHistoryService = game:GetService("ChangeHistoryService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local BeesWagonFlowerHelper = require(ReplicatedStorage.SharedModules.ContentPacks.BeesWagon2026.Game.BeesWagonFlowerHelper)
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local Signal = require(ReplicatedStorage.SharedModules.Signal)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local React = require(ReplicatedStorage.SharedPackages.React)
local ReactRoblox = require(ReplicatedStorage.SharedPackages.ReactRoblox)
local PottedBouquet = require(script.Parent.PottedBouquet)

local function app(p1) --[[ app | Line: 12 | Upvalues: React (copy) ]]
	return React.createElement("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(0.2, 0.4)
	}, {
		UIListLayout = React.createElement("UIListLayout", {
			FillDirection = Enum.FillDirection.Vertical,
			Padding = UDim.new(0, 4)
		}),
		Refresh = React.createElement("TextButton", {
			Text = "Refresh",
			Size = UDim2.fromScale(1, 0.5),
			LayoutOrder = 1,
			[React.Event.Activated] = p1.on_refresh
		}),
		Complete = React.createElement("TextButton", {
			Text = "Complete",
			Size = UDim2.fromScale(1, 0.5),
			LayoutOrder = 2,
			[React.Event.Activated] = p1.on_complete
		})
	})
end

local function story_async(p1, p2, p3) --[[ story_async | Line: 36 | Upvalues: PottedBouquet (copy), BeesWagonFlowerHelper (copy), ReactRoblox (copy), React (copy), app (copy) ]]
	local v2 = PottedBouquet.new(workspace.BouquetTemplate:GetPivot(), "1")

	p1:GiveTask(v2)

	local function refresh_bouquet() --[[ refresh_bouquet | Line: 44 | Upvalues: BeesWagonFlowerHelper (ref), v2 (copy) ]]
		local v1 = BeesWagonFlowerHelper.generate_random_bouquet(math.random(1, 1000000))
		local t = {}

		for i = 1, BeesWagonFlowerHelper.FLOWERS_PER_BOUQUET - 1 do
			t[i] = v1[i]
		end

		v2:set_state(t)
	end

	refresh_bouquet()

	local function complete_bouquet() --[[ complete_bouquet | Line: 58 | Upvalues: v2 (copy) ]]
		v2:set_complete()
	end

	local v3 = ReactRoblox.createRoot(Instance.new("Folder"))

	local function rerender(p1) --[[ rerender | Line: 63 | Upvalues: v3 (copy), ReactRoblox (ref), React (ref), app (ref), refresh_bouquet (copy), complete_bouquet (copy), p2 (copy) ]]
		v3:render(ReactRoblox.createPortal(React.createElement(app, {
			on_refresh = refresh_bouquet,
			on_complete = complete_bouquet
		}), p2.target))
	end

	local controls = p2.controls

	v3:render(ReactRoblox.createPortal(React.createElement(app, {
		on_refresh = refresh_bouquet,
		on_complete = complete_bouquet
	}), p2.target))
	p1:GiveTask(p3:Connect(rerender))
end

return {
	summary = "",
	controls = {},
	render = function(p1) --[[ render | Line: 77 | Upvalues: Maid (copy), Signal (copy), ChangeHistoryService (copy), Promise (copy), story_async (copy) ]]
		local v1 = Maid.new()
		local v2 = Signal.new()
		local v3 = ChangeHistoryService:TryBeginRecording("story")

		if v3 then
			v1:GiveTask(Promise.try(story_async, v1, p1, v2):catch(warn):finally(function() --[[ Line: 86 | Upvalues: ChangeHistoryService (ref), v3 (copy) ]]
				ChangeHistoryService:FinishRecording(v3, Enum.FinishRecordingOperation.Commit)
			end))
			v1:GiveTask((p1.subscribe(function(p13, p23) --[[ Line: 90 | Upvalues: v2 (copy) ]]
				local v1 = false

				for v22, v3 in p23 do
					if v3.__new ~= v3.__old then
						v1 = true

						break
					end
				end

				if v1 then
					v2:Fire(p13)
				end
			end)))

			return function() --[[ Line: 106 | Upvalues: v1 (copy) ]]
				v1:DoCleaning()
			end
		end

		ChangeHistoryService:FinishRecording("story", Enum.FinishRecordingOperation.Cancel)
		v1:GiveTask(Promise.try(story_async, v1, p1, v2):catch(warn):finally(function() --[[ Line: 86 | Upvalues: ChangeHistoryService (ref), v3 (copy) ]]
			ChangeHistoryService:FinishRecording(v3, Enum.FinishRecordingOperation.Commit)
		end))
		v1:GiveTask((p1.subscribe(function(p13, p23) --[[ Line: 90 | Upvalues: v2 (copy) ]]
			local v1 = false

			for v22, v3 in p23 do
				if v3.__new ~= v3.__old then
					v1 = true

					break
				end
			end

			if v1 then
				v2:Fire(p13)
			end
		end)))

		return function() --[[ Line: 106 | Upvalues: v1 (copy) ]]
			v1:DoCleaning()
		end
	end
}