IncludeScript("base_id");
IncludeScript("base_respawnturret");
NUM_PHASES = 3
-----------------------------------------------------------------------------
FLAG_RETURN_TIME = 45;
INITIAL_ROUND_DELAY = 30;
-----------------------------------------------------------------------------
function respawnall()
	BroadCastMessage( "Area Closing. Respawning..." )
	ApplyToAll( { AT.kRespawnPlayers, AT.kRemoveBuildables } )  
end

teamskins = {}
teamskins[Team.kBlue] = 0
teamskins[Team.kRed] = 1

force_change = {}

respawnturret_attackers = base_respawnturret:new({ team = attackers })
respawnturret_defenders = base_respawnturret:new({ team = defenders })

function startup()
	SetGameDescription("Invade Defend")
	
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	
	local team = GetTeam(attackers)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kEngineer, 2)

	team = GetTeam(defenders)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kEngineer, 2)

	-- start the timer for the points
	AddScheduleRepeating("addpoints", PERIOD_TIME, addpoints)

	setup_door_timer("start_gate", INITIAL_ROUND_DELAY)

	cp1_flag.enabled = true
	for i,v in ipairs({"cp1_flag", "cp2_flag", "cp3_flag", "cp4_flag", "cp5_flag", "cp6_flag", "cp7_flag", "cp8_flag"}) do
		local flag = GetInfoScriptByName(v)
		if flag then
			flag:SetModel(_G[v].model)
			flag:SetSkin(teamskins[attackers])
			if i == 1 then
				flag:Restore()
			else
				flag:Remove()
			end
		end
	end	
	
	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )
	DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_cap" )
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
end

function round_start(doorname)
	BroadCastMessage("Gates are now open!")
	OpenDoor(doorname)
	OutputEvent( "alert7", "PlaySound" )
	AddSchedule("stop_maingate_sound", 3.5, OutputEvent, "alert7", "StopSound")
end

------------------------------------------------------------------------------
--Capture points
------------------------------------------------------------------------------

function base_id_cap:oncapture(player, item)
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
--SmartSound(player, "vox.yourcap", "vox.yourcap", "vox.enemycap")
	SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
 	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP", Color.kGreen, Color.kGreen, Color.kRed)

	local flag_item = GetInfoScriptByName( item )
	RemoveHudItem( player, flag_item:GetName() )

	-- turn off this flag
	for i,v in ipairs(self.item) do
		_G[v].enabled = nil
		local flag = GetInfoScriptByName(v)
		if flag then
			flag:Remove()
		end
	end

	if phase == NUM_PHASES then
		-- it's the last round. end and stuff
		
		OutputEvent("cp" .. phase .. "_door", "Close")
		OutputEvent("cp" .. phase .. "_beam", "TurnOff")
		OutputEvent("cp" .. phase .. "_light", "LightOff")
		
		OutputEvent("cp" .. phase .. "_point", "Toggle")
		
		-- timers reset
		OutputEvent("timer_door1", "Toggle")
		OutputEvent("timer_door2", "Toggle")
		OutputEvent("timer_door3", "Toggle")
		OutputEvent("timer_door4", "Toggle")
		
		phase = 1
		
		OutputEvent("cp" .. phase .. "_door", "Open")
		OutputEvent("cp" .. phase .. "_beam", "TurnOn")
		OutputEvent("cp" .. phase .. "_light", "LightOn")

		if attackers == Team.kBlue then
			attackers = Team.kRed
			defenders = Team.kBlue
		else
			attackers = Team.kBlue
			defenders = Team.kRed
		end			
		
		-- enable the first flag
		cp1_flag.enabled = true
		local flag = GetInfoScriptByName("cp1_flag")
		if flag then
			flag:Restore()
			flag:SetSkin(teamskins[attackers])
		end
		
		-- reset the timer on points
		AddScheduleRepeating("addpoints", PERIOD_TIME, addpoints)
		
		-- respawn the players
		RespawnAllPlayers()
		setup_door_timer("start_gate", INITIAL_ROUND_DELAY)
		
		ConsoleToAll("Round should be resetting...")
		-- run custom round reset stuff
		onroundreset()
	else
		AddSchedule("enable_respawnzone", 5, respawnall)
		
		AddSchedule( "close_cp_door", 5, OutputEvent, "cp" .. phase .. "_door", "Close" )
		OutputEvent("cp" .. phase .. "_beam", "TurnOff")
		OutputEvent("cp" .. phase .. "_light", "LightOff")
		
		OutputEvent("cp" .. phase .. "_point", "Toggle")
		
		-- set the timer
		OutputEvent("timer_door"..phase * 2 - 1, "Toggle")
		OutputEvent("timer_door"..phase * 2, "Toggle")
		
		-- lock the doors
		OutputEvent("attacker_door_trigger1", "Disable")
		OutputEvent("attacker_door_trigger2", "Disable")
		
		-- unlock on flag return
		AddSchedule("reenable_door1", ROUND_DELAY, OutputEvent, "attacker_door_trigger1", "Enable")
		AddSchedule("reenable_door2", ROUND_DELAY, OutputEvent, "attacker_door_trigger2", "Enable")
		-- open on flag return
		AddSchedule("open_door1", ROUND_DELAY, OutputEvent, "attacker_door1", "Open")
		AddSchedule("open_door2", ROUND_DELAY, OutputEvent, "attacker_door2", "Open")

		-- play and stop the alarm when the round starts
		AddSchedule("play_alert7-round", ROUND_DELAY, OutputEvent, "alert7", "PlaySound")
		AddSchedule("stop_alert7-round", ROUND_DELAY + 3.5, OutputEvent, "alert7", "StopSound")

		phase = phase + 1
		
		OutputEvent("cp" .. phase .. "_door", "Open")
		OutputEvent("cp" .. phase .. "_beam", "TurnOn")
		OutputEvent("cp" .. phase .. "_light", "LightOn")

		-- enable the next flag after a time
		AddSchedule("flag_start", ROUND_DELAY, flag_start, self.next)
		if ROUND_DELAY > 30 then AddSchedule("flag_30secwarn", ROUND_DELAY-30, flag_30secwarn) end
		if ROUND_DELAY > 10 then AddSchedule("flag_10secwarn", ROUND_DELAY-10, flag_10secwarn) end		
		
		-- clear objective icon
		ATTACKERS_OBJECTIVE_ENTITY = nil
		if DEFENDERS_OBJECTIVE_ONFLAG or DEFENDERS_OBJECTIVE_ONCARRIER then DEFENDERS_OBJECTIVE_ENTITY = nil
		else DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_cap" ) end
		UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
		UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
		
		setup_tobase_timer()
		update_hud()
	end

end

-----------------------------------------------------------
-- Packs
-----------------------------------------------------------

function genericbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
	
		local dispensed = 0
	
		-- give player some health and armor
		if self.health ~= nil and self.health ~= 0 then dispensed = dispensed + player:AddHealth( self.health ) end
		if self.armor ~= nil and self.armor ~= 0 then dispensed = dispensed + player:AddArmor( self.armor ) end
	
		-- give player ammo
		if self.nails ~= nil and self.nails ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kNails, self.nails) end
		if self.shells ~= nil and self.shells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kShells, self.shells) end
		if self.rockets ~= nil and self.rockets ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kRockets, self.rockets) end
		if self.cells ~= nil and self.cells ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kCells, self.cells) end
		if self.detpacks ~= nil and self.detpacks ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kDetpack, self.detpacks) end
		if self.mancannons ~= nil and self.mancannons ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kManCannon, self.mancannons) end
		if self.gren1 ~= nil and self.gren1 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren1, self.gren1) end
		if self.gren2 ~= nil and self.gren2 ~= 0 then dispensed = dispensed + player:AddAmmo(Ammo.kGren2, self.gren2) end
	
		-- if the player took ammo, then have the backpack respawn with a delay
		if dispensed >= 1 then
			local backpack = CastToInfoScript(entity);
			if backpack then
				if (self.globalsound ~= nil) then
					OutputEvent( self.globalsound, "Playsound" )
				end
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

vertigopack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	gren1 = 1,
	gren2 = 0,
	cells = 70,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

function vertigopack:dropatspawn() return false 
end

vertigopack2 = genericbackpack:new({
 	health = 50,
 	armor = 50,
 	grenades = 20,
 	nails = 50,
 	shells = 300,
 	rockets = 15,
 	gren1 = 2,
 	gren2 = 1,
 	cells = 70,
 	respawntime = 30,
	globalsound = "alert1",
 	model = "models/items/backpack/backpack.mdl",
 	materializesound = "Item.Materialize",
 	touchsound = "Backpack.Touch"})

function vertigopack2:dropatspawn() return false 
end
------------------------------------------------------------------
--Resup Doors
------------------------------------------------------------------
id_door = trigger_ff_script:new({ team = Team.kUnassigned, door = nil }) 

function id_door:allowed( touch_entity ) 
	if IsPlayer( touch_entity ) then 
		local player = CastToPlayer( touch_entity ) 
		return player:GetTeamId() == self.team
	end 

	return EVENT_DISALLOWED 
end 

function id_door:ontrigger( touch_entity )
	if IsPlayer( touch_entity ) then 
		OutputEvent(self.door, "Open")
	end 
end 

attacker_door_trigger1 = id_door:new({ team = attackers, door = "attacker_door1" })
attacker_door_trigger2 = id_door:new({ team = attackers, door = "attacker_door2" })
defender_door_trigger1 = id_door:new({ team = defenders, door = "defender_door1" })
defender_door_trigger2 = id_door:new({ team = defenders, door = "defender_door2" })

-----------------------------------------------------------------------------
--Respawning Triggers 
-----------------------------------------------------------------------------

fall_respawnzone = trigger_ff_script:new({})

function fall_respawnzone:allowed( touch_entity ) 
	if IsPlayer( touch_entity ) then 
		local player = CastToPlayer( touch_entity ) 
		return EVENT_ALLOWED
	end
	return EVENT_DISALLOWED 
end 

function fall_respawnzone:ontrigger( triggering_entity ) 
	if IsPlayer( triggering_entity ) then 
		local player = CastToPlayer( triggering_entity ) 
		BroadCastMessageToPlayer( player, "Divine Intervention?" )
		ApplyToPlayer( player, { AT.kRespawnPlayers } )
	end
end

-----------------------------------------------------------------------------
--Scout Check
-----------------------------------------------------------------------------

scout_check = trigger_ff_script:new({})

function scout_check:allowed( touch_entity ) 
	if IsPlayer( touch_entity ) then 
		local player = CastToPlayer( touch_entity ) 
		if (player:GetClass() == Player.kScout) and (player:GetTeamId() == defenders) and (force_change[player:GetId()] == nil) then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED 
end 

function scout_check:ontrigger( triggering_entity ) 
	if IsPlayer( triggering_entity ) then 
		local player = CastToPlayer( triggering_entity ) 
		local id = player:GetId()
		BroadCastMessageToPlayer( player, "Scout is not allowed on defense. Switching to Soldier..." )
		
		force_change[id] = 1
		
		AddSchedule("force_change"..id, 1, forcechange, id)
	end
end

function forcechange( pid )
	local playert = GetPlayerByID( pid )
	if (playert:GetClass() == Player.kScout) and (playert:GetTeamId() == defenders) then
		ApplyToPlayer( playert, { AT.kChangeClassSoldier, AT.kRespawnPlayers } )
	end
	force_change[pid] = nil
end

function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	local id = player:GetId()

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kManCannon, 1 )

	player:RemoveAmmo( Ammo.kGren2, 4 )

	if player:GetTeamId() == attackers then
		UpdateObjectiveIcon( player, ATTACKERS_OBJECTIVE_ENTITY )
	elseif player:GetTeamId() == defenders then
		UpdateObjectiveIcon( player, DEFENDERS_OBJECTIVE_ENTITY )
	end

	-- no detpacks for defenders
	if player:GetTeamId() == defenders then
		player:RemoveAmmo( Ammo.kDetpack, 1 )
	end
	
	force_change[id] = nil
end

---------------------------------------------------------------------------
--Flags
---------------------------------------------------------------------------	
function base_id_flag:onreturn( )
	-- let the teams know that the flag was returned
	local team = GetTeam( Team.kUnassigned )
	if (attackers == Team.kBlue) then
		team = GetTeam( Team.kBlue )
	else
		team = GetTeam( Team.kRed )
	end
	
	SmartTeamMessage(team, "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN")
	SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
	SmartTeamSpeak(team, "CTF_FLAGBACK", "CTF_EFLAGBACK")
	
	-- objective icon
	ATTACKERS_OBJECTIVE_ENTITY = flag
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = flag end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	
	destroy_return_timer()
	update_hud()

end

function base_id_flag:onownerforcerespawn( owner_entity )
	local flag = CastToInfoScript( entity )
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable( true )
	player:SetCloakable( true )
	RemoveHudItem( player, flag:GetName() )	
	flag:Drop(0, 0.0)
	self.status = 2
	
	-- objective icon
	ATTACKERS_OBJECTIVE_ENTITY = flag
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = flag end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	
	update_hud()
end

----------------------------------------------------------------------------
-- Det Wall
-----------------------------------------------------------------------------
detpack_trigger = trigger_ff_script:new({})

function detpack_trigger:onexplode( trigger_entity )
	if IsDetpack( trigger_entity ) then
		BroadCastMessage("Detpack Wall Opened!")
		OutputEvent("detpack_hole", "Toggle")
		detpack_wall_open = true			
	end
	return EVENT_ALLOWED
end
----------------------------------------------------------------------------
--Resets
------------------------------------------------------------------------

detpack_wall_open = nil

function onroundreset()
	ConsoleToAll("Round resetting...")
	if detpack_wall_open then
		OutputEvent("detpack_hole", "Toggle")
		detpack_wall_open = nil
	end
	
	respawnturret_attackers = base_respawnturret:new({ team = attackers })
	respawnturret_defenders = base_respawnturret:new({ team = defenders })
	attacker_door_trigger1 = id_door:new({ team = attackers, door = "attacker_door1" })
	attacker_door_trigger2 = id_door:new({ team = attackers, door = "attacker_door2" })
	defender_door_trigger1 = id_door:new({ team = defenders, door = "defender_door1" })
	defender_door_trigger2 = id_door:new({ team = defenders, door = "defender_door2" })
	
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	
	team = GetTeam(defenders)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kEngineer, 2)
	
	team = GetTeam(attackers)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kEngineer, 2)
	
	-- change objective icon
	ATTACKERS_OBJECTIVE_ENTITY = flag
	DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_cap" )
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	
	update_hud()
end

-- Don't want any body touching/triggering it except the detpack
function trigger_detpackable_door:allowed( trigger_entity ) return EVENT_DISALLOWED 
end
