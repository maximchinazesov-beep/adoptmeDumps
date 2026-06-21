-- https://lua.expert/
local ClientData = require(game.ReplicatedStorage.ClientModules.Core.ClientData)
local CloudValues = require(game.ReplicatedStorage.ClientModules.CloudValues)
local FishDB = require(script.Parent.DB.FishDB)
local FishingAnims = require(script.Parent.FishingAnims)
local FishingRodDB = require(script.Parent.DB.FishingRodDB)
local FishingNetService = require(script.Parent.FishingNetService)
local FishingReactionTime = require(script.Parent.FishingReactionTime)
local FishingRodState = require(script.Parent.FishingRodState)
local KindDB = require(game.ReplicatedStorage.ClientDB.Inventory.KindDB)
local LiveOpsTime = require(game.ReplicatedStorage.SharedModules.Game.LiveOpsTime)
local Promise = require(game.ReplicatedStorage.SharedPackages.Promise)
local RepeatPromise = require(game.ReplicatedStorage.SharedModules.RepeatPromise)
local SoundPlayer = require(game.ReplicatedStorage.SharedModules.SoundPlayer)
local StateMachinePromise = require(game.ReplicatedStorage.new.modules.StateMachinePromise)
local TweenPromise = require(game.ReplicatedStorage.SharedModules.TweenPromise)
local UIManager = require(game.ReplicatedStorage.ClientModules.Core.UIManager.UIManager)

return {
	new = function(p1, p2, p3, p4, p5) --[[ new | Line: 27 | Upvalues: FishDB (copy), FishingAnims (copy), StateMachinePromise (copy), Promise (copy), RepeatPromise (copy), TweenPromise (copy), LiveOpsTime (copy), FishingRodState (copy), ClientData (copy), KindDB (copy), UIManager (copy), FishingRodDB (copy), SoundPlayer (copy), FishingReactionTime (copy), CloudValues (copy), FishingNetService (copy) ]]
		local Position = p5.Position
		local v1 = p5.Size * Vector3.new(1, 0, 1)
		local v2 = Random.new()
		local v3 = FishDB.get(p3)
		local X = v1.X
		local Z = v1.Z
		local v4 = Position.X - X / 2
		local v5 = v4 + X
		local v6 = Position.Z - Z / 2
		local v7 = v6 + Z
		local v8 = nil
		local Animator = p4:FindFirstChild("AnimationController"):FindFirstChild("Animator")
		local v9 = 0.3 + v2:NextNumber() * 0.25

		local function animate(p1) --[[ animate | Line: 43 | Upvalues: v8 (ref), FishingAnims (ref), Animator (copy), p3 (copy) ]]
			if v8 then
				v8:Stop()
				v8 = nil
			end

			v8 = FishingAnims.play_fish_anim(Animator, p3, p1, true)
		end

		return StateMachinePromise.new({
			swim = {
				enter = function(p12) --[[ enter | Line: 53 | Upvalues: Promise (ref), RepeatPromise (ref), v2 (copy), p4 (copy), v4 (copy), v5 (copy), v6 (copy), v7 (copy), X (copy), Z (copy), Position (copy), v8 (ref), FishingAnims (ref), Animator (copy), p3 (copy), v9 (copy), TweenPromise (ref), LiveOpsTime (ref), FishingRodState (ref), v3 (copy), ClientData (ref), p1 (copy), p2 (copy), KindDB (ref), UIManager (ref) ]]
					return Promise.any({ RepeatPromise.new(function() --[[ Line: 55 | Upvalues: v2 (ref), p4 (ref), v4 (ref), v5 (ref), v6 (ref), v7 (ref), X (ref), Z (ref), Position (ref), v8 (ref), FishingAnims (ref), Animator (ref), p3 (ref), v9 (ref), TweenPromise (ref), LiveOpsTime (ref), Promise (ref), FishingRodState (ref) ]]
							local v1 = 1 + v2:NextNumber() * 1.5
							local v22 = v2:NextNumber() * 55
							local v3 = math.max(15, v22)
							local v42 = v2:NextNumber() * 15
							local v52 = math.max(3, v42)

							if v2:NextNumber() > 0.5 then
								v3 = v3 * -1
							end

							p4:PivotTo(p4.PrimaryPart.CFrame * CFrame.Angles(0, math.rad(v3), 0))

							local v62 = p4.PrimaryPart.CFrame * CFrame.new(0, 0, -v52)
							local Position2 = v62.Position
							local v72 = if v4 < Position2.X then if Position2.X < v5 then true else false else false

							if not (v72 and (if v6 < Position2.Z then Position2.Z < v7 else false)) then
								local v11 = Vector3.new(v4 + v2:NextNumber() * X, Position.Y, v6 + v2:NextNumber() * Z)

								p4:PivotTo((CFrame.lookAt(p4.PrimaryPart.Position, v11)))
								v62 = p4.PrimaryPart.CFrame * CFrame.new(0, 0, -math.min(v52, (p4.PrimaryPart.Position - v11).Magnitude))
							end

							local v13

							if not v8 then
								v8 = FishingAnims.play_fish_anim(Animator, p3, "swim", true)
								v8.TimePosition = v2:NextNumber() * v8.Length
								v8:AdjustSpeed(v9)
								v13 = p4.PrimaryPart.CFrame

								return TweenPromise.callback(0, 1, TweenInfo.new(v1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), function(p13) --[[ Line: 86 | Upvalues: p4 (ref), v13 (copy), v62 (ref), v8 (ref), v9 (ref) ]]
									p4:PivotTo(v13:Lerp(v62, p13))
									v8:AdjustSpeed((math.lerp(2, v9, p13)))
								end):andThen(function() --[[ Line: 89 | Upvalues: v2 (ref), LiveOpsTime (ref), Promise (ref), FishingRodState (ref) ]]
									local v22 = math.max(2, v2:NextNumber() * 10)
									local v3 = LiveOpsTime.now() + v22

									return Promise.new(function(p13, p23, p33) --[[ Line: 94 | Upvalues: FishingRodState (ref), v3 (ref), LiveOpsTime (ref) ]]
										while not p33() do
											local v1 = FishingRodState:get_current_state()

											if v1 == "casting" or v1 == "charging" then
												v3 = v3 + 0.1
												task.wait(0.1)
											else
												if v3 < LiveOpsTime.now() then
													p13()

													return
												end

												task.wait()
											end
										end
									end)
								end)
							end

							v8:Stop()
							v8 = nil
							v8 = FishingAnims.play_fish_anim(Animator, p3, "swim", true)
							v8.TimePosition = v2:NextNumber() * v8.Length
							v8:AdjustSpeed(v9)
							v13 = p4.PrimaryPart.CFrame

							return TweenPromise.callback(0, 1, TweenInfo.new(v1, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), function(p13) --[[ Line: 86 | Upvalues: p4 (ref), v13 (copy), v62 (ref), v8 (ref), v9 (ref) ]]
								p4:PivotTo(v13:Lerp(v62, p13))
								v8:AdjustSpeed((math.lerp(2, v9, p13)))
							end):andThen(function() --[[ Line: 89 | Upvalues: v2 (ref), LiveOpsTime (ref), Promise (ref), FishingRodState (ref) ]]
								local v22 = math.max(2, v2:NextNumber() * 10)
								local v3 = LiveOpsTime.now() + v22

								return Promise.new(function(p13, p23, p33) --[[ Line: 94 | Upvalues: FishingRodState (ref), v3 (ref), LiveOpsTime (ref) ]]
									while not p33() do
										local v1 = FishingRodState:get_current_state()

										if v1 == "casting" or v1 == "charging" then
											v3 = v3 + 0.1
											task.wait(0.1)
										else
											if v3 < LiveOpsTime.now() then
												p13()

												return
											end

											task.wait()
										end
									end
								end)
							end)
						end), Promise.new(function(p13, p22, p3) --[[ Line: 110 | Upvalues: FishingRodState (ref), p4 (ref), v3 (ref), ClientData (ref), p1 (ref), p2 (ref), p12 (copy), KindDB (ref), UIManager (ref) ]]
							while not p3() do
								local v1, v2 = FishingRodState:get_values("bobber", "fish_unique")

								if FishingRodState:get_current_state() == "waiting" and (v1 and not v2) then
									local v32 = p4.PrimaryPart.CFrame
									local v4 = v1.PrimaryPart.CFrame
									local v8 = math.abs((math.acos((math.clamp(v32.LookVector:Dot((v4.Position - v32.Position).Unit), -1, 1)))))

									if (v32.Position - v4.Position).Magnitude <= v3.sight_distance and v8 <= math.rad(v3.sight_fov) / 2 then
										local v12 = nil

										for v13, v14 in (ClientData.get("inventory") or {}).gifts or {} do
											if v14.kind == v3.bait then
												v12 = v14

												break
											end
										end

										if v12 then
											FishingRodState:set_values({
												hotspot_kind = p1,
												fish_unique = p2
											})
											p12:enter_state("approach_bobber")

											return
										end

										UIManager.apps.SpeechBubbleApp:create(p4.PrimaryPart, ("Ew! I want %*!"):format(KindDB[v3.bait].name), {
											always_on_top = true,
											length = 5
										})
										task.wait(10)
									end
								end

								task.wait(0.1)
							end
						end) })
				end
			},
			approach_bobber = {
				can_enter = function(p1) --[[ can_enter | Line: 159 | Upvalues: FishingRodState (ref), p2 (copy) ]]
					local v1 = FishingRodState:get_value("bobber")

					return if p1:get_current_state() == "swim" and v1 ~= nil then FishingRodState:get_value("fish_unique") == p2 else false
				end,
				enter = function(p1) --[[ enter | Line: 163 | Upvalues: FishingRodState (ref), p4 (copy), FishingRodDB (ref), FishDB (ref), p3 (copy), v2 (copy), Promise (ref), TweenPromise (ref), RepeatPromise (ref), v8 (ref), v9 (copy), SoundPlayer (ref), UIManager (ref) ]]
					local Position = FishingRodState:get_value("bobber"):GetBoundingBox().Position
					local v1 = p4.PrimaryPart.CFrame
					local v22 = CFrame.lookAt(v1.Position, Position)
					local v3 = FishingRodState:get_value("rod_kind")
					local v4 = if v3 then FishingRodDB[v3] else v3
					local v7 = v2:NextInteger(1, math.min(0, FishDB.get(p3).tier - (v4 and v4.tier or 0)) + 4)

					FishingRodState:set_value("bobber_approached", true)

					return Promise.any({ TweenPromise.callback(0, 1, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), function(p1) --[[ Line: 176 | Upvalues: p4 (ref), v1 (copy), v22 (copy) ]]
							p4:PivotTo(v1:Lerp(v22, p1))
						end), Promise.fromEvent(FishingRodState.state_changed_signal):andThen(function() --[[ Line: 179 | Upvalues: p1 (copy) ]]
							p1:enter_state("swim")
						end) }):andThen(function() --[[ Line: 182 | Upvalues: Promise (ref), RepeatPromise (ref), p4 (ref), Position (copy), v2 (ref), TweenPromise (ref), v8 (ref), v9 (ref), v7 (ref), p1 (copy), SoundPlayer (ref), FishingRodState (ref), UIManager (ref) ]]
						return Promise.any({ RepeatPromise.new(function() --[[ Line: 184 | Upvalues: p4 (ref), Position (ref), v2 (ref), TweenPromise (ref), v8 (ref), v9 (ref), v7 (ref), p1 (ref), SoundPlayer (ref), Promise (ref) ]]
								local v1 = p4.PrimaryPart.CFrame
								local v22 = v1.Rotation + Position
								local v3 = v22 * CFrame.new(0, 0, v2:NextInteger(5, 8))

								return TweenPromise.callback(0, 1, TweenInfo.new(1.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p1) --[[ Line: 188 | Upvalues: p4 (ref), v1 (copy), v22 (copy), v8 (ref), v9 (ref) ]]
									p4:PivotTo(v1:Lerp(v22, p1))
									v8:AdjustSpeed((math.lerp(2, v9, p1)))
								end):andThen(function() --[[ Line: 191 | Upvalues: v7 (ref), p1 (ref), SoundPlayer (ref), TweenPromise (ref), p4 (ref), v22 (copy), v3 (copy), v8 (ref), v9 (ref), Promise (ref), v2 (ref) ]]
									v7 = v7 - 1

									if v7 == 0 then
										p1:enter_state("bite")

										return
									end

									SoundPlayer.FX:play("FishingFishNibble")

									return TweenPromise.callback(0, 1, TweenInfo.new(0.75, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), function(p1) --[[ Line: 198 | Upvalues: p4 (ref), v22 (ref), v3 (ref), v8 (ref), v9 (ref) ]]
										p4:PivotTo(v22:Lerp(v3, p1))
										v8:AdjustSpeed((math.lerp(2, v9, p1)))
									end):andThen(function() --[[ Line: 201 | Upvalues: Promise (ref), v2 (ref) ]]
										return Promise.delay(v2:NextNumber())
									end)
								end)
							end), Promise.fromEvent(FishingRodState.state_changed_signal):andThen(function() --[[ Line: 206 | Upvalues: FishingRodState (ref), p1 (ref), UIManager (ref) ]]
								if FishingRodState:get_current_state() ~= "hooked" then
									p1:enter_state("despawn", true)
									UIManager.apps.HintApp:hint({
										text = "Too Early! Wait for the fish to Bite.",
										yields = false,
										overridable = true,
										length = 4,
										color = Color3.new(0.933333, 0.776471, 0.266667)
									})
								end
							end) })
					end)
				end
			},
			bite = {
				can_enter = function(p1) --[[ can_enter | Line: 224 | Upvalues: FishingRodState (ref), p2 (copy) ]]
					local v1 = FishingRodState:get_value("bobber")
					local v2 = p1:get_current_state()

					return if (v2 == "approach_bobber" or v2 == "catching") and v1 ~= nil then FishingRodState:get_value("fish_unique") == p2 else false
				end,
				enter = function(p1) --[[ enter | Line: 231 | Upvalues: FishingRodState (ref), FishingRodDB (ref), v3 (copy), FishingReactionTime (ref), p3 (copy), Promise (ref), UIManager (ref), v8 (ref), FishingAnims (ref), Animator (copy), CloudValues (ref) ]]
					local v1 = FishingRodState:get_value("bobber")

					if v1 then
						v1.PrimaryPart.MouthRigidConstraint.Enabled = false
						v1.PrimaryPart.MouthRigidConstraint.Attachment1 = nil
						v1.PrimaryPart.Anchored = true
					end

					local v2 = FishingRodState:get_value("rod_kind")
					local v32 = if v2 then FishingRodDB[v2] else v2
					local v5 = if FishingRodState:get_current_state() == "struggling" then true else false
					local v6 = if v5 then (v32 and v32.tier or 0) < v3.tier else v5
					local v7 = FishingReactionTime.get_adjusted_bite_time(p3, v2, not v5)

					local function start_bite_reaction() --[[ start_bite_reaction | Line: 246 | Upvalues: FishingRodState (ref), v7 (copy), p1 (copy), Promise (ref), UIManager (ref) ]]
						FishingRodState:set_value("bite_reaction_duration", v7)
						FishingRodState:enter_state("hooked", p1)

						return Promise.delay(v7):andThen(function() --[[ Line: 250 | Upvalues: p1 (ref), FishingRodState (ref), UIManager (ref) ]]
							p1:enter_state("despawn", true)

							local v1 = FishingRodState:get_current_state()

							if v1 == "hooked" or (v1 == "struggling" or v1 == "catching") then
								FishingRodState:enter_state("waiting")
							end

							UIManager.apps.HintApp:hint({
								text = "Too Slow! Tap when the fish Bites.",
								yields = false,
								overridable = true,
								length = 4,
								color = Color3.new(0.933333, 0.776471, 0.266667)
							})
						end)
					end

					if not v6 then
						return start_bite_reaction()
					end

					local v82

					if not v8 then
						v82 = FishingAnims.play_fish_anim(Animator, p3, "yank", false)
						v8 = v82

						return Promise.race({ FishingAnims.await_anim(v82), Promise.delay(CloudValues:getValue("fishing", "fishing_yank_preview_duration")) }):andThen(start_bite_reaction)
					end

					v8:Stop()
					v8 = nil
					v82 = FishingAnims.play_fish_anim(Animator, p3, "yank", false)
					v8 = v82

					return Promise.race({ FishingAnims.await_anim(v82), Promise.delay(CloudValues:getValue("fishing", "fishing_yank_preview_duration")) }):andThen(start_bite_reaction)
				end
			},
			catching = {
				can_enter = function(p1) --[[ can_enter | Line: 283 | Upvalues: FishingRodState (ref) ]]
					local v1 = FishingRodState:get_current_state()

					return if p1:get_current_state() == "bite" then if v1 == "catching" then true else v1 == "struggling" else false
				end,
				enter = function(p1) --[[ enter | Line: 287 | Upvalues: FishingRodState (ref), p4 (copy), v8 (ref), FishingAnims (ref), Animator (copy), p3 (copy), Promise (ref) ]]
					local v1 = FishingRodState:get_value("bobber")

					v1.PrimaryPart.MouthRigidConstraint.Attachment1 = p4.RootPart:FindFirstChild("MouthAttachment", true)
					v1.PrimaryPart.MouthRigidConstraint.Enabled = true
					v1.PrimaryPart.Anchored = false

					if not v8 then
						v8 = FishingAnims.play_fish_anim(Animator, p3, "catch", true)

						return Promise.resolve()
					end

					v8:Stop()
					v8 = nil
					v8 = FishingAnims.play_fish_anim(Animator, p3, "catch", true)

					return Promise.resolve()
				end
			},
			despawn = {
				can_enter = function(p1, p2) --[[ can_enter | Line: 297 ]]
					if p2 then
						return true
					end

					local v1 = p1:get_current_state()

					return if v1 == nil then true else v1 == "swim"
				end,
				enter = function(p12, p22) --[[ enter | Line: 304 | Upvalues: FishingNetService (ref), p1 (copy), p2 (copy), SoundPlayer (ref), v2 (copy), v1 (copy), Position (copy), p5 (copy), p4 (copy), TweenPromise (ref) ]]
					local v12, v22, v3, v4, v5, v6, v7

					if not p22 then
						v12 = v2:NextNumber() * v1.X
						v22 = v2:NextNumber() * v1.Z
						v3 = Position - p5.Size / 2 + Vector3.new(v12, 0, v22)
						p4:PivotTo(CFrame.lookAt(p4.PrimaryPart.Position, v3))
						v4 = p4:GetScale()
						v5 = p4.PrimaryPart.CFrame
						v6 = v5.Rotation + v3
						v7 = 0.2 + v2:NextNumber() * 0.5

						return TweenPromise.callback(0, 1, TweenInfo.new(v7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p13) --[[ Line: 318 | Upvalues: p4 (ref), v4 (copy), v5 (copy), v6 (copy) ]]
							p4:ScaleTo((math.lerp(v4, 0.1, p13)))
							p4:PivotTo(v5:Lerp(v6, p13))
						end):andThen(function() --[[ Line: 321 | Upvalues: p12 (copy) ]]
							p12:exit_state()
						end)
					end

					FishingNetService.deplete_fish(p1, p2)
					SoundPlayer.FX:play("FishingFishEscape")
					v12 = v2:NextNumber() * v1.X
					v22 = v2:NextNumber() * v1.Z
					v3 = Position - p5.Size / 2 + Vector3.new(v12, 0, v22)
					p4:PivotTo(CFrame.lookAt(p4.PrimaryPart.Position, v3))
					v4 = p4:GetScale()
					v5 = p4.PrimaryPart.CFrame
					v6 = v5.Rotation + v3
					v7 = 0.2 + v2:NextNumber() * 0.5

					return TweenPromise.callback(0, 1, TweenInfo.new(v7, Enum.EasingStyle.Quad, Enum.EasingDirection.In), function(p13) --[[ Line: 318 | Upvalues: p4 (ref), v4 (copy), v5 (copy), v6 (copy) ]]
						p4:ScaleTo((math.lerp(v4, 0.1, p13)))
						p4:PivotTo(v5:Lerp(v6, p13))
					end):andThen(function() --[[ Line: 321 | Upvalues: p12 (copy) ]]
						p12:exit_state()
					end)
				end
			}
		})
	end
}