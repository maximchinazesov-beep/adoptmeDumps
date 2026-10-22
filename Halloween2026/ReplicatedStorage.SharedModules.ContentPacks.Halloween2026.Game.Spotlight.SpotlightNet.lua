-- https://lua.expert

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local NetEvent = require(ReplicatedStorage.new.modules.Net.NetEvent)
local gt = require(ReplicatedStorage.SharedPackages.gt)
local t1 = {
    beam = NetEvent.new({
        unreliable = true,
        request = {
            index = gt.number(),
            lit = gt.boolean(),
            target = gt.Vector3(),
            hunt = gt.number(),
            sequence = gt.number(),
            span = gt.number()
        },
        rate = {
            mode = "Infinite"
        }
    }),
    cannon_stream = NetEvent.new({
        request = {
            cannon = gt.number(),
            landings = gt.array(gt.Vector3()),
            fires_at = gt.number(),
            lands_at = gt.number()
        },
        rate = {
            mode = "Infinite"
        }
    })
}

return table.freeze(t1)
