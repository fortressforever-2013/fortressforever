
-- base_id_new.lua
-- Invade / Defend gametype 
-- New scoring system included
-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- globals. Copy these your yourmap.lua if you want to change them.
-----------------------------------------------------------------------------
if NUM_PHASES == nil then NUM_PHASES = 4; end
if INITIAL_ROUND_DELAY == nil then INITIAL_ROUND_DELAY = 45; end
--How long it takes for the next flag to become available 
if ROUND_DELAY == nil then ROUND_DELAY = 20; end
FLAG_RETURN_TIME = 60
--A little pause before teams switch
TEAM_SWITCH_DELAY = 5
--If true, all players will respawn when a flag is capped
if RESPAWN_AFTER_CAP == nil then RESPAWN_AFTER_CAP = false end
if RESPAWN_DELAY == nil then RESPAWN_DELAY = 2 end

--Every cap has a time limit. The score for a capture decreases as time passes
if CAP_TIME_LIMIT == nil then CAP_TIME_LIMIT = 240 end
if SECONDS_PER_POINT == nil then SECONDS_PER_POINT = 12 end

SECONDS_FOR_ONE_FULL_ROUND = INITIAL_ROUND_DELAY + TEAM_SWITCH_DELAY + ROUND_DELAY * (NUM_PHASES-1) + CAP_TIME_LIMIT * NUM_PHASES
--SECONDS_FOR_TWO_FULL_ROUNDS = (INITIAL_ROUND_DELAY + TEAM_SWITCH_DELAY + ROUND_DELAY * (NUM_PHASES-1) + CAP_TIME_LIMIT * NUM_PHASES) * 2
--ConsoleToAll("SECONDS_FOR_ONE_FULL_ROUND = "..SECONDS_FOR_ONE_FULL_ROUND)
-----------------------------------------------------------------------------

if ATTACKERS_OBJECTIVE_ENTITY == nil then ATTACKERS_OBJECTIVE_ENTITY = nil end
if DEFENDERS_OBJECTIVE_ENTITY == nil then DEFENDERS_OBJECTIVE_ENTITY = nil end
if DEFENDERS_OBJECTIVE_ONFLAG == nil then DEFENDERS_OBJECTIVE_ONFLAG = true end
if DEFENDERS_OBJECTIVE_ONCARRIER == nil then DEFENDERS_OBJECTIVE_ONCARRIER = true end
if onroundreset == nil then onroundreset = function() end end

instantswitch = false

--let players instantly change class before the gates open
function player_switchclass( player, oldclassid, newclassid )
	--avoids problems with joining a server
	if oldclassid == 0 then return true end
	if instantswitch and oldclassid ~= newclassid then 
		--add 16 to convert classes to AT flags
		ApplyToPlayer( player, {newclassid+16} )

		--The player gets full ammo/grenades on class switch!
		if player:GetTeamId() == attackers then
			player:RemoveAmmo( Ammo.kGren2, 4 )
		elseif player:GetTeamId() == defenders then
			player:RemoveAmmo( Ammo.kDetpack, 1)
		end
	end
	return true
end
                                                                               
basecap = trigger_ff_script:new({
	health = 100,
	armor = 300,
	grenades = 200,
	nails = 200,
	shells = 200,
	rockets = 200,
	cells = 200,
	detpacks = 1,
	mancannons = 1,
	gren1 = 0,
	gren2 = 0,
	item = "",
	team = 0,
	botgoaltype = Bot.kFlagCap,
})

function basecap:ontrigger ( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		-- player should capture now
		for i,v in ipairs( self.item ) do
			
			-- find the flag and cast it to an info_ff_script
			local flag = GetInfoScriptByName(v)

			-- Make sure flag isn't nil
			if flag then
			
				-- check if the player is carrying the flag
				if player:HasItem(flag:GetName()) then
			
					-- reward player for capture
					player:AddFortPoints(FORTPOINTS_PER_CAPTURE, "#FF_FORTPOINTS_CAPTUREFLAG")
				
					-- Remove any hud icons
					RemoveHudItem( player, flag:GetName() )
					RemoveHudItemFromAll( flag:GetName() .. "_c" )

          				LogLuaEvent(player:GetId(), 0, "flag_capture","flag_name",flag:GetName())
          			
					-- return the flag
					flag:Return()
				
					-- give player some health and armor
					if self.health ~= nil and self.health ~= 0 then player:AddHealth(self.health) end
					if self.armor ~= nil and self.armor ~= 0 then player:AddArmor(self.armor) end
	
					-- give the player some ammo
					if self.nails ~= nil and self.nails ~= 0 then player:AddAmmo(Ammo.kNails, self.nails) end
					if self.shells ~= nil and self.shells ~= 0 then player:AddAmmo(Ammo.kShells, self.shells) end
					if self.rockets ~= nil and self.rockets ~= 0 then player:AddAmmo(Ammo.kRockets, self.rockets) end
					if self.cells ~= nil and self.cells ~= 0 then player:AddAmmo(Ammo.kCells, self.cells) end
					if self.detpacks ~= nil and self.detpacks ~= 0 then player:AddAmmo(Ammo.kDetpack, self.detpacks) end
					if self.mancannons ~= nil and self.mancannons ~= 0 then player:AddAmmo(Ammo.kManCannon, self.mancannons) end
					if self.gren1 ~= nil and self.gren1 ~= 0 then player:AddAmmo(Ammo.kGren1, self.gren1) end
					if self.gren2 ~= nil and self.gren2 ~= 0 then player:AddAmmo(Ammo.kGren2, self.gren2) end
	
					self:oncapture( player, v )
				end
			end
		end
	end
end

function baseflag:spawn()
	self.notouch = { }
	info_ff_script.spawn(self)
	local flag = CastToInfoScript( entity )
	LogLuaEvent(0, 0, "flag_spawn","flag_name",flag:GetName())

	self.status = 0
	
	update_hud()
end

function baseflag:ownercloak( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	
	RemoveHudItem( player, flag:GetName() )
	self.status = 2
	
	-- objective icon
	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" ) 
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" ) end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	
	setup_return_timer()
	update_hud()
end

function baseflag:dropitemcmd( owner_entity )

	if allowdrop == false then return end

	--Used by logging
	self.flagtoss = true

	-- throw the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, FLAG_THROW_SPEED)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	
	RemoveHudItem( player, flag:GetName() )
	self.status = 2

	-- objective icon
	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" ) end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	
	setup_return_timer()
	update_hud()
end	

function baseflag:onownerforcerespawn( owner_entity )
	local flag = CastToInfoScript( entity )
	local player = CastToPlayer( owner_entity )
	player:SetDisguisable( true )
	player:SetCloakable( true )
	RemoveHudItem( player, flag:GetName() )	
	flag:Drop(0, FLAG_THROW_SPEED)

	self.status = 2
	-- objective icon
	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" ) end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )

	update_hud()
end

function baseflag:onreturn( )
	-- let the teams know that the flag was returned
	local team = GetTeam( self.team )
	SmartTeamMessage(team, "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN", Color.kYellow, Color.kYellow)
	SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
	SmartTeamSpeak(team, "CTF_FLAGBACK", "CTF_EFLAGBACK")
	local flag = CastToInfoScript( entity )

	self.status = 0
	
	LogLuaEvent(0, 0, "flag_returned","flag_name",flag:GetName());

	-- objective icon
	ATTACKERS_OBJECTIVE_ENTITY = flag
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = flag end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	
	destroy_return_timer()
	update_hud()
end

phase = 1
current_flag = "cp1_flag"
attackers = Team.kBlue
defenders = Team.kRed
current_timer = 0
carried_by = nil
rounds_elapsed = 0
cap_timeleft = 0

--This is the default startup script for id maps. If you use startup() in your map, call this and then do your own stuff before/after.
function id_startup()

	SetGameDescription( "Invade Defend" )
	
	-- set up team limits
	local team = GetTeam( Team.kBlue )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kRed )
	team:SetPlayerLimit( 0 )

	team = GetTeam( Team.kYellow )
	team:SetPlayerLimit( -1 )

	team = GetTeam( Team.kGreen )
	team:SetPlayerLimit( -1 )

	redScore = 0
	blueScore = 0

	--map will end after red gets to attack
	roundnumber = 1
	lastround = false
	--the original timelimit. If a server admin changes mp_timelimit, the script won't adjust to it.
	timelimit = GetConvar( "mp_timelimit" )

	-- CTF maps generally don't have civilians,
	-- so override in map LUA file if you want 'em
	local team = GetTeam(Team.kBlue)
	team:SetClassLimit(Player.kCivilian, -1)

	team = GetTeam(Team.kRed)
	team:SetClassLimit(Player.kCivilian, -1)
	
	-- set them team names
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )

	cap_timeleft = 0

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
	
	flags_set_team( attackers )
	
	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )
	DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_cap" )
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
end

function startup()
	id_startup()
end

-- Give everyone a full resupply, but strip secondary grenades for offense
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )

	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:AddAmmo( Ammo.kDetpack, 1 )
	player:AddAmmo( Ammo.kManCannon, 1 )

	if player:GetTeamId() == attackers then
		UpdateObjectiveIcon( player, ATTACKERS_OBJECTIVE_ENTITY )
		player:RemoveAmmo( Ammo.kGren2, 4 )
	elseif player:GetTeamId() == defenders then
		UpdateObjectiveIcon( player, DEFENDERS_OBJECTIVE_ENTITY )
		player:RemoveAmmo( Ammo.kDetpack, 1)
	end
end

function precache()
	-- precache sounds
	PrecacheSound("yourteam.flagstolen")
	PrecacheSound("otherteam.flagstolen")
	PrecacheSound("yourteam.flagcap")
	PrecacheSound("otherteam.flagcap")
	PrecacheSound("yourteam.drop")
	PrecacheSound("otherteam.drop")
	PrecacheSound("yourteam.flagreturn")
	PrecacheSound("otherteam.flagreturn")
end

-- kinda ghetto, sure
function flags_set_team( teamid )
	-- set all flags teams
	cp1_flag.team = teamid
	cp2_flag.team = teamid
	cp3_flag.team = teamid
	cp4_flag.team = teamid
	cp5_flag.team = teamid
	cp6_flag.team = teamid
	cp7_flag.team = teamid
	cp8_flag.team = teamid
end	
	
-----------------------------------------
--Backpacks
-----------------------------------------
idbackpack = genericbackpack:new({team = nil})

function idbackpack:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )

		if player:GetTeamId() ~= self.team then
			return false
		end
	
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
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

--These bags will switch teams with the map.
backpack_attackers = idbackpack:new({team = attackers})
backpack_defenders = idbackpack:new({team = defenders})


-----------------------------------------
-- base flag
-----------------------------------------
base_id_flag = baseflag:new({
	phase = 1,
	enabled = nil,
	touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed },
	hudicon = BLUE_FLAG_HUD_ICON,
})
function base_id_flag:touch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		-- pickup if they can
		if self.notouch[player:GetId()] then return; end

		if player:GetTeamId() == attackers and phase == self.phase and self.enabled then
			SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
			RandomFlagTouchSpeak( player )
			SmartMessage(player, "#FF_YOUPICKUP", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)
			
			local flag = CastToInfoScript(entity)
			flag:Pickup(player)
			player:SetDisguisable( false )
			-- if the player is a spy, then force him to lose his cloak
			player:SetCloakable( false )

			self.hudicon = team_hudicons[attackers] 
	
			AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudstatusiconw, self.hudstatusiconh, self.hudalign )

			-- log action in stats
			LogLuaEvent(player:GetId(), 0, "flag_touch", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());	

			-- change objective icons
			ATTACKERS_OBJECTIVE_ENTITY = player
			if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..self.phase.."_cap" ) end
			if DEFENDERS_OBJECTIVE_ONCARRIER then DEFENDERS_OBJECTIVE_ENTITY = player end
			UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
			UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
			UpdateObjectiveIcon( player, GetEntityByName( "cp"..self.phase.."_cap" ) )
			
			carried_by = player:GetName()
			destroy_return_timer()
			update_hud()
		end
	end
end

function base_id_flag:onownerdie( owner_entity )
	-- drop the flag
	local flag = CastToInfoScript(entity)
	flag:Drop(FLAG_RETURN_TIME, 0.0)
	
	-- remove flag icon from hud
	local player = CastToPlayer( owner_entity )
	RemoveHudItem( player, flag:GetName() )

	player:SetDisguisable( true )
	player:SetCloakable( true )
	
	-- change objective icon
	ATTACKERS_OBJECTIVE_ENTITY = flag
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = flag end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	UpdateObjectiveIcon( player, nil )
	
	self.status = 2
	
	setup_return_timer()
	update_hud()
end

-----------------------------------------
-- base capture point
-----------------------------------------
base_id_cap = basecap:new({
	phase = 0,
})

function base_id_cap:allowed ( touch_entity )
	if phase ~= self.phase then
		return EVENT_DISALLOWED
	end	
	
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		
		if player:GetTeamId() == defenders then
			BroadCastMessageToPlayer( player, "#AD_Defend" )
		else
			for i,v in ipairs(self.item) do
				if player:HasItem( v ) then
					return EVENT_ALLOWED
				end
			end
		end
	end
	
	return EVENT_DISALLOWED
end

function base_id_cap:oncapture(player, item)
	SmartSound(player, "yourteam.flagcap", "yourteam.flagcap", "otherteam.flagcap")
 	SmartMessage(player, "#FF_YOUCAP", "#FF_TEAMCAP", "#FF_OTHERTEAMCAP", Color.kGreen, Color.kGreen, Color.kRed)

	--Custom map effects. Put a logic_relay in the map, eg. "cp1_relay_blue" to trigger when there's a cap.
	if attackers == Team.kBlue then
		OutputEvent( "cp"..self.phase.."_relay_blue", "Trigger" )
	else
		OutputEvent( "cp"..self.phase.."_relay_red", "Trigger" )
	end

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
					


	--Team gets points for time left on the clock. 
	local team = player:GetTeam()
	team:AddScore(math.ceil(cap_timeleft / SECONDS_PER_POINT))
	if attackers == Team.kBlue then
		blueScore = blueScore + (math.ceil(cap_timeleft / SECONDS_PER_POINT))
	else
		redScore = redScore + (math.ceil(cap_timeleft / SECONDS_PER_POINT))
	end
	
	-- show on the deathnotice board
	ObjectiveNotice( player, "captured point "..phase.." for "..(math.ceil(cap_timeleft / SECONDS_PER_POINT)).." points" )
   	
	RemoveSchedule("cap_timer_schedule")
	RemoveSchedule("forceRoundEnd")
	RemoveSchedule("forceRoundWarn300")
	RemoveSchedule("forceRoundWarn120")
	RemoveSchedule("forceRoundWarn30")
	RemoveSchedule("forceRoundWarn10")
	RemoveSchedule("forceRoundWarn9")
	RemoveSchedule("forceRoundWarn8")
	RemoveSchedule("forceRoundWarn7")
	RemoveSchedule("forceRoundWarn6")
	RemoveSchedule("forceRoundWarn5")
	RemoveSchedule("forceRoundWarn4")
	RemoveSchedule("forceRoundWarn3")
	RemoveSchedule("forceRoundWarn2")
	RemoveSchedule("forceRoundWarn1")
	cap_timeleft = 0

	if phase == NUM_PHASES then
		-- it's the last phase. end and stuff
		rounds_elapsed = rounds_elapsed + 1

		SmartTeamSpeak(GetTeam(attackers), "CZ_GOTALL", "CZ_THEYGOTALL")
		freezeAllPlayers()
      
	 	--End the map if it's time.
	 	if attackers == Team.kRed and lastround == true then
	 		AddSchedule("QuitSched", 4, QuitIt())	
	   	else
	   		AddSchedule("team_switch_delay", TEAM_SWITCH_DELAY, round_end)
	   	end
	else
		SmartSpeak(player, "CTF_YOUCAP", "CTF_TEAMCAP", "CTF_THEYCAP")
		phase = phase + 1
		if RESPAWN_AFTER_CAP then
			AddSchedule("respawn_all", RESPAWN_DELAY, respawn_all)
		end

		-- enable the next flag after a time
		AddSchedule("flag_start", ROUND_DELAY, flag_start, self.next)
		if ROUND_DELAY > 30 then AddSchedule("flag_30secwarn", ROUND_DELAY-30, flag_30secwarn) end
		if ROUND_DELAY > 10 then AddSchedule("flag_10secwarn", ROUND_DELAY-10, flag_10secwarn) end

		current_flag = self.next
		
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

function respawn_all()
	RespawnAllPlayers()
end	

function round_end()

		phase = 1

		if attackers == Team.kBlue then
			attackers = Team.kRed
			defenders = Team.kBlue
		else
			roundnumber = roundnumber + 1
			attackers = Team.kBlue
			defenders = Team.kRed
			AddHudTextToAll("finalround_text", "ROUND "..roundnumber, 20, od_hudstatusicony+5, 3, 0, 2)
		end

		--ten minutes until the time limit, call it quits
		if (GetServerTime() > 60 * timelimit - 600) and lastround == false and attackers == Team.kBlue then
			lastround = true
			AddHudTextToAll("finalround_text", "FINAL ROUND", 20, od_hudstatusicony+5, 3, 0, 2)
			--ConsoleToAll("declaring last round: "..(timelimit - GetServerTime()/60).." minutes left until original map limit")
		end
		
		-- set all flag teams to new attackers
		flags_set_team( attackers )
		
		-- switch them team names
		SetTeamName( attackers, "Attackers" )
		SetTeamName( defenders, "Defenders" )

		-- respawn the players
		RespawnAllPlayers()
		setup_door_timer("start_gate", INITIAL_ROUND_DELAY)

      --Telling players what's up
		SmartTeamMessage(GetTeam(defenders), "You are now on defense. Move to command point 1", "You are now on Offense. When the gates open, attack!")
		SmartTeamSpeak(GetTeam(attackers), "AD_ATTACK", "AD_DEFEND")
		
		if blueScore > redScore then 
			AddSchedule("WinningSpeak", 3, SmartTeamSpeak, GetTeam(Team.kBlue), "WINNING_YOURTEAM", "WINNING_ENEMYTEAM")
		elseif redScore > blueScore then 
			AddSchedule("WinningSpeak", 3, SmartTeamSpeak, GetTeam(Team.kRed), "WINNING_YOURTEAM", "WINNING_ENEMYTEAM")
		end
		
		current_flag = "cp1_flag"

		-- enable the first flag
		cp1_flag.enabled = true
		cp1_flag.status = 0
		local flag = GetInfoScriptByName("cp1_flag")
		if flag then
			flag:Restore()
			flag:SetSkin(teamskins[attackers])
		end
		
		-- change objective icon
		ATTACKERS_OBJECTIVE_ENTITY = flag
		DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_cap" )
		UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
		UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
		
		update_hud()
		
		-- run custom round reset stuff
		onroundreset()
end

function setup_door_timer(doorname, duration)
	CloseDoor(doorname)
	AddSchedule("round_start", duration, round_start, doorname)
	AddSchedule("round_30secwarn", duration-30, round_30secwarn)
	AddSchedule("round_10secwarn", duration-10, round_10secwarn)
	AddSchedule("round_5secwarn", duration-5, round_5secwarn)
	AddSchedule("round_4secwarn", duration-4, round_4secwarn)
	AddSchedule("round_3secwarn", duration-3, round_3secwarn)
	AddSchedule("round_2secwarn", duration-2, round_2secwarn)
	AddSchedule("round_1secwarn", duration-1, round_1secwarn)
	--This overrides the schedules from the previous round
	--Which should be over anyway, but don't fix what ain't broke, right?
	AddSchedule("forceRoundEnd", CAP_TIME_LIMIT+duration, forceRoundEnd)
	--Don't do vox as the gate opens becasue there's already an anouncement
	if CAP_TIME_LIMIT >= 305 then AddSchedule("forceRoundWarn300", CAP_TIME_LIMIT+duration-300, forceRoundWarn300) end
	if CAP_TIME_LIMIT >= 125 then AddSchedule("forceRoundWarn120", CAP_TIME_LIMIT+duration-120, forceRoundWarn120) end
	AddSchedule("forceRoundWarn30", CAP_TIME_LIMIT+duration-30, forceRoundWarn30)
	AddSchedule("forceRoundWarn10", CAP_TIME_LIMIT+duration-10, forceRoundWarn10)
	AddSchedule("forceRoundWarn9", CAP_TIME_LIMIT+duration-9, forceRoundWarn9)
	AddSchedule("forceRoundWarn8", CAP_TIME_LIMIT+duration-8, forceRoundWarn8)
	AddSchedule("forceRoundWarn7", CAP_TIME_LIMIT+duration-7, forceRoundWarn7)
	AddSchedule("forceRoundWarn6", CAP_TIME_LIMIT+duration-6, forceRoundWarn6)
	AddSchedule("forceRoundWarn5", CAP_TIME_LIMIT+duration-5, forceRoundWarn5)
	AddSchedule("forceRoundWarn4", CAP_TIME_LIMIT+duration-4, forceRoundWarn4)
	AddSchedule("forceRoundWarn3", CAP_TIME_LIMIT+duration-3, forceRoundWarn3)
	AddSchedule("forceRoundWarn2", CAP_TIME_LIMIT+duration-2, forceRoundWarn2)
	AddSchedule("forceRoundWarn1", CAP_TIME_LIMIT+duration-1, forceRoundWarn1)

	instantswitch = true

	--Put more time on the clock if needed  
	if (60 * GetConvar( "mp_timelimit" ) - GetServerTime() - 4) < SECONDS_FOR_ONE_FULL_ROUND then
		set_cvar("mp_timelimit", (GetServerTime() + SECONDS_FOR_ONE_FULL_ROUND)/60)
		--ConsoleToAll("setting mp_timelimit: "..(GetServerTime() + SECONDS_FOR_ONE_FULL_ROUND/)60)
	end
end

function round_start(doorname)
	cap_timeleft = CAP_TIME_LIMIT
	AddScheduleRepeating( "cap_timer_schedule", 1, cap_timer_schedule)
	BroadCastMessage("#FF_AD_GATESOPEN")
	SpeakAll("AD_GATESOPEN")
	OpenDoor(doorname)
	update_hud()
	instantswitch = false
end

function cap_timer_schedule()
	cap_timeleft = cap_timeleft - 1
	if cap_timeleft < 0 then cap_timeleft = 0 end
end

function freezeAllPlayers()
	local col = Collection()
	col:GetByFilter( { CF.kPlayers, CF.kTeamBlue } )
	for temp in col.items do
		local player = CastToPlayer( temp )
		if player then
			player:Freeze(true)
		end
	end
	col:GetByFilter( { CF.kPlayers, CF.kTeamRed } )
	for temp in col.items do
		local player = CastToPlayer( temp )
		if player then
			player:Freeze(true)
		end
	end
end

function forceRoundEnd()
	freezeAllPlayers()

	BroadCastMessage("#ADZ_Switch")
	SpeakAll("CZ_POINTSRESET")
	RemoveSchedule("cap_timer_schedule")
	cap_timeleft = 0

	rounds_elapsed = rounds_elapsed + 1
	
	--These relays fire if the round times out
	if attackers == Team.kBlue then
      OutputEvent("timeout_relay_blue", "Trigger")
   else
      OutputEvent("timeout_relay_red", "Trigger")
   end
   
	--cancel any flag action
	local flag = GetInfoScriptByName(current_flag)
	if flag then 
		flag:Remove()
	end
	RemoveHudItemFromAll(current_flag)
	update_hud()

   	--End the map if it's time
	if attackers == Team.kRed and lastround == true then
   		AddSchedule("QuitSched", 4, QuitIt())	
	else
		AddSchedule("team_switch_delay", TEAM_SWITCH_DELAY, round_end)
   	end
end

function QuitIt()
   GoToIntermission()
   if blueScore > redScore then 
			AddSchedule("WinSpeak", 1, SpeakAll, "WIN_BLUE")
	elseif redScore > blueScore then 
			AddSchedule("WinSpeak", 1, SpeakAll, "WIN_RED")
	end
end

function forceRoundWarn300()
	BroadCastMessage("#ADZ_Switch5Min")
	SpeakAll("AD_300SEC")
end
function forceRoundWarn120()
	BroadCastMessage("#ADZ_Switch2Min")
	SpeakAll("AD_120SEC")
end
function forceRoundWarn30()
	BroadCastMessage("#ADZ_Switch30Sec")
	SpeakAll("AD_30SEC")
end
function forceRoundWarn10()
	BroadCastMessage("#ADZ_Switch10Sec")
	SpeakAll("AD_10SEC")
end
function forceRoundWarn9()
	BroadCastMessage("9")
	SpeakAll("AD_9SEC")
end
function forceRoundWarn8()
	BroadCastMessage("8")
	SpeakAll("AD_8SEC")
end
function forceRoundWarn7()
	BroadCastMessage("7")
	SpeakAll("AD_7SEC")
end
function forceRoundWarn6()
	BroadCastMessage("6")
	SpeakAll("AD_6SEC")
end
function forceRoundWarn5()
	BroadCastMessage("5")
	SpeakAll("AD_5SEC")
end
function forceRoundWarn4()
	BroadCastMessage("4")
	SpeakAll("AD_4SEC")
end
function forceRoundWarn3()
	BroadCastMessage("3")
	SpeakAll("AD_3SEC")
end
function forceRoundWarn2()
	BroadCastMessage("2")
	SpeakAll("AD_2SEC")
end
function forceRoundWarn1()
	BroadCastMessage("1")
	SpeakAll("AD_1SEC")
end


function round_30secwarn()
	BroadCastMessage("#FF_ROUND_30SECWARN")
end
function round_10secwarn()
	BroadCastMessage("#FF_ROUND_10SECWARN")
end
function round_5secwarn()
	BroadCastMessage("5")
	SpeakAll("AD_5SEC")
end
function round_4secwarn()
	BroadCastMessage("4")
	SpeakAll("AD_4SEC")
end
function round_3secwarn()
	BroadCastMessage("3")
	SpeakAll("AD_3SEC")
end
function round_2secwarn()
	BroadCastMessage("2")
	SpeakAll("AD_2SEC")
end
function round_1secwarn()
	BroadCastMessage("1")
	SpeakAll("AD_1SEC")
end


function flag_start(flagname)
	BroadCastMessage("#AD_FlagAtBase")
	_G[flagname].enabled = true
	_G[flagname].status = 0
	local flag = GetInfoScriptByName(flagname)
	if flag then
		flag:Restore()
		flag:SetSkin(teamskins[attackers])
	end

	--reset the cap timer
	cap_timeleft = CAP_TIME_LIMIT
	AddScheduleRepeating( "cap_timer_schedule", 1, cap_timer_schedule)

	AddSchedule("forceRoundEnd", CAP_TIME_LIMIT, forceRoundEnd)
	if CAP_TIME_LIMIT >= 300 then AddSchedule("forceRoundWarn300", CAP_TIME_LIMIT-300, forceRoundWarn300) end
	if CAP_TIME_LIMIT >= 120 then AddSchedule("forceRoundWarn120", CAP_TIME_LIMIT-120, forceRoundWarn120) end
	AddSchedule("forceRoundWarn30", CAP_TIME_LIMIT-30, forceRoundWarn30)
	AddSchedule("forceRoundWarn10", CAP_TIME_LIMIT-10, forceRoundWarn10)
	AddSchedule("forceRoundWarn9", CAP_TIME_LIMIT-9, forceRoundWarn9)
	AddSchedule("forceRoundWarn8", CAP_TIME_LIMIT-8, forceRoundWarn8)
	AddSchedule("forceRoundWarn7", CAP_TIME_LIMIT-7, forceRoundWarn7)
	AddSchedule("forceRoundWarn6", CAP_TIME_LIMIT-6, forceRoundWarn6)
	AddSchedule("forceRoundWarn5", CAP_TIME_LIMIT-5, forceRoundWarn5)
	AddSchedule("forceRoundWarn4", CAP_TIME_LIMIT-4, forceRoundWarn4)
	AddSchedule("forceRoundWarn3", CAP_TIME_LIMIT-3, forceRoundWarn3)
	AddSchedule("forceRoundWarn2", CAP_TIME_LIMIT-2, forceRoundWarn2)   
	AddSchedule("forceRoundWarn1", CAP_TIME_LIMIT-1, forceRoundWarn1)


	-- change objective icon
	ATTACKERS_OBJECTIVE_ENTITY = flag
	if DEFENDERS_OBJECTIVE_ONFLAG then DEFENDERS_OBJECTIVE_ENTITY = flag end
	UpdateTeamObjectiveIcon( GetTeam(attackers), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
	update_hud()
end
function flag_30secwarn() BroadCastMessage("#AD_30SecReturn") end
function flag_10secwarn() BroadCastMessage("#AD_10SecReturn") end


function timer_schedule()
	current_timer = current_timer -1
end

function setup_return_timer()
	RemoveSchedule( "timer_tobase_schedule" )
	current_timer = FLAG_RETURN_TIME
	
	AddScheduleRepeatingNotInfinitely( "timer_return_schedule", 1, timer_schedule, current_timer)
end

function destroy_return_timer()
	RemoveSchedule( "timer_return_schedule" )
end

function setup_tobase_timer()
	RemoveSchedule( "timer_return_schedule" )
	current_timer = ROUND_DELAY
	
	AddScheduleRepeatingNotInfinitely( "timer_tobase_schedule", 1, timer_schedule, current_timer)
end

function destroy_tobase_timer()
	RemoveSchedule( "timer_tobase_schedule" )
end

------------------------------------------------
-- instanciate them
------------------------------------------------
cp1_flag = base_id_flag:new({phase = 1})
cp2_flag = base_id_flag:new({phase = 2})
cp3_flag = base_id_flag:new({phase = 3})
cp4_flag = base_id_flag:new({phase = 4})
cp5_flag = base_id_flag:new({phase = 5})
cp6_flag = base_id_flag:new({phase = 6})
cp7_flag = base_id_flag:new({phase = 7})
cp8_flag = base_id_flag:new({phase = 8})
cp1_cap = base_id_cap:new({phase = 1, item = {"cp1_flag"}, next = "cp2_flag"})
cp2_cap = base_id_cap:new({phase = 2, item = {"cp2_flag"}, next = "cp3_flag"})
cp3_cap = base_id_cap:new({phase = 3, item = {"cp3_flag"}, next = "cp4_flag"})
cp4_cap = base_id_cap:new({phase = 4, item = {"cp4_flag"}, next = "cp5_flag"})
cp5_cap = base_id_cap:new({phase = 5, item = {"cp5_flag"}, next = "cp6_flag"})
cp6_cap = base_id_cap:new({phase = 6, item = {"cp6_flag"}, next = "cp7_flag"})
cp7_cap = base_id_cap:new({phase = 7, item = {"cp7_flag"}, next = "cp8_flag"})
cp8_cap = base_id_cap:new({phase = 8, item = {"cp8_flag"}, next = nil})

base_attacker_spawn = info_ff_teamspawn:new({ phase = 0, validspawn = function(self,player)
	return player:GetTeamId() == attackers and phase == self.phase
end })
base_defender_spawn = info_ff_teamspawn:new({ phase = 0, validspawn = function(self,player)
	return player:GetTeamId() == defenders and phase == self.phase
end })
cp1_attacker = base_attacker_spawn:new({phase=1})
cp2_attacker = base_attacker_spawn:new({phase=2})
cp3_attacker = base_attacker_spawn:new({phase=3})
cp4_attacker = base_attacker_spawn:new({phase=4})
cp5_attacker = base_attacker_spawn:new({phase=5})
cp6_attacker = base_attacker_spawn:new({phase=6})
cp7_attacker = base_attacker_spawn:new({phase=7})
cp8_attacker = base_attacker_spawn:new({phase=8})
cp1_defender = base_defender_spawn:new({phase=1})
cp2_defender = base_defender_spawn:new({phase=2})
cp3_defender = base_defender_spawn:new({phase=3})
cp4_defender = base_defender_spawn:new({phase=4})
cp5_defender = base_defender_spawn:new({phase=5})
cp6_defender = base_defender_spawn:new({phase=6})
cp7_defender = base_defender_spawn:new({phase=7})
cp8_defender = base_defender_spawn:new({phase=8})

------------------------------------------------
-- hud info
------------------------------------------------
function flaginfo( player_entity )

	local player = CastToPlayer( player_entity )

	local flag = GetInfoScriptByName("cp"..phase.."_flag")
	local flagname = flag:GetName()
	
	RemoveHudItem( player, "cp_flag_c" )
	RemoveHudItem( player, "cp_flag_d" )
	RemoveHudItem( player, "cp_flag_h" )
	RemoveHudItem( player, "flag_tobase_timer" )
	RemoveHudItem( player, "flag_tobase_text" )
	RemoveHudItem( player, "flag_return_timer" )
	RemoveHudItem( player, "flag_return_text" )
	RemoveHudItem( player, "flag_carried_by" )
	RemoveHudItem( player, "flag_carried_by2" )
	RemoveHudItem( player, "flag_athome" )
	RemoveHudItem( player, "flag_athome2" )

	if attackers == Team.kBlue then
		hudstatusicondropped = "hud_flag_dropped_blue.vtf"
		hudstatusiconhome = "hud_flag_home_blue.vtf"
		hudstatusiconcarried = "hud_flag_carried_blue.vtf"
		hudstatusicontobase = "hud_flag_home_l.vtf"
	elseif attackers == Team.kRed then
		hudstatusicondropped = "hud_flag_dropped_red.vtf"
		hudstatusiconhome = "hud_flag_home_red.vtf"
		hudstatusiconcarried = "hud_flag_carried_red.vtf"
		hudstatusicontobase = "hud_flag_home_r.vtf"
	elseif attackers == Team.kYellow then
		hudstatusicondropped = "hud_flag_dropped_yellow.vtf"
		hudstatusiconhome = "hud_flag_home_yellow.vtf"
		hudstatusiconcarried = "hud_flag_carried_yellow.vtf"
		hudstatusicontobase = "hud_flag_home_l.vtf"
	elseif attackers == Team.kGreen then
		hudstatusicondropped = "hud_flag_dropped_green.vtf"
		hudstatusiconhome = "hud_flag_home_green.vtf"
		hudstatusiconcarried = "hud_flag_carried_green.vtf"
		hudstatusicontobase = "hud_flag_home_r.vtf"
	end
	
	flag_hudstatusiconx = 4
	flag_hudstatusicony = 42
	flag_hudstatusiconw = 15
	flag_hudstatusiconh = 15
	flag_hudstatusiconalign = 3
	text_hudstatusx = 0
	text_hudstatusy = flag_hudstatusicony + 24
	text_hudstatusalign = 4

	local CPnumber = phase - 1

	if _G[flagname].enabled == true then
		if flag:IsCarried() then
			AddHudText(player, "flag_carried_by", "#AD_FlagCarriedBy", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			AddHudText(player, "flag_carried_by2", carried_by, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 2)
			AddHudIcon(player, hudstatusiconcarried, ( "cp_flag_c" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif flag:IsDropped() and _G[flagname].status == 2 then
			if CPnumber > 0 then
				AddHudTextToAll("flag_return_text", "Flag will return to CP"..CPnumber.." in", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			else
				AddHudTextToAll("flag_return_text", "#AD_FlagReturnBase", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			end
			AddHudTimer(player, "flag_return_timer", current_timer, -1, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 3)
			AddHudIcon(player, hudstatusicondropped, ( "cp_flag_d" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif _G[flagname].status == 0 then
			AddHudText(player, "flag_athome", "#AD_FlagIsAt", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			if CPnumber > 0 then
				AddHudText(player, "flag_athome2", "Capture Point "..CPnumber, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 2)
			else
				AddHudText(player, "flag_athome2", "#AD_ASpawn", text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 2)
			end
			AddHudIcon(player, hudstatusiconhome, ( "cp_flag_h" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )	
		end
	else
		if CPnumber > 0 then
			AddHudText(player, "flag_tobase_text", "Flag will return to CP"..CPnumber.." in", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
		else
			AddHudText(player, "flag_tobase_text", "#AD_FlagReturnBase", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
		end
		AddHudTimer(player, "flag_tobase_timer", current_timer, -1, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 3)
		AddHudIcon(player, hudstatusicontobase, ( "cp_flag_h" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
	end
	
	RemoveHudItem( player, "Zone_Team"..attackers )
	RemoveHudItem( player, "Zone_Team"..defenders )
	RemoveHudItem( player, "Zone_Phase"..attackers )
	RemoveHudItem( player, "Zone_Phase"..defenders )
	
	od_hudstatusiconx = -28
	od_hudstatusicony = 38
	od_hudstatusiconw = 24
	od_hudstatusiconh = 24
	od_hudstatusiconalign = 3
	
	RemoveHudItem(player, "cap_timer")
	RemoveHudItem(player, "cap_timer_text")
	if cap_timeleft > 0 then
		AddHudText(player, "cap_timer_text", "Time left", 40, od_hudstatusicony, 2, 0, 2)
		AddHudTimer(player, "cap_timer", cap_timeleft, -1, 40, od_hudstatusicony+10, 2, 0, 3)
	end

	if lastround == true then AddHudText(player, "finalround_text", "FINAL ROUND", 20, od_hudstatusicony+5, 3, 0, 2)
	else AddHudText(player, "finalround_text", "ROUND "..roundnumber, 20, od_hudstatusicony+5, 3, 0, 2)
	end

	if player:GetTeamId() == attackers then
		AddHudIcon( player, "hud_offense.vtf", "Zone_Team"..attackers, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
		AddHudIcon( player, "hud_cp_"..phase..".vtf", "Zone_Phase"..attackers, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	else
		AddHudIcon( player, "hud_defense.vtf", "Zone_Team"..defenders, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
		AddHudIcon( player, "hud_cp_"..phase..".vtf", "Zone_Phase"..defenders, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	end
	
end

function update_hud()

	local flag = GetInfoScriptByName("cp"..phase.."_flag")
	local flagname = flag:GetName()
	
	RemoveHudItemFromAll( "cp_flag_c" )
	RemoveHudItemFromAll( "cp_flag_d" )
	RemoveHudItemFromAll( "cp_flag_h" )
	RemoveHudItemFromAll( "flag_tobase_timer" )
	RemoveHudItemFromAll( "flag_tobase_text" )
	RemoveHudItemFromAll( "flag_return_timer" )
	RemoveHudItemFromAll( "flag_return_text" )
	RemoveHudItemFromAll( "flag_carried_by" )
	RemoveHudItemFromAll( "flag_carried_by2" )
	RemoveHudItemFromAll( "flag_athome" )
	RemoveHudItemFromAll( "flag_athome2" )

	if attackers == Team.kBlue then
		hudstatusicondropped = "hud_flag_dropped_blue.vtf"
		hudstatusiconhome = "hud_flag_home_blue.vtf"
		hudstatusiconcarried = "hud_flag_carried_blue.vtf"
		hudstatusicontobase = "hud_flag_home_l.vtf"
	elseif attackers == Team.kRed then
		hudstatusicondropped = "hud_flag_dropped_red.vtf"
		hudstatusiconhome = "hud_flag_home_red.vtf"
		hudstatusiconcarried = "hud_flag_carried_red.vtf"
		hudstatusicontobase = "hud_flag_home_r.vtf"
	elseif attackers == Team.kYellow then
		hudstatusicondropped = "hud_flag_dropped_yellow.vtf"
		hudstatusiconhome = "hud_flag_home_yellow.vtf"
		hudstatusiconcarried = "hud_flag_carried_yellow.vtf"
		hudstatusicontobase = "hud_flag_home_l.vtf"
	elseif attackers == Team.kGreen then
		hudstatusicondropped = "hud_flag_dropped_green.vtf"
		hudstatusiconhome = "hud_flag_home_green.vtf"
		hudstatusiconcarried = "hud_flag_carried_green.vtf"
		hudstatusicontobase = "hud_flag_home_r.vtf"
	end
	
	flag_hudstatusiconx = 4
	flag_hudstatusicony = 42
	flag_hudstatusiconw = 15
	flag_hudstatusiconh = 15
	flag_hudstatusiconalign = 3
	text_hudstatusx = 0
	text_hudstatusy = flag_hudstatusicony + 24
	text_hudstatusalign = 4

	local CPnumber = phase - 1

	if _G[flagname].enabled == true then
		if flag:IsCarried() then
			AddHudTextToAll("flag_carried_by", "#AD_FlagCarriedBy", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			AddHudTextToAll("flag_carried_by2", carried_by, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 2)
			AddHudIconToAll( hudstatusiconcarried, ( "cp_flag_c" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif flag:IsDropped() and _G[flagname].status == 2 then
			if CPnumber > 0 then
				AddHudTextToAll("flag_return_text", "Flag will return to CP"..CPnumber.." in", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			else
				AddHudTextToAll("flag_return_text", "#AD_FlagReturnBase", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			end
			AddHudTimerToAll("flag_return_timer", current_timer, -1, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 3)
			AddHudIconToAll( hudstatusicondropped, ( "cp_flag_d" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif _G[flagname].status == 0 then
			AddHudTextToAll("flag_athome", "#AD_FlagIsAt", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
			if CPnumber > 0 then
				AddHudTextToAll("flag_athome2", "Capture Point "..CPnumber, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 2)
			else
				AddHudTextToAll("flag_athome2", "#AD_ASpawn", text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 2)
			end
			AddHudIconToAll( hudstatusiconhome, ( "cp_flag_h" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )	
		end
	else
		if CPnumber > 0 then
			AddHudTextToAll("flag_tobase_text", "Flag will return to CP"..CPnumber.." in", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
		else
			AddHudTextToAll("flag_tobase_text", "#AD_FlagReturnBase", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0, 2)
		end
		AddHudTimerToAll("flag_tobase_timer", current_timer, -1, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0, 3)
		AddHudIconToAll(hudstatusicontobase, ( "cp_flag_h" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
	end


	RemoveHudItemFromAll( "Zone_Team"..attackers )
	RemoveHudItemFromAll( "Zone_Team"..defenders )
	RemoveHudItemFromAll( "Zone_Phase"..attackers )
	RemoveHudItemFromAll( "Zone_Phase"..defenders )
	
	od_hudstatusiconx = -28
	od_hudstatusicony = 38
	od_hudstatusiconw = 24
	od_hudstatusiconh = 24
	od_hudstatusiconalign = 3
	
	RemoveHudItemFromAll("cap_timer")
	RemoveHudItemFromAll("cap_timer_text")
	if cap_timeleft > 0 then
		AddHudTextToAll("cap_timer_text", "Time left", 40, od_hudstatusicony, 2, 0, 2)
		AddHudTimerToAll("cap_timer", cap_timeleft, -1, 40, od_hudstatusicony+10, 2, 0, 3)
	end

	AddHudIconToTeam( GetTeam(attackers), "hud_offense.vtf", "Zone_Team"..attackers, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
	AddHudIconToTeam( GetTeam(attackers), "hud_cp_"..phase..".vtf", "Zone_Phase"..attackers, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	
	AddHudIconToTeam( GetTeam(defenders), "hud_defense.vtf", "Zone_Team"..defenders, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
	AddHudIconToTeam( GetTeam(defenders), "hud_cp_"..phase..".vtf", "Zone_Phase"..defenders, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	
end