-----------------------------------------------------------------------------
-- includes
-----------------------------------------------------------------------------
IncludeScript("base_cp_default")
IncludeScript("base_cp_sequential")
IncludeScript("base_chatcommands")

-----------------------------------------------------------------------------
--Globals
-----------------------------------------------------------------------------

POINTS_FOR_COMPLETE_CONTROL = 25
ENABLE_COMPLETE_CONTROL_RESET = true
ENABLE_COMPLETE_CONTROL_RESPAWN = true
COMPLETE_CONTROL_RESPAWN_DELAY = 5
INITIAL_ROUND_DELAY = 20
RETOUCH_DELAY = 10.0 --CP3
RETOUCH_DELAY_CP2RED_CP4BLUE = 20
RETOUCH_DELAY_CP2BLUE_CP4RED = 10

CAP_REQ_CP1_CP5 = 750
CAP_REQ_CP3 = 1000
CAP_REQ_CP2RED_CP4BLUE = 1000
CAP_REQ_CP2BLUE_CP4RED = 1250

cp_blue = 1
cp_red = 5
RED_TUNNEL_WALL_BLOWN = false
BLUE_TUNNEL_WALL_BLOWN = false

-----------------------------------------------------------------------------
-- Chat commands and settings
-----------------------------------------------------------------------------

-- teamcapsound
chatbase_addcommand( "teamcapsound", "Determines if a sound is played when the other team starts capping a point", "teamcapsound 0/1" )
function chat_teamcapsound( player, setting )
	setting = tonumber(setting)
	if setting == "" or setting == nil then
		-- no parameter, just echo back their current setting
		ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Current team capture sound setting: "..tostring(chatbase_getplayersetting(player, "startcapsound")))
	elseif setting == 0 or not setting then
		ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Turned your team capture sound off")
		chatbase_setplayersetting(player, "teamcapsound", 0)
	else
		ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Turned your team capture sound on")
		chatbase_setplayersetting(player, "teamcapsound", 1)
	end
end
chatbase_addplayersetting( "teamcapsound", 1, "Determines if a sound is played when the other team starts capping a point" )

-- startcapsound
chatbase_addcommand( "startcapsound", "Determines if a sound is played when you start to capture a point", "startcapsound 0/1" )
function chat_startcapsound( player, setting )
	setting = tonumber(setting)
	if setting == "" or setting == nil then
		-- no parameter, just echo back their current setting
		ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Current start capture sound setting: "..tostring(chatbase_getplayersetting(player, "startcapsound")))
	elseif setting == 0 or not setting then
		ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Turned your start capture sound off")
		chatbase_setplayersetting(player, "startcapsound", 0)
	else
		ChatToPlayer(player, "^"..CHAT_COMMAND_COLOR_MAIN.."Turned your start capture sound on")
		chatbase_setplayersetting(player, "startcapsound", 1)
	end
end

chatbase_addplayersetting( "startcapsound", 1, "Determines if a sound is played when the opposite team starts to capture a point" )

-----------------------------------------------------------------------------
-- event outputs
-----------------------------------------------------------------------------

function startup()
	SetGameDescription("Sequential Control Points")
	
	-- disable certain teams
	for i,v in pairs(disabled_teams) do
		SetPlayerLimit( v, -1 )
	end

	-- set up team limits
	for i1,v1 in pairs(teams) do
		local team = GetTeam(v1)
		for i2,v2 in ipairs(team_info[team:GetTeamId()].class_limits) do
			team:SetClassLimit( i2, v2 )
		end
	end

	RemoveAllCPAmmoAndArmor()
	
	for i,v in ipairs(command_points) do
		RemoveSchedule( "cp" .. v.cp_number .. "_cap_timer" )
		ResetCPCapping( v )
		AddScheduleRepeating( "cp" .. v.cp_number .. "_cap_zone_timer", CAP_ZONE_TIMER_INTERVAL, cap_zone_timer, v )
	end
	
	reset_map_items(true)
end

function complete_control_notification ( team_number )
	local team = GetTeam(team_number)
	SmartTeamSound(team, "yourteam.flagcap", "otherteam.flagcap")
	SmartTeamSpeak(team, "CZ_GOTALL", "CZ_THEYGOTALL")
	SmartTeamMessage(team, "#FF_CZ2_YOURTEAM_COMPLETE", "#FF_CZ2_OTHERTEAM_COMPLETE")

	AddSchedule("reset_map_items", COMPLETE_CONTROL_RESPAWN_DELAY, reset_map_items, false)
end

function reset_map_items (firstRound)	
	BLUE_TUNNEL_WALL_BLOWN = false
	RED_TUNNEL_WALL_BLOWN = false
	OutputEvent( "blue_detwall_template", "ForceSpawn" )
	OutputEvent( "red_detwall_template", "ForceSpawn" )

	OBJECTIVE_TEAM1 = "cp2_zone"
	OBJECTIVE_TEAM2 = "cp4_zone"
	UpdateTeamObjectiveIcon( GetTeam(TEAM1), GetEntityByName( OBJECTIVE_TEAM1 ) )
	UpdateTeamObjectiveIcon( GetTeam(TEAM2), GetEntityByName( OBJECTIVE_TEAM2 ) )
	
	if firstRound then
		for i,v in ipairs(command_points) do	
			ChangeCPDefendingTeam(v.cp_number, Team.kUnassigned)
			ResetCPCapping( v )
		end
		
		ChangeCPDefendingTeam( 1, TEAM1 )
		ChangeCPDefendingTeam( CP_COUNT, TEAM2 )
		
		setup_door_timer("startgate_blue", INITIAL_ROUND_DELAY)
		setup_door_timer("startgate_red", INITIAL_ROUND_DELAY)
	else
		setup_door_timer("startgate_blue", 12)
		setup_door_timer("startgate_red", 12)
	end
end

function event_StopTouchingCP( entity, cp )
	return
end
	
function event_StartTouchingCP( entity, cp )
	if IsPlayer( entity ) then
		local player = CastToPlayer( entity )
		if chatbase_getplayersetting(player, "startcapsound") ~= 0 then
			BroadCastSoundToPlayer( player, "misc.woop" )
		end
	end
	return
end

function event_StartTouchingCC( entity, cc_team_number )
	return
end

function event_StopTouchingCC( entity, cc_team_number )
	return
end

function event_ChangeCPDefendingTeam( cp_number, new_defending_team )
	-- Change the skybeam and groundbeam color
	OutputEvent( "cp" .. cp_number .. "_actiondoor_" .. team_info[command_points[cp_number].defending_team].team_name, "Close")
	OutputEvent( "cp" .. cp_number .. "_actiondoor_" .. team_info[new_defending_team].team_name, "Open")
	
	-- update valid spawns
	if new_defending_team == Team.kBlue then
		cp_blue = cp_number
		if command_points[cp_number].defending_team == Team.kRed then
			cp_red = cp_number + 1
		end
	elseif new_defending_team == Team.kRed then
		cp_red = cp_number
		if command_points[cp_number].defending_team == Team.kBlue then
			cp_blue = cp_number - 1
		end
	end
end

function event_ResetTeamCPCapping( cp, team_number )
	OutputEvent( "cp" .. cp.cp_number .. "_" .. team_info[team_number].team_name .. "_beam", "TurnOff" )
end

function event_StartTeamCPCapping( cp, team_number )
	OutputEvent( "cp" .. cp.cp_number .. "_" .. team_info[team_number].team_name .. "_beam", "TurnOn" )
	local team = GetTeam(team_number)
	for i,v in pairs(chatbase_players) do
		local player = CastToPlayer(v.player)
		if IsPlayer(player) then
			if player:GetTeamId() ~= team_number then
				if chatbase_getplayersetting(player, "teamcapsound") then
					BroadCastSoundToPlayer( player, "misc.bloop" )
				end
			end
		end
	end
end


team_info = {

	[Team.kUnassigned] = {
		team_name = "neutral",
		enemy_team = Team.kUnassigned,
		objective_icon = nil,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue, AllowFlags.kRed, AllowFlags.kYellow, AllowFlags.kGreen },
		skybeam_color = "128 128 128",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 1,
		skin = "0",
		flag_visibility = "TurnOff",
		cc_touch_count = 0,
		ccalarmicon = "hud_secdown.vtf", ccalarmiconx = 0, ccalarmicony = 0, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 2,
		detcc_sentence = "HTD_DOORS",
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		}
	},

	[TEAM1] = {
		team_name = "blue",
		enemy_team = TEAM2,
		objective_icon = nil,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kBlue },
		skybeam_color = "64 64 255",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 2,
		skin = "2",
		flag_visibility = "TurnOn",
		cc_touch_count = 0,
		ccalarmicon = "hud_secup_blue.vtf", ccalarmiconx = 60, ccalarmicony = 5, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 2,
		detcc_sentence = "CZ_BCC_DET",
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		}
	},

	[TEAM2] = {
		team_name = "red",
		enemy_team = TEAM1,
		objective_icon = nil,
		touchflags = { AllowFlags.kOnlyPlayers, AllowFlags.kRed },
		skybeam_color = "255 64 64",
		respawnbeam_color = { [0] = 100, [1] = 100, [2] = 100 },
		color_index = 0,
		skin = "1",
		flag_visibility = "TurnOn",
		cc_touch_count = 0,
		ccalarmicon = "hud_secup_red.vtf", ccalarmiconx = 60, ccalarmicony = 5, ccalarmiconwidth = 16, ccalarmiconheight = 16, ccalarmiconalign = 3,
		detcc_sentence = "CZ_RCC_DET",
		class_limits = {
			[Player.kScout] = 0,
			[Player.kSniper] = 0,
			[Player.kSoldier] = 0,
			[Player.kDemoman] = 0,
			[Player.kMedic] = 0,
			[Player.kHwguy] = 0,
			[Player.kPyro] = 0,
			[Player.kSpy] = 0,
			[Player.kEngineer] = 0,
			[Player.kCivilian] = -1,
		}
	}
}


-------------------------------------------
-- Round start functions
-------------------------------------------

function setup_door_timer(doorname, duration)	
	CloseDoor(doorname)
	AddSchedule("round_opendoor_" .. doorname, duration, round_start, doorname)

	if duration > 10 then AddSchedule( "dooropen5sec" , duration - 10 , schedulemessagetoall, "Gates open in 10 seconds!" ) end
	if duration > 5 then AddSchedule( "dooropen5sec" , duration - 5 , schedulemessagetoall, "5" ) end
	if duration > 4 then AddSchedule( "dooropen4sec" , duration - 4 , schedulemessagetoall, "4" ) end
	if duration > 3 then AddSchedule( "dooropen3sec" , duration - 3, schedulemessagetoall, "3" ) end
	if duration > 2 then AddSchedule( "dooropen2sec" , duration - 2, schedulemessagetoall, "2" ) end
	if duration > 1 then AddSchedule( "dooropen1sec" , duration - 1, schedulemessagetoall, "1" ) end
	
	if duration > 5 then AddSchedule( "dooropen5seccount" , duration - 5 , schedulecountdown, 5 ) end
	if duration > 4 then AddSchedule( "dooropen4seccount" , duration - 4 , schedulecountdown, 4 ) end
	if duration > 3 then AddSchedule( "dooropen3seccount" , duration - 3 , schedulecountdown, 3 ) end
	if duration > 2 then AddSchedule( "dooropen2seccount" , duration - 2 , schedulecountdown, 2 ) end
	if duration > 1 then AddSchedule( "dooropen1seccount" , duration - 1 , schedulecountdown, 1 ) end
end

function round_start(doorname)
	BroadCastMessage("Gates are now open!")
	BroadCastSound( "otherteam.flagstolen" )
	SpeakAll( "AD_GATESOPEN" )
	
	OpenDoor(doorname)
end

function schedulemessagetoall( message )
	BroadCastMessage( message )
end

function schedulecountdown( time )
	BroadCastMessage( ""..time.."" )
	SpeakAll( "AD_" .. time .. "SEC" )
end

-----------------------------------------------------------------------------
-- bags
-----------------------------------------------------------------------------

gen_pack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 0,
	nails = 300,
	shells = 300,
	rockets = 300,
	gren1 = 0,
	gren2 = 0,
	cells = 130,
	respawntime = 10,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch"})

blue_gen_pack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 0,
	nails = 300,
	shells = 300,
	rockets = 300,
	gren1 = 1,
	gren2 = 0,
	cells = 130,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kBlue}})

red_gen_pack = genericbackpack:new({
	health = 50,
	armor = 50,
	grenades = 0,
	nails = 300,
	shells = 300,
	rockets = 300,
	gren1 = 1,
	gren2 = 0,
	cells = 130,
	respawntime = 15,
	model = "models/items/backpack/backpack.mdl",
	materializesound = "Item.Materialize",
	touchsound = "Backpack.Touch",
	touchflags = {AllowFlags.kOnlyPlayers,AllowFlags.kRed}})

-----------------------------------------------------------------------------
-- overrides
-----------------------------------------------------------------------------

-- teleporting
ENABLE_CC_TELEPORTERS = false
ENABLE_CP_TELEPORTERS = false

-- command center
ENABLE_CC = false

-- command points
CP_COUNT = 5

command_points = {
	[1] = { 
		cp_number = 1, 
		defending_team = Team.kBlue,
 		cap_requirement = { [TEAM1] = CAP_REQ_CP1_CP5, [TEAM2] = CAP_REQ_CP1_CP5 }, 
		cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, 
		cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, 
		next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, 
		delay_before_retouch = { [TEAM1] = RETOUCH_DELAY, [TEAM2] = RETOUCH_DELAY },
		touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, 
		former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, 
		point_value = { [TEAM1] = 1, [TEAM2] = 5 }, 
		score_timer_interval = { [TEAM1] = 30.00, [TEAM2] = 15.00 }, 
		hudstatusicon = "hud_cp_1.vtf", hudposx = -40, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
		
	[2] = { 
		cp_number = 2, 
		defending_team = Team.kUnassigned, 
		cap_requirement = { [TEAM1] = CAP_REQ_CP2RED_CP4BLUE, [TEAM2] = CAP_REQ_CP2BLUE_CP4RED }, 
		cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, 
		cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, 
		next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, 
		delay_before_retouch = { [TEAM1] = RETOUCH_DELAY_CP2BLUE_CP4RED, [TEAM2] = RETOUCH_DELAY_CP2RED_CP4BLUE }, 
		touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, 
		former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() },
		point_value = { [TEAM1] = 2, [TEAM2] = 4 }, 
		score_timer_interval = { [TEAM1] = 22.50, [TEAM2] = 22.50 }, 
		hudstatusicon = "hud_cp_2.vtf", hudposx = -20, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[3] = { 
		cp_number = 3, 
		defending_team = Team.kUnassigned, 
		cap_requirement = { [TEAM1] = CAP_REQ_CP3, [TEAM2] = CAP_REQ_CP3 }, 
		cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, 
		cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, 
		next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, 
		delay_before_retouch = { [TEAM1] = RETOUCH_DELAY, [TEAM2] = RETOUCH_DELAY }, 
		touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, 
		former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() },
		point_value = { [TEAM1] = 3, [TEAM2] = 3 }, 
		score_timer_interval = { [TEAM1] = 30.00, [TEAM2] = 30.00 }, 
		hudstatusicon = "hud_cp_3.vtf", hudposx =   0, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[4] = {
		cp_number = 4, 
		defending_team = Team.kUnassigned, 
		cap_requirement = { [TEAM1] = CAP_REQ_CP2BLUE_CP4RED, [TEAM2] = CAP_REQ_CP2RED_CP4BLUE },
		cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, 
		cap_speed = { [TEAM1] = 0, [TEAM2] = 0 }, 
		next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, 
		delay_before_retouch = { [TEAM1] = RETOUCH_DELAY_CP2RED_CP4BLUE, [TEAM2] = RETOUCH_DELAY_CP2BLUE_CP4RED }, 
		touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, 
		former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, 
		point_value = { [TEAM1] = 4, [TEAM2] = 2 }, 
		score_timer_interval = { [TEAM1] = 22.50, [TEAM2] = 22.50 }, 
		hudstatusicon = "hud_cp_4.vtf", hudposx =  20, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 },
	[CP_COUNT] = { 
		cp_number = 5, 
		defending_team = Team.kRed,
		cap_requirement = { [TEAM1] = CAP_REQ_CP1_CP5, [TEAM2] = CAP_REQ_CP1_CP5 },
		cap_status = { [TEAM1] = 0, [TEAM2] = 0 }, 
		cap_speed = { [TEAM1] = 0, [TEAM2] = 0 },
		next_cap_zone_timer = { [TEAM1] = 0, [TEAM2] = 0 }, 
		delay_before_retouch = { [TEAM1] = RETOUCH_DELAY, [TEAM2] = RETOUCH_DELAY }, 
		touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() }, 
		former_touching_players = { [TEAM1] = Collection(), [TEAM2] = Collection() },
		point_value = { [TEAM1] = 5, [TEAM2] = 1 }, 
		score_timer_interval = { [TEAM1] = 15.00, [TEAM2] = 30.00 }, 
		hudstatusicon = "hud_cp_5.vtf", hudposx =  40, hudposy = 56, hudalign = 4, hudwidth = 16, hudheight = 16 }
}

cap_resupply = {
	health = 100,
	armor = 300,
	nails = 400,
	shells = 400,
	cells = 400,
	grenades = 100,
	rockets = 50,
	detpacks = 0,
	mancannons = 1,
	gren1 = 2,
	gren2 = 1
}

----------------------------------------------------------------------------
-- Spawnpoints
----------------------------------------------------------------------------

-- Spawn Points
base_blue_spawn = info_ff_teamspawn:new({ cp_number = 0, validspawn = function(self,player)
	return player:GetTeamId() == Team.kBlue and self.cp_number == cp_blue
end })
base_red_spawn = info_ff_teamspawn:new({ cp_number = 0, validspawn = function(self,player)
	return player:GetTeamId() == Team.kRed and self.cp_number == cp_red
end })
bluespawn_cp1 = base_blue_spawn:new({cp_number=1})
bluespawn_cp2 = base_blue_spawn:new({cp_number=2})
bluespawn_cp3 = base_blue_spawn:new({cp_number=3})
bluespawn_cp4 = base_blue_spawn:new({cp_number=4})
redspawn_cp5 = base_red_spawn:new({cp_number=5})
redspawn_cp4 = base_red_spawn:new({cp_number=4})
redspawn_cp3 = base_red_spawn:new({cp_number=3})
redspawn_cp2 = base_red_spawn:new({cp_number=2})

-- Spawn Doors (base entity)
blue_respawn_door = trigger_ff_script:new({cp_number = 0})
red_respawn_door = trigger_ff_script:new({cp_number = 0})

-- Spawn Doors (validity checks)
function blue_respawn_door:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == Team.kBlue then --and self.cp_number <= cp_blue then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

function red_respawn_door:allowed( allowed_entity )
	if IsPlayer( allowed_entity ) then
		local player = CastToPlayer( allowed_entity )
		if player:GetTeamId() == Team.kRed then --and self.cp_number >= cp_red then
			return EVENT_ALLOWED
		end
	end
	return EVENT_DISALLOWED
end

--Spawn Doors (Validity checks failure)
function blue_respawn_door:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		--if player:GetTeamId() == Team.kBlue then
		--	BroadCastMessageToPlayer( player, "You need to capture Command Point ".. self.cp_number .. " before you can use this respawn!" )
		--else
			BroadCastMessageToPlayer( player, "Your team cannot use this respawn." )
		--end
	end
end

function red_respawn_door:onfailtouch( touch_entity )
	if IsPlayer( touch_entity ) then
		local player = CastToPlayer( touch_entity )
		--if player:GetTeamId() == Team.kRed then
		--	BroadCastMessageToPlayer( player, "You need to capture Command Point ".. self.cp_number .." before you can use this respawn!" )
		--else
			BroadCastMessageToPlayer( player, "Your team cannot use this respawn." )
		--end
	end
end


-- Spawn Doors (actual entities with command point condition attached)
bluerespawn_cp2 = blue_respawn_door:new({cp_number=2})
bluerespawn_cp3 = blue_respawn_door:new({cp_number=3})
bluerespawn_cp4 = blue_respawn_door:new({cp_number=4})
redrespawn_cp2 = red_respawn_door:new({cp_number=2})
redrespawn_cp3 = red_respawn_door:new({cp_number=3})
redrespawn_cp4 = red_respawn_door:new({cp_number=4})

-----------------------------------------------------------------------------
-- Grates
-----------------------------------------------------------------------------

detwall_trigger = trigger_ff_script:new({ team = Team.kUnassigned, team_name = "neutral" })

function detwall_trigger:onexplode( explosion_entity )
	if team == Team.kUnassigned then
		return
	end

	if IsDetpack( explosion_entity ) then
		local detpack = CastToDetpack( explosion_entity )
		-- GetTemId() might not exist for buildables, they have their own seperate shit and it might be named differently
		-- if detpack:GetTeamId() ~= self.team then -- both teams can destroy while commented out
		
		BroadCastSound( "misc.thunder" )
		
		if self.team == Team.kRed then
			if not RED_TUNNEL_WALL_BLOWN then
				OutputEvent( self.team_name .. "_detwall", "Kill" )
				BroadCastMessage("Red's tunnel has been blown!" )
				RED_TUNNEL_WALL_BLOWN = true
			else
				OutputEvent( self.team_name .. "_detwall_template", "ForceSpawn" )
				BroadCastMessage("Red's tunnel has been sealed!" )
				RED_TUNNEL_WALL_BLOWN = false
			end
		elseif self.team == Team.kBlue then
			if not BLUE_TUNNEL_WALL_BLOWN then
				OutputEvent( self.team_name .. "_detwall", "Kill" )
				BroadCastMessage("Blue's tunnel has been blown!" )
				BLUE_TUNNEL_WALL_BLOWN = true
			else
				OutputEvent( self.team_name .. "_detwall_template", "ForceSpawn" )
				BroadCastMessage("Blue's tunnel has been sealed!" )
				BLUE_TUNNEL_WALL_BLOWN = false
			end
		end
		-- end
	end
end

red_detwall_trigger = detwall_trigger:new({ team = Team.kRed, team_name = "red" })
blue_detwall_trigger = detwall_trigger:new({ team = Team.kBlue, team_name = "blue" })