-- https://lua.expert

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerRouter = require(ReplicatedStorage.Fsys).load("ServerRouter")
local v1 = require("./SpotlightShared")
local t1 = {}
local t2 = {}
local t3 = {}

local function publish() -- line: 14
    -- upvalues: ServerRouter (copy), v1 (copy), t2 (copy), t3 (ref)
    local t4 = {}

    for v2, v3 in t2 do
        table.insert(t4, {
            user_id = v2.UserId,
            name = v2.DisplayName,
            score = v3
        })
    end

    table.sort(t4, function(p1, p2) -- line: 20
        return p1.score > p2.score
    end)

    for i = #t4, v1.CONSTANTS.leaderboard_size + 1, -1 do
        t4[i] = nil
    end

    t3 = t4

    local v4 = ServerRouter.get("Halloween2026API/SpotlightLeaderboardUpdated")
    local t6 = t3

    v4:FireAllClients(t6)
end

function t1.submit(p3) -- line: 31
    -- upvalues: Players (copy), t2 (copy), publish (copy)
    for v5, v6 in p3 do
        if v6 > 0 and v5.Parent == Players then
            t2[v5] = math.max(t2[v5] or 0, v6)
        end
    end

    publish()
end

function t1.get_entries() -- line: 41
    -- upvalues: t3 (ref)
    return t3
end

Players.PlayerRemoving:Connect(function(p4) -- line: 45
    -- upvalues: t2 (copy), publish (copy)
    if t2[p4] then
        t2[p4] = nil
        publish()
    end
end)

return table.freeze(t1)
