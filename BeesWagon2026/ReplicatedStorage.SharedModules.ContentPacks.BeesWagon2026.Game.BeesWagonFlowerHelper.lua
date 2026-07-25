-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TimeZoneHelper = require(ReplicatedStorage.SharedModules.TimeZoneHelper)
local Sift = require(ReplicatedStorage.SharedPackages.Sift)
local Signal = require(ReplicatedStorage.SharedModules.Signal)
local Fsys = require(ReplicatedStorage.Fsys)
local v1 = Fsys.load("new:WeightedRandom")
local v2 = Fsys.load("CloudValues")
local t = {
	TAKEDOWN_TIMESTAMP = TimeZoneHelper.from_region_datetime("PT", 2026, 8, 7, 8).UnixTimestamp,
	REPLICATION_KEY = "bees_wagon_2026_manager",
	SEED_TOOL_EQUIPPED_ATTRIBUTE = "BeesWagon2026SeedToolEquipped"
}
local t2 = { "rose", "iris", "daisy", "poppy", "bluebell", "fern" }

t.FLOWER_KINDS = Sift.Set.fromArray(t2)
t.FLOWER_NAMES_BY_KIND = {
	rose = "Rose",
	iris = "Iris",
	daisy = "Daisy",
	poppy = "Poppy",
	bluebell = "Bluebell",
	fern = "Fern"
}
t.FLOWER_ICONS = {
	rose = "rbxassetid://73531519655114",
	iris = "rbxassetid://108089489651284",
	daisy = "rbxassetid://138234439059276",
	poppy = "rbxassetid://111575210981607",
	bluebell = "rbxassetid://126906619344800",
	fern = "rbxassetid://105232035421343"
}
t.SEED_ICONS = {
	rose = "rbxassetid://108392356554903",
	iris = "rbxassetid://76146762572642",
	daisy = "rbxassetid://74173437553750",
	poppy = "rbxassetid://113880947415805",
	bluebell = "rbxassetid://124095467613846",
	fern = "rbxassetid://81631616472883"
}
t.SEED_ITEM_KINDS_MAP = Sift.Dictionary.map(t.FLOWER_KINDS, function(p1, p2) --[[ Line: 45 ]]
	return p2, ("bees_wagon_2026_%*_seeds"):format(p2)
end)
t.FLOWER_ITEM_KINDS_MAP = Sift.Dictionary.map(t.FLOWER_KINDS, function(p1, p2) --[[ Line: 49 ]]
	return p2, ("bees_wagon_2026_%*_flower"):format(p2)
end)

local v3 = Sift.Dictionary.map(t.FLOWER_ITEM_KINDS_MAP, function(p1, p2) --[[ Line: 53 ]]
	return p1, p2
end)

t.BOUQUET_COUNT = 6
t.PLANTING_SPOT_COUNT = 12
t.FLOWERS_PER_BOUQUET = 6
t.BATTLE_PASS_KIND = "bees_2026_pass"
t.BOUQUET_XP_REWARD = 50
t.ALL_BOUQUETS_COMPLETED_XP_REWARD = 300
t.BOUQUET_POOF_HIDDEN_SECONDS = 2
t.BOUQUET_POOF_OUT_SEQUENCE = {
	{ "6", "3" },
	{ "5", "2" },
	{ "4", "1" }
}
t.BOUQUET_POOF_SEQUENCE_STEP_SECONDS = 0.4
t.QUEEN_BEE_THANKS_TIMEOUT_SECONDS = 15
t.queen_bee_thanks_signal = Signal.new()
function t.get_growth_duration(p1) --[[ get_growth_duration | Line: 78 | Upvalues: v2 (copy) ]]
	return v2:getValue("bees_wagon_2026", "growth_durations")[p1]
end
function t.is_flower_ready(p1, p2) --[[ is_flower_ready | Line: 82 | Upvalues: t (copy) ]]
	return if p1.watered_at == nil then false else p2 - p1.watered_at >= t.get_growth_duration(p1.flower_kind)
end
function t.get_flower_item_kind(p1) --[[ get_flower_item_kind | Line: 87 ]]
	return ("bees_wagon_2026_%*_flower"):format(p1)
end
function t.get_seed_item_kind(p1) --[[ get_seed_item_kind | Line: 91 ]]
	return ("bees_wagon_2026_%*_seeds"):format(p1)
end
function t.count_owned_flowers(p1) --[[ count_owned_flowers | Line: 95 | Upvalues: v3 (copy) ]]
	local t = {}

	for v1, v2 in p1 do
		local v32 = v3[v2.kind]

		if v32 then
			t[v32] = (t[v32] or 0) + 1
		end
	end

	return t
end
function t.compute_remaining_requirements(p1, p2) --[[ compute_remaining_requirements | Line: 106 ]]
	local t = {}

	for v1, v2 in p1 do
		t[v2] = (t[v2] or 0) + 1
	end

	for v3, v4 in p2 do
		local v5 = t[v4]

		if v5 and v5 > 0 then
			t[v4] = v5 - 1
		end
	end

	for v6, v7 in t do
		if v7 <= 0 then
			t[v6] = nil
		end
	end

	return t
end
function t.are_all_bouquets_complete(p1) --[[ are_all_bouquets_complete | Line: 128 | Upvalues: t (copy) ]]
	for i = 1, t.BOUQUET_COUNT do
		local v1 = p1[tostring(i)]

		if not v1 or #v1 < t.FLOWERS_PER_BOUQUET then
			return false
		end
	end

	return true
end
function t.get_bouquet_requirements(p1, p2) --[[ get_bouquet_requirements | Line: 140 | Upvalues: v2 (copy), t2 (copy), v1 (copy), t (copy) ]]
	local v12 = v2:getValue("bees_wagon_2026", "flower_weights") or {}
	local t3 = {}

	for v22, v3 in t2 do
		t3[v3] = v12[v3] or 1
	end

	return v1.get_values(t3, t.FLOWERS_PER_BOUQUET, p2 + tonumber(p1))
end
function t.generate_random_bouquet(p1) --[[ generate_random_bouquet | Line: 149 | Upvalues: t2 (copy), t (copy) ]]
	local v1 = Random.new(p1)
	local v2 = table.clone(t2)

	v1:Shuffle(v2)

	local t3 = {}

	for i = 1, t.FLOWERS_PER_BOUQUET do
		table.insert(t3, v2[v1:NextInteger(1, #v2)])
	end

	return t3
end

return t