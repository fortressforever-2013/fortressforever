-- base_idzone.lua
-- Invade / Defend the Zone gametype 

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- global overrides that you can do what you want with
-----------------------------------------------------------------------------

FORT_POINTS_PER_INITIAL_TOUCH = 200
FORT_POINTS_PER_PERIOD = 50
FORT_POINTS_PER_DEFEND = 100

POINTS_PER_INITIAL_TOUCH = 1
POINTS_PER_PERIOD = 1

DELAY_BEFORE_PERIOD_POINTS = 2
PERIOD_TIME = 1
INITIAL_ROUND_PERIOD = 60
ROUND_SETUP_PERIOD = 17

DEFENSE_PERIOD_TIME = 60
POINTS_PER_DEFENSE_PERIOD = 1

DEFAULT_POINTS_TO_CAP = 10
NUMBER_OF_CAP_POINTS = 3
DELAY_BEFORE_TEAMSWITCH = 2
DELAY_AFTER_CAP = 3

ZONE_COLOR = "blue"

-----------------------------------------------------------------------------
-- global variables and other shit that shouldn't be messed with
-----------------------------------------------------------------------------

phase = 1
zone_points = 0
zone_max_points = DEFAULT_POINTS_TO_CAP
zone_scoring = false
draw_hud = true

attackers = Team.kBlue
defenders = Team.kRed

scoring_team = Team.kRed

local teamdata = {
	[Team.kBlue] = { skin = "0", beamcolour = "0 0 255" },
	[Team.kRed] = { skin = "1", beamcolour = "255 0 0" }
}

-- stores ID's of attackers in the cap room
local zone_collection = Collection()

-- stores if the player has touched the cap point (for 1 touch per death)
local playerTouchedTable = {}

-----------------------------------------------------------------------------
-- functions that do sh... stuff
-----------------------------------------------------------------------------

-- sounds, right?
function precache()
	PrecacheSound("otherteam.flagstolen") -- doors open sound
	PrecacheSound("otherteam.drop") -- warning sound
	PrecacheSound("yourteam.flagreturn") -- scoring sound
	PrecacheSound("misc.bloop") -- minutes remaining
	PrecacheSound("misc.doop") -- attackers capping sound
end

-- pretty standard setup, aside from scoring starting
function startup()
	SetGameDescription( "Invade Defend the Zone" )

	-- set up team limits on each team
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	
	-- Making the game not suck.
	local team = GetTeam(attackers)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kSniper, 1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kHwguy, 2)
	team:SetClassLimit(Player.kPyro, 2)
	
	
	team = GetTeam(defenders)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kMedic, -1)
	team:SetClassLimit(Player.kSniper, 1)
	team:SetClassLimit(Player.kEngineer, 2)
	team:SetClassLimit(Player.kDemoman, 2)
	team:SetClassLimit(Player.kHwguy, 2)
	team:SetClassLimit(Player.kPyro, 2)
	
	
	AddSchedule( "round_start", INITIAL_ROUND_PERIOD, round_start)
	if INITIAL_ROUND_PERIOD > 30 then AddSchedule( "dooropen30sec" , INITIAL_ROUND_PERIOD - 30 , schedulemessagetoall, "#ADZ_30SecWarning" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10sec" , INITIAL_ROUND_PERIOD - 10 , schedulemessagetoall, "#ADZ_10SecWarning" ) end
	
	-- sounds
	if INITIAL_ROUND_PERIOD > 30 then AddSchedule( "dooropen30secsound" , INITIAL_ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10secsound" , INITIAL_ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5seccount" , INITIAL_ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4seccount" , INITIAL_ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3seccount" , INITIAL_ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2seccount" , INITIAL_ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1seccount" , INITIAL_ROUND_PERIOD - 1 , schedulecountdown, 1 ) end
	
	zone_max_points = zone1.pointstocap

	-- calculate defense period points
	local total_points_to_reset = 1
	for i=1,NUMBER_OF_CAP_POINTS do
		local t_points = getfield("zone"..i..".pointstocap")
		total_points_to_reset = total_points_to_reset + t_points
	end
	local timelimit = GetConvar( "mp_timelimit" )
	-- convert mp_timelimit from minutes to seconds and divide by the number of rounds minus initial round period
	POINTS_PER_DEFENSE_PERIOD = total_points_to_reset / (timelimit / (DEFENSE_PERIOD_TIME / 60))
	POINTS_PER_DEFENSE_PERIOD = math.ceil(POINTS_PER_DEFENSE_PERIOD)
	
	update_zone_all( )
	AddScheduleRepeating( "period_scoring_sched", PERIOD_TIME, period_scoring )
	AddScheduleRepeating( "defense_period_scoring_sched", DEFENSE_PERIOD_TIME, defenders_scoring )
end

-----------------------------------------------------------------------------
-- player_ functions
-----------------------------------------------------------------------------

-- on player spawn
function player_spawn( player_entity )
	
	local player = CastToPlayer( player_entity )
	
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	
	player:SetCloakable( true )
	player:SetDisguisable( true )
	
	update_zone_player( player )
	
	-- give demo 1 mirv, and only 1 mirv
	if player:GetClass() == Player.kDemoman or player:GetClass() == Player.kEngineer then 
		player:RemoveAmmo( Ammo.kGren2, 4 )
		player:AddAmmo( Ammo.kGren2, 1 )
	end
	
	if player:GetTeamId() == attackers then
		local attackers_objective = GetEntityByName( "zone"..phase )
		UpdateObjectiveIcon( player, attackers_objective )
	else
		UpdateObjectiveIcon( player, nil )
		player:RemoveAmmo( Ammo.kDetpack, 1 )
	end

	-- wtf, scout or med on d? are you mental?
	if (player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic) and (player:GetTeamId() == defenders) then
		local classt = "Scout"
		if player:GetClass() == Player.kMedic then classt = "Medic" end
		local id = player:GetId()
		AddSchedule("force_changemessage"..id, 2, schedulechangemessage, player, "No "..classt.."s on defense. Autoswitching to Soldier." )
		AddSchedule("force_change"..id, 2, forcechange, player)
	end
	
	-- remove any players not on a team from playertouchedtable
	for playerx, recordx in pairs(playerTouchedTable) do
		if GetPlayerByID( playerx ) then
			local playert = GetPlayerByID( playerx )
			if ( playert:GetTeamId() ~= attackers ) then
				playerTouchedTable[playerx] = nil
			end
		end
	end
	
	if player:GetTeamId() ~= attackers then return end
	
	-- add to table and reset touched to 0
	playerTouchedTable[player:GetId()] = {touched = false, allowed = true}
	
end

-- needed so that people who switch team are removed from the cap room collection properly.
function player_switchteam ( player, oldteam, newteam )
	if oldteam == attackers then 
		base_zone_trigger:onendtouch( player )
	end

	return true
end

-- on player killed
function player_killed ( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	else
		return
	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then return end

  -- If player killed self or teammate do nothing
  if (player:GetId() == player_attacker:GetId()) or (player:GetTeamId() == player_attacker:GetTeamId()) then
	return 
  end
  
  -- If player is an attacker, then do stuff
  if player:GetTeamId() == attackers then
	-- Check if he's in the cap point
	for playerx in zone_collection.items do
      playerx = CastToPlayer(playerx)

      if playerx:GetId() == player:GetId() then
		player_attacker:AddFortPoints( FORT_POINTS_PER_DEFEND, "Defending the Point" ) 
		
		-- for safety, remove player from collection
		zone_collection:RemoveItem( player )
		-- also for safety, if no more players, reset the cap
		if zone_collection:Count() == 0 then
			update_zone_all( )
			zone_turnoff( phase )
		end
		
		return
	  end
    end
   
  end
  
end

function player_ondamage ( player, damageinfo )

	-- if no damageinfo do nothing
	if not damageinfo then return end
	
	-- Get Damage Force
	local damage = damageinfo:GetDamage()

	-- Entity that is attacking
	local attacker = damageinfo:GetAttacker()

	-- If no attacker do nothing
	if not attacker then return end

	local player_attacker = nil

	-- get the attacking player
	if IsPlayer(attacker) then
		attacker = CastToPlayer(attacker)
		player_attacker = attacker
	elseif IsSentrygun(attacker) then
		attacker = CastToSentrygun(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDetpack(attacker) then
		attacker = CastToDetpack(attacker)
		player_attacker = attacker:GetOwner()
	elseif IsDispenser(attacker) then
		attacker = CastToDispenser(attacker)
		player_attacker = attacker:GetOwner()
	else
		return
	end

	-- if still no attacking player after all that, forget about it
	if not player_attacker then return end

  -- If player killed self or teammate do nothing
  if (player:GetId() == player_attacker:GetId()) or (player:GetTeamId() == player_attacker:GetTeamId()) then
	return 
  end
  
  -- If player is an attacker, then do stuff
  if player:GetTeamId() == attackers then
	-- Check if he's in the cap point
	for playerx in zone_collection.items do
      playerx = CastToPlayer(playerx)

      if playerx:GetId() == player:GetId() then
	    if (damage > 100) then damage = 100 end
		player_attacker:AddFortPoints( damage, "Protecting the Point" ) 
		return
	  end
   end
   
  end
  
end

-----------------------------------------------------------------------------
-- on cap
-----------------------------------------------------------------------------

function zone_cap( cap_phase )
	zone_collection:RemoveAllItems()
	zone_turnoff( phase )
	
	zone_points = 0
	
	-- reset touches
	for playerx, recordx in pairs(playerTouchedTable) do
		if GetPlayerByID( playerx ) then
			local playert = GetPlayerByID( playerx )
			if ( playert:GetTeamId() == attackers ) then
				-- add to table and reset touched to 0
				playerTouchedTable[playert:GetId()] = {touched = false, allowed = true}
			end
		end
	end
	
	draw_hud = false
	
	if phase == NUMBER_OF_CAP_POINTS then
		onreset_outputs()
		-- it's the last round. end and stuff
		phase = 1
		-- run custom round reset stuff
		AddSchedule( "onroundreset_sched", DELAY_BEFORE_TEAMSWITCH, onroundreset )
	else
		oncap_outputs()
		phase = phase + 1
		AddSchedule( "aftercap_sched", DELAY_AFTER_CAP, oncap_outputs_nextphase )
		
		
		AddSchedule( "aftercap_sched2", DELAY_AFTER_CAP, oncap_nextphase )
	end
	
	update_zone_all( )
	
end


-----------------------------------------------------------------------------
-- round functions
-----------------------------------------------------------------------------

-- Opens the gates and schedules the round's end.
function round_start()
	-- Opens the gates and all that lovely stuff
	OpenDoor("frontgate")
	BroadCastMessage( "#FF_AD_GATESOPEN" )
	BroadCastSound( "otherteam.flagstolen" )
	SpeakAll( "AD_GATESOPEN" )
	
	openstartdoor()
end

-- Checks to see if it's the first or second round, then either swaps teams, or ends the game.
function onroundreset()

	if attackers == Team.kBlue then
		attackers = Team.kRed
		defenders = Team.kBlue
		
		onswitch_bluetodef()
	else
		attackers = Team.kBlue
		defenders = Team.kRed
		
		onswitch_redtodef()
	end

	-- objective icon
	UpdateTeamObjectiveIcon( GetTeam(attackers), nil )
	UpdateTeamObjectiveIcon( GetTeam(defenders), nil )
	
	-- switch them team names
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	
	-- reset them limits
	team = GetTeam(defenders)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kScout, -1)
	team:SetClassLimit(Player.kMedic, -1)
	
	team = GetTeam(attackers)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)

	-- reset schedules
	AddSchedule( "round_start", INITIAL_ROUND_PERIOD, round_start)
	
	-- reset player touched table
	playerTouchedTable = {}
	-- remove all leftovers from the cap point collection
	zone_collection:RemoveAllItems()
	-- respawn the players
	RespawnAllPlayers()
	
	-- MORE scheduled message loveliness.
	if INITIAL_ROUND_PERIOD > 30 then AddSchedule( "dooropen30sec" , INITIAL_ROUND_PERIOD - 30 , schedulemessagetoall, "#ADZ_30SecWarning" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10sec" , INITIAL_ROUND_PERIOD - 10 , schedulemessagetoall, "#ADZ_10SecWarning" ) end
	
	-- sounds
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen30secsound" , INITIAL_ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10secsound" , INITIAL_ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5seccount" , INITIAL_ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4seccount" , INITIAL_ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3seccount" , INITIAL_ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2seccount" , INITIAL_ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1seccount" , INITIAL_ROUND_PERIOD - 1 , schedulecountdown, 1 ) end
	
	DeleteSchedule( "defense_period_scoring_sched" )
	AddScheduleRepeating( "defense_period_scoring_sched", DEFENSE_PERIOD_TIME, defenders_scoring )
	
	draw_hud = true
	update_zone_all( )
	
	onswitch()
end


-----------------------------------------------------------------------------
-- zone functions
-----------------------------------------------------------------------------

function zone_turnon( cp_num )
	zone_on_outputs()
	
	-- init scoring
	AddSchedule( "period_init", DELAY_BEFORE_PERIOD_POINTS, init_scoring, team )
	AddSchedule( "period_init_alarm", DELAY_BEFORE_PERIOD_POINTS - 1, init_scoring_alarm )
end
function zone_turnoff( cp_num )
	zone_off_outputs()
	
	-- stop scoring
	zone_scoring = false
end
function oncap_nextphase()
	draw_hud = true
	update_zone_all( )
	
	-- update objective icon
	local attackers_objective = GetEntityByName( "zone"..phase )
	UpdateTeamObjectiveIcon( GetTeam(attackers), attackers_objective )
	UpdateTeamObjectiveIcon( GetTeam(defenders), nil )
end

-----------------------------------------------------------------------------
-- output functions
-----------------------------------------------------------------------------

function zone_on_outputs() 
	return 
end
function zone_off_outputs() 
	return 
end
function onswitch_bluetodef() 
	return 
end
function onswitch_redtodef() 
	return 
end
function onswitch()
	return 
end
function openstartdoor() 
	return 
end
function oncap_outputs() 
	return 
end
function oncap_outputs_nextphase() 
	return 
end
function onreset_outputs()
	return 
end

-----------------------------------------------------------------------------
-- hud
-----------------------------------------------------------------------------

function update_zone_all( )
	
	RemoveHudItemFromAll( "Zone_Status" )
	RemoveHudItemFromAll( "Zone_Status_BG" )
	RemoveHudItemFromAll( "Zone_Status_Points" )
	RemoveHudItemFromAll( "Zone_Team"..attackers )
	RemoveHudItemFromAll( "Zone_Team"..defenders )
	RemoveHudItemFromAll( "Zone_Team_Text"..attackers )
	RemoveHudItemFromAll( "Zone_Team_Text"..defenders )
	
	if draw_hud then
		AddHudIconToAll( "hud_statusbar_256.vtf", "Zone_Status_BG", -64, 36, 128, 16, 3 )
		AddHudTextToTeam( GetTeam(attackers), "Zone_Team_Text"..attackers, "Attacking Zone "..phase, 33, 56, 4, 0 )
		AddHudTextToTeam( GetTeam(defenders), "Zone_Team_Text"..defenders, "Defending Zone "..phase, 33, 56, 4, 0 )
		AddHudTextToAll( "Zone_Status_Points", zone_points.." / "..zone_max_points, 40, 56, 2, 0 )
		
		AddHudIconToTeam( GetTeam(attackers), "hud_offense.vtf", "Zone_Team"..attackers, -92, 38, 24, 24, 3 )
		AddHudIconToTeam( GetTeam(defenders), "hud_defense.vtf", "Zone_Team"..defenders, -92, 38, 24, 24, 3 )
		
		local max_width = 124
		if zone_points > 0 then
		
			bar_width = zone_points / zone_max_points * max_width
		
			if zone_collection:Count() > 0 then
				AddHudIconToAll( "hud_statusbar_"..ZONE_COLOR.."_active.vtf", "Zone_Status", -62, 36, math.floor(bar_width), 16, 3 )
			else
				AddHudIconToAll( "hud_statusbar_"..ZONE_COLOR..".vtf", "Zone_Status", -62, 36, math.floor(bar_width), 16, 3 )
			end
			
		end
	end
end

function update_zone_player( player )
	RemoveHudItem( player, "Zone_Status" )
	RemoveHudItem( player, "Zone_Status_BG" )
	RemoveHudItem( player, "Zone_Status_Points" )
	RemoveHudItem( player, "Zone_Team"..attackers )
	RemoveHudItem( player, "Zone_Team"..defenders )
	RemoveHudItem( player, "Zone_Team_Text"..attackers )
	RemoveHudItem( player, "Zone_Team_Text"..defenders )
	
	if draw_hud then
		AddHudIcon( player, "hud_statusbar_256.vtf", "Zone_Status_BG", -64, 36, 128, 16, 3 )
		AddHudText( player, "Zone_Status_Points", zone_points.." / "..zone_max_points, 40, 56, 2, 0 )
		
		if player:GetTeamId() == attackers then
			AddHudIcon( player, "hud_offense.vtf", "Zone_Team"..attackers, -92, 38, 24, 24, 3 )
			AddHudText( player, "Zone_Team_Text"..attackers, "Attacking Zone "..phase, 33, 56, 4, 0 )
		else
			AddHudIcon( player, "hud_defense.vtf", "Zone_Team"..defenders, -92, 38, 24, 24, 3 )
			AddHudText( player, "Zone_Team_Text"..defenders, "Defending Zone "..phase, 33, 56, 4, 0 )
		end
		
		local max_width = 124
		if zone_points > 0 then
		
			bar_width = zone_points / zone_max_points * max_width
		
			if zone_collection:Count() > 0 then
				AddHudIcon( player, "hud_statusbar_"..ZONE_COLOR.."_active.vtf", "Zone_Status", -62, 36, math.floor(bar_width), 16, 3 )
			else
				AddHudIcon( player, "hud_statusbar_"..ZONE_COLOR..".vtf", "Zone_Status", -62, 36, math.floor(bar_width), 16, 3 )
			end
			
		end
	end
end

-----------------------------------------------------------------------------
-- base_zone_trigger
-----------------------------------------------------------------------------

-- capture room
base_zone_trigger = trigger_ff_script:new({ phase = 0, pointstocap = DEFAULT_POINTS_TO_CAP })

zone1 = base_zone_trigger:new({phase=1})
zone2 = base_zone_trigger:new({phase=2})
zone3 = base_zone_trigger:new({phase=3})
zone4 = base_zone_trigger:new({phase=4})
zone5 = base_zone_trigger:new({phase=5})
zone6 = base_zone_trigger:new({phase=6})
zone7 = base_zone_trigger:new({phase=7})
zone8 = base_zone_trigger:new({phase=8})

-- registers attackers as they enter the cap room
function base_zone_trigger:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then

		local player = CastToPlayer( trigger_entity )
		
		if phase ~= self.phase then return end
		if player:GetTeamId() == defenders then return end
		
		player:SetCloakable( false )
		player:SetDisguisable( false )
		
		update_zone_all( )
		
		local playerid = player:GetId()
		zone_collection:AddItem( player )
		
		local team = GetTeam(attackers)
		-- if it's the first touch, give points and stuff
		if playerTouchedTable[playerid].touched == false then
			team:AddScore( POINTS_PER_INITIAL_TOUCH )
			player:AddFortPoints( FORT_POINTS_PER_INITIAL_TOUCH, "Initial Point Touch" ) 
			
			zone_points = zone_points + POINTS_PER_INITIAL_TOUCH
			update_zone_all( )
			
			if zone_points >= self.pointstocap then
				zone_cap( self.phase )
				return
			end
			
			SmartTeamSound( GetTeam(defenders), "yourteam.flagreturn", "misc.doop" )
			
			playerTouchedTable[playerid].touched = true
			
		elseif zone_collection:Count() == 1 then
			SmartTeamSound( GetTeam(defenders), "otherteam.drop", nil )
		end
		if zone_collection:Count() == 1 then
			-- activate the cap point, bro
			update_zone_all( )
			zone_turnon( self.phase )
		end
		
	end
end

-- deregisters attackers as they enter the cap room. Checks to see if all attackers have left.
function base_zone_trigger:onendtouch( trigger_entity )

	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		if player:GetTeamId() == defenders then return end

		player:SetCloakable( true )
		player:SetDisguisable( true )
		
		zone_collection:RemoveItem( player )

		local team = GetTeam(defenders)
		if zone_collection:Count() == 0 then
			update_zone_all(  )
			zone_turnoff( self.phase )
		end
	end
end

-- empties the collection if no-one in in the room. Shouldn't really be nessecary.
function base_zone_trigger:oninactive()
	-- Clear out the flags in the collection
	DeleteSchedule( "period_scoring" )
	DeleteSchedule( "period_init" )
	DeleteSchedule( "period_init_alarm" )
	zone_collection:RemoveAllItems()
	update_zone_status( false )
	zone_turnoff( self.phase )
end

-----------------------------------------------------------------------------
-- scoring
-----------------------------------------------------------------------------

-- Adds points based on time inside cap room and number of attackers inside cap room
function period_scoring( )
	if zone_scoring then
		local team = GetTeam( attackers )
		team:AddScore( POINTS_PER_PERIOD )
		zone_points = zone_points + POINTS_PER_PERIOD
		update_zone_all( )
		SmartTeamSound( GetTeam(defenders), "yourteam.flagreturn", "misc.doop" )
		
		for player in zone_collection.items do
	      player = CastToPlayer(player)

	      if player ~= nil then
	         player:AddFortPoints( FORT_POINTS_PER_PERIOD, "Touching the Point" ) 
	      else
	         ConsoleToAll("LUA ERROR: player_addfortpoints: Unable to find player")
	      end
	   end
	end
	-- cap zone if the points say to
	if zone_points >= zone_max_points then 
		zone_cap( phase ) 
	end
end

-- Initializes the period_scoring (allows for a delay after initial touch)
function init_scoring( team )
	if zone_collection:Count() > 0 then
		zone_scoring = true
	end
end

-- Initializes the period_scoring (allows for a delay after initial touch)
function init_scoring_alarm( )
	if zone_collection:Count() > 0 then
		SmartTeamSound( GetTeam(defenders), "otherteam.drop", nil )
	end
end

-- Adds points based on time inside cap room and number of attackers inside cap room
function defenders_scoring( )
	local team = GetTeam( defenders )
	team:AddScore( POINTS_PER_DEFENSE_PERIOD )
end

-----------------------------------------------------------------------------
-- misc functions
-----------------------------------------------------------------------------

-- Sends a message to all after the determined time
function schedulechangemessage( player, message )
	if (player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic) and (player:GetTeamId() == defenders) then
		BroadCastMessageToPlayer( player, message )
	end
end

-- reset everything
function RespawnAllPlayers()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end

-- force a scout/med to switch to soli if they haven't
function forcechange( player )
	if (player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic) and (player:GetTeamId() == defenders) then
		ApplyToPlayer( player, { AT.kChangeClassSoldier, AT.kRespawnPlayers } )
	end
end

-- Sends a message to all after the determined time
function schedulemessagetoall( message )
	BroadCastMessage( message )
end

-- Plays a sound to all after the determined time
function schedulesound( sound )
	BroadCastSound( sound )
end


function schedulecountdown( time )
	BroadCastMessage( ""..time.."" )
	SpeakAll( "AD_" .. time .. "SEC" )
end

-----------------------------------------------------------------------------
-- Entity definitions (flags/command points/backpacks etc.)
-----------------------------------------------------------------------------

-- respawns
base_attacker_spawn = info_ff_teamspawn:new({ phase = 0, validspawn = function(self,player)
	return player:GetTeamId() == attackers and phase == self.phase
end })
base_defender_spawn = info_ff_teamspawn:new({ phase = 0, validspawn = function(self,player)
	return player:GetTeamId() == defenders and phase == self.phase
end })
zone1_attacker = base_attacker_spawn:new({phase=1})
zone2_attacker = base_attacker_spawn:new({phase=2})
zone3_attacker = base_attacker_spawn:new({phase=3})
zone4_attacker = base_attacker_spawn:new({phase=4})
zone5_attacker = base_attacker_spawn:new({phase=5})
zone6_attacker = base_attacker_spawn:new({phase=6})
zone7_attacker = base_attacker_spawn:new({phase=7})
zone8_attacker = base_attacker_spawn:new({phase=8})
zone1_defender = base_defender_spawn:new({phase=1})
zone2_defender = base_defender_spawn:new({phase=2})
zone3_defender = base_defender_spawn:new({phase=3})
zone4_defender = base_defender_spawn:new({phase=4})
zone5_defender = base_defender_spawn:new({phase=5})
zone6_defender = base_defender_spawn:new({phase=6})
zone7_defender = base_defender_spawn:new({phase=7})
zone8_defender = base_defender_spawn:new({phase=8})

-- generic respawns
attacker_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == attackers
end })
defender_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == defenders
end })

-----------------------------------------------------------------------------
-- Generic Backpack
-----------------------------------------------------------------------------
genericbackpack = info_ff_script:new({
	health = 0,
	armor = 0,
	grenades = 0,
	shells = 0,
	nails = 0,
	rockets = 0,
	cells = 0,
	detpacks = 0,
	mancannons = 0,
	gren1 = 0,
	gren2 = 0,
	respawntime = 5,
	model = "models/items/healthkit.mdl",
	materializesound = "Item.Materialize",
	touchsound = "HealthKit.Touch",
	notallowedmsg = "#FF_NOTALLOWEDPACK",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen}
})

function genericbackpack:dropatspawn() return false end

function genericbackpack:precache( )
	-- precache sounds
	PrecacheSound(self.materializesound)
	PrecacheSound(self.touchsound)

	-- precache models
	PrecacheModel(self.model)
end

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
				backpack:EmitSound(self.touchsound);
				backpack:Respawn(self.respawntime);
			end
		end
	end
end

function genericbackpack:materialize( )
	entity:EmitSound(self.materializesound)
end

-- from http://www.lua.org/pil/14.1.html
function getfield (f)
  local v = _G    -- start with the table of globals
  for w in string.gmatch(f, "[%w_]+") do
	v = v[w]
  end
  return v
end
function setfield (f, v)
  local t = _G    -- start with the table of globals
  for w, d in string.gmatch(f, "([%w_]+)(.?)") do
	if d == "." then      -- not last field?
	  t[w] = t[w] or {}   -- create table if absent
	  t = t[w]            -- get the table
	else                  -- last field
	  t[w] = v            -- do the assignment
	end
  end
end