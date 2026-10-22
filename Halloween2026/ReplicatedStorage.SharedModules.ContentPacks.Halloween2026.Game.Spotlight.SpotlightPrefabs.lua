-- https://lua.expert

local v1 = require("./SpotlightShared")
local t1 = {}

function t1.get_template(p1) -- line: 5
    -- upvalues: v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local v2 = p1:GetAttribute(CONSTANTS.resource_prefab_attribute) or error((("%* has no %*"):format(p1:GetFullName(), CONSTANTS.resource_prefab_attribute)))

    return v1.get_resources():FindFirstChild(v2) or error((("Resources has no %* prefab for %*"):format(v2, (p1:GetFullName()))))
end

function t1.clone(p2) -- line: 15
    -- upvalues: t1 (copy)
    local clone = t1.get_template(p2):Clone()

    clone:PivotTo(p2:GetPivot())

    return clone
end

function t1.unpack(p3) -- line: 22
    -- upvalues: t1 (copy)
    if #p3:GetChildren() > 0 then
        return
    end

    local v3 = t1.clone(p3)

    for _, child in v3:GetChildren() do
        child.Parent = p3
    end

    v3:Destroy()
end

function t1.unpack_all(p4) -- line: 35
    -- upvalues: t1 (copy)
    for _, child in p4:GetChildren() do
        t1.unpack(child)
    end
end

return table.freeze(t1)
