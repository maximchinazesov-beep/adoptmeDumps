-- https://lua.expert/
local v1 = require(game.ReplicatedStorage.Fsys).load("package:t")

return {
	flower_weights = {
		replicated = true,
		type = v1.map(v1.string, v1.number),
		safeDefault = {
			rose = 1,
			iris = 1,
			daisy = 1,
			poppy = 1,
			bluebell = 1,
			fern = 1
		}
	},
	growth_durations = {
		replicated = true,
		type = v1.map(v1.string, v1.number),
		safeDefault = {
			rose = 900,
			iris = 780,
			daisy = 540,
			poppy = 420,
			bluebell = 660,
			fern = 300
		}
	}
}