-- https://lua.expert/
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local GameplayFX = require(ReplicatedStorage.SharedModules.GameplayFX)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local t = {
	1,
	1.05,
	1.1,
	1.15,
	1.2,
	1.25,
	1.3,
	1.35
}
local t2 = {}

t2.__index = t2

local t3 = {}

local function fly_model(p1, p2, p3, p4) --[[ fly_model | Line: 26 | Upvalues: Promise (copy), GameplayFX (copy), SoundPlayer (copy), t (copy), TweenService (copy) ]]
	return Promise.new(function(p1, p2, p3) --[[ Line: 27 | Upvalues: GameplayFX (ref), p2 (copy), SoundPlayer (ref), p1 (copy), t (ref), TweenService (ref), p3 (copy), p4 (copy) ]]
		GameplayFX.emit_poof(p2.Position)

		local t2 = {}

		t2.playback_speed = t[tonumber(p1.Name)] or 1
		SoundPlayer.FX:play("SnowmanThrow", p1.PrimaryPart, t2)

		local v32 = tick()

		while not p3() do
			local v52 = math.min((tick() - v32) / 0.6, 1)
			local v7 = p2.Position:Lerp(p3.Position, (TweenService:GetValue(v52, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)))
			local v8 = Vector3.new(0, (-(v52 * 1.7 - 1) ^ 2 + 1) * 8, 0)
			local v9 = CFrame.Angles(6.283185307179586 * v52, 5.340707511102648 * v52, 7.225663103256523 * v52)

			p1:PivotTo(CFrame.new(v7 + v8) * v9 * p3.Rotation)

			if v52 >= 1 then
				break
			end

			task.wait()
		end

		if not p3() then
			GameplayFX.emit_poof(p3.Position)

			if p4 and p1.Name == "8" then
				SoundPlayer.FX:play("SnowmanComplete", p1.PrimaryPart)
			else
				local t3 = {}

				t3.playback_speed = t[tonumber(p1.Name)] or 1
				SoundPlayer.FX:play("SnowmanBuild", p1.PrimaryPart, t3)
			end
		end

		p1:PivotTo(p3)
		p1()
	end)
end

local function set_model_transparency(p1, p2) --[[ set_model_transparency | Line: 65 ]]
	for v1, v2 in p1:GetDescendants() do
		if v2:IsA("BasePart") then
			v2.Transparency = p2
		end
	end
end

local function revert_all_parts(p1) --[[ revert_all_parts | Line: 73 | Upvalues: Promise (copy), set_model_transparency (copy), fly_model (copy) ]]
	local count = 0
	local t = {}

	for i = 8, 1, -1 do
		local v1 = p1.parts[i]

		if v1.fly_promise then
			v1.fly_promise:cancel()
			v1.fly_promise = nil
		end

		if v1.built and (v1.disassembled_model and (v1.assembled_model and v1.original_cframe)) then
			v1.fly_promise = Promise.delay(count * 0.15):andThen(function() --[[ Line: 89 | Upvalues: set_model_transparency (ref), v1 (copy), fly_model (ref) ]]
				set_model_transparency(v1.assembled_model, 1)
				set_model_transparency(v1.disassembled_model, 0)

				return fly_model(v1.disassembled_model, v1.assembled_model:GetPivot(), v1.original_cframe, false)
			end)
			table.insert(t, v1.fly_promise)
			count = count + 1
		else
			if v1.disassembled_model and v1.original_cframe then
				v1.disassembled_model:PivotTo(v1.original_cframe)
				set_model_transparency(v1.disassembled_model, 0)
			end

			if v1.assembled_model then
				set_model_transparency(v1.assembled_model, 1)
			end
		end

		v1.built = false
		v1.reserved_by = nil
	end

	if #t > 0 then
		Promise.all(t):finally(function() --[[ Line: 112 | Upvalues: p1 (copy) ]]
			p1.locked = false
		end)
	else
		p1.locked = false
	end
end

function t2.register(p1) --[[ register | Line: 120 | Upvalues: t3 (copy) ]]
	local Snowman = p1:FindFirstChild("Snowman")

	if not Snowman then
		return
	end

	local Assembled = Snowman:FindFirstChild("Assembled")
	local Disassembled = Snowman:FindFirstChild("Disassembled")

	if not (Assembled and Disassembled) then
		return
	end

	local t = {}

	for i = 1, 8 do
		local v1 = tostring(i)
		local v2 = Disassembled:FindFirstChild(v1)
		local t2 = {
			reserved_by = nil,
			built = false,
			assembled_model = Assembled:FindFirstChild(v1),
			disassembled_model = v2
		}

		t2.original_cframe = if v2 then v2:GetPivot() else v2
		t[i] = t2
	end

	t3[p1] = {
		locked = false,
		revert_promise = nil,
		parts = t
	}

	return t3[p1]
end
function t2.unregister(p1) --[[ unregister | Line: 150 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]

	if v1 and v1.revert_promise then
		v1.revert_promise:cancel()
	end

	t3[p1] = nil
end
function t2.get_state(p1) --[[ get_state | Line: 158 | Upvalues: t3 (copy) ]]
	return t3[p1]
end
function t2.is_locked(p1) --[[ is_locked | Line: 162 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]

	if v1 then
		return v1.locked
	end

	return false
end
function t2.request_next_slot(p1, p2) --[[ request_next_slot | Line: 168 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]

	if not v1 or v1.locked then
		return nil, nil, 0
	end

	local count = 0

	for v2, v3 in v1.parts do
		if v3.reserved_by and v3.reserved_by ~= p2 then
			count = count + 1
		end
	end

	for v4, v5 in v1.parts do
		if not (v5.reserved_by or v5.built) then
			v5.reserved_by = p2

			return v4, v5, count
		end
	end

	return nil, nil, 0
end
function t2.release_slots(p1, p2) --[[ release_slots | Line: 189 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]

	if not v1 then
		return
	end

	for v2, v3 in v1.parts do
		if v3.reserved_by == p2 then
			v3.reserved_by = nil
		end
	end
end
function t2.play_dig_sfx_on_model(p1) --[[ play_dig_sfx_on_model | Line: 200 | Upvalues: SoundPlayer (copy) ]]
	if p1.PrimaryPart then
		SoundPlayer.FX:play("SnowmanDig", p1.PrimaryPart)
	end
end
function t2.stop_dig_sfx_on_model(p1) --[[ stop_dig_sfx_on_model | Line: 206 ]]
	if not p1.PrimaryPart then
		return
	end

	local SnowmanDig = p1.PrimaryPart:FindFirstChild("SnowmanDig")

	if not (SnowmanDig and SnowmanDig:IsA("Sound")) then
		return
	end

	SnowmanDig:Stop()
end
function t2.start_fly_animation(p1, p2) --[[ start_fly_animation | Line: 215 | Upvalues: t3 (copy), Promise (copy), GameplayFX (copy), SoundPlayer (copy), t (copy), TweenService (copy), set_model_transparency (copy) ]]
	local v1 = t3[p1]

	if not v1 then
		return
	end

	local v2 = v1.parts[p2]

	if not v2 then
		return
	end

	local disassembled_model = v2.disassembled_model
	local assembled_model = v2.assembled_model

	if disassembled_model and assembled_model then
		local v3 = disassembled_model:GetPivot()
		local v4 = assembled_model:GetPivot()
		local v5 = true

		v2.fly_promise = Promise.new(function(p1, p2, p3) --[[ Line: 27 | Upvalues: GameplayFX (ref), v3 (copy), SoundPlayer (ref), disassembled_model (copy), t (ref), TweenService (ref), v4 (copy), v5 (copy) ]]
			GameplayFX.emit_poof(v3.Position)

			local t2 = {}

			t2.playback_speed = t[tonumber(disassembled_model.Name)] or 1
			SoundPlayer.FX:play("SnowmanThrow", disassembled_model.PrimaryPart, t2)

			local v32 = tick()

			while not p3() do
				local v52 = math.min((tick() - v32) / 0.6, 1)
				local v7 = v3.Position:Lerp(v4.Position, (TweenService:GetValue(v52, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)))
				local v8 = Vector3.new(0, (-(v52 * 1.7 - 1) ^ 2 + 1) * 8, 0)
				local v9 = CFrame.Angles(6.283185307179586 * v52, 5.340707511102648 * v52, 7.225663103256523 * v52)

				disassembled_model:PivotTo(CFrame.new(v7 + v8) * v9 * v4.Rotation)

				if v52 >= 1 then
					break
				end

				task.wait()
			end

			if not p3() then
				GameplayFX.emit_poof(v4.Position)

				if v5 and disassembled_model.Name == "8" then
					SoundPlayer.FX:play("SnowmanComplete", disassembled_model.PrimaryPart)
				else
					local t3 = {}

					t3.playback_speed = t[tonumber(disassembled_model.Name)] or 1
					SoundPlayer.FX:play("SnowmanBuild", disassembled_model.PrimaryPart, t3)
				end
			end

			disassembled_model:PivotTo(v4)
			p1()
		end):andThen(function() --[[ Line: 229 | Upvalues: set_model_transparency (ref), disassembled_model (copy), assembled_model (copy), v2 (copy) ]]
			set_model_transparency(disassembled_model, 1)
			set_model_transparency(assembled_model, 0)
			v2.built = true
			v2.reserved_by = nil
			v2.fly_promise = nil
		end, function() --[[ Line: 236 | Upvalues: disassembled_model (copy), v2 (copy) ]]
			disassembled_model:PivotTo(v2.original_cframe)
		end)
	end
end
function t2.lock(p1) --[[ lock | Line: 241 | Upvalues: t3 (copy) ]]
	local v1 = t3[p1]

	if v1 then
		v1.locked = true
	end
end
function t2.begin_revert(p1) --[[ begin_revert | Line: 248 | Upvalues: t3 (copy), Promise (copy), revert_all_parts (copy) ]]
	local v1 = t3[p1]

	if v1 and not v1.revert_promise then
		v1.revert_promise = Promise.delay(5):andThen(function() --[[ Line: 252 | Upvalues: revert_all_parts (ref), v1 (copy) ]]
			revert_all_parts(v1)
			v1.revert_promise = nil
		end)
	end
end
function t2.reset(p1) --[[ reset | Line: 258 | Upvalues: t3 (copy), revert_all_parts (copy) ]]
	local v1 = t3[p1]

	if not v1 or v1.locked then
		return
	end

	if v1.revert_promise then
		v1.revert_promise:cancel()
		v1.revert_promise = nil
	end

	v1.locked = true
	revert_all_parts(v1)
end

return t2