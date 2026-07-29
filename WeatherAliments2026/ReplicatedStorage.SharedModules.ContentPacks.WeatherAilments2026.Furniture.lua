-- https://lua.expert/
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local ServerScriptService = game:GetService("ServerScriptService")
local EntryHelper = require(ReplicatedStorage.ClientDB.Inventory.EntryHelper)
local GameplayFX = require(ReplicatedStorage.SharedModules.GameplayFX)
local LiveOpsTime = require(ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local Promise = require(ReplicatedStorage.SharedPackages.Promise)
local SharedConstants = require(ReplicatedStorage.ClientDB.SharedConstants)
local Sift = require(ReplicatedStorage.SharedPackages.Sift)
local TweenPromise = require(ReplicatedStorage.SharedModules.TweenPromise)
local SoundPlayer = require(ReplicatedStorage.SharedModules.SoundPlayer)
local gt = require(ReplicatedStorage.SharedPackages.gt)
local NetEvent = require(ReplicatedStorage.new.modules.Net.NetEvent)
local Resources = ReplicatedStorage.Resources
local t = {
	AilmentFurnitureUse = NetEvent.new({
		request = gt.none(),
		response = gt.anyTable(),
		rate = {
			mode = "SlidingWindow",
			seconds = 1,
			limit = 10
		}
	}),
	AilmentFurnitureDone = NetEvent.new({
		request = gt.none(),
		response = gt.any(),
		rate = {
			mode = "SlidingWindow",
			seconds = 1,
			limit = 10
		}
	})
}

local function RAIN_PUDDLE() --[[ RAIN_PUDDLE | Line: 34 | Upvalues: SharedConstants (copy), Sift (copy), CollectionService (copy) ]]
	return function() --[[ Line: 35 | Upvalues: SharedConstants (ref), Sift (ref), CollectionService (ref) ]]
		return {
			ailment_to_boost = { "rain_puddle", SharedConstants.full_rain_puddle_duration },
			init = function(p13) --[[ init | Line: 38 | Upvalues: Sift (ref) ]]
				local RainPuddles = workspace.StaticMap:FindFirstChild("RainPuddles")

				if not RainPuddles then
					local RainPuddles2 = Instance.new("Folder")

					RainPuddles2.Name = "RainPuddles"
					RainPuddles2.Parent = workspace.StaticMap
					RainPuddles = RainPuddles2
				end

				if Sift.List.some(RainPuddles:GetChildren(), function(p1) --[[ Line: 45 | Upvalues: p13 (copy) ]]
					return p1.CFrame == p13.cframe
				end) then
					return
				end

				local RainPuddle = Instance.new("Part")

				RainPuddle.Name = "RainPuddle"
				RainPuddle.CFrame = p13.cframe
				RainPuddle.CollisionGroup = "no_collisions"
				RainPuddle.CanCollide = false
				RainPuddle.CanTouch = false
				RainPuddle.CanQuery = false
				RainPuddle.Anchored = true
				RainPuddle.Transparency = 1
				RainPuddle.Size = Vector3.new(1, 1, 1)
				RainPuddle:AddTag("RainPuddleServer")
				RainPuddle.Parent = RainPuddles
			end,
			render = function(p13, p23) --[[ render | Line: 63 | Upvalues: CollectionService (ref) ]]
				CollectionService:AddTag(p23, "RainPuddle")
			end
		}
	end
end

local function leaf_pile_respawn_function(p1, p2) --[[ leaf_pile_respawn_function | Line: 70 | Upvalues: GameplayFX (copy), Resources (copy), CollectionService (copy), LiveOpsTime (copy), SharedConstants (copy), ReplicatedStorage (copy) ]]
	local v1 = p1:GetChildren()[1]
	local v2 = v1 and v1:FindFirstChild("Visual")

	if not v2 then
		return
	end

	for v3, v4 in v2:GetChildren() do
		if v4:IsA("BasePart") then
			v4.Transparency = 1
		end
	end

	GameplayFX.emit_particle_group(Resources.IceSkating.SpawnPoof, v1.WorldPivot.Position)
	CollectionService:RemoveTag(v1, "LeafPile")
	p2.props.furniture_data.respawn_at = LiveOpsTime.now() + SharedConstants.leaf_pile_cooldown
	p2.props.furniture_data.hide_prompt_because_used = nil
	require(ReplicatedStorage.ClientModules.Core.RouterClient.RouterClient).get("InteractablesAPI/DisableInteractionWithMe"):FireServer(false)
	LiveOpsTime.delay_until(p2.props.furniture_data.respawn_at):andThen(function() --[[ Line: 89 | Upvalues: v1 (ref), p1 (copy), v2 (ref), GameplayFX (ref), Resources (ref), CollectionService (ref) ]]
		v1 = p1:GetChildren()[1]
		v2 = v1 and v1:FindFirstChild("Visual")

		if not v2 then
			return
		end

		for v22, v3 in v2:GetChildren() do
			if v3:IsA("BasePart") then
				v3.Transparency = 0
			end
		end

		GameplayFX.emit_particle_group(Resources.IceSkating.SpawnPoof, v1.WorldPivot.Position)
		CollectionService:AddTag(v1, "LeafPile")
	end)
end

local function LEAF_PILE() --[[ LEAF_PILE | Line: 104 | Upvalues: SharedConstants (copy), LiveOpsTime (copy), ReplicatedStorage (copy), Promise (copy), t (copy), Resources (copy), leaf_pile_respawn_function (copy), ServerScriptService (copy), Sift (copy), CollectionService (copy) ]]
	return function() --[[ Line: 105 | Upvalues: SharedConstants (ref), LiveOpsTime (ref), ReplicatedStorage (ref), Promise (ref), t (ref), Resources (ref), leaf_pile_respawn_function (ref), ServerScriptService (ref), Sift (ref), CollectionService (ref) ]]
		return {
			use_id = "leaf_pile",
			caregiver_assist = true,
			exclude_player = true,
			protect_interaction = true,
			ailment_to_boost = { "leaf_pile", nil, 1 / SharedConstants.leaf_pile_uses },
			team_whitelist = { "Pets", "Dolls" },
			use_text = function(p1, p2, p3, p4) --[[ use_text | Line: 114 | Upvalues: LiveOpsTime (ref) ]]
				if p4.props.furniture_data.hide_prompt_because_used then
					return nil
				end

				if LiveOpsTime.now() < (p4.props.furniture_data.respawn_at or 0) then
					return nil
				end

				p4.props.furniture_data.respawn_at = nil

				return "Jump in!"
			end,
			client_use = function(p1, p2, p3, p4, p5, p6) --[[ client_use | Line: 127 | Upvalues: ReplicatedStorage (ref), Promise (ref), t (ref), Resources (ref), leaf_pile_respawn_function (ref) ]]
				local PetEntityManager = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityManager)
				local PetEntityHelper = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityHelper)
				local PetPerformanceName = require(ReplicatedStorage.SharedModules.PetPerformanceName)
				local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
				local v1 = PetEntityManager.get_pet_entity(p4)

				if not v1 then
					return
				end

				if v1.modifier_values_from_performances.dont_allow_sit_states then
					UIManager.apps.HintApp:hint({
						text = "Your pet can\'t use this right now!",
						yields = false
					})
				else
					local v2 = nil

					Promise.race({ Promise.new(function(p1) --[[ Line: 146 | Upvalues: v2 (ref), t (ref) ]]
							v2 = t.AilmentFurnitureUse:on_client_event(p1)
						end), Promise.delay(12) }):andThen(function() --[[ Line: 150 | Upvalues: v2 (ref) ]]
						v2:Disconnect()
					end):expect()
					task.wait()

					local v3 = p6.furniture.Parent

					PetEntityHelper.stage_performance(v1, {
						name = PetPerformanceName.LeafPile,
						options = {
							furniture_folder = v3,
							vfx_model = Resources.LeafPileParticles
						}
					})
					PetEntityHelper.promise_performance_ended(v1, PetPerformanceName.LeafPile):andThen(function() --[[ Line: 165 | Upvalues: leaf_pile_respawn_function (ref), v3 (copy), p6 (copy), t (ref) ]]
						leaf_pile_respawn_function(v3, p6)
						t.AilmentFurnitureDone:fire_server()
					end)
				end
			end,
			server_use = function(p1, p2, p3, p4, p5, p6, p7, p8) --[[ server_use | Line: 170 | Upvalues: ServerScriptService (ref), ReplicatedStorage (ref), Promise (ref), t (ref), SharedConstants (ref) ]]
				local AilmentsServer = require(ServerScriptService.new.modules.Ailments.AilmentsServer)
				local CharacterWrapper = require(ServerScriptService.Modules.Game.CharacterWrapper)
				local PetEntityManagerServer = require(ServerScriptService.Services.Frame_4.Order_03.PetEntitiesServer.PetEntityManagerServer)
				local StreamingHelper = require(ReplicatedStorage.new.modules.StreamingHelper)
				local NotificationManager = require(ServerScriptService.Modules.Game.NotificationManager)
				local v1 = CharacterWrapper.get(p6)

				if not v1 then
					return
				end

				local v2 = PetEntityManagerServer.get_pet_entity(p6)

				if v2 and v2.modifiers.dont_allow_sit_states then
					return
				end

				p2.occupied = p2.occupied or {}

				if not p2.occupied[p7] then
					p2.occupied[p7] = StreamingHelper.as_id(v1.char)
					p3()
					Promise.try(function() --[[ Line: 194 | Upvalues: v1 (copy), p2 (copy), p1 (copy), t (ref), Promise (ref), NotificationManager (copy), AilmentsServer (copy), SharedConstants (ref) ]]
						v1.state_manager:exit_all_states()

						local v12 = v1.state_manager:enter({
							id = "CharacterConnect",
							params = {
								furniture_use_id = "leaf_pile",
								furniture_id = p2.id,
								parent = p1.Character
							}
						})

						if not v12 then
							return
						end

						local v2 = if v1.is_pet then v1:get_property("pet_unique") else nil

						task.wait()
						t.AilmentFurnitureUse:fire_client(p1, nil)

						local v3 = nil
						local v4 = false

						Promise.race({ Promise.new(function(p13) --[[ Line: 216 | Upvalues: v3 (ref), t (ref), p1 (ref), v4 (ref) ]]
								v3 = t.AilmentFurnitureDone:on_server_event(function(p14, p2) --[[ Line: 217 | Upvalues: p1 (ref), v4 (ref), p13 (copy) ]]
									if p14 ~= p1 then
										return
									end

									v4 = true
									p13()
								end)
							end), Promise.delay(12) }):finally(function() --[[ Line: 225 | Upvalues: v12 (copy), v3 (ref), v4 (ref), v2 (copy), NotificationManager (ref), p1 (ref), p2 (ref), AilmentsServer (ref), v1 (ref), SharedConstants (ref) ]]
							v12:exit()
							v3:Disconnect()

							if not v4 then
								return
							end

							if v2 then
								NotificationManager.indicate_event({
									name = "player_interacted_with_pet",
									player = p1,
									options = {
										unique_id = v2,
										furniture_id = p2.id
									}
								})
							end

							AilmentsServer.add_progress(v1, "leaf_pile", 1 / SharedConstants.leaf_pile_uses)
						end)
						v12:yield_until_exit()
					end):catch(function(p1) --[[ Line: 246 ]]
						warn(p1)
					end):await()
					p2.occupied[p7] = nil
				end
			end,
			init = function(p1) --[[ init | Line: 252 | Upvalues: Sift (ref) ]]
				local LeafPiles = workspace.StaticMap:FindFirstChild("LeafPiles")

				if not LeafPiles then
					local LeafPiles2 = Instance.new("Folder")

					LeafPiles2.Name = "LeafPiles"
					LeafPiles2.Parent = workspace.StaticMap
					LeafPiles = LeafPiles2
				end

				if Sift.List.some(LeafPiles:GetChildren(), function(p13) --[[ Line: 259 | Upvalues: p1 (copy) ]]
					return p13.CFrame == p1.cframe
				end) then
					return
				end

				local LeafPile = Instance.new("Part")

				LeafPile.Name = "LeafPile"
				LeafPile.CFrame = p1.cframe
				LeafPile.CollisionGroup = "no_collisions"
				LeafPile.CanCollide = false
				LeafPile.CanTouch = false
				LeafPile.CanQuery = false
				LeafPile.Anchored = true
				LeafPile.Transparency = 1
				LeafPile.Size = Vector3.new(1, 1, 1)
				LeafPile:AddTag("LeafPileServer")
				LeafPile.Parent = LeafPiles
			end,
			render = function(p1, p2, p3, p4) --[[ render | Line: 277 | Upvalues: LiveOpsTime (ref), CollectionService (ref) ]]
				if p4 then
					if p4.respawn_at then
						for v1, v2 in p2:FindFirstChild("Visual"):GetChildren() do
							if v2:IsA("BasePart") then
								v2.Transparency = 1
							end
						end

						p1.respawn_at = p4.respawn_at
					end

					if p4.hide_prompt_because_used then
						p1.hide_prompt_because_used = true
					end
				end

				if p1.respawn_at and not (LiveOpsTime.now() >= p1.respawn_at) then
					return
				end

				CollectionService:AddTag(p2, "LeafPile")
			end
		}
	end
end

local v1 = TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, 0, true)

local function DIVING_BOARD() --[[ DIVING_BOARD | Line: 305 | Upvalues: SharedConstants (copy), LiveOpsTime (copy), ReplicatedStorage (copy), Promise (copy), t (copy), GameplayFX (copy), TweenPromise (copy), v1 (copy), SoundPlayer (copy), CollectionService (copy), ServerScriptService (copy), Sift (copy) ]]
	return function() --[[ Line: 306 | Upvalues: SharedConstants (ref), LiveOpsTime (ref), ReplicatedStorage (ref), Promise (ref), t (ref), GameplayFX (ref), TweenPromise (ref), v1 (ref), SoundPlayer (ref), CollectionService (ref), ServerScriptService (ref), Sift (ref) ]]
		return {
			use_id = "diving_board",
			protect_interaction = true,
			ailment_to_boost = { "diving_board", nil, 1 / SharedConstants.diving_board_uses },
			use_text = function(p13, p23, p33, p43) --[[ use_text | Line: 311 | Upvalues: LiveOpsTime (ref), SharedConstants (ref) ]]
				local v1 = LiveOpsTime.now()

				if not p43.used_at then
					return "Dive!"
				end

				if v1 - p43.used_at < SharedConstants.diving_board_cooldown then
					return nil
				end

				p43.used_at = nil

				return "Dive!"
			end,
			client_use = function(p13, p23, p33, p43, p53, p63) --[[ client_use | Line: 322 | Upvalues: ReplicatedStorage (ref), Promise (ref), t (ref), GameplayFX (ref), TweenPromise (ref), v1 (ref), SoundPlayer (ref), LiveOpsTime (ref), CollectionService (ref), SharedConstants (ref) ]]
				local ControlsDisabler = require(ReplicatedStorage.ClientModules.Game.ControlsDisabler)
				local RouterClient = require(ReplicatedStorage.ClientModules.Core.RouterClient.RouterClient)
				local v12 = p33.Parent
				local Character = game.Players.LocalPlayer.Character
				local v2 = Character and Character:FindFirstChild("HumanoidRootPart")

				if not v2 then
					return
				end

				local v3 = nil

				Promise.race({ Promise.new(function(p13) --[[ Line: 334 | Upvalues: v3 (ref), t (ref) ]]
						v3 = t.AilmentFurnitureUse:on_client_event(p13)
					end), Promise.delay(12) }):andThen(function() --[[ Line: 338 | Upvalues: v3 (ref) ]]
					v3:Disconnect()
				end):expect()
				task.wait()
				RouterClient.get("InteractablesAPI/DisableInteractionWithMe"):FireServer(true)
				ControlsDisabler.disable_controls("DivingBoard")
				task.delay(5, function() --[[ Line: 347 | Upvalues: RouterClient (copy), ControlsDisabler (copy) ]]
					RouterClient.get("InteractablesAPI/DisableInteractionWithMe"):FireServer(false)
					ControlsDisabler.enable_controls("DivingBoard")
				end)

				local PlayerTarget = v12:GetChildren()[1]:FindFirstChild("PlayerTarget")

				v2.CFrame = PlayerTarget.CFrame
				GameplayFX.emit_poof(PlayerTarget.Position)

				local function player_actions_callback() --[[ player_actions_callback | Line: 356 | Upvalues: Character (copy), ReplicatedStorage (ref), v12 (copy), Promise (ref), TweenPromise (ref), v1 (ref), v2 (copy), SoundPlayer (ref), RouterClient (copy), ControlsDisabler (copy) ]]
					local v13 = Character and Character:FindFirstChildOfClass("Humanoid")

					if not v13 then
						return
					end

					local v22 = v13:LoadAnimation((require(ReplicatedStorage.ClientDB.AnimationManager).get_track("IceSkatingJump")))
					local PetPlatform = v12:GetChildren()[1]:FindFirstChild("PetPlatform")
					local PlayerPlatform = v12:GetChildren()[1]:FindFirstChild("PlayerPlatform")

					Promise.all({ TweenPromise.new(PetPlatform.PrimaryPart, v1, {
							CFrame = PetPlatform.PrimaryPart.CFrame * CFrame.Angles(-0.5235987755982988, 0, 0)
						}), TweenPromise.new(PlayerPlatform.PrimaryPart, v1, {
							CFrame = PlayerPlatform.PrimaryPart.CFrame * CFrame.Angles(-0.5235987755982988, 0, 0)
						}) }):andThen(function() --[[ Line: 374 | Upvalues: v13 (copy), v2 (ref), SoundPlayer (ref), v22 (copy), RouterClient (ref), ControlsDisabler (ref) ]]
						v13.Jump = true
						v2:ApplyImpulse(Vector3.new(v2.CFrame.LookVector.X, 1, v2.CFrame.LookVector.Z) * v2.AssemblyMass * 42.5)
						SoundPlayer.FX:play("DivingBoardPlayerJump")

						local v23 = nil

						v23 = v13.StateChanged:Connect(function(p13, p23) --[[ Line: 382 | Upvalues: SoundPlayer (ref), v23 (ref) ]]
							if p23 ~= Enum.HumanoidStateType.Swimming then
								return
							end

							SoundPlayer.FX:play("DivingBoardPlayerSplash")
							v23:Disconnect()
						end)
						task.delay(5, function() --[[ Line: 390 | Upvalues: v23 (ref) ]]
							if not v23 then
								return
							end

							v23:Disconnect()
						end)
						v22:Play()
						task.delay(3, function() --[[ Line: 399 | Upvalues: v22 (ref) ]]
							v22:Stop()
							v22:Destroy()
						end)
						task.delay(1, function() --[[ Line: 404 | Upvalues: RouterClient (ref), ControlsDisabler (ref) ]]
							RouterClient.get("InteractablesAPI/DisableInteractionWithMe"):FireServer(false)
							ControlsDisabler.enable_controls("DivingBoard")
						end)
					end)
				end

				local PetEntityManager = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityManager)
				local PetEntityHelper = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityHelper)
				local PetPerformanceName = require(ReplicatedStorage.SharedModules.PetPerformanceName)
				local CharWrapperClient = require(ReplicatedStorage.ClientModules.Game.CharWrapperClient)
				local count2 = 0
				local t2 = {}

				for v4, v5 in require(ReplicatedStorage.SharedModules.EquippedPets).get_controlled_char_wrappers() do
					if CharWrapperClient.is_in_same_location(CharWrapperClient.get(Character), v5) then
						p63.used_at = LiveOpsTime.now()

						local t3 = {
							furniture_folder = v12,
							delay = count2
						}

						if count2 == 0 then
							t3.player_actions_callback = player_actions_callback
						end

						local v6 = PetEntityManager.get_pet_entity(v5.char)

						PetEntityHelper.stage_performance(v6, {
							name = PetPerformanceName.DivingBoard,
							options = t3
						})
						table.insert(t2, PetEntityHelper.promise_performance_ended(v6, PetPerformanceName.DivingBoard))
						count2 = count2 + 1
					end
				end

				CollectionService:RemoveTag(p33, "DivingBoard")
				LiveOpsTime.delay_until(LiveOpsTime.now() + SharedConstants.diving_board_cooldown):andThen(function() --[[ Line: 449 | Upvalues: v12 (copy), CollectionService (ref) ]]
					local v1 = v12:GetChildren()[1]

					if not v1 then
						return
					end

					CollectionService:AddTag(v1, "DivingBoard")
				end)

				if count2 == 0 then
					player_actions_callback()
					t.AilmentFurnitureDone:fire_server()
				else
					Promise.all(t2):finally(function() --[[ Line: 461 | Upvalues: t (ref) ]]
						t.AilmentFurnitureDone:fire_server()
					end)
				end
			end,
			server_use = function(p13, p23, p33, p43, p53, p63, p73, p83) --[[ server_use | Line: 466 | Upvalues: ServerScriptService (ref), ReplicatedStorage (ref), t (ref), Promise (ref), SharedConstants (ref) ]]
				local AilmentsServer = require(ServerScriptService.new.modules.Ailments.AilmentsServer)
				local EquippedPets = require(ReplicatedStorage.SharedModules.EquippedPets)
				local CharacterWrapper = require(ServerScriptService.Modules.Game.CharacterWrapper)
				local NotificationManager = require(ServerScriptService.Modules.Game.NotificationManager)
				local v1 = CharacterWrapper.get(p63)
				local state_manager = v1.state_manager

				state_manager:exit_all_states()

				if v1:get_team() == "Parents" then
					state_manager:lock()
				end

				local v2 = EquippedPets.get_controlled_char_wrappers(p13)
				local t2 = {}

				for v3, v4 in v2 do
					if v4:is_valid() and v4.is_pet then
						v4.state_manager:exit_all_states()
						v4:set_property("entity_controller", p13)

						local v5 = v4.state_manager:enter({
							id = "CharacterConnect",
							params = {
								furniture_use_id = "diving_board",
								furniture_id = p23.id,
								parent = p13.Character
							}
						})

						if v5 then
							table.insert(t2, v5)
						end
					end
				end

				task.wait()
				t.AilmentFurnitureUse:fire_client(p13, nil)

				local v6 = nil
				local v7 = false

				Promise.race({ Promise.new(function(p1) --[[ Line: 507 | Upvalues: v6 (ref), t (ref), p13 (copy), v7 (ref) ]]
						v6 = t.AilmentFurnitureDone:on_server_event(function(p12, p23) --[[ Line: 508 | Upvalues: p13 (ref), v7 (ref), p1 (copy) ]]
							if p12 ~= p13 then
								return
							end

							v7 = true
							p1()
						end)
					end), Promise.delay(12) }):finally(function() --[[ Line: 516 | Upvalues: t2 (copy), state_manager (copy), v6 (ref), v7 (ref), v2 (copy), NotificationManager (copy), p13 (copy), p23 (copy), AilmentsServer (copy), SharedConstants (ref) ]]
					for v1, v22 in t2 do
						v22:exit()
					end

					state_manager:unlock()
					v6:Disconnect()

					if not v7 then
						return
					end

					for v3, v4 in v2 do
						if v4:is_valid() and v4.is_pet then
							local v5 = v4:get_property("pet_unique")

							if v5 then
								NotificationManager.indicate_event({
									name = "player_interacted_with_pet",
									player = p13,
									options = {
										unique_id = v5,
										furniture_id = p23.id
									}
								})
							end

							AilmentsServer.add_progress(v4, "diving_board", 1 / SharedConstants.diving_board_uses)
						end
					end
				end):await()
			end,
			init = function(p13) --[[ init | Line: 544 | Upvalues: Sift (ref) ]]
				local DivingBoards = workspace.StaticMap:FindFirstChild("DivingBoards")

				if not DivingBoards then
					local DivingBoards2 = Instance.new("Folder")

					DivingBoards2.Name = "DivingBoards"
					DivingBoards2.Parent = workspace.StaticMap
					DivingBoards = DivingBoards2
				end

				if Sift.List.some(DivingBoards:GetChildren(), function(p1) --[[ Line: 551 | Upvalues: p13 (copy) ]]
					return p1.CFrame == p13.cframe
				end) then
					return
				end

				local DivingBoard = Instance.new("Part")

				DivingBoard.Name = "DivingBoard"
				DivingBoard.CFrame = p13.cframe
				DivingBoard.CollisionGroup = "no_collisions"
				DivingBoard.CanCollide = false
				DivingBoard.CanTouch = false
				DivingBoard.CanQuery = false
				DivingBoard.Anchored = true
				DivingBoard.Transparency = 1
				DivingBoard.Size = Vector3.new(1, 1, 1)
				DivingBoard:AddTag("DivingBoardServer")
				DivingBoard.Parent = DivingBoards
			end,
			render = function(p13, p23) --[[ render | Line: 569 | Upvalues: CollectionService (ref) ]]
				CollectionService:AddTag(p23, "DivingBoard")
			end
		}
	end
end

local function SNOWMAN() --[[ SNOWMAN | Line: 576 | Upvalues: SharedConstants (copy), Sift (copy), CollectionService (copy), ReplicatedStorage (copy) ]]
	return function() --[[ Line: 577 | Upvalues: SharedConstants (ref), Sift (ref), CollectionService (ref), ReplicatedStorage (ref) ]]
		return {
			ailment_to_boost = { "snowman", SharedConstants.full_snowman_duration },
			init = function(p13) --[[ init | Line: 580 | Upvalues: Sift (ref) ]]
				local Snowmen = workspace.StaticMap:FindFirstChild("Snowmen")

				if not Snowmen then
					local Snowmen2 = Instance.new("Folder")

					Snowmen2.Name = "Snowmen"
					Snowmen2.Parent = workspace.StaticMap
					Snowmen = Snowmen2
				end

				if Sift.List.some(Snowmen:GetChildren(), function(p1) --[[ Line: 587 | Upvalues: p13 (copy) ]]
					return p1.CFrame == p13.cframe
				end) then
					return
				end

				local Snowman = Instance.new("Part")

				Snowman.Name = "Snowman"
				Snowman.CFrame = p13.cframe
				Snowman.CollisionGroup = "no_collisions"
				Snowman.CanCollide = false
				Snowman.CanTouch = false
				Snowman.CanQuery = false
				Snowman.Anchored = true
				Snowman.Transparency = 1
				Snowman.Size = Vector3.new(1, 1, 1)
				Snowman:AddTag("SnowmanServer")
				Snowman.Parent = Snowmen
			end,
			render = function(p13, p23) --[[ render | Line: 605 | Upvalues: CollectionService (ref), ReplicatedStorage (ref) ]]
				CollectionService:AddTag(p23, "Snowman")

				local AilmentsClient = require(ReplicatedStorage.new.modules.Ailments.AilmentsClient)
				local EquippedPets = require(ReplicatedStorage.SharedModules.EquippedPets)
				local SnowmanFurnitureController = require(ReplicatedStorage.SharedModules.ContentPacks.WeatherAilments2026.SnowmanFurnitureController)

				local function create_trail(p13) --[[ create_trail | Line: 612 ]]
					local Attachment0 = Instance.new("Attachment")

					Attachment0.Name = "Attachment0"
					Attachment0.Parent = p13.PrimaryPart
					Attachment0.CFrame = CFrame.new(0, 0.5, 0)

					local Attachment1 = Instance.new("Attachment")

					Attachment1.Name = "Attachment1"
					Attachment1.Parent = p13.PrimaryPart
					Attachment1.CFrame = CFrame.new(0, -0.5, 0)

					local v1 = game.ReplicatedStorage.Resources.Effects:FindFirstChild("ProjectileTrail"):Clone()

					v1.Attachment0 = Attachment0
					v1.Attachment1 = Attachment1
					v1.Parent = p13.PrimaryPart
				end

				for v1, v2 in p23:FindFirstChild("Snowman").Assembled:GetChildren() do
					if v2:IsA("Model") and v2.PrimaryPart then
						create_trail(v2)
					end
				end

				for v3, v4 in p23:FindFirstChild("Snowman").Disassembled:GetChildren() do
					if v4:IsA("Model") and v4.PrimaryPart then
						create_trail(v4)
					end
				end

				SnowmanFurnitureController.register(p23)

				local function has_any_snowman_ailment() --[[ has_any_snowman_ailment | Line: 643 | Upvalues: EquippedPets (copy), AilmentsClient (copy) ]]
					local v1 = EquippedPets.get_controlled_char_wrappers()

					if not v1 then
						return false
					end

					for v2, v3 in v1 do
						for v4, v5 in AilmentsClient.get_ailments_for_pet(v3) do
							if v5.kind == "snowman" and v5:get_progress() > 0 then
								return true
							end
						end
					end

					return false
				end

				local v5 = AilmentsClient.get_ailment_completed_signal():Connect(function(p13) --[[ Line: 658 | Upvalues: SnowmanFurnitureController (copy), p23 (copy), has_any_snowman_ailment (copy) ]]
					if p13.kind ~= "snowman" then
						return
					end

					SnowmanFurnitureController.lock(p23)

					if has_any_snowman_ailment() then
						return
					end

					SnowmanFurnitureController.begin_revert(p23)
				end)
				local v6 = AilmentsClient.get_changed_signal():Connect(function(p13) --[[ Line: 668 | Upvalues: AilmentsClient (copy), SnowmanFurnitureController (copy), p23 (copy), has_any_snowman_ailment (copy) ]]
					if not AilmentsClient.is_relevant_to_local_ailments(p13) then
						return
					end

					if SnowmanFurnitureController.is_locked(p23) then
						if has_any_snowman_ailment() then
							return
						end

						SnowmanFurnitureController.begin_revert(p23)
					else
						if has_any_snowman_ailment() then
							return
						end

						SnowmanFurnitureController.reset(p23)
					end
				end)

				p23.Destroying:Once(function() --[[ Line: 683 | Upvalues: v5 (copy), v6 (copy), SnowmanFurnitureController (copy), p23 (copy) ]]
					v5:Disconnect()
					v6:Disconnect()
					SnowmanFurnitureController.unregister(p23)
				end)
			end
		}
	end
end

return EntryHelper.furniture({
	weather_ailments_2026_rain_puddle = {
		name = "Rain Puddle",
		model_name = "WeatherAilments2026RainPuddle",
		behavior = function() --[[ Line: 35 | Upvalues: SharedConstants (copy), Sift (copy), CollectionService (copy) ]]
			return {
				ailment_to_boost = { "rain_puddle", SharedConstants.full_rain_puddle_duration },
				init = function(p13) --[[ init | Line: 38 | Upvalues: Sift (ref) ]]
					local RainPuddles = workspace.StaticMap:FindFirstChild("RainPuddles")

					if not RainPuddles then
						local RainPuddles2 = Instance.new("Folder")

						RainPuddles2.Name = "RainPuddles"
						RainPuddles2.Parent = workspace.StaticMap
						RainPuddles = RainPuddles2
					end

					if Sift.List.some(RainPuddles:GetChildren(), function(p1) --[[ Line: 45 | Upvalues: p13 (copy) ]]
						return p1.CFrame == p13.cframe
					end) then
						return
					end

					local RainPuddle = Instance.new("Part")

					RainPuddle.Name = "RainPuddle"
					RainPuddle.CFrame = p13.cframe
					RainPuddle.CollisionGroup = "no_collisions"
					RainPuddle.CanCollide = false
					RainPuddle.CanTouch = false
					RainPuddle.CanQuery = false
					RainPuddle.Anchored = true
					RainPuddle.Transparency = 1
					RainPuddle.Size = Vector3.new(1, 1, 1)
					RainPuddle:AddTag("RainPuddleServer")
					RainPuddle.Parent = RainPuddles
				end,
				render = function(p13, p23) --[[ render | Line: 63 | Upvalues: CollectionService (ref) ]]
					CollectionService:AddTag(p23, "RainPuddle")
				end
			}
		end
	},
	weather_ailments_2026_leaf_pile_1 = {
		name = "Leaf Pile",
		model_name = "WeatherAilments2026LeafPile1",
		behavior = function() --[[ Line: 105 | Upvalues: SharedConstants (copy), LiveOpsTime (copy), ReplicatedStorage (copy), Promise (copy), t (copy), Resources (copy), leaf_pile_respawn_function (copy), ServerScriptService (copy), Sift (copy), CollectionService (copy) ]]
			return {
				use_id = "leaf_pile",
				caregiver_assist = true,
				exclude_player = true,
				protect_interaction = true,
				ailment_to_boost = { "leaf_pile", nil, 1 / SharedConstants.leaf_pile_uses },
				team_whitelist = { "Pets", "Dolls" },
				use_text = function(p1, p2, p3, p4) --[[ use_text | Line: 114 | Upvalues: LiveOpsTime (ref) ]]
					if p4.props.furniture_data.hide_prompt_because_used then
						return nil
					end

					if LiveOpsTime.now() < (p4.props.furniture_data.respawn_at or 0) then
						return nil
					end

					p4.props.furniture_data.respawn_at = nil

					return "Jump in!"
				end,
				client_use = function(p1, p2, p3, p4, p5, p6) --[[ client_use | Line: 127 | Upvalues: ReplicatedStorage (ref), Promise (ref), t (ref), Resources (ref), leaf_pile_respawn_function (ref) ]]
					local PetEntityManager = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityManager)
					local PetEntityHelper = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityHelper)
					local PetPerformanceName = require(ReplicatedStorage.SharedModules.PetPerformanceName)
					local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
					local v1 = PetEntityManager.get_pet_entity(p4)

					if not v1 then
						return
					end

					if v1.modifier_values_from_performances.dont_allow_sit_states then
						UIManager.apps.HintApp:hint({
							text = "Your pet can\'t use this right now!",
							yields = false
						})
					else
						local v2 = nil

						Promise.race({ Promise.new(function(p1) --[[ Line: 146 | Upvalues: v2 (ref), t (ref) ]]
								v2 = t.AilmentFurnitureUse:on_client_event(p1)
							end), Promise.delay(12) }):andThen(function() --[[ Line: 150 | Upvalues: v2 (ref) ]]
							v2:Disconnect()
						end):expect()
						task.wait()

						local v3 = p6.furniture.Parent

						PetEntityHelper.stage_performance(v1, {
							name = PetPerformanceName.LeafPile,
							options = {
								furniture_folder = v3,
								vfx_model = Resources.LeafPileParticles
							}
						})
						PetEntityHelper.promise_performance_ended(v1, PetPerformanceName.LeafPile):andThen(function() --[[ Line: 165 | Upvalues: leaf_pile_respawn_function (ref), v3 (copy), p6 (copy), t (ref) ]]
							leaf_pile_respawn_function(v3, p6)
							t.AilmentFurnitureDone:fire_server()
						end)
					end
				end,
				server_use = function(p1, p2, p3, p4, p5, p6, p7, p8) --[[ server_use | Line: 170 | Upvalues: ServerScriptService (ref), ReplicatedStorage (ref), Promise (ref), t (ref), SharedConstants (ref) ]]
					local AilmentsServer = require(ServerScriptService.new.modules.Ailments.AilmentsServer)
					local CharacterWrapper = require(ServerScriptService.Modules.Game.CharacterWrapper)
					local PetEntityManagerServer = require(ServerScriptService.Services.Frame_4.Order_03.PetEntitiesServer.PetEntityManagerServer)
					local StreamingHelper = require(ReplicatedStorage.new.modules.StreamingHelper)
					local NotificationManager = require(ServerScriptService.Modules.Game.NotificationManager)
					local v1 = CharacterWrapper.get(p6)

					if not v1 then
						return
					end

					local v2 = PetEntityManagerServer.get_pet_entity(p6)

					if v2 and v2.modifiers.dont_allow_sit_states then
						return
					end

					p2.occupied = p2.occupied or {}

					if not p2.occupied[p7] then
						p2.occupied[p7] = StreamingHelper.as_id(v1.char)
						p3()
						Promise.try(function() --[[ Line: 194 | Upvalues: v1 (copy), p2 (copy), p1 (copy), t (ref), Promise (ref), NotificationManager (copy), AilmentsServer (copy), SharedConstants (ref) ]]
							v1.state_manager:exit_all_states()

							local v12 = v1.state_manager:enter({
								id = "CharacterConnect",
								params = {
									furniture_use_id = "leaf_pile",
									furniture_id = p2.id,
									parent = p1.Character
								}
							})

							if not v12 then
								return
							end

							local v2 = if v1.is_pet then v1:get_property("pet_unique") else nil

							task.wait()
							t.AilmentFurnitureUse:fire_client(p1, nil)

							local v3 = nil
							local v4 = false

							Promise.race({ Promise.new(function(p13) --[[ Line: 216 | Upvalues: v3 (ref), t (ref), p1 (ref), v4 (ref) ]]
									v3 = t.AilmentFurnitureDone:on_server_event(function(p14, p2) --[[ Line: 217 | Upvalues: p1 (ref), v4 (ref), p13 (copy) ]]
										if p14 ~= p1 then
											return
										end

										v4 = true
										p13()
									end)
								end), Promise.delay(12) }):finally(function() --[[ Line: 225 | Upvalues: v12 (copy), v3 (ref), v4 (ref), v2 (copy), NotificationManager (ref), p1 (ref), p2 (ref), AilmentsServer (ref), v1 (ref), SharedConstants (ref) ]]
								v12:exit()
								v3:Disconnect()

								if not v4 then
									return
								end

								if v2 then
									NotificationManager.indicate_event({
										name = "player_interacted_with_pet",
										player = p1,
										options = {
											unique_id = v2,
											furniture_id = p2.id
										}
									})
								end

								AilmentsServer.add_progress(v1, "leaf_pile", 1 / SharedConstants.leaf_pile_uses)
							end)
							v12:yield_until_exit()
						end):catch(function(p1) --[[ Line: 246 ]]
							warn(p1)
						end):await()
						p2.occupied[p7] = nil
					end
				end,
				init = function(p1) --[[ init | Line: 252 | Upvalues: Sift (ref) ]]
					local LeafPiles = workspace.StaticMap:FindFirstChild("LeafPiles")

					if not LeafPiles then
						local LeafPiles2 = Instance.new("Folder")

						LeafPiles2.Name = "LeafPiles"
						LeafPiles2.Parent = workspace.StaticMap
						LeafPiles = LeafPiles2
					end

					if Sift.List.some(LeafPiles:GetChildren(), function(p13) --[[ Line: 259 | Upvalues: p1 (copy) ]]
						return p13.CFrame == p1.cframe
					end) then
						return
					end

					local LeafPile = Instance.new("Part")

					LeafPile.Name = "LeafPile"
					LeafPile.CFrame = p1.cframe
					LeafPile.CollisionGroup = "no_collisions"
					LeafPile.CanCollide = false
					LeafPile.CanTouch = false
					LeafPile.CanQuery = false
					LeafPile.Anchored = true
					LeafPile.Transparency = 1
					LeafPile.Size = Vector3.new(1, 1, 1)
					LeafPile:AddTag("LeafPileServer")
					LeafPile.Parent = LeafPiles
				end,
				render = function(p1, p2, p3, p4) --[[ render | Line: 277 | Upvalues: LiveOpsTime (ref), CollectionService (ref) ]]
					if p4 then
						if p4.respawn_at then
							for v1, v2 in p2:FindFirstChild("Visual"):GetChildren() do
								if v2:IsA("BasePart") then
									v2.Transparency = 1
								end
							end

							p1.respawn_at = p4.respawn_at
						end

						if p4.hide_prompt_because_used then
							p1.hide_prompt_because_used = true
						end
					end

					if p1.respawn_at and not (LiveOpsTime.now() >= p1.respawn_at) then
						return
					end

					CollectionService:AddTag(p2, "LeafPile")
				end
			}
		end
	},
	weather_ailments_2026_leaf_pile_2 = {
		name = "Leaf Pile",
		model_name = "WeatherAilments2026LeafPile2",
		behavior = function() --[[ Line: 105 | Upvalues: SharedConstants (copy), LiveOpsTime (copy), ReplicatedStorage (copy), Promise (copy), t (copy), Resources (copy), leaf_pile_respawn_function (copy), ServerScriptService (copy), Sift (copy), CollectionService (copy) ]]
			return {
				use_id = "leaf_pile",
				caregiver_assist = true,
				exclude_player = true,
				protect_interaction = true,
				ailment_to_boost = { "leaf_pile", nil, 1 / SharedConstants.leaf_pile_uses },
				team_whitelist = { "Pets", "Dolls" },
				use_text = function(p1, p2, p3, p4) --[[ use_text | Line: 114 | Upvalues: LiveOpsTime (ref) ]]
					if p4.props.furniture_data.hide_prompt_because_used then
						return nil
					end

					if LiveOpsTime.now() < (p4.props.furniture_data.respawn_at or 0) then
						return nil
					end

					p4.props.furniture_data.respawn_at = nil

					return "Jump in!"
				end,
				client_use = function(p1, p2, p3, p4, p5, p6) --[[ client_use | Line: 127 | Upvalues: ReplicatedStorage (ref), Promise (ref), t (ref), Resources (ref), leaf_pile_respawn_function (ref) ]]
					local PetEntityManager = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityManager)
					local PetEntityHelper = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityHelper)
					local PetPerformanceName = require(ReplicatedStorage.SharedModules.PetPerformanceName)
					local UIManager = require(ReplicatedStorage.ClientModules.Core.UIManager.UIManager)
					local v1 = PetEntityManager.get_pet_entity(p4)

					if not v1 then
						return
					end

					if v1.modifier_values_from_performances.dont_allow_sit_states then
						UIManager.apps.HintApp:hint({
							text = "Your pet can\'t use this right now!",
							yields = false
						})
					else
						local v2 = nil

						Promise.race({ Promise.new(function(p1) --[[ Line: 146 | Upvalues: v2 (ref), t (ref) ]]
								v2 = t.AilmentFurnitureUse:on_client_event(p1)
							end), Promise.delay(12) }):andThen(function() --[[ Line: 150 | Upvalues: v2 (ref) ]]
							v2:Disconnect()
						end):expect()
						task.wait()

						local v3 = p6.furniture.Parent

						PetEntityHelper.stage_performance(v1, {
							name = PetPerformanceName.LeafPile,
							options = {
								furniture_folder = v3,
								vfx_model = Resources.LeafPileParticles
							}
						})
						PetEntityHelper.promise_performance_ended(v1, PetPerformanceName.LeafPile):andThen(function() --[[ Line: 165 | Upvalues: leaf_pile_respawn_function (ref), v3 (copy), p6 (copy), t (ref) ]]
							leaf_pile_respawn_function(v3, p6)
							t.AilmentFurnitureDone:fire_server()
						end)
					end
				end,
				server_use = function(p1, p2, p3, p4, p5, p6, p7, p8) --[[ server_use | Line: 170 | Upvalues: ServerScriptService (ref), ReplicatedStorage (ref), Promise (ref), t (ref), SharedConstants (ref) ]]
					local AilmentsServer = require(ServerScriptService.new.modules.Ailments.AilmentsServer)
					local CharacterWrapper = require(ServerScriptService.Modules.Game.CharacterWrapper)
					local PetEntityManagerServer = require(ServerScriptService.Services.Frame_4.Order_03.PetEntitiesServer.PetEntityManagerServer)
					local StreamingHelper = require(ReplicatedStorage.new.modules.StreamingHelper)
					local NotificationManager = require(ServerScriptService.Modules.Game.NotificationManager)
					local v1 = CharacterWrapper.get(p6)

					if not v1 then
						return
					end

					local v2 = PetEntityManagerServer.get_pet_entity(p6)

					if v2 and v2.modifiers.dont_allow_sit_states then
						return
					end

					p2.occupied = p2.occupied or {}

					if not p2.occupied[p7] then
						p2.occupied[p7] = StreamingHelper.as_id(v1.char)
						p3()
						Promise.try(function() --[[ Line: 194 | Upvalues: v1 (copy), p2 (copy), p1 (copy), t (ref), Promise (ref), NotificationManager (copy), AilmentsServer (copy), SharedConstants (ref) ]]
							v1.state_manager:exit_all_states()

							local v12 = v1.state_manager:enter({
								id = "CharacterConnect",
								params = {
									furniture_use_id = "leaf_pile",
									furniture_id = p2.id,
									parent = p1.Character
								}
							})

							if not v12 then
								return
							end

							local v2 = if v1.is_pet then v1:get_property("pet_unique") else nil

							task.wait()
							t.AilmentFurnitureUse:fire_client(p1, nil)

							local v3 = nil
							local v4 = false

							Promise.race({ Promise.new(function(p13) --[[ Line: 216 | Upvalues: v3 (ref), t (ref), p1 (ref), v4 (ref) ]]
									v3 = t.AilmentFurnitureDone:on_server_event(function(p14, p2) --[[ Line: 217 | Upvalues: p1 (ref), v4 (ref), p13 (copy) ]]
										if p14 ~= p1 then
											return
										end

										v4 = true
										p13()
									end)
								end), Promise.delay(12) }):finally(function() --[[ Line: 225 | Upvalues: v12 (copy), v3 (ref), v4 (ref), v2 (copy), NotificationManager (ref), p1 (ref), p2 (ref), AilmentsServer (ref), v1 (ref), SharedConstants (ref) ]]
								v12:exit()
								v3:Disconnect()

								if not v4 then
									return
								end

								if v2 then
									NotificationManager.indicate_event({
										name = "player_interacted_with_pet",
										player = p1,
										options = {
											unique_id = v2,
											furniture_id = p2.id
										}
									})
								end

								AilmentsServer.add_progress(v1, "leaf_pile", 1 / SharedConstants.leaf_pile_uses)
							end)
							v12:yield_until_exit()
						end):catch(function(p1) --[[ Line: 246 ]]
							warn(p1)
						end):await()
						p2.occupied[p7] = nil
					end
				end,
				init = function(p1) --[[ init | Line: 252 | Upvalues: Sift (ref) ]]
					local LeafPiles = workspace.StaticMap:FindFirstChild("LeafPiles")

					if not LeafPiles then
						local LeafPiles2 = Instance.new("Folder")

						LeafPiles2.Name = "LeafPiles"
						LeafPiles2.Parent = workspace.StaticMap
						LeafPiles = LeafPiles2
					end

					if Sift.List.some(LeafPiles:GetChildren(), function(p13) --[[ Line: 259 | Upvalues: p1 (copy) ]]
						return p13.CFrame == p1.cframe
					end) then
						return
					end

					local LeafPile = Instance.new("Part")

					LeafPile.Name = "LeafPile"
					LeafPile.CFrame = p1.cframe
					LeafPile.CollisionGroup = "no_collisions"
					LeafPile.CanCollide = false
					LeafPile.CanTouch = false
					LeafPile.CanQuery = false
					LeafPile.Anchored = true
					LeafPile.Transparency = 1
					LeafPile.Size = Vector3.new(1, 1, 1)
					LeafPile:AddTag("LeafPileServer")
					LeafPile.Parent = LeafPiles
				end,
				render = function(p1, p2, p3, p4) --[[ render | Line: 277 | Upvalues: LiveOpsTime (ref), CollectionService (ref) ]]
					if p4 then
						if p4.respawn_at then
							for v1, v2 in p2:FindFirstChild("Visual"):GetChildren() do
								if v2:IsA("BasePart") then
									v2.Transparency = 1
								end
							end

							p1.respawn_at = p4.respawn_at
						end

						if p4.hide_prompt_because_used then
							p1.hide_prompt_because_used = true
						end
					end

					if p1.respawn_at and not (LiveOpsTime.now() >= p1.respawn_at) then
						return
					end

					CollectionService:AddTag(p2, "LeafPile")
				end
			}
		end
	},
	weather_ailments_2026_diving_boards = {
		name = "Diving Boards",
		model_name = "WeatherAilments2026DivingBoards",
		behavior = function() --[[ Line: 306 | Upvalues: SharedConstants (copy), LiveOpsTime (copy), ReplicatedStorage (copy), Promise (copy), t (copy), GameplayFX (copy), TweenPromise (copy), v1 (copy), SoundPlayer (copy), CollectionService (copy), ServerScriptService (copy), Sift (copy) ]]
			return {
				use_id = "diving_board",
				protect_interaction = true,
				ailment_to_boost = { "diving_board", nil, 1 / SharedConstants.diving_board_uses },
				use_text = function(p13, p23, p33, p43) --[[ use_text | Line: 311 | Upvalues: LiveOpsTime (ref), SharedConstants (ref) ]]
					local v1 = LiveOpsTime.now()

					if not p43.used_at then
						return "Dive!"
					end

					if v1 - p43.used_at < SharedConstants.diving_board_cooldown then
						return nil
					end

					p43.used_at = nil

					return "Dive!"
				end,
				client_use = function(p13, p23, p33, p43, p53, p63) --[[ client_use | Line: 322 | Upvalues: ReplicatedStorage (ref), Promise (ref), t (ref), GameplayFX (ref), TweenPromise (ref), v1 (ref), SoundPlayer (ref), LiveOpsTime (ref), CollectionService (ref), SharedConstants (ref) ]]
					local ControlsDisabler = require(ReplicatedStorage.ClientModules.Game.ControlsDisabler)
					local RouterClient = require(ReplicatedStorage.ClientModules.Core.RouterClient.RouterClient)
					local v12 = p33.Parent
					local Character = game.Players.LocalPlayer.Character
					local v2 = Character and Character:FindFirstChild("HumanoidRootPart")

					if not v2 then
						return
					end

					local v3 = nil

					Promise.race({ Promise.new(function(p13) --[[ Line: 334 | Upvalues: v3 (ref), t (ref) ]]
							v3 = t.AilmentFurnitureUse:on_client_event(p13)
						end), Promise.delay(12) }):andThen(function() --[[ Line: 338 | Upvalues: v3 (ref) ]]
						v3:Disconnect()
					end):expect()
					task.wait()
					RouterClient.get("InteractablesAPI/DisableInteractionWithMe"):FireServer(true)
					ControlsDisabler.disable_controls("DivingBoard")
					task.delay(5, function() --[[ Line: 347 | Upvalues: RouterClient (copy), ControlsDisabler (copy) ]]
						RouterClient.get("InteractablesAPI/DisableInteractionWithMe"):FireServer(false)
						ControlsDisabler.enable_controls("DivingBoard")
					end)

					local PlayerTarget = v12:GetChildren()[1]:FindFirstChild("PlayerTarget")

					v2.CFrame = PlayerTarget.CFrame
					GameplayFX.emit_poof(PlayerTarget.Position)

					local function player_actions_callback() --[[ player_actions_callback | Line: 356 | Upvalues: Character (copy), ReplicatedStorage (ref), v12 (copy), Promise (ref), TweenPromise (ref), v1 (ref), v2 (copy), SoundPlayer (ref), RouterClient (copy), ControlsDisabler (copy) ]]
						local v13 = Character and Character:FindFirstChildOfClass("Humanoid")

						if not v13 then
							return
						end

						local v22 = v13:LoadAnimation((require(ReplicatedStorage.ClientDB.AnimationManager).get_track("IceSkatingJump")))
						local PetPlatform = v12:GetChildren()[1]:FindFirstChild("PetPlatform")
						local PlayerPlatform = v12:GetChildren()[1]:FindFirstChild("PlayerPlatform")

						Promise.all({ TweenPromise.new(PetPlatform.PrimaryPart, v1, {
								CFrame = PetPlatform.PrimaryPart.CFrame * CFrame.Angles(-0.5235987755982988, 0, 0)
							}), TweenPromise.new(PlayerPlatform.PrimaryPart, v1, {
								CFrame = PlayerPlatform.PrimaryPart.CFrame * CFrame.Angles(-0.5235987755982988, 0, 0)
							}) }):andThen(function() --[[ Line: 374 | Upvalues: v13 (copy), v2 (ref), SoundPlayer (ref), v22 (copy), RouterClient (ref), ControlsDisabler (ref) ]]
							v13.Jump = true
							v2:ApplyImpulse(Vector3.new(v2.CFrame.LookVector.X, 1, v2.CFrame.LookVector.Z) * v2.AssemblyMass * 42.5)
							SoundPlayer.FX:play("DivingBoardPlayerJump")

							local v23 = nil

							v23 = v13.StateChanged:Connect(function(p13, p23) --[[ Line: 382 | Upvalues: SoundPlayer (ref), v23 (ref) ]]
								if p23 ~= Enum.HumanoidStateType.Swimming then
									return
								end

								SoundPlayer.FX:play("DivingBoardPlayerSplash")
								v23:Disconnect()
							end)
							task.delay(5, function() --[[ Line: 390 | Upvalues: v23 (ref) ]]
								if not v23 then
									return
								end

								v23:Disconnect()
							end)
							v22:Play()
							task.delay(3, function() --[[ Line: 399 | Upvalues: v22 (ref) ]]
								v22:Stop()
								v22:Destroy()
							end)
							task.delay(1, function() --[[ Line: 404 | Upvalues: RouterClient (ref), ControlsDisabler (ref) ]]
								RouterClient.get("InteractablesAPI/DisableInteractionWithMe"):FireServer(false)
								ControlsDisabler.enable_controls("DivingBoard")
							end)
						end)
					end

					local PetEntityManager = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityManager)
					local PetEntityHelper = require(ReplicatedStorage.ClientModules.Game.PetEntities.PetEntityHelper)
					local PetPerformanceName = require(ReplicatedStorage.SharedModules.PetPerformanceName)
					local CharWrapperClient = require(ReplicatedStorage.ClientModules.Game.CharWrapperClient)
					local count2 = 0
					local t2 = {}

					for v4, v5 in require(ReplicatedStorage.SharedModules.EquippedPets).get_controlled_char_wrappers() do
						if CharWrapperClient.is_in_same_location(CharWrapperClient.get(Character), v5) then
							p63.used_at = LiveOpsTime.now()

							local t3 = {
								furniture_folder = v12,
								delay = count2
							}

							if count2 == 0 then
								t3.player_actions_callback = player_actions_callback
							end

							local v6 = PetEntityManager.get_pet_entity(v5.char)

							PetEntityHelper.stage_performance(v6, {
								name = PetPerformanceName.DivingBoard,
								options = t3
							})
							table.insert(t2, PetEntityHelper.promise_performance_ended(v6, PetPerformanceName.DivingBoard))
							count2 = count2 + 1
						end
					end

					CollectionService:RemoveTag(p33, "DivingBoard")
					LiveOpsTime.delay_until(LiveOpsTime.now() + SharedConstants.diving_board_cooldown):andThen(function() --[[ Line: 449 | Upvalues: v12 (copy), CollectionService (ref) ]]
						local v1 = v12:GetChildren()[1]

						if not v1 then
							return
						end

						CollectionService:AddTag(v1, "DivingBoard")
					end)

					if count2 == 0 then
						player_actions_callback()
						t.AilmentFurnitureDone:fire_server()
					else
						Promise.all(t2):finally(function() --[[ Line: 461 | Upvalues: t (ref) ]]
							t.AilmentFurnitureDone:fire_server()
						end)
					end
				end,
				server_use = function(p13, p23, p33, p43, p53, p63, p73, p83) --[[ server_use | Line: 466 | Upvalues: ServerScriptService (ref), ReplicatedStorage (ref), t (ref), Promise (ref), SharedConstants (ref) ]]
					local AilmentsServer = require(ServerScriptService.new.modules.Ailments.AilmentsServer)
					local EquippedPets = require(ReplicatedStorage.SharedModules.EquippedPets)
					local CharacterWrapper = require(ServerScriptService.Modules.Game.CharacterWrapper)
					local NotificationManager = require(ServerScriptService.Modules.Game.NotificationManager)
					local v1 = CharacterWrapper.get(p63)
					local state_manager = v1.state_manager

					state_manager:exit_all_states()

					if v1:get_team() == "Parents" then
						state_manager:lock()
					end

					local v2 = EquippedPets.get_controlled_char_wrappers(p13)
					local t2 = {}

					for v3, v4 in v2 do
						if v4:is_valid() and v4.is_pet then
							v4.state_manager:exit_all_states()
							v4:set_property("entity_controller", p13)

							local v5 = v4.state_manager:enter({
								id = "CharacterConnect",
								params = {
									furniture_use_id = "diving_board",
									furniture_id = p23.id,
									parent = p13.Character
								}
							})

							if v5 then
								table.insert(t2, v5)
							end
						end
					end

					task.wait()
					t.AilmentFurnitureUse:fire_client(p13, nil)

					local v6 = nil
					local v7 = false

					Promise.race({ Promise.new(function(p1) --[[ Line: 507 | Upvalues: v6 (ref), t (ref), p13 (copy), v7 (ref) ]]
							v6 = t.AilmentFurnitureDone:on_server_event(function(p12, p23) --[[ Line: 508 | Upvalues: p13 (ref), v7 (ref), p1 (copy) ]]
								if p12 ~= p13 then
									return
								end

								v7 = true
								p1()
							end)
						end), Promise.delay(12) }):finally(function() --[[ Line: 516 | Upvalues: t2 (copy), state_manager (copy), v6 (ref), v7 (ref), v2 (copy), NotificationManager (copy), p13 (copy), p23 (copy), AilmentsServer (copy), SharedConstants (ref) ]]
						for v1, v22 in t2 do
							v22:exit()
						end

						state_manager:unlock()
						v6:Disconnect()

						if not v7 then
							return
						end

						for v3, v4 in v2 do
							if v4:is_valid() and v4.is_pet then
								local v5 = v4:get_property("pet_unique")

								if v5 then
									NotificationManager.indicate_event({
										name = "player_interacted_with_pet",
										player = p13,
										options = {
											unique_id = v5,
											furniture_id = p23.id
										}
									})
								end

								AilmentsServer.add_progress(v4, "diving_board", 1 / SharedConstants.diving_board_uses)
							end
						end
					end):await()
				end,
				init = function(p13) --[[ init | Line: 544 | Upvalues: Sift (ref) ]]
					local DivingBoards = workspace.StaticMap:FindFirstChild("DivingBoards")

					if not DivingBoards then
						local DivingBoards2 = Instance.new("Folder")

						DivingBoards2.Name = "DivingBoards"
						DivingBoards2.Parent = workspace.StaticMap
						DivingBoards = DivingBoards2
					end

					if Sift.List.some(DivingBoards:GetChildren(), function(p1) --[[ Line: 551 | Upvalues: p13 (copy) ]]
						return p1.CFrame == p13.cframe
					end) then
						return
					end

					local DivingBoard = Instance.new("Part")

					DivingBoard.Name = "DivingBoard"
					DivingBoard.CFrame = p13.cframe
					DivingBoard.CollisionGroup = "no_collisions"
					DivingBoard.CanCollide = false
					DivingBoard.CanTouch = false
					DivingBoard.CanQuery = false
					DivingBoard.Anchored = true
					DivingBoard.Transparency = 1
					DivingBoard.Size = Vector3.new(1, 1, 1)
					DivingBoard:AddTag("DivingBoardServer")
					DivingBoard.Parent = DivingBoards
				end,
				render = function(p13, p23) --[[ render | Line: 569 | Upvalues: CollectionService (ref) ]]
					CollectionService:AddTag(p23, "DivingBoard")
				end
			}
		end
	},
	weather_ailments_2026_snowman = {
		name = "Snowman",
		model_name = "WeatherAilments2026Snowman",
		behavior = function() --[[ Line: 577 | Upvalues: SharedConstants (copy), Sift (copy), CollectionService (copy), ReplicatedStorage (copy) ]]
			return {
				ailment_to_boost = { "snowman", SharedConstants.full_snowman_duration },
				init = function(p13) --[[ init | Line: 580 | Upvalues: Sift (ref) ]]
					local Snowmen = workspace.StaticMap:FindFirstChild("Snowmen")

					if not Snowmen then
						local Snowmen2 = Instance.new("Folder")

						Snowmen2.Name = "Snowmen"
						Snowmen2.Parent = workspace.StaticMap
						Snowmen = Snowmen2
					end

					if Sift.List.some(Snowmen:GetChildren(), function(p1) --[[ Line: 587 | Upvalues: p13 (copy) ]]
						return p1.CFrame == p13.cframe
					end) then
						return
					end

					local Snowman = Instance.new("Part")

					Snowman.Name = "Snowman"
					Snowman.CFrame = p13.cframe
					Snowman.CollisionGroup = "no_collisions"
					Snowman.CanCollide = false
					Snowman.CanTouch = false
					Snowman.CanQuery = false
					Snowman.Anchored = true
					Snowman.Transparency = 1
					Snowman.Size = Vector3.new(1, 1, 1)
					Snowman:AddTag("SnowmanServer")
					Snowman.Parent = Snowmen
				end,
				render = function(p13, p23) --[[ render | Line: 605 | Upvalues: CollectionService (ref), ReplicatedStorage (ref) ]]
					CollectionService:AddTag(p23, "Snowman")

					local AilmentsClient = require(ReplicatedStorage.new.modules.Ailments.AilmentsClient)
					local EquippedPets = require(ReplicatedStorage.SharedModules.EquippedPets)
					local SnowmanFurnitureController = require(ReplicatedStorage.SharedModules.ContentPacks.WeatherAilments2026.SnowmanFurnitureController)

					local function create_trail(p13) --[[ create_trail | Line: 612 ]]
						local Attachment0 = Instance.new("Attachment")

						Attachment0.Name = "Attachment0"
						Attachment0.Parent = p13.PrimaryPart
						Attachment0.CFrame = CFrame.new(0, 0.5, 0)

						local Attachment1 = Instance.new("Attachment")

						Attachment1.Name = "Attachment1"
						Attachment1.Parent = p13.PrimaryPart
						Attachment1.CFrame = CFrame.new(0, -0.5, 0)

						local v1 = game.ReplicatedStorage.Resources.Effects:FindFirstChild("ProjectileTrail"):Clone()

						v1.Attachment0 = Attachment0
						v1.Attachment1 = Attachment1
						v1.Parent = p13.PrimaryPart
					end

					for v1, v2 in p23:FindFirstChild("Snowman").Assembled:GetChildren() do
						if v2:IsA("Model") and v2.PrimaryPart then
							create_trail(v2)
						end
					end

					for v3, v4 in p23:FindFirstChild("Snowman").Disassembled:GetChildren() do
						if v4:IsA("Model") and v4.PrimaryPart then
							create_trail(v4)
						end
					end

					SnowmanFurnitureController.register(p23)

					local function has_any_snowman_ailment() --[[ has_any_snowman_ailment | Line: 643 | Upvalues: EquippedPets (copy), AilmentsClient (copy) ]]
						local v1 = EquippedPets.get_controlled_char_wrappers()

						if not v1 then
							return false
						end

						for v2, v3 in v1 do
							for v4, v5 in AilmentsClient.get_ailments_for_pet(v3) do
								if v5.kind == "snowman" and v5:get_progress() > 0 then
									return true
								end
							end
						end

						return false
					end

					local v5 = AilmentsClient.get_ailment_completed_signal():Connect(function(p13) --[[ Line: 658 | Upvalues: SnowmanFurnitureController (copy), p23 (copy), has_any_snowman_ailment (copy) ]]
						if p13.kind ~= "snowman" then
							return
						end

						SnowmanFurnitureController.lock(p23)

						if has_any_snowman_ailment() then
							return
						end

						SnowmanFurnitureController.begin_revert(p23)
					end)
					local v6 = AilmentsClient.get_changed_signal():Connect(function(p13) --[[ Line: 668 | Upvalues: AilmentsClient (copy), SnowmanFurnitureController (copy), p23 (copy), has_any_snowman_ailment (copy) ]]
						if not AilmentsClient.is_relevant_to_local_ailments(p13) then
							return
						end

						if SnowmanFurnitureController.is_locked(p23) then
							if has_any_snowman_ailment() then
								return
							end

							SnowmanFurnitureController.begin_revert(p23)
						else
							if has_any_snowman_ailment() then
								return
							end

							SnowmanFurnitureController.reset(p23)
						end
					end)

					p23.Destroying:Once(function() --[[ Line: 683 | Upvalues: v5 (copy), v6 (copy), SnowmanFurnitureController (copy), p23 (copy) ]]
						v5:Disconnect()
						v6:Disconnect()
						SnowmanFurnitureController.unregister(p23)
					end)
				end
			}
		end
	}
})