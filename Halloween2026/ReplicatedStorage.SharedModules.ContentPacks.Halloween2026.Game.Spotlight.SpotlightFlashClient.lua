-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}
local t2 = {
    {
        name = "Left",
        rotation = 0,
        vertical = true,
        anchor = Vector2.new(0, 0)
    },
    {
        name = "Top",
        rotation = 90,
        vertical = false,
        anchor = Vector2.new(0, 0)
    },
    {
        name = "Right",
        rotation = 180,
        vertical = true,
        anchor = Vector2.new(1, 0)
    },
    {
        name = "Bottom",
        rotation = 270,
        vertical = false,
        anchor = Vector2.new(0, 1)
    }
}
local v3 = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 0),
    NumberSequenceKeypoint.new(0.5, 0.72),
    NumberSequenceKeypoint.new(1, 1)
})

local function build_vignette(p1) -- line: 21
    -- upvalues: v1 (copy), v2 (copy), t2 (copy), v3 (copy)
    local CONSTANTS = v2.CONSTANTS
    local ScreenGui = Instance.new("ScreenGui")

    ScreenGui.Name = "SpotlightFlash"
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = CONSTANTS.flash_display_order
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local t3 = {}

    for _, v4 in t2 do
        local Frame = Instance.new("Frame")

        Frame.Name = v4.name
        Frame.BackgroundColor3 = CONSTANTS.flash_color
        Frame.BackgroundTransparency = 1
        Frame.BorderSizePixel = 0
        Frame.AnchorPoint = v4.anchor
        Frame.Position = UDim2.fromScale(v4.anchor.X, v4.anchor.Y)
        Frame.Size = UDim2.fromScale(v4.vertical and 0 or 1, v4.vertical and 1 or 0)

        local UIGradient = Instance.new("UIGradient")

        UIGradient.Rotation = v4.rotation
        UIGradient.Transparency = v3
        UIGradient.Parent = Frame
        Frame.Parent = ScreenGui
        table.insert(t3, Frame)
    end

    ScreenGui.Parent = v1.LOCAL_PLAYER:WaitForChild("PlayerGui")
    p1.maid:GiveTask(ScreenGui)

    return t3
end

local function set_vignette(p2, p3, p4) -- line: 59
    -- upvalues: v2 (copy), t2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local v5 = CONSTANTS.flash_min_inset + (CONSTANTS.flash_max_inset - CONSTANTS.flash_min_inset) * p3
    local v6 = 1 - CONSTANTS.flash_brightness * p3

    for v7, v8 in p2.flash.bands do
        v8.BackgroundColor3 = p4
        v8.BackgroundTransparency = v6

        local vertical = t2[v7].vertical
        local fromScale = UDim2.fromScale
        local v9, v10

        if vertical then
            v10 = v5
            v9 = 1
        else
            v9 = v5
            v10 = 1
        end

        v8.Size = fromScale(v10, v9)
    end
end

local function get_flash_strength(p5, p6) -- line: 74
    -- upvalues: v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local started_at = p5.started_at

    if not started_at then
        return 0
    end

    local v11 = p6 - started_at

    if CONSTANTS.flash_rise_duration + p5.fade <= v11 then
        p5.started_at = nil

        return 0
    end

    if v11 < CONSTANTS.flash_rise_duration then
        return v1.ease_out(v11 / CONSTANTS.flash_rise_duration)
    end

    return 1 - v1.ease_in_out(v1.get_alpha(CONSTANTS.flash_rise_duration, v11, p5.fade))
end

local function step(p7, p8, p9) -- line: 98
    -- upvalues: v1 (copy), v2 (copy), set_vignette (copy), get_flash_strength (copy)
    local CONSTANTS = v2.CONSTANTS
    local flash = p7.flash
    local v12 = v1.get_chased_by()

    if v12 then
        flash.chased_by = v12
    end

    flash.targeted = v2.approach(flash.targeted, v12 and 1 or 0, p9 / CONSTANTS.targeted_vignette_fade_duration)

    local v13 = flash.targeted > CONSTANTS.targeted_vignette_min_visible
    local v14, v15, v16, flash_color

    if v13 then
        v14 = flash.targeted * v1.get_hunt_pulse(p8)
        v15 = p7.beam_colors[flash.chased_by]
    else
        v16 = get_flash_strength(flash, p8)
        flash_color = CONSTANTS.flash_color
    end

    if v13 and v15 or not v13 then
        if not v13 then
            v15 = flash_color
            v14 = v16
        end

        if v14 ~= 0 or flash.shown ~= 0 then
            flash.shown = v14
            set_vignette(p7, v14, v15)
        end
    end
end

function t1.play(p10, p11) -- line: 133
    p10.flash.started_at = os.clock()
    p10.flash.fade = p11
end

function t1.connect_flash(p12) -- line: 138
    -- upvalues: RunService (copy), build_vignette (copy), step (copy)
    p12.flash.bands = build_vignette(p12)
    p12.maid:GiveTask(RunService.PreRender:Connect(function(p13) -- line: 141
        -- upvalues: p12 (copy), step (copy)
        step(p12, os.clock(), p13)
    end))
end

return table.freeze(t1)
