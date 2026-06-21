-- https://lua.expert/
local ClientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local FishBiteTimerClient = require(script.Parent.FishBiteTimerClient)
local FishingRodState = require(script.Parent.FishingRodState)

require(script.Parent.FishingTypes)

local FishState = require(script.Parent.FishState)

require(script.Parent.FishingNetService)

local Maid = require(game.ReplicatedStorage.SharedModules.Maid)
local Fishing = game.ReplicatedStorage.Resources.Fishing
local v1 = Random.new()

return {
	render = function(p1, p2) --[[ render | Line: 15 | Upvalues: Maid (copy), FishBiteTimerClient (copy), Fishing (copy), v1 (copy), FishState (copy), ClientData (copy) ]]
		local v12 = p2.fishing_maid or Maid.new()

		p2.fishing_maid = v12
		v12:DoCleaning()
		FishBiteTimerClient.preload()

		local t = {}
		local FishingHotspots = p1:FindFirstChild("FishingHotspots")

		v12:GiveTask(function() --[[ Line: 26 | Upvalues: t (ref) ]]
			for v1, v2 in t do
				v2:exit_state()
			end

			t = {}
		end)

		local function on_hotspots_refreshed(p1, p2) --[[ on_hotspots_refreshed | Line: 33 | Upvalues: t (ref), FishingHotspots (copy), Fishing (ref), v1 (ref), FishState (ref) ]]
			print("refreshing hotspots client")

			local t2 = {}

			for v12, v2 in p1 do
				for v3, v4 in v2 do
					t2[v3] = true
				end
			end

			for v5, v6 in t do
				if not t2[v5] then
					v6:enter_state("despawn")
				end
			end

			for v7, v8 in p1 do
				local v9 = FishingHotspots:FindFirstChild(v7)

				if v9 then
					local Location = v9:FindFirstChild("Location")
					local Fish = v9:FindFirstChild("Fish")

					for v10, v11 in v8 do
						if not (p2[v10] or t[v10]) then
							local v12 = Fishing.Fish:FindFirstChild(v11):Clone()

							v12.Name = v10
							v12:PivotTo(Location.CFrame * CFrame.new(v1:NextInteger(-10, 10), 0, v1:NextInteger(-10, 10)))
							v12.Parent = Fish

							local v13 = FishState.new(v7, v10, v11, v12, Location)

							v13:set_value("fish_kind", v11)
							v13:cleanup_on_exit_state(function() --[[ Line: 73 | Upvalues: v12 (copy), t (ref), v10 (copy) ]]
								v12:Destroy()
								t[v10] = nil
							end)
							t[v10] = v13
							v13:enter_state("swim")
						end
					end
				end
			end
		end

		v12:GiveTask(ClientData.register_callback_plus_existing("fishing_manager", function(p1, p2) --[[ Line: 83 | Upvalues: on_hotspots_refreshed (copy) ]]
			if p2 then
				on_hotspots_refreshed(p2.hotspots, p2.depleted_fish)
			end
		end))
	end,
	cleanup = function(p1, p2) --[[ cleanup | Line: 89 | Upvalues: FishingRodState (copy) ]]
		FishingRodState:exit_state()

		if not p2.fishing_maid then
			return
		end

		p2.fishing_maid:DoCleaning()
	end
}