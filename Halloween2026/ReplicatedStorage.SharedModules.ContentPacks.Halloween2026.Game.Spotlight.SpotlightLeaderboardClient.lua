-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local FormatHelper = load("FormatHelper")
local RouterClient = load("RouterClient")
local v1 = require("./SpotlightShared")
local t1 = {}

local function show(p1, p2) -- line: 17
    -- upvalues: FormatHelper (copy)
    for v2, v3 in p1 do
        local v4 = p2[v2]

        v3.frame.Visible = v4 ~= nil

        if v4 then
            v3.name.Text = v4.name
            v3.score.Text = FormatHelper.add_number_commas(v4.score)
        end
    end
end

function t1.render(p3, p4) -- line: 29
    -- upvalues: RouterClient (copy), v1 (copy), show (copy)
    local CONSTANTS = v1.CONSTANTS
    local v5 = p3:FindFirstChild(CONSTANTS.leaderboard_sign_name, true) or error((("%* has no %*"):format(p3:GetFullName(), CONSTANTS.leaderboard_sign_name)))
    local v6 = v5:FindFirstChild(CONSTANTS.leaderboard_list_name, true) or error((("%* has no %* list"):format(v5:GetFullName(), CONSTANTS.leaderboard_list_name)))
    local v7 = table.create(CONSTANTS.leaderboard_size)

    for i = 1, CONSTANTS.leaderboard_size do
        local v8 = ("%*%*"):format(CONSTANTS.leaderboard_row_prefix, i)
        local v9 = v6:FindFirstChild(v8) or error((("%* has no %* row"):format(v6:GetFullName(), v8)))
        local v10 = v9:FindFirstChild(CONSTANTS.leaderboard_score_name) or error((("%* has no %*"):format(v9:GetFullName(), CONSTANTS.leaderboard_score_name)))

        v7[i] = {
            frame = v9,
            name = v9:FindFirstChild(CONSTANTS.leaderboard_name_label_name) or error((("%* has no %* label"):format(v9:GetFullName(), CONSTANTS.leaderboard_name_label_name))),
            score = v10:FindFirstChild(CONSTANTS.leaderboard_score_label_name) or error((("%* has no %* label"):format(v10:GetFullName(), CONSTANTS.leaderboard_score_label_name)))
        }
    end

    local function refresh(p5) -- line: 53
        -- upvalues: v7 (copy), show (copy)
        show(v7, p5)
    end

    show(v7, {})
    show(v7, (RouterClient.get("Halloween2026API/GetSpotlightLeaderboardData"):InvokeServer()))
    p4:GiveTask(RouterClient.get("Halloween2026API/SpotlightLeaderboardUpdated").OnClientEvent:Connect(refresh))
end

return table.freeze(t1)
