-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local React = require(ReplicatedStorage.SharedPackages.React)
local TweenHelper = require(ReplicatedStorage.SharedModules.TweenHelper)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local v1 = TweenHelper.tween_info({
	time = 0.25,
	easing_style = Enum.EasingStyle.Linear
})

local function ease_pop(p1) --[[ ease_pop | Line: 13 | Upvalues: TweenService (copy) ]]
	return TweenService:GetValue(p1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
end

return function(p1, p2, p3) --[[ use_pop_scale | Line: 17 | Upvalues: React (copy), TweenService (copy), TweenPromise (copy), v1 (copy) ]]
	local v2, v3 = React.useBinding(if p1 then 1 else 0)
	local v4 = React.useRef(nil)
	local v5 = React.useRef(false)
	local v6 = React.useMemo(function() --[[ Line: 22 | Upvalues: v2 (copy), p2 (copy), p3 (copy), TweenService (ref) ]]
		return v2:map(function(p1) --[[ Line: 23 | Upvalues: p2 (ref), p3 (ref), TweenService (ref) ]]
			return p2 + (p3 - p2) * TweenService:GetValue(p1, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
		end)
	end, { p2, p3 })

	React.useLayoutEffect(function() --[[ Line: 28 | Upvalues: v4 (copy), p1 (copy), v5 (copy), v3 (copy), TweenPromise (ref), v2 (copy), v1 (ref) ]]
		if v4.current then
			v4.current:cancel()
		end

		local v12 = if p1 then 1 else 0

		if v5.current then
			v4.current = TweenPromise.callback(v2:getValue(), v12, v1, v3)

			return function() --[[ Line: 42 | Upvalues: v4 (ref) ]]
				if not v4.current then
					return
				end

				v4.current:cancel()
			end
		end

		v5.current = true
		v3(v12)
	end, { p1 })

	return v6
end