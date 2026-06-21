-- https://lua.expert/
local AnimationManager = require(game.ReplicatedStorage.ClientDB.AnimationManager)
local Promise = require(game.ReplicatedStorage.SharedPackages.Promise)
local t = {}
local t2 = {
	"FishingAvatarCastBackswing",
	"FishingAvatarCastHold",
	"FishingAvatarCastFollowThrough",
	"FishingAvatarCastIdle",
	"FishingAvatarCatch",
	"FishingAvatarReelingControlled",
	"FishingAvatarReelingStruggle",
	"FishingRodCastBackswing",
	"FishingRodCastHold",
	"FishingRodCastFollowThrough",
	"FishingRodCastIdle",
	"FishingRodCatch",
	"FishingRodReelingControlled",
	"FishingRodReelingStruggle",
	"FishDefaultIdle",
	"FishDefaultSwim",
	"FishDefaultCatch",
	"FishDefaultYank",
	"FishRainbowTroutIdle",
	"FishRainbowTroutSwim",
	"FishRainbowTroutCatch",
	"FishLakeMonsterIdle",
	"FishLakeMonsterSwim",
	"FishLakeMonsterCatch"
}
local t3 = {
	idle = "FishDefaultIdle",
	swim = "FishDefaultSwim",
	catch = "FishDefaultCatch",
	yank = "FishDefaultYank"
}
local t4 = {
	summer_2026_bronze_fish = t3,
	summer_2026_silver_fish = t3,
	summer_2026_gold_fish = t3,
	summer_2026_rainbow_fish = t3,
	summer_2026_rainbow_trout = {
		idle = "FishRainbowTroutIdle",
		swim = "FishRainbowTroutSwim",
		catch = "FishRainbowTroutCatch",
		yank = "FishDefaultYank"
	},
	summer_2026_lake_monster = {
		idle = "FishLakeMonsterIdle",
		swim = "FishLakeMonsterSwim",
		catch = "FishLakeMonsterCatch",
		yank = "FishDefaultYank"
	}
}
local v1 = nil
local v2 = nil
local v3 = nil
local v4 = nil

return {
	start = function() --[[ start | Line: 65 | Upvalues: t2 (copy), AnimationManager (copy), t (copy) ]]
		local t3 = {}

		for v1, v2 in t2 do
			local v3 = AnimationManager.get_track(v2)

			t[v2] = v3
			table.insert(t3, v3)
		end

		game:GetService("ContentProvider"):PreloadAsync(t3)
	end,
	set_animators = function(p1, p2) --[[ set_animators | Line: 75 | Upvalues: v1 (ref), v2 (ref) ]]
		v1 = p1
		v2 = p2
	end,
	play_avatar_anim = function(p1, p2) --[[ play_avatar_anim | Line: 80 | Upvalues: v3 (ref), t (copy), v1 (ref) ]]
		if not v3 then
			v3 = v1:LoadAnimation(t[p1])
			v3.Looped = p2
			v3:Play(0.3)

			return v3
		end

		v3:Stop()
		v3 = v1:LoadAnimation(t[p1])
		v3.Looped = p2
		v3:Play(0.3)

		return v3
	end,
	play_rod_anim = function(p1, p2) --[[ play_rod_anim | Line: 91 | Upvalues: v4 (ref), t (copy), v2 (ref) ]]
		if not v4 then
			v4 = v2:LoadAnimation(t[p1])
			v4.Looped = p2
			v4:Play(0.3)

			return v4
		end

		v4:Stop()
		v4 = v2:LoadAnimation(t[p1])
		v4.Looped = p2
		v4:Play(0.3)

		return v4
	end,
	play_fish_anim = function(p1, p2, p3, p4) --[[ play_fish_anim | Line: 102 | Upvalues: t4 (copy), t (copy) ]]
		local v1 = p1:LoadAnimation(t[t4[p2][p3]])

		v1.Looped = p4
		v1:Play(0.3)

		return v1
	end,
	await_anim = function(p1) --[[ await_anim | Line: 111 | Upvalues: Promise (copy) ]]
		return Promise.fromEvent(p1.Stopped):finally(function() --[[ Line: 112 | Upvalues: p1 (copy) ]]
			p1:Stop()
		end)
	end,
	loop_anim_until = function(p1, p2) --[[ loop_anim_until | Line: 117 | Upvalues: Promise (copy) ]]
		return Promise.fromEvent(p1.DidLoop, p2):finally(function() --[[ Line: 118 | Upvalues: p1 (copy) ]]
			p1:Stop()
		end)
	end,
	cleanup = function() --[[ cleanup | Line: 123 | Upvalues: v4 (ref), v3 (ref) ]]
		if v4 then
			v4:Stop()
			v4 = nil
		end

		if not v3 then
			return
		end

		v3:Stop()
		v3 = nil
	end
}