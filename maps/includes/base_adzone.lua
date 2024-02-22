
-- base_adzone.lua
-- Attack and Defend the Zone gametype 

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
FLAG_RETURN_TIME = 0
INITIAL_ROUND_PERIOD = 60

DELAY_BEFORE_DEFENSE_PERIOD_SCORING = 30
DEFENSE_PERIOD_TIME = 10
POINTS_PER_DEFENSE_PERIOD = POINTS_PER_PERIOD -- same as attackers
POINTS_PER_DEFENSE_60SEC_BONUS = POINTS_PER_PERIOD * 5 -- attackers period points * 5
POINTS_PER_DEFENSE_SHUTOUT = POINTS_PER_DEFENSE_60SEC_BONUS * 10 --default, not used if GET_ROUND_PERIOD_FROM_TIMELIMIT is set to true

ATTACKERS_OBJECTIVE_ENTITY = nil
DEFENDERS_OBJECTIVE_ENTITY = nil
ENABLE_ATTACKERS_OBJECTIVE = true -- puts attackers objective on the zone
ENABLE_DEFENDERS_OBJECTIVE = true -- puts defenders objective on the zone

GET_ROUND_PERIOD_FROM_TIMELIMIT = true
NUMBER_OF_ROUNDS = 4
ROUND_PERIOD = 600 --default, not used if GET_ROUND_PERIOD_FROM_TIMELIMIT is set to true

ZONE_COLOR = "green"

USE_ZONE_AREA = true

NUM_DEFENDER_ONLY_PACKS = 0

-----------------------------------------------------------------------------
-- global variables and other shit that shouldn't be messed with
-----------------------------------------------------------------------------

phase = 1
zone_status = false
zone_area_status = false
gates_open = false

current_timer = DELAY_BEFORE_DEFENSE_PERIOD_SCORING
current_seconds = 0

attackers = Team.kBlue
defenders = Team.kRed

scoring_team = Team.kRed

local teamdata = {
	[Team.kBlue] = { skin = "0", beamcolour = "0 0 255" },
	[Team.kRed] = { skin = "1", beamcolour = "255 0 0" }
}

-- stores attackers in the zone
local zone_collection = Collection()
-- stores attackers in the zone area
local zone_area_collection = Collection()
-- stores if the player has touched the cap point (for 1 touch per death)
local playerTouchedTable = {}

-----------------------------------------------------------------------------
-- Entity definitions (flags/command points/backpacks etc.)
-----------------------------------------------------------------------------

-- zone
base_zone_trigger = trigger_ff_script:new({})
zone = base_zone_trigger:new({})

-- area around zone
base_zone_area_trigger = trigger_ff_script:new({})
zone_area = base_zone_area_trigger:new({})

-- respawns
attacker_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == attackers
end })
defender_spawn = info_ff_teamspawn:new({ validspawn = function(self,player)
	return player:GetTeamId() == defenders
end })


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

	SetGameDescription( "Attack Defend the Zone" )
	
	-- set up team limits on each team
	SetPlayerLimit( Team.kBlue, 0 )
	SetPlayerLimit( Team.kRed, 0 )
	SetPlayerLimit( Team.kYellow, -1 )
	SetPlayerLimit( Team.kGreen, -1 )

	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	
	-- set class limits
	set_classlimits()
	
	AddSchedule( "round_start", INITIAL_ROUND_PERIOD, round_start)
	if INITIAL_ROUND_PERIOD > 30 then AddSchedule( "dooropen30sec" , INITIAL_ROUND_PERIOD - 30 , schedulemessagetoall, "#ADZ_30SecWarning" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10sec" , INITIAL_ROUND_PERIOD - 10 , schedulemessagetoall, "#ADZ_10SecWarning" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5sec" , INITIAL_ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4sec" , INITIAL_ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3sec" , INITIAL_ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2sec" , INITIAL_ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1sec" , INITIAL_ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
	
	-- sounds
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen30secsound" , INITIAL_ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10secsound" , INITIAL_ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5seccount" , INITIAL_ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4seccount" , INITIAL_ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3seccount" , INITIAL_ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2seccount" , INITIAL_ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1seccount" , INITIAL_ROUND_PERIOD - 1 , schedulecountdown, 1 ) end
	
	-- get round times if its set to
	if GET_ROUND_PERIOD_FROM_TIMELIMIT == true then
		local timelimit = GetConvar( "mp_timelimit" )
		-- convert mp_timelimit from minutes to seconds and divide by the number of rounds minus initial round period
		ROUND_PERIOD = timelimit * 60 / NUMBER_OF_ROUNDS - INITIAL_ROUND_PERIOD - 1
		POINTS_PER_DEFENSE_SHUTOUT = ROUND_PERIOD / ( 3 / ( POINTS_PER_DEFENSE_PERIOD / 4 ) )
		-- now lock mp_timelimit, so things don't get weird
		AddScheduleRepeating( "set_cvar-mp_timelimit", 1, set_cvar, "mp_timelimit", timelimit )
	end
	
	if ENABLE_ATTACKERS_OBJECTIVE then ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "zone" ) end
	if ENABLE_DEFENDERS_OBJECTIVE then DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName( "zone" ) end
	
	custom_startup()
	
	current_timer = INITIAL_ROUND_PERIOD
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )
	
	update_zone_text( nil )
	update_zone_status( false )
end

-----------------------------------------------------------------------------
-- player_ functions
-----------------------------------------------------------------------------

-- spawns attackers with flags
function player_spawn( player_entity )

	local player = CastToPlayer( player_entity )
	
	player:AddHealth( 100 )
	player:AddArmor( 300 )

	player:AddAmmo( Ammo.kNails, 400 )
	player:AddAmmo( Ammo.kShells, 400 )
	player:AddAmmo( Ammo.kRockets, 400 )
	player:AddAmmo( Ammo.kCells, 400 )
	
	player:SetCloakable( true )
	player:SetDisguisable( true )
	
	-- nade/detpack limits
	set_itemlimits( player )

	-- wtf, scout or med on d? are you mental?
	if (player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic) and (player:GetTeamId() == defenders) then
		local classt = "Scout"
		if player:GetClass() == Player.kMedic then classt = "Medic" end
		local id = player:GetId()
		AddSchedule("force_changemessage"..id, 2, schedulechangemessage, player, "No "..classt.."s on defense. Autoswitching to Soldier." )
		AddSchedule("force_change"..id, 2, forcechange, player)
	end
	
	-- objective icon
	if player:GetTeamId() == attackers then
		UpdateObjectiveIcon( player, ATTACKERS_OBJECTIVE_ENTITY )
	elseif player:GetTeamId() == defenders then
		UpdateObjectiveIcon( player, DEFENDERS_OBJECTIVE_ENTITY )
	end
	
	-- remove any players not on a team from playertouchedtable
	for playerx, recordx in pairs(playerTouchedTable) do
		if GetPlayerByID( playerx ) then
			local playert = GetPlayerByID( playerx )
			if playert:GetTeamId() ~= attackers then
				playerTouchedTable[playerx] = nil
			end
		end
	end
	
	if player:GetTeamId() ~= attackers then return end
	
	-- add to table and reset touched to 0
	playerTouchedTable[player:GetId()] = {touched = false, allowed = true, points = 0}
	
end

function player_killed( player, damageinfo )

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
		-- show scored points
		BroadCastMessageToPlayer( player, "You scored "..playerTouchedTable[player:GetId()].points.." team points that run" )
		AddScheduleRepeatingNotInfinitely( "timer_return_schedule", .5, BroadCastMessageToPlayer, 4, player, "You scored "..playerTouchedTable[player:GetId()].points.." team points that run")
		-- Check if he's in the zone
		for playerx in zone_collection.items do
			playerx = CastToPlayer(playerx)
			if playerx:GetId() == player:GetId() then
				player_attacker:AddFortPoints( FORT_POINTS_PER_DEFEND, "Defending the Zone" ) 
				return
			end
		end
		-- Check if he's in the zone area
		for playerx in zone_area_collection.items do
			playerx = CastToPlayer(playerx)
			if playerx:GetId() == player:GetId() then
				if playerTouchedTable[player:GetId()].touched == false then
					player_attacker:AddFortPoints( FORT_POINTS_PER_DEFEND * 2, "Denying Attacker from Scoring" ) 
				else
					player_attacker:AddFortPoints( FORT_POINTS_PER_DEFEND / 2, "Defending the Zone Area" )
				end
				return
			end
		end
	end
  
end

function player_ondamage( player, damageinfo )

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
  
	-- If player (victim) is an attacker, then do stuff
	if player:GetTeamId() == attackers then
		-- Check if he's in the zone
		for playerx in zone_collection.items do
			playerx = CastToPlayer(playerx)
			if playerx:GetId() == player:GetId() then
				if (damage > 100) then damage = 100 end
				player_attacker:AddFortPoints( damage, "Protecting the Zone" ) 
				return
			end
		end
		-- Check if he's in the zone area
		for playerx in zone_area_collection.items do
			playerx = CastToPlayer(playerx)
			if playerx:GetId() == player:GetId() then
				if (damage > 50) then damage = 50 end
				player_attacker:AddFortPoints( damage, "Protecting the Zone Area" ) 
				return
			end
		end
	end
  
end

-----------------------------------------------------------------------------
-- zone triggers
-----------------------------------------------------------------------------

-- only attackers!
function base_zone_trigger:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == attackers then
			if not gates_open then return EVENT_DISALLOWED end
			return EVENT_ALLOWED
		end
		if player:GetTeamId() == defenders then 
			BroadCastMessageToPlayer( player, "ADZ_Defend" )
			return EVENT_DISALLOWED
		end
	end
	return EVENT_DISALLOWED
end

-- registers attackers as they enter the zone
function base_zone_trigger:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		
		player:SetCloakable( false )
		player:SetDisguisable( false )
		
		local playerid = player:GetId()
		zone_collection:AddItem( player )
		
		local team = GetTeam(attackers)
		-- if it's the first touch, give points and stuff
		if playerTouchedTable[playerid].touched == false then
			team:AddScore( POINTS_PER_INITIAL_TOUCH )
			player:AddFortPoints( FORT_POINTS_PER_INITIAL_TOUCH, "Initial Point Touch" ) 
		
			RemoveSchedule( "shutout" ) -- O scores, no D shutout (put in all O scoring spots for safety, haha)
			
			SmartTeamSound( GetTeam(defenders), "yourteam.flagreturn", "misc.doop" )
			
			playerTouchedTable[playerid].touched = true
			playerTouchedTable[playerid].points = playerTouchedTable[playerid].points + POINTS_PER_INITIAL_TOUCH
			
			if zone_collection:Count() == 1 then
				AddSchedule( "period_init", DELAY_BEFORE_PERIOD_POINTS, init_scoring, team )
			end
		elseif zone_collection:Count() == 1 then
			SmartTeamSound( GetTeam(defenders), "otherteam.drop", nil )
		end
		if zone_collection:Count() == 1 then
			-- activate the cap point, bro
			zone_turnon()
		end
		
		update_zone_status( true )
		
	end
end

-- deregisters attackers as they leave the zone
function base_zone_trigger:onendtouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )

		player:SetCloakable( true )
		player:SetDisguisable( true )
		
		zone_collection:RemoveItem( player )
	end
end

-- clear collection and start defender points when everyone's left
function base_zone_trigger:oninactive( )
	-- Clear out the flags in the collection
	zone_collection:RemoveAllItems()
	init_defender_countdown()
	zone_turnoff()
	update_zone_status( false )
end

-----------------------------------------------------------------------------
-- zone area triggers
-----------------------------------------------------------------------------

-- only attackers!
function base_zone_area_trigger:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == attackers then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

-- registers attackers as they enter the zone area
function base_zone_area_trigger:ontouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetTeamId() == defenders then return end
		update_zone_area_status( true )
		zone_area_collection:AddItem( player )
	end
end

-- registers attackers as they enter the zone area
function base_zone_area_trigger:onendtouch( trigger_entity )
	if IsPlayer( trigger_entity ) then
		local player = CastToPlayer( trigger_entity )
		if player:GetTeamId() == defenders then return end
		zone_area_collection:RemoveItem( player )
	end
end

-- updates the hud if no one is in the zone area.
function base_zone_area_trigger:oninactive()
	update_zone_area_status( false )
	zone_area_collection:RemoveAllItems()
end


-----------------------------------------------------------------------------
-- zone functions
-----------------------------------------------------------------------------

function update_zone_status( on )
	RemoveHudItemFromAll( "Zone_Status" )
	if on then
		AddHudIconToAll( "hud_zone_on_"..ZONE_COLOR..".vtf", "Zone_Status", -64, 32, 88, 88, 3 )
		zone_status = true;
	else
		AddHudIconToAll( "hud_zone_off.vtf", "Zone_Status", -64, 32, 88, 88, 3 )
		zone_status = false;
	end
	update_zone_text( nil )
end

function update_zone_area_status( on )
	if USE_ZONE_AREA then
		RemoveHudItemFromAll( "Zone_Area_Status" )
		if on then
			AddHudIconToAll( "hud_zone_area_active_"..ZONE_COLOR..".vtf", "Zone_Area_Status", -56, 40, 72, 72, 3 )
			zone_area_status = true;
		else
			AddHudIconToAll( "hud_zone_area_inactive.vtf", "Zone_Area_Status", -56, 40, 72, 72, 3 )
			zone_area_status = false;
		end
	end
end

function flaginfo( player_entity )
	local player = CastToPlayer( player_entity )
	RemoveHudItem( player, "Zone_Status" )
	RemoveHudItem( player, "Zone_Area_Status" )
	if USE_ZONE_AREA then
		if zone_area_status then
			AddHudIcon( player, "hud_zone_area_active_"..ZONE_COLOR..".vtf", "Zone_Area_Status", -56, 40, 72, 72, 3 )
		else
			AddHudIcon( player, "hud_zone_area_inactive.vtf", "Zone_Area_Status", -56, 40, 72, 72, 3 )
		end
	end
	if zone_status then
		AddHudIcon( player, "hud_zone_on_"..ZONE_COLOR..".vtf", "Zone_Status", -64, 32, 88, 88, 3 )
	else
		AddHudIcon( player, "hud_zone_off.vtf", "Zone_Status", -64, 32, 88, 88, 3 )
	end
	update_zone_text( player )
	update_round_info( player )
end

function zone_turnon( )
	zone_on_outputs()
	
	-- init attacker scoring
	AddSchedule( "period_init", DELAY_BEFORE_PERIOD_POINTS, init_scoring, team )
	AddSchedule( "period_init_alarm", DELAY_BEFORE_PERIOD_POINTS - 1, init_scoring_alarm )
	-- stop defender point countdown
	DeleteSchedule( "timer_schedule" )
	RemoveSchedule( "defenders_period_scoring" )
	RemoveSchedule( "init_defenders_period_scoring" )
end
function zone_turnoff( )
	zone_off_outputs()
	
	-- stop attacker scoring
	DeleteSchedule( "period_init" )
	DeleteSchedule( "period_init_alarm" )
	DeleteSchedule( "period_scoring" )
	zone_scoring = false
end

function update_zone_text( player )
	local text_align = 4
	local text_x = 40
	local text_line1y = 84
	local text_line2y = text_line1y + 8
	local text_line3y = text_line2y + 8
	
	if IsPlayer( player ) then
		-- defender period scoring text and timer
		RemoveHudItem(player, "defender_points_timer")
		RemoveHudItem(player, "defender_points_text")
		RemoveHudItem(player, "defender_points_text2")
		-- attackers in the zone text
		RemoveHudItem(player, "attackers_in_text")
		RemoveHudItem(player, "attackers_in_text2")
		RemoveHudItem(player, "attackers_in_text3")
		-- gates open in text and timer
		RemoveHudItem(player, "gates_open_text")
		RemoveHudItem(player, "gates_open_text2")
		RemoveHudItem(player, "gates_open_timer")
		if gates_open == true then
			if not zone_status then
				AddHudText( player, "defender_points_text", "#FF_Defenders", text_x, text_line1y, text_align )
				AddHudText( player, "defender_points_text2", "#ADZ_ScoreNotice", text_x, text_line2y, text_align )
				AddHudTimer( player, "defender_points_timer", current_timer, -1, text_x, text_line3y, text_align )
			else
				AddHudText( player, "attackers_in_text", "#FF_Attackers", text_x, text_line1y, text_align )
				AddHudText( player, "attackers_in_text2", "#ADZ_AreIn", text_x, text_line2y, text_align )
				AddHudText( player, "attackers_in_text3", "#ADZ_TheZone", text_x, text_line3y, text_align )
			end
		else
			AddHudText( player, "gates_open_text", "#ADZ_GATES", text_x, text_line1y, text_align )
			AddHudText( player, "gates_open_text2", "#ADZ_OPENIN", text_x, text_line2y, text_align )
			AddHudTimer( player, "gates_open_timer", current_timer, -1, text_x, text_line3y, text_align )
		end
	else
		-- defender period scoring text and timer
		RemoveHudItemFromAll("defender_points_timer")
		RemoveHudItemFromAll("defender_points_text")
		RemoveHudItemFromAll("defender_points_text2")
		-- attackers in the zone text
		RemoveHudItemFromAll("attackers_in_text")
		RemoveHudItemFromAll("attackers_in_text2")
		RemoveHudItemFromAll("attackers_in_text3")
		-- gates open in text and timer
		RemoveHudItemFromAll("gates_open_text")
		RemoveHudItemFromAll("gates_open_text2")
		RemoveHudItemFromAll("gates_open_timer")
		if gates_open == true then
			if not zone_status then
				AddHudTextToAll( "defender_points_text", "#FF_Defenders", text_x, text_line1y, text_align )
				AddHudTextToAll( "defender_points_text2", "#ADZ_ScoreNotice", text_x, text_line2y, text_align )
				AddHudTimerToAll( "defender_points_timer", current_timer, -1, text_x, text_line3y, text_align )
			else
				AddHudTextToAll( "attackers_in_text", "#FF_Attackers", text_x, text_line1y, text_align )
				AddHudTextToAll( "attackers_in_text2", "#ADZ_AreIn", text_x, text_line2y, text_align )
				AddHudTextToAll( "attackers_in_text3", "#ADZ_TheZone", text_x, text_line3y, text_align )
			end
		else
			AddHudTextToAll( "gates_open_text", "#ADZ_GATES", text_x, text_line1y, text_align )
			AddHudTextToAll( "gates_open_text2", "#ADZ_OPENIN", text_x, text_line2y, text_align )
			AddHudTimerToAll( "gates_open_timer", current_timer, -1, text_x, text_line3y, text_align )
		end
	end
end

function update_round_info( player )
	
	RemoveHudItem( player, "Zone_Round" )
	RemoveHudItem( player, "Zone_Team"..attackers )
	RemoveHudItem( player, "Zone_Team"..defenders )
	RemoveHudItem( player, "Zone_Phase"..attackers )
	RemoveHudItem( player, "Zone_Phase"..defenders )
	
	od_hudstatusiconx = 28
	od_hudstatusicony = 48
	od_hudstatusiconw = 24
	od_hudstatusiconh = 24
	od_hudstatusiconalign = 3
	
	AddHudText( player, "Zone_Round", "#ADZ_Round", od_hudstatusiconx + od_hudstatusiconw / 2, od_hudstatusicony - 10, 4 )
	if player:GetTeamId() == attackers then
		AddHudIcon( player, "hud_offense.vtf", "Zone_Team"..attackers, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
		AddHudIcon( player, "hud_cp_"..phase..".vtf", "Zone_Phase"..attackers, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	elseif player:GetTeamId() == defenders then
		AddHudIcon( player, "hud_defense.vtf", "Zone_Team"..defenders, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
		AddHudIcon( player, "hud_cp_"..phase..".vtf", "Zone_Phase"..defenders, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	end
	
end

function init_defender_countdown()
	-- init defender scoring
	current_timer = DELAY_BEFORE_DEFENSE_PERIOD_SCORING
	RemoveSchedule( "timer_schedule" )
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )
	AddSchedule( "init_defenders_period_scoring", current_timer, init_defenders_period_scoring )
end

-----------------------------------------------------------------------------
-- Scheduled functions that do stuff
-----------------------------------------------------------------------------

-- Sends a message to all after the determined time
function schedulechangemessage( player, message )
	if (player:GetClass() == Player.kScout or player:GetClass() == Player.kMedic) and (player:GetTeamId() == defenders) then
		BroadCastMessageToPlayer( player, message )
	end
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

function timer_schedule()
	current_timer = current_timer -1
end

-----------------------------------------------------------------------------
-- Scoring
-----------------------------------------------------------------------------

-- Adds points based on time inside cap room and number of attackers inside cap room
function period_scoring( team )
	team:AddScore( POINTS_PER_PERIOD )
	SmartTeamSound( GetTeam(defenders), "yourteam.flagreturn", "misc.doop" )
	
	for player in zone_collection.items do
      player = CastToPlayer(player)

      if player ~= nil then
        player:AddFortPoints( FORT_POINTS_PER_PERIOD, "Touching the Point" ) 
		playerTouchedTable[player:GetId()].points = playerTouchedTable[player:GetId()].points + POINTS_PER_PERIOD
      else
         ConsoleToAll("LUA ERROR: player_addfortpoints: Unable to find player")
      end
   end
end

-- Initializes the period_scoring (allows for a delay after initial touch)
function init_scoring( team )
	if zone_collection:Count() > 0 then
		team:AddScore( POINTS_PER_PERIOD )
		AddScheduleRepeating( "period_scoring", PERIOD_TIME, period_scoring, team)
		
		for player in zone_collection.items do
		  player = CastToPlayer(player)
		  if player ~= nil then
			player:AddFortPoints( FORT_POINTS_PER_PERIOD, "Touching the Point" ) 
			playerTouchedTable[player:GetId()].points = playerTouchedTable[player:GetId()].points + POINTS_PER_PERIOD
		  else
			 ConsoleToAll("LUA ERROR: player_addfortpoints: Unable to find player")
		  end
	    end
	end
end

-- Initializes the period_scoring (allows for a delay after initial touch)
function init_scoring_alarm( )
	if zone_collection:Count() > 0 then
		SmartTeamSound( GetTeam(defenders), "otherteam.drop", nil )
	end
end

function init_defenders_period_scoring()
	local team = GetTeam( defenders )
	team:AddScore( POINTS_PER_DEFENSE_PERIOD )
	SmartTeamSound( GetTeam(attackers), "yourteam.flagreturn", "misc.doop" )
	
	current_seconds = 30
	
	AddScheduleRepeating( "defenders_period_scoring", DEFENSE_PERIOD_TIME, defenders_period_scoring )
	current_timer = DEFENSE_PERIOD_TIME
	RemoveSchedule( "timer_schedule" )
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )
	update_zone_text( nil )
end

function defenders_period_scoring( )
	local team = GetTeam( defenders )
	team:AddScore( POINTS_PER_DEFENSE_PERIOD )
	SmartTeamSound( GetTeam(attackers), "yourteam.flagreturn", "misc.doop" )
	
	if current_seconds >= 60 then
		BroadCastMessage( "Defenders get "..POINTS_PER_DEFENSE_60SEC_BONUS.." bonus points" )
		team:AddScore( POINTS_PER_DEFENSE_60SEC_BONUS )
		current_seconds = 0
	else
		current_seconds = current_seconds + 10
	end
	
	current_timer = DEFENSE_PERIOD_TIME
	RemoveSchedule( "timer_schedule" )
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )
	update_zone_text( nil )
end

function shutout( )

	-- attackers instead of defenders, because the teams switched
	local teamid = attackers

	-- but after the last round, use defenders	
	if phase >= NUMBER_OF_ROUNDS then
		teamid = defenders
	end

	local team = GetTeam( teamid )
	AddSchedule( "defenders_shutout_msg", 3, BroadCastMessage, "#ADZ_NoScore" )
	team:AddScore( POINTS_PER_DEFENSE_SHUTOUT )
end

-----------------------------------------------------------------------------
-- Round start/end
-----------------------------------------------------------------------------

-- Opens the gates and schedules the round's end.
function round_start()
	-- Opens the gates and all that lovely stuff
	OpenDoor("frontgate")
	BroadCastMessage( "#FF_AD_GATESOPEN" )
	BroadCastSound( "otherteam.flagstolen" )
	SpeakAll( "AD_GATESOPEN" )
	
	gates_open = true
	
	openstartdoor()
	
	AddSchedule( "round_end", ROUND_PERIOD, round_end)
	AddSchedule( "shutout", ROUND_PERIOD, shutout)
	init_defender_countdown()
	update_zone_status( false )
	
	if phase < NUMBER_OF_ROUNDS then
		-- Sets up the end of a round, and the appropriate timed messages
		if ROUND_PERIOD > 300 then AddSchedule( "phase" .. phase .. "5minwarn" , ROUND_PERIOD - 300 , schedulemessagetoall, "#ADZ_Switch5Min" ) end
		if ROUND_PERIOD > 120 then AddSchedule( "phase" .. phase .. "2minwarn" , ROUND_PERIOD - 120 , schedulemessagetoall, "#ADZ_Switch2Min" ) end
		if ROUND_PERIOD > 60 then AddSchedule( "phase" .. phase .. "1minwarn" , ROUND_PERIOD - 60 , schedulemessagetoall, "#ADZ_Switch1Min" ) end
		if ROUND_PERIOD > 30 then AddSchedule( "phase" .. phase .. "30secwarn" , ROUND_PERIOD - 30 , schedulemessagetoall, "#ADZ_Switch30Sec" ) end
		if ROUND_PERIOD > 10 then AddSchedule( "phase" .. phase .. "10secwarn" , ROUND_PERIOD - 10 , schedulemessagetoall, "#ADZ_Switch10Sec" ) end
		if ROUND_PERIOD > 5 then AddSchedule( "phase" .. phase .. "5secwarn" , ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
		if ROUND_PERIOD > 4 then AddSchedule( "phase" .. phase .. "4secwarn" , ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
		if ROUND_PERIOD > 3 then AddSchedule( "phase" .. phase .. "3secwarn" , ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
		if ROUND_PERIOD > 2 then AddSchedule( "phase" .. phase .. "2secwarn" , ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
		if ROUND_PERIOD > 1 then AddSchedule( "phase" .. phase .. "1secwarn" , ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
		AddSchedule( "phase" .. phase .. "switchmessage" , ROUND_PERIOD, schedulemessagetoall, "#ADZ_Switch" )
	else
		if ROUND_PERIOD > 300 then AddSchedule( "phase" .. phase .. "5minwarn" , ROUND_PERIOD - 300 , schedulemessagetoall, "#ADZ_End5Min" ) end
		if ROUND_PERIOD > 120 then AddSchedule( "phase" .. phase .. "2minwarn" , ROUND_PERIOD - 120 , schedulemessagetoall, "#ADZ_End2Min" ) end
		if ROUND_PERIOD > 60 then AddSchedule( "phase" .. phase .. "1minwarn" , ROUND_PERIOD - 60 , schedulemessagetoall, "#ADZ_End1Min" ) end
		if ROUND_PERIOD > 30 then AddSchedule( "phase" .. phase .. "30secwarn" , ROUND_PERIOD - 30 , schedulemessagetoall, "#ADZ_End30Sec" ) end
		if ROUND_PERIOD > 10 then AddSchedule( "phase" .. phase .. "10secwarn" , ROUND_PERIOD - 10 , schedulemessagetoall, "#ADZ_End10Sec" ) end
		if ROUND_PERIOD > 5 then AddSchedule( "phase" .. phase .. "5secwarn" , ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
		if ROUND_PERIOD > 4 then AddSchedule( "phase" .. phase .. "4secwarn" , ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
		if ROUND_PERIOD > 3 then AddSchedule( "phase" .. phase .. "3secwarn" , ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
		if ROUND_PERIOD > 2 then AddSchedule( "phase" .. phase .. "2secwarn" , ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
		if ROUND_PERIOD > 1 then AddSchedule( "phase" .. phase .. "1secwarn" , ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
	end
	
	-- sounds
	if ROUND_PERIOD > 300 then AddSchedule( "phase" .. phase .. "5minwarnsound" , ROUND_PERIOD - 300 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 120 then AddSchedule( "phase" .. phase .. "2minwarnsound" , ROUND_PERIOD - 120 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 60 then AddSchedule( "phase" .. phase .. "1minwarnsound" , ROUND_PERIOD - 60 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 30 then AddSchedule( "phase" .. phase .. "30secwarnsound" , ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 10 then AddSchedule( "phase" .. phase .. "10secwarnsound" , ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if ROUND_PERIOD > 5 then AddSchedule( "phase" .. phase .. "5secwarnsound" , ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if ROUND_PERIOD > 4 then AddSchedule( "phase" .. phase .. "4secwarnsound" , ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if ROUND_PERIOD > 3 then AddSchedule( "phase" .. phase .. "3secwarnsound" , ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if ROUND_PERIOD > 2 then AddSchedule( "phase" .. phase .. "2secwarnsound" , ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if ROUND_PERIOD > 1 then AddSchedule( "phase" .. phase .. "1secwarnsound" , ROUND_PERIOD - 1 , schedulecountdown, 1 ) end

end

-- Checks to see if it's the first or second round, then either swaps teams, or ends the game.
function round_end()

	if phase == NUMBER_OF_ROUNDS then
		DeleteSchedule( "period_scoring" )
		DeleteSchedule( "defenders_period_scoring" )
		DeleteSchedule( "init_defenders_period_scoring" )
		DeleteSchedule( "set_cvar-mp_timelimit" )
		update_zone_text( nil )
		GoToIntermission()
		return
	else
		phase = phase + 1
		gates_open = false
	end

	if attackers == Team.kBlue then
		attackers = Team.kRed
		defenders = Team.kBlue
		
		onswitch_bluetodef()
	else
		attackers = Team.kBlue
		defenders = Team.kRed
		
		onswitch_redtodef()
	end
	
	-- switches some prop model's skins so teams spawn in appropriatly-coloured rooms.
	OutputEvent( "prop_defender", "Skin", teamdata[defenders].skin )
	OutputEvent( "prop_attacker", "Skin", teamdata[attackers].skin )
	
	-- reset the doors
	CloseDoor("frontgate")
	attacker_door_trigger = adz_door:new({ team = attackers, door = "attacker_door" })
	defender_door_trigger = adz_door:new({ team = defenders, door = "defender_door" })
	
	-- switch them team names
	SetTeamName( attackers, "Attackers" )
	SetTeamName( defenders, "Defenders" )
	
	-- reset schedules
	DeleteSchedule( "period_scoring" )
	DeleteSchedule( "period_init" )
	DeleteSchedule( "defenders_period_scoring" )
	DeleteSchedule( "init_defenders_period_scoring" )
	AddSchedule( "round_start", INITIAL_ROUND_PERIOD, round_start)
	-- gate timer
	current_timer = INITIAL_ROUND_PERIOD
	AddScheduleRepeatingNotInfinitely( "timer_schedule", 1, timer_schedule, current_timer )
	
	-- reset player touched table
	playerTouchedTable = {}
	-- remove all leftovers from the cap point collection
	zone_collection:RemoveAllItems()
	zone_area_collection:RemoveAllItems()
	-- respawn, obviously
	RespawnAllPlayers()
	
	-- switch pack touchflags
	if NUM_DEFENDER_ONLY_PACKS > 0 then
		-- get correct allow flags
		if defenders == Team.kRed then pack_allowflags = AllowFlags.kRed
		elseif defenders == Team.kBlue then pack_allowflags = AllowFlags.kBlue
		elseif defenders == Team.kGreen then pack_allowflags = AllowFlags.kGreen
		elseif defenders == Team.kYellow then pack_allowflags = AllowFlags.kYellow end
		
		-- this is a workaround due to how the touchflags are set in base.lua
		for i=1,NUM_DEFENDER_ONLY_PACKS do
			entity = GetEntityByName( "adz_pack_defender"..i )
			local info = CastToInfoScript( entity )
			info:SetTouchFlags({ pack_allowflags })
		end
	end
	
	-- MORE scheduled message loveliness.
	if INITIAL_ROUND_PERIOD > 30 then AddSchedule( "dooropen30sec" , INITIAL_ROUND_PERIOD - 30 , schedulemessagetoall, "#ADZ_30SecWarning" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10sec" , INITIAL_ROUND_PERIOD - 10 , schedulemessagetoall, "#ADZ_10SecWarning" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5sec" , INITIAL_ROUND_PERIOD - 5 , schedulemessagetoall, "5" ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4sec" , INITIAL_ROUND_PERIOD - 4 , schedulemessagetoall, "4" ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3sec" , INITIAL_ROUND_PERIOD - 3, schedulemessagetoall, "3" ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2sec" , INITIAL_ROUND_PERIOD - 2, schedulemessagetoall, "2" ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1sec" , INITIAL_ROUND_PERIOD - 1, schedulemessagetoall, "1" ) end
	
	-- sounds
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen30secsound" , INITIAL_ROUND_PERIOD - 30 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 10 then AddSchedule( "dooropen10secsound" , INITIAL_ROUND_PERIOD - 10 , schedulesound, "misc.bloop" ) end
	if INITIAL_ROUND_PERIOD > 5 then AddSchedule( "dooropen5seccount" , INITIAL_ROUND_PERIOD - 5 , schedulecountdown, 5 ) end
	if INITIAL_ROUND_PERIOD > 4 then AddSchedule( "dooropen4seccount" , INITIAL_ROUND_PERIOD - 4 , schedulecountdown, 4 ) end
	if INITIAL_ROUND_PERIOD > 3 then AddSchedule( "dooropen3seccount" , INITIAL_ROUND_PERIOD - 3 , schedulecountdown, 3 ) end
	if INITIAL_ROUND_PERIOD > 2 then AddSchedule( "dooropen2seccount" , INITIAL_ROUND_PERIOD - 2 , schedulecountdown, 2 ) end
	if INITIAL_ROUND_PERIOD > 1 then AddSchedule( "dooropen1seccount" , INITIAL_ROUND_PERIOD - 1 , schedulecountdown, 1 ) end
	
	-- clear them zones
	update_zone_status( false )
	zone_turnoff()
	
	set_classlimits()
	onswitch()
end

-- I dunno, does something, not sure what!
function RespawnAllPlayers()
	ApplyToAll({ AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips, AT.kAllowRespawn, AT.kReturnDroppedItems })
end

-----------------------------------------------------------------------------
-- output functions
-----------------------------------------------------------------------------

function custom_startup()
	return
end

function zone_on_outputs()
	OutputEvent( "zone_alarm", "PlaySound" )
	OutputEvent( "zone_light", "TurnOn" )
	OutputEvent( "zone_spot", "LightOn" )
	OutputEvent( "zone_rotate_clock", "Start" )
	OutputEvent( "zone_rotate_counterclock", "Start" )
	OutputEvent( "zone_tesla", "DoSpark" )
end
function zone_off_outputs() 
	OutputEvent( "zone_alarm", "StopSound" )
	OutputEvent( "zone_light", "TurnOff" )
	OutputEvent( "zone_spot", "LightOff" )
	OutputEvent( "zone_rotate_clock", "Stop" )
	OutputEvent( "zone_rotate_counterclock", "Stop" )
end
function onswitch_bluetodef() 
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
function onreset_outputs()
	return 
end
function set_classlimits()
	-- reset them limits
	local team = GetTeam(attackers)
	team:SetClassLimit(Player.kCivilian, -1)
	team:SetClassLimit(Player.kScout, 0)
	team:SetClassLimit(Player.kMedic, 0)
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
end
function set_itemlimits( player )
	player:RemoveAmmo( Ammo.kManCannon, 1 )
	-- give demo 1 mirv, and only 1 mirv
	if player:GetClass() == Player.kDemoman or player:GetClass() == Player.kEngineer then 
		player:RemoveAmmo( Ammo.kGren2, 4 )
		player:AddAmmo( Ammo.kGren2, 1 )
	end
	if player:GetTeamId() == defenders then
		player:RemoveAmmo( Ammo.kDetpack, 1 )
	end
end

-----------------------------------------------------------------------------
-- respawn shields
-----------------------------------------------------------------------------
hurt = trigger_ff_script:new({ team = Team.kUnassigned })
function hurt:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == attackers then
			return EVENT_ALLOWED
		end
	end

	return EVENT_DISALLOWED
end

-- red lasers hurt blue and vice-versa

red_laser_hurt = hurt:new({ team = Team.kBlue })
blue_laser_hurt = hurt:new({ team = Team.kRed })

-----------------------------------------------------------------------------
-- backpacks, doors, etc. etc. 
-----------------------------------------------------------------------------

adz_pack = genericbackpack:new({
	health = 35,
	armor = 35,
	grenades = 20,
	nails = 50,
	shells = 300,
	rockets = 15,
	gren1 = 1,
	gren2 = 0,
	cells = 120,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

function adz_pack:dropatspawn() return false end

if defenders == Team.kRed then pack_allowflags = AllowFlags.kRed
elseif defenders == Team.kBlue then pack_allowflags = AllowFlags.kBlue
elseif defenders == Team.kGreen then pack_allowflags = AllowFlags.kGreen
elseif defenders == Team.kYellow then pack_allowflags = AllowFlags.kYellow end

adz_pack_defender1 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender2 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender3 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender4 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender5 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender6 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender7 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender8 = adz_pack:new({ touchflags = {pack_allowflags} })
adz_pack_defender9 = adz_pack:new({ touchflags = {pack_allowflags} })

adz_defender_pack1 = adz_pack_defender1
adz_defender_pack2 = adz_pack_defender2
adz_defender_pack3 = adz_pack_defender3
adz_defender_pack4 = adz_pack_defender4
adz_defender_pack5 = adz_pack_defender5
adz_defender_pack6 = adz_pack_defender6
adz_defender_pack7 = adz_pack_defender7
adz_defender_pack8 = adz_pack_defender8
adz_defender_pack9 = adz_pack_defender9

------------------------------------------------------------------
--Resup Doors
------------------------------------------------------------------

adz_door = trigger_ff_script:new({ team = Team.kUnassigned, door = nil }) 

function adz_door:allowed( touch_entity ) 
	if IsPlayer( touch_entity ) then 
		local player = CastToPlayer( touch_entity ) 
		return player:GetTeamId() == self.team
	end 

	return EVENT_DISALLOWED 
end 

function adz_door:ontrigger( touch_entity )
	if IsPlayer( touch_entity ) then 
		OutputEvent(self.door, "Open")
	end 
end 

attacker_door_trigger = adz_door:new({ team = attackers, door = "attacker_door" })
defender_door_trigger = adz_door:new({ team = defenders, door = "defender_door" })