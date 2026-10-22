-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function get_exposure(p1) -- line: 8
    -- upvalues: v2 (copy)
    return p1:GetAttribute(v2.CONSTANTS.spotlight_exposure_attribute) or 0
end

local function build_fill(p2) -- line: 12
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local Frame = Instance.new("Frame")

    Frame.Name = "Track"
    Frame.Size = UDim2.fromScale(1, 1)
    Frame.BackgroundColor3 = CONSTANTS.reveal_bar_background_color
    Frame.BorderSizePixel = 0
    Frame.Parent = p2

    local UICorner = Instance.new("UICorner")

    UICorner.CornerRadius = CONSTANTS.reveal_bar_corner
    UICorner.Parent = Frame

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = CONSTANTS.reveal_bar_stroke_color
    UIStroke.Thickness = CONSTANTS.reveal_bar_stroke_thickness
    UIStroke.Parent = Frame

    local v3 = UDim.new(0, CONSTANTS.reveal_bar_inset)
    local UIPadding = Instance.new("UIPadding")

    UIPadding.PaddingTop = v3
    UIPadding.PaddingBottom = v3
    UIPadding.PaddingLeft = v3
    UIPadding.PaddingRight = v3
    UIPadding.Parent = Frame

    local Frame2 = Instance.new("Frame")

    Frame2.Name = "Fill"
    Frame2.Size = UDim2.fromScale(1, 1)
    Frame2.BackgroundColor3 = CONSTANTS.reveal_bar_hidden_color
    Frame2.BorderSizePixel = 0
    Frame2.Parent = Frame
    UICorner:Clone().Parent = Frame2

    return Frame2
end

local function step_bar(p3, p4, p5) -- line: 51
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS

    p4.shown = p4.shown + math.clamp((p3:GetAttribute(v2.CONSTANTS.spotlight_exposure_attribute) or 0) - p4.shown, -p5 / CONSTANTS.spotlight_conceal_duration, p5 / CONSTANTS.spotlight_expose_duration)

    local v7 = p4.shown > 0 and p4.shown < 1

    p4.billboard.Enabled = v7

    if not v7 then
        return
    end

    local v8 = 1 - p4.shown

    p4.fill.Size = UDim2.fromScale(v8, 1)
    p4.fill.BackgroundColor3 = CONSTANTS.reveal_bar_spotted_color:Lerp(CONSTANTS.reveal_bar_hidden_color, v8)
end

function t1.connect_reveal_bars(p6) -- line: 71
    -- upvalues: RunService (copy), v1 (copy), v2 (copy), build_fill (copy), step_bar (copy)
    local CONSTANTS = v2.CONSTANTS
    local by_character = p6.reveal_bars.by_character

    v1.connect_characters(p6, function(_, p8, p9) -- line: 75
        -- upvalues: CONSTANTS (copy), by_character (copy), v1 (copy), v2 (copy), build_fill (copy)
        local v9 = v1.build_head_billboard(p8, CONSTANTS.reveal_bar_name, CONSTANTS.reveal_bar_size, CONSTANTS.reveal_bar_offset)

        if not v9 then
            return
        end

        by_character[p8] = {
            billboard = v9,
            fill = build_fill(v9),
            shown = p8:GetAttribute(v2.CONSTANTS.spotlight_exposure_attribute) or 0
        }
        p9:GiveTask(v9)
        p9:GiveTask(function() -- line: 89
            -- upvalues: p8 (copy), by_character (copy)
            by_character[p8] = nil
        end)
    end)
    p6.maid:GiveTask(RunService.PreRender:Connect(function(p10) -- line: 94
        -- upvalues: by_character (copy), step_bar (copy)
        for v10, v11 in by_character do
            step_bar(v10, v11, p10)
        end
    end))
end

return table.freeze(t1)
