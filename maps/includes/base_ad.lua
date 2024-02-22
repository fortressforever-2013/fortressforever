-- base_ad.lua
-- Attack / Defend gametype 

-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_teamplay")

-----------------------------------------------------------------------------
-- globals
-----------------------------------------------------------------------------
if NUM_PHASES == nil then NUM_PHASES = 3; end
if INITIAL_ROUND_LENGTH == nil then INITIAL_ROUND_LENGTH = 90
POINTS_PER_CAPTURE = 25
POINTS_PER_PERIOD = 1
POSTCAP_TIMER = 2

if ATTACKERS == nil then ATTACKERS = Team.kBlue; end
if DEFENDERS == nil then DEFENDERS = Team.kRed; end
--if MAP_LENGTH == nil then MAP_LENGTH = 1436; end -- 23 minutes 56 seconds, 4 seconds less than the default timelimit of 24 minutes.

if ATTACKERS_OBJECTIVE_ENTITY == nil then ATTACKERS_OBJECTIVE_ENTITY = nil end
if DEFENDERS_OBJECTIVE_ENTITY == nil then DEFENDERS_OBJECTIVE_ENTITY = nil end
-- _ONCAP set to true; Defenders should always point to cap
if DEFENDERS_OBJECTIVE_ONCAP == nil then DEFENDERS_OBJECTIVE_ONCAP = true end
-- _OBJECTIVE_ONCARRIER and _ONFLAG set to false to keep objective on cap
if DEFENDERS_OBJECTIVE_ONFLAG == nil then DEFENDERS_OBJECTIVE_ONFLAG = false end
if DEFENDERS_OBJECTIVE_ONCARRIER == nil then DEFENDERS_OBJECTIVE_ONCARRIER = false end

INITIAL_FUSE_TIMER = 80
BLOW_CP1_ROUTE_TIMER = 300
BLOW_CP2_ROUTE_TIMER = 780

allow_win = true
phase = 1
current_timer = 0
carried_by = nil

function startup( )

	SetGameDescription( "Attack Defend" )
	
	-- 4 seconds less than mp_timelimit, just as was the case when it was fixed (I assume it always takes 4 seconds to initialise?)
	MAP_LENGTH = (60 * GetConvar( "mp_timelimit" )) - 4;
	PERIOD_TIME = MAP_LENGTH * POINTS_PER_PERIOD / 100;
	
	-- set up team limit
	-- disable all teams	
	for i = Team.kBlue, Team.kGreen do
		local team = GetTeam( i )
		if i then
			team:SetPlayerLimit( -1 )
		end
	end
	
	-- then re-enable attackers/defenders
	local team = GetTeam( ATTACKERS )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )

	local team = GetTeam( DEFENDERS )
	team:SetPlayerLimit( 0 )
	team:SetClassLimit( Player.kCivilian, -1 )
	team:SetClassLimit(Player.kScout, -1)

	-- Should this be map specific?
	SetTeamName( ATTACKERS, "#FF_Attackers")
	SetTeamName( DEFENDERS, "#FF_Defenders" )

	-- start the timer for the points
	AddScheduleRepeating( "addpoints", PERIOD_TIME, addpoints )

	setup_door_timer( "cp1_gate", INITIAL_ROUND_LENGTH )
	setup_map_timers()
	
	allow_win = true
	
	cp1_flag.enabled = true
	cp1_flag.team = ATTACKERS
	for i,v in ipairs({"cp1_flag", "cp2_flag", "cp3_flag"}) do
		local flag = GetInfoScriptByName(v)
		if flag then
			flag:SetModel(_G[v].model)
			flag:SetSkin(teamskins[ATTACKERS])
			if i == 1 then
				flag:Restore()
			else
				flag:Remove()
			end
		end
	end	 

	-- Remove future phase flags
	flag_remove( "cp2_flag" )
	flag_remove( "cp3_flag" )

	-- add map initialise stuff.  Needs to be done via lua for synchronisation 
	AddSchedule("blow_first_gate", INITIAL_FUSE_TIMER, blow_first_gate )
	AddSchedule("blow_cp1_extra_route", BLOW_CP1_ROUTE_TIMER, blow_cp1_extra_route )
	AddSchedule("blow_cp2_extra_route", BLOW_CP2_ROUTE_TIMER, blow_cp2_extra_route )
	
	ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )
	UpdateDefendersObjective()
	UpdateTeamObjectiveIcon( GetTeam(ATTACKERS), ATTACKERS_OBJECTIVE_ENTITY )
end

function blow_first_gate( )
	OutputEvent( "fuse01", "StartForward" ) -- delay of 80 secs
end

function blow_cp1_extra_route( )
	OutputEvent( "cp1_extraroute", "Break" ) -- delay of 300 secs
end

function blow_cp2_extra_route( )
	OutputEvent( "cp2_extraroute", "Break" ) -- delay of 780 secs
end


-----------------------------------------
-- Remove a flag by name
-----------------------------------------
function flag_remove( flag_name )
	local flag = GetInfoScriptByName( flag_name )
	if flag then
		flag:Remove()
		_G[flag_name].enabled = false
	end
end

-----------------------------------------
-- Restore a flag by name
-----------------------------------------
function flag_restore( flag_name )
	local flag = GetInfoScriptByName( flag_name )
	if flag then
		flag:Restore()
		_G[flag_name].enabled = true
	end
end

-----------------------------------------
-- 
-----------------------------------------
function player_spawn( player_entity )
	local player = CastToPlayer( player_entity )
	player:AddHealth( 400 )
	player:AddArmor( 400 )

	-- Remove stuff
	player:RemoveAmmo( Ammo.kNails, 400 )
	player:RemoveAmmo( Ammo.kShells, 400 )
	player:RemoveAmmo( Ammo.kRockets, 400 )
	player:RemoveAmmo( Ammo.kCells, 400 )
	player:RemoveAmmo( Ammo.kGren2, 4 )

	-- Add items (similar to both teams)
	player:AddAmmo( Ammo.kShells, 200 )
	player:AddAmmo( Ammo.kRockets, 30 )
	player:AddAmmo( Ammo.kNails, 200 )

	-- Defenders get...
	if player:GetTeamId() == DEFENDERS then
		-- Player is at full armor now, so we can
		-- easily reduce by some percent
		-- but were not going to because
		-- theres no reason to do so
		-- player:RemoveArmor( ( player:GetArmor() * .25 ) )

		player:RemoveAmmo( Ammo.kGren1, 4 )
		player:AddAmmo( Ammo.kCells, 200 )
	elseif player:GetTeamId() == ATTACKERS then
		-- Attackers get...
		player:AddAmmo( Ammo.kCells, 200 )
	end
	
	if player:GetTeamId() == ATTACKERS then
		UpdateObjectiveIcon( player, ATTACKERS_OBJECTIVE_ENTITY )
	elseif player:GetTeamId() == DEFENDERS then
		UpdateObjectiveIcon( player, DEFENDERS_OBJECTIVE_ENTITY )
	end
end

function addpoints( )
	local team = GetTeam( DEFENDERS )
	team:AddScore( POINTS_PER_PERIOD )
end

-----------------------------------------
-- base flag
-----------------------------------------
-- default
base_ad_flag = baseflag:new({
	modelskin = teamskins[ATTACKERS],
	name = "base_ad_flag",
	team = ATTACKERS,
	phase = 1,
	hudicon = team_hudicons[ATTACKERS],
	touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kGreen, AllowFlags.kYellow}
})

	-- if ATTACKERS == Team.kRed then
		-- ConsoleToAll("Setting up RED ATTACKERS FLAG")		
		-- base_ad_flag.hudicon = "hud_flag_red.vtf"
		-- base_ad_flag.touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kRed}	
	-- elseif ATTACKERS == Team.kGreen then
		-- ConsoleToAll("Setting up GREEN ATTACKERS FLAG")
		-- base_ad_flag.hudicon = "hud_flag_green.vtf"
		-- base_ad_flag.touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kGreen}
	-- elseif ATTACKERS == Team.kBlue then
		-- ConsoleToAll("Setting up BLUE ATTACKERS FLAG")
		-- base_ad_flag.hudicon = "hud_flag_blue.vtf"
		-- base_ad_flag.touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kBlue}
	-- elseif ATTACKERS == Team.kYellow then
		-- ConsoleToAll("Setting up Yellow ATTACKERS FLAG")
		-- base_ad_flag.hudicon = "hud_flag_yellow.vtf"
		-- base_ad_flag.touchflags = {AllowFlags.kOnlyPlayers, AllowFlags.kYellow}
	-- end
end

function base_ad_flag:dropitemcmd( owner_entity )
-- DO NOTHING!
--	-- throw the flag
--	local flag = CastToInfoScript(entity)
--	flag:Drop(FLAG_RETURN_TIME, FLAG_THROW_SPEED)
--
--	if IsPlayer( owner_entity ) then
--		local player = CastToPlayer( owner_entity )
--		player:RemoveEffect( EF.kSpeedlua1 )
--
--		-- Remove any hud icons with identifier "base_ad_flag"
--		RemoveHudItem( player, "base_ad_flag" )
--	end
end


function base_ad_flag:touch( touch_entity )
	-- should only respond to players
	if (IsPlayer(touch_entity) == false) then
		return
	end

	local player = CastToPlayer(touch_entity)
	local teamId = player:GetTeamId()

	-- pickup if they can
	if self.notouch then
		if self.notouch[player:GetId()] then return; end
	end

	if teamId == ATTACKERS and phase == self.phase then
		if phase == 1 then
			--BroadCastMessageToPlayer(player, "#FF_AD_TAKE1")
			SmartMessage(player, "#FF_AD_TAKE1", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)
		elseif phase == 2 then
			--BroadCastMessageToPlayer(player, "#FF_AD_TAKE2")
			SmartMessage(player, "#FF_AD_TAKE2", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)
		else
			--BroadCastMessageToPlayer(player, "#FF_AD_TAKE3")
			SmartMessage(player, "#FF_AD_TAKE3", "#FF_TEAMPICKUP", "#FF_OTHERTEAMPICKUP", Color.kGreen, Color.kGreen, Color.kRed)
		end
		
		SmartSound(player, "yourteam.flagstolen", "yourteam.flagstolen", "otherteam.flagstolen")
		RandomFlagTouchSpeak( player )
		
		-- have player pick up the flag and lose his disguise (for spy class)
		local flag = CastToInfoScript( entity )
		if flag ~= nil then
			flag:Pickup( player) 
			player:AddEffect( EF.kSpeedlua1, -1, 0, 0.65 )
			player:SetDisguisable( false )
			-- if the player is a spy, then force him to lose his cloak
			player:SetCloakable( false )

			self.hudicon = team_hudicons[ATTACKERS] 			
			-- Add hud icon to show we're carrying the flag
			AddHudIcon( player, self.hudicon, flag:GetName(), self.hudx, self.hudy, self.hudstatusiconw, self.hudstatusiconh, self.hudalign )
		
			-- change objective icons
			ATTACKERS_OBJECTIVE_ENTITY = player
			UpdateDefendersObjective()
			UpdateTeamObjectiveIcon( GetTeam(ATTACKERS), ATTACKERS_OBJECTIVE_ENTITY )
			UpdateObjectiveIcon( player, GetEntityByName( "cp"..self.phase.."_cap" ) )
			
			LogLuaEvent(player:GetId(), 0, "flag_touch", "flag_name", flag:GetName(), "player_origin", (string.format("%0.2f",player:GetOrigin().x) .. ", " .. string.format("%0.2f",player:GetOrigin().y) .. ", " .. string.format("%0.1f",player:GetOrigin().z) ), "player_health", "" .. player:GetHealth());
			-- show on the deathnotice board
			--ObjectiveNotice( player, "grabbed the flag" )
			
			carried_by = player:GetName()
			destroy_return_timer()
			update_hud()
		end
	end
end

function base_ad_flag:onownerdie( owner_entity )
	if IsPlayer( owner_entity ) then
		local player = CastToPlayer( owner_entity )
		player:RemoveEffect( EF.kSpeedlua1 )

		player:SetDisguisable( true )
		player:SetCloakable( true )

		-- Remove any hud icons with identifier "base_ad_flag"
		RemoveHudItem( player, "base_ad_flag" )
		
		-- drop the flag
		local flag = CastToInfoScript(entity)
		flag:Drop(FLAG_RETURN_TIME, 0.0)
		
		-- change objective icon
		ATTACKERS_OBJECTIVE_ENTITY = flag
		UpdateDefendersObjective()
		UpdateObjectiveIcon( player, nil )
		UpdateTeamObjectiveIcon( GetTeam(ATTACKERS), ATTACKERS_OBJECTIVE_ENTITY )
		
		-- remove flag icon from hud
		RemoveHudItem( player, flag:GetName() )
		RemoveHudItemFromAll( flag:GetName() .. "_c" )
		AddHudIconToAll( self.hudstatusicondropped, ( flag:GetName() .. "_d" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
		self.status = 2

		setup_return_timer()
		update_hud()
	end
end

function base_ad_flag:onreturn( )
	-- let the teams know that the flag was returned
	local team = GetTeam( self.team )
	SmartTeamMessage(team, "#FF_TEAMRETURN", "#FF_OTHERTEAMRETURN", Color.kYellow, Color.kYellow)
	SmartTeamSound(team, "yourteam.flagreturn", "otherteam.flagreturn")
	SmartTeamSpeak(team, "CTF_FLAGBACK", "CTF_EFLAGBACK")
	local flag = CastToInfoScript( entity )

	RemoveHudItemFromAll( flag:GetName() .. "_d" )
	RemoveHudItemFromAll( flag:GetName() .. "_c" )
	AddHudIconToAll( self.hudstatusiconhome, ( flag:GetName() .. "_h" ), self.hudstatusiconx, self.hudstatusicony, self.hudstatusiconw, self.hudstatusiconh, self.hudstatusiconalign )
	self.status = 0
	
	-- change objective icon
	ATTACKERS_OBJECTIVE_ENTITY = flag
	UpdateDefendersObjective()
	UpdateTeamObjectiveIcon( GetTeam(ATTACKERS), ATTACKERS_OBJECTIVE_ENTITY )
	
	LogLuaEvent(0, 0, "flag_returned","flag_name",flag:GetName());

	destroy_return_timer()
	update_hud()
end

-----------------------------------------
-- base capture point
-----------------------------------------
base_ad_cap = basecap:new({
	phase = 0,
	doorname = "cp2_gate",
	duration = 90,
	team = ATTACKERS
})

function base_ad_cap:allowed ( allowed_entity )
	if phase ~= self.phase then
		return false
	end
	
	-- only respond to players
	if ( IsPlayer( allowed_entity ) == false ) then
		return false
	end

	if allow_win == false then
		return false
	end

	local player = CastToPlayer( allowed_entity )

	-- check if the player has the flag
	for i,v in ipairs( self.item ) do
		if player:HasItem( v ) then
			player:RemoveEffect( EF.kSpeedlua1 )
			
			-- Remove any hud icons with identifier "base_ad_flag"
			RemoveHudItem( player, "base_ad_flag" )

			return true
		end
	end

	return false
end

function base_ad_cap:oncapture( player, item )

	if phase == 1 then
		map_cap1()
	elseif phase == 2 then
		map_cap2()
	else
		allow_win = false
		map_attackers_win()
	end

	player:AddFortPoints(500, "#FF_FORTPOINTS_CAPTUREPOINT")

	if self.closedoor then
		CloseDoor(self.closedoor)
	end

	-- remove objective icon
	ATTACKERS_OBJECTIVE_ENTITY = nil
	DEFENDERS_OBJECTIVE_ENTITY = nil
	UpdateTeamObjectiveIcon( GetTeam(ATTACKERS), ATTACKERS_OBJECTIVE_ENTITY )
	UpdateTeamObjectiveIcon( GetTeam(DEFENDERS), DEFENDERS_OBJECTIVE_ENTITY )

	-- Remove previous phase flag
	flag_remove( item )

	-- Delay for a couple seconds after the cap
	AddSchedule( "cap_delay_timer", POSTCAP_TIMER, cap_delay_timer, self )
end

-----------------------------------------
-- waste a couple seconds before respawning/ending
-----------------------------------------
function cap_delay_timer( cap )	
	if phase == NUM_PHASES then
		-- it's the last round. end and stuff
		GoToIntermission()
		RemoveSchedule( "addpoints" )
	else
		phase = phase + 1

		-- setup double cap points for the last round
		if phase == NUM_PHASES then
			POINTS_PER_CAPTURE = POINTS_PER_CAPTURE * 2
		end

		-- Restore next flag
		if phase == 2 then
			flag_restore( "cp2_flag" )
		elseif phase == 3 then
			flag_restore( "cp3_flag" )
		end
		
		-- update objective icon
		ATTACKERS_OBJECTIVE_ENTITY = GetEntityByName( "cp"..phase.."_flag" )
		UpdateDefendersObjective()

		setup_door_timer( cap.doorname, cap.duration) 
		ApplyToAll( { AT.kRemovePacks, AT.kRemoveProjectiles, AT.kRespawnPlayers, AT.kRemoveBuildables, AT.kRemoveRagdolls, AT.kStopPrimedGrens, AT.kReloadClips } )
	end
end

function setup_door_timer( doorname, duration )
	AddSchedule( "round_start", duration, round_start, doorname )
	if duration > 65 then AddSchedule( "round_60secwarn", duration-60, round_60secwarn ) end
	if duration > 35 then AddSchedule( "round_30secwarn", duration-30, round_30secwarn ) end
	if duration > 15 then AddSchedule( "round_10secwarn", duration-10, round_10secwarn ) end
end

function round_start( doorname )
	BroadCastMessage( "#FF_AD_GATESOPEN" )
	BroadCastSound( "otherteam.flagstolen" )
	SpeakAll( "AD_GATESOPEN" )
	OpenDoor( doorname )
end

function round_60secwarn( )
	BroadCastMessage( "#FF_ROUND_60SECWARN" )
end

function round_30secwarn( )
	BroadCastMessage( "#FF_ROUND_30SECWARN" )
end

function round_10secwarn( )
	BroadCastMessage( "#FF_ROUND_10SECWARN" )
end


----------------
-- map timers --
----------------

function setup_map_timers( )
	local timelimit = MAP_LENGTH

	AddSchedule( "map_10mintimer", timelimit-600, map_timewarn, 600 )
	AddSchedule( "map_5mintimer", timelimit-300, map_timewarn, 300 )
	AddSchedule( "map_2mintimer", timelimit-120, map_timewarn, 120 )
	AddSchedule( "map_60sectimer", timelimit-60, map_timewarn, 60 )
	AddSchedule( "map_30sectimer", timelimit-30, map_timewarn, 30 )
	AddSchedule( "map_10sectimer", timelimit-10, map_timewarn, 10 )
	AddSchedule( "map_9sectimer", timelimit-9, map_timewarn, 9 )
	AddSchedule( "map_8sectimer", timelimit-8, map_timewarn, 8 )
	AddSchedule( "map_7sectimer", timelimit-7, map_timewarn, 7 )
	AddSchedule( "map_6sectimer", timelimit-6, map_timewarn, 6 )
	AddSchedule( "map_5sectimer", timelimit-5, map_timewarn, 5 )
	AddSchedule( "map_4sectimer", timelimit-4, map_timewarn, 4 )
	AddSchedule( "map_3sectimer", timelimit-3, map_timewarn, 3 )
	AddSchedule( "map_2sectimer", timelimit-2, map_timewarn, 2 )
	AddSchedule( "map_1sectimer", timelimit-1, map_timewarn, 1 )
	AddSchedule( "map_timer", timelimit, map_defenders_win )
end

function map_attackers_win( )
	RemoveSchedule( "map_10mintimer" )
	RemoveSchedule( "map_5mintimer" )
	RemoveSchedule( "map_2mintimer" )
	RemoveSchedule( "map_60sectimer" )
	RemoveSchedule( "map_30sectimer" )
	RemoveSchedule( "map_10sectimer" )
	RemoveSchedule( "map_9sectimer" )
	RemoveSchedule( "map_8sectimer" )
	RemoveSchedule( "map_7sectimer" )
	RemoveSchedule( "map_6sectimer" )
	RemoveSchedule( "map_5sectimer" )
	RemoveSchedule( "map_4sectimer" )
	RemoveSchedule( "map_3sectimer" )
	RemoveSchedule( "map_2sectimer" )
	RemoveSchedule( "map_1sectimer" )
	RemoveSchedule( "map_timer" )
	BroadCastSound( "yourteam.flagcap" )	
	--BroadCastMessage("#FF_AD_" .. TeamName(ATTACKERS) .. "#FF_WIN")
	BroadCastMessage( "#FF_AD_BLUEWIN" )
	--SpeakAll( "AD_" .. TeamName( ATTACKERS ) .. "CAP".. TeamName( DEFENDERS ) )
	SpeakAll( "AD_CAP" )
end

function map_defenders_win( )
	if allow_win == false then
		return false
	end

	--BroadCastSound("yourteam.flagcap")	
	BroadCastMessage("#FF_AD_REDWIN")
	--SpeakAll( "AD_HOLD_" .. TeamName(DEFENDERS) )
	SpeakAll( "AD_HOLD" )
	allow_win = false
	--Defenders wins, call Intermission!
	phase = NUM_PHASES
	RemoveSchedule( "addpoints" )
	addpoints()
	AddSchedule( "cap_delay_timer", POSTCAP_TIMER, cap_delay_timer, self )
end

function map_timewarn( time )
	BroadCastMessage( "#FF_MAP_" .. time .. "SECWARN" )
	SpeakAll( "AD_" .. time .. "SEC" )
end

function map_cap1( )
	BroadCastSound( "yourteam.flagcap" )
	BroadCastMessage( "#FF_AD_CAP1" )
	SpeakAll( "AD_CP1" )
	--SpeakAll("AD_CP1_" .. TeamName(ATTACKERS))
end

function map_cap2( )
	BroadCastSound( "yourteam.flagcap" )
	BroadCastMessage( "#FF_AD_CAP2" )
	SpeakAll( "AD_CP2" )
	--SpeakAll("AD_CP2_" .. TeamName(ATTACKERS))
end

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

-----------------------------------------
-- spawn info stuffs
-----------------------------------------
function start_allowedmethod( self, player_entity )

	if ( IsPlayer( player_entity ) == false ) then
		return false
	end

	local player = CastToPlayer( player_entity )
	local teamId = player:GetTeamId( )
	
	return (teamId == ATTACKERS and phase == 1)
end

function alpha_allowedmethod( self, player_entity )
	if ( IsPlayer( player_entity ) == false ) then
		return false
	end

	local player = CastToPlayer( player_entity )
	local teamId = player:GetTeamId( ) 
	
	return (teamId == ATTACKERS and phase == 2)
		or (teamId == DEFENDERS and phase == 1)
end

function beta_allowedmethod( self, player_entity )
	if ( IsPlayer( player_entity ) == false ) then
		return false
	end

	local player = CastToPlayer( player_entity )
	local teamId = player:GetTeamId( ) 
	
	return (teamId == ATTACKERS and phase == 3)
		or (teamId == DEFENDERS and phase == 2)
end

function final_allowedmethod( self, player_entity )
	if ( IsPlayer( player_entity ) == false ) then
		return false
	end

	local player = CastToPlayer( player_entity )	
	local teamId = player:GetTeamId( ) 
	
	return (teamId == DEFENDERS and phase == 3)
end

function UpdateDefendersObjective()
	-- Check to see what Defenders should be focused on and update 
    local flag = GetInfoScriptByName("cp"..phase.."_flag")
    local carried = flag:IsCarried()
    if (not carried and DEFENDERS_OBJECTIVE_ONFLAG) or (carried and DEFENDERS_OBJECTIVE_ONCARRIER) then
        DEFENDERS_OBJECTIVE_ENTITY = flag
    elseif DEFENDERS_OBJECTIVE_ONCAP then
        DEFENDERS_OBJECTIVE_ENTITY = GetEntityByName("cp"..phase.."_cap")
    else
        DEFENDERS_OBJECTIVE_ENTITY = nil
    end
    UpdateTeamObjectiveIcon( GetTeam(defenders), DEFENDERS_OBJECTIVE_ENTITY )
end


-----------------------------------------
-- instanciate everything
-----------------------------------------
cp1_flag = base_ad_flag:new({ phase = 1 })
cp2_flag = base_ad_flag:new({ phase = 2 })
cp3_flag = base_ad_flag:new({ phase = 3 })

cp1_cap = base_ad_cap:new({ item={"cp1_flag"}, phase = 1, doorname = "cp2_gate", closedoor = "cp1_exit"})
cp2_cap = base_ad_cap:new({ item={"cp2_flag"}, phase = 2, doorname = "cp3_gate", closedoor = "cp2_exit"})
cp3_cap = base_ad_cap:new({ item={"cp3_flag"}, phase = 3, doorname = "", closedoor = "cp3_exit"})

start_door = respawndoor:new({allowed = start_allowedmethod})
start_spawn = {validspawn = start_allowedmethod}
alpha_door = respawndoor:new({allowed = alpha_allowedmethod})
alpha_spawn = {validspawn = alpha_allowedmethod}
beta_door = respawndoor:new({allowed = beta_allowedmethod})
beta_spawn = {validspawn = beta_allowedmethod}
final_door = respawndoor:new({allowed = final_allowedmethod})
final_spawn = {validspawn = final_allowedmethod}


------------------------------------------------
-- hud info
------------------------------------------------
function flaginfo( player_entity )

	local player = CastToPlayer( player_entity )

	local flag = GetInfoScriptByName("cp"..phase.."_flag")
	local flagname = flag:GetName()
	
	attackers = ATTACKERS
	defenders = DEFENDERS
	
	--RemoveHudItemFromAll( "background" )
	--AddHudIconToAll( "hud_statusbar_256_128.vtf", "background", -64, 32, 128, 70, 3 )
	
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
	
	if _G[flagname].enabled == true then
		if flag:IsCarried() then
			AddHudText(player, "flag_carried_by", "#AD_FlagCarriedBy", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
			AddHudText(player, "flag_carried_by2", carried_by, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0)
			AddHudIcon(player, hudstatusiconcarried, ( "cp_flag_c" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif flag:IsDropped() and _G[flagname].status == 2 then
			AddHudText(player, "flag_return_text", "#AD_FlagReturn", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
			AddHudTimer(player, "flag_return_timer", current_timer + 1, -1, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign)
			AddHudIcon(player, hudstatusicondropped, ( "cp_flag_d" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif _G[flagname].status == 0 then
			AddHudText(player, "flag_athome", "#AD_FlagIsAt", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
			AddHudText(player, "flag_athome2", "#AD_ASpawn", text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0)
			AddHudIcon(player, hudstatusiconhome, ( "cp_flag_h" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )	
		end
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
	
	attackers = ATTACKERS
	defenders = DEFENDERS
	
	--RemoveHudItemFromAll( "background" )
	--AddHudIconToAll( "hud_statusbar_256_128.vtf", "background", -64, 32, 128, 70, 3 )
	
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
	
	if _G[flagname].enabled == true then
		if flag:IsCarried() then
			AddHudTextToAll("flag_carried_by", "#AD_FlagCarriedBy", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
			AddHudTextToAll("flag_carried_by2", carried_by, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0)
			AddHudIconToAll( hudstatusiconcarried, ( "cp_flag_c" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif flag:IsDropped() and _G[flagname].status == 2 then
			AddHudTextToAll("flag_return_text", "#AD_FlagReturn", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
			AddHudTimerToAll("flag_return_timer", current_timer + 1, -1, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign)
			AddHudIconToAll( hudstatusicondropped, ( "cp_flag_d" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )
		elseif _G[flagname].status == 0 then
			AddHudTextToAll("flag_athome", "#AD_FlagIsAt", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
			AddHudTextToAll("flag_athome2", "#AD_ASpawn", text_hudstatusx, text_hudstatusy+8, text_hudstatusalign, 0)
			AddHudIconToAll( hudstatusiconhome, ( "cp_flag_h" ), flag_hudstatusiconx, flag_hudstatusicony, flag_hudstatusiconw, flag_hudstatusiconh, flag_hudstatusiconalign )	
		end
	else
		AddHudTextToAll("flag_tobase_text", "#AD_FlagReturnBase", text_hudstatusx, text_hudstatusy, text_hudstatusalign, 0)
		AddHudTimerToAll("flag_tobase_timer", current_timer + 1, -1, text_hudstatusx, text_hudstatusy+8, text_hudstatusalign)
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
	
	AddHudIconToTeam( GetTeam(attackers), "hud_offense.vtf", "Zone_Team"..attackers, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
	AddHudIconToTeam( GetTeam(attackers), "hud_cp_"..phase..".vtf", "Zone_Phase"..attackers, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	
	AddHudIconToTeam( GetTeam(defenders), "hud_defense.vtf", "Zone_Team"..defenders, od_hudstatusiconx, od_hudstatusicony, od_hudstatusiconw, od_hudstatusiconh, od_hudstatusiconalign )
	AddHudIconToTeam( GetTeam(defenders), "hud_cp_"..phase..".vtf", "Zone_Phase"..defenders, od_hudstatusiconx + 2, od_hudstatusicony + 2, 20, 20, od_hudstatusiconalign )
	
end
