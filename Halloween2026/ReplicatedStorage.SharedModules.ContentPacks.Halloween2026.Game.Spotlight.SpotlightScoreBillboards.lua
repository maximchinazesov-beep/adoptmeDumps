-- https://lua.expert

local RunService = game:GetService("RunService")
local v1 = require("./SpotlightClientState")
local v2 = require("./SpotlightShared")
local t1 = {}

local function build_label(p1) -- line: 14
    -- upvalues: v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local TextLabel = Instance.new("TextLabel")

    TextLabel.Name = "Count"
    TextLabel.Size = UDim2.fromScale(1, 1)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Font = Enum.Font.FredokaOne
    TextLabel.TextScaled = true
    TextLabel.TextColor3 = CONSTANTS.score_billboard_text_color
    TextLabel.Parent = p1

    local UIGradient = Instance.new("UIGradient")

    UIGradient.Color = ColorSequence.new(CONSTANTS.score_billboard_text_color, CONSTANTS.score_billboard_accent_color)
    UIGradient.Rotation = 90
    UIGradient.Parent = TextLabel

    local UIStroke = Instance.new("UIStroke")

    UIStroke.Color = CONSTANTS.score_billboard_stroke_color
    UIStroke.Thickness = CONSTANTS.score_billboard_stroke_thickness
    UIStroke.Parent = TextLabel

    return TextLabel
end

local function paint(p2, p3) -- line: 39
    -- upvalues: v2 (copy)
    local v3 = p3:GetAttribute(v2.CONSTANTS.candycorn_score_attribute) or 0

    p2.label.Text = tostring(v3)
    p2.gui.Enabled = v3 > 0
end

local function step(p4, p5) -- line: 46
    -- upvalues: v1 (copy), v2 (copy)
    local CONSTANTS = v2.CONSTANTS
    local v4 = v1.get_alpha(p4.changed_at, p5, CONSTANTS.score_billboard_pop_duration)
    local v5 = math.lerp(CONSTANTS.score_billboard_pop_scale, 1, v1.ease_out(v4))
    local score_billboard_size = CONSTANTS.score_billboard_size

    p4.gui.Size = UDim2.fromScale(score_billboard_size.X.Scale * v5, score_billboard_size.Y.Scale * v5)

    return v4 < 1
end

function t1.connect_score_billboards(p6) -- line: 58
    -- upvalues: RunService (copy), v1 (copy), v2 (copy), build_label (copy), step (copy)
    local CONSTANTS = v2.CONSTANTS
    local popping = p6.billboards.popping

    v1.connect_characters(p6, function(p7, p8, p9) -- line: 62
        -- upvalues: CONSTANTS (copy), popping (copy), v1 (copy), v2 (copy), build_label (copy)
        local v6 = v1.build_head_billboard(p8, CONSTANTS.score_billboard_name, CONSTANTS.score_billboard_size, CONSTANTS.score_billboard_offset)

        if not v6 then
            return
        end

        local t2 = {
            changed_at = 0,
            gui = v6,
            label = build_label(v6)
        }
        local v7 = p7:GetAttribute(v2.CONSTANTS.candycorn_score_attribute) or 0

        t2.label.Text = tostring(v7)
        t2.gui.Enabled = v7 > 0
        p9:GiveTask(v6)
        p9:GiveTask(function() -- line: 82
            -- upvalues: t2 (copy), popping (copy)
            popping[t2] = nil
        end)
        p9:GiveTask(p7:GetAttributeChangedSignal(CONSTANTS.candycorn_score_attribute):Connect(function() -- line: 85
            -- upvalues: p7 (copy), t2 (copy), popping (copy), v2 (copy)
            t2.changed_at = os.clock()

            local v8 = p7:GetAttribute(v2.CONSTANTS.candycorn_score_attribute) or 0

            t2.label.Text = tostring(v8)
            t2.gui.Enabled = v8 > 0
            popping[t2] = true
        end))
    end)
    p6.maid:GiveTask(RunService.Heartbeat:Connect(function() -- line: 92
        -- upvalues: popping (copy), step (copy)
        local elapsed = os.clock()

        for v9 in popping do
            if not step(v9, elapsed) then
                popping[v9] = nil
            end
        end
    end))
end

return table.freeze(t1)
