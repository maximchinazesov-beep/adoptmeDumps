-- https://lua.expert

local t1 = {
    get_collected_attribute = function(p1) -- get_collected_attribute | line: 3
        return (tostring(p1.UserId))
    end,
    connect_spawners = function(p2, p3) -- connect_spawners | line: 7
        for _, child in p2:GetChildren() do
            p3(child)
        end

        return p2.ChildAdded:Connect(function(p4) -- line: 12
            -- upvalues: p3 (copy)
            p3(p4)
        end)
    end
}

return table.freeze(t1)
