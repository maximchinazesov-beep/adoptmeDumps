--main branch: game:GetService("ReplicatedStorage").SharedModules.ContentPacks.Halloween2026
-- валюта ивента: candy currency

--[[Что нужно делать:
❔ Pets в покупках засапортить
❔ GhostClusters minigame support 
❔ JacobeanPigeonNest support
❔ Dailies сделать 
❔ Candy Corn разобраться
crypt twig фикс

удалить после окончания ивента
-- МЬЮТЕКС: Пауза автофарма перед мини-игрой (за 50 секунд и во время игры)
            if getgenv().GhostClusterEnabled then
                local cycle_data = M.ClientData.get("ghost_clusters_cycle_timestamp")
                if cycle_data and cycle_data.timestamp then
                    local time_left = cycle_data.timestamp - os.time()
                    if time_left < 50 and time_left > -120 then
                        getgenv().SetLiveStatus("Paused: Ghost Event")
                        continue
                    end
                end
            end
            autofarm
            и 

-- МЬЮТЕКС: Если включен авто-ивент и до мини-игры осталось меньше 50 сек (или она идет) -> Автолюр спит
            if getgenv().GhostClusterEnabled then
                local cycle_data = DuskCore.M.ClientData.get("ghost_clusters_cycle_timestamp")
                if cycle_data and cycle_data.timestamp then
                    local time_left = cycle_data.timestamp - os.time()
                    if time_left < 50 and time_left > -120 then
                        getgenv().LureStatusText = "Paused: Ghost Event"
                        continue
                    end
                end
            end
            спешал
]]