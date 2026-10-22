--[[local player
"dailies_manager": {
            "serialized_tabs": {
                "alerts": {
                    "total_dailies_completed_today": 0,
                    "reward_claimed": false, -- главнвя награда
                    "order": 2,
                    "total_dailies_completed": 0,
                    "active_dailies": {}
                },
                "halloween_2026": {
                    "total_dailies_completed_today": 0,
                    "reward_claimed": false,
                    "next_distribution_timestamp": 1791126000,
                    "order": 5,
                    "rewards": [
                        {
                            "kind": "halloween_2026_rusty_key",
                            "category": "toys"
                        }
                    ],
                    "total_dailies_completed": 0,
                    "active_dailies": {
                        "halloween_2026_complete_minigame": { -- суть задания сыграть в любую мини-игру
                            "state": {
                                "steps_completed": 1, -- фактически выполненые steps
                                "steps_to_complete": 1 
                            },
                            "is_new": true,
                            "order": 0,
                            "kind": "halloween_2026_complete_minigame" -- id задания в dailies_manager
                        },
                        "halloween_2026_use_rusty_key": { -- суть задания Разблокировать награду с помощью крипт ключа
                            "state": {
                                "steps_completed": 0,
                                "steps_to_complete": 1
                            },
                            "is_new": true,
                            "order": 1,
                            "kind": "halloween_2026_use_rusty_key"
                        },
                        "halloween_2026_complete_pet_needs": { -- суть задания просто выполнить колво заданий steps_to_complete
                            "state": {
                                "steps_completed": 18,
                                "steps_to_complete": 30
                            },
                            "is_new": true,
                            "order": 2,
                            "kind": "halloween_2026_complete_pet_needs"
                        }
                    }
                },]]

-- Для сбора если задание выполнено (хоть одно):
local args = {
	"halloween_2026" -- id quests
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("adoptme_new.modules.Dailies.DailiesNetService:9"):FireServer(unpack(args)) -- постоянный апи для сбора dailies

-- для сбора главного приза
local args = {
	"halloween_2026"
}
game:GetService("ReplicatedStorage"):WaitForChild("adoptme_new_net"):WaitForChild("adoptme_new.modules.Dailies.DailiesNetService:15"):FireServer(unpack(args)) 

