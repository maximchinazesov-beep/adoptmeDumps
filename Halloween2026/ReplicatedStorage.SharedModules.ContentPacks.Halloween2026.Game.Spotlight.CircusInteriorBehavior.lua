-- https://lua.expert

local CollectionService = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local t1 = {}
local v1 = Color3.fromRGB(140, 180, 122)
local v2 = Color3.fromRGB(0, 0, 0)

function t1.render(_, _, p3) -- line: 10
    -- upvalues: CollectionService (copy), RunService (copy), v1 (copy), v2 (copy)
    local t2 = {}

    for _, v3 in CollectionService:GetTagged("CircusInteriorBlinkingLight") do
        t2[v3] = (tonumber(v3.Name:sub(5)) or error((("%* needs its number after \"Part\" to know when to blink"):format((v3:GetFullName()))))) % 2 == 0
    end

    local n1 = 0

    p3:GiveTask(RunService.PreRender:Connect(function(p4) -- line: 19
        -- upvalues: t2 (copy), n1 (ref), v1 (copy), v2 (copy)
        n1 += 2.13 * p4

        local v6 = math.floor(n1) % 2 == 0

        for v7, v8 in t2 do
            if v6 == v8 then
                v7.Color = v1
            else
                v7.Color = v2
            end
        end
    end))
end

return t1
