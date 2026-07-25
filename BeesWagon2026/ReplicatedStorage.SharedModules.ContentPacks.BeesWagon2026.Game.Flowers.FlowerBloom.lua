-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Maid = require(ReplicatedStorage.SharedModules.Maid)

require(ReplicatedStorage.SharedPackages.Promise)

local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local v1 = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
local t = {}

t.__index = t

local t2 = {}

local function get_numbered_child_models(p1) --[[ get_numbered_child_models | Line: 46 ]]
	local t = {}

	for v1, v2 in p1:GetChildren() do
		if v2:IsA("Model") then
			local v4 = tonumber(v2.Name)

			if v4 then
				table.insert(t, {
					index = v4,
					model = v2
				})
			end
		end
	end

	table.sort(t, function(p1, p2) --[[ Line: 61 ]]
		return p1.index < p2.index
	end)

	local t2 = {}

	for v5, v6 in t do
		table.insert(t2, v6.model)
	end

	return t2
end

local function get_pop_targets(p1) --[[ get_pop_targets | Line: 73 | Upvalues: get_numbered_child_models (copy) ]]
	local v1 = get_numbered_child_models(p1)

	if #v1 > 0 then
		return v1
	end

	return { p1 }
end

local function set_pivot_preserving_geometry(p1, p2) --[[ set_pivot_preserving_geometry | Line: 82 ]]
	local v1 = p1:GetPivot()

	p1:PivotTo(p2)

	local v2 = v1 * p2:Inverse()

	for v3, v4 in p1:GetDescendants() do
		if v4:IsA("BasePart") then
			v4.CFrame = v2 * v4.CFrame
		end
	end
end

local function stem_scale_for_t(p1) --[[ stem_scale_for_t | Line: 94 ]]
	return math.clamp(p1 / 0.8, 0, 1) * 0.99 + 0.01
end

local function make_leaves_threshold(p1, p2) --[[ make_leaves_threshold | Line: 99 ]]
	if p2 then
		return 0.8 + p1:NextNumber() * 0.05
	end

	return nil
end

local function make_petal_window_start(p1) --[[ make_petal_window_start | Line: 107 ]]
	return p1 or 0.8
end

local function make_single_petal_threshold(p1, p2) --[[ make_single_petal_threshold | Line: 111 ]]
	local v1 = p2 or 0.8

	return v1 + p1:NextNumber() * (1 - v1)
end

local function get_active_petal_count(p1, p2, p3) --[[ get_active_petal_count | Line: 116 ]]
	if p2 == 0 or p1 <= p3 then
		return 0
	end

	return math.clamp(math.ceil((p1 - p3) / (1 - p3) * p2), 0, p2)
end

local function new_pop_part(p1) --[[ new_pop_part | Line: 125 ]]
	return {
		popped = false,
		tween_promise = nil,
		model = p1
	}
end

function t._apply_stem_scale(p1, p2) --[[ _apply_stem_scale | Line: 133 ]]
	p1._stem:ScaleTo(p2)
end
function t._cancel_pop(p1, p2) --[[ _cancel_pop | Line: 137 ]]
	if p2.tween_promise then
		p2.tween_promise:cancel()
		p2.tween_promise = nil
	end

	p2.popped = false
	p2.model:ScaleTo(0.01)
end
function t._start_pop(p1, p2) --[[ _start_pop | Line: 147 | Upvalues: TweenPromise (copy), v1 (copy) ]]
	if not p2.tween_promise then
		p2.popped = true
		p2.model:ScaleTo(0.01)

		local v12 = TweenPromise.callback(0.01, 1, v1, function(p1) --[[ Line: 155 | Upvalues: p2 (copy) ]]
			p2.model:ScaleTo(p1)
		end):finally(function() --[[ Line: 157 | Upvalues: p2 (copy) ]]
			p2.tween_promise = nil
		end)

		p2.tween_promise = v12
		p1._maid:GiveTask(v12)
	end
end
function t._apply_threshold_pop_parts(p1, p2) --[[ _apply_threshold_pop_parts | Line: 165 ]]
	for v1, v2 in p1._threshold_pop_parts do
		if v2.threshold <= p2 then
			if not (v2.popped or v2.tween_promise) then
				p1:_start_pop(v2)
			end

			continue
		end

		if v2.popped or v2.tween_promise then
			p1:_cancel_pop(v2)
		end
	end
end
function t._apply_petal_sequence(p1, p2) --[[ _apply_petal_sequence | Line: 177 ]]
	local _petal_sequence = p1._petal_sequence

	if not _petal_sequence then
		return
	end

	local v1 = #_petal_sequence.parts
	local window_start = _petal_sequence.window_start
	local v2 = if v1 == 0 or p2 <= window_start then 0 else math.clamp(math.ceil((p2 - window_start) / (1 - window_start) * v1), 0, v1)

	for v5, v6 in _petal_sequence.parts do
		if v5 <= v2 then
			if not (v6.popped or v6.tween_promise) then
				p1:_start_pop(v6)
			end

			continue
		end

		if v6.popped or v6.tween_promise then
			p1:_cancel_pop(v6)
		end
	end
end
function t.bloom(p1, p2) --[[ bloom | Line: 196 ]]
	local v1 = math.clamp(p2, 0, 1)

	p1:_apply_stem_scale(math.clamp(v1 / 0.8, 0, 1) * 0.99 + 0.01)
	p1:_apply_threshold_pop_parts(v1)
	p1:_apply_petal_sequence(v1)
end
function t.destroy(p1) --[[ destroy | Line: 203 ]]
	p1._maid:DoCleaning()
end
function t.new(p1) --[[ new | Line: 207 | Upvalues: set_pivot_preserving_geometry (copy), get_numbered_child_models (copy), Maid (copy), t (copy) ]]
	local Visual = p1.Visual
	local Stem = Visual.Stem
	local Leaves = Visual:FindFirstChild("Leaves")
	local Petals = Visual:FindFirstChild("Petals")

	Stem:ScaleTo(1)
	set_pivot_preserving_geometry(Stem, p1.Root.CFrame)

	local v1

	if Petals then
		local v2 = get_numbered_child_models(Petals)

		v1 = if #v2 > 0 then v2 else { Petals }
	else
		v1 = {}
	end

	local v3 = if Petals == nil then false elseif #v1 > 1 then true else false
	local t2 = {}
	local v4 = nil

	if Leaves then
		Leaves:ScaleTo(0.01)
	end

	if Petals and v3 then
		Petals:ScaleTo(1)

		for v5, v6 in v1 do
			v6:ScaleTo(0.01)
		end
	elseif Petals then
		Petals:ScaleTo(0.01)
	end

	local v7 = Random.new()
	local v9 = if if Leaves == nil then false else true then 0.8 + v7:NextNumber() * 0.05 else nil
	local v10 = v9 or 0.8

	if Leaves and v9 then
		table.insert(t2, {
			popped = false,
			tween_promise = nil,
			model = Leaves,
			threshold = v9
		})
	end

	if Petals and v3 then
		local t3 = {}

		for v11, v12 in v1 do
			table.insert(t3, {
				popped = false,
				tween_promise = nil,
				model = v12
			})
		end

		v4 = {
			parts = t3,
			window_start = v10
		}
	elseif Petals then
		local t3 = {
			popped = false,
			tween_promise = nil,
			model = Petals
		}
		local v13 = v9 or 0.8

		t3.threshold = v13 + v7:NextNumber() * (1 - v13)
		table.insert(t2, t3)
	end

	local v15 = setmetatable({
		_maid = Maid.new(),
		_stem = Stem,
		_threshold_pop_parts = t2,
		_petal_sequence = v4
	}, t)

	v15:_apply_stem_scale(0.01)
	v15:bloom(0)

	return v15
end
function t2.mount(p1) --[[ mount | Line: 287 | Upvalues: t (copy) ]]
	return t.new(p1)
end

return t2