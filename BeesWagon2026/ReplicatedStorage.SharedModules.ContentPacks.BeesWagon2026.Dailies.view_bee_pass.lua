-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DailyEntry = require(ReplicatedStorage.new.modules.Dailies.DailyEntry)
local load = require(game.ReplicatedStorage.Fsys).load

return DailyEntry.new({
	tab_kind = "alerts",
	difficulty = "none",
	name = "Bee Pass",
	kind = script.Name,
	create_display_text = function(p1) --[[ create_display_text | Line: 13 ]]
		return "See the Bee Pass"
	end,
	create_action = function(p1) --[[ create_action | Line: 16 | Upvalues: load (copy) ]]
		return require(game.ReplicatedStorage.new.modules.Ailments.ClientActions.InlineAction).new(function() --[[ Line: 20 | Upvalues: load (ref) ]]
			task.wait()
			load("UIManager").apps.BattlePassApp:view("bees_2026_pass")

			return true
		end)
	end
})