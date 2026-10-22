-- https://lua.expert

local ContentProvider = game:GetService("ContentProvider")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local load = require(ReplicatedStorage.Fsys).load
local AnimationManager = load("AnimationManager")
local DownloadClient = load("DownloadClient")
local SoundDB = load("SoundDB")
local SoundPlayer = load("SoundPlayer")
local v1 = require("./SpotlightShared")
local t1 = {}
local v2 = false

local function add_descendants(p1, p2) -- line: 22
    for _, descendant in p2:GetDescendants() do
        table.insert(p1, descendant)
    end
end

local function get_assets() -- line: 28
    -- upvalues: AnimationManager (copy), SoundDB (copy), SoundPlayer (copy), v1 (copy)
    local CONSTANTS = v1.CONSTANTS
    local t2 = {}

    for _, descendant in (SoundPlayer.FX.folder:FindFirstChild(CONSTANTS.sound_folder_name) or error((("Sounds/FX has no %* folder"):format(CONSTANTS.sound_folder_name)))):GetDescendants() do
        table.insert(t2, descendant)
    end

    for _, descendant in v1.get_resources():GetDescendants() do
        table.insert(t2, descendant)
    end

    for v3 in CONSTANTS.ringmaster_animations do
        table.insert(t2, AnimationManager.get_track(CONSTANTS.ringmaster_animation_prefix .. v3))
    end

    table.insert(t2, (SoundDB[CONSTANTS.minigame_music_id] or error((("SoundDB has no %*"):format(CONSTANTS.minigame_music_id)))).id)

    return t2
end

function t1.start() -- line: 49
    -- upvalues: ContentProvider (copy), v2 (ref), get_assets (copy)
    if not v2 then
        v2 = true
        task.spawn(function() -- line: 55
            -- upvalues: ContentProvider (copy), get_assets (copy)
            ContentProvider:PreloadAsync((get_assets()))
        end)
    end
end

function t1.start_interior(p3) -- line: 60
    -- upvalues: ContentProvider (copy), DownloadClient (copy)
    task.spawn(function() -- line: 61
        -- upvalues: p3 (copy), ContentProvider (copy), DownloadClient (copy)
        local t3 = {}

        for _, descendant in DownloadClient.download("Interiors", p3):GetDescendants() do
            table.insert(t3, descendant)
        end

        ContentProvider:PreloadAsync(t3)
    end)
end

function t1.load_round(p4, p5) -- line: 68
    -- upvalues: ContentProvider (copy), get_assets (copy)
    local t4 = {
        loaded = 0,
        failed = 0,
        done = false
    }
    local v5 = get_assets()

    for _, v6 in p5 do
        for _, descendant in v6:GetDescendants() do
            table.insert(v5, descendant)
        end
    end

    p4:GiveTask(task.spawn(function() -- line: 76
        -- upvalues: t4 (copy), v5 (copy), ContentProvider (copy)
        ContentProvider:PreloadAsync(v5, function(_, p7) -- line: 77
            -- upvalues: t4 (copy)
            if p7 == Enum.AssetFetchStatus.Success then
                t4.loaded += 1
            else
                t4.failed += 1
            end
        end)
        t4.done = true
    end))

    return t4
end

return table.freeze(t1)
