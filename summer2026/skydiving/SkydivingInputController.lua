-- ==========================================
-- Скрипт: ReplicatedStorage.SharedModules.ContentPacks.Summer2026.Game.Skydiving.SkydivingInputController
-- ==========================================

-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Maid = require(ReplicatedStorage.SharedModules.Maid)
local High = Enum.ContextActionPriority.High.Value
local t = {
	[Enum.KeyCode.W] = "w",
	[Enum.KeyCode.Up] = "w",
	[Enum.KeyCode.S] = "s",
	[Enum.KeyCode.Down] = "s",
	[Enum.KeyCode.A] = "a",
	[Enum.KeyCode.Left] = "a",
	[Enum.KeyCode.D] = "d",
	[Enum.KeyCode.Right] = "d"
}
local t2 = {}

t2.__index = t2
function t2.new() --[[ new | Line: 26 | Upvalues: Maid (copy), t2 (copy) ]]
	local v3 = setmetatable({
		is_pencil_diving = false,
		_touch_input = nil,
		_touch_origin = nil,
		move_vector = Vector2.zero,
		maid = Maid.new(),
		_key_state = {
			w = false,
			a = false,
			s = false,
			d = false
		}
	}, t2)

	v3:_bind_actions()

	return v3
end
function t2._bind_actions(p1) --[[ _bind_actions | Line: 43 | Upvalues: ContextActionService (copy), High (copy), UserInputService (copy) ]]
	ContextActionService:BindActionAtPriority("SkydivingMove", function(p12, p2, p3) --[[ Line: 44 | Upvalues: p1 (copy) ]]
		return p1:_handle_move(p2, p3)
	end, false, High, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right, Enum.KeyCode.Thumbstick1)
	ContextActionService:BindActionAtPriority("SkydivingPencilDive", function(p12, p2, p3) --[[ Line: 48 | Upvalues: p1 (copy) ]]
		return p1:_handle_pencil_dive(p2)
	end, false, High, Enum.KeyCode.Space, Enum.KeyCode.ButtonA, Enum.PlayerActions.CharacterJump)
	p1.maid:GiveTask(function() --[[ Line: 52 | Upvalues: ContextActionService (ref) ]]
		ContextActionService:UnbindAction("SkydivingMove")
		ContextActionService:UnbindAction("SkydivingPencilDive")
	end)
	p1.maid:GiveTask(UserInputService.TouchStarted:Connect(function(p12, p2) --[[ Line: 57 | Upvalues: p1 (copy) ]]
		if not (p2 or p1._touch_input) then
			p1._touch_input = p12
			p1._touch_origin = p12.Position
		end
	end))
	p1.maid:GiveTask(UserInputService.TouchMoved:Connect(function(p12) --[[ Line: 65 | Upvalues: p1 (copy) ]]
		if p12 ~= p1._touch_input then
			return
		end

		local v1 = Vector2.new(p12.Position.X - p1._touch_origin.X, -(p12.Position.Y - p1._touch_origin.Y))
		local Magnitude = v1.Magnitude

		if Magnitude > 0.01 then
			p1.move_vector = v1.Unit * math.clamp(Magnitude / 50, 0, 1)
		else
			p1.move_vector = Vector2.zero
		end
	end))
	p1.maid:GiveTask(UserInputService.TouchEnded:Connect(function(p12) --[[ Line: 78 | Upvalues: p1 (copy) ]]
		if p12 == p1._touch_input then
			p1._touch_input = nil
			p1._touch_origin = nil
			p1.move_vector = Vector2.zero
		end
	end))
end
function t2._handle_move(p1, p2, p3) --[[ _handle_move | Line: 88 | Upvalues: t (copy) ]]
	if p3.KeyCode == Enum.KeyCode.Thumbstick1 then
		p1.move_vector = Vector2.new(p3.Position.X, p3.Position.Y)

		return Enum.ContextActionResult.Sink
	end

	local isBegin = p2 == Enum.UserInputState.Begin
	local v1 = t[p3.KeyCode]

	if not v1 then
		return Enum.ContextActionResult.Sink
	end

	p1._key_state[v1] = isBegin
	p1:_update_move_from_keys()

	return Enum.ContextActionResult.Sink
end
function t2._update_move_from_keys(p1) --[[ _update_move_from_keys | Line: 104 ]]
	local count = 0
	local count2 = 0

	if p1._key_state.w then
		count2 = count2 + 1
	end

	if p1._key_state.s then
		count2 = count2 - 1
	end

	if p1._key_state.d then
		count = count + 1
	end

	if p1._key_state.a then
		count = count - 1
	end

	local v1 = Vector2.new(count, count2)

	p1.move_vector = if v1.Magnitude > 0 then v1.Unit else Vector2.zero
end
function t2._handle_pencil_dive(p1, p2) --[[ _handle_pencil_dive | Line: 116 ]]
	p1.is_pencil_diving = if p2 == Enum.UserInputState.Begin then true else false

	return Enum.ContextActionResult.Sink
end
function t2.set_pencil_diving(p1, p2) --[[ set_pencil_diving | Line: 121 ]]
	p1.is_pencil_diving = p2
end
function t2.get_move_vector(p1) --[[ get_move_vector | Line: 125 ]]
	return p1.move_vector
end
function t2.get_is_pencil_diving(p1) --[[ get_is_pencil_diving | Line: 129 ]]
	return p1.is_pencil_diving
end
function t2.destroy(p1) --[[ destroy | Line: 133 ]]
	p1.maid:DoCleaning()
end

return t2

