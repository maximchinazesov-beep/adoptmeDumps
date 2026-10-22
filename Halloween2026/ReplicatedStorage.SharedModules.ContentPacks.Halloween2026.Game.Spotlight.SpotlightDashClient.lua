-- https://lua.expert

local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local load = require(ReplicatedStorage.Fsys).load
local ColorThemeDB = load("ColorThemeDB")
local PlatformM = load("PlatformM")
local v1 = load("package:Promise4")
local UIManager = load("UIManager")
local v2 = require("./SpotlightClientState")
local v3 = require("./SpotlightFlashClient")
local v4 = require("./SpotlightMovementClient")
local v5 = require("./SpotlightShared")
local t1 = {}
local v6 = Color3.new(1, 1, 1)

local function set_phase(p1, p2, p3) -- line: 42
    -- upvalues: v4 (copy)
    p1.dash.phase = p2
    p1.dash.ends_at = os.clock() + p3
    v4.apply(p1)
end

local function get_button() -- line: 49
    -- upvalues: UIManager (copy), v5 (copy)
    return UIManager.apps.MinigameHotbarApp:get_button(v5.CONSTANTS.dash_button_name)
end

local function get_inner_color() -- line: 53
    -- upvalues: ColorThemeDB (copy), v5 (copy)
    return ColorThemeDB.themes[v5.CONSTANTS.dash_button_theme].saturated
end

local function get_recharge_duration() -- line: 57
    -- upvalues: v2 (copy), v5 (copy)
    local CONSTANTS = v5.CONSTANTS
    local v7 = (v2.LOCAL_PLAYER:GetAttribute(CONSTANTS.movement_speed_bonus_attribute) or 0) / CONSTANTS.marker_speedup_bonus

    return (math.max(CONSTANTS.dash_recharge_duration - CONSTANTS.dash_recharge_speedup_cut * v7, 0))
end

local function connect_recharge_duration(p4) -- line: 66
    -- upvalues: v2 (copy), v5 (copy)
    local AttributeChangedSignal = v2.LOCAL_PLAYER:GetAttributeChangedSignal(v5.CONSTANTS.movement_speed_bonus_attribute)
    local CONSTANTS = v5.CONSTANTS
    local v9 = (v2.LOCAL_PLAYER:GetAttribute(CONSTANTS.movement_speed_bonus_attribute) or 0) / CONSTANTS.marker_speedup_bonus
    local v11 = math.max(CONSTANTS.dash_recharge_duration - CONSTANTS.dash_recharge_speedup_cut * v9, 0)

    p4.maid:GiveTask(AttributeChangedSignal:Connect(function() -- line: 72
        -- upvalues: v11 (ref), v2 (copy), v5 (copy)
        local CONSTANTS = v5.CONSTANTS
        local v12 = (v2.LOCAL_PLAYER:GetAttribute(CONSTANTS.movement_speed_bonus_attribute) or 0) / CONSTANTS.marker_speedup_bonus

        v11 = math.max(CONSTANTS.dash_recharge_duration - CONSTANTS.dash_recharge_speedup_cut * v12, 0)
    end))

    return function() -- line: 76
        -- upvalues: v11 (ref)
        return v11
    end
end

local function step(p5, p6) -- line: 81
    -- upvalues: v4 (copy)
    local dash = p5.dash

    if dash.phase == "boost" and dash.ends_at <= p6 then
        p5.dash.phase = "ready"
        p5.dash.ends_at = os.clock() + 0
        v4.apply(p5)
    end
end

local function get_spring(p7, p8, p9) -- line: 89
    return math.exp(-p9 * p7) * math.sin(6.283185307179586 * p8 * p7)
end

local function get_drop_scale(p10) -- line: 93
    -- upvalues: v5 (copy)
    local v17 = 1 / v5.CONSTANTS.dash_stamp_scale

    return 1 / (v17 + (1 - v17) * p10 * p10)
end

local function set_faded(p11, p12) -- line: 99
    for v18, v19 in p11.images do
        v18.ImageTransparency = v19 + (1 - v19) * (1 - p12)
    end

    for v20, v21 in p11.texts do
        v20.TextTransparency = v21 + (1 - v21) * (1 - p12)
    end
end

local function place(p13, p14, p15) -- line: 109
    -- upvalues: v5 (copy)
    local screen, home, rest_position = p13.screen, p13.home, p13.rest_position

    if not (screen and home and rest_position) then
        return 1
    end

    local button = p14.button

    if p15 >= 1 then
        button.Parent = home
        button.Position = rest_position
        p13.screen = nil

        return 1
    end

    local instance = p14.instance
    local v22 = instance.AbsolutePosition + instance.AbsoluteSize / 2 - screen.AbsolutePosition
    local dash_stamp_start = v5.CONSTANTS.dash_stamp_start

    button.Position = UDim2.fromScale(dash_stamp_start.X, dash_stamp_start.Y):Lerp(UDim2.fromOffset(v22.X, v22.Y), p15)

    return instance.AbsoluteSize.X / instance.Size.X.Offset
end

local function start_stamp(p16, p17) -- line: 132
    -- upvalues: v5 (copy)
    local CONSTANTS = v5.CONSTANTS

    for _, descendant in p17.instance:GetDescendants() do
        if descendant:IsA("ImageLabel") or descendant:IsA("ImageButton") then
            p16.images[descendant] = descendant.ImageTransparency
        elseif descendant:IsA("TextLabel") then
            p16.texts[descendant] = descendant.TextTransparency
        end
    end

    local UIScale = Instance.new("UIScale")

    UIScale.Name = CONSTANTS.dash_stamp_scale_name
    UIScale.Scale = CONSTANTS.dash_stamp_scale
    UIScale.Parent = p17.button
    p16.scale = UIScale
    p16.rest_position = p17.button.Position
    p16.stamp_pending = true
    p16.landed = false
    p16.dropped = false

    for v23, v24 in p16.images do
        v23.ImageTransparency = v24 + (1 - v24) * 1
    end

    for v25, v26 in p16.texts do
        v25.TextTransparency = v26 + (1 - v26) * 1
    end
end

local function begin_stamp_once_laid_out(p18, p19, p20, p21) -- line: 156
    local instance = p20.instance
    local LayerCollector = instance:FindFirstAncestorWhichIsA("LayerCollector")

    if not (instance.AbsoluteSize.X > 0 and instance.AbsolutePosition ~= Vector2.zero) or not LayerCollector then
        return
    end

    local button = p20.button

    p19.stamp_pending = false
    p19.screen = LayerCollector
    p19.home = button.Parent
    p19.stamp_at = p21
    button.Parent = LayerCollector
    p18.maid:GiveTask(function() -- line: 171
        -- upvalues: p19 (copy), button (copy)
        if p19.screen then
            button:Destroy()
        end
    end)
end

local function animate(p22, p23, p24) -- line: 178
    -- upvalues: SoundService (copy), ColorThemeDB (copy), UIManager (copy), v2 (copy), v5 (copy), v6 (copy), set_faded (copy), place (copy), begin_stamp_once_laid_out (copy)
    local CONSTANTS = v5.CONSTANTS
    local v27 = UIManager.apps.MinigameHotbarApp:get_button(v5.CONSTANTS.dash_button_name)
    local dash = p22.dash

    if not v27 or dash.phase ~= "boost" then
        if v27 and p23.recharging and v27.cooldown_percent == 0 then
            p23.recharging = false
            p23.pulse_at = p24
        end
    else
        v27:set_cooldown_percent(1 - (dash.ends_at - p24) / CONSTANTS.dash_boost_duration)
    end

    if v27 and p23.stamp_pending then
        begin_stamp_once_laid_out(p22, p23, v27, p24)
    end

    if not p23.stamp_pending and not p23.stamp_at and not p23.recharging and p22.dash.phase == "ready" then
        if not p23.breathing_since then
            p23.breathing_since = p24
        end
    else
        p23.breathing_since = nil
    end

    local scale = p23.scale

    if not v27 or not scale or not p23.stamp_at and not p23.punch_at and not p23.pulse_at and not p23.breathing_since then
        return
    end

    local stamp_at = p23.stamp_at
    local v28, v29

    if stamp_at then
        local v30 = p24 - stamp_at
        local v32 = math.max(v30 - CONSTANTS.dash_stamp_hold_duration, 0)
        local dash_stamp_drop_duration = CONSTANTS.dash_stamp_drop_duration

        set_faded(p23, (math.min(v30 / CONSTANTS.dash_stamp_fade_duration, 1)))

        if v32 > 0 and not p23.dropped then
            p23.dropped = true
            v2.play_layered_sound(CONSTANTS.sound_dash_drop, SoundService)
        end

        local v35 = place(p23, v27, if v32 < dash_stamp_drop_duration then (v32 / dash_stamp_drop_duration) ^ 2 else 1)

        if v32 < dash_stamp_drop_duration then
            local v36 = v32 / dash_stamp_drop_duration
            local v37 = 1 / v5.CONSTANTS.dash_stamp_scale

            v28 = 1 / (v37 + (1 - v37) * v36 * v36) * v35
            v29 = CONSTANTS.dash_stamp_tilt * (1 - v36 * v36)
        else
            if not p23.landed then
                p23.landed = true
                v2.play_layered_sound(CONSTANTS.sound_dash_stamp, SoundService)
                v2.shake(p22, {
                    envelope = "decay",
                    amplitude = CONSTANTS.dash_stamp_shake_amplitude,
                    frequency = CONSTANTS.dash_stamp_shake_frequency,
                    time = CONSTANTS.dash_stamp_shake_duration
                })
            end

            local v38 = v32 - dash_stamp_drop_duration

            if v38 < CONSTANTS.dash_stamp_settle_duration then
                local dash_stamp_squash, dash_spring_frequency = CONSTANTS.dash_stamp_squash, CONSTANTS.dash_spring_frequency

                v28 = 1 - dash_stamp_squash * (math.exp(-CONSTANTS.dash_spring_damping * v38) * math.sin(6.283185307179586 * dash_spring_frequency * v38))
            else
                p23.stamp_at = nil
                table.clear(p23.images)
                table.clear(p23.texts)

                local settled_hint = p23.settled_hint

                if settled_hint then
                    p23.settled_hint = nil
                    v2.show_hint(settled_hint, true)
                end

                v28 = 1
            end

            v29 = 0
        end
    else
        v28 = 1
        v29 = 0
    end

    local punch_at = p23.punch_at

    if punch_at then
        local v42 = p24 - punch_at

        if v42 < CONSTANTS.dash_punch_duration then
            local dash_punch_squash, dash_spring_frequency = CONSTANTS.dash_punch_squash, CONSTANTS.dash_spring_frequency

            v28 *= 1 - dash_punch_squash * (math.exp(-CONSTANTS.dash_spring_damping * v42) * math.sin(6.283185307179586 * dash_spring_frequency * v42))
        else
            p23.punch_at = nil
        end
    end

    local pulse_at = p23.pulse_at
    local v46

    if pulse_at then
        local v47 = p24 - pulse_at

        if v47 < CONSTANTS.dash_pulse_duration then
            local dash_pulse_damping, dash_pulse_scale, dash_pulse_frequency = CONSTANTS.dash_pulse_damping, CONSTANTS.dash_pulse_scale, CONSTANTS.dash_pulse_frequency

            v28 *= 1 + dash_pulse_scale * (math.exp(-dash_pulse_damping * v47) * math.sin(6.283185307179586 * dash_pulse_frequency * v47))

            local dash_pulse_tilt, dash_pulse_tilt_frequency = CONSTANTS.dash_pulse_tilt, CONSTANTS.dash_pulse_tilt_frequency

            v29 += dash_pulse_tilt * (math.exp(-dash_pulse_damping * v47) * math.sin(6.283185307179586 * dash_pulse_tilt_frequency * v47))
            v46 = 0 + CONSTANTS.dash_pulse_brighten * math.exp(-dash_pulse_damping * v47)
        else
            v46 = 0
            p23.pulse_at = nil
        end
    else
        v46 = 0
    end

    local breathing_since = p23.breathing_since
    local v55, v56, v57

    if breathing_since then
        local v58 = (p24 - breathing_since) * 2 * 3.141592653589793 / CONSTANTS.dash_breath_period
        local v59 = 0.5 - math.cos(v58) * 0.5
        local v60, v61

        if p23.used then
            v61 = v29
            v60 = v28 * (1 + CONSTANTS.dash_breath_scale * v59)
        else
            v60 = v28 * (1 + CONSTANTS.dash_breath_unused_scale * v59)
            v61 = v29 + CONSTANTS.dash_breath_unused_tilt * math.sin(v58)
        end

        v56 = v60
        v57 = v61
        v55 = v46 + CONSTANTS.dash_breath_brighten * v59
    else
        v55 = v46
        v56 = v28
        v57 = v29
    end

    if v55 > 0 then
        v27:set_inner_color(ColorThemeDB.themes[v5.CONSTANTS.dash_button_theme].saturated:Lerp(v6, (math.min(v55, 1))))
    elseif p23.glowing then
        v27:set_inner_color(nil)
    end

    p23.glowing = v55 > 0
    scale.Scale = v56
    v27.button.Rotation = v57
end

local function start_dash(p25, p26) -- line: 314
    -- upvalues: SoundService (copy), v1 (copy), v2 (copy), v3 (copy), v4 (copy), v5 (copy)
    local CONSTANTS = v5.CONSTANTS
    local dash_boost_duration = CONSTANTS.dash_boost_duration

    p25.dash.phase = "boost"
    p25.dash.ends_at = os.clock() + dash_boost_duration
    v4.apply(p25)

    local Character = v2.LOCAL_PLAYER.Character
    local v62 = Character and Character:FindFirstChildOfClass("Humanoid")

    if v62 and v62.FloorMaterial == Enum.Material.Air then
        v62:ChangeState(Enum.HumanoidStateType.Jumping)
    end

    v2.play_layered_sound(CONSTANTS.sound_dash, SoundService)
    v3.play(p25, CONSTANTS.dash_boost_duration - CONSTANTS.flash_rise_duration)
    p26.used = true
    p26.punch_at = os.clock()
    p26.recharging = true

    return v1.resolve()
end

local function build_button(p27, p28) -- line: 335
    -- upvalues: ContextActionService (copy), UserInputService (copy), ColorThemeDB (copy), PlatformM (copy), UIManager (copy), v2 (copy), v5 (copy), connect_recharge_duration (copy), start_stamp (copy), start_dash (copy)
    local CONSTANTS = v5.CONSTANTS
    local MinigameHotbarApp = UIManager.apps.MinigameHotbarApp

    MinigameHotbarApp:on_minigame_start({
        [CONSTANTS.dash_button_name] = {
            layout_order = 1,
            visible = true,
            world_tap_enabled = false,
            image = CONSTANTS.dash_button_image,
            inner_color = ColorThemeDB.themes[v5.CONSTANTS.dash_button_theme].saturated,
            gamepad_hotkey = CONSTANTS.dash_gamepad_key,
            get_can_use = function() -- get_can_use | line: 347
                -- upvalues: p27 (copy)
                if p27.dash.phase == "ready" then
                    return p27.has_started
                end

                return false
            end,
            get_use_promise = function() -- get_use_promise | line: 350
                -- upvalues: p27 (copy), p28 (copy), start_dash (copy)
                return start_dash(p27, p28)
            end,
            get_cooldown = connect_recharge_duration(p27),
            get_is_cooldown_paused = function() -- get_is_cooldown_paused | line: 354
                -- upvalues: p27 (copy)
                return p27.dash.phase == "boost"
            end
        }
    })

    local v63 = PlatformM.get_platform()

    if v63 == PlatformM.platform.phone or v63 == PlatformM.platform.tablet or v63 == PlatformM.platform.console then
        local v64 = UIManager.apps.MinigameHotbarApp:get_button(v5.CONSTANTS.dash_button_name)

        if v64 then
            v64:set_scale_multiplier(1.2)
        end

        MinigameHotbarApp:place_above_jump_button(UDim2.new(1, -20, 0.825, -20), Vector2.new(1, 1), CONSTANTS.dash_button_name, CONSTANTS.dash_jump_gap)
    end

    local v65 = v63 == PlatformM.platform.desktop and not PlatformM.is_using_gamepad()
    local v66 = UIManager.apps.MinigameHotbarApp:get_button(v5.CONSTANTS.dash_button_name)

    if v66 then
        p28.settled_hint = if v65 then CONSTANTS.hint_sprint_keyboard else nil
        start_stamp(p28, v66)
    elseif v65 then
        v2.show_hint(CONSTANTS.hint_sprint_keyboard, true)
    end

    ContextActionService:BindAction(CONSTANTS.dash_keys_action_name, function(_, p30) -- line: 389
        -- upvalues: UIManager (copy), v5 (copy)
        if p30 == Enum.UserInputState.Begin then
            local v68 = UIManager.apps.MinigameHotbarApp:get_button(v5.CONSTANTS.dash_button_name)

            if v68 then
                v68:use()
            end
        end
    end, false, table.unpack(CONSTANTS.dash_keyboard_keys))
    p27.maid:GiveTask(UserInputService.TouchTap:Connect(function(_, p32) -- line: 398
        -- upvalues: UIManager (copy), v5 (copy)
        local v69 = UIManager.apps.MinigameHotbarApp:get_button(v5.CONSTANTS.dash_button_name)

        if v69 and not p32 then
            v69:use()
        end
    end))
    p27.maid:GiveTask(function() -- line: 405
        -- upvalues: CONSTANTS (copy), MinigameHotbarApp (copy), ContextActionService (copy)
        ContextActionService:UnbindAction(CONSTANTS.dash_keys_action_name)
        MinigameHotbarApp:on_minigame_end()
    end)
end

function t1.connect_dash(p33) -- line: 411
    -- upvalues: RunService (copy), v2 (copy), v4 (copy), animate (copy), build_button (copy)
    local t4 = {
        stamp_at = nil,
        stamp_pending = false,
        settled_hint = nil,
        landed = false,
        dropped = false,
        used = false,
        punch_at = nil,
        pulse_at = nil,
        recharging = false,
        breathing_since = nil,
        glowing = false,
        scale = nil,
        screen = nil,
        home = nil,
        rest_position = nil,
        images = {},
        texts = {}
    }

    v2.when_started(p33, function() -- line: 432
        -- upvalues: p33 (copy), t4 (copy), build_button (copy)
        build_button(p33, t4)
    end)
    p33.maid:GiveTask(RunService.Heartbeat:Connect(function() -- line: 436
        -- upvalues: p33 (copy), t4 (copy), v4 (copy), animate (copy)
        local elapsed = os.clock()
        local dash = p33.dash

        if dash.phase == "boost" and dash.ends_at <= elapsed then
            p33.dash.phase = "ready"
            p33.dash.ends_at = os.clock() + 0
            v4.apply(p33)
        end

        animate(p33, t4, elapsed)
    end))
end

return table.freeze(t1)
