-- https://lua.expert/
local load = require(game.ReplicatedStorage.Fsys).load
local v1 = load("new:RoamingPetAdoptionClient")
local v2 = load("PositionProvider")
local v3 = load("package:Sift")
local RANDOM = v1.RANDOM

return v3.Dictionary.map({
	honey = {
		bee = 3,
		king_bee = 1,
		queen_bee = 1
	}
}, function(p1, p2) --[[ Line: 16 | Upvalues: RANDOM (copy), v2 (copy), v1 (copy) ]]
	return {
		spawn_when_thrown_options = {
			spawn_delay = 1,
			pets_to_spawn = p1,
			capture_barks = { "STRIKE STRIKE STRIKE", "GIVE ME MY HONEY!", "BZZZZZZZZZZZZZZZZZZZZZ", "HONEY ISNT FUNNY IT BELONGS IN MY TUMMY!", "Who would have guessed there was an island around the coffee shop...", "FAIR WAGES FOR WORKER BEES", "I can only make so much of a buzz by myself..." },
			get_spawn_positions = function(p1, p2) --[[ get_spawn_positions | Line: 30 | Upvalues: RANDOM (ref) ]]
				local t = {}

				for i = 1, p2 do
					local v1 = RANDOM:NextInteger(-10, 10)
					local v2 = RANDOM:NextInteger(20, 40)
					local v3 = RANDOM:NextInteger(-10, 10)

					table.insert(t, p1:GetPivot().Position + Vector3.new(v1, v2, v3))
				end

				return t
			end,
			get_swarm_locations = function(p1, p2, p3) --[[ get_swarm_locations | Line: 41 | Upvalues: v2 (ref), RANDOM (ref) ]]
				local t = {}

				for v1, v22 in p3 do
					local t2 = {
						center_offset = Vector3.new(0, 10, 0),
						max_elevation_offset = 8,
						center_target = v2.new(function() --[[ Line: 49 | Upvalues: p1 (copy), v22 (copy) ]]
							if p1.Parent then
								return p1
							end

							return v22
						end),
						radius = RANDOM:NextInteger(6, 12)
					}

					t2.radians_per_second = math.rad((RANDOM:NextInteger(180, 260)))
					table.insert(t, t2)
				end

				return t
			end,
			get_surround_swarm_location = function(p1) --[[ get_surround_swarm_location | Line: 60 | Upvalues: v2 (ref), v1 (ref) ]]
				return {
					center_offset = Vector3.new(0, 4, 0),
					radius = 8,
					max_elevation_offset = 4,
					center_target = v2.new(function() --[[ Line: 62 | Upvalues: p1 (copy) ]]
						return p1
					end),
					radians_per_second = v1.FLY_SPEED / 8
				}
			end
		}
	}
end)